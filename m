From: akpm@osdl.org
Subject: + slc90e66-carry-over-fixes-from-piix-driver.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:43:26 -0800
Message-ID: <200701022143.l02LhQrF030713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbXABVnw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:43:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com


The patch titled
     ide: slc90e66: carry over fixes from piix driver
has been added to the -mm tree.  Its filename is
     slc90e66-carry-over-fixes-from-piix-driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide: slc90e66: carry over fixes from piix driver
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Synchronize with version 0.46 of the Intel PIIX/ICH driver:

- carry over Alan's and my own fixes in the tuneproc() method and my cleanups
  both there and in the ratemask() method;

- SLC90E66 only supports MW DMA modes 1/2 and SW DMA mode 2 (just like Intel
  chips), so don't claim support for other MW/SW DMA modes;

- don't check dor non-NULL drive->id in the ide_dma_check() method -- this is
  assumed to be true in all other drivers;

- do some coding/formatting cleanups while at it...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/slc90e66.c |   55 +++++++++++++++++++++--------------
 1 files changed, 34 insertions(+), 21 deletions(-)

diff -puN drivers/ide/pci/slc90e66.c~slc90e66-carry-over-fixes-from-piix-driver drivers/ide/pci/slc90e66.c
--- a/drivers/ide/pci/slc90e66.c~slc90e66-carry-over-fixes-from-piix-driver
+++ a/drivers/ide/pci/slc90e66.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.12	May 12, 2006
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.13	December 30, 2006
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006 MontaVista Software, Inc. <source@mvista.com>
@@ -26,7 +26,7 @@ static u8 slc90e66_ratemask (ide_drive_t
 	u8 mode	= 2;
 
 	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
+		mode = min_t(u8, mode, 1);
 	return mode;
 }
 
@@ -65,36 +65,47 @@ static void slc90e66_tune_drive (ide_dri
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	int is_slave		= (&hwif->drives[1] == drive);
+	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
 	int slave_port		= 0x44;
 	unsigned long flags;
 	u16 master_data;
 	u8 slave_data;
-				 /* ISP  RTC */
+ 	int control = 0;
+				     /* ISP  RTC */
 	static const u8 timings[][2]= {
-				    { 0, 0 },
-				    { 0, 0 },
-				    { 1, 0 },
-				    { 2, 1 },
-				    { 2, 3 }, };
+					{ 0, 0 },
+					{ 0, 0 },
+					{ 1, 0 },
+					{ 2, 1 },
+					{ 2, 3 }, };
 
-	pio = ide_get_best_pio_mode(drive, pio, 5, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
 	spin_lock_irqsave(&ide_lock, flags);
 	pci_read_config_word(dev, master_port, &master_data);
+
+	if (pio > 1)
+		control |= 1;	/* Programmable timing on */
+	if (drive->media == ide_disk)
+		control |= 4;	/* Prefetch, post write */
+	if (pio > 2)
+		control |= 2;	/* IORDY */
 	if (is_slave) {
-		master_data = master_data | 0x4000;
-		if (pio > 1)
+		master_data |=  0x4000;
+		master_data &= ~0x0070;
+		if (pio > 1) {
 			/* enable PPE, IE and TIME */
-			master_data = master_data | 0x0070;
+			master_data = master_data | (control << 4);
+		}
 		pci_read_config_byte(dev, slave_port, &slave_data);
 		slave_data = slave_data & (hwif->channel ? 0x0f : 0xf0);
 		slave_data = slave_data | (((timings[pio][0] << 2) | timings[pio][1]) << (hwif->channel ? 4 : 0));
 	} else {
-		master_data = master_data & 0xccf8;
-		if (pio > 1)
+		master_data &= ~0x3307;
+		if (pio > 1) {
 			/* enable PPE, IE and TIME */
-			master_data = master_data | 0x0007;
+			master_data = master_data | control;
+		}
 		master_data = master_data | (timings[pio][0] << 12) | (timings[pio][1] << 8);
 	}
 	pci_write_config_word(dev, master_port, master_data);
@@ -173,7 +184,7 @@ static int slc90e66_config_drive_xfer_ra
 
 	drive->init_speed = 0;
 
-	if (id && (id->capability & 1) && drive->autodma) {
+	if ((id->capability & 1) && drive->autodma) {
 
 		if (ide_use_dma(drive) && slc90e66_config_drive_for_dma(drive))
 			return hwif->ide_dma_on(drive);
@@ -201,7 +212,7 @@ static void __devinit init_hwif_slc90e66
 		hwif->irq = hwif->channel ? 15 : 14;
 
 	hwif->speedproc = &slc90e66_tune_chipset;
-	hwif->tuneproc = &slc90e66_tune_drive;
+	hwif->tuneproc	= &slc90e66_tune_drive;
 
 	pci_read_config_byte(hwif->pci_dev, 0x47, &reg47);
 
@@ -213,14 +224,16 @@ static void __devinit init_hwif_slc90e66
 
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x1f;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
+	hwif->mwdma_mask = 0x06;
+	hwif->swdma_mask = 0x04;
 
-	if (!(hwif->udma_four))
+	if (!hwif->udma_four) {
 		/* bit[0(1)]: 0:80, 1:40 */
 		hwif->udma_four = (reg47 & mask) ? 0 : 1;
+	}
 
 	hwif->ide_dma_check = &slc90e66_config_drive_xfer_rate;
+
 	if (!noautodma)
 		hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->autodma;
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
piix-tuneproc-fixes-cleanups.patch
slc90e66-carry-over-fixes-from-piix-driver.patch
hpt36x-pci-clock-detection-fix.patch
