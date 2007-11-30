From: akpm@linux-foundation.org
Subject: + fix-setsid-for-sub-namespace-sbin-init.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:12:31 -0800
Message-ID: <200711300012.lAU0CVAQ014361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762677AbXK3AMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:12:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     fix setsid() for sub-namespace /sbin/init
has been added to the -mm tree.  Its filename is
     fix-setsid-for-sub-namespace-sbin-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix setsid() for sub-namespace /sbin/init
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_setsid() still deals with pid_t's from the global namespace. This means
that the "session > 1" check can't help for sub-namespace init, setsid() can't
succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.

Remove the usage of task_struct->pid and convert the code to use "struct pid".
This also simplifies and speedups the code, saves one find_pid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN kernel/sys.c~fix-setsid-for-sub-namespace-sbin-init kernel/sys.c
--- a/kernel/sys.c~fix-setsid-for-sub-namespace-sbin-init
+++ a/kernel/sys.c
@@ -1045,35 +1045,33 @@ asmlinkage long sys_getsid(pid_t pid)
 asmlinkage long sys_setsid(void)
 {
 	struct task_struct *group_leader = current->group_leader;
-	pid_t session;
+	struct pid *sid = task_pid(group_leader);
+	pid_t session = pid_vnr(sid);
 	int err = -EPERM;
 
 	write_lock_irq(&tasklist_lock);
-
 	/* Fail if I am already a session leader */
 	if (group_leader->signal->leader)
 		goto out;
 
-	session = group_leader->pid;
-	/* Fail if a process group id already exists that equals the
-	 * proposed session id.
+	/* Fail if a process group id already exists that equals the proposed
+	 * session id.
 	 *
-	 * Don't check if session id == 1 because kernel threads use this
-	 * session id and so the check will always fail and make it so
-	 * init cannot successfully call setsid.
+	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
+	 * tasks use this session id and so the check will always fail and make
+	 * it so init cannot successfully call setsid.
 	 */
-	if (session > 1 && find_task_by_pid_type_ns(PIDTYPE_PGID,
-				session, &init_pid_ns))
+	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
 		goto out;
 
 	group_leader->signal->leader = 1;
-	__set_special_pids(session, session);
+	__set_special_pids(pid_nr(sid), pid_nr(sid));
 
 	spin_lock(&group_leader->sighand->siglock);
 	group_leader->signal->tty = NULL;
 	spin_unlock(&group_leader->sighand->siglock);
 
-	err = task_pgrp_vnr(group_leader);
+	err = session;
 out:
 	write_unlock_irq(&tasklist_lock);
 	return err;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
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
