From: akpm@linux-foundation.org
Subject: + signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:00:05 -0800
Message-ID: <200802272300.m1RN05j0002690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383AbYB0XA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:00:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     signals: consolidate send_sigqueue and send_group_sigqueue
has been added to the -mm tree.  Its filename is
     signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch

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
Subject: signals: consolidate send_sigqueue and send_group_sigqueue
From: Pavel Emelyanov <xemul@openvz.org>

Both functions do the same thing after proper locking, but with different
sigpening structs, so move the common code into a helper.

After this we have 4 places that look very similar: send_sigqueue: calls
do_send_sigqueue and signal_wakeup send_group_sigqueue: calls do_send_sigqueue
and __group_complete_signal __group_send_sig_info: calls send_signal and
__group_complete_signal specific_send_sig_info: calls send_signal and
signal_wakeup

Besides, send_signal performs actions similar to do_send_sigqueue's
and __group_complete_signal - to signal_wakeup.

It looks like they can be consolidated gracefully.

Oleg said:

  Personally, I think this change is very good.  But send_sigqueue() and
  send_group_sigqueue() have a very subtle difference which I was never able
  to understand.

  Let's suppose that sigqueue is already queued, and the signal is ignored
  (the latter means we should re-schedule cpu timer or handle overrruns).  In
  that case send_sigqueue() returns 0, but send_group_sigqueue() returns 1.

  I think this is not the problem (in fact, I think this patch makes the
  behaviour more correct), but I hope Thomas can take a look and confirm.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   86 +++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 57 deletions(-)

diff -puN kernel/signal.c~signals-consolidate-send_sigqueue-and-send_group_sigqueue kernel/signal.c
--- a/kernel/signal.c~signals-consolidate-send_sigqueue-and-send_group_sigqueue
+++ a/kernel/signal.c
@@ -1290,10 +1290,33 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
+static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
+		struct sigpending *pending)
+{
+	if (unlikely(!list_empty(&q->list))) {
+		/*
+		 * If an SI_TIMER entry is already queue just increment
+		 * the overrun count.
+		 */
+
+		BUG_ON(q->info.si_code != SI_TIMER);
+		q->info.si_overrun++;
+		return 0;
+	}
+
+	if (sig_ignored(t, sig))
+		return 1;
+
+	signalfd_notify(t, sig);
+	list_add_tail(&q->list, &pending->list);
+	sigaddset(&pending->signal, sig);
+	return 0;
+}
+
 int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret = -1;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
@@ -1307,37 +1330,14 @@ int send_sigqueue(int sig, struct sigque
 	 */
 	rcu_read_lock();
 
-	if (!likely(lock_task_sighand(p, &flags))) {
-		ret = -1;
+	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
-	}
 
-	if (unlikely(!list_empty(&q->list))) {
-		/*
-		 * If an SI_TIMER entry is already queue just increment
-		 * the overrun count.
-		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
-		q->info.si_overrun++;
-		goto out;
-	}
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig)) {
-		ret = 1;
-		goto out;
-	}
-	/*
-	 * Deliver the signal to listening signalfds. This must be called
-	 * with the sighand lock held.
-	 */
-	signalfd_notify(p, sig);
+	ret = do_send_sigqueue(sig, q, p, &p->pending);
 
-	list_add_tail(&q->list, &p->pending.list);
-	sigaddset(&p->pending.signal, sig);
 	if (!sigismember(&p->blocked, sig))
 		signal_wake_up(p, sig == SIGKILL);
 
-out:
 	unlock_task_sighand(p, &flags);
 out_err:
 	rcu_read_unlock();
@@ -1349,7 +1349,7 @@ int
 send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
@@ -1358,38 +1358,10 @@ send_group_sigqueue(int sig, struct sigq
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	handle_stop_signal(sig, p);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig)) {
-		ret = 1;
-		goto out;
-	}
-
-	if (unlikely(!list_empty(&q->list))) {
-		/*
-		 * If an SI_TIMER entry is already queue just increment
-		 * the overrun count.  Other uses should not try to
-		 * send the signal multiple times.
-		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
-		q->info.si_overrun++;
-		goto out;
-	} 
-	/*
-	 * Deliver the signal to listening signalfds. This must be called
-	 * with the sighand lock held.
-	 */
-	signalfd_notify(p, sig);
-
-	/*
-	 * Put this signal on the shared-pending queue.
-	 * We always use the shared queue for process-wide signals,
-	 * to avoid several races.
-	 */
-	list_add_tail(&q->list, &p->signal->shared_pending.list);
-	sigaddset(&p->signal->shared_pending.signal, sig);
+	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
 
 	__group_complete_signal(sig, p);
-out:
+
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	read_unlock(&tasklist_lock);
 	return ret;
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
udf-fix-anchor-point-detection.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
