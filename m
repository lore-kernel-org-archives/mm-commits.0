From: akpm@linux-foundation.org
Subject: + pids-introduce-find_get_task_by_vpid-helper.patch added to -mm
 tree
Date: Tue, 21 Nov 2017 15:20:42 -0800
Message-ID: <5a14b4ca.U15zeglMzq8KvCo3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdKUXUn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pids: introduce find_get_task_by_vpid() helper
has been added to the -mm tree.  Its filename is
     pids-introduce-find_get_task_by_vpid-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pids-introduce-find_get_task_by_vpid-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pids-introduce-find_get_task_by_vpid-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: pids: introduce find_get_task_by_vpid() helper

There are several functions that do find_task_by_vpid() followed by
get_task_struct().  We can use a helper function instead.

Link: http://lkml.kernel.org/r/1509602027-11337-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |   13 +++----------
 include/linux/sched.h      |    5 +++++
 kernel/futex.c             |   20 +-------------------
 kernel/pid.c               |   13 +++++++++++++
 kernel/ptrace.c            |   27 ++++++---------------------
 kernel/taskstats.c         |    6 +-----
 mm/process_vm_access.c     |    6 +-----
 security/yama/yama_lsm.c   |   11 +++--------
 8 files changed, 33 insertions(+), 68 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~pids-introduce-find_get_task_by_vpid-helper arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/arch/ia64/kernel/perfmon.c
@@ -2610,17 +2610,10 @@ pfm_get_task(pfm_context_t *ctx, pid_t p
 	if (pid < 2) return -EPERM;
 
 	if (pid != task_pid_vnr(current)) {
-
-		read_lock(&tasklist_lock);
-
-		p = find_task_by_vpid(pid);
-
 		/* make sure task cannot go away while we operate on it */
-		if (p) get_task_struct(p);
-
-		read_unlock(&tasklist_lock);
-
-		if (p == NULL) return -ESRCH;
+		p = find_get_task_by_vpid(pid);
+		if (!p)
+			return -ESRCH;
 	}
 
 	ret = pfm_task_incompatible(ctx, p);
diff -puN include/linux/sched.h~pids-introduce-find_get_task_by_vpid-helper include/linux/sched.h
--- a/include/linux/sched.h~pids-introduce-find_get_task_by_vpid-helper
+++ a/include/linux/sched.h
@@ -1486,6 +1486,11 @@ static inline struct thread_info *task_t
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns);
 
+/*
+ * find a task by its virtual pid and get the task struct
+ */
+extern struct task_struct *find_get_task_by_vpid(pid_t nr);
+
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk);
diff -puN kernel/futex.c~pids-introduce-find_get_task_by_vpid-helper kernel/futex.c
--- a/kernel/futex.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/kernel/futex.c
@@ -862,24 +862,6 @@ static void put_pi_state(struct futex_pi
 	}
 }
 
-/*
- * Look up the task based on what TID userspace gave us.
- * We dont trust it.
- */
-static struct task_struct *futex_find_get_task(pid_t pid)
-{
-	struct task_struct *p;
-
-	rcu_read_lock();
-	p = find_task_by_vpid(pid);
-	if (p)
-		get_task_struct(p);
-
-	rcu_read_unlock();
-
-	return p;
-}
-
 #ifdef CONFIG_FUTEX_PI
 
 /*
@@ -1183,7 +1165,7 @@ static int attach_to_pi_owner(u32 uval,
 	 */
 	if (!pid)
 		return -ESRCH;
-	p = futex_find_get_task(pid);
+	p = find_get_task_by_vpid(pid);
 	if (!p)
 		return -ESRCH;
 
diff -puN kernel/pid.c~pids-introduce-find_get_task_by_vpid-helper kernel/pid.c
--- a/kernel/pid.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/kernel/pid.c
@@ -329,6 +329,19 @@ struct task_struct *find_task_by_vpid(pi
 	return find_task_by_pid_ns(vnr, task_active_pid_ns(current));
 }
 
+struct task_struct *find_get_task_by_vpid(pid_t nr)
+{
+	struct task_struct *task;
+
+	rcu_read_lock();
+	task = find_task_by_vpid(nr);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	return task;
+}
+
 struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid;
diff -puN kernel/ptrace.c~pids-introduce-find_get_task_by_vpid-helper kernel/ptrace.c
--- a/kernel/ptrace.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/kernel/ptrace.c
@@ -1099,21 +1099,6 @@ int ptrace_request(struct task_struct *c
 	return ret;
 }
 
-static struct task_struct *ptrace_get_task_struct(pid_t pid)
-{
-	struct task_struct *child;
-
-	rcu_read_lock();
-	child = find_task_by_vpid(pid);
-	if (child)
-		get_task_struct(child);
-	rcu_read_unlock();
-
-	if (!child)
-		return ERR_PTR(-ESRCH);
-	return child;
-}
-
 #ifndef arch_ptrace_attach
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
@@ -1131,9 +1116,9 @@ SYSCALL_DEFINE4(ptrace, long, request, l
 		goto out;
 	}
 
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
+	child = find_get_task_by_vpid(pid);
+	if (!child) {
+		ret = -ESRCH;
 		goto out;
 	}
 
@@ -1278,9 +1263,9 @@ COMPAT_SYSCALL_DEFINE4(ptrace, compat_lo
 		goto out;
 	}
 
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
+	child = find_get_task_by_vpid(pid);
+	if (!child) {
+		ret = -ESRCH;
 		goto out;
 	}
 
diff -puN kernel/taskstats.c~pids-introduce-find_get_task_by_vpid-helper kernel/taskstats.c
--- a/kernel/taskstats.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/kernel/taskstats.c
@@ -194,11 +194,7 @@ static int fill_stats_for_pid(pid_t pid,
 {
 	struct task_struct *tsk;
 
-	rcu_read_lock();
-	tsk = find_task_by_vpid(pid);
-	if (tsk)
-		get_task_struct(tsk);
-	rcu_read_unlock();
+	tsk = find_get_task_by_vpid(pid);
 	if (!tsk)
 		return -ESRCH;
 	fill_stats(current_user_ns(), task_active_pid_ns(current), tsk, stats);
diff -puN mm/process_vm_access.c~pids-introduce-find_get_task_by_vpid-helper mm/process_vm_access.c
--- a/mm/process_vm_access.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/mm/process_vm_access.c
@@ -197,11 +197,7 @@ static ssize_t process_vm_rw_core(pid_t
 	}
 
 	/* Get process information */
-	rcu_read_lock();
-	task = find_task_by_vpid(pid);
-	if (task)
-		get_task_struct(task);
-	rcu_read_unlock();
+	task = find_get_task_by_vpid(pid);
 	if (!task) {
 		rc = -ESRCH;
 		goto free_proc_pages;
diff -puN security/yama/yama_lsm.c~pids-introduce-find_get_task_by_vpid-helper security/yama/yama_lsm.c
--- a/security/yama/yama_lsm.c~pids-introduce-find_get_task_by_vpid-helper
+++ a/security/yama/yama_lsm.c
@@ -250,15 +250,10 @@ int yama_task_prctl(int option, unsigned
 		} else {
 			struct task_struct *tracer;
 
-			rcu_read_lock();
-			tracer = find_task_by_vpid(arg2);
-			if (tracer)
-				get_task_struct(tracer);
-			else
+			tracer = find_get_task_by_vpid(arg2);
+			if (!tracer) {
 				rc = -EINVAL;
-			rcu_read_unlock();
