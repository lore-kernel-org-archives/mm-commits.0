From: akpm@linux-foundation.org
Subject: + fix-tasklist-find_pid-with-config_preempt_rcu.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:12:54 -0800
Message-ID: <200801292312.m0TNCsex009301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbYA2XNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, paulmck@us.ibm.com, xemul@openvz.org


The patch titled
     fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
has been added to the -mm tree.  Its filename is
     fix-tasklist-find_pid-with-config_preempt_rcu.patch

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
Subject: fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
From: Oleg Nesterov <oleg@tv-sign.ru>

With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply
rcu_read_lock(), but find_pid_ns()->hlist_for_each_entry_rcu() should be
safe under tasklist.

Usually it is, detach_pid() is always called under
write_lock(tasklist_lock), but copy_process() calls free_pid() lockless.

"#ifdef CONFIG_PREEMPT_RCU" is added mostly as documentation, perhaps it is
too ugly and should be removed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~fix-tasklist-find_pid-with-config_preempt_rcu kernel/fork.c
--- a/kernel/fork.c~fix-tasklist-find_pid-with-config_preempt_rcu
+++ a/kernel/fork.c
@@ -1336,8 +1336,19 @@ static struct task_struct *copy_process(
 	return p;
 
 bad_fork_free_pid:
-	if (pid != &init_struct_pid)
+	if (pid != &init_struct_pid) {
+#ifdef CONFIG_PREEMPT_RCU
+		/*
+		 * read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
+		 * make sure find_pid() is safe under read_lock(tasklist).
+		 */
+		write_lock_irq(&tasklist_lock);
+#endif
 		free_pid(pid);
+#ifdef CONFIG_PREEMPT_RCU
+		write_unlock_irq(&tasklist_lock);
+#endif
+	}
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_keys:
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

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
fix-procfs-task-exe-symlink.patch
fix-tasklist-find_pid-with-config_preempt_rcu.patch
