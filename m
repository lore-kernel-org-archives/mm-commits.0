From: akpm@linux-foundation.org
Subject: + keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch added to -mm tree
Date: Wed, 24 Mar 2010 14:33:31 -0700
Message-ID: <201003242133.o2OLXVkZ028299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899Ab0CXVeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 17:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, peterz@infradead.org, roland@redhat.com


The patch titled
     keyctl_session_to_parent(): use thread_group_empty() to check singlethreadness
has been added to the -mm tree.  Its filename is
     keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch

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
Subject: keyctl_session_to_parent(): use thread_group_empty() to check singlethreadness
From: Oleg Nesterov <oleg@redhat.com>

No functional changes.

keyctl_session_to_parent() is the only user of signal->count which needs
the correct value.  Change it to use thread_group_empty() instead, this
must be strictly equivalent under tasklist, and imho looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/keys/keyctl.c~keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness security/keys/keyctl.c
--- a/security/keys/keyctl.c~keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness
+++ a/security/keys/keyctl.c
@@ -1269,7 +1269,7 @@ long keyctl_session_to_parent(void)
 		goto not_permitted;
 
 	/* the parent must be single threaded */
-	if (atomic_read(&parent->signal->count) != 1)
+	if (!thread_group_empty(parent))
 		goto not_permitted;
 
 	/* the parent and the child must have different session keyrings or
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
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
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-cleanup-remove-unused-assignments.patch

