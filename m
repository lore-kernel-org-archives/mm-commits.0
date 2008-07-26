From: akpm@linux-foundation.org
Subject: - tracehook-wait_task_inactive.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:09 -0700
Message-ID: <200807262117.m6QLH9SL019910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758013AbYGZVR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: wait_task_inactive
has been removed from the -mm tree.  Its filename was
     tracehook-wait_task_inactive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: wait_task_inactive
From: Roland McGrath <roland@redhat.com>

This extends wait_task_inactive() with a new argument so it can be used in
a "soft" mode where it will check for the task changing state unexpectedly
and back off.  There is no change to existing callers.  This lays the
groundwork to allow robust, noninvasive tracing that can try to sample a
blocked thread but back off safely if it wakes up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    4 ++--
 include/linux/sched.h      |    8 ++++++--
 kernel/kthread.c           |    2 +-
 kernel/ptrace.c            |    2 +-
 kernel/sched.c             |   29 +++++++++++++++++++++++++++--
 5 files changed, 37 insertions(+), 8 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~tracehook-wait_task_inactive arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~tracehook-wait_task_inactive
+++ a/arch/ia64/kernel/perfmon.c
@@ -2626,7 +2626,7 @@ pfm_task_incompatible(pfm_context_t *ctx
 	/*
 	 * make sure the task is off any CPU
 	 */
-	wait_task_inactive(task);
+	wait_task_inactive(task, 0);
 
 	/* more to come... */
 
@@ -4774,7 +4774,7 @@ recheck:
 
 		UNPROTECT_CTX(ctx, flags);
 
-		wait_task_inactive(task);
+		wait_task_inactive(task, 0);
 
 		PROTECT_CTX(ctx, flags);
 
diff -puN include/linux/sched.h~tracehook-wait_task_inactive include/linux/sched.h
--- a/include/linux/sched.h~tracehook-wait_task_inactive
+++ a/include/linux/sched.h
@@ -1882,9 +1882,13 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
-extern void wait_task_inactive(struct task_struct * p);
+extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
-#define wait_task_inactive(p)	do { } while (0)
+static inline unsigned long wait_task_inactive(struct task_struct *p,
+					       long match_state)
+{
+	return 1;
+}
 #endif
 
 #define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
diff -puN kernel/kthread.c~tracehook-wait_task_inactive kernel/kthread.c
--- a/kernel/kthread.c~tracehook-wait_task_inactive
+++ a/kernel/kthread.c
@@ -176,7 +176,7 @@ void kthread_bind(struct task_struct *k,
 		return;
 	}
 	/* Must have done schedule() in kthread() before we set_task_cpu */
-	wait_task_inactive(k);
+	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;
diff -puN kernel/ptrace.c~tracehook-wait_task_inactive kernel/ptrace.c
--- a/kernel/ptrace.c~tracehook-wait_task_inactive
+++ a/kernel/ptrace.c
@@ -107,7 +107,7 @@ int ptrace_check_attach(struct task_stru
 	read_unlock(&tasklist_lock);
 
 	if (!ret && !kill)
-		wait_task_inactive(child);
+		ret = wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
 
 	/* All systems go.. */
 	return ret;
diff -puN kernel/sched.c~tracehook-wait_task_inactive kernel/sched.c
--- a/kernel/sched.c~tracehook-wait_task_inactive
+++ a/kernel/sched.c
@@ -1867,16 +1867,24 @@ migrate_task(struct task_struct *p, int 
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
+ * If @match_state is nonzero, it's the @p->state value just checked and
+ * not expected to change.  If it changes, i.e. @p might have woken up,
+ * then return zero.  When we succeed in waiting for @p to be off its CPU,
+ * we return a positive number (its total switch count).  If a second call
+ * a short while later returns the same number, the caller can be sure that
+ * @p has remained unscheduled the whole time.
+ *
  * The caller must ensure that the task *will* unschedule sometime soon,
  * else this function might spin for a *long* time. This function can't
  * be called with interrupts off, or it may introduce deadlock with
  * smp_call_function() if an IPI is sent by the same process we are
  * waiting to become inactive.
  */
-void wait_task_inactive(struct task_struct *p)
+unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
 	unsigned long flags;
 	int running, on_rq;
+	unsigned long ncsw;
 	struct rq *rq;
 
 	for (;;) {
@@ -1899,8 +1907,11 @@ void wait_task_inactive(struct task_stru
 		 * return false if the runqueue has changed and p
 		 * is actually now running somewhere else!
 		 */
-		while (task_running(rq, p))
+		while (task_running(rq, p)) {
+			if (match_state && unlikely(p->state != match_state))
+				return 0;
 			cpu_relax();
+		}
 
 		/*
 		 * Ok, time to look more closely! We need the rq
@@ -1910,9 +1921,21 @@ void wait_task_inactive(struct task_stru
 		rq = task_rq_lock(p, &flags);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
+		ncsw = 0;
+		if (!match_state || p->state == match_state) {
+			ncsw = p->nivcsw + p->nvcsw;
+			if (unlikely(!ncsw))
+				ncsw = 1;
+		}
 		task_rq_unlock(rq, &flags);
 
 		/*
+		 * If it changed from the expected state, bail out now.
+		 */
+		if (unlikely(!ncsw))
+			break;
+
+		/*
 		 * Was it really running after all now that we
 		 * checked with the proper locks actually held?
 		 *
@@ -1944,6 +1967,8 @@ void wait_task_inactive(struct task_stru
 		 */
 		break;
 	}
+
+	return ncsw;
 }
 
 /***
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

