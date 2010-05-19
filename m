From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:15 -0700
Message-ID: <201005191848.o4JImFZ6029485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab0ESSxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: introduce find_lock_task_mm() to fix !mm false positives
has been removed from the -mm tree.  Its filename was
     oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: introduce find_lock_task_mm() to fix !mm false positives
From: Oleg Nesterov <oleg@redhat.com>

Almost all ->mm == NUL checks in oom_kill.c are wrong.

The current code assumes that the task without ->mm has already
released its memory and ignores the process. However this is not
necessarily true when this process is multithreaded, other live
sub-threads can use this ->mm.

- Remove the "if (!p->mm)" check in select_bad_process(), it is
  just wrong.

- Add the new helper, find_lock_task_mm(), which finds the live
  thread which uses the memory and takes task_lock() to pin ->mm

- change oom_badness() to use this helper instead of just checking
  ->mm != NULL.

- As David pointed out, select_bad_process() must never choose the
  task without ->mm, but no matter what oom_badness() returns the
  task can be chosen if nothing else has been found yet.

  Change oom_badness() to return int, change it to return -1 if
  find_lock_task_mm() fails, and change select_bad_process() to
  check points >= 0.

Note! This patch is not enough, we need more changes.

	- oom_badness() was fixed, but oom_kill_task() still ignores
	  the task without ->mm

	- oom_forkbomb_penalty() should use find_lock_task_mm() too,
	  and it also needs other changes to actually find the first
	  first-descendant children

This will be addressed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 +-
 mm/oom_kill.c       |   39 +++++++++++++++++++++------------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff -puN include/linux/oom.h~oom-introduce-find_lock_task_mm-to-fix-mm-false-positives include/linux/oom.h
--- a/include/linux/oom.h~oom-introduce-find_lock_task_mm-to-fix-mm-false-positives
+++ a/include/linux/oom.h
@@ -40,7 +40,7 @@ enum oom_constraint {
 	CONSTRAINT_MEMORY_POLICY,
 };
 
-extern unsigned int oom_badness(struct task_struct *p,
+extern int oom_badness(struct task_struct *p,
 			unsigned long totalpages, unsigned long uptime);
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
diff -puN mm/oom_kill.c~oom-introduce-find_lock_task_mm-to-fix-mm-false-positives mm/oom_kill.c
--- a/mm/oom_kill.c~oom-introduce-find_lock_task_mm-to-fix-mm-false-positives
+++ a/mm/oom_kill.c
@@ -84,6 +84,19 @@ static bool has_intersects_mems_allowed(
 	return false;
 }
 
+static struct task_struct *find_lock_task_mm(struct task_struct *p)
+{
+	struct task_struct *t = p;
+	do {
+		task_lock(t);
+		if (likely(t->mm))
+			return t;
+		task_unlock(t);
+	} while_each_thread(p, t);
+
+	return NULL;
+}
+
 /*
  * Tasks that fork a very large number of children with seperate address spaces
  * may be the result of a bug, user error, malicious applications, or even those
@@ -154,10 +167,9 @@ static unsigned long oom_forkbomb_penalt
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom conditions.
  */
-unsigned int oom_badness(struct task_struct *p, unsigned long totalpages,
+int oom_badness(struct task_struct *p, unsigned long totalpages,
 							unsigned long uptime)
 {
-	struct mm_struct *mm;
 	int points;
 
 	/*
@@ -174,19 +186,15 @@ unsigned int oom_badness(struct task_str
 	if (p->flags & PF_OOM_ORIGIN)
 		return 1000;
 
-	task_lock(p);
-	mm = p->mm;
-	if (!mm) {
-		task_unlock(p);
-		return 0;
-	}
-
+	p = find_lock_task_mm(p);
+	if (!p)
+		return -1;
 	/*
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss and swap space use.
 	 */
-	points = (get_mm_rss(mm) + get_mm_counter(mm, MM_SWAPENTS)) * 1000 /
-			totalpages;
+	points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS)) *
+			1000 / totalpages;
 	task_unlock(p);
 	points += oom_forkbomb_penalty(p);
 
@@ -303,7 +311,7 @@ static struct task_struct *select_bad_pr
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	for_each_process(p) {
-		unsigned int points;
+		int points;
 
 		/* skip the init task and kthreads */
 		if (is_global_init(p) || (p->flags & PF_KTHREAD))
@@ -345,16 +353,11 @@ static struct task_struct *select_bad_pr
 			*ppoints = 1000;
 		}
 
-		/*
-		 * skip the tasks which have already released their mm.
-		 */
-		if (!p->mm)
-			continue;
 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 			continue;
 
 		points = oom_badness(p, totalpages, uptime.tv_sec);
-		if (points > *ppoints || !chosen) {
+		if (points >= 0 && (points > *ppoints || !chosen)) {
 			chosen = p;
 			*ppoints = points;
 		}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
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
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
proc-cleanup-remove-unused-assignments.patch
init_task-should-initialize-thread_group-list.patch
pids-init_struct_pidtasks-should-never-see-the-swapper-process.patch
pids-fix-fork_idle-to-setup-pids-correctly.patch
init_sighand-use-sig_dfl-instead-of-null.patch

