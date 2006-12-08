From: akpm@osdl.org
Subject: - add-child-reaper-to-pid_namespace.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:05 -0800
Message-ID: <200612082006.kB8K6534002358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946248AbWLHUJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     add child reaper to pid_namespace
has been removed from the -mm tree.  Its filename was
     add-child-reaper-to-pid_namespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add child reaper to pid_namespace
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Add a per pid_namespace child-reaper.  This is needed so processes are reaped
within the same pid space and do not spill over to the parent pid space.  Its
also needed so containers preserve existing semantic that pid == 1 would reap
orphaned children.

This is based on Eric Biederman's patch: http://lkml.org/lkml/2006/2/6/285

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/exec.c                     |    5 +++--
 include/linux/pid.h           |    5 +++--
 include/linux/pid_namespace.h |    6 ++++++
 include/linux/sched.h         |    1 -
 init/main.c                   |    5 ++---
 kernel/exit.c                 |   23 +++++++++++++++--------
 kernel/pid.c                  |    3 ++-
 kernel/signal.c               |   11 +++++++++--
 8 files changed, 40 insertions(+), 19 deletions(-)

diff -puN fs/exec.c~add-child-reaper-to-pid_namespace fs/exec.c
--- a/fs/exec.c~add-child-reaper-to-pid_namespace
+++ a/fs/exec.c
@@ -38,6 +38,7 @@
 #include <linux/binfmts.h>
 #include <linux/swap.h>
 #include <linux/utsname.h>
+#include <linux/pid_namespace.h>
 #include <linux/module.h>
 #include <linux/namei.h>
 #include <linux/proc_fs.h>
@@ -620,8 +621,8 @@ static int de_thread(struct task_struct 
 	 * Reparenting needs write_lock on tasklist_lock,
 	 * so it is safe to do it under read_lock.
 	 */
-	if (unlikely(tsk->group_leader == child_reaper))
-		child_reaper = tsk;
+	if (unlikely(tsk->group_leader == child_reaper(tsk)))
+		tsk->nsproxy->pid_ns->child_reaper = tsk;
 
 	zap_other_threads(tsk);
 	read_unlock(&tasklist_lock);
diff -puN include/linux/pid.h~add-child-reaper-to-pid_namespace include/linux/pid.h
--- a/include/linux/pid.h~add-child-reaper-to-pid_namespace
+++ a/include/linux/pid.h
@@ -35,8 +35,9 @@ enum pid_type
  *
  * Holding a reference to struct pid solves both of these problems.
  * It is small so holding a reference does not consume a lot of
- * resources, and since a new struct pid is allocated when the numeric
- * pid value is reused we don't mistakenly refer to new processes.
+ * resources, and since a new struct pid is allocated when the numeric pid
+ * value is reused (when pids wrap around) we don't mistakenly refer to new
+ * processes.
  */
 
 struct pid
diff -puN include/linux/pid_namespace.h~add-child-reaper-to-pid_namespace include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~add-child-reaper-to-pid_namespace
+++ a/include/linux/pid_namespace.h
@@ -19,6 +19,7 @@ struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
 	int last_pid;
+	struct task_struct *child_reaper;
 };
 
 extern struct pid_namespace init_pid_ns;
@@ -36,4 +37,9 @@ static inline void put_pid_ns(struct pid
 	kref_put(&ns->kref, free_pid_ns);
 }
 
+static inline struct task_struct *child_reaper(struct task_struct *tsk)
+{
+	return tsk->nsproxy->pid_ns->child_reaper;
+}
+
 #endif /* _LINUX_PID_NS_H */
