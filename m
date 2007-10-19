From: akpm@linux-foundation.org
Subject: - isolate-the-explicit-usage-of-signal-pgrp.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:09 -0700
Message-ID: <200710192253.l9JMr9xq024406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763923AbXJSXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, oleg@tv-sign.ru, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Isolate the explicit usage of signal->pgrp
has been removed from the -mm tree.  Its filename was
     isolate-the-explicit-usage-of-signal-pgrp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Isolate the explicit usage of signal->pgrp
From: Pavel Emelyanov <xemul@openvz.org>

The pgrp field is not used widely around the kernel so it is now marked as
deprecated with appropriate comment.

The initialization of INIT_SIGNALS is trimmed because
a) they are set to 0 automatically;
b) gcc cannot properly initialize two anonymous (the second one
   is the one with the session) unions. In this particular case
   to make it compile we'd have to add some field initialized
   right before the .pgrp.

This is the same patch as the 1ec320afdc9552c92191d5f89fcd1ebe588334ca one
(from Cedric), but for the pgrp field.

Some progress report:

We have to deprecate the pid, tgid, session and pgrp fields on struct
task_struct and struct signal_struct.  The session and pgrp are already
deprecated.  The tgid value is close to being such - the worst known usage
in in fs/locks.c and audit code.  The pid field deprecation is mainly
blocked by numerous printk-s around the kernel that print the tsk->pid to
log.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    3 ---
 include/linux/sched.h     |   19 +++++++++++++++++--
 kernel/exit.c             |    2 +-
 kernel/fork.c             |    4 ++--
 kernel/sys.c              |    2 +-
 5 files changed, 21 insertions(+), 9 deletions(-)

diff -puN include/linux/init_task.h~isolate-the-explicit-usage-of-signal-pgrp include/linux/init_task.h
--- a/include/linux/init_task.h~isolate-the-explicit-usage-of-signal-pgrp
+++ a/include/linux/init_task.h
@@ -67,9 +67,6 @@
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
-	.pgrp		= 0,						\
-	.tty_old_pgrp   = NULL,						\
-	{ .__session      = 0},						\
 }
 
 extern struct nsproxy init_nsproxy;
diff -puN include/linux/sched.h~isolate-the-explicit-usage-of-signal-pgrp include/linux/sched.h
--- a/include/linux/sched.h~isolate-the-explicit-usage-of-signal-pgrp
+++ a/include/linux/sched.h
@@ -429,7 +429,17 @@ struct signal_struct {
 	cputime_t it_prof_incr, it_virt_incr;
 
 	/* job control IDs */
-	pid_t pgrp;
+
+	/*
+	 * pgrp and session fields are deprecated.
+	 * use the task_session_Xnr and task_pgrp_Xnr routines below
+	 */
+
+	union {
+		pid_t pgrp __deprecated;
+		pid_t __pgrp;
+	};
+
 	struct pid *tty_old_pgrp;
 
 	union {
@@ -1196,6 +1206,11 @@ static inline void set_task_session(stru
 	tsk->signal->__session = session;
 }
 
+static inline void set_task_pgrp(struct task_struct *tsk, pid_t pgrp)
+{
+	tsk->signal->__pgrp = pgrp;
+}
+
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
@@ -1268,7 +1283,7 @@ static inline pid_t task_tgid_vnr(struct
 
 static inline pid_t task_pgrp_nr(struct task_struct *tsk)
 {
-	return tsk->signal->pgrp;
+	return tsk->signal->__pgrp;
 }
 
 pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
diff -puN kernel/exit.c~isolate-the-explicit-usage-of-signal-pgrp kernel/exit.c
--- a/kernel/exit.c~isolate-the-explicit-usage-of-signal-pgrp
+++ a/kernel/exit.c
@@ -306,7 +306,7 @@ void __set_special_pids(pid_t session, p
 	}
 	if (task_pgrp_nr(curr) != pgrp) {
 		detach_pid(curr, PIDTYPE_PGID);
-		curr->signal->pgrp = pgrp;
+		set_task_pgrp(curr, pgrp);
 		attach_pid(curr, PIDTYPE_PGID, find_pid(pgrp));
 	}
 }
diff -puN kernel/fork.c~isolate-the-explicit-usage-of-signal-pgrp kernel/fork.c
--- a/kernel/fork.c~isolate-the-explicit-usage-of-signal-pgrp
+++ a/kernel/fork.c
@@ -1293,13 +1293,13 @@ static struct task_struct *copy_process(
 			if (clone_flags & CLONE_NEWPID) {
 				p->nsproxy->pid_ns->child_reaper = p;
 				p->signal->tty = NULL;
-				p->signal->pgrp = p->pid;
+				set_task_pgrp(p, p->pid);
 				set_task_session(p, p->pid);
 				attach_pid(p, PIDTYPE_PGID, pid);
 				attach_pid(p, PIDTYPE_SID, pid);
 			} else {
 				p->signal->tty = current->signal->tty;
-				p->signal->pgrp = task_pgrp_nr(current);
+				set_task_pgrp(p, task_pgrp_nr(current));
 				set_task_session(p, task_session_nr(current));
 				attach_pid(p, PIDTYPE_PGID,
 						task_pgrp(current));
diff -puN kernel/sys.c~isolate-the-explicit-usage-of-signal-pgrp kernel/sys.c
--- a/kernel/sys.c~isolate-the-explicit-usage-of-signal-pgrp
+++ a/kernel/sys.c
@@ -977,7 +977,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		detach_pid(p, PIDTYPE_PGID);
 		pid = find_vpid(pgid);
 		attach_pid(p, PIDTYPE_PGID, pid);
-		p->signal->pgrp = pid_nr(pid);
+		set_task_pgrp(p, pid_nr(pid));
 	}
 
 	err = 0;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
