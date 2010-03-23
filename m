From: akpm@linux-foundation.org
Subject: + proc-get_nr_threads-doesnt-need-siglock-any-longer.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:39:30 -0400
Message-ID: <201003230640.o2N6eMZ0018693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab0CWGlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, roland@redhat.com


The patch titled
     proc: get_nr_threads() doesn't need ->siglock any longer
has been added to the -mm tree.  Its filename is
     proc-get_nr_threads-doesnt-need-siglock-any-longer.patch

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
Subject: proc: get_nr_threads() doesn't need ->siglock any longer
From: Oleg Nesterov <oleg@redhat.com>

Now that task->signal can't go away get_nr_threads() doesn't need
->siglock to read signal->count.

Also, make it inline, move into sched.h, and convert 2 other proc users of
signal->count to use this (now trivial) helper.

Henceforth get_nr_threads() is the only valid user of signal->count, we
are ready to turn it into "int nr_threads" or, perhaps, kill it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c       |    4 ++--
 fs/proc/base.c        |   12 ------------
 include/linux/sched.h |    5 +++++
 3 files changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/proc/array.c~proc-get_nr_threads-doesnt-need-siglock-any-longer fs/proc/array.c
--- a/fs/proc/array.c~proc-get_nr_threads-doesnt-need-siglock-any-longer
+++ a/fs/proc/array.c
@@ -269,7 +269,7 @@ static inline void task_sig(struct seq_f
 		shpending = p->signal->shared_pending.signal;
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
-		num_threads = atomic_read(&p->signal->count);
+		num_threads = get_nr_threads(p);
 		rcu_read_lock();  /* FIXME: is this correct? */
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
 		rcu_read_unlock();
@@ -412,7 +412,7 @@ static int do_task_stat(struct seq_file 
 			tty_nr = new_encode_dev(tty_devnum(sig->tty));
 		}
 
-		num_threads = atomic_read(&sig->count);
+		num_threads = get_nr_threads(task);
 		collect_sigign_sigcatch(task, &sigign, &sigcatch);
 
 		cmin_flt = sig->cmin_flt;
diff -puN fs/proc/base.c~proc-get_nr_threads-doesnt-need-siglock-any-longer fs/proc/base.c
--- a/fs/proc/base.c~proc-get_nr_threads-doesnt-need-siglock-any-longer
+++ a/fs/proc/base.c
@@ -166,18 +166,6 @@ static int get_fs_path(struct task_struc
 	return result;
 }
 
-static int get_nr_threads(struct task_struct *tsk)
-{
-	unsigned long flags;
-	int count = 0;
-
-	if (lock_task_sighand(tsk, &flags)) {
-		count = atomic_read(&tsk->signal->count);
-		unlock_task_sighand(tsk, &flags);
-	}
-	return count;
-}
-
 static int proc_cwd_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);
diff -puN include/linux/sched.h~proc-get_nr_threads-doesnt-need-siglock-any-longer include/linux/sched.h
--- a/include/linux/sched.h~proc-get_nr_threads-doesnt-need-siglock-any-longer
+++ a/include/linux/sched.h
@@ -2152,6 +2152,11 @@ extern bool current_is_single_threaded(v
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
+static inline int get_nr_threads(struct task_struct *tsk)
+{
+	return atomic_read(&tsk->signal->count);
+}
+
 /* de_thread depends on thread_group_leader not being a pid based check */
 #define thread_group_leader(p)	(p == p->group_leader)
 
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

