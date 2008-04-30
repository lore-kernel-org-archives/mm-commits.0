From: akpm@linux-foundation.org
Subject: - consolidate-checking-for-ignored-legacy-signals-simplify.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:05:10 -0700
Message-ID: <200804300605.m3U65AH0030814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756983AbYD3GGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     consolidate-checking-for-ignored-legacy-signals-simplify
has been removed from the -mm tree.  Its filename was
     consolidate-checking-for-ignored-legacy-signals-simplify.patch

This patch was dropped because it was folded into consolidate-checking-for-ignored-legacy-signals.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: consolidate-checking-for-ignored-legacy-signals-simplify
From: Oleg Nesterov <oleg@tv-sign.ru>

Every user of send_signal() must check ret twice. Change the meaning of the
returned value, so that ret <= 0 means we can just return, and ret == 1 means
the signal was queued. Saves a couple of if's and imho makes the code more
logical.

Also, remove now unneeded "ret = 0" initializions.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~consolidate-checking-for-ignored-legacy-signals-simplify kernel/signal.c
--- a/kernel/signal.c~consolidate-checking-for-ignored-legacy-signals-simplify
+++ a/kernel/signal.c
@@ -673,7 +673,7 @@ static int send_signal(int sig, struct s
 	 * detailed information about the cause of the signal.
 	 */
 	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
-		return 1;
+		return 0;
 
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
@@ -731,7 +731,7 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return 0;
+	return 1;
 }
 
 int print_fatal_signals;
@@ -769,16 +769,16 @@ __setup("print-fatal-signals=", setup_pr
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
 	ret = send_signal(sig, info, t, &t->pending);
-	if (ret < 0)
+	if (ret <= 0)
 		return ret;
 
-	if (!ret && !sigismember(&t->blocked, sig))
+	if (!sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
 	return 0;
 }
@@ -925,7 +925,7 @@ __group_complete_signal(int sig, struct 
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret = 0;
+	int ret;
 
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
@@ -936,11 +936,10 @@ __group_send_sig_info(int sig, struct si
 	 * to avoid several races.
 	 */
 	ret = send_signal(sig, info, p, &p->signal->shared_pending);
-	if (unlikely(ret < 0))
+	if (ret <= 0)
 		return ret;
 
-	if (!ret)
-		__group_complete_signal(sig, p);
+	__group_complete_signal(sig, p);
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
workqueue-remove-redundant-function-invocation.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

