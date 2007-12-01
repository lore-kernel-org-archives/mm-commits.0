From: akpm@linux-foundation.org
Subject: - wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:21:06 -0800
Message-ID: <200712010021.lB10L6ES031742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756969AbXLAAVy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:21:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     wait_task_stopped(): don't use task_pid_nr_ns() lockless
has been removed from the -mm tree.  Its filename was
     wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wait_task_stopped(): don't use task_pid_nr_ns() lockless
From: Oleg Nesterov <oleg@tv-sign.ru>

wait_task_stopped(WNOWAIT) does task_pid_nr_ns() without tasklist/rcu lock,
we can read an already freed memory.  Use the cached pid_t value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Looks-good-to: Roland McGrath <roland@redhat.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~wait_task_stopped-dont-use-task_pid_nr_ns-lockless kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-dont-use-task_pid_nr_ns-lockless
+++ a/kernel/exit.c
@@ -1357,7 +1357,7 @@ static int wait_task_stopped(struct task
 			     int __user *stat_addr, struct rusage __user *ru)
 {
 	int retval, exit_code;
-	struct pid_namespace *ns;
+	pid_t pid;
 
 	if (!p->exit_code)
 		return 0;
@@ -1376,12 +1376,11 @@ static int wait_task_stopped(struct task
 	 * keep holding onto the tasklist_lock while we call getrusage and
 	 * possibly take page faults for user memory.
 	 */
-	ns = current->nsproxy->pid_ns;
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
 	if (unlikely(noreap)) {
-		pid_t pid = task_pid_nr_ns(p, ns);
 		uid_t uid = p->uid;
 		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 
@@ -1451,11 +1450,11 @@ bail_ref:
 	if (!retval && infop)
 		retval = put_user(exit_code, &infop->si_status);
 	if (!retval && infop)
-		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
+		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
 	if (!retval)
-		retval = task_pid_nr_ns(p, ns);
+		retval = pid;
 	put_task_struct(p);
 
 	BUG_ON(!retval);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-x86.patch
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
