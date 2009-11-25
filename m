From: akpm@linux-foundation.org
Subject: + ricoh_mmc-port-from-driver-to-pci-quirk.patch added to -mm tree
Date: Wed, 25 Nov 2009 11:37:23 -0800
Message-ID: <200911251937.nAPJbN17016072__2474.36218564889$1259177875$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191AbZKYThg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 14:37:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, linux-mmc@vger.kernel.org, philipl@overt.org


The patch titled
     ricoh_mmc: port from driver to pci quirk
has been added to the -mm tree.  Its filename is
     ricoh_mmc-port-from-driver-to-pci-quirk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ricoh_mmc: port from driver to pci quirk
From: Maxim Levitsky <maximlevitsky@gmail.com>

-ENOCHANGELOG

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig     |   17 --
 drivers/mmc/host/Makefile    |    1 
 drivers/mmc/host/ricoh_mmc.c |  262 ---------------------------------
 drivers/pci/quirks.c         |   77 +++++++++
 4 files changed, 77 insertions(+), 280 deletions(-)

diff -puN drivers/mmc/host/Kconfig~ricoh_mmc-port-from-driver-to-pci-quirk drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~ricoh_mmc-port-from-driver-to-pci-quirk
+++ a/drivers/mmc/host/Kconfig
@@ -55,23 +55,6 @@ config MMC_SDHCI_PCI
 
 	  If unsure, say N.
 
-config MMC_RICOH_MMC
-	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
-	depends on MMC_SDHCI_PCI
-	help
-	  This selects the disabler for the Ricoh MMC Controller. This
-	  proprietary controller is unnecessary because the SDHCI driver
-	  supports MMC cards on the SD controller, but if it is not
-	  disabled, it will steal the MMC cards away - rendering them
-	  useless. It is safe to select this driver even if you don't
-	  have a Ricoh based card reader.
-
-
-	  To compile this driver as a module, choose M here:
-	  the module will be called ricoh_mmc.
-
-	  If unsure, say Y.
-
 config MMC_SDHCI_OF
 	tristate "SDHCI support on OpenFirmware platforms"
 	depends on MMC_SDHCI && PPC_OF
diff -puN drivers/mmc/host/Makefile~ricoh_mmc-port-from-driver-to-pci-quirk drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~ricoh_mmc-port-from-driver-to-pci-quirk
+++ a/drivers/mmc/host/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
 obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
-obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
 obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 obj-$(CONFIG_MMC_SDHCI_PLTFM)	+= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
