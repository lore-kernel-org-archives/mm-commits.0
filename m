From: akpm@linux-foundation.org
Subject: + signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:33:57 -0700
Message-ID: <200803101933.m2AJXvgg001733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYCJTfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: change send_signal/do_send_sigqueue to take "boolean group" parameter
has been added to the -mm tree.  Its filename is
     signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch

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
Subject: signals: change send_signal/do_send_sigqueue to take "boolean group" parameter
From: Oleg Nesterov <oleg@tv-sign.ru>

send_signal() is used either with ->pending or with ->signal->shared_pending. 
Change it to take "int group" instead, this argument will be re-used later.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter kernel/signal.c
--- a/kernel/signal.c~signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter
+++ a/kernel/signal.c
@@ -754,18 +754,21 @@ static inline int legacy_queue(struct si
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			struct sigpending *signals)
+			int group)
 {
+	struct sigpending *pending;
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
 	handle_stop_signal(sig, t);
+
+	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
+	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -793,7 +796,7 @@ static int send_signal(int sig, struct s
 					     (is_si_special(info) ||
 					      info->si_code >= 0)));
 	if (q) {
-		list_add_tail(&q->list, &signals->list);
+		list_add_tail(&q->list, &pending->list);
 		switch ((unsigned long) info) {
 		case (unsigned long) SEND_SIG_NOINFO:
 			q->info.si_signo = sig;
@@ -823,7 +826,7 @@ static int send_signal(int sig, struct s
 	}
 
 out_set:
-	sigaddset(&signals->signal, sig);
+	sigaddset(&pending->signal, sig);
 	return 1;
 }
 
@@ -864,7 +867,7 @@ specific_send_sig_info(int sig, struct s
 {
 	int ret;
 
-	ret = send_signal(sig, info, t, &t->pending);
+	ret = send_signal(sig, info, t, 0);
 	if (ret <= 0)
 		return ret;
 
@@ -923,7 +926,7 @@ __group_send_sig_info(int sig, struct si
 	 * We always use the shared queue for process-wide signals,
 	 * to avoid several races.
 	 */
-	ret = send_signal(sig, info, p, &p->signal->shared_pending);
+	ret = send_signal(sig, info, p, 1);
 	if (ret <= 0)
 		return ret;
 
@@ -1258,8 +1261,10 @@ void sigqueue_free(struct sigqueue *q)
 }
 
 static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
-				struct sigpending *pending)
+				int group)
 {
+	struct sigpending *pending;
+
 	handle_stop_signal(sig, t);
 
 	if (unlikely(!list_empty(&q->list))) {
@@ -1277,8 +1282,10 @@ static int do_send_sigqueue(int sig, str
 		return 1;
 
 	signalfd_notify(t, sig);
+	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
+
 	return 0;
 }
 
@@ -1300,7 +1307,7 @@ int send_sigqueue(int sig, struct sigque
 	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
 
-	ret = do_send_sigqueue(sig, q, p, &p->pending);
+	ret = do_send_sigqueue(sig, q, p, 0);
 
 	if (!sigismember(&p->blocked, sig))
 		signal_wake_up(p, sig == SIGKILL);
@@ -1321,7 +1328,7 @@ send_group_sigqueue(int sig, struct sigq
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
-	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
+	ret = do_send_sigqueue(sig, q, p, 1);
 
 	__group_complete_signal(sig, p);
 
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

