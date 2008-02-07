From: akpm@linux-foundation.org
Subject: - use-__set_task_state-for-traced-stopped-tasks.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:37 -0800
Message-ID: <200802070020.m170KIHf006110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932326AbYBGAVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     use __set_task_state() for TRACED/STOPPED tasks
has been removed from the -mm tree.  Its filename was
     use-__set_task_state-for-traced-stopped-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use __set_task_state() for TRACED/STOPPED tasks
From: Oleg Nesterov <oleg@tv-sign.ru>

1. It is much easier to grep for ->state change if __set_task_state() is used
   instead of the direct assignment.

2. ptrace_stop() and handle_group_stop() use set_task_state() which adds the
   unneeded mb() (btw even if we use mb() it is still possible that do_wait()
   sees the new ->state but not ->exit_code, but this is ok).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c   |    2 +-
 kernel/ptrace.c |   10 ++++------
 kernel/signal.c |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/fork.c~use-__set_task_state-for-traced-stopped-tasks kernel/fork.c
--- a/kernel/fork.c~use-__set_task_state-for-traced-stopped-tasks
+++ a/kernel/fork.c
@@ -1510,7 +1510,7 @@ long do_fork(unsigned long clone_flags,
 		if (!(clone_flags & CLONE_STOPPED))
 			wake_up_new_task(p, clone_flags);
 		else
-			p->state = TASK_STOPPED;
+			__set_task_state(p, TASK_STOPPED);
 
 		if (unlikely (trace)) {
 			current->ptrace_message = nr;
diff -puN kernel/ptrace.c~use-__set_task_state-for-traced-stopped-tasks kernel/ptrace.c
--- a/kernel/ptrace.c~use-__set_task_state-for-traced-stopped-tasks
+++ a/kernel/ptrace.c
@@ -53,7 +53,7 @@ void ptrace_untrace(struct task_struct *
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
 		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
-			child->state = TASK_STOPPED;
+			__set_task_state(child, TASK_STOPPED);
 		} else {
 			signal_wake_up(child, 1);
 		}
@@ -103,18 +103,16 @@ int ptrace_check_attach(struct task_stru
 	    && child->signal != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
-		if (task_is_stopped(child)) {
+		if (task_is_stopped(child))
 			child->state = TASK_TRACED;
-		} else if (!task_is_traced(child) && !kill) {
+		else if (!task_is_traced(child) && !kill)
 			ret = -ESRCH;
-		}
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
 
-	if (!ret && !kill) {
+	if (!ret && !kill)
 		wait_task_inactive(child);
-	}
 
 	/* All systems go.. */
 	return ret;
diff -puN kernel/signal.c~use-__set_task_state-for-traced-stopped-tasks kernel/signal.c
--- a/kernel/signal.c~use-__set_task_state-for-traced-stopped-tasks
+++ a/kernel/signal.c
@@ -1601,7 +1601,7 @@ static void ptrace_stop(int exit_code, i
 	current->exit_code = exit_code;
 
 	/* Let the debugger run.  */
-	set_current_state(TASK_TRACED);
+	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	try_to_freeze();
 	read_lock(&tasklist_lock);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
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
