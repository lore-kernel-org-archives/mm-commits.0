From: akpm@linux-foundation.org
Subject: - reimplement-flush_workqueue.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:53 -0700
Message-ID: <200705092150.l49LorVN002838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758396AbXEIVvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     reimplement flush_workqueue()
has been removed from the -mm tree.  Its filename was
     reimplement-flush_workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reimplement flush_workqueue()
From: Oleg Nesterov <oleg@tv-sign.ru>

Remove ->remove_sequence, ->insert_sequence, and ->work_done from struct
cpu_workqueue_struct.  To implement flush_workqueue() we can queue a
barrier work on each CPU and wait for its completition.

The barrier is queued under workqueue_mutex to ensure that per cpu
wq->cpu_wq is alive, we drop this mutex before going to sleep.  If CPU goes
down while we are waiting for completition, take_over_work() will move the
barrier on another CPU, and the handler will wake up us eventually.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   70 +++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

diff -puN kernel/workqueue.c~reimplement-flush_workqueue kernel/workqueue.c
--- a/kernel/workqueue.c~reimplement-flush_workqueue
+++ a/kernel/workqueue.c
@@ -36,23 +36,13 @@
 /*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
- *
- * The sequence counters are for flush_scheduled_work().  It wants to wait
- * until all currently-scheduled works are completed, but it doesn't
- * want to be livelocked by new, incoming ones.  So it waits until
- * remove_sequence is >= the insert_sequence which pertained when
- * flush_scheduled_work() was called.
  */
 struct cpu_workqueue_struct {
 
 	spinlock_t lock;
 
-	long remove_sequence;	/* Least-recently added (next to run) */
-	long insert_sequence;	/* Next to add */
-
 	struct list_head worklist;
 	wait_queue_head_t more_work;
-	wait_queue_head_t work_done;
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
@@ -138,8 +128,6 @@ static int __run_work(struct cpu_workque
 		f(work);
 
 		spin_lock_irqsave(&cwq->lock, flags);
-		cwq->remove_sequence++;
-		wake_up(&cwq->work_done);
 		ret = 1;
 	}
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -187,7 +175,6 @@ static void __queue_work(struct cpu_work
 	spin_lock_irqsave(&cwq->lock, flags);
 	set_wq_data(work, cwq);
 	list_add_tail(&work->entry, &cwq->worklist);
-	cwq->insert_sequence++;
 	wake_up(&cwq->more_work);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
@@ -338,8 +325,6 @@ static void run_workqueue(struct cpu_wor
 		}
 
 		spin_lock_irqsave(&cwq->lock, flags);
-		cwq->remove_sequence++;
-		wake_up(&cwq->work_done);
 	}
 	cwq->run_depth--;
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -394,6 +379,25 @@ static int worker_thread(void *__cwq)
 	return 0;
 }
 
+struct wq_barrier {
+	struct work_struct	work;
+	struct completion	done;
+};
+
+static void wq_barrier_func(struct work_struct *work)
+{
+	struct wq_barrier *barr = container_of(work, struct wq_barrier, work);
+	complete(&barr->done);
+}
+
+static inline void init_wq_barrier(struct wq_barrier *barr)
+{
+	INIT_WORK(&barr->work, wq_barrier_func);
+	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+
+	init_completion(&barr->done);
+}
+
 static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	if (cwq->thread == current) {
@@ -401,23 +405,18 @@ static void flush_cpu_workqueue(struct c
 		 * Probably keventd trying to flush its own queue. So simply run
 		 * it by hand rather than deadlocking.
 		 */
+		mutex_unlock(&workqueue_mutex);
 		run_workqueue(cwq);
+		mutex_lock(&workqueue_mutex);
 	} else {
-		DEFINE_WAIT(wait);
-		long sequence_needed;
+		struct wq_barrier barr;
 
-		spin_lock_irq(&cwq->lock);
-		sequence_needed = cwq->insert_sequence;
+		init_wq_barrier(&barr);
+		__queue_work(cwq, &barr.work);
 
-		while (sequence_needed - cwq->remove_sequence > 0) {
-			prepare_to_wait(&cwq->work_done, &wait,
-					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&cwq->lock);
-			schedule();
-			spin_lock_irq(&cwq->lock);
-		}
-		finish_wait(&cwq->work_done, &wait);
-		spin_unlock_irq(&cwq->lock);
+		mutex_unlock(&workqueue_mutex);
+		wait_for_completion(&barr.done);
+		mutex_lock(&workqueue_mutex);
 	}
 }
 
@@ -428,29 +427,25 @@ static void flush_cpu_workqueue(struct c
  * Forces execution of the workqueue and blocks until its completion.
  * This is typically used in driver shutdown handlers.
  *
- * This function will sample each workqueue's current insert_sequence number and
- * will sleep until the head sequence is greater than or equal to that.  This
- * means that we sleep until all works which were queued on entry have been
- * handled, but we are not livelocked by new incoming ones.
+ * We sleep until all works which were queued on entry have been handled,
+ * but we are not livelocked by new incoming ones.
  *
  * This function used to run the workqueues itself.  Now we just wait for the
  * helper threads to do it.
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	might_sleep();
-
+	mutex_lock(&workqueue_mutex);
 	if (is_single_threaded(wq)) {
 		/* Always use first cpu's area. */
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
 	} else {
 		int cpu;
 
-		mutex_lock(&workqueue_mutex);
 		for_each_online_cpu(cpu)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
-		mutex_unlock(&workqueue_mutex);
 	}
+	mutex_unlock(&workqueue_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -463,12 +458,9 @@ static struct task_struct *create_workqu
 	spin_lock_init(&cwq->lock);
 	cwq->wq = wq;
 	cwq->thread = NULL;
-	cwq->insert_sequence = 0;
-	cwq->remove_sequence = 0;
 	cwq->freezeable = freezeable;
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
-	init_waitqueue_head(&cwq->work_done);
 
 	if (is_single_threaded(wq))
 		p = kthread_create(worker_thread, cwq, "%s", wq->name);
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
