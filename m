From: akpm@linux-foundation.org
Subject: [merged] signals-tracehook_notify_jctl-change.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:29 -0700
Message-ID: <200909241935.n8OJZTt4000548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbZIXTf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: tracehook_notify_jctl change
has been removed from the -mm tree.  Its filename was
     signals-tracehook_notify_jctl-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: tracehook_notify_jctl change
From: Roland McGrath <roland@redhat.com>

This changes tracehook_notify_jctl() so it's called with the siglock held,
and changes its argument and return value definition.  These clean-ups
make it a better fit for what new tracing hooks need to check.

Tracing needs the siglock here, held from the time TASK_STOPPED was set,
to avoid potential SIGCONT races if it wants to allow any blocking in its
tracing hooks.

This also folds the finish_stop() function into its caller
do_signal_stop().  The function is short, called only once and only
unconditionally.  It aids readability to fold it in.

[oleg@redhat.com: do not call tracehook_notify_jctl() in TASK_STOPPED state]
[oleg@redhat.com: introduce tracehook_finish_jctl() helper]
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   34 +++++++++---
 kernel/signal.c           |   97 +++++++++++++++++-------------------
 2 files changed, 72 insertions(+), 59 deletions(-)

diff -puN include/linux/tracehook.h~signals-tracehook_notify_jctl-change include/linux/tracehook.h
--- a/include/linux/tracehook.h~signals-tracehook_notify_jctl-change
+++ a/include/linux/tracehook.h
@@ -1,7 +1,7 @@
 /*
  * Tracing hooks
  *
- * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2008-2009 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -463,22 +463,38 @@ static inline int tracehook_get_signal(s
 
 /**
  * tracehook_notify_jctl - report about job control stop/continue
- * @notify:		nonzero if this is the last thread in the group to stop
+ * @notify:		zero, %CLD_STOPPED or %CLD_CONTINUED
  * @why:		%CLD_STOPPED or %CLD_CONTINUED
  *
  * This is called when we might call do_notify_parent_cldstop().
- * It's called when about to stop for job control; we are already in
- * %TASK_STOPPED state, about to call schedule().  It's also called when
- * a delayed %CLD_STOPPED or %CLD_CONTINUED report is ready to be made.
  *
- * Return nonzero to generate a %SIGCHLD with @why, which is
- * normal if @notify is nonzero.
+ * @notify is zero if we would not ordinarily send a %SIGCHLD,
+ * or is the %CLD_STOPPED or %CLD_CONTINUED .si_code for %SIGCHLD.
  *
- * Called with no locks held.
+ * @why is %CLD_STOPPED when about to stop for job control;
+ * we are already in %TASK_STOPPED state, about to call schedule().
+ * It might also be that we have just exited (check %PF_EXITING),
+ * but need to report that a group-wide stop is complete.
+ *
+ * @why is %CLD_CONTINUED when waking up after job control stop and
+ * ready to make a delayed @notify report.
+ *
+ * Return the %CLD_* value for %SIGCHLD, or zero to generate no signal.
+ *
+ * Called with the siglock held.
  */
 static inline int tracehook_notify_jctl(int notify, int why)
 {
-	return notify || (current->ptrace & PT_PTRACED);
+	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
+}
+
+/**
+ * tracehook_finish_jctl - report about return from job control stop
+ *
+ * This is called by do_signal_stop() after wakeup.
+ */
+static inline void tracehook_finish_jctl(void)
+{
 }
 
 #define DEATH_REAP			-1
