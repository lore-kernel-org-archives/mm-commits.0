From: akpm@linux-foundation.org
Subject: - handle_stop_signal-use-the-cached-p-signal-value.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:21 -0700
Message-ID: <200805010926.m419QLJ3030291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758257AbYEAJqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     handle_stop_signal: use the cached p->signal value
has been removed from the -mm tree.  Its filename was
     handle_stop_signal-use-the-cached-p-signal-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: handle_stop_signal: use the cached p->signal value
From: Oleg Nesterov <oleg@tv-sign.ru>

Cache the value of p->signal, and change the code to use while_each_thread()
helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN kernel/signal.c~handle_stop_signal-use-the-cached-p-signal-value kernel/signal.c
--- a/kernel/signal.c~handle_stop_signal-use-the-cached-p-signal-value
+++ a/kernel/signal.c
@@ -566,9 +566,10 @@ static void do_notify_parent_cldstop(str
  */
 static void handle_stop_signal(int sig, struct task_struct *p)
 {
+	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (p->signal->flags & SIGNAL_GROUP_EXIT)
+	if (signal->flags & SIGNAL_GROUP_EXIT)
 		/*
 		 * The process is in the middle of dying already.
 		 */
@@ -578,19 +579,18 @@ static void handle_stop_signal(int sig, 
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
-		rm_from_queue(sigmask(SIGCONT), &p->signal->shared_pending);
+		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
 		t = p;
 		do {
 			rm_from_queue(sigmask(SIGCONT), &t->pending);
-			t = next_thread(t);
-		} while (t != p);
+		} while_each_thread(p, t);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
+		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
@@ -615,9 +615,7 @@ static void handle_stop_signal(int sig, 
 				state |= TASK_INTERRUPTIBLE;
 			}
 			wake_up_state(t, state);
-
-			t = next_thread(t);
-		} while (t != p);
+		} while_each_thread(p, t);
 
 		/*
 		 * Notify the parent with CLD_CONTINUED if we were stopped.
@@ -628,29 +626,29 @@ static void handle_stop_signal(int sig, 
 		 * CLD_CONTINUED was dropped.
 		 */
 		why = 0;
-		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+		if (signal->flags & SIGNAL_STOP_STOPPED)
 			why |= SIGNAL_CLD_CONTINUED;
-		else if (p->signal->group_stop_count)
+		else if (signal->group_stop_count)
 			why |= SIGNAL_CLD_STOPPED;
 
 		if (why) {
-			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
-			p->signal->group_stop_count = 0;
-			p->signal->group_exit_code = 0;
+			signal->flags = why | SIGNAL_STOP_CONTINUED;
+			signal->group_stop_count = 0;
+			signal->group_exit_code = 0;
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
 			 * signal in the middle of being processed after
 			 * being removed from the queue.  Clear that too.
 			 */
-			p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
+			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
 		 * is undone by the wakeup for SIGKILL.
 		 */
-		p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
+		signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

