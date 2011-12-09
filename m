From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-modify-pcie-capability-settings.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:51 -0800
Message-ID: <201112092008.pB9K8pZH014915@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:36507 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809Ab1LIUIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:55 -0500
Received: by lahj13 with SMTP id j13so67691lah.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: modify PCIe capability settings
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-modify-pcie-capability-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: modify PCIe capability settings

Modify initialization of PCIe capability registers in Tsi721 mport driver:
- change Completion Timeout value to avoid unexpected data transfer aborts
  during intensive traffic.
- replace hardcoded offset of PCIe capability block by getting it using
  the common function.

This patch is applicable to kernel versions starting from 3.2-rc1.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   20 +++++++++++++++-----
 drivers/rapidio/devices/tsi721.h |    2 ++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-modify-pcie-capability-settings drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-modify-pcie-capability-settings
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2154,7 +2154,7 @@ static int __devinit tsi721_probe(struct
 				  const struct pci_device_id *id)
 {
 	struct tsi721_device *priv;
-	int i;
+	int i, cap;
 	int err;
 	u32 regval;
 
@@ -2262,10 +2262,20 @@ static int __devinit tsi721_probe(struct
 			dev_info(&pdev->dev, "Unable to set consistent DMA mask\n");
 	}
 
-	/* Clear "no snoop" and "relaxed ordering" bits. */
-	pci_read_config_dword(pdev, 0x40 + PCI_EXP_DEVCTL, &regval);
-	regval &= ~(PCI_EXP_DEVCTL_RELAX_EN | PCI_EXP_DEVCTL_NOSNOOP_EN);
-	pci_write_config_dword(pdev, 0x40 + PCI_EXP_DEVCTL, regval);
+	cap = pci_pcie_cap(pdev);
+	BUG_ON(cap == 0);
+
+	/* Clear "no snoop" and "relaxed ordering" bits, use default MRRS. */
+	pci_read_config_dword(pdev, cap + PCI_EXP_DEVCTL, &regval);
+	regval &= ~(PCI_EXP_DEVCTL_READRQ | PCI_EXP_DEVCTL_RELAX_EN |
+		    PCI_EXP_DEVCTL_NOSNOOP_EN);
+	regval |= 0x2 << MAX_READ_REQUEST_SZ_SHIFT;
+	pci_write_config_dword(pdev, cap + PCI_EXP_DEVCTL, regval);
+
+	/* Adjust PCIe completion timeout. */
+	pci_read_config_dword(pdev, cap + PCI_EXP_DEVCTL2, &regval);
+	regval &= ~(0x0f);
+	pci_write_config_dword(pdev, cap + PCI_EXP_DEVCTL2, regval | 0x2);
 
 	/*
 	 * FIXUP: correct offsets of MSI-X tables in the MSI-X Capability Block
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-modify-pcie-capability-settings drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-modify-pcie-capability-settings
+++ a/drivers/rapidio/devices/tsi721.h
@@ -72,6 +72,8 @@
 #define TSI721_MSIXPBA_OFFSET	0x2a000
 #define TSI721_PCIECFG_EPCTL	0x400
 
+#define MAX_READ_REQUEST_SZ_SHIFT	12
+
 /*
  * Event Management Registers
  */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
linux-next.patch

