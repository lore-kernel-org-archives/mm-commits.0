From: akpm@linux-foundation.org
Subject: + exit-exit_notify-can-trust-signal-notify_count-0.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:12:19 -0700
Message-ID: <201003192212.o2JMCJ5l015265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0CSWMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, vfalico@redhat.com


The patch titled
     exit: exit_notify() can trust signal->notify_count < 0
has been added to the -mm tree.  Its filename is
     exit-exit_notify-can-trust-signal-notify_count-0.patch

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
Subject: exit: exit_notify() can trust signal->notify_count < 0
From: Oleg Nesterov <oleg@redhat.com>

signal_struct->count in its current form must die.

- it has no reasons to be atomic_t

- it looks like a reference counter, but it is not

- otoh, we really need to make task->signal refcountable, just look at
  the extremely ugly task_rq_unlock_wait() called from __exit_signals().

- we should change the lifetime rules for task->signal, it should be
  pinned to task_struct.  We have a lot of code which can be simplified
  after that.

- it is not needed!  while the code is correct, any usage of this
  counter is artificial, except fs/proc uses it correctly to show the
  number of threads.

This series removes the usage of sig->count from exit pathes.



This patch:

Now that Veaceslav changed copy_signal() to use zalloc(), exit_notify()
can just check notify_count < 0 to ensure the execing sub-threads needs
the notification from us.  No need to do other checks, notify_count != 0
must always mean ->group_exit_task != NULL is waiting for us.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~exit-exit_notify-can-trust-signal-notify_count-0 kernel/exit.c
--- a/kernel/exit.c~exit-exit_notify-can-trust-signal-notify_count-0
+++ a/kernel/exit.c
@@ -857,12 +857,9 @@ static void exit_notify(struct task_stru
 
 	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
 
-	/* mt-exec, de_thread() is waiting for us */
-	if (thread_group_leader(tsk) &&
-	    tsk->signal->group_exit_task &&
-	    tsk->signal->notify_count < 0)
+	/* mt-exec, de_thread() is waiting for group leader */
+	if (unlikely(tsk->signal->notify_count < 0))
 		wake_up_process(tsk->signal->group_exit_task);
-
 	write_unlock_irq(&tasklist_lock);
 
 	tracehook_report_death(tsk, signal, cookie, group_dead);
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

