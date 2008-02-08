From: akpm@linux-foundation.org
Subject: - teach-set_special_pids-to-use-struct-pid.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:55 -0800
Message-ID: <200802082013.m18KDad6010304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757844AbYBHVBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     teach set_special_pids() to use struct pid
has been removed from the -mm tree.  Its filename was
     teach-set_special_pids-to-use-struct-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1632,7 +1632,7 @@ extern struct task_struct *find_task_by_
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
 
-extern void __set_special_pids(pid_t session, pid_t pgrp);
+extern void __set_special_pids(struct pid *pid);
 
 /* per-UID process charging. */
 extern struct user_struct * alloc_uid(struct user_namespace *, uid_t);
diff -puN init/main.c~teach-set_special_pids-to-use-struct-pid init/main.c
--- a/init/main.c~teach-set_special_pids-to-use-struct-pid
+++ a/init/main.c
@@ -833,7 +833,7 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	__set_special_pids(1, 1);
+	__set_special_pids(task_pid(current));
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(setup_max_cpus);
diff -puN kernel/exit.c~teach-set_special_pids-to-use-struct-pid kernel/exit.c
--- a/kernel/exit.c~teach-set_special_pids-to-use-struct-pid
+++ a/kernel/exit.c
@@ -293,26 +293,27 @@ static void reparent_to_kthreadd(void)
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
 
@@ -383,7 +384,11 @@ void daemonize(const char *name, ...)
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
@@ -398,11 +403,6 @@ void daemonize(const char *name, ...)
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

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
