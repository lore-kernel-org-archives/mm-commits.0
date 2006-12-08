From: akpm@osdl.org
Subject: - sl82c105-straighten-up-ide-control-status-register-caching.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:10 -0800
Message-ID: <200612082012.kB8KCA4Q002985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60018 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947118AbWLHUPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     sl82c105: straighten up IDE control/status register caching
has been removed from the -mm tree.  Its filename was
     sl82c105-straighten-up-ide-control-status-register-caching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sl82c105: straighten up IDE control/status register caching
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Straighten up the IDE control/status register caching -- you *really* can't
cache the shared register per-channel and hope that it won't get out ouf
sync.

Set the PIO fallback mode to PIO0 for the slave drive as well as master --
there was no point in having them different (most probably a resutl of
typo).

Do a bit of reformat and cleanup while at it...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/sl82c105.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff -puN drivers/ide/pci/sl82c105.c~sl82c105-straighten-up-ide-control-status-register-caching drivers/ide/pci/sl82c105.c
--- a/drivers/ide/pci/sl82c105.c~sl82c105-straighten-up-ide-control-status-register-caching
+++ a/drivers/ide/pci/sl82c105.c
@@ -299,14 +299,14 @@ static void sl82c105_selectproc(ide_driv
 	//DBG(("sl82c105_selectproc(drive:%s)\n", drive->name));
 
 	mask = hwif->channel ? CTRL_P1F16 : CTRL_P0F16;
-	old = val = *((u32 *)&hwif->hwif_data);
+	old = val = (u32)pci_get_drvdata(dev);
 	if (drive->using_dma)
 		val &= ~mask;
 	else
 		val |= mask;
 	if (old != val) {
 		pci_write_config_dword(dev, 0x40, val);	
-		*((u32 *)&hwif->hwif_data) = val;
+		pci_set_drvdata(dev, (void *)val);
 	}
 }
 
@@ -316,14 +316,13 @@ static void sl82c105_selectproc(ide_driv
  */
 static void sl82c105_resetproc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev = HWIF(drive)->pci_dev;
 	u32 val;
 
 	DBG(("sl82c105_resetproc(drive:%s)\n", drive->name));
 
 	pci_read_config_dword(dev, 0x40, &val);
-	*((u32 *)&hwif->hwif_data) = val;
+	pci_set_drvdata(dev, (void *)val);
 }
 	
 /*
@@ -394,6 +393,7 @@ static unsigned int __devinit init_chips
 	pci_read_config_dword(dev, 0x40, &val);
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
+	pci_set_drvdata(dev, (void *)val);
 
 	return dev->irq;
 }
@@ -404,30 +404,25 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
 	unsigned int rev;
 	u8 dma_state;
-	u32 val;
-	
+
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
 
 	hwif->tuneproc = tune_sl82c105;
 	hwif->selectproc = sl82c105_selectproc;
 	hwif->resetproc = sl82c105_resetproc;
-	
-	/* Default to PIO 0 for fallback unless tuned otherwise,
-	 * we always autotune PIO, this is done before DMA is
-	 * checked, so there is no risk of accidentally disabling
-	 * DMA
-	  */
+
+	/*
+	 * Default to PIO 0 for fallback unless tuned otherwise.
+	 * We always autotune PIO,  this is done before DMA is checked,
+	 * so there's no risk of accidentally disabling DMA
+	 */
 	hwif->drives[0].pio_speed = XFER_PIO_0;
 	hwif->drives[0].autotune = 1;
-	hwif->drives[1].pio_speed = XFER_PIO_1;
+	hwif->drives[1].pio_speed = XFER_PIO_0;
 	hwif->drives[1].autotune = 1;
 
-	pci_read_config_dword(dev, 0x40, &val);
-	*((u32 *)&hwif->hwif_data) = val;
-	
 	hwif->atapi_dma = 0;
 	hwif->mwdma_mask = 0;
 	hwif->swdma_mask = 0;
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
3x59x-fix-pci-resource-management.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch

