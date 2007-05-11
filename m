From: akpm@linux-foundation.org
Subject: - freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch removed from -mm tree
Date: Fri, 11 May 2007 12:28:50 -0700
Message-ID: <200705111928.l4BJSoLh024563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759894AbXEKTaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, James.Bottomley@steeleye.com, aneesh.kumar@gmail.com, drzeus@drzeus.cx, dwmw2@infradead.org, ego@in.ibm.com, greg@kroah.com, mingo@elte.hu, neilb@suse.de, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, stefanr@s5r6.in-berlin.de, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer: add try_to_freeze calls to all kernel threads
has been removed from the -mm tree.  Its filename was
     freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: freezer: add try_to_freeze calls to all kernel threads
From: Rafael J. Wysocki <rjw@sisk.pl>

Add try_to_freeze() calls to the remaining kernel threads that do not call
try_to_freeze() already, although they set PF_NOFREEZE.

In the future we are going to replace PF_NOFREEZE with a set of flags that
will be set to indicate in which situations the task should not be frozen (for
example, there can be a task that should be frozen for the CPU hotplugging and
should not be frozen for the system suspend).  For this reason every kernel
thread should be able to freeze itself (ie.  call try_to_freeze()), so that it
can be frozen whenever necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c              |    2 ++
 drivers/block/loop.c                |    2 ++
 drivers/char/apm-emulation.c        |    3 +++
 drivers/ieee1394/ieee1394_core.c    |    3 +++
 drivers/md/md.c                     |    2 ++
 drivers/mmc/card/queue.c            |    3 +++
 drivers/mtd/mtd_blkdevs.c           |    3 +++
 drivers/scsi/libsas/sas_scsi_host.c |    2 ++
 drivers/scsi/scsi_error.c           |    3 +++
 drivers/usb/storage/usb.c           |    2 ++
 kernel/softirq.c                    |    2 ++
 kernel/softlockup.c                 |    2 ++
 12 files changed, 29 insertions(+)

diff -puN arch/i386/kernel/apm.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/arch/i386/kernel/apm.c
@@ -226,6 +226,7 @@
 #include <linux/dmi.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -1393,6 +1394,7 @@ static void apm_mainloop(void)
 	add_wait_queue(&apm_waitqueue, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	for (;;) {
+		try_to_freeze();
 		schedule_timeout(APM_CHECK_TIMEOUT);
 		if (kthread_should_stop())
 			break;
diff -puN drivers/block/loop.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/block/loop.c
--- a/drivers/block/loop.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/block/loop.c
@@ -74,6 +74,7 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
@@ -586,6 +587,7 @@ static int loop_thread(void *data)
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop() || lo->lo_bio) {
+		try_to_freeze();
 
 		wait_event_interruptible(lo->lo_event,
 				lo->lo_bio || kthread_should_stop());
diff -puN drivers/char/apm-emulation.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/char/apm-emulation.c
@@ -27,6 +27,7 @@
 #include <linux/completion.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 
@@ -539,6 +540,8 @@ static int kapmd(void *arg)
 		apm_event_t event;
 		int ret;
 
+		try_to_freeze();
+
 		wait_event_interruptible(kapmd_wait,
 				!queue_empty(&kapmd_queue) || kthread_should_stop());
 
diff -puN drivers/ieee1394/ieee1394_core.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -34,6 +34,7 @@
 #include <linux/kthread.h>
 #include <linux/preempt.h>
 #include <linux/time.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/byteorder.h>
@@ -1147,6 +1148,8 @@ static int hpsbpkt_thread(void *__hi)
 			packet->complete_routine(packet->complete_data);
 		}
 
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock_irq(&pending_packets_lock);
 		may_schedule = list_empty(&hpsbpkt_queue);
diff -puN drivers/md/md.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/md/md.c
--- a/drivers/md/md.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/md/md.c
@@ -4652,6 +4652,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
+		try_to_freeze();
+
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 
 		thread->run(thread->mddev);
diff -puN drivers/mmc/card/queue.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/mmc/card/queue.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -71,6 +72,8 @@ static int mmc_queue_thread(void *d)
 	do {
 		struct request *req = NULL;
 
+		try_to_freeze();
+
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!blk_queue_plugged(q))
diff -puN drivers/mtd/mtd_blkdevs.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/mtd/blktrans.h>
 #include <linux/mtd/mtd.h>
+#include <linux/freezer.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/spinlock.h>
@@ -107,6 +108,8 @@ static int mtd_blktrans_thread(void *arg
 		res = do_blktrans_request(tr, dev, req);
 		mutex_unlock(&dev->lock);
 
+			try_to_freeze();
+
 		spin_lock_irq(rq->queue_lock);
 
 		end_request(req, res);
diff -puN drivers/scsi/libsas/sas_scsi_host.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -41,6 +41,7 @@
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/scatterlist.h>
 #include <linux/libata.h>
 
@@ -906,6 +907,7 @@ static int sas_queue_thread(void *_sas_h
 	current->flags |= PF_NOFREEZE;
 
 	while (1) {
+		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 		sas_queue(sas_ha);
diff -puN drivers/scsi/scsi_error.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/scsi/scsi_error.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1546,6 +1547,8 @@ int scsi_error_handler(void *data)
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
+		try_to_freeze();
+
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
diff -puN drivers/usb/storage/usb.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/usb/storage/usb.c
@@ -304,6 +304,8 @@ static int usb_stor_control_thread(void 
 	current->flags |= PF_NOFREEZE;
 
 	for(;;) {
+		try_to_freeze();
+
 		US_DEBUGP("*** thread sleeping.\n");
 		if(down_interruptible(&us->sema))
 			break;
diff -puN kernel/softirq.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads kernel/softirq.c
--- a/kernel/softirq.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/kernel/softirq.c
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <linux/freezer.h>
 
 #include <asm/irq.h>
 /*
@@ -494,6 +495,7 @@ static int ksoftirqd(void * __bind_cpu)
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
+		try_to_freeze();
 		preempt_disable();
 		if (!local_softirq_pending()) {
 			preempt_enable_no_resched();
diff -puN kernel/softlockup.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads kernel/softlockup.c
--- a/kernel/softlockup.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/kernel/softlockup.c
@@ -13,6 +13,7 @@
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/freezer.h>
 
 static DEFINE_SPINLOCK(print_lock);
 
@@ -127,6 +128,7 @@ static int watchdog(void * __bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
+		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
