From: akpm@osdl.org
Subject: - piix-remove-check-for-broken-mw-dma-mode-0.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:59 -0800
Message-ID: <200701020724.l027OxPF012998@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37687 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbXABH22 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     PIIX: remove check for broken MW DMA mode 0
has been removed from the -mm tree.  Its filename was
     piix-remove-check-for-broken-mw-dma-mode-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PIIX: remove check for broken MW DMA mode 0
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

There's no need to check in piix_config_drive_for_dma() for broken MW DMA
mode 0 as this mode is not supported by the driver (it sets
hwif->mwdma_mask to 0x6), and hence can't be selected by ide_dma_speed().

(Alan sayeth "Probably right but if not you've got a subtle corruptor.  Should
at least stick a BUG_ON mode 0 setting right close when the mode is set.")

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/piix.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

diff -puN drivers/ide/pci/piix.c~piix-remove-check-for-broken-mw-dma-mode-0 drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c~piix-remove-check-for-broken-mw-dma-mode-0
+++ a/drivers/ide/pci/piix.c
@@ -353,33 +353,6 @@ static int piix_tune_chipset (ide_drive_
 }
 
 /**
- *	piix_faulty_dma0		-	check for DMA0 errata
- *	@hwif: IDE interface to check
- *
- *	If an ICH/ICH0/ICH2 interface is is operating in multi-word
- *	DMA mode with 600nS cycle time the IDE PIO prefetch buffer will
- *	inadvertently provide an extra piece of secondary data to the primary
- *	device resulting in data corruption.
- *
- *	With such a device this test function returns true. This allows
- *	our tuning code to follow Intel recommendations and use PIO on
- *	such devices.
- */
- 
-static int piix_faulty_dma0(ide_hwif_t *hwif)
-{
-	switch(hwif->pci_dev->device)
-	{
-		case PCI_DEVICE_ID_INTEL_82801AA_1:	/* ICH */
-		case PCI_DEVICE_ID_INTEL_82801AB_1:	/* ICH0 */
-		case PCI_DEVICE_ID_INTEL_82801BA_8:	/* ICH2 */
-		case PCI_DEVICE_ID_INTEL_82801BA_9:	/* ICH2 */
-			return 1;
-	}
-	return 0;
-}
-
-/**
  *	piix_config_drive_for_dma	-	configure drive for DMA
  *	@drive: IDE drive to configure
  *
@@ -391,10 +364,6 @@ static int piix_faulty_dma0(ide_hwif_t *
 static int piix_config_drive_for_dma (ide_drive_t *drive)
 {
 	u8 speed = ide_dma_speed(drive, piix_ratemask(drive));
-	
-	/* Some ICH devices cannot support DMA mode 0 */
-	if(speed == XFER_MW_DMA_0 && piix_faulty_dma0(HWIF(drive)))
-		speed = 0;
 
 	/* If no DMA speed was available or the chipset has DMA bugs
 	   then disable DMA and use PIO */
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
