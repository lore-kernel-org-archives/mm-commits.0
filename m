From: akpm@linux-foundation.org
Subject: + epoll-locks-changes-and-cleanups.patch added to -mm tree
Date: Sun, 13 May 2007 12:30:45 -0700
Message-ID: <200705131930.l4DJUj9L001844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757494AbXEMTa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 15:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     epoll locks changes and cleanups
has been added to the -mm tree.  Its filename is
     epoll-locks-changes-and-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: epoll locks changes and cleanups
From: Davide Libenzi <davidel@xmailserver.org>

Changes the rwlock to a spinlock, and drops the use-count variable. 
Operations are always bound by the mutex now, so the use-count is no more
needed.  For the same reason, the rwlock can become a simple spinlock.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |  234 ++++++++++++++---------------------------------
 1 file changed, 73 insertions(+), 161 deletions(-)

diff -puN fs/eventpoll.c~epoll-locks-changes-and-cleanups fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-locks-changes-and-cleanups
+++ a/fs/eventpoll.c
@@ -1,6 +1,6 @@
 /*
- *  fs/eventpoll.c ( Efficent event polling implementation )
- *  Copyright (C) 2001,...,2006	 Davide Libenzi
+ *  fs/eventpoll.c (Efficent event polling implementation)
+ *  Copyright (C) 2001,...,2007	 Davide Libenzi
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -44,8 +44,8 @@
  * There are three level of locking required by epoll :
  *
  * 1) epmutex (mutex)
- * 2) ep->mtx (mutes)
- * 3) ep->lock (rw_lock)
+ * 2) ep->mtx (mutex)
+ * 3) ep->lock (spinlock)
  *
  * The acquire order is the one listed above, from 1 to 3.
  * We need a spinlock (ep->lock) because we manipulate objects
@@ -140,6 +140,12 @@ struct epitem {
 	/* List header used to link this structure to the eventpoll ready list */
 	struct list_head rdllink;
 
+	/*
+	 * Works together "struct eventpoll"->ovflist in keeping the
+	 * single linked chain of items.
+	 */
+	struct epitem *next;
+
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
 
@@ -152,23 +158,11 @@ struct epitem {
 	/* The "container" of this item */
 	struct eventpoll *ep;
 
-	/* The structure that describe the interested events and the source fd */
-	struct epoll_event event;
-
-	/*
-	 * Used to keep track of the usage count of the structure. This avoids
-	 * that the structure will desappear from underneath our processing.
-	 */
-	atomic_t usecnt;
-
 	/* List header used to link this item to the "struct file" items list */
 	struct list_head fllink;
 
-	/*
-	 * Works together "struct eventpoll"->ovflist in keeping the
-	 * single linked chain of items.
-	 */
-	struct epitem *next;
+	/* The structure that describe the interested events and the source fd */
+	struct epoll_event event;
 };
 
 /*
@@ -178,7 +172,7 @@ struct epitem {
  */
 struct eventpoll {
 	/* Protect the this structure access */
-	rwlock_t lock;
+	spinlock_t lock;
 
 	/*
 	 * This mutex is used to ensure that files are not removed
@@ -394,78 +388,11 @@ static void ep_unregister_pollwait(struc
 }
 
 /*
- * Unlink the "struct epitem" from all places it might have been hooked up.
- * This function must be called with write IRQ lock on "ep->lock".
- */
-static int ep_unlink(struct eventpoll *ep, struct epitem *epi)
-{
-	int error;
-
-	/*
-	 * It can happen that this one is called for an item already unlinked.
-	 * The check protect us from doing a double unlink ( crash ).
-	 */
-	error = -ENOENT;
-	if (!ep_rb_linked(&epi->rbn))
-		goto error_return;
-
-	/*
-	 * Clear the event mask for the unlinked item. This will avoid item
-	 * notifications to be sent after the unlink operation from inside
-	 * the kernel->userspace event transfer loop.
-	 */
-	epi->event.events = 0;
-
-	/*
-	 * At this point is safe to do the job, unlink the item from our rb-tree.
-	 * This operation togheter with the above check closes the door to
-	 * double unlinks.
-	 */
-	ep_rb_erase(&epi->rbn, &ep->rbr);
-
-	/*
-	 * If the item we are going to remove is inside the ready file descriptors
-	 * we want to remove it from this list to avoid stale events.
-	 */
-	if (ep_is_linked(&epi->rdllink))
-		list_del_init(&epi->rdllink);
-
-	error = 0;
-error_return:
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_unlink(%p, %p) = %d\n",
-		     current, ep, epi->ffd.file, error));
-
-	return error;
-}
-
-/*
- * Increment the usage count of the "struct epitem" making it sure
- * that the user will have a valid pointer to reference.
- */
-static void ep_use_epitem(struct epitem *epi)
-{
-	atomic_inc(&epi->usecnt);
-}
-
-/*
- * Decrement ( release ) the usage count by signaling that the user
- * has finished using the structure. It might lead to freeing the
- * structure itself if the count goes to zero.
- */
-static void ep_release_epitem(struct epitem *epi)
-{
-	if (atomic_dec_and_test(&epi->usecnt))
-		kmem_cache_free(epi_cache, epi);
-}
-
-/*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
- * all the associated resources.
+ * all the associated resources. Must be called with "mtx" held.
  */
 static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 {
-	int error;
 	unsigned long flags;
 	struct file *file = epi->ffd.file;
 
@@ -485,26 +412,21 @@ static int ep_remove(struct eventpoll *e
 		list_del_init(&epi->fllink);
 	spin_unlock(&file->f_ep_lock);
 
-	/* We need to acquire the write IRQ lock before calling ep_unlink() */
-	write_lock_irqsave(&ep->lock, flags);
-
-	/* Really unlink the item from the RB tree */
-	error = ep_unlink(ep, epi);
-
-	write_unlock_irqrestore(&ep->lock, flags);
+	if (ep_rb_linked(&epi->rbn))
+		ep_rb_erase(&epi->rbn, &ep->rbr);
 
-	if (error)
-		goto error_return;
+	spin_lock_irqsave(&ep->lock, flags);
+	if (ep_is_linked(&epi->rdllink))
+		list_del_init(&epi->rdllink);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* At this point it is safe to free the eventpoll item */
-	ep_release_epitem(epi);
+	kmem_cache_free(epi_cache, epi);
 
-	error = 0;
-error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p) = %d\n",
-		     current, ep, file, error));
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p)\n",
+		     current, ep, file));
 
