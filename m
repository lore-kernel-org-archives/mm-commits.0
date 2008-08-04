From: akpm@linux-foundation.org
Subject: - tracehook-fix-exit_signal=0-case.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:00 -0700
Message-ID: <200808042006.m74K60kR027636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762730AbYHDUHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, drepper@redhat.com, oleg@tv-sign.ru, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tracehook: fix exit_signal=0 case
has been removed from the -mm tree.  Its filename was
     tracehook-fix-exit_signal=0-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: fix exit_signal=0 case
From: Roland McGrath <roland@redhat.com>

My commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664 introduced a regression
(sorry about that) for the odd case of exit_signal=0 (e.g. clone_flags=0).
This is not a normal use, but it's used by a case in the glibc test suite.

Dying with exit_signal=0 sends no signal, but it's supposed to wake up a
parent's blocked wait*() calls (unlike the delayed_group_leader case). 
This fixes tracehook_notify_death() and its caller to distinguish a
"signal 0" wakeup from the delayed_group_leader case (with no wakeup).

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   21 +++++++++++++--------
 kernel/exit.c             |    6 +++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-fix-exit_signal=0-case include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-fix-exit_signal=0-case
+++ a/include/linux/tracehook.h
@@ -493,16 +493,21 @@ static inline int tracehook_notify_jctl(
  * @death_cookie:	value to pass to tracehook_report_death()
  * @group_dead:		nonzero if this was the last thread in the group to die
  *
- * Return the signal number to send our parent with do_notify_parent(), or
- * zero to send no signal and leave a zombie, or -1 to self-reap right now.
+ * A return value >= 0 means call do_notify_parent() with that signal
+ * number.  Negative return value can be %DEATH_REAP to self-reap right
+ * now, or %DEATH_DELAYED_GROUP_LEADER to a zombie without notifying our
+ * parent.  Note that a return value of 0 means a do_notify_parent() call
+ * that sends no signal, but still wakes up a parent blocked in wait*().
  *
  * Called with write_lock_irq(&tasklist_lock) held.
  */
+#define DEATH_REAP			-1
+#define DEATH_DELAYED_GROUP_LEADER	-2
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
 	if (task->exit_signal == -1)
-		return task->ptrace ? SIGCHLD : -1;
+		return task->ptrace ? SIGCHLD : DEATH_REAP;
 
 	/*
 	 * If something other than our normal parent is ptracing us, then
@@ -512,21 +517,21 @@ static inline int tracehook_notify_death
 	if (thread_group_empty(task) && !ptrace_reparented(task))
 		return task->exit_signal;
 
-	return task->ptrace ? SIGCHLD : 0;
+	return task->ptrace ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
 }
 
 /**
  * tracehook_report_death - task is dead and ready to be reaped
  * @task:		@current task now exiting
- * @signal:		signal number sent to parent, or 0 or -1
+ * @signal:		return value from tracheook_notify_death()
  * @death_cookie:	value passed back from tracehook_notify_death()
  * @group_dead:		nonzero if this was the last thread in the group to die
  *
  * Thread has just become a zombie or is about to self-reap.  If positive,
  * @signal is the signal number just sent to the parent (usually %SIGCHLD).
- * If @signal is -1, this thread will self-reap.  If @signal is 0, this is
- * a delayed_group_leader() zombie.  The @death_cookie was passed back by
- * tracehook_notify_death().
+ * If @signal is %DEATH_REAP, this thread will self-reap.  If @signal is
+ * %DEATH_DELAYED_GROUP_LEADER, this is a delayed_group_leader() zombie.
+ * The @death_cookie was passed back by tracehook_notify_death().
  *
  * If normal reaping is not inhibited, @task->exit_state might be changing
  * in parallel.
diff -puN kernel/exit.c~tracehook-fix-exit_signal=0-case kernel/exit.c
--- a/kernel/exit.c~tracehook-fix-exit_signal=0-case
+++ a/kernel/exit.c
@@ -911,10 +911,10 @@ static void exit_notify(struct task_stru
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);
-	if (signal > 0)
+	if (signal >= 0)
 		signal = do_notify_parent(tsk, signal);
 
-	tsk->exit_state = signal < 0 ? EXIT_DEAD : EXIT_ZOMBIE;
+	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
 
 	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
@@ -927,7 +927,7 @@ static void exit_notify(struct task_stru
 	tracehook_report_death(tsk, signal, cookie, group_dead);
 
 	/* If the process is dead, release it - nobody will wait for it */
-	if (signal < 0)
+	if (signal == DEATH_REAP)
 		release_task(tsk);
 }
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
semaphore-__down_common-use-signal_pending_state.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

