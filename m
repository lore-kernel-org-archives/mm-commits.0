From: akpm@linux-foundation.org
Subject: - implement-flush_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:55 -0700
Message-ID: <200705092150.l49LotcI002841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758396AbXEIVvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     implement flush_work()
has been removed from the -mm tree.  Its filename was
     implement-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: implement flush_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

A basic problem with flush_scheduled_work() is that it blocks behind _all_
presently-queued works, rather than just the work whcih the caller wants to
flush.  If the caller holds some lock, and if one of the queued work happens
to want that lock as well then accidental deadlocks can occur.

One example of this is the phy layer: it wants to flush work while holding
rtnl_lock().  But if a linkwatch event happens to be queued, the phy code will
deadlock because the linkwatch callback function takes rtnl_lock.

So we implement a new function which will flush a *single* work - just the one
which the caller wants to free up.  Thus we avoid the accidental deadlocks
which can arise from unrelated subsystems' callbacks taking shared locks.


flush_work() non-blockingly dequeues the work_struct which we want to kill,
then it waits for its handler to complete on all CPUs.

Add ->current_work to the "struct cpu_workqueue_struct", it points to
currently running "struct work_struct". When flush_work(work) detects
->current_work == work, it inserts a barrier at the _head_ of ->worklist
(and thus right _after_ that work) and waits for completition. This means
that the next work fired on that CPU will be this barrier, or another
barrier queued by concurrent flush_work(), so the caller of flush_work()
will be woken before any "regular" work has a chance to run.

When wait_on_work() unlocks workqueue_mutex (or whatever we choose to protect
against CPU hotplug), CPU may go away. But in that case take_over_work() will
move a barrier we queued to another CPU, it will be fired sometime, and
wait_on_work() will be woken.

Actually, we are doing cleanup_workqueue_thread()->kthread_stop() before
take_over_work(), so cwq->thread should complete its ->worklist (and thus
the barrier), because currently we don't check kthread_should_stop() in
run_workqueue(). But even if we did, everything should be ok.

[akpm@osdl.org: cleanup]
[akpm@osdl.org: add flush_work_keventd() wrapper]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    4 +
 kernel/workqueue.c        |   95 ++++++++++++++++++++++++++++++++++--
 2 files changed, 95 insertions(+), 4 deletions(-)

