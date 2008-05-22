From: akpm@linux-foundation.org
Subject: - signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch removed from -mm tree
Date: Thu, 22 May 2008 15:26:50 -0700
Message-ID: <200805222226.m4MMQplW024728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756691AbYEVW1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 18:27:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: sigqueue_free: don't free sigqueue if it is queued
has been removed from the -mm tree.  Its filename was
     signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: sigqueue_free: don't free sigqueue if it is queued
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently sigqueue_free() removes sigqueue from list, but doesn't cancel
the pending signal.  This is not consistent, the task should either
receive the "full" signal along with siginfo_t, or it shouldn't receive
the signal at all.

Change sigqueue_free() to clear SIGQUEUE_PREALLOC but leave sigqueue on
list if it is queued.

This patch doesn't change the behaviour of sys_timer_delete() and friends,
just makes it more correct and allows us to introduce other SIGQUEUE_
flags passed to the receiver.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued kernel/signal.c
--- a/kernel/signal.c~signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued
+++ a/kernel/signal.c
@@ -1240,18 +1240,22 @@ void sigqueue_free(struct sigqueue *q)
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
-	 * If the signal is still pending remove it from the
-	 * pending queue. We must hold ->siglock while testing
-	 * q->list to serialize with collect_signal() or with
+	 * We must hold ->siglock while testing q->list
+	 * to serialize with collect_signal() or with
 	 * __exit_signal()->flush_sigqueue().
 	 */
 	spin_lock_irqsave(lock, flags);
+	q->flags &= ~SIGQUEUE_PREALLOC;
+	/*
+	 * If it is queued it will be freed when dequeued,
+	 * like the "regular" sigqueue.
+	 */
 	if (!list_empty(&q->list))
-		list_del_init(&q->list);
+		q = NULL;
 	spin_unlock_irqrestore(lock, flags);
 
-	q->flags &= ~SIGQUEUE_PREALLOC;
-	__sigqueue_free(q);
+	if (q)
+		__sigqueue_free(q);
 }
 
 int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

signals-fix-sigqueue_free-vs-__exit_signal-race.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch
signals-introduce-sigqueue_cancelled.patch
posix-timers-use-sigqueue_cancelled-when-the-timer-is-destroyed.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch

