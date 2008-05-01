From: akpm@linux-foundation.org
Subject: - signals-move-the-definition-of-__group_complete_signal-up.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:41 -0700
Message-ID: <200805010926.m419QfF9030321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757502AbYEAJon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: move the definition of __group_complete_signal() up
has been removed from the -mm tree.  Its filename was
     signals-move-the-definition-of-__group_complete_signal-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
