From: akpm@osdl.org
Subject: - piix-tuneproc-fixes-cleanups.patch removed from -mm tree
Date: Mon, 22 Jan 2007 13:11:10 -0800
Message-ID: <200701222111.l0MLBAdg002227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbXAVVL2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:11:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide: PIIX tuneproc() fixes/cleanups
has been removed from the -mm tree.  Its filename was
     piix-tuneproc-fixes-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: PIIX tuneproc() fixes/cleanups
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix/cleanup the driver's tuneproc() and ratemask() methods:

- PPE, IE, and TIME bits need to be cleared beforehand for the slave drive as
  well as master (Alan probably just forgot about it);

- this driver only supports PIO modes up to 4, so must pass the correct limit
  to ide_get_best_pio_mode();

- use min_t() macro instead of min();

- simplify slave vs master drive evaluation;

- do come coding and formatting cleanups...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/piix.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/ide/pci/piix.c~piix-tuneproc-fixes-cleanups drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c~piix-tuneproc-fixes-cleanups
+++ a/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.45	May 12, 2006
+ *  linux/drivers/ide/pci/piix.c	Version 0.46	December 3, 2006
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -163,7 +163,7 @@ static u8 piix_ratemask (ide_drive_t *dr
 	 *	if the drive cannot see an 80pin cable.
 	 */
 	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
+		mode = min_t(u8, mode, 1);
 	return mode;
 }
 
@@ -216,7 +216,7 @@ static void piix_tune_drive (ide_drive_t
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	int is_slave		= (&hwif->drives[1] == drive);
+	int is_slave		= drive->dn & 1;
 	int master_port		= hwif->channel ? 0x42 : 0x40;
 	int slave_port		= 0x44;
 	unsigned long flags;
@@ -225,7 +225,7 @@ static void piix_tune_drive (ide_drive_t
 	static DEFINE_SPINLOCK(tune_lock);
 	int control = 0;
 
-				 /* ISP  RTC */
+				     /* ISP  RTC */
 	static const u8 timings[][2]= {
 					{ 0, 0 },
 					{ 0, 0 },
@@ -233,7 +233,7 @@ static void piix_tune_drive (ide_drive_t
 					{ 2, 1 },
 					{ 2, 3 }, };
 
-	pio = ide_get_best_pio_mode(drive, pio, 5, NULL);
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
 
 	/*
 	 * Master vs slave is synchronized above us but the slave register is
@@ -243,25 +243,24 @@ static void piix_tune_drive (ide_drive_t
 	spin_lock_irqsave(&tune_lock, flags);
 	pci_read_config_word(dev, master_port, &master_data);
 
-	if (pio >= 2)
+	if (pio > 1)
 		control |= 1;	/* Programmable timing on */
 	if (drive->media == ide_disk)
 		control |= 4;	/* Prefetch, post write */
-	if (pio >= 3)
+	if (pio > 2)
 		control |= 2;	/* IORDY */
 	if (is_slave) {
-		master_data = master_data | 0x4000;
+		master_data |=  0x4000;
+		master_data &= ~0x0070;
 		if (pio > 1) {
 			/* enable PPE, IE and TIME */
 			master_data = master_data | (control << 4);
-		} else {
-			master_data &= ~0x0070;
 		}
 		pci_read_config_byte(dev, slave_port, &slave_data);
 		slave_data = slave_data & (hwif->channel ? 0x0f : 0xf0);
 		slave_data = slave_data | (((timings[pio][0] << 2) | timings[pio][1]) << (hwif->channel ? 4 : 0));
 	} else {
-		master_data = master_data & 0xccf8;
+		master_data &= ~0x3307;
 		if (pio > 1) {
 			/* enable PPE, IE and TIME */
 			master_data = master_data | control;
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
