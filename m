From: akpm@linux-foundation.org
Subject: + exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:12:24 -0700
Message-ID: <201003192212.o2JMCPeX015274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0CSWMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, vfalico@redhat.com


The patch titled
     exit: avoid sig->count in __exit_signal() to detect the group-dead case
has been added to the -mm tree.  Its filename is
     exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch

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
Subject: exit: avoid sig->count in __exit_signal() to detect the group-dead case
From: Oleg Nesterov <oleg@redhat.com>

Change __exit_signal() to check thread_group_leader() instead of
atomic_dec_and_test(&sig->count).  This must be equivalent, the group
leader must be released only after all other threads have exited and
passed __exit_signal().

Henceforth sig->count is not actually used, except in fs/proc for
get_nr_threads/etc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case kernel/exit.c
--- a/kernel/exit.c~exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case
+++ a/kernel/exit.c
@@ -89,11 +89,12 @@ static void __exit_signal(struct task_st
 					rcu_read_lock_held() ||
 					lockdep_tasklist_lock_is_held());
 	spin_lock(&sighand->siglock);
+	atomic_dec(&sig->count);
 
 	posix_cpu_timers_exit(tsk);
-	if (atomic_dec_and_test(&sig->count))
+	if (thread_group_leader(tsk)) {
 		posix_cpu_timers_exit_group(tsk);
-	else {
+	} else {
 		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
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

