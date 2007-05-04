From: akpm@linux-foundation.org
Subject: + make-cancel_rearming_delayed_work-reliable.patch added to -mm tree
Date: Thu, 03 May 2007 18:13:38 -0700
Message-ID: <200705040113.l441Dc5g026433@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501AbXEDBOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dgc@sgi.com, dhowells@redhat.com, ego@in.ibm.com, jarkao2@o2.pl, vatsa@in.ibm.com


The patch titled
     make cancel_rearming_delayed_work() reliable
has been added to the -mm tree.  Its filename is
     make-cancel_rearming_delayed_work-reliable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make cancel_rearming_delayed_work() reliable
From: Oleg Nesterov <oleg@tv-sign.ru>

Thanks to Jarek Poplawski for the ideas and for spotting the bug in the
initial draft patch.

cancel_rearming_delayed_work() currently has many limitations, because it
requires that dwork always re-arms itself via queue_delayed_work().  So it
hangs forever if dwork doesn't do this, or cancel_rearming_delayed_work/
cancel_delayed_work was already called.  It uses flush_workqueue() in a
loop, so it can't be used if workqueue was freezed, and it is potentially
live- lockable on busy system if delay is small.

With this patch cancel_rearming_delayed_work() doesn't make any assumptions
about dwork, it can re-arm itself via queue_delayed_work(), or
queue_work(), or do nothing.

As a "side effect", cancel_work_sync() was changed to handle re-arming works
as well.

Disadvantages:

	- this patch adds wmb() to insert_work().

	- slowdowns the fast path (when del_timer() succeeds on entry) of
	  cancel_rearming_delayed_work(), because wait_on_work() is called
	  unconditionally. In that case, compared to the old version, we are
	  doing "unneeded" lock/unlock for each online CPU.

	  On the other hand, this means we don't need to use cancel_work_sync()
	  after cancel_rearming_delayed_work().

	- complicates the code (.text grows by 130 bytes).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Chinner <dgc@sgi.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |  137 +++++++++++++++++++++++++++----------------
 1 files changed, 88 insertions(+), 49 deletions(-)

