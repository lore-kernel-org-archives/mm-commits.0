From: akpm@linux-foundation.org
Subject: + isolate-the-explicit-usage-of-signal-pgrp.patch added to -mm tree
Date: Mon, 20 Aug 2007 14:51:45 -0700
Message-ID: <200708202151.l7KLpj4W024931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbXHTVwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 17:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, oleg@tv-sign.ru, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     Isolate the explicit usage of signal->pgrp
has been added to the -mm tree.  Its filename is
     isolate-the-explicit-usage-of-signal-pgrp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -66,9 +66,6 @@
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
@@ -426,7 +426,17 @@ struct signal_struct {
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
@@ -1157,6 +1167,11 @@ static inline void set_task_session(stru
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
@@ -1237,7 +1252,7 @@ static inline pid_t task_tgid_vnr(struct
 
 static inline pid_t task_pgrp_nr(struct task_struct *tsk)
 {
-	return tsk->signal->pgrp;
+	return tsk->signal->__pgrp;
 }
 
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
diff -puN kernel/exit.c~isolate-the-explicit-usage-of-signal-pgrp kernel/exit.c
--- a/kernel/exit.c~isolate-the-explicit-usage-of-signal-pgrp
+++ a/kernel/exit.c
@@ -314,7 +314,7 @@ void __set_special_pids(pid_t session, p
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
@@ -1279,13 +1279,13 @@ static struct task_struct *copy_process(
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
@@ -976,7 +976,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		detach_pid(p, PIDTYPE_PGID);
 		pid = find_vpid(pgid);
 		attach_pid(p, PIDTYPE_PGID, pid);
-		p->signal->pgrp = pid_nr(pid);
+		set_task_pgrp(p, pid_nr(pid));
 	}
 
 	err = 0;
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
