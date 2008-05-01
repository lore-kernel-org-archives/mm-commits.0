From: akpm@linux-foundation.org
Subject: - posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch removed from -mm tree
Date: Thu, 01 May 2008 09:25:12 -0700
Message-ID: <200805011625.m41GPC2v014446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761797AbYEAQ1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 12:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, amdragon+kernelbugzilla@mit.edu, johnstul@us.ibm.com, mingo@elte.hu, mtk.manpages@googlemail.com, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix timers: discard the pending signal when the timer is destroyed
has been removed from the -mm tree.  Its filename was
     posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix timers: discard the pending signal when the timer is destroyed
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently sigqueue_free() removes sigqueue from list, but doesn't cancel the
pending signal.  This is indeed strange, the task should either receive the
"full" signal along with siginfo_t, or it shouldn't see the signal at all.

Change sigqueue_free(q) to do sigdelset() if q is queued.  There is a little
complication.  Looking at "struct sigqueue*" we can't figure out where it is
pending, in ->pending or ->shared_pending.  So this patch adds a new flag,
SIGQUEUE_SHARED_PENDING, which is set/cleared by send_sigqueue().

Alternatively, we can add a new parameter to sigqueue_free(), and the caller
can check SIGEV_THREAD_ID.  But I think this is not as robust as a flag which
is "automatically" correct.

This patch should also fix the problem pointed out by Austin Clements, see

	http://bugzilla.kernel.org/show_bug.cgi?id=10460

Currently, when the task execs it could be killed by the fatal signal sent by
the posix timer, because exec flushes the signal handlers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 kernel/signal.c        |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff -puN include/linux/signal.h~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed include/linux/signal.h
--- a/include/linux/signal.h~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed
+++ a/include/linux/signal.h
@@ -20,6 +20,7 @@ struct sigqueue {
 
 /* flags values. */
 #define SIGQUEUE_PREALLOC	1
+#define SIGQUEUE_SHARED_PENDING	2	/* meaningful only if queued */
 
 struct sigpending {
 	struct list_head list;
diff -puN kernel/signal.c~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed kernel/signal.c
--- a/kernel/signal.c~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed
+++ a/kernel/signal.c
@@ -1233,6 +1233,28 @@ struct sigqueue *sigqueue_alloc(void)
 	return(q);
 }
 
+static void sigqueue_cancel(struct sigqueue *q)
+{
+	struct sigpending *pending;
+	int sig;
+
+	list_del_init(&q->list);
+
+	pending = (q->flags & SIGQUEUE_SHARED_PENDING)
+		? &current->signal->shared_pending
+		: &current->pending;
+
+	sig = q->info.si_signo;
+	if (sig >= SIGRTMIN) {
+		list_for_each_entry(q, &pending->list, list)
+			if (q->info.si_signo == sig)
+				return;
+	}
+
+	sigdelset(&pending->signal, sig);
+	recalc_sigpending();
+}
+
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
@@ -1246,7 +1268,7 @@ void sigqueue_free(struct sigqueue *q)
 	 */
 	spin_lock_irqsave(lock, flags);
 	if (!list_empty(&q->list))
-		list_del_init(&q->list);
+		sigqueue_cancel(q);
 	spin_unlock_irqrestore(lock, flags);
 
 	q->flags &= ~SIGQUEUE_PREALLOC;
@@ -1282,7 +1304,13 @@ int send_sigqueue(struct sigqueue *q, st
 	}
 
 	signalfd_notify(t, sig);
-	pending = group ? &t->signal->shared_pending : &t->pending;
+	if (group) {
+		q->flags |=  SIGQUEUE_SHARED_PENDING;
+		pending = &t->signal->shared_pending;
+	} else {
+		q->flags &= ~SIGQUEUE_SHARED_PENDING;
+		pending = &t->pending;
+	}
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

