From: akpm@linux-foundation.org
Subject: + epoll-fix-epolls-own-poll-update.patch added to -mm tree
Date: Thu, 29 Jan 2009 17:02:59 -0800
Message-ID: <200901300102.n0U12xFl003247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853AbZA3BDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 20:03:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, pisa@cmp.felk.cvut.cz


The patch titled
     epoll: fix epoll's own poll (update)
has been added to the -mm tree.  Its filename is
     epoll-fix-epolls-own-poll-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: fix epoll's own poll (update)
From: Davide Libenzi <davidel@xmailserver.org>

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |  110 ++++++++++++++++++++++++-----------------------
 1 file changed, 57 insertions(+), 53 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-epolls-own-poll-update fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-epolls-own-poll-update
+++ a/fs/eventpoll.c
@@ -454,9 +454,7 @@ static int ep_scan_ready_list(struct eve
 	int error, pwake = 0;
 	unsigned long flags;
 	struct epitem *epi, *nepi;
-	struct list_head txlist;
-
-	INIT_LIST_HEAD(&txlist);
+	LIST_HEAD(txlist);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -473,8 +471,7 @@ static int ep_scan_ready_list(struct eve
 	 * in a lockless way.
 	 */
 	spin_lock_irqsave(&ep->lock, flags);
-	list_splice(&ep->rdllist, &txlist);
-	INIT_LIST_HEAD(&ep->rdllist);
+	list_splice_init(&ep->rdllist, &txlist);
 	ep->ovflist = NULL;
 	spin_unlock_irqrestore(&ep->lock, flags);
 
@@ -514,8 +511,8 @@ static int ep_scan_ready_list(struct eve
 
 	if (!list_empty(&ep->rdllist)) {
 		/*
-		 * Wake up (if active) both the eventpoll wait list and the ->poll()
-		 * wait list (delayed after we release the lock).
+		 * Wake up (if active) both the eventpoll wait list and
+		 * the ->poll() wait list (delayed after we release the lock).
 		 */
 		if (waitqueue_active(&ep->wq))
 			wake_up_locked(&ep->wq);
@@ -632,7 +629,8 @@ static int ep_eventpoll_release(struct i
 	return 0;
 }
 
-static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head, void *priv)
+static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
+			       void *priv)
 {
 	struct epitem *epi, *tmp;
 
@@ -640,13 +638,14 @@ static int ep_read_events_proc(struct ev
 		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
 		    epi->event.events)
 			return POLLIN | POLLRDNORM;
-		else
+		else {
 			/*
 			 * Item has been dropped into the ready list by the poll
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
 			list_del_init(&epi->rdllink);
+		}
 	}
 
 	return 0;
@@ -674,7 +673,7 @@ static unsigned int ep_eventpoll_poll(st
 	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
 				   ep_poll_readyevents_proc, ep, ep);
 
-	return pollflags != -1 ? pollflags: 0;
+	return pollflags != -1 ? pollflags : 0;
 }
 
 /* File callbacks that implement the eventpoll file behaviour */
@@ -870,9 +869,10 @@ static void ep_ptable_queue_proc(struct 
 		add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
-	} else
+	} else {
 		/* We have to signal that an error occurred */
 		epi->nwait = -1;
+	}
 }
 
 static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
@@ -1053,62 +1053,65 @@ static int ep_modify(struct eventpoll *e
 	return 0;
 }
 
-static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head, void *priv)
+static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
+			       void *priv)
 {
 	struct ep_send_events_data *esed = priv;
 	int eventcnt;
-  	unsigned int revents;
+	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
 
-  	/*
+	/*
 	 * We can loop without lock because we are passed a task private list.
 	 * Items cannot vanish during the loop because ep_scan_ready_list() is
 	 * holding "mtx" during this call.
-  	 */
+	 */
 	for (eventcnt = 0, uevent = esed->events;
 	     !list_empty(head) && eventcnt < esed->maxevents;) {
 		epi = list_first_entry(head, struct epitem, rdllink);
 
 		list_del_init(&epi->rdllink);
 
-  		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
-  			epi->event.events;
+		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+			epi->event.events;
 
-  		/*
+		/*
 		 * If the event mask intersect the caller-requested one,
 		 * deliver the event to userspace. Again, ep_scan_ready_list()
 		 * is holding "mtx", so no operations coming from userspace
 		 * can change the item.
-  		 */
-  		if (revents) {
+		 */
+		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data))
-				return eventcnt ? eventcnt: -EFAULT;
-  			eventcnt++;
+				return eventcnt ? eventcnt : -EFAULT;
+			eventcnt++;
 			uevent++;
-  			if (epi->event.events & EPOLLONESHOT)
-  				epi->event.events &= EP_PRIVATE_BITS;
-  			else if (!(epi->event.events & EPOLLET))
-  				/*
-				 * If this file has been added with Level Trigger
-				 * mode, we need to insert back inside the ready
-				 * list, so that the next call to epoll_wait()
-				 * will check again the events availability.
-  				 * At this point, noone can insert into ep->rdllist
-  				 * besides us. The epoll_ctl() callers are locked
-				 * out by ep_scan_ready_list() holding "mtx" and
-				 * the poll callback will queue them in ep->ovflist.
-  				 */
-  				list_add_tail(&epi->rdllink, &ep->rdllist);
-  		}
-  	}
+			if (epi->event.events & EPOLLONESHOT)
+				epi->event.events &= EP_PRIVATE_BITS;
+			else if (!(epi->event.events & EPOLLET)) {
+				/*
+				 * If this file has been added with Level
+				 * Trigger mode, we need to insert back inside
+				 * the ready list, so that the next call to
+				 * epoll_wait() will check again the events
+				 * availability. At this point, noone can insert
+				 * into ep->rdllist besides us. The epoll_ctl()
+				 * callers are locked out by
+				 * ep_scan_ready_list() holding "mtx" and the
+				 * poll callback will queue them in ep->ovflist.
+				 */
+				list_add_tail(&epi->rdllink, &ep->rdllist);
+			}
+		}
+	}
 
 	return eventcnt;
 }
 
-static int ep_send_events(struct eventpoll *ep, struct epoll_event __user *events,
-			  int maxevents)
+static int ep_send_events(struct eventpoll *ep,
+			  struct epoll_event __user *events, int maxevents)
 {
 	struct ep_send_events_data esed;
 
@@ -1192,40 +1195,41 @@ retry:
  */
 SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
-	int error;
-	struct eventpoll *ep = NULL;
+	int error, fd = -1;
+	struct eventpoll *ep;
 
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
+	if (flags & ~EPOLL_CLOEXEC)
+		return -EINVAL;
+
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
 		     current, flags));
 
-	error = -EINVAL;
-	if (flags & ~EPOLL_CLOEXEC)
-		goto error_return;
-
 	/*
-	 * Create the internal data structure ("struct eventpoll").
+	 * Create the internal data structure ( "struct eventpoll" ).
 	 */
 	error = ep_alloc(&ep);
-	if (error < 0)
+	if (error < 0) {
+		fd = error;
 		goto error_return;
+	}
 
 	/*
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
-				 flags & O_CLOEXEC);
-	if (error < 0)
+	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
+			      flags & O_CLOEXEC);
+	if (fd < 0)
 		ep_free(ep);
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, flags, error));
+		     current, flags, fd));
 
-	return error;
+	return fd;
 }
 
 SYSCALL_DEFINE1(epoll_create, int, size)
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch
linux-next.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch

