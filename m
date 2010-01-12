From: akpm@linux-foundation.org
Subject: [folded] ricoh_mmc-port-from-driver-to-pci-quirk-update.patch removed from -mm tree
Date: Tue, 12 Jan 2010 15:42:51 -0800
Message-ID: <201001122342.o0CNgpmd002539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab0ALXnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 18:43:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, linux-mmc@vger.kernel.org, philipl@overt.org, mm-commits@vger.kernel.org


The patch titled
     ricoh_mmc-port-from-driver-to-pci-quirk update
has been removed from the -mm tree.  Its filename was
     ricoh_mmc-port-from-driver-to-pci-quirk-update.patch

This patch was dropped because it was folded into ricoh_mmc-port-from-driver-to-pci-quirk.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ricoh_mmc-port-from-driver-to-pci-quirk update
From: Maxim Levitsky <maximlevitsky@gmail.com>

This patch solves nasty problem original driver has.
Original goal of the ricoh_mmc was to disable this device because
then, mmc cards can be read using standard SDHCI controller,
thus avoiding writing of yet another driver.
However, the act of disablement, makes other pci functions that belong to
this controller (xD and memstick) shift up one level, thus pci core has now wrong idea
about these devices.

To fix this issue, this patch moves the driver into pci quirk section, thus it
is executes before the pci is enumerated, and therefore solving that issue,
also same sequence of commands is performed on resume for same reasons.

Also regardless of the above, this way is cleaner.

You still need to set CONFIG_MMC_RICOH_MMC
to enable this quirk

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig |   13 +++++++++++++
 drivers/pci/quirks.c     |   21 ++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/Kconfig~ricoh_mmc-port-from-driver-to-pci-quirk-update drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~ricoh_mmc-port-from-driver-to-pci-quirk-update
+++ a/drivers/mmc/host/Kconfig
@@ -55,6 +55,19 @@ config MMC_SDHCI_PCI
 
 	  If unsure, say N.
 
+config MMC_RICOH_MMC
+	bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
+	depends on MMC_SDHCI_PCI
+	help
+	  This adds a pci quirk to disable Ricoh MMC Controller. This
+	  proprietary controller is unnecessary because the SDHCI driver
+	  supports MMC cards on the SD controller, but if it is not
+	  disabled, it will steal the MMC cards away - rendering them
+	  useless. It is safe to select this even if you don't
+	  have a Ricoh based card reader.
+
+	  If unsure, say Y.
+
 config MMC_SDHCI_OF
 	tristate "SDHCI support on OpenFirmware platforms"
 	depends on MMC_SDHCI && PPC_OF
diff -puN drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk-update drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk-update
+++ a/drivers/pci/quirks.c
@@ -2522,9 +2522,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 
 /*
  * This is a quirk for Ricoh MMC controller found as a part of
- * multifunction chip.
- * It is very similiar and based on ricoh_mmc driver written by Philip Langdale
- * Thanks for these magic sequences.
+ * mulifunction chip.
+
+ * This is very similiar and based on ricoh_mmc driver
+ * written by Philip Langdale. Thank you for these magic sequencies.
+
  * These chips implement the four main memory card
  * controllers (SD, MMC, MS, xD) and one or both
  * of cardbus or firewire. It happens that they implement SD and MMC
@@ -2536,8 +2538,13 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  * It seems to be the case that the relevant PCI registers to deactivate the
  * MMC controller live on PCI function 0, which might be the cardbus controller
  * or the firewire controller, depending on the particular chip in question
+
+ * This has to be done early, because as soon as we disable the MMC controller
+ * other pci functions shift up one level, e.g. function #2 becames function
+ * #1, and therefore is confusing the pci core.
  */
 
+#ifdef CONFIG_MMC_RICOH_MMC
 static void ricoh_mmc_fixup_rl5c476(struct pci_dev *dev)
 {
 	/* disable via cardbus interface */
@@ -2560,6 +2567,9 @@ static void ricoh_mmc_fixup_rl5c476(stru
 	pci_write_config_byte(dev, 0xB7, disable | 0x02);
 	pci_write_config_byte(dev, 0x8E, write_enable);
 	pci_write_config_byte(dev, 0x8D, write_target);
+
+	printk(KERN_NOTICE "pci: Ricoh MMC controller disabled\n");
+	printk(KERN_NOTICE "pci: mmc cards will be supported through SDHCI\n");
 }
 
 static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
@@ -2581,6 +2591,9 @@ static void ricoh_mmc_fixup_r5c832(struc
 	pci_write_config_byte(dev, 0xCA, 0x57);
 	pci_write_config_byte(dev, 0xCB, disable | 0x02);
 	pci_write_config_byte(dev, 0xCA, write_enable);
+
+	printk(KERN_NOTICE "pci: Ricoh MMC controller disabled\n");
+	printk(KERN_NOTICE "pci: mmc cards will be supported through SDHCI\n");
 }
 
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
@@ -2596,6 +2609,8 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RI
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
 	ricoh_mmc_fixup_r5c832);
 
+#endif /*CONFIG_MMC_RICOH_MMC*/
+
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
ricoh_mmc-port-from-driver-to-pci-quirk.patch
ricoh_mmc-port-from-driver-to-pci-quirk-update.patch

