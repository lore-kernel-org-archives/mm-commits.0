From: akpm@google.com
Subject: [merged] floppy-use-del_timer_sync-in-init-cleanup.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:03 -0700
Message-ID: <201109222100.p8ML04Yq004655@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: C.Emde@osadl.org, axboe@kernel.dk, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: floppy: use del_timer_sync() in init cleanup
has been removed from the -mm tree.  Its filename was
     floppy-use-del_timer_sync-in-init-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Carsten Emde <C.Emde@osadl.org>
Subject: floppy: use del_timer_sync() in init cleanup

When no floppy is found the module code can be released while a timer
function is pending or about to be executed.

CPU0                                  CPU1
				      floppy_init()
timer_softirq()
   spin_lock_irq(&base->lock);
   detach_timer();
   spin_unlock_irq(&base->lock);
   -> Interrupt
					del_timer();
				        return -ENODEV;
                                      module_cleanup();
   <- EOI
   call_timer_fn();
   OOPS

Use del_timer_sync() to prevent this.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/floppy.c~floppy-use-del_timer_sync-in-init-cleanup drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-use-del_timer_sync-in-init-cleanup
+++ a/drivers/block/floppy.c
@@ -4250,7 +4250,7 @@ static int __init floppy_init(void)
 	use_virtual_dma = can_use_virtual_dma & 1;
 	fdc_state[0].address = FDC1;
 	if (fdc_state[0].address == -1) {
-		del_timer(&fd_timeout);
+		del_timer_sync(&fd_timeout);
 		err = -ENODEV;
 		goto out_unreg_region;
 	}
@@ -4261,7 +4261,7 @@ static int __init floppy_init(void)
 	fdc = 0;		/* reset fdc in case of unexpected interrupt */
 	err = floppy_grab_irq_and_dma();
 	if (err) {
-		del_timer(&fd_timeout);
+		del_timer_sync(&fd_timeout);
 		err = -EBUSY;
 		goto out_unreg_region;
 	}
@@ -4318,7 +4318,7 @@ static int __init floppy_init(void)
 		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
-	del_timer(&fd_timeout);
+	del_timer_sync(&fd_timeout);
 	current_drive = 0;
 	initialized = true;
 	if (have_no_fdc) {
@@ -4368,7 +4368,7 @@ out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
 	while (dr--) {
-		del_timer(&motor_off_timer[dr]);
+		del_timer_sync(&motor_off_timer[dr]);
 		if (disks[dr]->queue)
 			blk_cleanup_queue(disks[dr]->queue);
 		put_disk(disks[dr]);
_

Patches currently in -mm which might be from C.Emde@osadl.org are

origin.patch

