From: akpm@linux-foundation.org
Subject: + exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:12:22 -0700
Message-ID: <201003192212.o2JMCN2p015271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0CSWMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, vfalico@redhat.com


The patch titled
     exit: avoid sig->count in de_thread/__exit_signal synchronization
has been added to the -mm tree.  Its filename is
     exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch

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
Subject: exit: avoid sig->count in de_thread/__exit_signal synchronization
From: Oleg Nesterov <oleg@redhat.com>

de_thread() and __exit_signal() use signal_struct->count/notify_count for
synchronization.  We can simplify the code and use ->notify_count only. 
Instead of comparing these two counters, we can change de_thread() to set
->notify_count = nr_of_sub_threads, then change __exit_signal() to
dec-and-test this counter and notify group_exit_task.

Note that __exit_signal() checks "notify_count > 0" just for symmetry with
exit_notify(), we could just check it is != 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |   11 +++++------
 kernel/exit.c |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization fs/exec.c
--- a/fs/exec.c~exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization
+++ a/fs/exec.c
@@ -763,7 +763,6 @@ static int de_thread(struct task_struct 
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	int count;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
@@ -780,13 +779,13 @@ static int de_thread(struct task_struct 
 		spin_unlock_irq(lock);
 		return -EAGAIN;
 	}
+
 	sig->group_exit_task = tsk;
-	zap_other_threads(tsk);
+	sig->notify_count = zap_other_threads(tsk);
+	if (!thread_group_leader(tsk))
+		sig->notify_count--;
 
-	/* Account for the thread group leader hanging around: */
-	count = thread_group_leader(tsk) ? 1 : 2;
-	sig->notify_count = count;
-	while (atomic_read(&sig->count) > count) {
+	while (sig->notify_count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(lock);
 		schedule();
diff -puN kernel/exit.c~exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization kernel/exit.c
--- a/kernel/exit.c~exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization
+++ a/kernel/exit.c
@@ -98,7 +98,7 @@ static void __exit_signal(struct task_st
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
-		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
+		if (sig->notify_count > 0 && !--sig->notify_count)
 			wake_up_process(sig->group_exit_task);
 
 		if (tsk == sig->curr_target)
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

