From: akpm@linux-foundation.org
Subject: + oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch added to -mm tree
Date: Fri, 02 Apr 2010 15:18:16 -0700
Message-ID: <201004022218.o32MIGcB008584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402Ab0DBWSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 18:18:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, rientjes@google.com


The patch titled
     oom: select_bad_process: check PF_KTHREAD instead of !mm to skip kthreads
has been added to the -mm tree.  Its filename is
     oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch

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
Subject: oom: select_bad_process: check PF_KTHREAD instead of !mm to skip kthreads
From: Oleg Nesterov <oleg@redhat.com>

select_bad_process() thinks a kernel thread can't have ->mm != NULL, this
is not true due to use_mm().

Change the code to check PF_KTHREAD.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads mm/oom_kill.c
--- a/mm/oom_kill.c~oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads
+++ a/mm/oom_kill.c
@@ -291,8 +291,8 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned int points;
 
-		/* skip the init task */
-		if (is_global_init(p))
+		/* skip the init task and kthreads */
+		if (is_global_init(p) || (p->flags & PF_KTHREAD))
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
@@ -332,8 +332,7 @@ static struct task_struct *select_bad_pr
 		}
 
 		/*
-		 * skip kernel threads and tasks which have already released
-		 * their mm.
+		 * skip the tasks which have already released their mm.
 		 */
 		if (!p->mm)
 			continue;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
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
signals-clear-signal-tty-when-the-last-thread-exits-fix.patch
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
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
proc-cleanup-remove-unused-assignments.patch

