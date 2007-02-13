From: akpm@linux-foundation.org
Subject: + unify-queue_delayed_work-and-queue_delayed_work_on.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:44:07 -0800
Message-ID: <200702130544.l1D5i7tX022845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55410 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161087AbXBMFoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     unify queue_delayed_work() and queue_delayed_work_on()
has been added to the -mm tree.  Its filename is
     unify-queue_delayed_work-and-queue_delayed_work_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unify queue_delayed_work() and queue_delayed_work_on()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change queue_delayed_work() to use queue_delayed_work_on() to avoid the code
duplication (saves 133 bytes).

Q: queue_delayed_work() enqueues &dwork->work directly when delay == 0, why?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff -puN kernel/workqueue.c~unify-queue_delayed_work-and-queue_delayed_work_on kernel/workqueue.c
--- a/kernel/workqueue.c~unify-queue_delayed_work-and-queue_delayed_work_on
+++ a/kernel/workqueue.c
@@ -180,28 +180,11 @@ void delayed_work_timer_fn(unsigned long
 int fastcall queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	int ret = 0;
-	struct timer_list *timer = &dwork->timer;
-	struct work_struct *work = &dwork->work;
-
-	timer_stats_timer_set_start_info(timer);
+	timer_stats_timer_set_start_info(&dwork->timer);
 	if (delay == 0)
-		return queue_work(wq, work);
+		return queue_work(wq, &dwork->work);
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
-
-		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
-		timer->expires = jiffies + delay;
-		timer->data = (unsigned long)dwork;
-		timer->function = delayed_work_timer_fn;
-		add_timer(timer);
-		ret = 1;
-	}
-	return ret;
+	return queue_delayed_work_on(-1, wq, dwork, delay);
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work);
 
@@ -231,7 +214,11 @@ int queue_delayed_work_on(int cpu, struc
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
-		add_timer_on(timer, cpu);
+
+		if (unlikely(cpu >= 0))
+			add_timer_on(timer, cpu);
+		else
+			add_timer(timer);
 		ret = 1;
 	}
 	return ret;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-block.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
