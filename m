From: akpm@linux-foundation.org
Subject: + libata-early-cfa-adapters-are-not-required-to-support-mode.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:52:37 -0800
Message-ID: <200702052252.l15MqbJv001745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37271 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927AbXBEWwx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: Early CFA adapters are not required to support mode setting
has been added to the -mm tree.  Its filename is
     libata-early-cfa-adapters-are-not-required-to-support-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: Early CFA adapters are not required to support mode setting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

If we are doing a PIO setup for a CFA card and it blows up with a device error
then assume it is an older CFA card which doesn't support this rather than
failing the device out of existance.

Stands seperate to the quieting patch but that is obviously useful with this
change.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-early-cfa-adapters-are-not-required-to-support-mode drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-early-cfa-adapters-are-not-required-to-support-mode
+++ a/drivers/ata/libata-core.c
@@ -2337,6 +2337,10 @@ static int ata_dev_set_mode(struct ata_d
 		dev->flags |= ATA_DFLAG_PIO;
 
 	err_mask = ata_dev_set_xfermode(dev);
+	/* Old CFA may refuse this command, which is just fine */
+	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
+        	err_mask &= ~AC_ERR_DEV;
+
 	if (err_mask) {
 		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
 			       "(err_mask=0x%x)\n", err_mask);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
sis-warning-fixes.patch
kconfig-clarify-ata_piix-description.patch
ata-add-defines-for-the-iordy-bits.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
libata-early-cfa-adapters-are-not-required-to-support-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
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
geode-configuration-fixes.patch
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
