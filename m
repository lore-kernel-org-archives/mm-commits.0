From: akpm@linux-foundation.org
Subject: + tracehook-job-control.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:31:01 -0700
Message-ID: <200807170831.m6H8V1xA006998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbYGQIic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: job control
has been added to the -mm tree.  Its filename is
     tracehook-job-control.patch

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
Subject: tracehook: job control
From: Roland McGrath <roland@redhat.com>

This defines the tracehook_notify_jctl() hook to formalize the ptrace
effects on the job control notifications.  There is no change, only
cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   20 ++++++++++++++++++++
 kernel/signal.c           |   10 +++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-job-control include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-job-control
+++ a/include/linux/tracehook.h
@@ -451,4 +451,24 @@ static inline int tracehook_get_signal(s
 	return 0;
 }
 
+/**
+ * tracehook_notify_jctl - report about job control stop/continue
+ * @notify:		nonzero if this is the last thread in the group to stop
+ * @why:		%CLD_STOPPED or %CLD_CONTINUED
+ *
+ * This is called when we might call do_notify_parent_cldstop().
+ * It's called when about to stop for job control; we are already in
+ * %TASK_STOPPED state, about to call schedule().  It's also called when
+ * a delayed %CLD_STOPPED or %CLD_CONTINUED report is ready to be made.
+ *
+ * Return nonzero to generate a %SIGCHLD with @why, which is
+ * normal if @notify is nonzero.
+ *
+ * Called with no locks held.
+ */
+static inline int tracehook_notify_jctl(int notify, int why)
+{
+	return notify || (current->ptrace & PT_PTRACED);
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/signal.c~tracehook-job-control kernel/signal.c
--- a/kernel/signal.c~tracehook-job-control
+++ a/kernel/signal.c
@@ -596,9 +596,6 @@ static int check_kill_permission(int sig
 	return security_task_kill(t, info, sig, 0);
 }
 
-/* forward decl */
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
-
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -1605,7 +1602,7 @@ finish_stop(int stop_count)
 	 * a group stop in progress and we are the last to stop,
 	 * report to the parent.  When ptraced, every thread reports itself.
 	 */
-	if (stop_count == 0 || (current->ptrace & PT_PTRACED)) {
+	if (tracehook_notify_jctl(stop_count == 0, CLD_STOPPED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
@@ -1741,6 +1738,9 @@ relock:
 		signal->flags &= ~SIGNAL_CLD_MASK;
 		spin_unlock_irq(&sighand->siglock);
 
+		if (unlikely(!tracehook_notify_jctl(1, why)))
+			goto relock;
+
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current->group_leader, why);
 		read_unlock(&tasklist_lock);
@@ -1906,7 +1906,7 @@ void exit_signals(struct task_struct *ts
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (unlikely(group_stop)) {
+	if (unlikely(group_stop) && tracehook_notify_jctl(1, CLD_STOPPED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(tsk, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
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

