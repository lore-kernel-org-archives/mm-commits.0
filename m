From: akpm@linux-foundation.org
Subject: - tracehook-death.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:01 -0700
Message-ID: <200807262117.m6QLH17s019890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890AbYGZVRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: death
has been removed from the -mm tree.  Its filename was
     tracehook-death.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: death
From: Roland McGrath <roland@redhat.com>

This moves the ptrace logic in task death (exit_notify) into tracehook.h
inlines.  Some code is rearranged slightly to make things nicer.  There is
no change, only cleanup.

There is one hook called with the tasklist_lock write-locked, as ptrace
needs.  There is also a new hook called after exit_state changes and
without locks.  This is a better place for tracing work to be in the
future, since it doesn't delay the whole system with locking.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h     |    2 -
 include/linux/tracehook.h |   52 ++++++++++++++++++++++++++++++++++++
 kernel/exit.c             |   28 ++++++-------------
 kernel/signal.c           |   10 ++++--
 4 files changed, 70 insertions(+), 22 deletions(-)

diff -puN include/linux/sched.h~tracehook-death include/linux/sched.h
--- a/include/linux/sched.h~tracehook-death
+++ a/include/linux/sched.h
@@ -1796,7 +1796,7 @@ extern int kill_pid_info_as_uid(int, str
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
-extern void do_notify_parent(struct task_struct *, int);
+extern int do_notify_parent(struct task_struct *, int);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff -puN include/linux/tracehook.h~tracehook-death include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-death
+++ a/include/linux/tracehook.h
@@ -471,4 +471,56 @@ static inline int tracehook_notify_jctl(
 	return notify || (current->ptrace & PT_PTRACED);
 }
 
+/**
+ * tracehook_notify_death - task is dead, ready to notify parent
+ * @task:		@current task now exiting
+ * @death_cookie:	value to pass to tracehook_report_death()
+ * @group_dead:		nonzero if this was the last thread in the group to die
+ *
+ * Return the signal number to send our parent with do_notify_parent(), or
+ * zero to send no signal and leave a zombie, or -1 to self-reap right now.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static inline int tracehook_notify_death(struct task_struct *task,
+					 void **death_cookie, int group_dead)
+{
+	if (task->exit_signal == -1)
+		return task->ptrace ? SIGCHLD : -1;
+
+	/*
+	 * If something other than our normal parent is ptracing us, then
+	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
+	 * only has special meaning to our real parent.
+	 */
+	if (thread_group_empty(task) && !ptrace_reparented(task))
+		return task->exit_signal;
+
+	return task->ptrace ? SIGCHLD : 0;
+}
+
+/**
+ * tracehook_report_death - task is dead and ready to be reaped
+ * @task:		@current task now exiting
+ * @signal:		signal number sent to parent, or 0 or -1
+ * @death_cookie:	value passed back from tracehook_notify_death()
+ * @group_dead:		nonzero if this was the last thread in the group to die
+ *
+ * Thread has just become a zombie or is about to self-reap.  If positive,
+ * @signal is the signal number just sent to the parent (usually %SIGCHLD).
+ * If @signal is -1, this thread will self-reap.  If @signal is 0, this is
+ * a delayed_group_leader() zombie.  The @death_cookie was passed back by
+ * tracehook_notify_death().
+ *
+ * If normal reaping is not inhibited, @task->exit_state might be changing
+ * in parallel.
+ *
+ * Called without locks.
+ */
+static inline void tracehook_report_death(struct task_struct *task,
+					  int signal, void *death_cookie,
+					  int group_dead)
+{
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/exit.c~tracehook-death kernel/exit.c
--- a/kernel/exit.c~tracehook-death
+++ a/kernel/exit.c
@@ -885,7 +885,8 @@ static void forget_original_parent(struc
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	int state;
+	int signal;
+	void *cookie;
 
 	/*
 	 * This does two things:
@@ -922,22 +923,11 @@ static void exit_notify(struct task_stru
 	    !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 
-	/* If something other than our normal parent is ptracing us, then
-	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
-	 * only has special meaning to our real parent.
-	 */
-	if (!task_detached(tsk) && thread_group_empty(tsk)) {
-		int signal = ptrace_reparented(tsk) ?
-				SIGCHLD : tsk->exit_signal;
-		do_notify_parent(tsk, signal);
-	} else if (tsk->ptrace) {
-		do_notify_parent(tsk, SIGCHLD);
-	}
-
-	state = EXIT_ZOMBIE;
-	if (task_detached(tsk) && likely(!tsk->ptrace))
-		state = EXIT_DEAD;
-	tsk->exit_state = state;
+	signal = tracehook_notify_death(tsk, &cookie, group_dead);
+	if (signal > 0)
+		signal = do_notify_parent(tsk, signal);
+
+	tsk->exit_state = signal < 0 ? EXIT_DEAD : EXIT_ZOMBIE;
 
 	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
@@ -947,8 +937,10 @@ static void exit_notify(struct task_stru
 
 	write_unlock_irq(&tasklist_lock);
 
+	tracehook_report_death(tsk, signal, cookie, group_dead);
+
 	/* If the process is dead, release it - nobody will wait for it */
-	if (state == EXIT_DEAD)
+	if (signal < 0)
 		release_task(tsk);
 }
 
diff -puN kernel/signal.c~tracehook-death kernel/signal.c
--- a/kernel/signal.c~tracehook-death
+++ a/kernel/signal.c
@@ -1326,9 +1326,11 @@ static inline void __wake_up_parent(stru
 /*
  * Let a parent know about the death of a child.
  * For a stopped/continued status change, use do_notify_parent_cldstop instead.
+ *
+ * Returns -1 if our parent ignored us and so we've switched to
+ * self-reaping, or else @sig.
  */
-
-void do_notify_parent(struct task_struct *tsk, int sig)
+int do_notify_parent(struct task_struct *tsk, int sig)
 {
 	struct siginfo info;
 	unsigned long flags;
@@ -1399,12 +1401,14 @@ void do_notify_parent(struct task_struct
 		 */
 		tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
-			sig = 0;
+			sig = -1;
 	}
 	if (valid_signal(sig) && sig > 0)
 		__group_send_sig_info(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
+
+	return sig;
 }
 
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
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

