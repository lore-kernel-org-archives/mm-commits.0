From: akpm@linux-foundation.org
Subject: - exec-rework-the-group-exit-and-fix-the-race-with-kill.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:34 -0800
Message-ID: <200802052226.m15MQFGV011613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760469AbYBEW1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, holt@sgi.com, mingo@elte.hu, roland@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     exec: rework the group exit and fix the race with kill
has been removed from the -mm tree.  Its filename was
     exec-rework-the-group-exit-and-fix-the-race-with-kill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: rework the group exit and fix the race with kill
From: Oleg Nesterov <oleg@tv-sign.ru>

As Roland pointed out, we have the very old problem with exec.  de_thread()
sets SIGNAL_GROUP_EXIT, kills other threads, changes ->group_leader and then
clears signal->flags.  All signals (even fatal ones) sent in this window
(which is not too small) will be lost.

With this patch exec doesn't abuse SIGNAL_GROUP_EXIT.  signal_group_exit(),
the new helper, should be used to detect exit_group() or exec() in progress. 
It can have more users, but this patch does only strictly necessary changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |   13 ++++---------
 include/linux/sched.h |    7 +++++++
 kernel/exit.c         |    3 ++-
 kernel/signal.c       |    4 ++--
 4 files changed, 15 insertions(+), 12 deletions(-)

diff -puN fs/exec.c~exec-rework-the-group-exit-and-fix-the-race-with-kill fs/exec.c
--- a/fs/exec.c~exec-rework-the-group-exit-and-fix-the-race-with-kill
+++ a/fs/exec.c
@@ -760,7 +760,7 @@ static int de_thread(struct task_struct 
 	 */
 	read_lock(&tasklist_lock);
 	spin_lock_irq(lock);
-	if (sig->flags & SIGNAL_GROUP_EXIT) {
+	if (signal_group_exit(sig)) {
 		/*
 		 * Another group action in progress, just
 		 * return so that the signal is processed.
@@ -778,6 +778,7 @@ static int de_thread(struct task_struct 
 	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
 		task_active_pid_ns(tsk)->child_reaper = tsk;
 
+	sig->group_exit_task = tsk;
 	zap_other_threads(tsk);
 	read_unlock(&tasklist_lock);
 
@@ -802,7 +803,6 @@ static int de_thread(struct task_struct 
 	}
 
 	sig->notify_count = count;
-	sig->group_exit_task = tsk;
 	while (atomic_read(&sig->count) > count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(lock);
@@ -871,15 +871,10 @@ static int de_thread(struct task_struct 
 		leader->exit_state = EXIT_DEAD;
 
 		write_unlock_irq(&tasklist_lock);
-        }
+	}
 
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
-	/*
-	 * There may be one thread left which is just exiting,
-	 * but it's safe to stop telling the group to kill themselves.
-	 */
-	sig->flags = 0;
 
 no_thread_group:
 	exit_itimers(sig);
@@ -1549,7 +1544,7 @@ static inline int zap_threads(struct tas
 	int err = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT)) {
+	if (!signal_group_exit(tsk->signal)) {
 		tsk->signal->group_exit_code = exit_code;
 		zap_process(tsk);
 		err = 0;
diff -puN include/linux/sched.h~exec-rework-the-group-exit-and-fix-the-race-with-kill include/linux/sched.h
--- a/include/linux/sched.h~exec-rework-the-group-exit-and-fix-the-race-with-kill
+++ a/include/linux/sched.h
@@ -555,6 +555,13 @@ struct signal_struct {
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
 
+/* If true, all threads except ->group_exit_task have pending SIGKILL */
+static inline int signal_group_exit(const struct signal_struct *sig)
+{
+	return	(sig->flags & SIGNAL_GROUP_EXIT) ||
+		(sig->group_exit_task != NULL);
+}
+
 /*
  * Some day this will be a full-fledged user tracking system..
  */
diff -puN kernel/exit.c~exec-rework-the-group-exit-and-fix-the-race-with-kill kernel/exit.c
--- a/kernel/exit.c~exec-rework-the-group-exit-and-fix-the-race-with-kill
+++ a/kernel/exit.c
@@ -1083,11 +1083,12 @@ do_group_exit(int exit_code)
 		struct signal_struct *const sig = current->signal;
 		struct sighand_struct *const sighand = current->sighand;
 		spin_lock_irq(&sighand->siglock);
-		if (sig->flags & SIGNAL_GROUP_EXIT)
+		if (signal_group_exit(sig))
 			/* Another thread got here before we took the lock.  */
 			exit_code = sig->group_exit_code;
 		else {
 			sig->group_exit_code = exit_code;
+			sig->flags = SIGNAL_GROUP_EXIT;
 			zap_other_threads(current);
 		}
 		spin_unlock_irq(&sighand->siglock);
diff -puN kernel/signal.c~exec-rework-the-group-exit-and-fix-the-race-with-kill kernel/signal.c
--- a/kernel/signal.c~exec-rework-the-group-exit-and-fix-the-race-with-kill
+++ a/kernel/signal.c
@@ -957,7 +957,6 @@ void zap_other_threads(struct task_struc
 {
 	struct task_struct *t;
 
-	p->signal->flags = SIGNAL_GROUP_EXIT;
 	p->signal->group_stop_count = 0;
 
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
@@ -1697,7 +1696,8 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		    unlikely(sig->group_exit_task))
 			return 0;
 		/*
 		 * There is no group stop already in progress.
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
