From: akpm@osdl.org
Subject: + libata-fix-hopefully-all-the-remaining-problems-with.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:36:49 -0800
Message-ID: <200702012236.l11Manjb024956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852AbXBAWgy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:36:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk


The patch titled
     libata: fix (hopefully) all the remaining problems with devices failing setup/identify
has been added to the -mm tree.  Its filename is
     libata-fix-hopefully-all-the-remaining-problems-with.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: fix (hopefully) all the remaining problems with devices failing setup/identify
From: Alan <alan@lxorguk.ukuu.org.uk>

Two fixes in this test patch.  One of them allows old CF cards to refuse
pio mode setting, and one to wait for the drive to settle after a set
features changes the speed settings, which is based upon the workarounds
used by drivers/ide.

Please test and report back if you have an afflicted system.  This patch
isn't for merging just testing.

The CF card fix will still display errors when the card works (got fixes
for that once I know the cure works) but should then be found/usable.

Not signed off by anyone, not for merging


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-core.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-fix-hopefully-all-the-remaining-problems-with drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-hopefully-all-the-remaining-problems-with
+++ a/drivers/ata/libata-core.c
@@ -2407,6 +2407,10 @@ static int ata_dev_set_mode(struct ata_d
 		dev->flags |= ATA_DFLAG_PIO;
 
 	err_mask = ata_dev_set_xfermode(dev);
+	/* Old CFA may refuse this command, which is just fine */
+	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
+        	err_mask &= ~AC_ERR_DEV;
+
 	if (err_mask) {
 		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
 			       "(err_mask=0x%x)\n", err_mask);
@@ -5091,6 +5095,7 @@ inline unsigned int ata_host_intr (struc
 {
 	struct ata_eh_info *ehi = &ap->eh_info;
 	u8 status, host_stat = 0;
+	int i;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
 		ap->id, qc->tf.protocol, ap->hsm_task_state);
@@ -5146,6 +5151,20 @@ inline unsigned int ata_host_intr (struc
 	if (unlikely(status & ATA_BUSY))
 		goto idle_irq;
 
+	if (unlikely(qc->tf.command == ATA_CMD_SET_FEATURES &&
+			qc->tf.feature == SETFEATURES_XFER)) {
+		/* Let the timings change settle and the drive catch up as
+		   some hardware needs up to 10uS to get its brain back in
+		   gear. Taken from the workarounds in drivers/ide done by
+		   Matthew Faupel/Niccolo Rigacci */
+		for (i = 0; i < 10; i++) {
+			if ((status & (ATA_BUSY | ATA_DRQ | ATA_ERR)) == 0)
+				break;
+			udelay(1);
+			status = ata_chk_status(ap);
+		}
+	}
+
 	/* ack bmdma irq events */
 	ap->ops->irq_clear(ap);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

via-quirk-fix-update.patch
git-libata-all.patch
pata_atiixp-propogate-cable-detection-hack-from.patch
pata_via-correct-missing-comments.patch
sis-warning-fixes.patch
ata_busy_wait-kerneldoc-fixes.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
ubi-int-versus-size_t-printk-warnings.patch
atl1_main-pci_module_int-returns-to-haunt-us.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
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
sched-avoid-div-in-rebalance_tick.patch
pm3fb-kill-pci_find_device-usage.patch
