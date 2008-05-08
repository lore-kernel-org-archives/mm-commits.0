From: akpm@linux-foundation.org
Subject: - pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch removed from -mm tree
Date: Thu, 08 May 2008 12:10:10 -0700
Message-ID: <200805081910.m48JAA51001055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757613AbYEHTLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, greg@kroah.com, kaneshige.kenji@jp.fujitsu.com, kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     pci hotplug: construct one fakephp slot per pci slot
has been removed from the -mm tree.  Its filename was
     pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch

This patch was dropped because linux-next changes broke it a bit

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci hotplug: construct one fakephp slot per pci slot
From: Alex Chiang <achiang@hp.com>

Register one slot per slot, rather than one slot per function.  Change the
name of the slot to fake%d instead of the pci address.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/fakephp.c |   85 +++++++++++---------------------
 1 file changed, 30 insertions(+), 55 deletions(-)

diff -puN drivers/pci/hotplug/fakephp.c~pci-hotplug-construct-one-fakephp-slot-per-pci-slot drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c~pci-hotplug-construct-one-fakephp-slot-per-pci-slot
+++ a/drivers/pci/hotplug/fakephp.c
@@ -66,6 +66,7 @@ struct dummy_slot {
 	struct pci_dev *dev;
 	struct work_struct remove_work;
 	unsigned long removed;
+	char name[8];
 };
 
 static int debug;
@@ -100,6 +101,7 @@ static int add_slot(struct pci_dev *dev)
 	struct dummy_slot *dslot;
 	struct hotplug_slot *slot;
 	int retval = -ENOMEM;
+	static int count = 1;
 
 	slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
 	if (!slot)
@@ -113,13 +115,14 @@ static int add_slot(struct pci_dev *dev)
 	slot->info->max_bus_speed = PCI_SPEED_UNKNOWN;
 	slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
 
-	slot->name = &dev->dev.bus_id[0];
-	dbg("slot->name = %s\n", slot->name);
-
 	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
 		goto error_info;
 
+	slot->name = dslot->name;
+	snprintf(slot->name, sizeof(dslot->name), "fake%d", count++);
+	dbg("slot->name = %s\n", slot->name);
+
 	slot->ops = &dummy_hotplug_slot_ops;
 	slot->release = &dummy_release;
 	slot->private = dslot;
@@ -148,17 +151,17 @@ error:
 static int __init pci_scan_buses(void)
 {
 	struct pci_dev *dev = NULL;
-	int retval = 0;
+	int lastslot = 0;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		retval = add_slot(dev);
-		if (retval) {
-			pci_dev_put(dev);
-			break;
-		}
+		if (PCI_FUNC(dev->devfn) > 0 &&
+				lastslot == PCI_SLOT(dev->devfn))
+			continue;
+		lastslot = PCI_SLOT(dev->devfn);
+		add_slot(dev);
 	}
 
-	return retval;
+	return 0;
 }
 
 static void remove_slot(struct dummy_slot *dslot)
@@ -296,23 +299,9 @@ static int enable_slot(struct hotplug_sl
 	return 0;
 }
 
-/* find the hotplug_slot for the pci_dev */
-static struct hotplug_slot *get_slot_from_dev(struct pci_dev *dev)
-{
-	struct dummy_slot *dslot;
-
-	list_for_each_entry(dslot, &slot_list, node) {
-		if (dslot->dev == dev)
-			return dslot->slot;
-	}
-	return NULL;
-}
-
-
 static int disable_slot(struct hotplug_slot *slot)
 {
 	struct dummy_slot *dslot;
-	struct hotplug_slot *hslot;
 	struct pci_dev *dev;
 	int func;
 
@@ -322,41 +311,27 @@ static int disable_slot(struct hotplug_s
 
 	dbg("%s - physical_slot = %s\n", __func__, slot->name);
 
-	/* don't disable bridged devices just yet, we can't handle them easily... */
-	if (dslot->dev->subordinate) {
-		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
-		return -ENODEV;
-	}
-	if (test_and_set_bit(0, &dslot->removed)) {
-		dbg("Slot already scheduled for removal\n");
-		return -ENODEV;
-	}
-	/* search for subfunctions and disable them first */
-	if (!(dslot->dev->devfn & 7)) {
-		for (func = 1; func < 8; func++) {
-			dev = pci_get_slot(dslot->dev->bus,
-					dslot->dev->devfn + func);
-			if (dev) {
-				hslot = get_slot_from_dev(dev);
-				if (hslot)
-					disable_slot(hslot);
-				else {
-					err("Hotplug slot not found for subfunction of PCI device\n");
-					return -ENODEV;
-				}
-				pci_dev_put(dev);
-			} else
-				dbg("No device in slot found\n");
+	for (func = 7; func >= 0; func--) {
+		dev = pci_get_slot(dslot->dev->bus, dslot->dev->devfn + func);
+		if (!dev)
+			continue;
+
+		if (test_and_set_bit(0, &dslot->removed)) {
+			dbg("Slot already scheduled for removal\n");
+			return -ENODEV;
 		}
-	}
 
-	/* remove the device from the pci core */
-	pci_remove_bus_device(dslot->dev);
+		/* queue work item to blow away this sysfs entry and other
+		 * parts.
+		 */
+		INIT_WORK(&dslot->remove_work, remove_slot_worker);
+		queue_work(dummyphp_wq, &dslot->remove_work);
 
-	/* queue work item to blow away this sysfs entry and other parts. */
-	INIT_WORK(&dslot->remove_work, remove_slot_worker);
-	queue_work(dummyphp_wq, &dslot->remove_work);
+		/* blow away this sysfs entry and other parts. */
+		remove_slot(dslot);
 
+		pci_dev_put(dev);
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from achiang@hp.com are

pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch
pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch

