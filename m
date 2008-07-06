From: akpm@linux-foundation.org
Subject: + workqueues-lockdep-annotations-for-flush_work.patch added to -mm tree
Date: Sun, 06 Jul 2008 12:26:06 -0700
Message-ID: <200807061926.m66JQ6LK021326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbYGFT0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 15:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jarkao2@o2.pl, johannes@sipsolutions.net


The patch titled
     workqueues: lockdep annotations for flush_work()
has been added to the -mm tree.  Its filename is
     workqueues-lockdep-annotations-for-flush_work.patch

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
Subject: workqueues: lockdep annotations for flush_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

Add lockdep annotations to flush_work() and update the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/workqueue.c~workqueues-lockdep-annotations-for-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-lockdep-annotations-for-flush_work
+++ a/kernel/workqueue.c
@@ -403,6 +403,8 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  * flush_work - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
+ * Returns false if @work has already terminated.
+ *
  * It is expected that, prior to calling flush_work(), the caller has
  * arranged for the work to not be requeued, otherwise it doesn't make
  * sense to use this function.
@@ -418,6 +420,9 @@ int flush_work(struct work_struct *work)
 	if (!cwq)
 		return 0;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&work->entry)) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
linux-next.patch
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
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
workqueues-lockdep-annotations-for-flush_work.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