diff -puN include/linux/workqueue.h~implement-flush_work include/linux/workqueue.h
--- a/include/linux/workqueue.h~implement-flush_work
+++ a/include/linux/workqueue.h
@@ -178,6 +178,8 @@ extern int FASTCALL(queue_delayed_work(s
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct delayed_work *work, unsigned long delay);
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
+extern void flush_work(struct workqueue_struct *wq, struct work_struct *work);
+extern void flush_work_keventd(struct work_struct *work);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
 extern int FASTCALL(run_scheduled_work(struct work_struct *work));
@@ -199,7 +201,7 @@ int execute_in_process_context(work_func
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work(), unless
  * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
- * cancel_work_sync() to wait on it.
+ * flush_work() or cancel_work_sync() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
diff -puN kernel/workqueue.c~implement-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~implement-flush_work
+++ a/kernel/workqueue.c
@@ -46,6 +46,7 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
+	struct work_struct *current_work;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 
@@ -120,6 +121,7 @@ static int __run_work(struct cpu_workque
 	    && work_pending(work)
 	    && !list_empty(&work->entry)) {
 		work_func_t f = work->func;
+		cwq->current_work = work;
 		list_del_init(&work->entry);
 		spin_unlock_irqrestore(&cwq->lock, flags);
 
@@ -128,6 +130,7 @@ static int __run_work(struct cpu_workque
 		f(work);
 
 		spin_lock_irqsave(&cwq->lock, flags);
+		cwq->current_work = NULL;
 		ret = 1;
 	}
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -166,6 +169,17 @@ int fastcall run_scheduled_work(struct w
 }
 EXPORT_SYMBOL(run_scheduled_work);
 
+static void insert_work(struct cpu_workqueue_struct *cwq,
+				struct work_struct *work, int tail)
+{
+	set_wq_data(work, cwq);
+	if (tail)
+		list_add_tail(&work->entry, &cwq->worklist);
+	else
+		list_add(&work->entry, &cwq->worklist);
+	wake_up(&cwq->more_work);
+}
+
 /* Preempt must be disabled. */
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
@@ -173,9 +187,7 @@ static void __queue_work(struct cpu_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
-	set_wq_data(work, cwq);
-	list_add_tail(&work->entry, &cwq->worklist);
-	wake_up(&cwq->more_work);
+	insert_work(cwq, work, 1);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -305,6 +317,7 @@ static void run_workqueue(struct cpu_wor
 						struct work_struct, entry);
 		work_func_t f = work->func;
 
+		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irqrestore(&cwq->lock, flags);
 
@@ -325,6 +338,7 @@ static void run_workqueue(struct cpu_wor
 		}
 
 		spin_lock_irqsave(&cwq->lock, flags);
+		cwq->current_work = NULL;
 	}
 	cwq->run_depth--;
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -449,6 +463,75 @@ void fastcall flush_workqueue(struct wor
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
+static void wait_on_work(struct cpu_workqueue_struct *cwq,
+				struct work_struct *work)
+{
+	struct wq_barrier barr;
+	int running = 0;
+
+	spin_lock_irq(&cwq->lock);
+	if (unlikely(cwq->current_work == work)) {
+		init_wq_barrier(&barr);
+		insert_work(cwq, &barr.work, 0);
+		running = 1;
+	}
+	spin_unlock_irq(&cwq->lock);
+
+	if (unlikely(running)) {
+		mutex_unlock(&workqueue_mutex);
+		wait_for_completion(&barr.done);
+		mutex_lock(&workqueue_mutex);
+	}
+}
+
+/**
+ * flush_work - block until a work_struct's callback has terminated
+ * @wq: the workqueue on which the work is queued
+ * @work: the work which is to be flushed
+ *
+ * flush_work() will attempt to cancel the work if it is queued.  If the work's
+ * callback appears to be running, flush_work() will block until it has
+ * completed.
+ *
+ * flush_work() is designed to be used when the caller is tearing down data
+ * structures which the callback function operates upon.  It is expected that,
+ * prior to calling flush_work(), the caller has arranged for the work to not
+ * be requeued.
+ */
+void flush_work(struct workqueue_struct *wq, struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq;
+
+	mutex_lock(&workqueue_mutex);
+	cwq = get_wq_data(work);
+	/* Was it ever queued ? */
+	if (!cwq)
+		goto out;
+
+	/*
+	 * This work can't be re-queued, and the lock above protects us
+	 * from take_over_work(), no need to re-check that get_wq_data()
+	 * is still the same when we take cwq->lock.
+	 */
+	spin_lock_irq(&cwq->lock);
+	list_del_init(&work->entry);
+	work_release(work);
+	spin_unlock_irq(&cwq->lock);
+
+	if (is_single_threaded(wq)) {
+		/* Always use first cpu's area. */
+		wait_on_work(per_cpu_ptr(wq->cpu_wq, singlethread_cpu), work);
+	} else {
+		int cpu;
+
+		for_each_online_cpu(cpu)
+			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+	}
+out:
+	mutex_unlock(&workqueue_mutex);
+}
+EXPORT_SYMBOL_GPL(flush_work);
+
 static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
 						   int cpu, int freezeable)
 {
@@ -650,6 +733,12 @@ void flush_scheduled_work(void)
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
+void flush_work_keventd(struct work_struct *work)
+{
+	flush_work(keventd_wq, work);
+}
+EXPORT_SYMBOL(flush_work_keventd);
+
 /**
  * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