-	return error;
+	return 0;
 }
 
 static void ep_free(struct eventpoll *ep)
@@ -574,10 +496,10 @@ static unsigned int ep_eventpoll_poll(st
 	poll_wait(file, &ep->poll_wait, wait);
 
 	/* Check our condition */
-	read_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 	if (!list_empty(&ep->rdllist))
 		pollflags = POLLIN | POLLRDNORM;
-	read_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	return pollflags;
 }
@@ -636,7 +558,7 @@ static int ep_alloc(struct eventpoll **p
 	if (!ep)
 		return -ENOMEM;
 
-	rwlock_init(&ep->lock);
+	spin_lock_init(&ep->lock);
 	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
@@ -652,20 +574,18 @@ static int ep_alloc(struct eventpoll **p
 }
 
 /*
- * Search the file inside the eventpoll tree. It add usage count to
- * the returned item, so the caller must call ep_release_epitem()
- * after finished using the "struct epitem".
+ * Search the file inside the eventpoll tree. The RB tree operations
+ * are protected by the "mtx" mutex, and ep_find() must be called with
+ * "mtx" held.
  */
 static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
 {
 	int kcmp;
-	unsigned long flags;
 	struct rb_node *rbp;
 	struct epitem *epi, *epir = NULL;
 	struct epoll_filefd ffd;
 
 	ep_set_ffd(&ffd, file, fd);
-	read_lock_irqsave(&ep->lock, flags);
 	for (rbp = ep->rbr.rb_node; rbp; ) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		kcmp = ep_cmp_ffd(&ffd, &epi->ffd);
@@ -674,12 +594,10 @@ static struct epitem *ep_find(struct eve
 		else if (kcmp < 0)
 			rbp = rbp->rb_left;
 		else {
-			ep_use_epitem(epi);
 			epir = epi;
 			break;
 		}
 	}
-	read_unlock_irqrestore(&ep->lock, flags);
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_find(%p) -> %p\n",
 		     current, file, epir));
@@ -702,7 +620,7 @@ static int ep_poll_callback(wait_queue_t
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
 		     current, epi->ffd.file, epi, ep));
 
-	write_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
 	 * If the event mask does not contain any poll(2) event, we consider the
@@ -745,7 +663,7 @@ is_linked:
 		pwake++;
 
 out_unlock:
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -796,6 +714,9 @@ static void ep_rbtree_insert(struct even
 	rb_insert_color(&epi->rbn, &ep->rbr);
 }
 
