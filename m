From: akpm@linux-foundation.org
Subject: - fix-epoll-single-pass-code-and-add-wait-exclusive-flag.patch removed from -mm tree
Date: Tue, 15 May 2007 11:06:52 -0700
Message-ID: <200705151806.l4FI6qot014121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326AbXEOSHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     fix epoll single pass code and add wait-exclusive flag
has been removed from the -mm tree.  Its filename was
     fix-epoll-single-pass-code-and-add-wait-exclusive-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix epoll single pass code and add wait-exclusive flag
From: Davide Libenzi <davidel@xmailserver.org>

Fixes the epoll single pass code.  During the unlocked event delivery (to
userspace) code, the poll callback can re-issue new events, and we must
receive them correctly.  Since we loop in a lockless fashion, we want to be
O(nready), and we don't want to flash on/off the spinlock for every event, we
have the poll callback to use a secondary list to queue events while we're
inside the event delivery loop.  The rw_semaphore has been turned into a
mutex.  This patch also adds the wait-exclusive flag, as suggested by Davi
Arnaut.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |  322 ++++++++++++++++++++++++-----------------------
 1 file changed, 166 insertions(+), 156 deletions(-)

diff -puN fs/eventpoll.c~fix-epoll-single-pass-code-and-add-wait-exclusive-flag fs/eventpoll.c
--- a/fs/eventpoll.c~fix-epoll-single-pass-code-and-add-wait-exclusive-flag
+++ a/fs/eventpoll.c
@@ -26,7 +26,6 @@
 #include <linux/hash.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
-#include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/wait.h>
 #include <linux/eventpoll.h>
@@ -39,14 +38,13 @@
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 /*
  * LOCKING:
  * There are three level of locking required by epoll :
  *
  * 1) epmutex (mutex)
- * 2) ep->sem (rw_semaphore)
+ * 2) ep->mtx (mutes)
  * 3) ep->lock (rw_lock)
  *
  * The acquire order is the one listed above, from 1 to 3.
@@ -57,20 +55,20 @@
  * a spinlock. During the event transfer loop (from kernel to
  * user space) we could end up sleeping due a copy_to_user(), so
  * we need a lock that will allow us to sleep. This lock is a
- * read-write semaphore (ep->sem). It is acquired on read during
- * the event transfer loop and in write during epoll_ctl(EPOLL_CTL_DEL)
- * and during eventpoll_release_file(). Then we also need a global
- * semaphore to serialize eventpoll_release_file() and ep_free().
- * This semaphore is acquired by ep_free() during the epoll file
+ * mutex (ep->mtx). It is acquired during the event transfer loop,
+ * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
+ * Then we also need a global mutex to serialize eventpoll_release_file()
+ * and ep_free().
+ * This mutex is acquired by ep_free() during the epoll file
  * cleanup path and it is also acquired by eventpoll_release_file()
  * if a file has been pushed inside an epoll set and it is then
  * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
- * It is possible to drop the "ep->sem" and to use the global
- * semaphore "epmutex" (together with "ep->lock") to have it working,
- * but having "ep->sem" will make the interface more scalable.
+ * It is possible to drop the "ep->mtx" and to use the global
+ * mutex "epmutex" (together with "ep->lock") to have it working,
+ * but having "ep->mtx" will make the interface more scalable.
  * Events that require holding "epmutex" are very rare, while for
- * normal operations the epoll private "ep->sem" will guarantee
- * a greater scalability.
+ * normal operations the epoll private "ep->mtx" will guarantee
+ * a better scalability.
  */
 
 #define DEBUG_EPOLL 0
@@ -102,6 +100,8 @@
 
 #define EP_MAX_EVENTS (INT_MAX / sizeof(struct epoll_event))
 
