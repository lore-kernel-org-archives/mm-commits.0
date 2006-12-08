From: akpm@osdl.org
Subject: - pdc202xx_new-fix-pio-mode-setup.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:07 -0800
Message-ID: <200612082012.kB8KC7ZN002979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60020 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947099AbWLHUPe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     pdc202xx_new: fix PIO mode setup
has been removed from the -mm tree.  Its filename was
     pdc202xx_new-fix-pio-mode-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pdc202xx_new: fix PIO mode setup
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix pdcnew_tune_drive() to always set the PIO mode requested, not pick the
best possible one, change pdcnew_config_drive_xfer_rate() accordingly, and
get rid of the duplicate tuneproc() call in config_chipset_for_dma().

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/pdc202xx_new.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/ide/pci/pdc202xx_new.c~pdc202xx_new-fix-pio-mode-setup drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~pdc202xx_new-fix-pio-mode-setup
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -9,6 +9,7 @@
  *  Split from:
  *  linux/drivers/ide/pdc202xx.c	Version 0.35	Mar. 30, 2002
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
+ *  Copyright (C) 2005-2006		MontaVista Software, Inc.
  *  Portions Copyright (C) 1999 Promise Technology, Inc.
  *  Author: Frank Tiernan (frankt@promise.com)
  *  Released under terms of General Public License
@@ -168,12 +169,8 @@ static int pdcnew_new_tune_chipset (ide_
  */
 static void pdcnew_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	u8 speed;
-
-	if (pio == 5) pio = 4;
-	speed = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, pio, NULL);
-
-	(void)pdcnew_new_tune_chipset(drive, speed);
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	(void)pdcnew_new_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
 static u8 pdcnew_new_cable_detect (ide_hwif_t *hwif)
@@ -207,10 +204,8 @@ static int config_chipset_for_dma (ide_d
 
 	speed = ide_dma_speed(drive, pdcnew_ratemask(drive));
 
-	if (!(speed)) {
-		hwif->tuneproc(drive, 5);
+	if (!speed)
 		return 0;
-	}
 
 	(void) hwif->speedproc(drive, speed);
 	return ide_dma_enable(drive);
@@ -234,7 +229,7 @@ static int pdcnew_config_drive_xfer_rate
 
 	} else if ((id->capability & 8) || (id->field_valid & 2)) {
 fast_ata_pio:
-		hwif->tuneproc(drive, 5);
+		hwif->tuneproc(drive, 255);
 		return hwif->ide_dma_off_quietly(drive);
 	}
 	/* IORDY not supported */
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
pdc202xx_new-fix-pio-mode-setup.patch
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

