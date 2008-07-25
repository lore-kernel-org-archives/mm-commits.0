From: akpm@linux-foundation.org
Subject: - ptrace-simplify-ptrace_stop-sigkill_pending-path.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:44 -0700
Message-ID: <200807252259.m6PMxijH003412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983AbYGYXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: simplify ptrace_stop()->sigkill_pending() path
has been removed from the -mm tree.  Its filename was
     ptrace-simplify-ptrace_stop-sigkill_pending-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: simplify ptrace_stop()->sigkill_pending() path
From: Oleg Nesterov <oleg@tv-sign.ru>

1. SIGKILL can't be blocked, remove this check from sigkill_pending().

2. When ptrace_stop() sees sigkill_pending() == T, it can just return.
   Kill "int killed" and simplify the code. This also is more correct,
   the tracer shouldn't see us in TASK_TRACED if we are not going to
   stop.

I strongly believe this code needs further changes.  We should do the "was
this task killed" check unconditionally, currently it depends on
arch_ptrace_stop_needed().  On the other hand, sigkill_pending() isn't
very clever.  If the task was killed tkill(SIGKILL), the signal can be
already dequeued if the caller is do_exit().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN kernel/signal.c~ptrace-simplify-ptrace_stop-sigkill_pending-path kernel/signal.c
--- a/kernel/signal.c~ptrace-simplify-ptrace_stop-sigkill_pending-path
+++ a/kernel/signal.c
@@ -1496,9 +1496,8 @@ static inline int may_ptrace_stop(void)
  */
 static int sigkill_pending(struct task_struct *tsk)
 {
-	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
-		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
-		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
+	return	sigismember(&tsk->pending.signal, SIGKILL) ||
+		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
 }
 
 /*
@@ -1514,8 +1513,6 @@ static int sigkill_pending(struct task_s
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
-	int killed = 0;
-
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
 		 * The arch code has something special to do before a
@@ -1531,7 +1528,8 @@ static void ptrace_stop(int exit_code, i
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
-		killed = sigkill_pending(current);
+		if (sigkill_pending(current))
+			return;
 	}
 
 	/*
@@ -1548,7 +1546,7 @@ static void ptrace_stop(int exit_code, i
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (!unlikely(killed) && may_ptrace_stop()) {
+	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();
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

