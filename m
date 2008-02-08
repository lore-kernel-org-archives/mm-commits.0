From: akpm@linux-foundation.org
Subject: - pid-sys_wait-fixes-v2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:09 -0800
Message-ID: <200802082013.m18KDoHE010327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810AbYBHVCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid: sys_wait... fixes
has been removed from the -mm tree.  Its filename was
     pid-sys_wait-fixes-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid: sys_wait... fixes
From: Eric W. Biederman <ebiederm@xmission.com>

This modifies do_wait and eligible child to take a pair of enum pid_type
and struct pid *pid to precisely specify what set of processes are eligible
to be waited for, instead of the raw pid_t value from sys_wait4.

This fixes a bug in sys_waitid where you could not wait for children in
just process group 1.

This fixes a pid namespace crossing case in eligible_child.  Allowing us to
wait for a processes in our current process group even if our current
process group == 0.

This allows the no child with this pid case to be optimized.  This allows
us to optimize the pid membership test in eligible child to be optimized.

This even closes a theoretical pid wraparound race where in a threaded
parent if two threads are waiting for the same child and one thread picks
up the child and the pid numbers wrap around and generate another child
with that same pid before the other thread is scheduled (teribly insanely
unlikely) we could end up waiting on the second child with the same pid#
and not discover that the specific child we were waiting for has exited.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   80 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 24 deletions(-)

diff -puN kernel/exit.c~pid-sys_wait-fixes-v2 kernel/exit.c
--- a/kernel/exit.c~pid-sys_wait-fixes-v2
+++ a/kernel/exit.c
@@ -1090,20 +1090,23 @@ asmlinkage void sys_exit_group(int error
 	do_group_exit((error_code & 0xff) << 8);
 }
 
-static int eligible_child(pid_t pid, int options, struct task_struct *p)
+static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
+{
+	struct pid *pid = NULL;
+	if (type == PIDTYPE_PID)
+		pid = task->pids[type].pid;
+	else if (type < PIDTYPE_MAX)
+		pid = task->group_leader->pids[type].pid;
+	return pid;
+}
+
+static int eligible_child(enum pid_type type, struct pid *pid, int options,
+			  struct task_struct *p)
 {
 	int err;
-	struct pid_namespace *ns;
 
-	ns = current->nsproxy->pid_ns;
-	if (pid > 0) {
-		if (task_pid_nr_ns(p, ns) != pid)
-			return 0;
-	} else if (!pid) {
-		if (task_pgrp_nr_ns(p, ns) != task_pgrp_vnr(current))
-			return 0;
-	} else if (pid != -1) {
-		if (task_pgrp_nr_ns(p, ns) != -pid)
+	if (type < PIDTYPE_MAX) {
+		if (task_pid_type(p, type) != pid)
 			return 0;
 	}
 
@@ -1127,7 +1130,7 @@ static int eligible_child(pid_t pid, int
 	if (likely(!err))
 		return 1;
 
-	if (pid <= 0)
+	if (type != PIDTYPE_PID)
 		return 0;
 	/* This child was explicitly requested, abort */
 	read_unlock(&tasklist_lock);
@@ -1447,8 +1450,9 @@ static int wait_task_continued(struct ta
 	return retval;
 }
 
-static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
-		    int __user *stat_addr, struct rusage __user *ru)
+static long do_wait(enum pid_type type, struct pid *pid, int options,
+		    struct siginfo __user *infop, int __user *stat_addr,
+		    struct rusage __user *ru)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
@@ -1456,6 +1460,11 @@ static long do_wait(pid_t pid, int optio
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
+	/* If there is nothing that can match our critier just get out */
+	retval = -ECHILD;
+	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
+		goto end;
+
 	/*
 	 * We will set this flag if we see any child that might later
 	 * match our criteria, even if we are not able to reap it yet.
@@ -1468,7 +1477,7 @@ repeat:
 		struct task_struct *p;
 
 		list_for_each_entry(p, &tsk->children, sibling) {
-			int ret = eligible_child(pid, options, p);
+			int ret = eligible_child(type, pid, options, p);
 			if (!ret)
 				continue;
 
@@ -1515,7 +1524,7 @@ repeat:
 		if (!flag) {
 			list_for_each_entry(p, &tsk->ptrace_children,
 								ptrace_list) {
-				flag = eligible_child(pid, options, p);
+				flag = eligible_child(type, pid, options, p);
 				if (!flag)
 					continue;
 				if (likely(flag > 0))
@@ -1570,10 +1579,12 @@ end:
 	return retval;
 }
 
-asmlinkage long sys_waitid(int which, pid_t pid,
+asmlinkage long sys_waitid(int which, pid_t upid,
 			   struct siginfo __user *infop, int options,
 			   struct rusage __user *ru)
 {
+	struct pid *pid = NULL;
+	enum pid_type type;
 	long ret;
 
 	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED))
@@ -1583,37 +1594,58 @@ asmlinkage long sys_waitid(int which, pi
 
 	switch (which) {
 	case P_ALL:
-		pid = -1;
+		type = PIDTYPE_MAX;
 		break;
 	case P_PID:
-		if (pid <= 0)
+		type = PIDTYPE_PID;
+		if (upid <= 0)
 			return -EINVAL;
 		break;
 	case P_PGID:
-		if (pid <= 0)
+		type = PIDTYPE_PGID;
+		if (upid <= 0)
 			return -EINVAL;
-		pid = -pid;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	ret = do_wait(pid, options, infop, NULL, ru);
+	if (type < PIDTYPE_MAX)
+		pid = find_get_pid(upid);
+	ret = do_wait(type, pid, options, infop, NULL, ru);
+	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
 	prevent_tail_call(ret);
 	return ret;
 }
 
-asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
+asmlinkage long sys_wait4(pid_t upid, int __user *stat_addr,
 			  int options, struct rusage __user *ru)
 {
+	struct pid *pid = NULL;
+	enum pid_type type;
 	long ret;
 
 	if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
 			__WNOTHREAD|__WCLONE|__WALL))
 		return -EINVAL;
-	ret = do_wait(pid, options | WEXITED, NULL, stat_addr, ru);
+
+	if (upid == -1)
+		type = PIDTYPE_MAX;
+	else if (upid < 0) {
+		type = PIDTYPE_PGID;
+		pid = find_get_pid(-upid);
+	} else if (upid == 0) {
+		type = PIDTYPE_PGID;
+		pid = get_pid(task_pgrp(current));
+	} else /* upid > 0 */ {
+		type = PIDTYPE_PID;
+		pid = find_get_pid(upid);
+	}
+
+	ret = do_wait(type, pid, options | WEXITED, NULL, stat_addr, ru);
+	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
 	prevent_tail_call(ret);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
