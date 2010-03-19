From: akpm@linux-foundation.org
Subject: + ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:14:25 -0700
Message-ID: <201003192214.o2JMEP7s015311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0CSWOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, fenghua.yu@intel.com, roland@redhat.com, sgruszka@redhat.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     ia64: ptrace_attach_sync_user_rbs: avoid "task->signal != NULL" checks
has been added to the -mm tree.  Its filename is
     ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch

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
Subject: ia64: ptrace_attach_sync_user_rbs: avoid "task->signal != NULL" checks
From: Oleg Nesterov <oleg@redhat.com>

Preparation to make task->signal immutable, no functional changes.

It doesn't matter which pointer we check under tasklist to ensure the task
was not released, ->signal or ->sighand.  But we are going to make
->signal refcountable, change the code to use ->sighand.

Note: this code doesn't need this check and tasklist_lock at all, it
should be converted to use lock_task_sighand().  And, the code under
SIGNAL_STOP_STOPPED check looks wrong.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/ptrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/ptrace.c~ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks arch/ia64/kernel/ptrace.c
--- a/arch/ia64/kernel/ptrace.c~ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks
+++ a/arch/ia64/kernel/ptrace.c
@@ -639,7 +639,7 @@ ptrace_attach_sync_user_rbs (struct task
 	 */
 
 	read_lock(&tasklist_lock);
-	if (child->signal) {
+	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_STOPPED &&
 		    !test_and_set_tsk_thread_flag(child, TIF_RESTORE_RSE)) {
@@ -663,7 +663,7 @@ ptrace_attach_sync_user_rbs (struct task
 	 * job control stop, so that SIGCONT can be used to wake it up.
 	 */
 	read_lock(&tasklist_lock);
-	if (child->signal) {
+	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_TRACED &&
 		    (child->signal->flags & SIGNAL_STOP_STOPPED)) {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
exit-exit_notify-can-trust-signal-notify_count-0.patch
exit-change-zap_other_threads-to-count-sub-threads.patch
exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch
exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch

