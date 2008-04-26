From: akpm@linux-foundation.org
Subject: - ptrace_signal-subroutine.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:40 -0700
Message-ID: <200804261642.m3QGgeiw031214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759347AbYDZQnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     ptrace_signal() subroutine
has been removed from the -mm tree.  Its filename was
     ptrace_signal-subroutine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace_signal() subroutine
From: Roland McGrath <roland@redhat.com>

This breaks out the ptrace handling from get_signal_to_deliver into a new
subroutine.  The actual code there doesn't change, and it gets inlined into
nearly identical compiled code.  This makes the function substantially shorter
and thus easier to read, and it nicely isolates the ptrace magic.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   71 +++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff -puN kernel/signal.c~ptrace_signal-subroutine kernel/signal.c
--- a/kernel/signal.c~ptrace_signal-subroutine
+++ a/kernel/signal.c
@@ -1654,6 +1654,45 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
+static int ptrace_signal(int signr, siginfo_t *info,
+			 struct pt_regs *regs, void *cookie)
+{
+	if (!(current->ptrace & PT_PTRACED))
+		return signr;
+
+	ptrace_signal_deliver(regs, cookie);
+
+	/* Let the debugger run.  */
+	ptrace_stop(signr, 0, info);
+
+	/* We're back.  Did the debugger cancel the sig?  */
+	signr = current->exit_code;
+	if (signr == 0)
+		return signr;
+
+	current->exit_code = 0;
+
+	/* Update the siginfo structure if the signal has
+	   changed.  If the debugger wanted something
+	   specific in the siginfo structure then it should
+	   have updated *info via PTRACE_SETSIGINFO.  */
+	if (signr != info->si_signo) {
+		info->si_signo = signr;
+		info->si_errno = 0;
+		info->si_code = SI_USER;
+		info->si_pid = task_pid_vnr(current->parent);
+		info->si_uid = current->parent->uid;
+	}
+
+	/* If the (new) signal is now blocked, requeue it.  */
+	if (sigismember(&current->blocked, signr)) {
+		specific_send_sig_info(signr, info, current);
+		signr = 0;
+	}
+
+	return signr;
+}
+
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -1699,36 +1738,10 @@ relock:
 		if (!signr)
 			break; /* will return 0 */
 
-		if ((current->ptrace & PT_PTRACED) && signr != SIGKILL) {
-			ptrace_signal_deliver(regs, cookie);
-
-			/* Let the debugger run.  */
-			ptrace_stop(signr, 0, info);
-
-			/* We're back.  Did the debugger cancel the sig?  */
-			signr = current->exit_code;
-			if (signr == 0)
-				continue;
-
-			current->exit_code = 0;
-
-			/* Update the siginfo structure if the signal has
-			   changed.  If the debugger wanted something
-			   specific in the siginfo structure then it should
-			   have updated *info via PTRACE_SETSIGINFO.  */
-			if (signr != info->si_signo) {
-				info->si_signo = signr;
-				info->si_errno = 0;
-				info->si_code = SI_USER;
-				info->si_pid = task_pid_vnr(current->parent);
-				info->si_uid = current->parent->uid;
-			}
-
-			/* If the (new) signal is now blocked, requeue it.  */
-			if (sigismember(&current->blocked, signr)) {
-				specific_send_sig_info(signr, info, current);
+		if (signr != SIGKILL) {
+			signr = ptrace_signal(signr, info, regs, cookie);
+			if (!signr)
 				continue;
-			}
 		}
 
 		ka = &sighand->action[signr-1];
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86-ptrace-pebs-support.patch
x86-ptrace-pebs-support-warning-fix.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
procfs-mem-permission-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

