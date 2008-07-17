From: akpm@linux-foundation.org
Subject: + tracehook-death.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:31:03 -0700
Message-ID: <200807170831.m6H8V3wF007003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbYGQIkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: death
has been added to the -mm tree.  Its filename is
     tracehook-death.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1786,7 +1786,7 @@ extern int kill_pid_info_as_uid(int, str
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
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
ptrace-do_wait-reorganization.patch
ptrace-ptrace-children-revamp.patch
ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch
ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

