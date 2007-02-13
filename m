From: akpm@linux-foundation.org
Subject: + make-queue_delayed_work-friendly-to-flush_fork.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:43:45 -0800
Message-ID: <200702130543.l1D5hjrQ022838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161088AbXBMFoC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:44:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     make queue_delayed_work() friendly to flush_fork()
has been added to the -mm tree.  Its filename is
     make-queue_delayed_work-friendly-to-flush_fork.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make queue_delayed_work() friendly to flush_fork()
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently typeof(delayed_work->work.data) is

	"struct workqueue_struct" when the timer is pending

	"struct cpu_workqueue_struct" whe the work is queued

This makes impossible to use flush_fork(delayed_work->work) in addition
to cancel_delayed_work/cancel_rearming_delayed_work, not good.

Change queue_delayed_work/delayed_work_timer_fn to use cwq, not wq. This
complicates (and uglifies) these functions a little bit, but alows us to
use flush_fork(dwork) and imho makes the whole code more consistent.

Also, document the fact that cancel_rearming_delayed_work() doesn't garantee
the completion of work->func() upon return.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    2 +-
 kernel/workqueue.c        |   28 ++++++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff -puN include/linux/workqueue.h~make-queue_delayed_work-friendly-to-flush_fork include/linux/workqueue.h
--- a/include/linux/workqueue.h~make-queue_delayed_work-friendly-to-flush_fork
+++ a/include/linux/workqueue.h
@@ -193,7 +193,7 @@ int execute_in_process_context(work_func
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work().  Run
- * flush_scheduled_work() or flush_work() to wait on it.
+ * flush_workqueue() or flush_work() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
diff -puN kernel/workqueue.c~make-queue_delayed_work-friendly-to-flush_fork kernel/workqueue.c
--- a/kernel/workqueue.c~make-queue_delayed_work-friendly-to-flush_fork
+++ a/kernel/workqueue.c
@@ -90,18 +90,20 @@ static const cpumask_t *wq_cpu_map(struc
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
  */
-static inline void set_wq_data(struct work_struct *work, void *wq)
+static inline void set_wq_data(struct work_struct *work,
+				struct cpu_workqueue_struct *cwq)
 {
 	unsigned long new;
 
 	BUG_ON(!work_pending(work));
 
-	new = (unsigned long) wq | (1UL << WORK_STRUCT_PENDING);
+	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
 	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
 	atomic_long_set(&work->data, new);
 }
 
-static inline void *get_wq_data(struct work_struct *work)
+static inline
+struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
@@ -157,7 +159,8 @@ EXPORT_SYMBOL_GPL(queue_work);
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct workqueue_struct *wq = get_wq_data(&dwork->work);
+	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
+	struct workqueue_struct *wq = cwq->wq;
 	int cpu = smp_processor_id();
 
 	if (unlikely(is_single_threaded(wq)))
@@ -189,8 +192,9 @@ int fastcall queue_delayed_work(struct w
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		/* This stores wq for the moment, for the timer_fn */
-		set_wq_data(work, wq);
+		/* This stores cwq for the moment, for the timer_fn */
+		set_wq_data(work,
+			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -221,8 +225,9 @@ int queue_delayed_work_on(int cpu, struc
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		/* This stores wq for the moment, for the timer_fn */
-		set_wq_data(work, wq);
+		/* This stores cwq for the moment, for the timer_fn */
+		set_wq_data(work,
+			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -562,9 +567,12 @@ void flush_work_keventd(struct work_stru
 EXPORT_SYMBOL(flush_work_keventd);
 
 /**
- * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_workqueue - kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
  * @dwork: the delayed work struct
+ *
+ * Note that the work callback function may still be running on return from
+ * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
  */
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 				       struct delayed_work *dwork)
@@ -579,7 +587,7 @@ void cancel_rearming_delayed_workqueue(s
 EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);
 
 /**
- * cancel_rearming_delayed_work - reliably kill off a delayed keventd work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_work - kill off a delayed keventd work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
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
