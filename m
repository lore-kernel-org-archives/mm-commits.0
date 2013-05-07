From: akpm@linux-foundation.org
Subject: [merged] epoll-cleanup-hoist-out-f_op-poll-calls.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:15 -0700
Message-ID: <20130507174815.7B5E45A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:51321 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab3EGRsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:16 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so73381ghr.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: normalperson@yhbt.net, davidel@xmailserver.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: cleanup: hoist out f_op->poll calls
has been removed from the -mm tree.  Its filename was
     epoll-cleanup-hoist-out-f_op-poll-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Wong <normalperson@yhbt.net>
Subject: epoll: cleanup: hoist out f_op->poll calls

This reduces the amount of code inside the ready list iteration loops for
better readability IMHO.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/eventpoll.c~epoll-cleanup-hoist-out-f_op-poll-calls fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-cleanup-hoist-out-f_op-poll-calls
+++ a/fs/eventpoll.c
@@ -772,6 +772,13 @@ static int ep_eventpoll_release(struct i
 	return 0;
 }
 
+static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
+{
+	pt->_key = epi->event.events;
+
+	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+}
+
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
@@ -779,10 +786,9 @@ static int ep_read_events_proc(struct ev
 	poll_table pt;
 
 	init_poll_funcptr(&pt, NULL);
+
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		pt._key = epi->event.events;
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
-		    epi->event.events)
+		if (ep_item_poll(epi, &pt))
 			return POLLIN | POLLRDNORM;
 		else {
 			/*
@@ -1256,7 +1262,6 @@ static int ep_insert(struct eventpoll *e
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
-	epq.pt._key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1265,7 +1270,7 @@ static int ep_insert(struct eventpoll *e
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
-	revents = tfile->f_op->poll(tfile, &epq.pt);
+	revents = ep_item_poll(epi, &epq.pt);
 
 	/*
 	 * We have to check if something went wrong during the poll wait queue
@@ -1365,7 +1370,6 @@ static int ep_modify(struct eventpoll *e
 	 * f_op->poll() call and the new event set registering.
 	 */
 	epi->event.events = event->events; /* need barrier below */
-	pt._key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 	if (epi->event.events & EPOLLWAKEUP) {
 		if (!ep_has_wakeup_source(epi))
@@ -1398,7 +1402,7 @@ static int ep_modify(struct eventpoll *e
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
+	revents = ep_item_poll(epi, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1466,9 +1470,7 @@ static int ep_send_events_proc(struct ev
 
 		list_del_init(&epi->rdllink);
 
-		pt._key = epi->event.events;
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
-			epi->event.events;
+		revents = ep_item_poll(epi, &pt);
 
 		/*
 		 * If the event mask intersect the caller-requested one,
_

Patches currently in -mm which might be from normalperson@yhbt.net are

origin.patch

