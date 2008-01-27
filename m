From: akpm@linux-foundation.org
Subject: + fix-fakephp-deadlock.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:10:40 -0800
Message-ID: <200801270510.m0R5AbQ3030807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbYA0FKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:10:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: abbotti@mev.co.uk, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     Fix fakephp deadlock
has been added to the -mm tree.  Its filename is
     fix-fakephp-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix fakephp deadlock
From: Ian Abbott <abbotti@mev.co.uk>

If the fakephp driver is used to emulate removal of a PCI device by writing
text string "0" to the "power" sysfs attribute file, this causes its parent
directory and its contents (including the "power" file) to be deleted
before the write operation returns.  Unfortunately, it ends up in a
deadlock waiting for itself to complete.

The deadlock is as follows: sysfs_write_file calls flush_write_buffer which
calls sysfs_get_active_two before calling power_write_file in
pci_hotplug_core.c via the sysfs store operation.  The power_write_file
function calls disable_slot in fakephp.c via the slot operation.  The
disable_slot function calls remove_slot which calls pci_hp_deregister (back
in pci_hotplug_core.c) which calls fs_remove_slot which calls
sysfs_remove_file to remove the "power" file.  The sysfs_remove_file
function calls sysfs_hash_and_remove which calls sysfs_addrm_finish which
calls sysfs_deactivate.  The sysfs_deactivate function sees that something
has an active reference on the sysfs_dirent (from the previous call to
sysfs_get_active_two back up the call stack somewhere) so waits for the
active reference to go away, which is of course impossible.

The problem has been present since 2.6.21.

This patch breaks the deadlock by queuing work queue items on a single-
threaded work queue to remove a slot from sysfs, and to rescan the PCI
buses.  There is also some protection against disabling a slot that is
already being removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/fakephp.c |   39 ++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff -puN drivers/pci/hotplug/fakephp.c~fix-fakephp-deadlock drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c~fix-fakephp-deadlock
+++ a/drivers/pci/hotplug/fakephp.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 #include "../pci.h"
 
 #if !defined(MODULE)
@@ -63,10 +64,16 @@ struct dummy_slot {
 	struct list_head node;
 	struct hotplug_slot *slot;
 	struct pci_dev *dev;
+	struct work_struct remove_work;
+	unsigned long removed;
 };
 
 static int debug;
 static LIST_HEAD(slot_list);
+static struct workqueue_struct *dummyphp_wq;
+
+static void pci_rescan_worker(struct work_struct *work);
+static DECLARE_WORK(pci_rescan_work, pci_rescan_worker);
 
 static int enable_slot (struct hotplug_slot *slot);
 static int disable_slot (struct hotplug_slot *slot);
@@ -109,7 +116,7 @@ static int add_slot(struct pci_dev *dev)
 	slot->name = &dev->dev.bus_id[0];
 	dbg("slot->name = %s\n", slot->name);
 
-	dslot = kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
+	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
 		goto error_info;
 
@@ -164,6 +171,14 @@ static void remove_slot(struct dummy_slo
 		err("Problem unregistering a slot %s\n", dslot->slot->name);
 }
 
+/* called from the single-threaded workqueue handler to remove a slot */
+static void remove_slot_worker(struct work_struct *work)
+{
+	struct dummy_slot *dslot =
+		container_of(work, struct dummy_slot, remove_work);
+	remove_slot(dslot);
+}
+
 /**
  * pci_rescan_slot - Rescan slot
  * @temp: Device template. Should be set: bus and devfn.
@@ -267,11 +282,17 @@ static inline void pci_rescan(void) {
 	pci_rescan_buses(&pci_root_buses);
 }
 
+/* called from the single-threaded workqueue handler to rescan all pci buses */
+static void pci_rescan_worker(struct work_struct *work)
+{
+	pci_rescan();
+}
 
 static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	/* mis-use enable_slot for rescanning of the pci bus */
-	pci_rescan();
+	cancel_work_sync(&pci_rescan_work);
+	queue_work(dummyphp_wq, &pci_rescan_work);
 	return -ENODEV;
 }
 
@@ -306,6 +327,10 @@ static int disable_slot(struct hotplug_s
 		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
 		return -ENODEV;
 	}
+	if (test_and_set_bit(0, &dslot->removed)) {
+		dbg("Slot already scheduled for removal\n");
+		return -ENODEV;
+	}
 	/* search for subfunctions and disable them first */
 	if (!(dslot->dev->devfn & 7)) {
 		for (func = 1; func < 8; func++) {
@@ -328,8 +353,9 @@ static int disable_slot(struct hotplug_s
 	/* remove the device from the pci core */
 	pci_remove_bus_device(dslot->dev);
 
-	/* blow away this sysfs entry and other parts. */
-	remove_slot(dslot);
+	/* queue work item to blow away this sysfs entry and other parts. */
+	INIT_WORK(&dslot->remove_work, remove_slot_worker);
+	queue_work(dummyphp_wq, &dslot->remove_work);
 
 	return 0;
 }
@@ -340,6 +366,7 @@ static void cleanup_slots (void)
 	struct list_head *next;
 	struct dummy_slot *dslot;
 
+	destroy_workqueue(dummyphp_wq);
 	list_for_each_safe (tmp, next, &slot_list) {
 		dslot = list_entry (tmp, struct dummy_slot, node);
 		remove_slot(dslot);
@@ -351,6 +378,10 @@ static int __init dummyphp_init(void)
 {
 	info(DRIVER_DESC "\n");
 
+	dummyphp_wq = create_singlethread_workqueue(MY_NAME);
+	if (!dummyphp_wq)
+		return -ENOMEM;
+
 	return pci_scan_buses();
 }
 
_

Patches currently in -mm which might be from abbotti@mev.co.uk are

fix-fakephp-deadlock.patch
