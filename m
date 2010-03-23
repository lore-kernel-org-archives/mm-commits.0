From: akpm@linux-foundation.org
Subject: + kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:10:17 -0400
Message-ID: <201003230611.o2N6B8g5017522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab0CWGLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, balbir@linux.vnet.ibm.com, roland@redhat.com, sgruszka@redhat.com, vfalico@redhat.com


The patch titled
     kill the obsolete thread_group_cputime_free() helper
has been added to the -mm tree.  Its filename is
     kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch

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
Subject: kill the obsolete thread_group_cputime_free() helper
From: Oleg Nesterov <oleg@redhat.com>

Kill the empty thread_group_cputime_free() helper.  It was needed to free
the per-cpu data which we no longer have.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ----
 kernel/fork.c         |    1 -
 2 files changed, 5 deletions(-)

diff -puN include/linux/sched.h~kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers include/linux/sched.h
--- a/include/linux/sched.h~kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers
+++ a/include/linux/sched.h
@@ -2398,10 +2398,6 @@ static inline void thread_group_cputime_
 	spin_lock_init(&sig->cputimer.lock);
 }
 
-static inline void thread_group_cputime_free(struct signal_struct *sig)
-{
-}
-
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff -puN kernel/fork.c~kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers kernel/fork.c
--- a/kernel/fork.c~kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers
+++ a/kernel/fork.c
@@ -167,7 +167,6 @@ EXPORT_SYMBOL(free_task);
 
 static inline void free_signal_struct(struct signal_struct *sig)
 {
-	thread_group_cputime_free(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
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
fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch
signals-make-task_struct-signal-immutable-refcountable.patch
signals-clear-signal-tty-when-the-last-thread-exits.patch
signals-kill-the-awful-task_rq_unlock_wait-hack.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch

