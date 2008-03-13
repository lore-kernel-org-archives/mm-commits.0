From: akpm@linux-foundation.org
Subject: + signals-fold-sig_ignored-into-handle_stop_signal.patch added to -mm tree
Date: Thu, 13 Mar 2008 12:50:44 -0700
Message-ID: <200803131950.m2DJojts029969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbYCMTwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: fold sig_ignored() into handle_stop_signal()
has been added to the -mm tree.  Its filename is
     signals-fold-sig_ignored-into-handle_stop_signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: fold sig_ignored() into handle_stop_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

Rename handle_stop_signal() to prepare_signal(), make it return a boolean, and
move the callsites of sig_ignored() into it.

No functional changes for now.  But it would be nice to factor out the "should
we drop this signal" checks as much as possible, before we try to fix the bugs
with the sub-namespace init's signals (actually the global /sbin/init has some
problems with signals too).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN kernel/signal.c~signals-fold-sig_ignored-into-handle_stop_signal kernel/signal.c
--- a/kernel/signal.c~signals-fold-sig_ignored-into-handle_stop_signal
+++ a/kernel/signal.c
@@ -564,18 +564,16 @@ static void do_notify_parent_cldstop(str
  * actual continuing for SIGCONT, but not the actual stopping for stop
  * signals.  The process stop is done as a signal action for SIG_DFL.
  */
-static void handle_stop_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (signal->flags & SIGNAL_GROUP_EXIT)
+	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
 		/*
-		 * The process is in the middle of dying already.
+		 * The process is in the middle of dying, nothing to do.
 		 */
-		return;
-
-	if (sig_kernel_stop(sig)) {
+	} else if (sig_kernel_stop(sig)) {
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
@@ -644,6 +642,8 @@ static void handle_stop_signal(int sig, 
 			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	}
+
+	return !sig_ignored(p, sig);
 }
 
 /*
@@ -753,7 +753,8 @@ static int send_signal(int sig, struct s
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
-	handle_stop_signal(sig, t);
+	if (!prepare_signal(sig, t))
+		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -761,7 +762,7 @@ static int send_signal(int sig, struct s
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
+	if (legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -1247,10 +1248,8 @@ int send_sigqueue(struct sigqueue *q, st
 	if (!likely(lock_task_sighand(t, &flags)))
 		goto ret;
 
-	handle_stop_signal(sig, t);
-
-	ret = 1;
-	if (sig_ignored(t, sig))
+	ret = 1; /* the signal is ignored */
+	if (!prepare_signal(sig, t))
 		goto out;
 
 	ret = 0;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
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
signals-document-cld_continued-notification-mechanics.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

