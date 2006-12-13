From: akpm@osdl.org
Subject: - ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:47 -0800
Message-ID: <200612130654.kBD6slJE030574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57692 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016AbWLMGy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, axboe@suse.de, mm-commits@vger.kernel.org


The patch titled
     ide-cd: Handle strange interrupt on the Intel ESB2
has been removed from the -mm tree.  Its filename was
     ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide-cd: Handle strange interrupt on the Intel ESB2
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The ESB2 appears to emit spurious DMA interrupts when configured for native
mode and handling ATAPI devices.  Stratus were able to pin this bug down and
produce a patch.  This is a rework which applies the fixup only to the ESB2
(for now).  We can apply it to other chips later if the same problem is found.

This code has been tested and confirmed to fix the problem on the tested
systems.

Signed-off-by: Alan Cox <alan@redhat.com>
(Most of the hard work done by Stratus however)
Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/ide-cd.c   |    7 +++++++
 drivers/ide/pci/piix.c |    4 ++++
 include/linux/ide.h    |    1 +
 3 files changed, 12 insertions(+)

diff -puN drivers/ide/ide-cd.c~ide-cd-handle-strange-interrupt-on-the-intel-esb2 drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~ide-cd-handle-strange-interrupt-on-the-intel-esb2
+++ a/drivers/ide/ide-cd.c
@@ -687,8 +687,15 @@ static void ide_dump_status_no_sense(ide
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
+	ide_hwif_t *hwif = HWIF(drive);
 	int stat, err, sense_key;
 	
+	/* We may have bogus DMA interrupts in PIO state here */
+	if (HWIF(drive)->dma_status && hwif->atapi_irq_bogon) {
+		stat = hwif->INB(hwif->dma_status);
+		/* Should we force the bit as well ? */
+		hwif->OUTB(stat, hwif->dma_status);
+	}
 	/* Check for errors. */
 	stat = HWIF(drive)->INB(IDE_STATUS_REG);
 	if (stat_ret)
diff -puN drivers/ide/pci/piix.c~ide-cd-handle-strange-interrupt-on-the-intel-esb2 drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c~ide-cd-handle-strange-interrupt-on-the-intel-esb2
+++ a/drivers/ide/pci/piix.c
@@ -505,6 +505,10 @@ static void __devinit init_hwif_piix(ide
 		/* This is a painful system best to let it self tune for now */
 		return;
 	}
+	/* ESB2 appears to generate spurious DMA interrupts in PIO mode
+	   when in native mode */
+	if (hwif->pci_dev->device == PCI_DEVICE_ID_INTEL_ESB2_18)
+		hwif->atapi_irq_bogon = 1;
 
 	hwif->autodma = 0;
 	hwif->tuneproc = &piix_tune_drive;
diff -puN include/linux/ide.h~ide-cd-handle-strange-interrupt-on-the-intel-esb2 include/linux/ide.h
--- a/include/linux/ide.h~ide-cd-handle-strange-interrupt-on-the-intel-esb2
+++ a/include/linux/ide.h
@@ -796,6 +796,7 @@ typedef struct hwif_s {
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	no_io_32bit : 1; /* 1 = can not do 32-bit IO ops */
 	unsigned	err_stops_fifo : 1; /* 1=data FIFO is cleared by an error */
+	unsigned	atapi_irq_bogon : 1; /* Generates spurious DMA interrupts in PIO mode */
 
 	struct device	gendev;
 	struct completion gendev_rel_comp; /* To deal with device release() */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-switch-to-ktermios-nozomi-fix.patch
git-libata-all.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
xtensa-add-ktermios-and-minor-filename-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
tty-remove-useless-memory-barrier.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

