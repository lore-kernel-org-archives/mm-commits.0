From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:18 -0700
Message-ID: <201005191848.o4JImI39029493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410Ab0ESSxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:53:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: oom_forkbomb_penalty: move thread_group_cputime() out of task_lock()
has been removed from the -mm tree.  Its filename was
     oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: oom_forkbomb_penalty: move thread_group_cputime() out of task_lock()
From: Oleg Nesterov <oleg@redhat.com>

It doesn't make sense to call thread_group_cputime() under task_lock(), we
can drop this lock right after we read get_mm_rss() and save the value in
the local variable.

Note: probably it makes more sense to use sum_exec_runtime instead
of utime + stime, it is much more precise. A task can eat a lot of
CPU time, but its Xtime can be zero.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock
+++ a/mm/oom_kill.c
@@ -125,13 +125,16 @@ static unsigned long oom_forkbomb_penalt
 		return 0;
 	list_for_each_entry(child, &tsk->children, sibling) {
 		struct task_cputime task_time;
-		unsigned long runtime;
+		unsigned long runtime, rss;
 
 		task_lock(child);
 		if (!child->mm || child->mm == tsk->mm) {
 			task_unlock(child);
 			continue;
 		}
+		rss = get_mm_rss(child->mm);
+		task_unlock(child);
+
 		thread_group_cputime(child, &task_time);
 		runtime = cputime_to_jiffies(task_time.utime) +
 			  cputime_to_jiffies(task_time.stime);
@@ -141,10 +144,9 @@ static unsigned long oom_forkbomb_penalt
 		 * get to execute at all in such cases anyway.
 		 */
 		if (runtime < HZ) {
-			child_rss += get_mm_rss(child->mm);
+			child_rss += rss;
 			forkcount++;
 		}
-		task_unlock(child);
 	}
 
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
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

