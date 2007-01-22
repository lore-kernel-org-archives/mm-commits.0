From: akpm@osdl.org
Subject: - hpt370-clean-up-dma-timeout-handling.patch removed from -mm tree
Date: Mon, 22 Jan 2007 13:10:57 -0800
Message-ID: <200701222110.l0MLAve5002201@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758AbXAVVR2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:17:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     HPT370: clean up DMA timeout handling
has been removed from the -mm tree.  Its filename was
     hpt370-clean-up-dma-timeout-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HPT370: clean up DMA timeout handling
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Clean up DMA timeout handling for HPT370:

- hpt370_lostirq_timeout() cleared the DMA status which made __ide_dma_end()
   called afterwards return the incorrect result, and the DMA engine was reset
   both before and after stopping DMA while the HighPoint drivers only do it
   after (which seems logical) -- fix this and also rename the function;

- get rid of the needless mutual recursion in hpt370_ide_dma_end() and
   hpt370_ide_dma_timeout();

- get rid of hpt370_lostirq_timeout() since hwif->ide_dma_end() called from
   the driver's interrupt handler later does all its work.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |   62 ++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~hpt370-clean-up-dma-timeout-handling drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~hpt370-clean-up-dma-timeout-handling
+++ a/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 0.51	Jun 04, 2006
+ * linux/drivers/ide/pci/hpt366.c		Version 0.52	Jun 07, 2006
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -90,6 +90,7 @@
  *   there; make HPT36x speedproc handler look the same way as the HPT37x one
  * - fix  the tuneproc handler to always set the PIO mode requested,  not the
  *   best possible one
+ * - clean up DMA timeout handling for HPT370
  *		<source@mvista.com>
  */
 
@@ -680,7 +681,7 @@ static int hpt366_ide_dma_lostirq(ide_dr
 	return __ide_dma_lostirq(drive);
 }
 
-static void hpt370_clear_engine (ide_drive_t *drive)
+static void hpt370_clear_engine(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
@@ -688,6 +689,22 @@ static void hpt370_clear_engine (ide_dri
 	udelay(10);
 }
 
+static void hpt370_irq_timeout(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	u16 bfifo		= 0;
+	u8  dma_cmd;
+
+	pci_read_config_word(hwif->pci_dev, hwif->select_data + 2, &bfifo);
+	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
+
+	/* get DMA command mode */
+	dma_cmd = hwif->INB(hwif->dma_command);
+	/* stop DMA */
+	hwif->OUTB(dma_cmd & ~0x1, hwif->dma_command);
+	hpt370_clear_engine(drive);
+}
+
 static void hpt370_ide_dma_start(ide_drive_t *drive)
 {
 #ifdef HPT_RESET_STATE_ENGINE
@@ -696,55 +713,27 @@ static void hpt370_ide_dma_start(ide_dri
 	ide_dma_start(drive);
 }
 
-static int hpt370_ide_dma_end (ide_drive_t *drive)
+static int hpt370_ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8  dma_stat		= hwif->INB(hwif->dma_status);
 
 	if (dma_stat & 0x01) {
 		/* wait a little */
 		udelay(20);
 		dma_stat = hwif->INB(hwif->dma_status);
+		if (dma_stat & 0x01)
+			hpt370_irq_timeout(drive);
 	}
-	if ((dma_stat & 0x01) != 0) 
-		/* fallthrough */
-		(void) HWIF(drive)->ide_dma_timeout(drive);
-
 	return __ide_dma_end(drive);
 }
 
-static void hpt370_lostirq_timeout (ide_drive_t *drive)
+static int hpt370_ide_dma_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 bfifo = 0;
-	u8 dma_stat = 0, dma_cmd = 0;
-
-	pci_read_config_byte(HWIF(drive)->pci_dev, hwif->select_data + 2, &bfifo);
-	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo);
-	hpt370_clear_engine(drive);
-	/* get dma command mode */
-	dma_cmd = hwif->INB(hwif->dma_command);
-	/* stop dma */
-	hwif->OUTB(dma_cmd & ~0x1, hwif->dma_command);
-	dma_stat = hwif->INB(hwif->dma_status);
-	/* clear errors */
-	hwif->OUTB(dma_stat | 0x6, hwif->dma_status);
-}
-
-static int hpt370_ide_dma_timeout (ide_drive_t *drive)
-{
-	hpt370_lostirq_timeout(drive);
-	hpt370_clear_engine(drive);
+	hpt370_irq_timeout(drive);
 	return __ide_dma_timeout(drive);
 }
 
-static int hpt370_ide_dma_lostirq (ide_drive_t *drive)
-{
-	hpt370_lostirq_timeout(drive);
-	hpt370_clear_engine(drive);
-	return __ide_dma_lostirq(drive);
-}
-
 /* returns 1 if DMA IRQ issued, 0 otherwise */
 static int hpt374_ide_dma_test_irq(ide_drive_t *drive)
 {
@@ -1226,7 +1215,6 @@ static void __devinit init_hwif_hpt366(i
 		hwif->dma_start 	= &hpt370_ide_dma_start;
 		hwif->ide_dma_end	= &hpt370_ide_dma_end;
 		hwif->ide_dma_timeout	= &hpt370_ide_dma_timeout;
-		hwif->ide_dma_lostirq	= &hpt370_ide_dma_lostirq;
 	} else
 		hwif->ide_dma_lostirq	= &hpt366_ide_dma_lostirq;
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
