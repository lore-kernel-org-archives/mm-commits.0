From: akpm@linux-foundation.org
Subject: - tracehook-release_task.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:45 -0700
Message-ID: <200807262116.m6QLGj8q019858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757733AbYGZVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: release_task
has been removed from the -mm tree.  Its filename was
     tracehook-release_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: release_task
From: Roland McGrath <roland@redhat.com>

This moves the ptrace-related logic from release_task into tracehook.h and
ptrace.h inlines.  It provides clean hooks both before and after locking
tasklist_lock, for future tracing logic to do more cleanup without the
lock.

This also changes release_task() itself in the rare "zap_leader" case to
set the leader to EXIT_DEAD before iterating.  This maintains the
invariant that release_task() only ever handles a task in EXIT_DEAD.  This
is a common-sense invariant that is already always true except in this one
arcane case of zombie leader whose parent ignores SIGCHLD.

This change is harmless and only costs one store in this one rare case. 
It keeps the expected state more consisently sane, which is nicer when
debugging weirdness in release_task().  It also lets some future code in
the tracehook entry points rely on this invariant for bookkeeping.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h    |   13 +++++++++++++
 include/linux/tracehook.h |   28 ++++++++++++++++++++++++++++
 kernel/exit.c             |   21 +++++++++------------
 3 files changed, 50 insertions(+), 12 deletions(-)

diff -puN include/linux/ptrace.h~tracehook-release_task include/linux/ptrace.h
--- a/include/linux/ptrace.h~tracehook-release_task
+++ a/include/linux/ptrace.h
@@ -176,6 +176,19 @@ static inline void ptrace_init_task(stru
 	}
 }
 
+/**
+ * ptrace_release_task - final ptrace-related cleanup of a zombie being reaped
+ * @task:	task in %EXIT_DEAD state
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static inline void ptrace_release_task(struct task_struct *task)
+{
+	BUG_ON(!list_empty(&task->ptraced));
+	ptrace_unlink(task);
+	BUG_ON(!list_empty(&task->ptrace_entry));
+}
+
 #ifndef force_successful_syscall_return
 /*
  * System call handlers that, upon successful completion, need to return a
diff -puN include/linux/tracehook.h~tracehook-release_task include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-release_task
+++ a/include/linux/tracehook.h
@@ -228,4 +228,32 @@ static inline void tracehook_report_vfor
 	ptrace_event(PT_TRACE_VFORK_DONE, PTRACE_EVENT_VFORK_DONE, pid);
 }
 
+/**
+ * tracehook_prepare_release_task - task is being reaped, clean up tracing
+ * @task:		task in %EXIT_DEAD state
+ *
+ * This is called in release_task() just before @task gets finally reaped
+ * and freed.  This would be the ideal place to remove and clean up any
+ * tracing-related state for @task.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_prepare_release_task(struct task_struct *task)
+{
+}
+
+/**
+ * tracehook_finish_release_task - task is being reaped, clean up tracing
+ * @task:		task in %EXIT_DEAD state
+ *
+ * This is called in release_task() when @task is being in the middle of
+ * being reaped.  After this, there must be no tracing entanglements.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static inline void tracehook_finish_release_task(struct task_struct *task)
+{
+	ptrace_release_task(task);
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/exit.c~tracehook-release_task kernel/exit.c
--- a/kernel/exit.c~tracehook-release_task
+++ a/kernel/exit.c
@@ -163,27 +163,17 @@ static void delayed_put_task_struct(stru
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
-/*
- * Do final ptrace-related cleanup of a zombie being reaped.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-static void ptrace_release_task(struct task_struct *p)
-{
-	BUG_ON(!list_empty(&p->ptraced));
-	ptrace_unlink(p);
-	BUG_ON(!list_empty(&p->ptrace_entry));
-}
 
 void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
+	tracehook_prepare_release_task(p);
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
-	ptrace_release_task(p);
+	tracehook_finish_release_task(p);
 	__exit_signal(p);
 
 	/*
@@ -205,6 +195,13 @@ repeat:
 		 * that case.
 		 */
 		zap_leader = task_detached(leader);
+
+		/*
+		 * This maintains the invariant that release_task()
+		 * only runs on a task in EXIT_DEAD, just for sanity.
+		 */
+		if (zap_leader)
+			leader->exit_state = EXIT_DEAD;
 	}
 
 	write_unlock_irq(&tasklist_lock);
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