+#define EP_UNACTIVE_PTR ((void *) -1L)
+
 struct epoll_filefd {
 	struct file *file;
 	int fd;
@@ -111,7 +111,7 @@ struct epoll_filefd {
  * Node that is linked into the "wake_task_list" member of the "struct poll_safewake".
  * It is used to keep track on all tasks that are currently inside the wake_up() code
  * to 1) short-circuit the one coming from the same task and same wait queue head
- * ( loop ) 2) allow a maximum number of epoll descriptors inclusion nesting
+ * (loop) 2) allow a maximum number of epoll descriptors inclusion nesting
  * 3) let go the ones coming from other tasks.
  */
 struct wake_task_node {
@@ -130,6 +130,48 @@ struct poll_safewake {
 };
 
 /*
+ * Each file descriptor added to the eventpoll interface will
+ * have an entry of this type linked to the "rbr" RB tree.
+ */
+struct epitem {
+	/* RB-Tree node used to link this structure to the eventpoll rb-tree */
+	struct rb_node rbn;
+
+	/* List header used to link this structure to the eventpoll ready list */
+	struct list_head rdllink;
+
+	/* The file descriptor information this item refers to */
+	struct epoll_filefd ffd;
+
+	/* Number of active wait queue attached to poll operations */
+	int nwait;
+
+	/* List containing poll wait queues */
+	struct list_head pwqlist;
+
+	/* The "container" of this item */
+	struct eventpoll *ep;
+
+	/* The structure that describe the interested events and the source fd */
+	struct epoll_event event;
+
+	/*
+	 * Used to keep track of the usage count of the structure. This avoids
+	 * that the structure will desappear from underneath our processing.
+	 */
+	atomic_t usecnt;
+
+	/* List header used to link this item to the "struct file" items list */
+	struct list_head fllink;
+
+	/*
+	 * Works together "struct eventpoll"->ovflist in keeping the
+	 * single linked chain of items.
+	 */
+	struct epitem *next;
+};
+
+/*
  * This structure is stored inside the "private_data" member of the file
  * structure and rapresent the main data sructure for the eventpoll
  * interface.
@@ -139,12 +181,12 @@ struct eventpoll {
 	rwlock_t lock;
 
 	/*
-	 * This semaphore is used to ensure that files are not removed
-	 * while epoll is using them. This is read-held during the event
-	 * collection loop and it is write-held during the file cleanup
-	 * path, the epoll file exit code and the ctl operations.
+	 * This mutex is used to ensure that files are not removed
+	 * while epoll is using them. This is held during the event
+	 * collection loop, the file cleanup path, the epoll file exit
+	 * code and the ctl operations.
 	 */
-	struct rw_semaphore sem;
+	struct mutex mtx;
 
 	/* Wait queue used by sys_epoll_wait() */
 	wait_queue_head_t wq;
@@ -157,6 +199,13 @@ struct eventpoll {
 
 	/* RB-Tree root used to store monitored fd structs */
 	struct rb_root rbr;
+
+	/*
+	 * This is a single linked list that chains all the "struct epitem" that
+	 * happened while transfering ready events to userspace w/out
+	 * holding ->lock.
+	 */
+	struct epitem *ovflist;
 };
 
 /* Wait structure used by the poll hooks */
@@ -177,42 +226,6 @@ struct eppoll_entry {
 	wait_queue_head_t *whead;
 };
 
-/*
- * Each file descriptor added to the eventpoll interface will
- * have an entry of this type linked to the "rbr" RB tree.
- */
-struct epitem {
-	/* RB-Tree node used to link this structure to the eventpoll rb-tree */
-	struct rb_node rbn;
-
-	/* List header used to link this structure to the eventpoll ready list */
-	struct list_head rdllink;
-
-	/* The file descriptor information this item refers to */
-	struct epoll_filefd ffd;
-
-	/* Number of active wait queue attached to poll operations */
-	int nwait;
-
-	/* List containing poll wait queues */
-	struct list_head pwqlist;
-
-	/* The "container" of this item */
-	struct eventpoll *ep;
-
-	/* The structure that describe the interested events and the source fd */
-	struct epoll_event event;
-
-	/*
-	 * Used to keep track of the usage count of the structure. This avoids
-	 * that the structure will desappear from underneath our processing.
-	 */
-	atomic_t usecnt;
-
-	/* List header used to link this item to the "struct file" items list */
-	struct list_head fllink;
-};
-
 /* Wrapper struct used by poll queueing */
 struct ep_pqueue {
 	poll_table pt;
@@ -220,7 +233,7 @@ struct ep_pqueue {
 };
 
 /*
- * This semaphore is used to serialize ep_free() and eventpoll_release_file().
+ * This mutex is used to serialize ep_free() and eventpoll_release_file().
  */
 static struct mutex epmutex;
 
@@ -506,7 +519,7 @@ static void ep_free(struct eventpoll *ep
 	/*
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
-	 * We do not need to hold "ep->sem" here because the epoll file
+	 * We do not need to hold "ep->mtx" here because the epoll file
 	 * is on the way to be removed and no one has references to it
 	 * anymore. The only hit might come from eventpoll_release_file() but
 	 * holding "epmutex" is sufficent here.
@@ -525,7 +538,7 @@ static void ep_free(struct eventpoll *ep
 	/*
 	 * Walks through the whole tree by freeing each "struct epitem". At this
 	 * point we are sure no poll callbacks will be lingering around, and also by
-	 * write-holding "sem" we can be sure that no file cleanup code will hit
+	 * holding "epmutex" we can be sure that no file cleanup code will hit
 	 * us during this operation. So we can avoid the lock on "ep->lock".
 	 */
 	while ((rbp = rb_first(&ep->rbr)) != 0) {
@@ -534,6 +547,8 @@ static void ep_free(struct eventpoll *ep
 	}
 
 	mutex_unlock(&epmutex);
+
+	mutex_destroy(&ep->mtx);
 }
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
@@ -594,9 +609,9 @@ void eventpoll_release_file(struct file 
 	 * We don't want to get "file->f_ep_lock" because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
-	 * The only hit might come from ep_free() but by holding the semaphore
+	 * The only hit might come from ep_free() but by holding the mutex
 	 * will correctly serialize the operation. We do need to acquire
-	 * "ep->sem" after "epmutex" because ep_remove() requires it when called
+	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
 	 * from anywhere but ep_free().
 	 */
 	mutex_lock(&epmutex);
@@ -606,9 +621,9 @@ void eventpoll_release_file(struct file 
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		down_write(&ep->sem);
+		mutex_lock(&ep->mtx);
 		ep_remove(ep, epi);
-		up_write(&ep->sem);
+		mutex_unlock(&ep->mtx);
 	}
 
 	mutex_unlock(&epmutex);
@@ -622,11 +637,12 @@ static int ep_alloc(struct eventpoll **p
 		return -ENOMEM;
 
 	rwlock_init(&ep->lock);
-	init_rwsem(&ep->sem);
+	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
 	ep->rbr = RB_ROOT;
+	ep->ovflist = EP_UNACTIVE_PTR;
 
 	*pep = ep;
 
@@ -695,7 +711,21 @@ static int ep_poll_callback(wait_queue_t
 	 * until the next EPOLL_CTL_MOD will be issued.
 	 */
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
-		goto is_disabled;
+		goto out_unlock;
+
+	/*
+	 * If we are trasfering events to userspace, we can hold no locks
+	 * (because we're accessing user memory, and because of linux f_op->poll()
+	 * semantics). All the events that happens during that period of time are
+	 * chained in ep->ovflist and requeued later on.
+	 */
+	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
+		if (epi->next == EP_UNACTIVE_PTR) {
+			epi->next = ep->ovflist;
+			ep->ovflist = epi;
+		}
+		goto out_unlock;
+	}
 
 	/* If this file is already in the ready list we exit soon */
 	if (ep_is_linked(&epi->rdllink))
@@ -714,7 +744,7 @@ is_linked:
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
-is_disabled:
+out_unlock:
 	write_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
@@ -788,6 +818,7 @@ static int ep_insert(struct eventpoll *e
 	epi->event = *event;
 	atomic_set(&epi->usecnt, 1);
 	epi->nwait = 0;
+	epi->next = EP_UNACTIVE_PTR;
 
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
@@ -920,36 +951,50 @@ static int ep_modify(struct eventpoll *e
 	return 0;
 }
 
-/*
- * This function is called without holding the "ep->lock" since the call to
- * __copy_to_user() might sleep, and also f_op->poll() might reenable the IRQ
- * because of the way poll() is traditionally implemented in Linux.
- */
-static int ep_send_events(struct eventpoll *ep, struct list_head *txlist,
-			  struct epoll_event __user *events, int maxevents)
+static int ep_send_events(struct eventpoll *ep, struct epoll_event __user *events,
+			  int maxevents)
 {
 	int eventcnt, error = -EFAULT, pwake = 0;
 	unsigned int revents;
 	unsigned long flags;
-	struct epitem *epi;
-	struct list_head injlist;
+	struct epitem *epi, *nepi;
+	struct list_head txlist;
+
+	INIT_LIST_HEAD(&txlist);
 
-	INIT_LIST_HEAD(&injlist);
+	/*
+	 * We need to lock this because we could be hit by
+	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
+	 */
+	mutex_lock(&ep->mtx);
+
+	/*
+	 * Steal the ready list, and re-init the original one to the
+	 * empty list. Also, set ep->ovflist to NULL so that events
+	 * happening while looping w/out locks, are not lost. We cannot
+	 * have the poll callback to queue directly on ep->rdllist,
+	 * because we are doing it in the loop below, in a lockless way.
+	 */
+	write_lock_irqsave(&ep->lock, flags);
+	list_splice(&ep->rdllist, &txlist);
+	INIT_LIST_HEAD(&ep->rdllist);
+	ep->ovflist = NULL;
+	write_unlock_irqrestore(&ep->lock, flags);
 
 	/*
 	 * We can loop without lock because this is a task private list.
 	 * We just splice'd out the ep->rdllist in ep_collect_ready_items().
-	 * Items cannot vanish during the loop because we are holding "sem" in
-	 * read.
+	 * Items cannot vanish during the loop because we are holding "mtx".
 	 */
-	for (eventcnt = 0; !list_empty(txlist) && eventcnt < maxevents;) {
-		epi = list_first_entry(txlist, struct epitem, rdllink);
-		prefetch(epi->rdllink.next);
+	for (eventcnt = 0; !list_empty(&txlist) && eventcnt < maxevents;) {
+		epi = list_first_entry(&txlist, struct epitem, rdllink);
+
+		list_del_init(&epi->rdllink);
 
 		/*
 		 * Get the ready file event set. We can safely use the file
-		 * because we are holding the "sem" in read and this will
-		 * guarantee that both the file and the item will not vanish.
+		 * because we are holding the "mtx" and this will guarantee
+		 * that both the file and the item will not vanish.
 		 */
 		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
 		revents &= epi->event.events;
@@ -957,8 +1002,8 @@ static int ep_send_events(struct eventpo
 		/*
 		 * Is the event mask intersect the caller-requested one,
 		 * deliver the event to userspace. Again, we are holding
-		 * "sem" in read, so no operations coming from userspace
-		 * can change the item.
+		 * "mtx", so no operations coming from userspace can change
+		 * the item.
 		 */
 		if (revents) {
 			if (__put_user(revents,
@@ -970,49 +1015,47 @@ static int ep_send_events(struct eventpo
 				epi->event.events &= EP_PRIVATE_BITS;
 			eventcnt++;
 		}
-
 		/*
-		 * This is tricky. We are holding the "sem" in read, and this
-		 * means that the operations that can change the "linked" status
-		 * of the epoll item (epi->rbn and epi->rdllink), cannot touch
-		 * them.  Also, since we are "linked" from a epi->rdllink POV
-		 * (the item is linked to our transmission list we just
-		 * spliced), the ep_poll_callback() cannot touch us either,
-		 * because of the check present in there. Another parallel
-		 * epoll_wait() will not get the same result set, since we
-		 * spliced the ready list before.  Note that list_del() still
-		 * shows the item as linked to the test in ep_poll_callback().
+		 * At this point, noone can insert into ep->rdllist besides
+		 * us. The epoll_ctl() callers are locked out by us holding
+		 * "mtx" and the poll callback will queue them in ep->ovflist.
 		 */
-		list_del(&epi->rdllink);
 		if (!(epi->event.events & EPOLLET) &&
-				(revents & epi->event.events))
-			list_add_tail(&epi->rdllink, &injlist);
-		else {
-			/*
-			 * Be sure the item is totally detached before re-init
-			 * the list_head. After INIT_LIST_HEAD() is committed,
-			 * the ep_poll_callback() can requeue the item again,
-			 * but we don't care since we are already past it.
-			 */
-			smp_mb();
-			INIT_LIST_HEAD(&epi->rdllink);
-		}
+		    (revents & epi->event.events))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
 	}
 	error = 0;
 
-	errxit:
+errxit:
 
+	write_lock_irqsave(&ep->lock, flags);
 	/*
-	 * If the re-injection list or the txlist are not empty, re-splice
-	 * them to the ready list and do proper wakeups.
+	 * During the time we spent in the loop above, some other events
+	 * might have been queued by the poll callback. We re-insert them
+	 * here (in case they are not already queued, or they're one-shot).
+	 */
+	for (nepi = ep->ovflist; (epi = nepi) != NULL;
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		if (!ep_is_linked(&epi->rdllink) &&
+		    (epi->event.events & ~EP_PRIVATE_BITS))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+	}
+	/*
+	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
+	 * releasing the lock, events will be queued in the normal way inside
+	 * ep->rdllist.
 	 */
-	if (!list_empty(&injlist) || !list_empty(txlist)) {
-		write_lock_irqsave(&ep->lock, flags);
+	ep->ovflist = EP_UNACTIVE_PTR;
 
-		list_splice(txlist, &ep->rdllist);
-		list_splice(&injlist, &ep->rdllist);
+	/*
+	 * In case of error in the event-send loop, we might still have items
+	 * inside the "txlist". We need to splice them back inside ep->rdllist.
+	 */
+	list_splice(&txlist, &ep->rdllist);
+
+	if (!list_empty(&ep->rdllist)) {
 		/*
-		 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
+		 * Wake up (if active) both the eventpoll wait list and the ->poll()
 		 * wait list.
 		 */
 		if (waitqueue_active(&ep->wq))
@@ -1020,9 +1063,10 @@ static int ep_send_events(struct eventpo
 					 TASK_INTERRUPTIBLE);
 		if (waitqueue_active(&ep->poll_wait))
 			pwake++;
-
-		write_unlock_irqrestore(&ep->lock, flags);
 	}
+	write_unlock_irqrestore(&ep->lock, flags);
+
+	mutex_unlock(&ep->mtx);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -1031,41 +1075,6 @@ static int ep_send_events(struct eventpo
 	return eventcnt == 0 ? error: eventcnt;
 }
 
-/*
- * Perform the transfer of events to user space.
- */
-static int ep_events_transfer(struct eventpoll *ep,
-			      struct epoll_event __user *events, int maxevents)
-{
-	int eventcnt;
-	unsigned long flags;
-	struct list_head txlist;
-
-	INIT_LIST_HEAD(&txlist);
-
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
-	 */
-	down_read(&ep->sem);
-
-	/*
-	 * Steal the ready list, and re-init the original one to the
-	 * empty list.
-	 */
-	write_lock_irqsave(&ep->lock, flags);
-	list_splice(&ep->rdllist, &txlist);
-	INIT_LIST_HEAD(&ep->rdllist);
-	write_unlock_irqrestore(&ep->lock, flags);
-
-	/* Build result set in userspace */
-	eventcnt = ep_send_events(ep, &txlist, events, maxevents);
-
-	up_read(&ep->sem);
-
-	return eventcnt;
-}
-
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
@@ -1093,6 +1102,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
+		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue(&ep->wq, &wait);
 
 		for (;;) {
@@ -1129,7 +1139,7 @@ retry:
 	 * more luck.
 	 */
 	if (!res && eavail &&
-	    !(res = ep_events_transfer(ep, events, maxevents)) && jtimeout)
+	    !(res = ep_send_events(ep, events, maxevents)) && jtimeout)
 		goto retry;
 
 	return res;
@@ -1237,7 +1247,7 @@ asmlinkage long sys_epoll_ctl(int epfd, 
 	 */
 	ep = file->private_data;
 
-	down_write(&ep->sem);
+	mutex_lock(&ep->mtx);
 
 	/* Try to lookup the file inside our RB tree */
 	epi = ep_find(ep, tfile, fd);
@@ -1272,7 +1282,7 @@ asmlinkage long sys_epoll_ctl(int epfd, 
 	 */
 	if (epi)
 		ep_release_epitem(epi);
-	up_write(&ep->sem);
+	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
 	fput(tfile);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
simplify-compat_sys_timerfd.patch
