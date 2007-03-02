From: akpm@linux-foundation.org
Subject: + freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch added to -mm tree
Date: Thu, 01 Mar 2007 16:55:34 -0800
Message-ID: <200703020055.l220tYb0028050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422666AbXCBA4F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 19:56:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com


The patch titled
     freezer: add try_to_freeze calls to all kernel threads
has been added to the -mm tree.  Its filename is
     freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c              |    2 ++
 drivers/block/loop.c                |    2 ++
 drivers/char/apm-emulation.c        |    3 +++
 drivers/ieee1394/ieee1394_core.c    |    3 +++
 drivers/md/md.c                     |    2 ++
 drivers/mmc/card/queue.c            |    3 +++
 drivers/mtd/mtd_blkdevs.c           |    3 +++
 drivers/scsi/libsas/sas_scsi_host.c |    3 +++
 drivers/scsi/scsi_error.c           |    3 +++
 drivers/usb/storage/usb.c           |    2 ++
 kernel/softirq.c                    |    2 ++
 kernel/softlockup.c                 |    2 ++
 12 files changed, 30 insertions(+)

diff -puN arch/i386/kernel/apm.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/arch/i386/kernel/apm.c
@@ -227,6 +227,7 @@
 #include <linux/dmi.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -1402,6 +1403,7 @@ static void apm_mainloop(void)
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
 
@@ -580,6 +581,7 @@ static int loop_thread(void *data)
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
@@ -35,6 +35,7 @@
 #include <linux/kthread.h>
 #include <linux/preempt.h>
 #include <linux/time.h>
+#include <linux/freezer.h>
 
 #include <asm/system.h>
 #include <asm/byteorder.h>
@@ -1081,6 +1082,8 @@ static int hpsbpkt_thread(void *__hi)
 			complete_routine(complete_data);
 		}
 
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!skb_peek(&hpsbpkt_queue))
 			schedule();
diff -puN drivers/md/md.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/md/md.c
--- a/drivers/md/md.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/md/md.c
@@ -4526,6 +4526,8 @@ static int md_thread(void * arg)
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
@@ -20,6 +20,7 @@
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 
 static LIST_HEAD(blktrans_majors);
@@ -113,6 +114,8 @@ static int mtd_blktrans_thread(void *arg
 			schedule();
 			remove_wait_queue(&tr->blkcore_priv->thread_wq, &wait);
 
+			try_to_freeze();
+
 			spin_lock_irq(rq->queue_lock);
 
 			continue;
diff -puN drivers/scsi/libsas/sas_scsi_host.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~freezer-add-try_to_freeze-calls-to-all-kernel-threads
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -39,6 +39,7 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
+#include <linux/freezer.h>
 
 /* ---------- SCSI Host glue ---------- */
 
@@ -875,6 +876,8 @@ static int sas_queue_thread(void *_sas_h
 	complete(&queue_th_comp);
 
 	while (1) {
+		try_to_freeze();
+
 		down_interruptible(&core->queue_thread_sema);
 		sas_queue(sas_ha);
 		if (core->queue_thread_kill)
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
@@ -1536,6 +1537,8 @@ int scsi_error_handler(void *data)
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
 
@@ -93,6 +94,7 @@ static int watchdog(void * __bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
+		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
_

Patches currently in -mm which might be from rjw@sisk.pl are

make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
