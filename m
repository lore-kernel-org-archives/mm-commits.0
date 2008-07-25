From: akpm@linux-foundation.org
Subject: - workqueues-implement-flush_work.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:12 -0700
Message-ID: <200807252300.m6PN0C6N003566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYGYXBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jarkao2@gmail.com, maxk@qualcomm.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     workqueues: implement flush_work()
has been removed from the -mm tree.  Its filename was
     workqueues-implement-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: implement flush_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

Most of users of flush_workqueue() can be changed to use cancel_work_sync(),
but sometimes we really need to wait for the completion and cancelling is not
an option. schedule_on_each_cpu() is good example.

Add the new helper, flush_work(work), which waits for the completion of the
specific work_struct. More precisely, it "flushes" the result of of the last
queue_work() which is visible to the caller.

For example, this code

	queue_work(wq, work);
	/* WINDOW */
	queue_work(wq, work);

	flush_work(work);

doesn't necessary work "as expected". What can happen in the WINDOW above is

	- wq starts the execution of work->func()

	- the caller migrates to another CPU

now, after the 2nd queue_work() this work is active on the previous CPU, and
at the same time it is queued on another. In this case flush_work(work) may
return before the first work->func() completes.

It is trivial to add another helper

	int flush_work_sync(struct work_struct *work)
	{
		return flush_work(work) || wait_on_work(work);
	}

which works "more correctly", but it has to iterate over all CPUs and thus
it much slower than flush_work().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Max Krasnyansky <maxk@qualcomm.com>
Acked-by: Jarek Poplawski <jarkao2@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    2 +
 kernel/workqueue.c        |   46 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff -puN include/linux/workqueue.h~workqueues-implement-flush_work include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueues-implement-flush_work
+++ a/include/linux/workqueue.h
@@ -201,6 +201,8 @@ extern int keventd_up(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
+extern int flush_work(struct work_struct *work);
+
 extern int cancel_work_sync(struct work_struct *work);
 
 /*
diff -puN kernel/workqueue.c~workqueues-implement-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-implement-flush_work
+++ a/kernel/workqueue.c
@@ -423,6 +423,52 @@ void flush_workqueue(struct workqueue_st
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
+/**
+ * flush_work - block until a work_struct's callback has terminated
+ * @work: the work which is to be flushed
+ *
+ * It is expected that, prior to calling flush_work(), the caller has
+ * arranged for the work to not be requeued, otherwise it doesn't make
+ * sense to use this function.
+ */
+int flush_work(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq;
+	struct list_head *prev;
+	struct wq_barrier barr;
+
+	might_sleep();
+	cwq = get_wq_data(work);
+	if (!cwq)
+		return 0;
+
+	prev = NULL;
+	spin_lock_irq(&cwq->lock);
+	if (!list_empty(&work->entry)) {
+		/*
+		 * See the comment near try_to_grab_pending()->smp_rmb().
+		 * If it was re-queued under us we are not going to wait.
+		 */
+		smp_rmb();
+		if (unlikely(cwq != get_wq_data(work)))
+			goto out;
+		prev = &work->entry;
+	} else {
+		if (cwq->current_work != work)
+			goto out;
+		prev = &cwq->worklist;
+	}
+	insert_wq_barrier(cwq, &barr, prev->next);
+out:
+	spin_unlock_irq(&cwq->lock);
+	if (!prev)
+		return 0;
+
+	wait_for_completion(&barr.done);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(flush_work);
+
 /*
  * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

