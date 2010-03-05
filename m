From: akpm@linux-foundation.org
Subject: [folded] ricoh_mmc-port-from-driver-to-pci-quirk-update.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:23:15 -0800
Message-ID: <201003052123.o25LNFNU028435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414Ab0CEVYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:24:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, linux-mmc@vger.kernel.org, philipl@overt.org, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     ricoh_mmc-port-from-driver-to-pci-quirk-update
has been removed from the -mm tree.  Its filename was
     ricoh_mmc-port-from-driver-to-pci-quirk-update.patch

This patch was dropped because it was folded into ricoh_mmc-port-from-driver-to-pci-quirk.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ricoh_mmc-port-from-driver-to-pci-quirk-update
From: Maxim Levitsky <maximlevitsky@gmail.com>

This patch solves nasty problem original driver had.
Original goal of the ricoh_mmc, was to disable this device because
then, mmc cards can be read using standard SDHCI controller,
thus avoiding the need in yet another driver.
However, the act of disablement, makes other pci functions that belong to
this controller (xD and memstick) shift up one level, thus pci core has now wrong idea
about these devices.

To fix this issue, this patch moves the driver into pci quirk section, thus it
is executed before the pci is enumerated, and therefore solve that issue,
also the same is preformed on resume for same reasons.

Also regardless of the above, this way is cleaner.

You still need to set CONFIG_MMC_RICOH_MMC
to enable this quirk

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   53 +++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff -puN drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk-update drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk-update
+++ a/drivers/pci/quirks.c
@@ -2534,27 +2534,30 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 #endif	/* CONFIG_PCI_IOV */
 
 /*
- * This is a quirk for Ricoh MMC controller found as a part of
- * mulifunction chip.
+ * This is a quirk for the Ricoh MMC controller found as a part of
+ * some mulifunction chips.
 
- * This is very similiar and based on ricoh_mmc driver
- * written by Philip Langdale. Thank you for these magic sequencies.
-
- * These chips implement the four main memory card
- * controllers (SD, MMC, MS, xD) and one or both
- * of cardbus or firewire. It happens that they implement SD and MMC
+ * This is very similiar and based on the ricoh_mmc driver written by
+ * Philip Langdale. Thank you for these magic sequences.
+ *
+ * These chips implement the four main memory card controllers (SD, MMC, MS, xD)
+ * and one or both of cardbus or firewire.
+ *
+ * It happens that they implement SD and MMC
  * support as separate controllers (and PCI functions). The linux SDHCI
  * driver supports MMC cards but the chip detects MMC cards in hardware
  * and directs them to the MMC controller - so the SDHCI driver never sees
- * them. To get around this, we must disable the useless MMC controller.
+ * them.
+ *
+ * To get around this, we must disable the useless MMC controller.
  * At that point, the SDHCI controller will start seeing them
  * It seems to be the case that the relevant PCI registers to deactivate the
  * MMC controller live on PCI function 0, which might be the cardbus controller
  * or the firewire controller, depending on the particular chip in question
-
+ *
  * This has to be done early, because as soon as we disable the MMC controller
- * other pci functions shift up one level, e.g. function #2 becames function
- * #1, and therefore is confusing the pci core.
+ * other pci functions shift up one level, e.g. function #2 becomes function
+ * #1, and this will confuse the pci core.
  */
 
 #ifdef CONFIG_MMC_RICOH_MMC
@@ -2581,9 +2584,11 @@ static void ricoh_mmc_fixup_rl5c476(stru
 	pci_write_config_byte(dev, 0x8E, write_enable);
 	pci_write_config_byte(dev, 0x8D, write_target);
 
-	printk(KERN_NOTICE "pci: Ricoh MMC controller disabled\n");
-	printk(KERN_NOTICE "pci: mmc cards will be supported through SDHCI\n");
+	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via cardbus function)\n");
+	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
 }
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476, ricoh_mmc_fixup_rl5c476);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476, ricoh_mmc_fixup_rl5c476);
 
 static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
 {
@@ -2605,23 +2610,11 @@ static void ricoh_mmc_fixup_r5c832(struc
 	pci_write_config_byte(dev, 0xCB, disable | 0x02);
 	pci_write_config_byte(dev, 0xCA, write_enable);
 
-	printk(KERN_NOTICE "pci: Ricoh MMC controller disabled\n");
-	printk(KERN_NOTICE "pci: mmc cards will be supported through SDHCI\n");
+	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
+	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
 }
-
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
-	ricoh_mmc_fixup_rl5c476);
-
-DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
-	ricoh_mmc_fixup_rl5c476);
-
-
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
-	ricoh_mmc_fixup_r5c832);
-
-DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
-	ricoh_mmc_fixup_r5c832);
