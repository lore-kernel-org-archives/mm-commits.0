From: akpm@osdl.org
Subject: - piix-slc90e66-pio-mode-fallback-fix.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:03 -0800
Message-ID: <200701020725.l027P3UZ013004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943AbXABH2a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:28:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     PIIX/SLC90E66: PIO mode fallback fix
has been removed from the -mm tree.  Its filename was
     piix-slc90e66-pio-mode-fallback-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PIIX/SLC90E66: PIO mode fallback fix
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

The fallback to PIO mode in the hwif->dma_check() handler doesn't work in
the Intel PIIX and SMsC SLC90E66 IDE drivers because:

- config_drive_for_dma() calls the hwif->speedproc() handler with a wrong
  mode number (unbiased by XFER_PIO_0) in case of the PIO fallback;

- hwif->tuneproc() handler doesn't really set the drive's own speed (this
  is not fixed as yet).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/piix.c     |   33 ++++++++++++++++-----------------
 drivers/ide/pci/slc90e66.c |   20 +++++++++-----------
 2 files changed, 25 insertions(+), 28 deletions(-)

diff -puN drivers/ide/pci/piix.c~piix-slc90e66-pio-mode-fallback-fix drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c~piix-slc90e66-pio-mode-fallback-fix
+++ a/drivers/ide/pci/piix.c
@@ -1,13 +1,14 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.44	March 20, 2003
+ *  linux/drivers/ide/pci/piix.c	Version 0.45	May 12, 2006
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2003 Red Hat Inc <alan@redhat.com>
+ *  Copyright (C) 2006 MontaVista Software, Inc. <source@mvista.com>
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
- *  PIO mode setting function for Intel chipsets.  
+ *  PIO mode setting function for Intel chipsets.
  *  For use instead of BIOS settings.
  *
  * 40-41
@@ -25,7 +26,7 @@
  * sitre = word42 & 0x4000; secondary
  *
  * 44 8421|8421    hdd|hdb
- * 
+ *
  * 48 8421         hdd|hdc|hdb|hda udma enabled
  *
  *    0001         hda
@@ -357,21 +358,20 @@ static int piix_tune_chipset (ide_drive_
  *	@drive: IDE drive to configure
  *
  *	Set up a PIIX interface channel for the best available speed.
- *	We prefer UDMA if it is available and then MWDMA. If DMA is 
- *	not available we switch to PIO and return 0. 
+ *	We prefer UDMA if it is available and then MWDMA.  If DMA is
+ *	not available we switch to PIO and return 0.
  */
  
 static int piix_config_drive_for_dma (ide_drive_t *drive)
 {
 	u8 speed = ide_dma_speed(drive, piix_ratemask(drive));
 
-	/* If no DMA speed was available or the chipset has DMA bugs
-	   then disable DMA and use PIO */
-	   
-	if (!speed || no_piix_dma) {
-		u8 tspeed = ide_get_best_pio_mode(drive, 255, 5, NULL);
-		speed = piix_dma_2_pio(XFER_PIO_0 + tspeed);
-	}
+	/*
+	 * If no DMA speed was available or the chipset has DMA bugs
+	 * then disable DMA and use PIO
+	 */
+	if (!speed || no_piix_dma)
+		return 0;
 
 	(void) piix_tune_chipset(drive, speed);
 	return ide_dma_enable(drive);
@@ -394,17 +394,16 @@ static int piix_config_drive_xfer_rate (
 
 	if ((id->capability & 1) && drive->autodma) {
 
-		if (ide_use_dma(drive)) {
-			if (piix_config_drive_for_dma(drive))
-				return hwif->ide_dma_on(drive);
-		}
+		if (ide_use_dma(drive) && piix_config_drive_for_dma(drive))
+			return hwif->ide_dma_on(drive);
 
 		goto fast_ata_pio;
 
 	} else if ((id->capability & 8) || (id->field_valid & 2)) {
 fast_ata_pio:
 		/* Find best PIO mode. */
-		hwif->tuneproc(drive, 255);
+		(void) hwif->speedproc(drive, XFER_PIO_0 +
+				       ide_get_best_pio_mode(drive, 255, 4, NULL));
 		return hwif->ide_dma_off_quietly(drive);
 	}
 	/* IORDY not supported */
diff -puN drivers/ide/pci/slc90e66.c~piix-slc90e66-pio-mode-fallback-fix drivers/ide/pci/slc90e66.c
--- a/drivers/ide/pci/slc90e66.c~piix-slc90e66-pio-mode-fallback-fix
+++ a/drivers/ide/pci/slc90e66.c
@@ -1,9 +1,10 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.11	September 11, 2002
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.12	May 12, 2006
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 2006 MontaVista Software, Inc. <source@mvista.com>
  *
- * This a look-a-like variation of the ICH0 PIIX4 Ultra-66,
+ * This is a look-alike variation of the ICH0 PIIX4 Ultra-66,
  * but this keeps the ISA-Bridge and slots alive.
  *
  */
@@ -158,10 +159,8 @@ static int slc90e66_config_drive_for_dma
 {
 	u8 speed = ide_dma_speed(drive, slc90e66_ratemask(drive));
 
-	if (!(speed)) {
-		u8 tspeed = ide_get_best_pio_mode(drive, 255, 5, NULL);
-		speed = slc90e66_dma_2_pio(XFER_PIO_0 + tspeed);
-	}
+	if (!speed)
+		return 0;
 
 	(void) slc90e66_tune_chipset(drive, speed);
 	return ide_dma_enable(drive);
@@ -176,16 +175,15 @@ static int slc90e66_config_drive_xfer_ra
 
 	if (id && (id->capability & 1) && drive->autodma) {
 
-		if (ide_use_dma(drive)) {
-			if (slc90e66_config_drive_for_dma(drive))
-				return hwif->ide_dma_on(drive);
-		}
+		if (ide_use_dma(drive) && slc90e66_config_drive_for_dma(drive))
+			return hwif->ide_dma_on(drive);
 
 		goto fast_ata_pio;
 
 	} else if ((id->capability & 8) || (id->field_valid & 2)) {
 fast_ata_pio:
-		hwif->tuneproc(drive, 5);
+		(void) hwif->speedproc(drive, XFER_PIO_0 +
+				       ide_get_best_pio_mode(drive, 255, 4, NULL));
 		return hwif->ide_dma_off_quietly(drive);
 	}
 	/* IORDY not supported */
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
toshiba-tc86c001-ide-driver-take-2.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
