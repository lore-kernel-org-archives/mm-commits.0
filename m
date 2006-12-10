From: akpm@osdl.org
Subject: + pdc202xx_new-remove-useless-code.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:25:48 -0800
Message-ID: <200612101925.kBAJPm33000768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762399AbWLJT0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk


The patch titled
     pdc202xx_new: remove useless code
has been added to the -mm tree.  Its filename is
     pdc202xx_new-remove-useless-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pdc202xx_new: remove useless code
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Remove the following useless fragments from the driver:

- the ide_dma_lostirq() and ide_dma_timeout() handlers which boil down to just
  printing the incoherent reset message and calling their default counterparts;

- check for non-NULL drive->id in the ide_dma_check() handler -- this is assumed
  to be true by all other handlers (also, get rid of unnecessary nesting of the
  conditional statements there);

- the comment before pdcnew_tune_drive() which has nothing to do with the code.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/pdc202xx_new.c |   31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff -puN drivers/ide/pci/pdc202xx_new.c~pdc202xx_new-remove-useless-code drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~pdc202xx_new-remove-useless-code
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -249,13 +249,6 @@ static int pdcnew_tune_chipset(ide_drive
 	return err;
 }
 
-/*   0    1    2    3    4    5    6   7   8
- * 960, 480, 390, 300, 240, 180, 120, 90, 60
- *           180, 150, 120,  90,  60
- * DMA_Speed
- * 180, 120,  90,  90,  90,  60,  30
- *  11,   5,   4,   3,   2,   1,   0
- */
 static void pdcnew_tune_drive(ide_drive_t *drive, u8 pio)
 {
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
@@ -313,12 +306,10 @@ static int pdcnew_config_drive_xfer_rate
 
 	drive->init_speed = 0;
 
-	if (id && (id->capability & 1) && drive->autodma) {
+	if ((id->capability & 1) && drive->autodma) {
 
-		if (ide_use_dma(drive)) {
-			if (config_chipset_for_dma(drive))
-				return hwif->ide_dma_on(drive);
-		}
+		if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+			return hwif->ide_dma_on(drive);
 
 		goto fast_ata_pio;
 
@@ -336,20 +327,6 @@ static int pdcnew_quirkproc(ide_drive_t 
 	return check_in_drive_lists(drive, pdc_quirk_drives);
 }
 
-static int pdcnew_ide_dma_lostirq(ide_drive_t *drive)
-{
-	if (HWIF(drive)->resetproc != NULL)
-		HWIF(drive)->resetproc(drive);
-	return __ide_dma_lostirq(drive);
-}
-
-static int pdcnew_ide_dma_timeout(ide_drive_t *drive)
-{
-	if (HWIF(drive)->resetproc != NULL)
-		HWIF(drive)->resetproc(drive);
-	return __ide_dma_timeout(drive);
-}
-
 static void pdcnew_reset(ide_drive_t *drive)
 {
 	/*
@@ -599,8 +576,6 @@ static void __devinit init_hwif_pdc202ne
 	hwif->err_stops_fifo = 1;
 
 	hwif->ide_dma_check = &pdcnew_config_drive_xfer_rate;
-	hwif->ide_dma_lostirq = &pdcnew_ide_dma_lostirq;
-	hwif->ide_dma_timeout = &pdcnew_ide_dma_timeout;
 
 	if (!hwif->udma_four)
 		hwif->udma_four = pdcnew_cable_detect(hwif) ? 0 : 1;
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
pdc202xx_new-fix-pll-timing-issues.patch
git-mtd.patch
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
pdc202xx_new-remove-useless-code.patch
2619-rc6-mm2-pdc202xx_-remove-check_in_drive_lists-abomination.patch

