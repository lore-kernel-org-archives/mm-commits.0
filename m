From: akpm@linux-foundation.org
Subject: + uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:11:56 -0800
Message-ID: <200712120511.lBC5BudF026758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbXLLFMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:12:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org


The patch titled
     uglify kill_pid_info() to fix kill() vs exec() race
has been added to the -mm tree.  Its filename is
     uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uglify kill_pid_info() to fix kill() vs exec() race
From: Oleg Nesterov <oleg@tv-sign.ru>

kill_pid_info()->pid_task() could be the old leader of the execing process.
In that case it is possible that the leader will be released before we take
siglock. This means that kill_pid_info() (and thus sys_kill()) can return a
false -ESRCH.

Change the code to retry when lock_task_sighand() fails. The endless loop is
not possible, __exit_signal() both clears ->sighand and does detach_pid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~uglify-kill_pid_info-to-fix-kill-vs-exec-race kernel/signal.c
--- a/kernel/signal.c~uglify-kill_pid_info-to-fix-kill-vs-exec-race
+++ a/kernel/signal.c
@@ -1049,17 +1049,26 @@ int kill_pgrp_info(int sig, struct sigin
 
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
-	int error;
+	int error = -ESRCH;
 	struct task_struct *p;
 
 	rcu_read_lock();
 	if (unlikely(sig_needs_tasklist(sig)))
 		read_lock(&tasklist_lock);
 
+retry:
 	p = pid_task(pid, PIDTYPE_PID);
-	error = -ESRCH;
-	if (p)
+	if (p) {
 		error = group_send_sig_info(sig, info, p);
+		if (unlikely(error == -ESRCH))
+			/*
+			 * The task was unhashed in between, try again.
+			 * If it is dead, pid_task() will return NULL,
+			 * if we race with de_thread() it will find the
+			 * new leader.
+			 */
+			goto retry;
+	}
 
 	if (unlikely(sig_needs_tasklist(sig)))
 		read_unlock(&tasklist_lock);
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
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
