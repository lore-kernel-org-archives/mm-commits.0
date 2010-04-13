From: akpm@linux-foundation.org
Subject: + oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch added to -mm tree
Date: Mon, 12 Apr 2010 22:59:44 -0400
Message-ID: <201004130601.o3D61N1K016404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab0DMGBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 02:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, rientjes@google.com


The patch titled
     oom: select_bad_process(): never choose tasks with badness == 0
has been added to the -mm tree.  Its filename is
     oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch

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
Subject: oom: select_bad_process(): never choose tasks with badness == 0
From: Oleg Nesterov <oleg@redhat.com>

As David pointed out, we should fix select_bad_process() which currently
always selects the first process which was not filtered out before
oom_badness(), no matter what oom_badness() returns.

Change the code to ignore the process if oom_badness() returns 0, this
matters Documentation/filesystems/proc.txt and this merely looks better.

This also allows us to do more cleanups:

	- no need to check OOM_SCORE_ADJ_MIN in select_bad_process(),
	  oom_badness() returns 0 in this case.

	- oom_badness() can simply return 0 instead of -1 if the task
	  has no ->mm.

	  Now we can make it "unsigned" again, the signness and the
	  special "points >= 0" in select_bad_process() was added to
	  preserve the current behaviour.

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    3 ++-
 mm/oom_kill.c       |   11 ++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN include/linux/oom.h~oom-select_bad_process-never-choose-tasks-with-badness-==-0 include/linux/oom.h
--- a/include/linux/oom.h~oom-select_bad_process-never-choose-tasks-with-badness-==-0
+++ a/include/linux/oom.h
@@ -40,7 +40,8 @@ enum oom_constraint {
 	CONSTRAINT_MEMORY_POLICY,
 };
 
-extern int oom_badness(struct task_struct *p, unsigned long totalpages);
+extern unsigned int oom_badness(struct task_struct *p,
+					unsigned long totalpages);
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
diff -puN mm/oom_kill.c~oom-select_bad_process-never-choose-tasks-with-badness-==-0 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-select_bad_process-never-choose-tasks-with-badness-==-0
+++ a/mm/oom_kill.c
@@ -154,7 +154,7 @@ static unsigned long oom_forkbomb_penalt
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom conditions.
  */
-int oom_badness(struct task_struct *p, unsigned long totalpages)
+unsigned int oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	int points;
 
@@ -174,7 +174,7 @@ int oom_badness(struct task_struct *p, u
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return -1;
+		return 0;
 	/*
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss and swap space use.
@@ -295,7 +295,7 @@ static struct task_struct *select_bad_pr
 	*ppoints = 0;
 
 	for_each_process(p) {
-		int points;
+		unsigned int points;
 
 		/* skip the init task and kthreads */
 		if (is_global_init(p) || (p->flags & PF_KTHREAD))
@@ -337,11 +337,8 @@ static struct task_struct *select_bad_pr
 			*ppoints = 1000;
 		}
 
-		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-			continue;
-
 		points = oom_badness(p, totalpages);
-		if (points >= 0 && (points > *ppoints || !chosen)) {
+		if (points > *ppoints) {
 			chosen = p;
 			*ppoints = points;
 		}
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
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch
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