diff -puN drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-port-from-driver-to-pci-quirk /dev/null
--- a/drivers/mmc/host/ricoh_mmc.c
+++ /dev/null
@@ -1,262 +0,0 @@
-/*
- *  ricoh_mmc.c - Dummy driver to disable the Rioch MMC controller.
- *
- *  Copyright (C) 2007 Philip Langdale, All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- */
-
-/*
- * This is a conceptually ridiculous driver, but it is required by the way
- * the Ricoh multi-function chips (R5CXXX) work. These chips implement
- * the four main memory card controllers (SD, MMC, MS, xD) and one or both
- * of cardbus or firewire. It happens that they implement SD and MMC
- * support as separate controllers (and PCI functions). The linux SDHCI
- * driver supports MMC cards but the chip detects MMC cards in hardware
- * and directs them to the MMC controller - so the SDHCI driver never sees
- * them. To get around this, we must disable the useless MMC controller.
- * At that point, the SDHCI controller will start seeing them. As a bonus,
- * a detection event occurs immediately, even if the MMC card is already
- * in the reader.
- *
- * It seems to be the case that the relevant PCI registers to deactivate the
- * MMC controller live on PCI function 0, which might be the cardbus controller
- * or the firewire controller, depending on the particular chip in question. As
- * such, it makes what this driver has to do unavoidably ugly. Such is life.
- */
-
-#include <linux/pci.h>
-
-#define DRIVER_NAME "ricoh-mmc"
-
-static const struct pci_device_id pci_ids[] __devinitdata = {
-	{
-		.vendor		= PCI_VENDOR_ID_RICOH,
-		.device		= PCI_DEVICE_ID_RICOH_R5C843,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	},
-	{ /* end: all zeroes */ },
-};
-
-MODULE_DEVICE_TABLE(pci, pci_ids);
-
-static int ricoh_mmc_disable(struct pci_dev *fw_dev)
-{
-	u8 write_enable;
-	u8 write_target;
-	u8 disable;
-
-	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
-		/* via RL5C476 */
-
-		pci_read_config_byte(fw_dev, 0xB7, &disable);
-		if (disable & 0x02) {
-			printk(KERN_INFO DRIVER_NAME
-				": Controller already disabled. " \
-				"Nothing to do.\n");
-			return -ENODEV;
-		}
-
-		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
-		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
-		pci_read_config_byte(fw_dev, 0x8D, &write_target);
-		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
-		pci_write_config_byte(fw_dev, 0xB7, disable | 0x02);
-		pci_write_config_byte(fw_dev, 0x8E, write_enable);
-		pci_write_config_byte(fw_dev, 0x8D, write_target);
-	} else {
-		/* via R5C832 */
-
-		pci_read_config_byte(fw_dev, 0xCB, &disable);
-		if (disable & 0x02) {
-			printk(KERN_INFO DRIVER_NAME
-			       ": Controller already disabled. " \
-				"Nothing to do.\n");
-			return -ENODEV;
-		}
-
-		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-		pci_write_config_byte(fw_dev, 0xCA, 0x57);
-		pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
-		pci_write_config_byte(fw_dev, 0xCA, write_enable);
-	}
-
-	printk(KERN_INFO DRIVER_NAME
-	       ": Controller is now disabled.\n");
-
-	return 0;
-}
-
-static int ricoh_mmc_enable(struct pci_dev *fw_dev)
-{
-	u8 write_enable;
-	u8 write_target;
-	u8 disable;
-
-	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
-		/* via RL5C476 */
-
-		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
-		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
-		pci_read_config_byte(fw_dev, 0x8D, &write_target);
-		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
-		pci_read_config_byte(fw_dev, 0xB7, &disable);
-		pci_write_config_byte(fw_dev, 0xB7, disable & ~0x02);
-		pci_write_config_byte(fw_dev, 0x8E, write_enable);
-		pci_write_config_byte(fw_dev, 0x8D, write_target);
-	} else {
-		/* via R5C832 */
-
-		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-		pci_read_config_byte(fw_dev, 0xCB, &disable);
-		pci_write_config_byte(fw_dev, 0xCA, 0x57);
-		pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
-		pci_write_config_byte(fw_dev, 0xCA, write_enable);
-	}
-
-	printk(KERN_INFO DRIVER_NAME
-	       ": Controller is now re-enabled.\n");
-
-	return 0;
-}
-
-static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
-				     const struct pci_device_id *ent)
-{
-	u8 rev;
-	u8 ctrlfound = 0;
-
-	struct pci_dev *fw_dev = NULL;
-
-	BUG_ON(pdev == NULL);
-	BUG_ON(ent == NULL);
-
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &rev);
-
-	printk(KERN_INFO DRIVER_NAME
-		": Ricoh MMC controller found at %s [%04x:%04x] (rev %x)\n",
-		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
-		(int)rev);
-
-	while ((fw_dev =
-		pci_get_device(PCI_VENDOR_ID_RICOH,
-			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
-		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
-		    PCI_FUNC(fw_dev->devfn) == 0 &&
-		    pdev->bus == fw_dev->bus) {
-			if (ricoh_mmc_disable(fw_dev) != 0)
-				return -ENODEV;
-
-			pci_set_drvdata(pdev, fw_dev);
-
-			++ctrlfound;
-			break;
-		}
-	}
-
-	fw_dev = NULL;
-
-	while (!ctrlfound &&
-	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
-					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
-		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
-		    PCI_FUNC(fw_dev->devfn) == 0 &&
-		    pdev->bus == fw_dev->bus) {
-			if (ricoh_mmc_disable(fw_dev) != 0)
-				return -ENODEV;
-
-			pci_set_drvdata(pdev, fw_dev);
-
-			++ctrlfound;
-		}
-	}
-
-	if (!ctrlfound) {
-		printk(KERN_WARNING DRIVER_NAME
-		       ": Main Ricoh function not found. Cannot disable controller.\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
-{
-	struct pci_dev *fw_dev = NULL;
-
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
-
-	ricoh_mmc_enable(fw_dev);
-
-	pci_set_drvdata(pdev, NULL);
-}
-
-static int ricoh_mmc_suspend_late(struct pci_dev *pdev, pm_message_t state)
-{
-	struct pci_dev *fw_dev = NULL;
-
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
-
-	printk(KERN_INFO DRIVER_NAME ": Suspending.\n");
-
-	ricoh_mmc_enable(fw_dev);
-
-	return 0;
-}
-
-static int ricoh_mmc_resume_early(struct pci_dev *pdev)
-{
-	struct pci_dev *fw_dev = NULL;
-
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
-
-	printk(KERN_INFO DRIVER_NAME ": Resuming.\n");
-
-	ricoh_mmc_disable(fw_dev);
-
-	return 0;
-}
-
-static struct pci_driver ricoh_mmc_driver = {
-	.name = 	DRIVER_NAME,
-	.id_table =	pci_ids,
-	.probe = 	ricoh_mmc_probe,
-	.remove =	__devexit_p(ricoh_mmc_remove),
-	.suspend_late =	ricoh_mmc_suspend_late,
-	.resume_early =	ricoh_mmc_resume_early,
-};
-
-/*****************************************************************************\
- *                                                                           *
- * Driver init/exit                                                          *
- *                                                                           *
-\*****************************************************************************/
-
-static int __init ricoh_mmc_drv_init(void)
-{
-	printk(KERN_INFO DRIVER_NAME
-		": Ricoh MMC Controller disabling driver\n");
-	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Philip Langdale\n");
-
-	return pci_register_driver(&ricoh_mmc_driver);
-}
-
-static void __exit ricoh_mmc_drv_exit(void)
-{
-	pci_unregister_driver(&ricoh_mmc_driver);
-}
-
-module_init(ricoh_mmc_drv_init);
-module_exit(ricoh_mmc_drv_exit);
-
-MODULE_AUTHOR("Philip Langdale <philipl@alumni.utexas.net>");
-MODULE_DESCRIPTION("Ricoh MMC Controller disabling driver");
-MODULE_LICENSE("GPL");
-
diff -puN drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~ricoh_mmc-port-from-driver-to-pci-quirk
+++ a/drivers/pci/quirks.c
@@ -2520,6 +2520,83 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 
 #endif	/* CONFIG_PCI_IOV */
 
+/*
+ * This is a quirk for Ricoh MMC controller found as a part of
+ * multifunction chip.
+ * It is very similiar and based on ricoh_mmc driver written by Philip Langdale
+ * Thanks for these magic sequences.
+ * These chips implement the four main memory card
+ * controllers (SD, MMC, MS, xD) and one or both
+ * of cardbus or firewire. It happens that they implement SD and MMC
+ * support as separate controllers (and PCI functions). The linux SDHCI
+ * driver supports MMC cards but the chip detects MMC cards in hardware
+ * and directs them to the MMC controller - so the SDHCI driver never sees
+ * them. To get around this, we must disable the useless MMC controller.
+ * At that point, the SDHCI controller will start seeing them
+ * It seems to be the case that the relevant PCI registers to deactivate the
+ * MMC controller live on PCI function 0, which might be the cardbus controller
+ * or the firewire controller, depending on the particular chip in question
+ */
+
+static void ricoh_mmc_fixup_rl5c476(struct pci_dev *dev)
+{
+	/* disable via cardbus interface */
+	u8 write_enable;
+	u8 write_target;
+	u8 disable;
+
+	/* disable must be done via function #0 */
+	if (PCI_FUNC(dev->devfn))
+		return;
+
+	pci_read_config_byte(dev, 0xB7, &disable);
+	if (disable & 0x02)
+		return;
+
+	pci_read_config_byte(dev, 0x8E, &write_enable);
+	pci_write_config_byte(dev, 0x8E, 0xAA);
+	pci_read_config_byte(dev, 0x8D, &write_target);
+	pci_write_config_byte(dev, 0x8D, 0xB7);
+	pci_write_config_byte(dev, 0xB7, disable | 0x02);
+	pci_write_config_byte(dev, 0x8E, write_enable);
+	pci_write_config_byte(dev, 0x8D, write_target);
+}
+
+static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
+{
+	/* disable via firewire interface */
+	u8 write_enable;
+	u8 disable;
+
+	/* disable must be done via function #0 */
+	if (PCI_FUNC(dev->devfn))
+		return;
+
+	pci_read_config_byte(dev, 0xCB, &disable);
+
+	if (disable & 0x02)
+		return;
+
+	pci_read_config_byte(dev, 0xCA, &write_enable);
+	pci_write_config_byte(dev, 0xCA, 0x57);
+	pci_write_config_byte(dev, 0xCB, disable | 0x02);
+	pci_write_config_byte(dev, 0xCA, write_enable);
+}
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
+	ricoh_mmc_fixup_rl5c476);
+
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
+	ricoh_mmc_fixup_rl5c476);
+
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
+	ricoh_mmc_fixup_r5c832);
+
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
+	ricoh_mmc_fixup_r5c832);
+
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
ricoh_mmc-port-from-driver-to-pci-quirk.patch
rtc-disable-hpet-emulation-on-suspend.patch

