From: akpm@linux-foundation.org
Subject: - fix-the-remove-task_ppid_nr_ns-commit.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:56 -0800
Message-ID: <200801160138.m0G1cu2r013949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438AbYAPBti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix the "remove task_ppid_nr_ns" commit
has been removed from the -mm tree.  Its filename was
     fix-the-remove-task_ppid_nr_ns-commit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix the "remove task_ppid_nr_ns" commit
From: Oleg Nesterov <oleg@tv-sign.ru>

The commit 84427eaef1fb91704c7112bdb598c810003b99f3 (remove
task_ppid_nr_ns) moves the task_tgid_nr_ns(task->real_parent) outside of
lock_task_sighand().  This is wrong, ->real_parent could be freed/reused.

Both ->parent/real_parent point to nothnig after __exit_signal() because we
remove the child from ->children list, and thus the child can't be
reparented when its parent exits.

rcu_read_lock() protects ->parent/real_parent, but _only_ if we know it was
valid before we take rcu lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~fix-the-remove-task_ppid_nr_ns-commit fs/proc/array.c
--- a/fs/proc/array.c~fix-the-remove-task_ppid_nr_ns-commit
+++ a/fs/proc/array.c
@@ -426,7 +426,6 @@ static int do_task_stat(struct seq_file 
 	cgtime = gtime = cputime_zero;
 
 	rcu_read_lock();
-	ppid = task_tgid_nr_ns(task->real_parent, ns);
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -465,6 +464,7 @@ static int do_task_stat(struct seq_file 
 		}
 
 		sid = task_session_nr_ns(task, ns);
+		ppid = task_tgid_nr_ns(task->real_parent, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
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
