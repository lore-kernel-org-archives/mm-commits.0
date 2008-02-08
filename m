From: akpm@linux-foundation.org
Subject: - pid-extend-fix-pid_vnr.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:12 -0800
Message-ID: <200802082013.m18KDrG3010330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758063AbYBHVB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid: Extend/Fix pid_vnr
has been removed from the -mm tree.  Its filename was
     pid-extend-fix-pid_vnr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid: Extend/Fix pid_vnr
From: Eric W. Biederman <ebiederm@xmission.com>

pid_vnr returns the user space pid with respect to the pid namespace the
struct pid was allocated in.  What we want before we return a pid to user
space is the user space pid with respect to the pid namespace of current.

pid_vnr is a very nice optimization but because it isn't quite what we want
it is easy to use pid_vnr at times when we aren't certain the struct pid
was allocated in our pid namespace.

Currently this describes at least tiocgpgrp and tiocgsid in ttyio.c the
parent process reported in the core dumps and the parent process in
get_signal_to_deliver.

So unless the performance impact is huge having an interface that does what
we want instead of always what we want should be much more reliable and
much less error prone.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h   |   14 +++-----------
 include/linux/sched.h |    5 ++---
 kernel/pid.c          |    6 ++++++
 3 files changed, 11 insertions(+), 14 deletions(-)

diff -puN include/linux/pid.h~pid-extend-fix-pid_vnr include/linux/pid.h
--- a/include/linux/pid.h~pid-extend-fix-pid_vnr
+++ a/include/linux/pid.h
@@ -127,9 +127,8 @@ extern void FASTCALL(free_pid(struct pid
  * the helpers to get the pid's id seen from different namespaces
  *
  * pid_nr()    : global id, i.e. the id seen from the init namespace;
- * pid_vnr()   : virtual id, i.e. the id seen from the namespace this pid
- *               belongs to. this only makes sence when called in the
- *               context of the task that belongs to the same namespace;
+ * pid_vnr()   : virtual id, i.e. the id seen from the pid namespace of
+ *               current.
  * pid_nr_ns() : id seen from the ns specified.
  *
  * see also task_xid_nr() etc in include/linux/sched.h
@@ -144,14 +143,7 @@ static inline pid_t pid_nr(struct pid *p
 }
 
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
-
-static inline pid_t pid_vnr(struct pid *pid)
-{
-	pid_t nr = 0;
-	if (pid)
-		nr = pid->numbers[pid->level].nr;
-	return nr;
-}
+pid_t pid_vnr(struct pid *pid);
 
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
diff -puN include/linux/sched.h~pid-extend-fix-pid_vnr include/linux/sched.h
--- a/include/linux/sched.h~pid-extend-fix-pid_vnr
+++ a/include/linux/sched.h
@@ -1332,9 +1332,8 @@ struct pid_namespace;
  * from various namespaces
  *
  * task_xid_nr()     : global id, i.e. the id seen from the init namespace;
- * task_xid_vnr()    : virtual id, i.e. the id seen from the namespace the task
- *                     belongs to. this only makes sence when called in the
- *                     context of the task that belongs to the same namespace;
+ * task_xid_vnr()    : virtual id, i.e. the id seen from the pid namespace of
+ *                     current.
  * task_xid_nr_ns()  : id seen from the ns specified;
  *
  * set_task_vxid()   : assigns a virtual id to a task;
diff -puN kernel/pid.c~pid-extend-fix-pid_vnr kernel/pid.c
--- a/kernel/pid.c~pid-extend-fix-pid_vnr
+++ a/kernel/pid.c
@@ -443,6 +443,12 @@ pid_t pid_nr_ns(struct pid *pid, struct 
 	return nr;
 }
 
+pid_t pid_vnr(struct pid *pid)
+{
+	return pid_nr_ns(pid, current->nsproxy->pid_ns);
+}
+EXPORT_SYMBOL_GPL(pid_vnr);
+
 pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_pid(tsk), ns);
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
