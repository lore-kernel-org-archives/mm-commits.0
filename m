From: akpm@linux-foundation.org
Subject: + pata_cmd64x-set-up-mwdma-modes-properly.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:59:32 -0700
Message-ID: <200708091959.l79JxWe6016786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbXHIUAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_cmd64x: Set up MWDMA modes properly
has been added to the -mm tree.  Its filename is
     pata_cmd64x-set-up-mwdma-modes-properly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_cmd64x: Set up MWDMA modes properly
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Set the MWDMA timing by updating the correct registers.  Split the PIO path as
this is mostly shared code.  Wants testing.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cmd64x.c |   37 +++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff -puN drivers/ata/pata_cmd64x.c~pata_cmd64x-set-up-mwdma-modes-properly drivers/ata/pata_cmd64x.c
--- a/drivers/ata/pata_cmd64x.c~pata_cmd64x-set-up-mwdma-modes-properly
+++ a/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.4"
+#define DRV_VERSION "0.2.5"
 
 /*
  * CMD64x specific registers definition.
@@ -88,14 +88,15 @@ static int cmd648_cable_detect(struct at
 }
 
 /**
- *	cmd64x_set_piomode	-	set initial PIO mode data
+ *	cmd64x_set_piomode	-	set PIO and MWDMA timing
  *	@ap: ATA interface
  *	@adev: ATA device
+ *	@mode: mode
  *
- *	Called to do the PIO mode setup.
+ *	Called to do the PIO and MWDMA mode setup.
  */
 
-static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 mode)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct ata_timing t;
@@ -117,8 +118,9 @@ static void cmd64x_set_piomode(struct at
 	int arttim = arttim_port[ap->port_no][adev->devno];
 	int drwtim = drwtim_port[ap->port_no][adev->devno];
 
-
-	if (ata_timing_compute(adev, adev->pio_mode, &t, T, 0) < 0) {
+	/* ata_timing_compute is smart and will produce timings for MWDMA
+	   that don't violate the drives PIO capabilities. */
+	if (ata_timing_compute(adev, mode, &t, T, 0) < 0) {
 		printk(KERN_ERR DRV_NAME ": mode computation failed.\n");
 		return;
 	}
@@ -168,6 +170,20 @@ static void cmd64x_set_piomode(struct at
 }
 
 /**
+ *	cmd64x_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Used when configuring the devices ot set the PIO timings. All the
+ *	actual work is done by the PIO/MWDMA setting helper
+ */
+
+static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	cmd64x_set_timing(ap, adev, adev->pio_mode);
+}
+
+/**
  *	cmd64x_set_dmamode	-	set initial DMA mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -180,9 +196,6 @@ static void cmd64x_set_dmamode(struct at
 	static const u8 udma_data[] = {
 		0x30, 0x20, 0x10, 0x20, 0x10, 0x00
 	};
-	static const u8 mwdma_data[] = {
-		0x30, 0x20, 0x10
-	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 regU, regD;
@@ -208,8 +221,10 @@ static void cmd64x_set_dmamode(struct at
 		regU |= 1 << adev->devno; /* UDMA on */
 		if (adev->dma_mode > 2)	/* 15nS timing */
 			regU |= 4 << adev->devno;
-	} else
-		regD |= mwdma_data[adev->dma_mode - XFER_MW_DMA_0] << shift;
+	} else {
+		regU &= ~ (1 << adev->devno);	/* UDMA off */
+		cmd64x_set_timing(ap, adev, adev->dma_mode);
+	}
 
 	regD |= 0x20 << adev->devno;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pci-align-bar-settings-for-legacy-mode-ide-fix.patch
belkin_sa-avoid-divide-by-zero-error.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
