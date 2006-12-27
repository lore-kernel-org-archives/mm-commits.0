From: akpm@osdl.org
Subject: + pciehp-remove-unused-pcie_cap_base.patch added to -mm tree
Date: Tue, 26 Dec 2006 22:56:25 -0800
Message-ID: <200612270656.kBR6uP8j003777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbWL0G4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 01:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     pciehp: remove unused pcie_cap_base
has been added to the -mm tree.  Its filename is
     pciehp-remove-unused-pcie_cap_base.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pciehp-cleanup-init_slot.patch
pciehp-cleanup-slot-list.patch
pciehp-remove-unnecessary-php_ctlr.patch
pciehp-remove-unused-pci_bus-from-struct-controller.patch
pciehp-cleanup-register-access.patch
pciehp-cleanup-pciehph.patch
pciehp-remove-unused-pcie_cap_base.patch
pciehp-cleanup-wait-command-completion.patch
pciehp-fix-wait-command-completion.patch

