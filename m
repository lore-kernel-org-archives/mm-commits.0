From: akpm@linux-foundation.org
Subject: + signals-unify-send_sigqueue-send_group_sigqueue-completely.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:34:03 -0700
Message-ID: <200803101934.m2AJY3re001748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYCJTfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org


The patch titled
     signals: unify send_sigqueue/send_group_sigqueue completely
has been added to the -mm tree.  Its filename is
     signals-unify-send_sigqueue-send_group_sigqueue-completely.patch

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
Subject: signals: unify send_sigqueue/send_group_sigqueue completely
From: Oleg Nesterov <oleg@tv-sign.ru>

Suggested by Pavel Emelyanov.

send_sigqueue/send_group_sigqueue are only differ in how they lock ->siglock. 
Unify them.  send_group_sigqueue() uses spin_lock() because it knows the task
can't exit, but in that case lock_task_sighand() can't fail and doesn't hurt.

Note that the "sig" argument is ignored, it is always equal to ->si_signo.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   58 ++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

diff -puN kernel/signal.c~signals-unify-send_sigqueue-send_group_sigqueue-completely kernel/signal.c
--- a/kernel/signal.c~signals-unify-send_sigqueue-send_group_sigqueue-completely
+++ a/kernel/signal.c
@@ -1240,14 +1240,27 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
-static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
+static int do_send_sigqueue(struct sigqueue *q, struct task_struct *t,
 				int group)
 {
+	int sig = q->info.si_signo;
 	struct sigpending *pending;
+	unsigned long flags;
+	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+
+	ret = -1;
+	if (!likely(lock_task_sighand(t, &flags)))
+		goto ret;
+
 	handle_stop_signal(sig, t);
 
+	ret = 1;
+	if (sig_ignored(t, sig))
+		goto out;
+
+	ret = 0;
 	if (unlikely(!list_empty(&q->list))) {
 		/*
 		 * If an SI_TIMER entry is already queue just increment
@@ -1256,58 +1269,29 @@ static int do_send_sigqueue(int sig, str
 
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
-		return 0;
+		goto out;
 	}
 
-	if (sig_ignored(t, sig))
-		return 1;
-
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-
-	return 0;
+out:
+	unlock_task_sighand(t, &flags);
+ret:
+	return ret;
 }
 
 int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret = -1;
-
-	/*
-	 * The rcu based delayed sighand destroy makes it possible to
-	 * run this without tasklist lock held. The task struct itself
-	 * cannot go away as create_timer did get_task_struct().
-	 *
-	 * We return -1, when the task is marked exiting, so
-	 * posix_timer_event can redirect it to the group leader
-	 */
-	if (!likely(lock_task_sighand(p, &flags)))
-		goto out_err;
-
-	ret = do_send_sigqueue(sig, q, p, 0);
-
-	unlock_task_sighand(p, &flags);
-out_err:
-	return ret;
+	return do_send_sigqueue(q, p, 0);
 }
 
 int
 send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret;
-
-	/* Since it_lock is held, p->sighand cannot be NULL. */
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-
-	ret = do_send_sigqueue(sig, q, p, 1);
-
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-
-	return ret;
+	return do_send_sigqueue(q, p, 1);
 }
 
 /*
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

