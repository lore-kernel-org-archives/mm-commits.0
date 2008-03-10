From: akpm@linux-foundation.org
Subject: + signals-move-the-definition-of-__group_complete_signal-up.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:33:54 -0700
Message-ID: <200803101933.m2AJXsoP001730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbYCJTfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: move the definition of __group_complete_signal() up
has been added to the -mm tree.  Its filename is
     signals-move-the-definition-of-__group_complete_signal-up.patch

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
Subject: signals: move the definition of __group_complete_signal() up
From: Oleg Nesterov <oleg@tv-sign.ru>

Move the unchanged definition of __group_complete_signal() so that send_signal
can see it.  To simplify the reading of the next patches.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |  192 +++++++++++++++++++++++-----------------------
 1 file changed, 96 insertions(+), 96 deletions(-)

diff -puN kernel/signal.c~signals-move-the-definition-of-__group_complete_signal-up kernel/signal.c
--- a/kernel/signal.c~signals-move-the-definition-of-__group_complete_signal-up
+++ a/kernel/signal.c
@@ -652,6 +652,102 @@ static void handle_stop_signal(int sig, 
 	}
 }
 
+/*
+ * Test if P wants to take SIG.  After we've checked all threads with this,
+ * it's equivalent to finding no threads not blocking SIG.  Any threads not
+ * blocking SIG were ruled out because they are not running and already
+ * have pending signals.  Such threads will dequeue from the shared queue
+ * as soon as they're available, so putting the signal on the shared queue
+ * will be equivalent to sending it to one such thread.
+ */
+static inline int wants_signal(int sig, struct task_struct *p)
+{
+	if (sigismember(&p->blocked, sig))
+		return 0;
+	if (p->flags & PF_EXITING)
+		return 0;
+	if (sig == SIGKILL)
+		return 1;
+	if (task_is_stopped_or_traced(p))
+		return 0;
+	return task_curr(p) || !signal_pending(p);
+}
+
+static void
+__group_complete_signal(int sig, struct task_struct *p)
+{
+	struct signal_struct *signal = p->signal;
+	struct task_struct *t;
+
+	/*
+	 * Now find a thread we can wake up to take the signal off the queue.
+	 *
+	 * If the main thread wants the signal, it gets first crack.
+	 * Probably the least surprising to the average bear.
+	 */
+	if (wants_signal(sig, p))
+		t = p;
+	else if (thread_group_empty(p))
+		/*
+		 * There is just one thread and it does not need to be woken.
+		 * It will dequeue unblocked signals before it runs again.
+		 */
+		return;
+	else {
+		/*
+		 * Otherwise try to find a suitable thread.
+		 */
+		t = signal->curr_target;
+		while (!wants_signal(sig, t)) {
+			t = next_thread(t);
+			if (t == signal->curr_target)
+				/*
+				 * No thread needs to be woken.
+				 * Any eligible threads will see
+				 * the signal in the queue soon.
+				 */
+				return;
+		}
+		signal->curr_target = t;
+	}
+
+	/*
+	 * Found a killable thread.  If the signal will be fatal,
+	 * then start taking the whole group down immediately.
+	 */
+	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
+	    !sigismember(&t->real_blocked, sig) &&
+	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
+		/*
+		 * This signal will be fatal to the whole group.
+		 */
+		if (!sig_kernel_coredump(sig)) {
+			/*
+			 * Start a group exit and wake everybody up.
+			 * This way we don't have other threads
+			 * running and doing things after a slower
+			 * thread has the fatal signal pending.
+			 */
+			signal->flags = SIGNAL_GROUP_EXIT;
+			signal->group_exit_code = sig;
+			signal->group_stop_count = 0;
+			t = p;
+			do {
+				sigaddset(&t->pending.signal, SIGKILL);
+				signal_wake_up(t, 1);
+			} while_each_thread(p, t);
+			return;
+		}
+	}
+
+	/*
+	 * The signal is already in the shared-pending queue.
+	 * Tell the chosen thread to wake up and dequeue it.
+	 */
+	signal_wake_up(t, sig == SIGKILL);
+	return;
+}
+
 static inline int legacy_queue(struct sigpending *signals, int sig)
 {
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
@@ -817,102 +913,6 @@ force_sig_specific(int sig, struct task_
 	force_sig_info(sig, SEND_SIG_FORCED, t);
 }
 
-/*
- * Test if P wants to take SIG.  After we've checked all threads with this,
- * it's equivalent to finding no threads not blocking SIG.  Any threads not
- * blocking SIG were ruled out because they are not running and already
- * have pending signals.  Such threads will dequeue from the shared queue
- * as soon as they're available, so putting the signal on the shared queue
- * will be equivalent to sending it to one such thread.
- */
-static inline int wants_signal(int sig, struct task_struct *p)
-{
-	if (sigismember(&p->blocked, sig))
-		return 0;
-	if (p->flags & PF_EXITING)
-		return 0;
-	if (sig == SIGKILL)
-		return 1;
-	if (task_is_stopped_or_traced(p))
-		return 0;
-	return task_curr(p) || !signal_pending(p);
-}
-
-static void
-__group_complete_signal(int sig, struct task_struct *p)
-{
-	struct signal_struct *signal = p->signal;
-	struct task_struct *t;
-
-	/*
-	 * Now find a thread we can wake up to take the signal off the queue.
-	 *
-	 * If the main thread wants the signal, it gets first crack.
-	 * Probably the least surprising to the average bear.
-	 */
-	if (wants_signal(sig, p))
-		t = p;
-	else if (thread_group_empty(p))
-		/*
-		 * There is just one thread and it does not need to be woken.
-		 * It will dequeue unblocked signals before it runs again.
-		 */
-		return;
-	else {
-		/*
-		 * Otherwise try to find a suitable thread.
-		 */
-		t = signal->curr_target;
-		while (!wants_signal(sig, t)) {
-			t = next_thread(t);
-			if (t == signal->curr_target)
-				/*
-				 * No thread needs to be woken.
-				 * Any eligible threads will see
-				 * the signal in the queue soon.
-				 */
-				return;
-		}
-		signal->curr_target = t;
-	}
-
-	/*
-	 * Found a killable thread.  If the signal will be fatal,
-	 * then start taking the whole group down immediately.
-	 */
-	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
-	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
-		/*
-		 * This signal will be fatal to the whole group.
-		 */
-		if (!sig_kernel_coredump(sig)) {
-			/*
-			 * Start a group exit and wake everybody up.
-			 * This way we don't have other threads
-			 * running and doing things after a slower
-			 * thread has the fatal signal pending.
-			 */
-			signal->flags = SIGNAL_GROUP_EXIT;
-			signal->group_exit_code = sig;
-			signal->group_stop_count = 0;
-			t = p;
-			do {
-				sigaddset(&t->pending.signal, SIGKILL);
-				signal_wake_up(t, 1);
-			} while_each_thread(p, t);
-			return;
-		}
-	}
-
-	/*
-	 * The signal is already in the shared-pending queue.
-	 * Tell the chosen thread to wake up and dequeue it.
-	 */
-	signal_wake_up(t, sig == SIGKILL);
-	return;
-}
-
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
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

