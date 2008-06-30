From: akpm@linux-foundation.org
Subject: + workqueues-implement-flush_work.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:42:54 -0700
Message-ID: <200806302342.m5UNgsA2031528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbYF3Xm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jarkao2@gmail.com, maxk@qualcomm.com, peterz@infradead.org


The patch titled
     workqueues: implement flush_work()
has been added to the -mm tree.  Its filename is
     workqueues-implement-flush_work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -198,6 +198,8 @@ extern int keventd_up(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
+extern int flush_work(struct work_struct *work);
+
 extern int cancel_work_sync(struct work_struct *work);
 
 /*
diff -puN kernel/workqueue.c~workqueues-implement-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-implement-flush_work
+++ a/kernel/workqueue.c
@@ -399,6 +399,52 @@ void flush_workqueue(struct workqueue_st
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

get_user_pages-fix-possible-page-leak-on-oom.patch
migrate_timers-add-comment-use-spinlock_irq.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

