From: akpm@osdl.org
Subject: - atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:27 -0800
Message-ID: <200701070758.l077wRQm012954@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXAGH6o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atiixp: Old drivers/ide layer driver for the ATIIXP hang fix
has been removed from the -mm tree.  Its filename was
     atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atiixp: Old drivers/ide layer driver for the ATIIXP hang fix
From: Alan <alan@lxorguk.ukuu.org.uk>

When the old IDE layer calls into methods in the driver during error
handling it is essentially random whether ide_lock is already held.  This
causes a deadlock in the atiixp driver which also uses ide_lock internally
for locking.

Switch to a private lock instead.

[akpm@osl.org: cleanup]
Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/atiixp.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/ide/pci/atiixp.c~atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang drivers/ide/pci/atiixp.c
--- a/drivers/ide/pci/atiixp.c~atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang
+++ a/drivers/ide/pci/atiixp.c
@@ -46,6 +46,8 @@ static atiixp_ide_timing mdma_timing[] =
 
 static int save_mdma_mode[4];
 
+static DEFINE_SPINLOCK(atiixp_lock);
+
 /**
  *	atiixp_ratemask		-	compute rate mask for ATIIXP IDE
  *	@drive: IDE drive to compute for
@@ -105,7 +107,7 @@ static int atiixp_ide_dma_host_on(ide_dr
 	unsigned long flags;
 	u16 tmp16;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&atiixp_lock, flags);
 
 	pci_read_config_word(dev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
 	if (save_mdma_mode[drive->dn])
@@ -114,7 +116,7 @@ static int atiixp_ide_dma_host_on(ide_dr
 		tmp16 |= (1 << drive->dn);
 	pci_write_config_word(dev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
 
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 
 	return __ide_dma_host_on(drive);
 }
@@ -125,13 +127,13 @@ static int atiixp_ide_dma_host_off(ide_d
 	unsigned long flags;
 	u16 tmp16;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&atiixp_lock, flags);
 
 	pci_read_config_word(dev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
 	tmp16 &= ~(1 << drive->dn);
 	pci_write_config_word(dev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
 
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 
 	return __ide_dma_host_off(drive);
 }
@@ -152,7 +154,7 @@ static void atiixp_tuneproc(ide_drive_t 
 	u32 pio_timing_data;
 	u16 pio_mode_data;
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&atiixp_lock, flags);
 
 	pci_read_config_word(dev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
 	pio_mode_data &= ~(0x07 << (drive->dn * 4));
@@ -165,7 +167,7 @@ static void atiixp_tuneproc(ide_drive_t 
 		 (pio_timing[pio].command_width << (timing_shift + 4));
 	pci_write_config_dword(dev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
 
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 /**
@@ -189,7 +191,7 @@ static int atiixp_speedproc(ide_drive_t 
 
 	speed = ide_rate_filter(atiixp_ratemask(drive), xferspeed);
 
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(&atiixp_lock, flags);
 
 	save_mdma_mode[drive->dn] = 0;
 	if (speed >= XFER_UDMA_0) {
@@ -208,7 +210,7 @@ static int atiixp_speedproc(ide_drive_t 
 		}
 	}
 
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 
 	if (speed >= XFER_SW_DMA_0)
 		pio = atiixp_dma_2_pio(speed);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
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
