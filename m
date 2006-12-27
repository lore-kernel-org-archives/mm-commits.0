From: akpm@osdl.org
Subject: + pciehp-remove-unused-pci_bus-from-struct-controller.patch added to -mm tree
Date: Tue, 26 Dec 2006 22:56:19 -0800
Message-ID: <200612270656.kBR6uJnS003768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbWL0G4X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 01:56:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     pciehp: remove unused pci_bus from struct controller
has been added to the -mm tree.  Its filename is
     pciehp-remove-unused-pci_bus-from-struct-controller.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pciehp: remove unused pci_bus from struct controller
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Remove unused pci_bus member from struct controller.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/hotplug/pciehp.h      |    1 -
 drivers/pci/hotplug/pciehp_core.c |   14 ++------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/pci/hotplug/pciehp.h~pciehp-remove-unused-pci_bus-from-struct-controller drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h~pciehp-remove-unused-pci_bus-from-struct-controller
+++ a/drivers/pci/hotplug/pciehp.h
@@ -78,7 +78,6 @@ struct controller {
 	int num_slots;			/* Number of slots on ctlr */
 	int slot_num_inc;		/* 1 or -1 */
 	struct pci_dev *pci_dev;
-	struct pci_bus *pci_bus;
 	struct list_head slot_list;
 	struct event_info event_queue[MAX_EVENTS];
 	struct slot *slot;
diff -puN drivers/pci/hotplug/pciehp_core.c~pciehp-remove-unused-pci_bus-from-struct-controller drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pciehp-remove-unused-pci_bus-from-struct-controller
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -346,13 +346,6 @@ static int pciehp_probe(struct pcie_devi
 
 	pci_set_drvdata(pdev, ctrl);
 
-	ctrl->pci_bus = kmalloc(sizeof(*ctrl->pci_bus), GFP_KERNEL);
-	if (!ctrl->pci_bus) {
-		err("%s: out of memory\n", __FUNCTION__);
-		rc = -ENOMEM;
-		goto err_out_unmap_mmio_region;
-	}
-	memcpy (ctrl->pci_bus, pdev->bus, sizeof (*ctrl->pci_bus));
 	ctrl->bus = pdev->bus->number;  /* ctrl bus */
 	ctrl->slot_bus = pdev->subordinate->number;  /* bus controlled by this HPC */
 
@@ -365,7 +358,7 @@ static int pciehp_probe(struct pcie_devi
 	rc = init_slots(ctrl);
 	if (rc) {
 		err(msg_initialization_err, 6);
-		goto err_out_free_ctrl_slot;
+		goto err_out_release_ctlr;
 	}
 
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
@@ -404,8 +397,7 @@ static int pciehp_probe(struct pcie_devi
 
 err_out_free_ctrl_slot:
 	cleanup_slots(ctrl);
-	kfree(ctrl->pci_bus);
-err_out_unmap_mmio_region:
+err_out_release_ctlr:
 	ctrl->hpc_ops->release_ctlr(ctrl);
 err_out_free_ctrl:
 	kfree(ctrl);
@@ -439,8 +431,6 @@ static void __exit unload_pciehpd(void)
 	while (ctrl) {
 		cleanup_slots(ctrl);
 
-		kfree (ctrl->pci_bus);
-
 		ctrl->hpc_ops->release_ctlr(ctrl);
 
 		tctrl = ctrl;
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

