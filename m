From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:31 -0700
Message-ID: <201005191848.o4JImVZQ029514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab0ESStF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: select_bad_process(): never choose tasks with badness == 0
has been removed from the -mm tree.  Its filename was
     oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch

This patch was dropped because an updated version will be merged

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
@@ -168,7 +168,7 @@ static unsigned long oom_forkbomb_penalt
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom conditions.
  */
-int oom_badness(struct task_struct *p, unsigned long totalpages)
+unsigned int oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	int points;
 
@@ -188,7 +188,7 @@ int oom_badness(struct task_struct *p, u
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return -1;
+		return 0;
 	/*
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss and swap space use.
@@ -309,7 +309,7 @@ static struct task_struct *select_bad_pr
 	*ppoints = 0;
 
 	for_each_process(p) {
-		int points;
+		unsigned int points;
 
 		/* skip the init task and kthreads */
 		if (is_global_init(p) || (p->flags & PF_KTHREAD))
@@ -351,11 +351,8 @@ static struct task_struct *select_bad_pr
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
fix-stop_machine-reimplement-using-cpu_stop.patch
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
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
proc-cleanup-remove-unused-assignments.patch
init_task-should-initialize-thread_group-list.patch
pids-init_struct_pidtasks-should-never-see-the-swapper-process.patch
pids-fix-fork_idle-to-setup-pids-correctly.patch
init_sighand-use-sig_dfl-instead-of-null.patch