+/*
+ * Must be called with "mtx" held.
+ */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		     struct file *tfile, int fd)
 {
@@ -816,7 +737,6 @@ static int ep_insert(struct eventpoll *e
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
 	epi->event = *event;
-	atomic_set(&epi->usecnt, 1);
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
 
@@ -827,7 +747,9 @@ static int ep_insert(struct eventpoll *e
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
 	 * We can safely use the file* here because its usage count has
-	 * been increased by the caller of this function.
+	 * been increased by the caller of this function. Note that after
+	 * this operation completes, the poll callback can start hitting
+	 * the new item.
 	 */
 	revents = tfile->f_op->poll(tfile, &epq.pt);
 
@@ -844,12 +766,15 @@ static int ep_insert(struct eventpoll *e
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
 	spin_unlock(&tfile->f_ep_lock);
 
-	/* We have to drop the new item inside our item list to keep track of it */
-	write_lock_irqsave(&ep->lock, flags);
-
-	/* Add the current item to the rb-tree */
+	/*
+	 * Add the current item to the RB tree. All RB tree operations are
+	 * protected by "mtx", and ep_insert() is called with "mtx" held.
+	 */
 	ep_rbtree_insert(ep, epi);
 
+	/* We have to drop the new item inside our item list to keep track of it */
+	spin_lock_irqsave(&ep->lock, flags);
+
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
@@ -861,7 +786,7 @@ static int ep_insert(struct eventpoll *e
 			pwake++;
 	}
 
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -879,10 +804,10 @@ error_unregister:
 	 * We need to do this because an event could have been arrived on some
 	 * allocated wait queue.
 	 */
-	write_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
 		list_del_init(&epi->rdllink);
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	kmem_cache_free(epi_cache, epi);
 error_return:
@@ -891,7 +816,7 @@ error_return:
 
 /*
  * Modify the interest event mask by dropping an event if the new mask
- * has a match in the current file status.
+ * has a match in the current file status. Must be called with "mtx" held.
  */
 static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_event *event)
 {
@@ -913,36 +838,29 @@ static int ep_modify(struct eventpoll *e
 	 */
 	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
 
-	write_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 
 	/* Copy the data member from inside the lock */
 	epi->event.data = event->data;
 
 	/*
-	 * If the item is not linked to the RB tree it means that it's on its
-	 * way toward the removal. Do nothing in this case.
+	 * If the item is "hot" and it is not registered inside the ready
+	 * list, push it inside. If the item is not "hot" and it is currently
+	 * registered inside the ready list, unlink it.
 	 */
-	if (ep_rb_linked(&epi->rbn)) {
-		/*
-		 * If the item is "hot" and it is not registered inside the ready
-		 * list, push it inside. If the item is not "hot" and it is currently
-		 * registered inside the ready list, unlink it.
-		 */
-		if (revents & event->events) {
-			if (!ep_is_linked(&epi->rdllink)) {
-				list_add_tail(&epi->rdllink, &ep->rdllist);
-
-				/* Notify waiting tasks that events are available */
-				if (waitqueue_active(&ep->wq))
-					__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-							 TASK_INTERRUPTIBLE);
-				if (waitqueue_active(&ep->poll_wait))
-					pwake++;
-			}
+	if (revents & event->events) {
+		if (!ep_is_linked(&epi->rdllink)) {
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+
+			/* Notify waiting tasks that events are available */
+			if (waitqueue_active(&ep->wq))
+				__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
+						 TASK_INTERRUPTIBLE);
+			if (waitqueue_active(&ep->poll_wait))
+				pwake++;
 		}
 	}
-
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -975,11 +893,11 @@ static int ep_send_events(struct eventpo
 	 * have the poll callback to queue directly on ep->rdllist,
 	 * because we are doing it in the loop below, in a lockless way.
 	 */
-	write_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 	list_splice(&ep->rdllist, &txlist);
 	INIT_LIST_HEAD(&ep->rdllist);
 	ep->ovflist = NULL;
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/*
 	 * We can loop without lock because this is a task private list.
@@ -1028,7 +946,7 @@ static int ep_send_events(struct eventpo
 
 errxit:
 
-	write_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 	/*
 	 * During the time we spent in the loop above, some other events
 	 * might have been queued by the poll callback. We re-insert them
@@ -1064,7 +982,7 @@ errxit:
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
 	}
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	mutex_unlock(&ep->mtx);
 
@@ -1092,7 +1010,7 @@ static int ep_poll(struct eventpoll *ep,
 		MAX_SCHEDULE_TIMEOUT : (timeout * HZ + 999) / 1000;
 
 retry:
-	write_lock_irqsave(&ep->lock, flags);
+	spin_lock_irqsave(&ep->lock, flags);
 
 	res = 0;
 	if (list_empty(&ep->rdllist)) {
@@ -1119,9 +1037,9 @@ retry:
 				break;
 			}
 
-			write_unlock_irqrestore(&ep->lock, flags);
+			spin_unlock_irqrestore(&ep->lock, flags);
 			jtimeout = schedule_timeout(jtimeout);
-			write_lock_irqsave(&ep->lock, flags);
+			spin_lock_irqsave(&ep->lock, flags);
 		}
 		__remove_wait_queue(&ep->wq, &wait);
 
@@ -1131,7 +1049,7 @@ retry:
 	/* Is it worth to try to dig for events ? */
 	eavail = !list_empty(&ep->rdllist);
 
-	write_unlock_irqrestore(&ep->lock, flags);
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
@@ -1276,12 +1194,6 @@ asmlinkage long sys_epoll_ctl(int epfd, 
 			error = -ENOENT;
 		break;
 	}
-	/*
-	 * The function ep_find() increments the usage count of the structure
-	 * so, if this is not NULL, we need to release it.
-	 */
-	if (epi)
-		ep_release_epitem(epi);
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
@@ -1388,7 +1300,7 @@ asmlinkage long sys_epoll_pwait(int epfd
 	if (sigmask) {
 		if (error == -EINTR) {
 			memcpy(&current->saved_sigmask, &sigsaved,
-				sizeof(sigsaved));
+			       sizeof(sigsaved));
 			set_thread_flag(TIF_RESTORE_SIGMASK);
 		} else
 			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

fix-epoll-single-pass-code-and-add-wait-exclusive-flag.patch
epoll-locks-changes-and-cleanups.patch
