From: akpm@linux-foundation.org
Subject: + sys_setpgid-simplify-pid-ns-interaction.patch added to -mm tree
Date: Tue, 27 Nov 2007 00:33:08 -0800
Message-ID: <200711270833.lAR8X82J002744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbXK0Idu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 03:33:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     sys_setpgid(): simplify pid/ns interaction
has been added to the -mm tree.  Its filename is
     sys_setpgid-simplify-pid-ns-interaction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sys_setpgid(): simplify pid/ns interaction
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_setpgid() does unneeded conversions from pid_t to "struct pid" and vice
versa.  Use "struct pid" more consistently.  Saves one find_vpid() and
eliminates the explicit usage of ->nsproxy->pid_ns.  Imho, cleanups the
code.

Also use the same_thread_group() helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN kernel/sys.c~sys_setpgid-simplify-pid-ns-interaction kernel/sys.c
--- a/kernel/sys.c~sys_setpgid-simplify-pid-ns-interaction
+++ a/kernel/sys.c
@@ -916,8 +916,8 @@ asmlinkage long sys_setpgid(pid_t pid, p
 {
 	struct task_struct *p;
 	struct task_struct *group_leader = current->group_leader;
-	int err = -EINVAL;
-	struct pid_namespace *ns;
+	struct pid *pgrp;
+	int err;
 
 	if (!pid)
 		pid = task_pid_vnr(group_leader);
@@ -929,12 +929,10 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
 	 */
-	ns = current->nsproxy->pid_ns;
-
 	write_lock_irq(&tasklist_lock);
 
 	err = -ESRCH;
-	p = find_task_by_pid_ns(pid, ns);
+	p = find_task_by_vpid(pid);
 	if (!p)
 		goto out;
 
@@ -942,7 +940,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (!thread_group_leader(p))
 		goto out;
 
-	if (p->real_parent->tgid == group_leader->tgid) {
+	if (same_thread_group(p->real_parent, group_leader)) {
 		err = -EPERM;
 		if (task_session(p) != task_session(group_leader))
 			goto out;
@@ -959,10 +957,12 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (p->signal->leader)
 		goto out;
 
+	pgrp = task_pid(p);
 	if (pgid != pid) {
 		struct task_struct *g;
 
-		g = find_task_by_pid_type_ns(PIDTYPE_PGID, pgid, ns);
+		pgrp = find_vpid(pgid);
+		g = pid_task(pgrp, PIDTYPE_PGID);
 		if (!g || task_session(g) != task_session(group_leader))
 			goto out;
 	}
@@ -971,13 +971,10 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (err)
 		goto out;
 
-	if (task_pgrp_nr_ns(p, ns) != pgid) {
-		struct pid *pid;
-
+	if (task_pgrp(p) != pgrp) {
 		detach_pid(p, PIDTYPE_PGID);
-		pid = find_vpid(pgid);
-		attach_pid(p, PIDTYPE_PGID, pid);
-		set_task_pgrp(p, pid_nr(pid));
+		attach_pid(p, PIDTYPE_PGID, pgrp);
+		set_task_pgrp(p, pid_nr(pgrp));
 	}
 
 	err = 0;
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
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
sys_setpgid-simplify-pid-ns-interaction.patch
