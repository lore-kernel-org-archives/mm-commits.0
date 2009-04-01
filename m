From: akpm@linux-foundation.org
Subject: [merged] epoll-clean-up-ep_modify.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:36 -0700
Message-ID: <200904011840.n31Iea6p009059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761841AbZDATOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: clean up ep_modify
has been removed from the -mm tree.  Its filename was
     epoll-clean-up-ep_modify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: clean up ep_modify
From: Tony Battersby <tonyb@cybernetics.com>

ep_modify() doesn't need to set event.data from within the ep->lock
spinlock as the comment suggests.  The only place event.data is used is
ep_send_events_proc(), and this is protected by ep->mtx instead of
ep->lock.  Also update the comment for mutex_lock() at the top of
ep_scan_ready_list(), which mentions epoll_ctl(EPOLL_CTL_DEL) but not
epoll_ctl(EPOLL_CTL_MOD).

ep_modify() can also use spin_lock_irq() instead of spin_lock_irqsave().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN fs/eventpoll.c~epoll-clean-up-ep_modify fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-clean-up-ep_modify
+++ a/fs/eventpoll.c
@@ -435,7 +435,7 @@ static int ep_scan_ready_list(struct eve
 
 	/*
 	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
+	 * eventpoll_release_file() and epoll_ctl().
 	 */
 	mutex_lock(&ep->mtx);
 
@@ -972,15 +972,14 @@ static int ep_modify(struct eventpoll *e
 {
 	int pwake = 0;
 	unsigned int revents;
-	unsigned long flags;
 
 	/*
-	 * Set the new event interest mask before calling f_op->poll(), otherwise
-	 * a potential race might occur. In fact if we do this operation inside
-	 * the lock, an event might happen between the f_op->poll() call and the
-	 * new event set registering.
+	 * Set the new event interest mask before calling f_op->poll();
+	 * otherwise we might miss an event that happens between the
+	 * f_op->poll() call and the new event set registering.
 	 */
 	epi->event.events = event->events;
+	epi->event.data = event->data; /* protected by mtx */
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
@@ -988,16 +987,12 @@ static int ep_modify(struct eventpoll *e
 	 */
 	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
 
-	spin_lock_irqsave(&ep->lock, flags);
-
-	/* Copy the data member from inside the lock */
-	epi->event.data = event->data;
-
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
 	 * list, push it inside.
 	 */
 	if (revents & event->events) {
+		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
 
@@ -1007,8 +1002,8 @@ static int ep_modify(struct eventpoll *e
 			if (waitqueue_active(&ep->poll_wait))
 				pwake++;
 		}
+		spin_unlock_irq(&ep->lock);
 	}
-	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

origin.patch
vfs-improve-comment-describing-fget_light.patch
make-shm_get_stat-more-robust.patch

