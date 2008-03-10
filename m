From: akpm@linux-foundation.org
Subject: + signals-use-__group_complete_signal-for-the-specific-signals-too.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:33:59 -0700
Message-ID: <200803101934.m2AJY0qX001736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbYCJTfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org


The patch titled
     signals: use __group_complete_signal() for the specific signals too
has been added to the -mm tree.  Its filename is
     signals-use-__group_complete_signal-for-the-specific-signals-too.patch

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
Subject: signals: use __group_complete_signal() for the specific signals too
From: Oleg Nesterov <oleg@tv-sign.ru>

Based on Pavel Emelyanov's suggestion.

Rename __group_complete_signal() to complete_signal() and use it to process
the specific signals too.  To do this we simply add the "int group" argument.

This allows us to greatly simply the signal-sending code and adds a useful
behaviour change.  We can avoid the unneeded wakeups for the private signals
because wants_signal() is more clever than sigismember(blocked), but more
importantly we now take into account the fatal specific signals too.

The latter allows us to kill some subtle checks in handle_stop_signal() and
makes the specific/group signal's behaviour more consistent.  For example,
currently sigtimedwait(FATAL_SIGNAL) behaves differently depending on was the
signal sent by kill() or tkill() if the signal was not blocked.

And.  This allows us to tweak/fix the behaviour when the specific signal is
sent to the dying/dead ->group_leader.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-use-__group_complete_signal-for-the-specific-signals-too kernel/signal.c
--- a/kernel/signal.c~signals-use-__group_complete_signal-for-the-specific-signals-too
+++ a/kernel/signal.c
@@ -673,8 +673,7 @@ static inline int wants_signal(int sig, 
 	return task_curr(p) || !signal_pending(p);
 }
 
-static void
-__group_complete_signal(int sig, struct task_struct *p)
+static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -687,7 +686,7 @@ __group_complete_signal(int sig, struct 
 	 */
 	if (wants_signal(sig, p))
 		t = p;
-	else if (thread_group_empty(p))
+	else if (!group || thread_group_empty(p))
 		/*
 		 * There is just one thread and it does not need to be woken.
 		 * It will dequeue unblocked signals before it runs again.
@@ -871,8 +870,7 @@ specific_send_sig_info(int sig, struct s
 	if (ret <= 0)
 		return ret;
 
-	if (!sigismember(&t->blocked, sig))
-		signal_wake_up(t, sig == SIGKILL);
+	complete_signal(sig, t, 0);
 	return 0;
 }
 
@@ -930,7 +928,7 @@ __group_send_sig_info(int sig, struct si
 	if (ret <= 0)
 		return ret;
 
-	__group_complete_signal(sig, p);
+	complete_signal(sig, p, 1);
 	return 0;
 }
 
@@ -1309,8 +1307,7 @@ int send_sigqueue(int sig, struct sigque
 
 	ret = do_send_sigqueue(sig, q, p, 0);
 
-	if (!sigismember(&p->blocked, sig))
-		signal_wake_up(p, sig == SIGKILL);
+	complete_signal(sig, p, 0);
 
 	unlock_task_sighand(p, &flags);
 out_err:
@@ -1330,7 +1327,7 @@ send_group_sigqueue(int sig, struct sigq
 
 	ret = do_send_sigqueue(sig, q, p, 1);
 
-	__group_complete_signal(sig, p);
+	complete_signal(sig, p, 1);
 
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 
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

