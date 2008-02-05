From: akpm@linux-foundation.org
Subject: - remove-handle_group_stop-in-favor-of-do_signal_stop.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:31 -0800
Message-ID: <200802052226.m15MQCLG011605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760082AbYBEW1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:27:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, holt@sgi.com, mingo@elte.hu, roland@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     remove handle_group_stop() in favor of do_signal_stop()
has been removed from the -mm tree.  Its filename was
     remove-handle_group_stop-in-favor-of-do_signal_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove handle_group_stop() in favor of do_signal_stop()
From: Oleg Nesterov <oleg@tv-sign.ru>

Every time we set SIGNAL_GROUP_EXIT or clear SIGNAL_STOP_DEQUEUED we also
reset ->group_stop_count.

This means that the SIGNAL_GROUP_EXIT check in handle_group_stop() is not
needed, and do_signal_stop() should check SIGNAL_STOP_DEQUEUED only when
->group_stop_count == 0. With these changes handle_group_stop() becomes the
subset of do_signal_stop(), we can kill it and use do_signal_stop() instead.

Also, a preparation for the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   43 +++++--------------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff -puN kernel/signal.c~remove-handle_group_stop-in-favor-of-do_signal_stop kernel/signal.c
--- a/kernel/signal.c~remove-handle_group_stop-in-favor-of-do_signal_stop
+++ a/kernel/signal.c
@@ -1688,9 +1688,6 @@ static int do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 	int stop_count;
 
-	if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
-		return 0;
-
 	if (sig->group_stop_count > 0) {
 		/*
 		 * There is a group stop in progress.  We don't need to
@@ -1698,12 +1695,14 @@ static int do_signal_stop(int signr)
 		 */
 		stop_count = --sig->group_stop_count;
 	} else {
+		struct task_struct *t;
+
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
+			return 0;
 		/*
 		 * There is no group stop already in progress.
 		 * We must initiate one now.
 		 */
-		struct task_struct *t;
-
 		sig->group_exit_code = signr;
 
 		stop_count = 0;
@@ -1731,38 +1730,6 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
-/*
- * Do appropriate magic when group_stop_count > 0.
- * We return nonzero if we stopped, after releasing the siglock.
- * We return zero if we still hold the siglock and should look
- * for another signal without checking group_stop_count again.
- */
-static int handle_group_stop(void)
-{
-	int stop_count;
-
-	if (current->signal->flags & SIGNAL_GROUP_EXIT)
-		/*
-		 * Group stop is so another thread can do a core dump,
-		 * or else we are racing against a death signal.
-		 * Just punt the stop so we can get the next signal.
-		 */
-		return 0;
-
-	/*
-	 * There is a group stop in progress.  We stop
-	 * without any associated signal being in our queue.
-	 */
-	stop_count = --current->signal->group_stop_count;
-	if (stop_count == 0)
-		current->signal->flags = SIGNAL_STOP_STOPPED;
-	current->exit_code = current->signal->group_exit_code;
-	set_current_state(TASK_STOPPED);
-	spin_unlock_irq(&current->sighand->siglock);
-	finish_stop(stop_count);
-	return 1;
-}
-
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -1777,7 +1744,7 @@ relock:
 		struct k_sigaction *ka;
 
 		if (unlikely(current->signal->group_stop_count > 0) &&
-		    handle_group_stop())
+		    do_signal_stop(0))
 			goto relock;
 
 		signr = dequeue_signal(current, mask, info);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
use-__set_task_state-for-traced-stopped-tasks.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
fix-group-stop-with-exit-race.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