diff -puN include/linux/sched.h~add-child-reaper-to-pid_namespace include/linux/sched.h
--- a/include/linux/sched.h~add-child-reaper-to-pid_namespace
+++ a/include/linux/sched.h
@@ -1400,7 +1400,6 @@ extern NORET_TYPE void do_group_exit(int
 extern void daemonize(const char *, ...);
 extern int allow_signal(int);
 extern int disallow_signal(int);
-extern struct task_struct *child_reaper;
 
 extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
diff -puN init/main.c~add-child-reaper-to-pid_namespace init/main.c
--- a/init/main.c~add-child-reaper-to-pid_namespace
+++ a/init/main.c
@@ -51,6 +51,7 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/utsrelease.h>
+#include <linux/pid_namespace.h>
 #include <linux/compile.h>
 
 #include <asm/io.h>
@@ -626,8 +627,6 @@ static int __init initcall_debug_setup(c
 }
 __setup("initcall_debug", initcall_debug_setup);
 
-struct task_struct *child_reaper = &init_task;
-
 extern initcall_t __initcall_start[], __initcall_end[];
 
 static void __init do_initcalls(void)
@@ -727,7 +726,7 @@ static int init(void * unused)
 	 * assumptions about where in the task array this
 	 * can be found.
 	 */
-	child_reaper = current;
+	init_pid_ns.child_reaper = current;
 
 	cad_pid = task_pid(current);
 
diff -puN kernel/exit.c~add-child-reaper-to-pid_namespace kernel/exit.c
--- a/kernel/exit.c~add-child-reaper-to-pid_namespace
+++ a/kernel/exit.c
@@ -22,6 +22,7 @@
 #include <linux/file.h>
 #include <linux/binfmts.h>
 #include <linux/nsproxy.h>
+#include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/profile.h>
 #include <linux/mount.h>
@@ -48,7 +49,6 @@
 #include <asm/mmu_context.h>
 
 extern void sem_exit (void);
-extern struct task_struct *child_reaper;
 
 static void exit_mm(struct task_struct * tsk);
 
@@ -260,7 +260,8 @@ static int has_stopped_jobs(int pgrp)
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task.
+ * reparent_to_init - Reparent the calling kernel thread to the init task
+ * of the pid space that the thread belongs to.
  *
  * If a kernel thread is launched as a result of a system call, or if
  * it ever exits, it should generally reparent itself to init so that
@@ -278,8 +279,8 @@ static void reparent_to_init(void)
 	ptrace_unlink(current);
 	/* Reparent to init */
 	remove_parent(current);
-	current->parent = child_reaper;
-	current->real_parent = child_reaper;
+	current->parent = child_reaper(current);
+	current->real_parent = child_reaper(current);
 	add_parent(current);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
@@ -662,7 +663,8 @@ reparent_thread(struct task_struct *p, s
  * When we die, we re-parent all our children.
  * Try to give them to another thread in our thread
  * group, and if no such member exists, give it to
- * the global child reaper process (ie "init")
+ * the child reaper process (ie "init") in our pid
+ * space.
  */
 static void
 forget_original_parent(struct task_struct *father, struct list_head *to_release)
@@ -673,7 +675,7 @@ forget_original_parent(struct task_struc
 	do {
 		reaper = next_thread(reaper);
 		if (reaper == father) {
-			reaper = child_reaper;
+			reaper = child_reaper(father);
 			break;
 		}
 	} while (reaper->exit_state);
@@ -859,8 +861,13 @@ fastcall NORET_TYPE void do_exit(long co
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
-	if (unlikely(tsk == child_reaper))
-		panic("Attempted to kill init!");
+	if (unlikely(tsk == child_reaper(tsk))) {
+		if (tsk->nsproxy->pid_ns != &init_pid_ns)
+			tsk->nsproxy->pid_ns->child_reaper = init_pid_ns.child_reaper;
+		else
+			panic("Attempted to kill init!");
+	}
+
 
 	if (unlikely(current->ptrace & PT_TRACE_EXIT)) {
 		current->ptrace_message = code;
diff -puN kernel/pid.c~add-child-reaper-to-pid_namespace kernel/pid.c
--- a/kernel/pid.c~add-child-reaper-to-pid_namespace
+++ a/kernel/pid.c
@@ -65,7 +65,8 @@ struct pid_namespace init_pid_ns = {
 	.pidmap = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
-	.last_pid = 0
+	.last_pid = 0,
+	.child_reaper = &init_task
 };
 
 /*
diff -puN kernel/signal.c~add-child-reaper-to-pid_namespace kernel/signal.c
--- a/kernel/signal.c~add-child-reaper-to-pid_namespace
+++ a/kernel/signal.c
@@ -24,6 +24,9 @@
 #include <linux/signal.h>
 #include <linux/capability.h>
 #include <linux/freezer.h>
+#include <linux/pid_namespace.h>
+#include <linux/nsproxy.h>
+
 #include <asm/param.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1877,8 +1880,12 @@ relock:
 		if (sig_kernel_ignore(signr)) /* Default is nothing. */
 			continue;
 
-		/* Init gets no signals it doesn't want.  */
-		if (current == child_reaper)
+		/*
+		 * Init of a pid space gets no signals it doesn't want from
+		 * within that pid space. It can of course get signals from
+		 * its parent pid space.
+		 */
+		if (current == child_reaper(current))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

add-child-reaper-to-pid_namespace.patch

