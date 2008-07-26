From: akpm@linux-foundation.org
Subject: - tracehook-tracehook_tracer_task.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:47 -0700
Message-ID: <200807262116.m6QLGlL5019865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737AbYGZVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: tracehook_tracer_task
has been removed from the -mm tree.  Its filename was
     tracehook-tracehook_tracer_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: tracehook_tracer_task
From: Roland McGrath <roland@redhat.com>

This adds the tracehook_tracer_task() hook to consolidate all forms of
"Who is using ptrace on me?" logic.  This is used for "TracerPid:" in
/proc and for permission checks.  We also clean up the selinux code the
called an identical accessor.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c           |    9 +++++++--
 fs/proc/base.c            |   13 +++++++++----
 include/linux/tracehook.h |   18 ++++++++++++++++++
 security/selinux/hooks.c  |   22 +++-------------------
 4 files changed, 37 insertions(+), 25 deletions(-)

diff -puN fs/proc/array.c~tracehook-tracehook_tracer_task fs/proc/array.c
--- a/fs/proc/array.c~tracehook-tracehook_tracer_task
+++ a/fs/proc/array.c
@@ -80,6 +80,7 @@
 #include <linux/delayacct.h>
 #include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
+#include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -168,8 +169,12 @@ static inline void task_state(struct seq
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
-	tpid = pid_alive(p) && p->ptrace ?
-		task_pid_nr_ns(rcu_dereference(p->parent), ns) : 0;
+	tpid = 0;
+	if (pid_alive(p)) {
+		struct task_struct *tracer = tracehook_tracer_task(p);
+		if (tracer)
+			tpid = task_pid_nr_ns(tracer, ns);
+	}
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
diff -puN fs/proc/base.c~tracehook-tracehook_tracer_task fs/proc/base.c
--- a/fs/proc/base.c~tracehook-tracehook_tracer_task
+++ a/fs/proc/base.c
@@ -69,6 +69,7 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -231,10 +232,14 @@ static int check_mem_permission(struct t
 	 * If current is actively ptrace'ing, and would also be
 	 * permitted to freshly attach with ptrace now, permit it.
 	 */
-	if (task->parent == current && (task->ptrace & PT_PTRACED) &&
-	    task_is_stopped_or_traced(task) &&
-	    ptrace_may_access(task, PTRACE_MODE_ATTACH))
-		return 0;
+	if (task_is_stopped_or_traced(task)) {
+		int match;
+		rcu_read_lock();
+		match = (tracehook_tracer_task(task) == current);
+		rcu_read_unlock();
+		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
+			return 0;
+	}
 
 	/*
 	 * Noone else is allowed.
diff -puN include/linux/tracehook.h~tracehook-tracehook_tracer_task include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tracehook_tracer_task
+++ a/include/linux/tracehook.h
@@ -73,6 +73,24 @@ static inline int tracehook_unsafe_exec(
 }
 
 /**
+ * tracehook_tracer_task - return the task that is tracing the given task
+ * @tsk:		task to consider
+ *
+ * Returns NULL if noone is tracing @task, or the &struct task_struct
+ * pointer to its tracer.
+ *
+ * Must called under rcu_read_lock().  The pointer returned might be kept
+ * live only by RCU.  During exec, this may be called with task_lock()
+ * held on @task, still held from when tracehook_unsafe_exec() was called.
+ */
+static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
+{
+	if (task_ptrace(tsk) & PT_PTRACED)
+		return rcu_dereference(tsk->parent);
+	return NULL;
+}
+
+/**
  * tracehook_report_exec - a successful exec was completed
  * @fmt:		&struct linux_binfmt that performed the exec
  * @bprm:		&struct linux_binprm containing exec details
diff -puN security/selinux/hooks.c~tracehook-tracehook_tracer_task security/selinux/hooks.c
--- a/security/selinux/hooks.c~tracehook-tracehook_tracer_task
+++ a/security/selinux/hooks.c
@@ -25,7 +25,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/security.h>
@@ -1971,22 +1971,6 @@ static int selinux_vm_enough_memory(stru
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
-/**
- * task_tracer_task - return the task that is tracing the given task
- * @task:		task to consider
- *
- * Returns NULL if noone is tracing @task, or the &struct task_struct
- * pointer to its tracer.
- *
- * Must be called under rcu_read_lock().
- */
-static struct task_struct *task_tracer_task(struct task_struct *task)
-{
-	if (task->ptrace & PT_PTRACED)
-		return rcu_dereference(task->parent);
-	return NULL;
-}
-
 /* binprm security operations */
 
 static int selinux_bprm_alloc_security(struct linux_binprm *bprm)
@@ -2238,7 +2222,7 @@ static void selinux_bprm_apply_creds(str
 			u32 ptsid = 0;
 
 			rcu_read_lock();
-			tracer = task_tracer_task(current);
+			tracer = tracehook_tracer_task(current);
 			if (likely(tracer != NULL)) {
 				sec = tracer->security;
 				ptsid = sec->sid;
@@ -5247,7 +5231,7 @@ static int selinux_setprocattr(struct ta
 		   Otherwise, leave SID unchanged and fail. */
 		task_lock(p);
 		rcu_read_lock();
-		tracer = task_tracer_task(p);
+		tracer = tracehook_tracer_task(p);
 		if (tracer != NULL) {
 			struct task_security_struct *ptsec = tracer->security;
 			u32 ptsid = ptsec->sid;
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

