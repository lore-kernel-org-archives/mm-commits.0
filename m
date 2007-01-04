From: akpm@osdl.org
Subject: - pciehp-remove-unused-pcie_cap_base.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:03 -0800
Message-ID: <200701042343.l04Nh3Q3002866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36799 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030264AbXADXnH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pciehp: remove unused pcie_cap_base
has been removed from the -mm tree.  Its filename was
     pciehp-remove-unused-pcie_cap_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pciehp: remove unused pcie_cap_base
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Remove unused pcie_cap_base variable.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/hotplug/pciehp_hpc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_hpc.c~pciehp-remove-unused-pcie_cap_base drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~pciehp-remove-unused-pcie_cap_base
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -105,7 +105,6 @@ enum ctrl_offsets {
 	ROOTCTRL	=	offsetof(struct ctrl_reg, root_ctrl),
 	ROOTSTATUS	=	offsetof(struct ctrl_reg, root_status),
 };
-static int pcie_cap_base = 0;		/* Base of the PCI Express capability item structure */ 
 
 static inline int pciehp_readw(struct controller *ctrl, int reg, u16 *value)
 {
@@ -1072,7 +1071,7 @@ int pcie_init(struct controller * ctrl, 
 	u16 cap_reg;
 	u16 intr_enable = 0;
 	u32 slot_cap;
-	int cap_base, saved_cap_base;
+	int cap_base;
 	u16 slot_status, slot_ctrl;
 	struct pci_dev *pdev;
 
@@ -1084,8 +1083,6 @@ int pcie_init(struct controller * ctrl, 
 	dbg("%s: hotplug controller vendor id 0x%x device id 0x%x\n",
 			__FUNCTION__, pdev->vendor, pdev->device);
 
-	saved_cap_base = pcie_cap_base;
-
 	if ((cap_base = pci_find_capability(pdev, PCI_CAP_ID_EXP)) == 0) {
 		dbg("%s: Can't find PCI_CAP_ID_EXP (0x10)\n", __FUNCTION__);
 		goto abort_free_ctlr;
@@ -1093,7 +1090,7 @@ int pcie_init(struct controller * ctrl, 
 
 	ctrl->cap_base = cap_base;
 
-	dbg("%s: pcie_cap_base %x\n", __FUNCTION__, pcie_cap_base);
+	dbg("%s: pcie_cap_base %x\n", __FUNCTION__, cap_base);
 
 	rc = pciehp_readw(ctrl, CAPREG, &cap_reg);
 	if (rc) {
@@ -1289,8 +1286,6 @@ abort_free_irq:
 		free_irq(ctrl->pci_dev->irq, ctrl);
 
 abort_free_ctlr:
-	pcie_cap_base = saved_cap_base;
-
 	DBG_LEAVE_ROUTINE
 	return -1;
 }
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are
