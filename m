From: akpm@linux-foundation.org
Subject: + signals-check_kill_permission-dont-check-creds-if-same_thread_group.patch added to -mm tree
Date: Thu, 20 May 2010 12:42:19 -0700
Message-ID: <201005201942.o4KJgJBQ000845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332Ab0ETTnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 15:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, eparis@parisplace.org, jakub@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov, tridge@samba.org


The patch titled
     signals: check_kill_permission(): don't check creds if same_thread_group()
has been added to the -mm tree.  Its filename is
     signals-check_kill_permission-dont-check-creds-if-same_thread_group.patch

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
Subject: signals: check_kill_permission(): don't check creds if same_thread_group()
From: Oleg Nesterov <oleg@redhat.com>

Andrew Tridgell reports that aio_read(SIGEV_SIGNAL) can fail if the
notification from the helper thread races with setresuid(), see
http://samba.org/~tridge/junkcode/aio_uid.c

This happens because check_kill_permission() doesn't permit sending a
signal to the task with the different cred->xids.  But there is not any
security reason to check ->cred's when the task sends a signal (private or
group-wide) to its sub-thread.  Whatever we do, any thread can bypass all
security checks and send SIGKILL to all threads, or it can block a signal
SIG and do kill(gettid(), SIG) to deliver this signal to another
sub-thread.  Not to mention that CLONE_THREAD implies CLONE_VM.

Change check_kill_permission() to avoid the credentials check when the
sender and the target are from the same thread group.

Also, move "cred = current_cred()" down to avoid calling get_current()
twice.

Note: David Howells pointed out we could relax this even more, the
CLONE_SIGHAND (without CLONE_THREAD) case probably does not need
these checks too.

Reported-by: Andrew Tridgell <tridge@samba.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-check_kill_permission-dont-check-creds-if-same_thread_group kernel/signal.c
--- a/kernel/signal.c~signals-check_kill_permission-dont-check-creds-if-same_thread_group
+++ a/kernel/signal.c
@@ -642,7 +642,7 @@ static inline bool si_fromuser(const str
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	const struct cred *cred = current_cred(), *tcred;
+	const struct cred *cred, *tcred;
 	struct pid *sid;
 	int error;
 
@@ -656,8 +656,10 @@ static int check_kill_permission(int sig
 	if (error)
 		return error;
 
+	cred = current_cred();
 	tcred = __task_cred(t);
-	if ((cred->euid ^ tcred->suid) &&
+	if (!same_thread_group(current, t) &&
+	    (cred->euid ^ tcred->suid) &&
 	    (cred->euid ^ tcred->uid) &&
 	    (cred->uid  ^ tcred->suid) &&
 	    (cred->uid  ^ tcred->uid) &&
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
signals-check_kill_permission-dont-check-creds-if-same_thread_group.patch
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

