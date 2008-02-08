From: akpm@linux-foundation.org
Subject: - pidns-make-full-use-of-xxx_vnr-calls.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:33 -0800
Message-ID: <200802082014.m18KEENQ010388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755073AbYBHVCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Pidns: make full use of xxx_vnr() calls
has been removed from the -mm tree.  Its filename was
     pidns-make-full-use-of-xxx_vnr-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Pidns: make full use of xxx_vnr() calls
From: Pavel Emelyanov <xemul@openvz.org>

Some time ago the xxx_vnr() calls (e.g.  pid_vnr or find_task_by_vpid) were
_all_ converted to operate on the current pid namespace.  After this each call
like xxx_nr_ns(foo, current->nsproxy->pid_ns) is nothing but a xxx_vnr(foo)
one.

Switch all the xxx_nr_ns() callers to use the xxx_vnr() calls where
appropriate.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c      |    2 +-
 fs/locks.c      |    5 ++---
 ipc/mqueue.c    |    3 +--
 kernel/exit.c   |    6 +++---
 kernel/fork.c   |    8 +-------
 kernel/sys.c    |    7 ++-----
 kernel/sysctl.c |    2 +-
 kernel/timer.c  |    2 +-
 8 files changed, 12 insertions(+), 23 deletions(-)

diff -puN fs/fcntl.c~pidns-make-full-use-of-xxx_vnr-calls fs/fcntl.c
--- a/fs/fcntl.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/fs/fcntl.c
@@ -309,7 +309,7 @@ pid_t f_getown(struct file *filp)
 {
 	pid_t pid;
 	read_lock(&filp->f_owner.lock);
-	pid = pid_nr_ns(filp->f_owner.pid, current->nsproxy->pid_ns);
+	pid = pid_vnr(filp->f_owner.pid);
 	if (filp->f_owner.pid_type == PIDTYPE_PGID)
 		pid = -pid;
 	read_unlock(&filp->f_owner.lock);
diff -puN fs/locks.c~pidns-make-full-use-of-xxx_vnr-calls fs/locks.c
--- a/fs/locks.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/fs/locks.c
@@ -658,8 +658,7 @@ posix_test_lock(struct file *filp, struc
 	if (cfl) {
 		__locks_copy_lock(fl, cfl);
 		if (cfl->fl_nspid)
-			fl->fl_pid = pid_nr_ns(cfl->fl_nspid,
-						task_active_pid_ns(current));
+			fl->fl_pid = pid_vnr(cfl->fl_nspid);
 	} else
 		fl->fl_type = F_UNLCK;
 	unlock_kernel();
@@ -2084,7 +2083,7 @@ static void lock_get_status(struct seq_f
 	unsigned int fl_pid;
 
 	if (fl->fl_nspid)
-		fl_pid = pid_nr_ns(fl->fl_nspid, task_active_pid_ns(current));
+		fl_pid = pid_vnr(fl->fl_nspid);
 	else
 		fl_pid = fl->fl_pid;
 
diff -puN ipc/mqueue.c~pidns-make-full-use-of-xxx_vnr-calls ipc/mqueue.c
--- a/ipc/mqueue.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/ipc/mqueue.c
@@ -332,8 +332,7 @@ static ssize_t mqueue_read_file(struct f
 			(info->notify_owner &&
 			 info->notify.sigev_notify == SIGEV_SIGNAL) ?
 				info->notify.sigev_signo : 0,
-			pid_nr_ns(info->notify_owner,
-				current->nsproxy->pid_ns));
+			pid_vnr(info->notify_owner));
 	spin_unlock(&info->lock);
 	buffer[sizeof(buffer)-1] = '\0';
 	slen = strlen(buffer)+1;
diff -puN kernel/exit.c~pidns-make-full-use-of-xxx_vnr-calls kernel/exit.c
--- a/kernel/exit.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/exit.c
@@ -1174,7 +1174,7 @@ static int wait_task_zombie(struct task_
 {
 	unsigned long state;
 	int retval, status, traced;
-	pid_t pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	pid_t pid = task_pid_vnr(p);
 
 	if (unlikely(noreap)) {
 		uid_t uid = p->uid;
@@ -1369,7 +1369,7 @@ unlock_sig:
 	 * possibly take page faults for user memory.
 	 */
 	get_task_struct(p);
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	pid = task_pid_vnr(p);
 	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
@@ -1428,7 +1428,7 @@ static int wait_task_continued(struct ta
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	pid = task_pid_vnr(p);
 	uid = p->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
diff -puN kernel/fork.c~pidns-make-full-use-of-xxx_vnr-calls kernel/fork.c
--- a/kernel/fork.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/fork.c
@@ -1488,13 +1488,7 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
-		/*
-		 * this is enough to call pid_nr_ns here, but this if
-		 * improves optimisation of regular fork()
-		 */
-		nr = (clone_flags & CLONE_NEWPID) ?
-			task_pid_nr_ns(p, current->nsproxy->pid_ns) :
-				task_pid_vnr(p);
+		nr = task_pid_vnr(p);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
 			put_user(nr, parent_tidptr);
diff -puN kernel/sys.c~pidns-make-full-use-of-xxx_vnr-calls kernel/sys.c
--- a/kernel/sys.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/sys.c
@@ -991,17 +991,14 @@ asmlinkage long sys_getpgid(pid_t pid)
 	else {
 		int retval;
 		struct task_struct *p;
-		struct pid_namespace *ns;
-
-		ns = current->nsproxy->pid_ns;
 
 		read_lock(&tasklist_lock);
-		p = find_task_by_pid_ns(pid, ns);
+		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
 		if (p) {
 			retval = security_task_getpgid(p);
 			if (!retval)
-				retval = task_pgrp_nr_ns(p, ns);
+				retval = task_pgrp_vnr(p);
 		}
 		read_unlock(&tasklist_lock);
 		return retval;
diff -puN kernel/sysctl.c~pidns-make-full-use-of-xxx_vnr-calls kernel/sysctl.c
--- a/kernel/sysctl.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/sysctl.c
@@ -2488,7 +2488,7 @@ static int proc_do_cad_pid(struct ctl_ta
 	pid_t tmp;
 	int r;
 
-	tmp = pid_nr_ns(cad_pid, current->nsproxy->pid_ns);
+	tmp = pid_vnr(cad_pid);
 
 	r = __do_proc_dointvec(&tmp, table, write, filp, buffer,
 			       lenp, ppos, NULL, NULL);
diff -puN kernel/timer.c~pidns-make-full-use-of-xxx_vnr-calls kernel/timer.c
--- a/kernel/timer.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/timer.c
@@ -979,7 +979,7 @@ asmlinkage long sys_getppid(void)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_tgid_nr_ns(current->real_parent, current->nsproxy->pid_ns);
+	pid = task_tgid_vnr(current->real_parent);
 	rcu_read_unlock();
 
 	return pid;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
