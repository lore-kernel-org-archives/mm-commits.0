From: akpm@linux-foundation.org
Subject: - sched-fix-task_wakekill-vs-sigkill-race.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:08 -0700
Message-ID: <200806122038.m5CKc83s005509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868AbYFLUjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, dmitry.adamushko@gmail.com, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sched: fix TASK_WAKEKILL vs SIGKILL race
has been removed from the -mm tree.  Its filename was
     sched-fix-task_wakekill-vs-sigkill-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fix TASK_WAKEKILL vs SIGKILL race
From: Oleg Nesterov <oleg@tv-sign.ru>

schedule() has the special "TASK_INTERRUPTIBLE && signal_pending()" case,
this allows us to do

	current->state = TASK_INTERRUPTIBLE;
	schedule();

without fear to sleep with pending signal.

However, the code like

	current->state = TASK_KILLABLE;
	schedule();

is not right, schedule() doesn't take TASK_WAKEKILL into account. This means
that mutex_lock_killable(), wait_for_completion_killable(), down_killable(),
schedule_timeout_killable() can miss SIGKILL (and btw the second SIGKILL has
no effect).

Introduce the new helper, signal_pending_state(), and change schedule() to
use it. Hopefully it will have more users, that is why the task's state is
passed separately.

Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
This is needed to preserve the current behaviour (ptrace_notify). I hope
this check will be removed soon, but this (afaics good) change needs the
separate discussion.

The fast path is "(state & (INTERRUPTIBLE | WAKEKILL)) + signal_pending(p)",
basically the same that schedule() does now. However, this patch of course
bloats schedule().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   13 +++++++++++++
 kernel/sched.c        |    6 ++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/sched.h~sched-fix-task_wakekill-vs-sigkill-race include/linux/sched.h
--- a/include/linux/sched.h~sched-fix-task_wakekill-vs-sigkill-race
+++ a/include/linux/sched.h
@@ -2040,6 +2040,19 @@ static inline int fatal_signal_pending(s
 	return signal_pending(p) && __fatal_signal_pending(p);
 }
 
+static inline int signal_pending_state(long state, struct task_struct *p)
+{
+	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
+		return 0;
+	if (!signal_pending(p))
+		return 0;
+
+	if (state & (__TASK_STOPPED | __TASK_TRACED))
+		return 0;
+
+	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
+}
+
 static inline int need_resched(void)
 {
 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
diff -puN kernel/sched.c~sched-fix-task_wakekill-vs-sigkill-race kernel/sched.c
--- a/kernel/sched.c~sched-fix-task_wakekill-vs-sigkill-race
+++ a/kernel/sched.c
@@ -4207,12 +4207,10 @@ need_resched_nonpreemptible:
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				signal_pending(prev))) {
+		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		} else {
+		else
 			deactivate_task(rq, prev, 1);
-		}
 		switch_count = &prev->nvcsw;
 	}
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
distinct-tgid-tid-i-o-statistics.patch

