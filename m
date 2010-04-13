From: akpm@linux-foundation.org
Subject: [withdrawn] proc-make-task_sig-lockless.patch removed from -mm tree
Date: Tue, 13 Apr 2010 13:12:32 -0700
Message-ID: <201004132012.o3DKCWKV025461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab0DMUMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 16:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     proc: make task_sig() lockless
has been removed from the -mm tree.  Its filename was
     proc-make-task_sig-lockless.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: make task_sig() lockless
From: Oleg Nesterov <oleg@redhat.com>

Now that task->signal can't go away and collect_sigign_sigcatch() is
rcu-safe, task_sig() doesn't need ->siglock.

Remove lock_task_sighand() and unnecessary sigemptyset's, move
collect_sigign_sigcatch() under rcu_read_lock().

Of course, this means we read pending/blocked/etc nonatomically and we can
report this info in some intermediate state.  Say, a signal can be
reported as both pending and ignored, or we can report ->sigpending != 0
while pending/shpending are empty, etc.  Hopefully this is OK for proc, we
never promised this info should be atomic.

Probably we can change do_task_stat() to avoid ->siglock too, except we
can't get tty_nr lockless.

Also, remove the "is this correct?" comment.  I think it is safe to
dereference __task_cred(p)->user under rcu lock.  In any case, ->siglock
can't help to protect cred->user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN fs/proc/array.c~proc-make-task_sig-lockless fs/proc/array.c
--- a/fs/proc/array.c~proc-make-task_sig-lockless
+++ a/fs/proc/array.c
@@ -256,30 +256,24 @@ static void collect_sigign_sigcatch(stru
 
 static inline void task_sig(struct seq_file *m, struct task_struct *p)
 {
-	unsigned long flags;
 	sigset_t pending, shpending, blocked, ignored, caught;
 	int num_threads = 0;
 	unsigned long qsize = 0;
 	unsigned long qlim = 0;
 
-	sigemptyset(&pending);
-	sigemptyset(&shpending);
-	sigemptyset(&blocked);
 	sigemptyset(&ignored);
 	sigemptyset(&caught);
 
-	if (lock_task_sighand(p, &flags)) {
-		pending = p->pending.signal;
-		shpending = p->signal->shared_pending.signal;
-		blocked = p->blocked;
-		collect_sigign_sigcatch(p, &ignored, &caught);
-		num_threads = get_nr_threads(p);
-		rcu_read_lock();  /* FIXME: is this correct? */
-		qsize = atomic_read(&__task_cred(p)->user->sigpending);
-		rcu_read_unlock();
-		qlim = task_rlimit(p, RLIMIT_SIGPENDING);
-		unlock_task_sighand(p, &flags);
-	}
+	blocked = p->blocked;
+	pending = p->pending.signal;
+	shpending = p->signal->shared_pending.signal;
+	qlim = task_rlimit(p, RLIMIT_SIGPENDING);
+	num_threads = get_nr_threads(p);
+
+	rcu_read_lock();
+	collect_sigign_sigcatch(p, &ignored, &caught);
+	qsize = atomic_read(&__task_cred(p)->user->sigpending);
+	rcu_read_unlock();
 
 	seq_printf(m, "Threads:\t%d\n", num_threads);
 	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);
_

Patches currently in -mm which might be from oleg@redhat.com are

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

