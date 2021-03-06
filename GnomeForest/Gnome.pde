abstract class Gnome extends Occupier {

  final int grabAmount = 40;

  public Gnome(ForestSpace space) {
    contents = new Material(MaterialType.FOOD,0);
    capacity = 300;
    position = space;
    spawn();
  }

  //  Gnomes do *something* every frame.
  abstract void jiggle();
  
  
  //  Gnomes can pick materials up from the position they're standing in.
  final void grabContents() {
    if (position.contents==null) return;
    if (position.contents.quantity==0) {
      position.contents=null;
      return;
    }
    //  Carrying nothing
    if (contents==null) contents = new Material(position.contents.type, 0);
    //  Already carrying something else
    if (contents.type!=position.contents.type) return;
    // Form demand
    int demand = capacity-contents.quantity;
    if (demand<=0) return;
    if (demand>grabAmount) demand=grabAmount;
    if (demand<position.contents.quantity) {
      contents.quantity+=grabAmount;
      position.contents.quantity-=grabAmount;
    } else {
      contents.quantity+=position.contents.quantity;
      position.contents=null;
    }
  }

  final void giveMaterial(Occupier other) {
    int otherDesire = other.capacity-other.contents.quantity;
    if (otherDesire<=0) return;
    if (contents.quantity>=otherDesire) {
      other.contents.quantity += otherDesire;
      contents.quantity -= otherDesire;
    } else {
      other.contents.quantity+=contents.quantity;
      contents.quantity=0;
    }
    updateAppearance();
    other.updateAppearance();
  }

  final void moveTo(ForestSpace target) {
    if(target.occupant==null) {
      position.occupant = null;
      position = target;
      position.occupant = this;
    }
  }
}
