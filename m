From: akpm@osdl.org
Subject: + hpt37x-two-important-bug-fixes.patch added to -mm tree
Date: Thu, 04 Jan 2007 13:36:45 -0800
Message-ID: <200701042136.l04Lajpb032042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094AbXADVgz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 16:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     hpt37x: Two important bug fixes
has been added to the -mm tree.  Its filename is
     hpt37x-two-important-bug-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hpt37x: Two important bug fixes
From: Alan <alan@lxorguk.ukuu.org.uk>

The HPT37x driver very carefully handles DMA completions and the needed
fixups are done on pci registers 0x50 and 0x52.  This is unfortunate
because the actual registers are 0x50 and 0x54.  Fixing this offset cures
the second channel problems reported.

Secondly there are some problems with the HPT370 and certain ATA drives. 
The filter code however only filters ATAPI devices due to a reversed type
check.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/pata_hpt37x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/pata_hpt37x.c~hpt37x-two-important-bug-fixes drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~hpt37x-two-important-bug-fixes
+++ a/drivers/ata/pata_hpt37x.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.5.1"
+#define DRV_VERSION	"0.5.2"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -416,7 +416,7 @@ static const char *bad_ata100_5[] = {
 
 static unsigned long hpt370_filter(const struct ata_port *ap, struct ata_device *adev, unsigned long mask)
 {
-	if (adev->class != ATA_DEV_ATA) {
+	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA", bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
@@ -749,7 +749,7 @@ static void hpt37x_bmdma_stop(struct ata
 {
 	struct ata_port *ap = qc->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int mscreg = 0x50 + 2 * ap->port_no;
+	int mscreg = 0x50 + 4 * ap->port_no;
 	u8 bwsr_stat, msc_stat;
 
 	pci_read_config_byte(pdev, 0x6A, &bwsr_stat);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
via82cxxx-fix-cable-detection.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang.patch
git-libata-all.patch
hpt37x-two-important-bug-fixes.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
cdrom-longer-timeout-for-read-track-info-command.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
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
