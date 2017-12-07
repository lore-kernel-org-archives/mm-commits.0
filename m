From: akpm@linux-foundation.org
Subject: + epoll-use-the-waitqueue-lock-to-protect-ep-wq.patch added to
 -mm tree
Date: Wed, 06 Dec 2017 16:05:31 -0800
Message-ID: <5a2885cb.2YBnoIiWwIP9tT1N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdLGAFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jbaron@akamai.com, mingo@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: use the waitqueue lock to protect ep->wq
has been added to the -mm tree.  Its filename is
     epoll-use-the-waitqueue-lock-to-protect-ep-wq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-use-the-waitqueue-lock-to-protect-ep-wq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-use-the-waitqueue-lock-to-protect-ep-wq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: epoll: use the waitqueue lock to protect ep->wq

Patch series "waitqueue lockdep annotation".

This series adds a strategic lockdep_assert_held to __wake_up_common to
ensure callers really do hold the wait_queue_head lock when calling the
unlocked wake_up variants.  It turns out epoll did not do this for a
fairly common path (hit all the time by systemd during bootup), so the
second patch fixed this instance as well.


This patch (of 2):

The epoll code currently always uses the unlocked waitqueue helpers for
ep->wq, but instead of holding the lock inside the waitqueue around these
calls, as expected by the epoll code uses its own lock.  Given that the
waitqueue is not exposed to the rest of the kernel this actually works ok
at the moment, but prevents the epoll locking rules from being enforced
using lockdep.  Remove ep->lock and use the waitqueue lock to not only
reduce the size of struct eventpoll but also make sure we can assert
locking invariations in the waitqueue code.

Link: http://lkml.kernel.org/r/20171206235230.19425-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff -puN fs/eventpoll.c~epoll-use-the-waitqueue-lock-to-protect-ep-wq fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-use-the-waitqueue-lock-to-protect-ep-wq
+++ a/fs/eventpoll.c
@@ -182,11 +182,10 @@ struct epitem {
  * This structure is stored inside the "private_data" member of the file
  * structure and represents the main data structure for the eventpoll
  * interface.
+ *
+ * Access to it is protected by the lock inside wq.
  */
 struct eventpoll {
-	/* Protect the access to this structure */
-	spinlock_t lock;
-
 	/*
 	 * This mutex is used to ensure that files are not removed
 	 * while epoll is using them. This is held during the event
@@ -210,7 +209,7 @@ struct eventpoll {
 	/*
 	 * This is a single linked list that chains all the "struct epitem" that
 	 * happened while transferring ready events to userspace w/out
-	 * holding ->lock.
+	 * holding ->wq.lock.
 	 */
 	struct epitem *ovflist;
 
@@ -686,17 +685,17 @@ static int ep_scan_ready_list(struct eve
 	 * because we want the "sproc" callback to be able to do it
 	 * in a lockless way.
 	 */
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 	list_splice_init(&ep->rdllist, &txlist);
 	ep->ovflist = NULL;
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	/*
 	 * Now call the callback function.
 	 */
 	error = (*sproc)(ep, &txlist, priv);
 
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 	/*
 	 * During the time we spent inside the "sproc" callback, some
 	 * other events might have been queued by the poll callback.
@@ -738,7 +737,7 @@ static int ep_scan_ready_list(struct eve
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	if (!ep_locked)
 		mutex_unlock(&ep->mtx);
@@ -782,10 +781,10 @@ static int ep_remove(struct eventpoll *e
 
 	rb_erase_cached(&epi->rbn, &ep->rbr);
 
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 	if (ep_is_linked(&epi->rdllink))
 		list_del_init(&epi->rdllink);
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	wakeup_source_unregister(ep_wakeup_source(epi));
 	/*
@@ -1015,7 +1014,6 @@ static int ep_alloc(struct eventpoll **p
 	if (unlikely(!ep))
 		goto free_uid;
 
-	spin_lock_init(&ep->lock);
 	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
@@ -1119,7 +1117,7 @@ static int ep_poll_callback(wait_queue_e
 	struct eventpoll *ep = epi->ep;
 	int ewake = 0;
 
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 
 	ep_set_busy_poll_napi_id(epi);
 
@@ -1196,7 +1194,7 @@ static int ep_poll_callback(wait_queue_e
 		pwake++;
 
 out_unlock:
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -1480,7 +1478,7 @@ static int ep_insert(struct eventpoll *e
 		goto error_remove_epi;
 
 	/* We have to drop the new item inside our item list to keep track of it */
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 
 	/* record NAPI ID of new item if present */
 	ep_set_busy_poll_napi_id(epi);
@@ -1497,7 +1495,7 @@ static int ep_insert(struct eventpoll *e
 			pwake++;
 	}
 
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	atomic_long_inc(&ep->user->epoll_watches);
 
@@ -1523,10 +1521,10 @@ error_unregister:
 	 * list, since that is used/cleaned only inside a section bound by "mtx".
 	 * And ep_insert() is called with "mtx" held.
 	 */
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 	if (ep_is_linked(&epi->rdllink))
 		list_del_init(&epi->rdllink);
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	wakeup_source_unregister(ep_wakeup_source(epi));
 
@@ -1593,7 +1591,7 @@ static int ep_modify(struct eventpoll *e
 	 * list, push it inside.
 	 */
 	if (revents & event->events) {
-		spin_lock_irq(&ep->lock);
+		spin_lock_irq(&ep->wq.lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
 			ep_pm_stay_awake(epi);
@@ -1604,7 +1602,7 @@ static int ep_modify(struct eventpoll *e
 			if (waitqueue_active(&ep->poll_wait))
 				pwake++;
 		}
-		spin_unlock_irq(&ep->lock);
+		spin_unlock_irq(&ep->wq.lock);
 	}
 
 	/* We have to call this outside the lock */
@@ -1754,7 +1752,7 @@ static int ep_poll(struct eventpoll *ep,
 		 * caller specified a non blocking operation.
 		 */
 		timed_out = 1;
-		spin_lock_irqsave(&ep->lock, flags);
+		spin_lock_irqsave(&ep->wq.lock, flags);
 		goto check_events;
 	}
 
@@ -1763,7 +1761,7 @@ fetch_events:
 	if (!ep_events_available(ep))
 		ep_busy_loop(ep, timed_out);
 
-	spin_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->wq.lock, flags);
 
 	if (!ep_events_available(ep)) {
 		/*
@@ -1805,11 +1803,11 @@ fetch_events:
 				break;
 			}
 
-			spin_unlock_irqrestore(&ep->lock, flags);
+			spin_unlock_irqrestore(&ep->wq.lock, flags);
 			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
 				timed_out = 1;
 
-			spin_lock_irqsave(&ep->lock, flags);
+			spin_lock_irqsave(&ep->wq.lock, flags);
 		}
 
 		__remove_wait_queue(&ep->wq, &wait);
@@ -1819,7 +1817,7 @@ check_events:
 	/* Is it worth to try to dig for events ? */
 	eavail = ep_events_available(ep);
 
-	spin_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
_

Patches currently in -mm which might be from hch@lst.de are

epoll-use-the-waitqueue-lock-to-protect-ep-wq.patch
sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch

