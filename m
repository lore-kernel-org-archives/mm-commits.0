From: akpm@linux-foundation.org
Subject: + epoll-cleanup-hoist-out-f_op-poll-calls.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:17:40 -0700
Message-ID: <20130319211740.7185B5A41B5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:59392 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934059Ab3CSVRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:17:42 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so93483vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:17:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net, davidel@xmailserver.org, viro@ZenIV.linux.org.uk


The patch titled
     Subject: epoll: cleanup: hoist out f_op->poll calls
has been added to the -mm tree.  Its filename is
     epoll-cleanup-hoist-out-f_op-poll-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -803,6 +803,13 @@ static int ep_eventpoll_release(struct i
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
@@ -810,10 +817,9 @@ static int ep_read_events_proc(struct ev
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
@@ -1285,7 +1291,6 @@ static int ep_insert(struct eventpoll *e
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
-	epq.pt._key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1294,7 +1299,7 @@ static int ep_insert(struct eventpoll *e
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
-	revents = tfile->f_op->poll(tfile, &epq.pt);
+	revents = ep_item_poll(epi, &epq.pt);
 
 	/*
 	 * We have to check if something went wrong during the poll wait queue
@@ -1394,7 +1399,6 @@ static int ep_modify(struct eventpoll *e
 	 * f_op->poll() call and the new event set registering.
 	 */
 	epi->event.events = event->events; /* need barrier below */
-	pt._key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 	if (epi->event.events & EPOLLWAKEUP) {
 		if (!ep_has_wakeup_source(epi))
@@ -1427,7 +1431,7 @@ static int ep_modify(struct eventpoll *e
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
+	revents = ep_item_poll(epi, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1495,9 +1499,7 @@ static int ep_send_events_proc(struct ev
 
 		list_del_init(&epi->rdllink);
 
-		pt._key = epi->event.events;
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
-			epi->event.events;
+		revents = ep_item_poll(epi, &pt);
 
 		/*
 		 * If the event mask intersect the caller-requested one,
_

Patches currently in -mm which might be from normalperson@yhbt.net are

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
epoll-cleanup-hoist-out-f_op-poll-calls.patch

