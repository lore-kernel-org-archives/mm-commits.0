From: akpm@linux-foundation.org
Subject: - signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:14 -0700
Message-ID: <200805010926.m419QEuC030282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216AbYEAJ1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: re-assign CLD_CONTINUED notification from the sender to reciever
has been removed from the -mm tree.  Its filename was
     signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: re-assign CLD_CONTINUED notification from the sender to reciever
From: Oleg Nesterov <oleg@tv-sign.ru>

Based on discussion with Jiri and Roland.

In short: currently handle_stop_signal(SIGCONT, p) sends the notification to
p->parent, with this patch p itself notifies its parent when it becomes
running.

handle_stop_signal(SIGCONT) has to drop ->siglock temporary in order to notify
the parent with do_notify_parent_cldstop().  This leads to multiple problems:

	- as Jiri Kosina pointed out, the stopped task can resume without
	  actually seeing SIGCONT which may have a handler.

	- we race with another sig_kernel_stop() signal which may come in
	  that window.

	- we race with sig_fatal() signals which may set SIGNAL_GROUP_EXIT
	  in that window.

	- we can't avoid taking tasklist_lock() while sending SIGCONT.

With this patch handle_stop_signal() just sets the new SIGNAL_CLD_CONTINUED
flag in p->signal->flags and returns.  The notification is sent by the first
task which returns from finish_stop() (there should be at least one) or any
other signalled thread from get_signal_to_deliver().

This is a user-visible change.  Say, currently kill(SIGCONT, stopped_child)
can't return without seeing SIGCHLD, with this patch SIGCHLD can be delayed
unpredictably.  Another difference is that if the child is ptraced by another
process, CLD_CONTINUED may be delivered to ->real_parent after ptrace_detach()
while currently it always goes to the tracer which doesn't actually need this
notification.  Hopefully not a problem.

The patch asks for the futher obvious cleanups, I'll send them separately.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ++++++
 kernel/signal.c       |   29 +++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff -puN include/linux/sched.h~signals-re-assign-cld_continued-notification-from-the-sender-to-reciever include/linux/sched.h
--- a/include/linux/sched.h~signals-re-assign-cld_continued-notification-from-the-sender-to-reciever
+++ a/include/linux/sched.h
@@ -554,6 +554,12 @@ struct signal_struct {
 #define SIGNAL_STOP_DEQUEUED	0x00000002 /* stop signal dequeued */
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
+/*
+ * Pending notifications to parent.
+ */
+#define SIGNAL_CLD_STOPPED	0x00000010
+#define SIGNAL_CLD_CONTINUED	0x00000020
+#define SIGNAL_CLD_MASK		(SIGNAL_CLD_STOPPED|SIGNAL_CLD_CONTINUED)
 
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
diff -puN kernel/signal.c~signals-re-assign-cld_continued-notification-from-the-sender-to-reciever kernel/signal.c
--- a/kernel/signal.c~signals-re-assign-cld_continued-notification-from-the-sender-to-reciever
+++ a/kernel/signal.c
@@ -603,10 +603,8 @@ static void handle_stop_signal(int sig, 
 			 * the SIGCHLD was pending on entry to this kill.
 			 */
 			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_STOPPED);
-			spin_lock(&p->sighand->siglock);
+			p->signal->flags = SIGNAL_STOP_CONTINUED |
+						SIGNAL_CLD_STOPPED;
 		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
@@ -643,25 +641,23 @@ static void handle_stop_signal(int sig, 
 			 * We were in fact stopped, and are now continued.
 			 * Notify the parent with CLD_CONTINUED.
 			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
+			p->signal->flags = SIGNAL_STOP_CONTINUED |
+						SIGNAL_CLD_CONTINUED;
 			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
 			 * signal in the middle of being processed after
 			 * being removed from the queue.  Clear that too.
 			 */
-			p->signal->flags = 0;
+			p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
 		 * is undone by the wakeup for SIGKILL.
 		 */
-		p->signal->flags = 0;
+		p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 
@@ -1784,6 +1780,19 @@ relock:
 	try_to_freeze();
 
 	spin_lock_irq(&current->sighand->siglock);
+
+	if (unlikely(current->signal->flags & SIGNAL_CLD_MASK)) {
+		int why = (current->signal->flags & SIGNAL_STOP_CONTINUED)
+				? CLD_CONTINUED : CLD_STOPPED;
+		current->signal->flags &= ~SIGNAL_CLD_MASK;
+		spin_unlock_irq(&current->sighand->siglock);
+
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current->group_leader, why);
+		read_unlock(&tasklist_lock);
+		goto relock;
+	}
+
 	for (;;) {
 		struct k_sigaction *ka;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

