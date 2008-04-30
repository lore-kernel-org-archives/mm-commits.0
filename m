From: akpm@linux-foundation.org
Subject: - signals-fold-sig_ignored-into-handle_stop_signal-comment.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:07:50 -0700
Message-ID: <200804300607.m3U67oYp030867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253AbYD3GJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals-fold-sig_ignored-into-handle_stop_signal-comment
has been removed from the -mm tree.  Its filename was
     signals-fold-sig_ignored-into-handle_stop_signal-comment.patch

This patch was dropped because it was folded into signals-fold-sig_ignored-into-handle_stop_signal.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals-fold-sig_ignored-into-handle_stop_signal-comment
From: Oleg Nesterov <oleg@tv-sign.ru>

comments update for signals-fold-sig_ignored-into-handle_stop_signal.patch

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~signals-fold-sig_ignored-into-handle_stop_signal-comment kernel/signal.c
--- a/kernel/signal.c~signals-fold-sig_ignored-into-handle_stop_signal-comment
+++ a/kernel/signal.c
@@ -558,11 +558,14 @@ static int check_kill_permission(int sig
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
 
 /*
- * Handle magic process-wide effects of stop/continue signals.
- * Unlike the signal actions, these happen immediately at signal-generation
+ * Handle magic process-wide effects of stop/continue signals. Unlike
+ * the signal actions, these happen immediately at signal-generation
  * time regardless of blocking, ignoring, or handling.  This does the
  * actual continuing for SIGCONT, but not the actual stopping for stop
- * signals.  The process stop is done as a signal action for SIG_DFL.
+ * signals. The process stop is done as a signal action for SIG_DFL.
+ *
+ * Returns true if the signal should be actually delivered, otherwise
+ * it should be dropped.
  */
 static int prepare_signal(int sig, struct task_struct *p)
 {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
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

