From: akpm@linux-foundation.org
Subject: + simplify-cleanup_workqueue_thread.patch added to -mm tree
Date: Fri, 18 May 2007 13:58:37 -0700
Message-ID: <200705182058.l4IKwbGU023385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXERVCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 17:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, rjw@sisk.pl, vatsa@in.ibm.com, zilvinas@wilibox.com


The patch titled
     simplify cleanup_workqueue_thread()
has been added to the -mm tree.  Its filename is
     simplify-cleanup_workqueue_thread.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: simplify cleanup_workqueue_thread()
From: Oleg Nesterov <oleg@tv-sign.ru>

cleanup_workqueue_thread() and cwq_should_stop() are overcomplicated. 
Convert the code to use kthread_should_stop/kthread_stop as was suggested
by Gautham and Srivatsa.

In particular this patch removes the (unlikely) busy-wait loop from the
exit path, it was a temporary and ugly kludge (if not a bug).

Note: the current code was designed to solve another old problem: work->func
can't share locks with hotplug callbacks. I think this could be done, see

	http://marc.info/?l=linux-kernel&m=116905366428633

but this needs some more complications to preserve CPU affinity of
cwq->thread during cpu_up().  A freezer-based hotplug looks more appealing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Zilvinas Valinskas <zilvinas@wilibox.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   80 ++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 46 deletions(-)

diff -puN kernel/workqueue.c~simplify-cleanup_workqueue_thread kernel/workqueue.c
--- a/kernel/workqueue.c~simplify-cleanup_workqueue_thread
+++ a/kernel/workqueue.c
@@ -47,7 +47,6 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-	int should_stop;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -71,7 +70,13 @@ static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
 static cpumask_t cpu_singlethread_map __read_mostly;
-/* optimization, we could use cpu_possible_map */
+/*
+ * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
+ * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
+ * which comes in between can't use for_each_online_cpu(). We could
+ * use cpu_possible_map, the cpumask below is more a documentation
+ * than optimization.
+ */
 static cpumask_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
@@ -272,24 +277,6 @@ static void run_workqueue(struct cpu_wor
 	spin_unlock_irq(&cwq->lock);
 }
 
-/*
- * NOTE: the caller must not touch *cwq if this func returns true
- */
-static int cwq_should_stop(struct cpu_workqueue_struct *cwq)
-{
-	int should_stop = cwq->should_stop;
-
-	if (unlikely(should_stop)) {
-		spin_lock_irq(&cwq->lock);
-		should_stop = cwq->should_stop && list_empty(&cwq->worklist);
-		if (should_stop)
-			cwq->thread = NULL;
-		spin_unlock_irq(&cwq->lock);
-	}
-
-	return should_stop;
-}
-
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
@@ -302,14 +289,15 @@ static int worker_thread(void *__cwq)
 
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!freezing(current) && !cwq->should_stop
-		    && list_empty(&cwq->worklist))
+		if (!freezing(current) &&
+		    !kthread_should_stop() &&
+		    list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
 		try_to_freeze();
 
-		if (cwq_should_stop(cwq))
+		if (kthread_should_stop())
 			break;
 
 		run_workqueue(cwq);
@@ -340,7 +328,7 @@ static void insert_wq_barrier(struct cpu
 	insert_work(cwq, &barr->work, tail);
 }
 
-static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
+static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	if (cwq->thread == current) {
 		/*
@@ -348,6 +336,7 @@ static void flush_cpu_workqueue(struct c
 		 * it by hand rather than deadlocking.
 		 */
 		run_workqueue(cwq);
+		return 1;
 	} else {
 		struct wq_barrier barr;
 		int active = 0;
@@ -361,6 +350,8 @@ static void flush_cpu_workqueue(struct c
 
 		if (active)
 			wait_for_completion(&barr.done);
+
+		return active;
 	}
 }
 
@@ -674,7 +665,6 @@ static int create_workqueue_thread(struc
 		return PTR_ERR(p);
 
 	cwq->thread = p;
-	cwq->should_stop = 0;
 
 	return 0;
 }
@@ -740,29 +730,27 @@ EXPORT_SYMBOL_GPL(__create_workqueue);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct wq_barrier barr;
-	int alive = 0;
-
-	spin_lock_irq(&cwq->lock);
-	if (cwq->thread != NULL) {
-		insert_wq_barrier(cwq, &barr, 1);
-		cwq->should_stop = 1;
-		alive = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
+	/*
+	 * Our caller is either destroy_workqueue() or CPU_DEAD,
+	 * workqueue_mutex protects cwq->thread
+	 */
+	if (cwq->thread == NULL)
+		return;
 
-	if (alive) {
-		wait_for_completion(&barr.done);
+	/*
+	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
+	 * is not enough, a concurrent flush_workqueue() can insert a
+	 * barrier after us.
+	 * When ->worklist becomes empty it is safe to exit because no
+	 * more work_structs can be queued on this cwq: flush_workqueue
+	 * checks list_empty(), and a "normal" queue_work() can't use
+	 * a dead CPU.
+	 */
+	while (flush_cpu_workqueue(cwq))
+		;
 
-		while (unlikely(cwq->thread != NULL))
-			cpu_relax();
-		/*
-		 * Wait until cwq->thread unlocks cwq->lock,
-		 * it won't touch *cwq after that.
-		 */
-		smp_rmb();
-		spin_unlock_wait(&cwq->lock);
-	}
+	kthread_stop(cwq->thread);
+	cwq->thread = NULL;
 }
 
 /**
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
git-nfs.patch
recalc_sigpending_tsk-fixes.patch
simplify-cleanup_workqueue_thread.patch
simplify-cleanup_workqueue_thread-fix.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
