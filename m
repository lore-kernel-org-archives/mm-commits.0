From: akpm@osdl.org
Subject: + pciehp-cleanup-slot-list.patch added to -mm tree
Date: Tue, 26 Dec 2006 22:56:15 -0800
Message-ID: <200612270656.kBR6uF8A003762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbWL0G4U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 01:56:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     pciehp: cleanup slot list
has been added to the -mm tree.  Its filename is
     pciehp-cleanup-slot-list.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pciehp: cleanup slot list
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Clean up slot list handling (use list_head).  This has no functional change.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/hotplug/pciehp.h      |   19 +++++++------------
 drivers/pci/hotplug/pciehp_core.c |   27 +++++++++++----------------
 2 files changed, 18 insertions(+), 28 deletions(-)

diff -puN drivers/pci/hotplug/pciehp.h~pciehp-cleanup-slot-list drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h~pciehp-cleanup-slot-list
+++ a/drivers/pci/hotplug/pciehp.h
@@ -52,7 +52,6 @@ extern int pciehp_force;
 
 #define SLOT_NAME_SIZE 10
 struct slot {
-	struct slot *next;
 	u8 bus;
 	u8 device;
 	u32 number;
@@ -99,6 +98,7 @@ struct controller {
 	int slot_num_inc;		/* 1 or -1 */
 	struct pci_dev *pci_dev;
 	struct pci_bus *pci_bus;
+	struct list_head slot_list;
 	struct event_info event_queue[MAX_EVENTS];
 	struct slot *slot;
 	struct hpc_ops *hpc_ops;
@@ -198,20 +198,15 @@ extern struct controller *pciehp_ctrl_li
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
-	struct slot *p_slot, *tmp_slot = NULL;
-
-	p_slot = ctrl->slot;
+	struct slot *slot;
 
-	while (p_slot && (p_slot->device != device)) {
-		tmp_slot = p_slot;
-		p_slot = p_slot->next;
-	}
-	if (p_slot == NULL) {
-		err("ERROR: pciehp_find_slot device=0x%x\n", device);
-		p_slot = tmp_slot;
+	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
+		if (slot->device == device)
+			return slot;
 	}
 
-	return p_slot;
+	err("%s: slot (device=0x%x) not found\n", __FUNCTION__, device);
+	return NULL;
 }
 
 static inline int wait_for_ctrl_irq(struct controller *ctrl)
diff -puN drivers/pci/hotplug/pciehp_core.c~pciehp-cleanup-slot-list drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pciehp-cleanup-slot-list
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -160,8 +160,7 @@ static int init_slots(struct controller 
 			goto error_info;
 		}
 
-		slot->next = ctrl->slot;
-		ctrl->slot = slot;
+		list_add(&slot->slot_list, &ctrl->slot_list);
 	}
 
 	return 0;
@@ -175,22 +174,17 @@ error:
 	return retval;
 }
 
-
-static int cleanup_slots (struct controller * ctrl)
+static void cleanup_slots(struct controller *ctrl)
 {
-	struct slot *old_slot, *next_slot;
-
-	old_slot = ctrl->slot;
-	ctrl->slot = NULL;
-
-	while (old_slot) {
-		next_slot = old_slot->next;
-		pci_hp_deregister (old_slot->hotplug_slot);
-		old_slot = next_slot;
+	struct list_head *tmp;
+	struct list_head *next;
+	struct slot *slot;
+
+	list_for_each_safe(tmp, next, &ctrl->slot_list) {
+		slot = list_entry(tmp, struct slot, slot_list);
+		list_del(&slot->slot_list);
+		pci_hp_deregister(slot->hotplug_slot);
 	}
-
-
-	return(0);
 }
 
 static int get_ctlr_slot_config(struct controller *ctrl)
@@ -368,6 +362,7 @@ static int pciehp_probe(struct pcie_devi
 		err("%s : out of memory\n", __FUNCTION__);
 		goto err_out_none;
 	}
+	INIT_LIST_HEAD(&ctrl->slot_list);
 
 	pdev = dev->port;
 	ctrl->pci_dev = pdev;
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

pciehp-cleanup-init_slot.patch
pciehp-cleanup-slot-list.patch
pciehp-remove-unnecessary-php_ctlr.patch
pciehp-remove-unused-pci_bus-from-struct-controller.patch
pciehp-cleanup-register-access.patch
pciehp-cleanup-pciehph.patch
pciehp-remove-unused-pcie_cap_base.patch
pciehp-cleanup-wait-command-completion.patch
pciehp-fix-wait-command-completion.patch