diff -puN kernel/workqueue.c~make-cancel_rearming_delayed_work-reliable kernel/workqueue.c
--- a/kernel/workqueue.c~make-cancel_rearming_delayed_work-reliable
+++ a/kernel/workqueue.c
@@ -120,6 +120,11 @@ static void insert_work(struct cpu_workq
 				struct work_struct *work, int tail)
 {
 	set_wq_data(work, cwq);
+	/*
+	 * Ensure that we get the right work->data if we see the
+	 * result of list_add() below, see try_to_grab_pending().
+	 */
+	smp_wmb();
 	if (tail)
 		list_add_tail(&work->entry, &cwq->worklist);
 	else
@@ -383,7 +388,46 @@ void fastcall flush_workqueue(struct wor
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
-static void wait_on_work(struct cpu_workqueue_struct *cwq,
+/*
+ * Upon a successfull return, the caller "owns" WORK_STRUCT_PENDING bit,
+ * so this work can't be re-armed in any way.
+ */
+static int try_to_grab_pending(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq;
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+		return 1;
+
+	/*
+	 * The queueing is in progress, or it is already queued. Try to
+	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
+	 */
+
+	cwq = get_wq_data(work);
+	if (!cwq)
+		return ret;
+
+	spin_lock_irq(&cwq->lock);
+	if (!list_empty(&work->entry)) {
+		/*
+		 * This work is queued, but perhaps we locked the wrong cwq.
+		 * In that case we must see the new value after rmb(), see
+		 * insert_work()->wmb().
+		 */
+		smp_rmb();
+		if (cwq == get_wq_data(work)) {
+			list_del_init(&work->entry);
+			ret = 1;
+		}
+	}
+	spin_unlock_irq(&cwq->lock);
+
+	return ret;
+}
+
+static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
 	struct wq_barrier barr;
@@ -400,20 +444,7 @@ static void wait_on_work(struct cpu_work
 		wait_for_completion(&barr.done);
 }
 
-/**
- * cancel_work_sync - block until a work_struct's callback has terminated
- * @work: the work which is to be flushed
- *
- * cancel_work_sync() will attempt to cancel the work if it is queued. If the
- * work's callback appears to be running, cancel_work_sync() will block until
- * it has completed.
- *
- * cancel_work_sync() is designed to be used when the caller is tearing down
- * data structures which the callback function operates upon. It is expected
- * that, prior to calling cancel_work_sync(), the caller has arranged for the
- * work to not be requeued.
- */
-void cancel_work_sync(struct work_struct *work)
+static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
@@ -423,29 +454,59 @@ void cancel_work_sync(struct work_struct
 	might_sleep();
 
 	cwq = get_wq_data(work);
-	/* Was it ever queued ? */
 	if (!cwq)
 		return;
 
-	/*
-	 * This work can't be re-queued, no need to re-check that
-	 * get_wq_data() is still the same when we take cwq->lock.
-	 */
-	spin_lock_irq(&cwq->lock);
-	list_del_init(&work->entry);
-	work_clear_pending(work);
-	spin_unlock_irq(&cwq->lock);
-
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu_mask(cpu, *cpu_map)
-		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+}
+
+/**
+ * cancel_work_sync - block until a work_struct's callback has terminated
+ * @work: the work which is to be flushed
+ *
+ * cancel_work_sync() will cancel the work if it is queued. If the work's
+ * callback appears to be running, cancel_work_sync() will block until it
+ * has completed.
+ *
+ * It is possible to use this function if the work re-queues itself. It can
+ * cancel the work even if it migrates to another workqueue, however in that
+ * case it only garantees that work->func() has completed on the last queued
+ * workqueue.
+ *
+ * The caller must ensure that workqueue_struct on which this work was last
+ * queued can't be destroyed before this function returns.
+ */
+void cancel_work_sync(struct work_struct *work)
+{
+	while (!try_to_grab_pending(work))
+		;
+	wait_on_work(work);
+	work_clear_pending(work);
 }
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
+/**
+ * cancel_rearming_delayed_work - reliably kill off a delayed work.
+ * @dwork: the delayed work struct
+ *
+ * It is possible to use this function if dwork rearms itself via queue_work()
+ * or queue_delayed_work(). See also the comment for cancel_work_sync().
+ */
+void cancel_rearming_delayed_work(struct delayed_work *dwork)
+{
+	while (!del_timer(&dwork->timer) &&
+	       !try_to_grab_pending(&dwork->work))
+		;
+	wait_on_work(&dwork->work);
+	work_clear_pending(&dwork->work);
+}
+EXPORT_SYMBOL(cancel_rearming_delayed_work);
 
-static struct workqueue_struct *keventd_wq;
+static struct workqueue_struct *keventd_wq __read_mostly;
 
 /**
  * schedule_work - put work task in global workqueue
@@ -532,28 +593,6 @@ void flush_scheduled_work(void)
 EXPORT_SYMBOL(flush_scheduled_work);
 
 /**
- * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
- * @dwork: the delayed work struct
- *
- * Note that the work callback function may still be running on return from
- * cancel_delayed_work(). Run flush_workqueue() or cancel_work_sync() to wait
- * on it.
- */
-void cancel_rearming_delayed_work(struct delayed_work *dwork)
-{
-	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-
-	/* Was it ever queued ? */
-	if (cwq != NULL) {
-		struct workqueue_struct *wq = cwq->wq;
-
-		while (!cancel_delayed_work(dwork))
-			flush_workqueue(wq);
-	}
-}
-EXPORT_SYMBOL(cancel_rearming_delayed_work);
-
-/**
  * execute_in_process_context - reliably execute the routine with user context
  * @fn:		the function to execute
  * @ew:		guaranteed storage for the execute work structure (must
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
fix-refrigerator-vs-thaw_process-race.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
futex-restartable-futex_wait.patch
add-support-for-deferrable-timers-respun.patch
add-a-new-deferrable-delayed-work-init.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
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
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
worker_thread-dont-play-with-signals.patch
worker_thread-fix-racy-try_to_freeze-usage.patch
zap_other_threads-remove-unneeded-exit_signal-change.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
____call_usermodehelper-dont-flush_signals.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
kthread-dont-depend-on-work-queues-take-2.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
usbatm_heavy_init-dont-use-clone_sighand.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
dont-init-pgrp-and-__session-in-init_signals.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
