From: akpm@linux-foundation.org
Subject: + pci-x-pci-express-read-control-interfaces-qla2xxx.patch added to -mm tree
Date: Tue, 15 May 2007 12:39:45 -0700
Message-ID: <200705151939.l4FJdjeN015959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759364AbXEOTkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oruba@amd.com, andrew.vasquez@qlogic.com, shemminger@linux-foundation.org


The patch titled
     PCI-X/PCI-Express read control interfaces: use them in qla2xxx
has been added to the -mm tree.  Its filename is
     pci-x-pci-express-read-control-interfaces-qla2xxx.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/scsi/qla2xxx/qla_init.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_init.c~pci-x-pci-express-read-control-interfaces-qla2xxx drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~pci-x-pci-express-read-control-interfaces-qla2xxx
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -281,15 +281,9 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 
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
+		if (pcie_set_readrq(ha->pdev, 2048))
+			DEBUG2(printk("Couldn't write PCI Express read request\n"));
 
 	/* Reset expansion ROM address decode enable */
 	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
_

Patches currently in -mm which might be from peter.oruba@amd.com are

pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces.patch
pci-x-pci-express-read-control-interfaces-fix.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
