From: akpm@linux-foundation.org
Subject: + signals-tracehook_notify_jctl-change.patch added to -mm tree
Date: Mon, 30 Mar 2009 15:18:56 -0700
Message-ID: <200903302218.n2UMIvEb004737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337AbZC3WVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 18:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@redhat.com


The patch titled
     signals: tracehook_notify_jctl change
has been added to the -mm tree.  Its filename is
     signals-tracehook_notify_jctl-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   25 ++++++++-----
 kernel/signal.c           |   69 ++++++++++++++++++------------------
 2 files changed, 51 insertions(+), 43 deletions(-)

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
@@ -464,22 +464,29 @@ static inline int tracehook_get_signal(s
 
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
 }
 
 #define DEATH_REAP			-1
diff -puN kernel/signal.c~signals-tracehook_notify_jctl-change kernel/signal.c
--- a/kernel/signal.c~signals-tracehook_notify_jctl-change
+++ a/kernel/signal.c
@@ -702,7 +702,7 @@ static int prepare_signal(int sig, struc
 
 		if (why) {
 			/*
-			 * The first thread which returns from finish_stop()
+			 * The first thread which returns from do_signal_stop()
 			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
 			 * notify its parent. See get_signal_to_deliver().
 			 */
@@ -1665,29 +1665,6 @@ void ptrace_notify(int exit_code)
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
@@ -1698,6 +1675,7 @@ static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
 	int stop_count;
+	int notify;
 
 	if (sig->group_stop_count > 0) {
 		/*
@@ -1737,8 +1715,30 @@ static int do_signal_stop(int signr)
 	current->exit_code = sig->group_exit_code;
 	__set_current_state(TASK_STOPPED);
 
+	/*
+	 * If there are no other threads in the group, or if there is
+	 * a group stop in progress and we are the last to stop,
+	 * report to the parent.  When ptraced, every thread reports itself.
+	 */
+	notify = tracehook_notify_jctl(stop_count == 0 ? CLD_STOPPED : 0,
+				       CLD_STOPPED);
+
 	spin_unlock_irq(&current->sighand->siglock);
-	finish_stop(stop_count);
+
+	if (notify) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current, notify);
+		read_unlock(&tasklist_lock);
+	}
+
+	do {
+		schedule();
+	} while (try_to_freeze());
+	/*
+	 * Now we don't run again until continued.
+	 */
+	current->exit_code = 0;
+
 	return 1;
 }
 
@@ -1807,14 +1807,15 @@ relock:
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
 
@@ -1979,14 +1980,14 @@ void exit_signals(struct task_struct *ts
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
linux-next.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
signals-add-from_ancestor_ns-parameter-to-send_signal.patch
signals-protect-cinit-from-unblocked-sig_dfl-signals.patch
signals-zap_pid_ns_process-should-use-force_sig.patch
signals-protect-cinit-from-blocked-fatal-signals.patch
signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

