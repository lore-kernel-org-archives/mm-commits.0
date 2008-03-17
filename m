From: akpm@linux-foundation.org
Subject: - block-floppy-fix-rmmod-lockup.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:58:24 -0700
Message-ID: <200803172058.m2HKwOMY030656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYCQU7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: floppy: fix rmmod lockup
has been removed from the -mm tree.  Its filename was
     block-floppy-fix-rmmod-lockup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: floppy: fix rmmod lockup
From: Jiri Slaby <jirislaby@gmail.com>

Floppy rmmod locks up when no such hardware was initialized, since there is
nobody to wake the remove code up.  Remove the completion, because release is
called during platform_unregister anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/block/floppy.c~block-floppy-fix-rmmod-lockup drivers/block/floppy.c
--- a/drivers/block/floppy.c~block-floppy-fix-rmmod-lockup
+++ a/drivers/block/floppy.c
@@ -217,7 +217,6 @@ static int use_virtual_dma;
  */
 
 static DEFINE_SPINLOCK(floppy_lock);
-static struct completion device_release;
 
 static unsigned short virtual_dma_port = 0x3f0;
 irqreturn_t floppy_interrupt(int irq, void *dev_id);
@@ -4144,7 +4143,6 @@ DEVICE_ATTR(cmos,S_IRUGO,floppy_cmos_sho
 
 static void floppy_device_release(struct device *dev)
 {
-	complete(&device_release);
 }
 
 static struct platform_device floppy_device[N_DRIVE];
@@ -4539,7 +4537,6 @@ void cleanup_module(void)
 {
 	int drive;
 
-	init_completion(&device_release);
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
@@ -4564,8 +4561,6 @@ void cleanup_module(void)
 
 	/* eject disk, if any */
 	fd_eject(0);
-
-	wait_for_completion(&device_release);
 }
 
 module_param(floppy, charp, 0);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch
wdev-ath5k-typecheck-on-nondebug.patch
x86_32-fix-fault_msg-nul-termination.patch
capabilities-implement-per-process-securebits-fix.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
misc-phantom-consistent-whitespace.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

