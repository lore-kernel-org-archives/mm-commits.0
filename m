From: akpm@linux-foundation.org
Subject: - pci-x-pci-express-read-control-interfaces-qla2xxx.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:30:22 -0700
Message-ID: <200707201930.l6KJUM2C012492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933271AbXGTTbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oruba@amd.com, andrew.vasquez@qlogic.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     PCI-X/PCI-Express read control interfaces: use them in qla2xxx
has been removed from the -mm tree.  Its filename was
     pci-x-pci-express-read-control-interfaces-qla2xxx.patch

This patch was dropped because changes in git-scsi-misc wrecked it

------------------------------------------------------
Subject: PCI-X/PCI-Express read control interfaces: use them in qla2xxx
From: "Peter Oruba" <peter.oruba@amd.com>

These driver changes incorporate the proposed PCI-X / PCI-Express read byte
count interface.  Reading and setting those valuse doesn't take place
"manually", instead wrapping functions are called to allow quirks for some
PCI bridges.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on work by Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_init.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_init.c~pci-x-pci-express-read-control-interfaces-qla2xxx drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~pci-x-pci-express-read-control-interfaces-qla2xxx
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -269,27 +269,15 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 
 	/* PCI-X -- adjust Maximum Memory Read Byte Count (2048). */
 	pcix_cmd_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_PCIX);
-	if (pcix_cmd_reg) {
-		uint16_t pcix_cmd;
-
-		pcix_cmd_reg += PCI_X_CMD;
-		pci_read_config_word(ha->pdev, pcix_cmd_reg, &pcix_cmd);
-		pcix_cmd &= ~PCI_X_CMD_MAX_READ;
-		pcix_cmd |= 0x0008;
-		pci_write_config_word(ha->pdev, pcix_cmd_reg, pcix_cmd);
-	}
+	if (pcix_cmd_reg)
+		if (pcix_set_mmrbc(ha->pdev, 2048))
+		DEBUG2(printk("Couldn't write PCI-X read request\n"));
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
 	pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	if (pcie_dctl_reg) {
-		uint16_t pcie_dctl;
-
-		pcie_dctl_reg += PCI_EXP_DEVCTL;
-		pci_read_config_word(ha->pdev, pcie_dctl_reg, &pcie_dctl);
-		pcie_dctl &= ~PCI_EXP_DEVCTL_READRQ;
-		pcie_dctl |= 0x4000;
-		pci_write_config_word(ha->pdev, pcie_dctl_reg, pcie_dctl);
-	}
+	if (pcie_dctl_reg)
+	if (pcie_set_readrq(ha->pdev, 2048))
+		DEBUG2(printk("Couldn't write PCI Express read request\n"));
 
 	/* Reset expansion ROM address decode enable */
 	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
_

Patches currently in -mm which might be from peter.oruba@amd.com are

origin.patch
git-scsi-misc.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