diff -puN kernel/signal.c~signals-tracehook_notify_jctl-change kernel/signal.c
--- a/kernel/signal.c~signals-tracehook_notify_jctl-change
+++ a/kernel/signal.c
@@ -705,7 +705,7 @@ static int prepare_signal(int sig, struc
 
 		if (why) {
 			/*
-			 * The first thread which returns from finish_stop()
+			 * The first thread which returns from do_signal_stop()
 			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
 			 * notify its parent. See get_signal_to_deliver().
 			 */
@@ -1664,29 +1664,6 @@ void ptrace_notify(int exit_code)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-static void
-finish_stop(int stop_count)
-{
-	/*
-	 * If there are no other threads in the group, or if there is
-	 * a group stop in progress and we are the last to stop,
-	 * report to the parent.  When ptraced, every thread reports itself.
-	 */
-	if (tracehook_notify_jctl(stop_count == 0, CLD_STOPPED)) {
-		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current, CLD_STOPPED);
-		read_unlock(&tasklist_lock);
-	}
-
-	do {
-		schedule();
-	} while (try_to_freeze());
-	/*
-	 * Now we don't run again until continued.
-	 */
-	current->exit_code = 0;
-}
-
 /*
  * This performs the stopping for SIGSTOP and other stop signals.
  * We have to stop all threads in the thread group.
@@ -1696,15 +1673,9 @@ finish_stop(int stop_count)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int stop_count;
+	int notify;
 
-	if (sig->group_stop_count > 0) {
-		/*
-		 * There is a group stop in progress.  We don't need to
-		 * start another one.
-		 */
-		stop_count = --sig->group_stop_count;
-	} else {
+	if (!sig->group_stop_count) {
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1716,7 +1687,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
-		stop_count = 0;
+		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
 			 * Setting state to TASK_STOPPED for a group
@@ -1725,19 +1696,44 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
-				stop_count++;
+				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			}
-		sig->group_stop_count = stop_count;
 	}
+	/*
+	 * If there are no other threads in the group, or if there is
+	 * a group stop in progress and we are the last to stop, report
+	 * to the parent.  When ptraced, every thread reports itself.
+	 */
+	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
+	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
+	/*
+	 * tracehook_notify_jctl() can drop and reacquire siglock, so
+	 * we keep ->group_stop_count != 0 before the call. If SIGCONT
+	 * or SIGKILL comes in between ->group_stop_count == 0.
+	 */
+	if (sig->group_stop_count) {
+		if (!--sig->group_stop_count)
+			sig->flags = SIGNAL_STOP_STOPPED;
+		current->exit_code = sig->group_exit_code;
+		__set_current_state(TASK_STOPPED);
+	}
+	spin_unlock_irq(&current->sighand->siglock);
 
-	if (stop_count == 0)
-		sig->flags = SIGNAL_STOP_STOPPED;
-	current->exit_code = sig->group_exit_code;
-	__set_current_state(TASK_STOPPED);
+	if (notify) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current, notify);
+		read_unlock(&tasklist_lock);
+	}
+
+	/* Now we don't run again until woken by SIGCONT or SIGKILL */
+	do {
+		schedule();
+	} while (try_to_freeze());
+
+	tracehook_finish_jctl();
+	current->exit_code = 0;
 
-	spin_unlock_irq(&current->sighand->siglock);
-	finish_stop(stop_count);
 	return 1;
 }
 
@@ -1806,14 +1802,15 @@ relock:
 		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
 				? CLD_CONTINUED : CLD_STOPPED;
 		signal->flags &= ~SIGNAL_CLD_MASK;
-		spin_unlock_irq(&sighand->siglock);
 
-		if (unlikely(!tracehook_notify_jctl(1, why)))
-			goto relock;
+		why = tracehook_notify_jctl(why, CLD_CONTINUED);
+		spin_unlock_irq(&sighand->siglock);
 
-		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current->group_leader, why);
-		read_unlock(&tasklist_lock);
+		if (why) {
+			read_lock(&tasklist_lock);
+			do_notify_parent_cldstop(current->group_leader, why);
+			read_unlock(&tasklist_lock);
+		}
 		goto relock;
 	}
 
@@ -1978,14 +1975,14 @@ void exit_signals(struct task_struct *ts
 	if (unlikely(tsk->signal->group_stop_count) &&
 			!--tsk->signal->group_stop_count) {
 		tsk->signal->flags = SIGNAL_STOP_STOPPED;
-		group_stop = 1;
+		group_stop = tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
 	}
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (unlikely(group_stop) && tracehook_notify_jctl(1, CLD_STOPPED)) {
+	if (unlikely(group_stop)) {
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(tsk, CLD_STOPPED);
+		do_notify_parent_cldstop(tsk, group_stop);
 		read_unlock(&tasklist_lock);
 	}
 }
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
kconfig-cross_compile-option.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

