From: akpm@linux-foundation.org
Subject: + posix-cpu-timers-avoid-task-signal-=-null-checks.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:14:22 -0700
Message-ID: <201003192214.o2JMEM44015308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0CSWOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, fenghua.yu@intel.com, roland@redhat.com, sgruszka@redhat.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     posix-cpu-timers: avoid "task->signal != NULL" checks
has been added to the -mm tree.  Its filename is
     posix-cpu-timers-avoid-task-signal-=-null-checks.patch

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
Subject: posix-cpu-timers: avoid "task->signal != NULL" checks
From: Oleg Nesterov <oleg@redhat.com>

Preparation to make task->signal immutable, no functional changes.

posix-cpu-timers.c checks task->signal != NULL to ensure this task is
alive and didn't pass __exit_signal().  This is correct but we are going
to change the lifetime rules for ->signal and never reset this pointer.

Change the code to check ->sighand instead, it doesn't matter which
pointer we check under tasklist, they both are cleared simultaneously.

As Roland pointed out, some of these changes are not strictly needed and
probably it makes sense to revert them later, when ->signal will be pinned
to task_struct.  But this patch tries to ensure the subsequent changes in
fork/exit can't make any visible impact on posix cpu timers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-avoid-task-signal-=-null-checks kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-avoid-task-signal-=-null-checks
+++ a/kernel/posix-cpu-timers.c
@@ -362,7 +362,7 @@ int posix_cpu_clock_get(const clockid_t 
 				}
 			} else {
 				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->signal) {
+				if (thread_group_leader(p) && p->sighand) {
 					error =
 					    cpu_clock_sample_group(which_clock,
 							           p, &rtn);
@@ -438,7 +438,7 @@ int posix_cpu_timer_del(struct k_itimer 
 
 	if (likely(p != NULL)) {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * We raced with the reaping of the task.
 			 * The deletion should have cleared us off the list.
@@ -690,10 +690,10 @@ int posix_cpu_timer_set(struct k_itimer 
 	read_lock(&tasklist_lock);
 	/*
 	 * We need the tasklist_lock to protect against reaping that
-	 * clears p->signal.  If p has just been reaped, we can no
+	 * clears p->sighand.  If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
-	if (unlikely(p->signal == NULL)) {
+	if (unlikely(p->sighand == NULL)) {
 		read_unlock(&tasklist_lock);
 		put_task_struct(p);
 		timer->it.cpu.task = NULL;
@@ -862,7 +862,7 @@ void posix_cpu_timer_get(struct k_itimer
 		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
@@ -1198,7 +1198,7 @@ void posix_cpu_timer_schedule(struct k_i
 		spin_lock(&p->sighand->siglock);
 	} else {
 		read_lock(&tasklist_lock);
-		if (unlikely(p->signal == NULL)) {
+		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
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

