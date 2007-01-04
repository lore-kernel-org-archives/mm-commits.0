From: akpm@osdl.org
Subject: - pciehp-remove-unused-pci_bus-from-struct-controller.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:42:57 -0800
Message-ID: <200701042342.l04NgvFc002855@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXADXnD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pciehp: remove unused pci_bus from struct controller
has been removed from the -mm tree.  Its filename was
     pciehp-remove-unused-pci_bus-from-struct-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
