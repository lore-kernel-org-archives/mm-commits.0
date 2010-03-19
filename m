From: akpm@linux-foundation.org
Subject: + fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:15:53 -0700
Message-ID: <201003192215.o2JMFrCn015345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab0CSWQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, roland@redhat.com


The patch titled
     fork/exit: move tty_kref_put() outside of __cleanup_signal()
has been added to the -mm tree.  Its filename is
     fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch

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
Subject: fork/exit: move tty_kref_put() outside of __cleanup_signal()
From: Oleg Nesterov <oleg@redhat.com>

tty_kref_put() has two callsites in copy_process() paths,

	1. if copy_process() suceeds it is called before we copy
	   signal->tty from parent

	2. otherwise it is called from __cleanup_signal() under
	   bad_fork_cleanup_signal: label

In both cases tty_kref_put() is not right and unneeded because we don't
have the balancing tty_kref_get().  Fortunately, this is harmless because
this can only happen without CLONE_THREAD, and in this case signal->tty
must be NULL.

Remove tty_kref_put() from copy_process() and __cleanup_signal(), and
change another caller of __cleanup_signal(), __exit_signal(), to call
tty_kref_put() by hand.

I hope this change makes sense by itself, but it is also needed to make
->signal refcountable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roland McGrath <roland@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 +
 kernel/fork.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~fork-exit-move-tty_kref_put-outside-of-__cleanup_signal kernel/exit.c
--- a/kernel/exit.c~fork-exit-move-tty_kref_put-outside-of-__cleanup_signal
+++ a/kernel/exit.c
@@ -150,6 +150,7 @@ static void __exit_signal(struct task_st
 		 * see account_group_exec_runtime().
 		 */
 		task_rq_unlock_wait(tsk);
+		tty_kref_put(sig->tty);
 		__cleanup_signal(sig);
 	}
 }
diff -puN kernel/fork.c~fork-exit-move-tty_kref_put-outside-of-__cleanup_signal kernel/fork.c
--- a/kernel/fork.c~fork-exit-move-tty_kref_put-outside-of-__cleanup_signal
+++ a/kernel/fork.c
@@ -892,7 +892,6 @@ static int copy_signal(unsigned long clo
 void __cleanup_signal(struct signal_struct *sig)
 {
 	thread_group_cputime_free(sig);
-	tty_kref_put(sig->tty);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1260,7 +1259,6 @@ static struct task_struct *copy_process(
 				p->nsproxy->pid_ns->child_reaper = p;
 
 			p->signal->leader_pid = pid;
-			tty_kref_put(p->signal->tty);
 			p->signal->tty = tty_kref_get(current->signal->tty);
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
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

