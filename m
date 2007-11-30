From: akpm@linux-foundation.org
Subject: + teach-set_special_pids-to-use-struct-pid.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:13:51 -0800
Message-ID: <200711300013.lAU0DpOV014480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760622AbXK3AOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     teach set_special_pids() to use struct pid
has been added to the -mm tree.  Its filename is
     teach-set_special_pids-to-use-struct-pid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: teach set_special_pids() to use struct pid
From: Oleg Nesterov <oleg@tv-sign.ru>

Change set_special_pids() to work with struct pid, not pid_t from global name
space. This again speedups and imho cleanups the code, also a preparation for
the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 init/main.c           |    2 +-
 kernel/exit.c         |   30 +++++++++++++++---------------
 kernel/sys.c          |    2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff -puN include/linux/sched.h~teach-set_special_pids-to-use-struct-pid include/linux/sched.h
--- a/include/linux/sched.h~teach-set_special_pids-to-use-struct-pid
+++ a/include/linux/sched.h
@@ -1572,7 +1572,7 @@ extern struct task_struct *find_task_by_
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
 
-extern void __set_special_pids(pid_t session, pid_t pgrp);
+extern void __set_special_pids(struct pid *pid);
 
 /* per-UID process charging. */
 extern struct user_struct * alloc_uid(struct user_namespace *, uid_t);
diff -puN init/main.c~teach-set_special_pids-to-use-struct-pid init/main.c
--- a/init/main.c~teach-set_special_pids-to-use-struct-pid
+++ a/init/main.c
@@ -830,7 +830,7 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	__set_special_pids(1, 1);
+	__set_special_pids(task_pid(current));
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
diff -puN kernel/exit.c~teach-set_special_pids-to-use-struct-pid kernel/exit.c
--- a/kernel/exit.c~teach-set_special_pids-to-use-struct-pid
+++ a/kernel/exit.c
@@ -295,26 +295,27 @@ static void reparent_to_kthreadd(void)
 	switch_uid(INIT_USER);
 }
 
-void __set_special_pids(pid_t session, pid_t pgrp)
+void __set_special_pids(struct pid *pid)
 {
 	struct task_struct *curr = current->group_leader;
+	pid_t nr = pid_nr(pid);
 
-	if (task_session_nr(curr) != session) {
+	if (task_session(curr) != pid) {
 		detach_pid(curr, PIDTYPE_SID);
-		set_task_session(curr, session);
-		attach_pid(curr, PIDTYPE_SID, find_pid(session));
+		attach_pid(curr, PIDTYPE_SID, pid);
+		set_task_session(curr, nr);
 	}
-	if (task_pgrp_nr(curr) != pgrp) {
+	if (task_pgrp(curr) != pid) {
 		detach_pid(curr, PIDTYPE_PGID);
-		set_task_pgrp(curr, pgrp);
-		attach_pid(curr, PIDTYPE_PGID, find_pid(pgrp));
+		attach_pid(curr, PIDTYPE_PGID, pid);
+		set_task_pgrp(curr, nr);
 	}
 }
 
-static void set_special_pids(pid_t session, pid_t pgrp)
+static void set_special_pids(struct pid *pid)
 {
 	write_lock_irq(&tasklist_lock);
-	__set_special_pids(session, pgrp);
+	__set_special_pids(pid);
 	write_unlock_irq(&tasklist_lock);
 }
 
@@ -385,7 +386,11 @@ void daemonize(const char *name, ...)
 	 */
 	current->flags |= PF_NOFREEZE;
 
-	set_special_pids(1, 1);
+	if (current->nsproxy != &init_nsproxy) {
+		get_nsproxy(&init_nsproxy);
+		switch_task_namespaces(current, &init_nsproxy);
+	}
+	set_special_pids(find_pid(1));
 	proc_clear_tty(current);
 
 	/* Block and flush all signals */
@@ -400,11 +405,6 @@ void daemonize(const char *name, ...)
 	current->fs = fs;
 	atomic_inc(&fs->count);
 
-	if (current->nsproxy != init_task.nsproxy) {
-		get_nsproxy(init_task.nsproxy);
-		switch_task_namespaces(current, init_task.nsproxy);
-	}
-
 	exit_files(current);
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
diff -puN kernel/sys.c~teach-set_special_pids-to-use-struct-pid kernel/sys.c
--- a/kernel/sys.c~teach-set_special_pids-to-use-struct-pid
+++ a/kernel/sys.c
@@ -1065,7 +1065,7 @@ asmlinkage long sys_setsid(void)
 		goto out;
 
 	group_leader->signal->leader = 1;
-	__set_special_pids(pid_nr(sid), pid_nr(sid));
+	__set_special_pids(sid);
 
 	spin_lock(&group_leader->sighand->siglock);
 	group_leader->signal->tty = NULL;
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
