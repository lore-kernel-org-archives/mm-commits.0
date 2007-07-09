From: akpm@linux-foundation.org
Subject: - pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:24:37 -0700
Message-ID: <200707092024.l69KOclB009149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34674 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbXGIUZY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:25:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oruba@amd.com, andrew.vasquez@qlogic.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     pci-x-pci-express-read-control-interfaces-qla2xxx fix
has been removed from the -mm tree.  Its filename was
     pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch

This patch was dropped because it was folded into pci-x-pci-express-read-control-interfaces-qla2xxx.patch

------------------------------------------------------
Subject: pci-x-pci-express-read-control-interfaces-qla2xxx fix
From: "Peter Oruba" <peter.oruba@amd.com>

Sorry, I missed out an essential part in the qla2xxx driver, namely the MMRBC
configuration for PCI-X. The submitted patch only did that for PCIe. This is
the corrected version

The pre-condition check is there to not blindly call the mmrbc-functions, but
to check for the bus type first. Indeed, the first patch version made this
check look unnecessary.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_init.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_init.c~pci-x-pci-express-read-control-interfaces-qla2xxx-fix drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~pci-x-pci-express-read-control-interfaces-qla2xxx-fix
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -269,21 +269,15 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 
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
 	if (pcie_dctl_reg)
-		if (pcie_set_readrq(ha->pdev, 2048))
-			DEBUG2(printk("Couldn't write PCI Express read request\n"));
+	if (pcie_set_readrq(ha->pdev, 2048))
+		DEBUG2(printk("Couldn't write PCI Express read request\n"));
 
 	/* Reset expansion ROM address decode enable */
 	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
_

Patches currently in -mm which might be from peter.oruba@amd.com are

bugfix-cpufreq-in-combination-with-performance-governor.patch
pci-x-pci-express-read-control-interfaces-fix.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch
