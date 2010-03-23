From: akpm@linux-foundation.org
Subject: + proc-make-task_sig-lockless.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:39:35 -0400
Message-ID: <201003230640.o2N6eR1K018699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab0CWGlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, roland@redhat.com


The patch titled
     proc: make task_sig() lockless
has been added to the -mm tree.  Its filename is
     proc-make-task_sig-lockless.patch

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
Subject: proc: make task_sig() lockless
From: Oleg Nesterov <oleg@redhat.com>

Now that task->signal can't go away and collect_sigign_sigcatch() is
rcu-safe, task_sig() doesn't need ->siglock.

Remove lock_task_sighand() and unnecessary sigemptyset's, move
collect_sigign_sigcatch() under rcu_read_lock().

Of course, this means we read pending/blocked/etc nonatomically, but I
hope this is OK for fs/proc.

Probably we can change do_task_stat() to avod ->siglock too, except we
can't get tty_nr lockless.

Also, remove the "is this correct?" comment.  I think it is safe to
dereference __task_cred(p)->user under rcu lock.  In any case, ->siglock
can't help to protect cred->user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN fs/proc/array.c~proc-make-task_sig-lockless fs/proc/array.c
--- a/fs/proc/array.c~proc-make-task_sig-lockless
+++ a/fs/proc/array.c
@@ -257,30 +257,24 @@ static void collect_sigign_sigcatch(stru
 
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
proc-cleanup-remove-unused-assignments.patch

