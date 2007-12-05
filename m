From: akpm@linux-foundation.org
Subject: + fix-group-stop-with-exit-race.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:18:31 -0800
Message-ID: <200712052318.lB5NIVXJ030094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbXLEXTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, davidel@xmailserver.org, mingo@elte.hu, roland@redhat.com


The patch titled
     fix group stop with exit race
has been added to the -mm tree.  Its filename is
     fix-group-stop-with-exit-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix group stop with exit race
From: Oleg Nesterov <oleg@tv-sign.ru>

do_signal_stop() counts all sub-thread and sets ->group_stop_count
accordingly.  Every thread should decrement ->group_stop_count and stop,
the last one should notify the parent.

However a sub-thread can exit before it notices the signal_pending(), or it
may be somewhere in do_exit() already.  In that case the group stop never
finishes properly.

Note: this is a minimal fix, we can add some optimizations later.  Say we
can return quickly if thread_group_empty().  Also, we can move some signal
related code from exit_notify() to exit_signals().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 kernel/exit.c          |    2 +-
 kernel/signal.c        |   27 ++++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff -puN include/linux/signal.h~fix-group-stop-with-exit-race include/linux/signal.h
--- a/include/linux/signal.h~fix-group-stop-with-exit-race
+++ a/include/linux/signal.h
@@ -241,6 +241,7 @@ extern int show_unhandled_signals;
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern void exit_signals(struct task_struct *tsk);
 
 extern struct kmem_cache *sighand_cachep;
 
diff -puN kernel/exit.c~fix-group-stop-with-exit-race kernel/exit.c
--- a/kernel/exit.c~fix-group-stop-with-exit-race
+++ a/kernel/exit.c
@@ -945,7 +945,7 @@ fastcall NORET_TYPE void do_exit(long co
 		schedule();
 	}
 
-	tsk->flags |= PF_EXITING;
+	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.
diff -puN kernel/signal.c~fix-group-stop-with-exit-race kernel/signal.c
--- a/kernel/signal.c~fix-group-stop-with-exit-race
+++ a/kernel/signal.c
@@ -1707,7 +1707,7 @@ static int do_signal_stop(int signr)
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
-			if (!t->exit_state &&
+			if (!(t->flags & PF_EXITING) &&
 			    !is_task_stopped_or_traced(t)) {
 				stop_count++;
 				signal_wake_up(t, 0);
@@ -1868,6 +1868,31 @@ relock:
 	return signr;
 }
 
+void exit_signals(struct task_struct *tsk)
+{
+	int group_stop = 0;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (unlikely(tsk->signal->group_stop_count) &&
+			!--tsk->signal->group_stop_count) {
+		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+		group_stop = 1;
+	}
+
+	/*
+	 * From now this task is not visible for group-wide signals,
+	 * see wants_signal(), do_signal_stop().
+	 */
+	tsk->flags |= PF_EXITING;
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (unlikely(group_stop)) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(tsk, CLD_STOPPED);
+		read_unlock(&tasklist_lock);
+	}
+}
+
 EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-cloneclone_newpid.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-sched.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
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
