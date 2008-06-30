From: akpm@linux-foundation.org
Subject: - coredump-simplify-core_state-nr_threads-calculation.patch removed from -mm tree
Date: Mon, 30 Jun 2008 16:39:56 -0700
Message-ID: <200806302339.m5UNduVj031439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbYF3XkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: simplify core_state->nr_threads calculation
has been removed from the -mm tree.  Its filename was
     coredump-simplify-core_state-nr_threads-calculation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: simplify core_state->nr_threads calculation
From: Oleg Nesterov <oleg@tv-sign.ru>

Change zap_process() to return int instead of incrementing
mm->core_state->nr_threads directly. Change zap_threads() to set
mm->core_state only on success.

This patch restores the original size of .text, and more importantly now
->nr_threads is used in two places only.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff -puN fs/exec.c~coredump-simplify-core_state-nr_threads-calculation fs/exec.c
--- a/fs/exec.c~coredump-simplify-core_state-nr_threads-calculation
+++ a/fs/exec.c
@@ -1504,9 +1504,10 @@ out:
 	return ispipe;
 }
 
-static void zap_process(struct task_struct *start)
+static int zap_process(struct task_struct *start)
 {
 	struct task_struct *t;
+	int nr = 0;
 
 	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_stop_count = 0;
@@ -1514,31 +1515,32 @@ static void zap_process(struct task_stru
 	t = start;
 	do {
 		if (t != current && t->mm) {
-			t->mm->core_state->nr_threads++;
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
+			nr++;
 		}
 	} while_each_thread(start, t);
+
+	return nr;
 }
 
 static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
-				int exit_code)
+				struct core_state *core_state, int exit_code)
 {
 	struct task_struct *g, *p;
 	unsigned long flags;
-	int err = -EAGAIN;
+	int nr = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		tsk->signal->group_exit_code = exit_code;
-		zap_process(tsk);
-		err = 0;
+		nr = zap_process(tsk);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
-	if (err)
-		return err;
+	if (unlikely(nr < 0))
+		return nr;
 
-	if (atomic_read(&mm->mm_users) == mm->core_state->nr_threads + 1)
+	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
 	 * We should find and kill all tasks which use this mm, and we should
@@ -1581,7 +1583,7 @@ static inline int zap_threads(struct tas
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
-					zap_process(p);
+					nr += zap_process(p);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
@@ -1590,7 +1592,9 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	return mm->core_state->nr_threads;
+	core_state->nr_threads = nr;
+	mm->core_state = core_state;
+	return nr;
 }
 
 static int coredump_wait(int exit_code)
@@ -1603,12 +1607,7 @@ static int coredump_wait(int exit_code)
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
-	core_state.nr_threads = 0;
-	mm->core_state = &core_state;
-
-	core_waiters = zap_threads(tsk, mm, exit_code);
-	if (core_waiters < 0)
-		mm->core_state = NULL;
+	core_waiters = zap_threads(tsk, mm, &core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
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
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

