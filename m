From: akpm@linux-foundation.org
Subject: - epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:29 -0700
Message-ID: <200705120535.l4C5ZTES002297@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbXELFfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll cleanups: epoll remove static pre-declarations and akpm-ize the code
has been removed from the -mm tree.  Its filename was
     epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: epoll cleanups: epoll remove static pre-declarations and akpm-ize the code
From: Davide Libenzi <davidel@xmailserver.org>

Re-arrange epoll code to avoid static functions pre-declarations, and apply
akpm-filter on it.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c | 1060 ++++++++++++++++++++++-------------------------
 1 file changed, 499 insertions(+), 561 deletions(-)

diff -puN fs/eventpoll.c~epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code
+++ a/fs/eventpoll.c
@@ -41,7 +41,6 @@
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
 
-
 /*
  * LOCKING:
  * There are three level of locking required by epoll :
@@ -74,7 +73,6 @@
  * a greater scalability.
  */
 
-
 #define DEBUG_EPOLL 0
 
 #if DEBUG_EPOLL > 0
@@ -104,7 +102,6 @@
 
 #define EP_MAX_EVENTS (INT_MAX / sizeof(struct epoll_event))
 
-
 struct epoll_filefd {
 	struct file *file;
 	int fd;
@@ -222,36 +219,6 @@ struct ep_pqueue {
 	struct epitem *epi;
 };
 
-
-
-static void ep_poll_safewake_init(struct poll_safewake *psw);
-static void ep_poll_safewake(struct poll_safewake *psw, wait_queue_head_t *wq);
-static int ep_alloc(struct eventpoll **pep);
-static void ep_free(struct eventpoll *ep);
-static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd);
-static void ep_use_epitem(struct epitem *epi);
-static void ep_release_epitem(struct epitem *epi);
-static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
-				 poll_table *pt);
-static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi);
-static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
-		     struct file *tfile, int fd);
-static int ep_modify(struct eventpoll *ep, struct epitem *epi,
-		     struct epoll_event *event);
-static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi);
-static int ep_unlink(struct eventpoll *ep, struct epitem *epi);
-static int ep_remove(struct eventpoll *ep, struct epitem *epi);
-static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key);
-static int ep_eventpoll_close(struct inode *inode, struct file *file);
-static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait);
-static int ep_send_events(struct eventpoll *ep, struct list_head *txlist,
-			  struct epoll_event __user *events, int maxevents);
-static int ep_events_transfer(struct eventpoll *ep,
-			      struct epoll_event __user *events,
-			      int maxevents);
-static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
-		   int maxevents, long timeout);
-
 /*
  * This semaphore is used to serialize ep_free() and eventpoll_release_file().
  */
@@ -266,19 +233,6 @@ static struct kmem_cache *epi_cache __re
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
-/* File callbacks that implement the eventpoll file behaviour */
-static const struct file_operations eventpoll_fops = {
-	.release	= ep_eventpoll_close,
-	.poll		= ep_eventpoll_poll
-};
-
-
-
-/* Fast test to see if the file is an evenpoll file */
-static inline int is_file_epoll(struct file *f)
-{
-	return f->f_op == &eventpoll_fops;
-}
 
 /* Setup the structure that is used as key for the rb-tree */
 static inline void ep_set_ffd(struct epoll_filefd *ffd,
@@ -347,7 +301,6 @@ static void ep_poll_safewake_init(struct
 	spin_lock_init(&psw->lock);
 }
 
-
 /*
  * Perform a safe wake up of the poll wait list. The problem is that
  * with the new callback'd wake up system, it is possible that the
@@ -402,303 +355,265 @@ static void ep_poll_safewake(struct poll
 	spin_unlock_irqrestore(&psw->lock, flags);
 }
 
-
 /*
- * This is called from eventpoll_release() to unlink files from the eventpoll
- * interface. We need to have this facility to cleanup correctly files that are
- * closed without being removed from the eventpoll interface.
+ * This function unregister poll callbacks from the associated file descriptor.
+ * Since this must be called without holding "ep->lock" the atomic exchange trick
+ * will protect us from multiple unregister.
  */
-void eventpoll_release_file(struct file *file)
+static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 {
-	struct list_head *lsthead = &file->f_ep_links;
-	struct eventpoll *ep;
-	struct epitem *epi;
+	int nwait;
+	struct list_head *lsthead = &epi->pwqlist;
+	struct eppoll_entry *pwq;
 
-	/*
-	 * We don't want to get "file->f_ep_lock" because it is not
-	 * necessary. It is not necessary because we're in the "struct file"
-	 * cleanup path, and this means that noone is using this file anymore.
-	 * The only hit might come from ep_free() but by holding the semaphore
-	 * will correctly serialize the operation. We do need to acquire
-	 * "ep->sem" after "epmutex" because ep_remove() requires it when called
-	 * from anywhere but ep_free().
-	 */
-	mutex_lock(&epmutex);
+	/* This is called without locks, so we need the atomic exchange */
+	nwait = xchg(&epi->nwait, 0);
 
-	while (!list_empty(lsthead)) {
-		epi = list_first_entry(lsthead, struct epitem, fllink);
+	if (nwait) {
+		while (!list_empty(lsthead)) {
+			pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
-		ep = epi->ep;
-		list_del_init(&epi->fllink);
-		down_write(&ep->sem);
-		ep_remove(ep, epi);
-		up_write(&ep->sem);
+			list_del_init(&pwq->llink);
+			remove_wait_queue(pwq->whead, &pwq->wait);
+			kmem_cache_free(pwq_cache, pwq);
+		}
 	}
-
-	mutex_unlock(&epmutex);
 }
 
-
 /*
- * It opens an eventpoll file descriptor by suggesting a storage of "size"
- * file descriptors. The size parameter is just an hint about how to size
- * data structures. It won't prevent the user to store more than "size"
- * file descriptors inside the epoll interface. It is the kernel part of
- * the userspace epoll_create(2).
+ * Unlink the "struct epitem" from all places it might have been hooked up.
+ * This function must be called with write IRQ lock on "ep->lock".
  */
-asmlinkage long sys_epoll_create(int size)
+static int ep_unlink(struct eventpoll *ep, struct epitem *epi)
 {
-	int error, fd = -1;
-	struct eventpoll *ep;
-	struct inode *inode;
-	struct file *file;
+	int error;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
-		     current, size));
+	/*
+	 * It can happen that this one is called for an item already unlinked.
+	 * The check protect us from doing a double unlink ( crash ).
+	 */
+	error = -ENOENT;
+	if (!ep_rb_linked(&epi->rbn))
+		goto error_return;
 
 	/*
-	 * Sanity check on the size parameter, and create the internal data
-	 * structure ( "struct eventpoll" ).
+	 * Clear the event mask for the unlinked item. This will avoid item
+	 * notifications to be sent after the unlink operation from inside
+	 * the kernel->userspace event transfer loop.
 	 */
-	error = -EINVAL;
-	if (size <= 0 || (error = ep_alloc(&ep)) != 0)
-		goto eexit_1;
+	epi->event.events = 0;
 
 	/*
-	 * Creates all the items needed to setup an eventpoll file. That is,
-	 * a file structure, and inode and a free file descriptor.
+	 * At this point is safe to do the job, unlink the item from our rb-tree.
+	 * This operation togheter with the above check closes the door to
+	 * double unlinks.
 	 */
-	error = anon_inode_getfd(&fd, &inode, &file, "[eventpoll]",
-				 &eventpoll_fops, ep);
-	if (error)
-		goto eexit_2;
+	ep_rb_erase(&epi->rbn, &ep->rbr);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, size, fd));
+	/*
+	 * If the item we are going to remove is inside the ready file descriptors
+	 * we want to remove it from this list to avoid stale events.
+	 */
+	if (ep_is_linked(&epi->rdllink))
+		list_del_init(&epi->rdllink);
 
-	return fd;
+	error = 0;
+error_return:
+
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_unlink(%p, %p) = %d\n",
+		     current, ep, epi->ffd.file, error));
 
-eexit_2:
-	ep_free(ep);
-	kfree(ep);
-eexit_1:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, size, error));
 	return error;
 }
 
-
 /*
- * The following function implements the controller interface for
- * the eventpoll file that enables the insertion/removal/change of
- * file descriptors inside the interest set.  It represents
- * the kernel part of the user space epoll_ctl(2).
+ * Increment the usage count of the "struct epitem" making it sure
+ * that the user will have a valid pointer to reference.
  */
-asmlinkage long
-sys_epoll_ctl(int epfd, int op, int fd, struct epoll_event __user *event)
+static void ep_use_epitem(struct epitem *epi)
 {
-	int error;
-	struct file *file, *tfile;
-	struct eventpoll *ep;
-	struct epitem *epi;
-	struct epoll_event epds;
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
-		     current, epfd, op, fd, event));
-
-	error = -EFAULT;
-	if (ep_op_has_event(op) &&
-	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
-		goto eexit_1;
-
-	/* Get the "struct file *" for the eventpoll file */
-	error = -EBADF;
-	file = fget(epfd);
-	if (!file)
-		goto eexit_1;
-
-	/* Get the "struct file *" for the target file */
-	tfile = fget(fd);
-	if (!tfile)
-		goto eexit_2;
+	atomic_inc(&epi->usecnt);
+}
 
-	/* The target file descriptor must support poll */
-	error = -EPERM;
-	if (!tfile->f_op || !tfile->f_op->poll)
-		goto eexit_3;
+/*
+ * Decrement ( release ) the usage count by signaling that the user
+ * has finished using the structure. It might lead to freeing the
+ * structure itself if the count goes to zero.
+ */
+static void ep_release_epitem(struct epitem *epi)
+{
+	if (atomic_dec_and_test(&epi->usecnt))
+		kmem_cache_free(epi_cache, epi);
+}
 
-	/*
-	 * We have to check that the file structure underneath the file descriptor
-	 * the user passed to us _is_ an eventpoll file. And also we do not permit
-	 * adding an epoll file descriptor inside itself.
-	 */
-	error = -EINVAL;
-	if (file == tfile || !is_file_epoll(file))
-		goto eexit_3;
+/*
+ * Removes a "struct epitem" from the eventpoll RB tree and deallocates
+ * all the associated resources.
+ */
+static int ep_remove(struct eventpoll *ep, struct epitem *epi)
+{
+	int error;
+	unsigned long flags;
+	struct file *file = epi->ffd.file;
 
 	/*
-	 * At this point it is safe to assume that the "private_data" contains
-	 * our own data structure.
+	 * Removes poll wait queue hooks. We _have_ to do this without holding
+	 * the "ep->lock" otherwise a deadlock might occur. This because of the
+	 * sequence of the lock acquisition. Here we do "ep->lock" then the wait
+	 * queue head lock when unregistering the wait queue. The wakeup callback
+	 * will run by holding the wait queue head lock and will call our callback
+	 * that will try to get "ep->lock".
 	 */
-	ep = file->private_data;
+	ep_unregister_pollwait(ep, epi);
 
-	down_write(&ep->sem);
+	/* Remove the current item from the list of epoll hooks */
+	spin_lock(&file->f_ep_lock);
+	if (ep_is_linked(&epi->fllink))
+		list_del_init(&epi->fllink);
+	spin_unlock(&file->f_ep_lock);
 
-	/* Try to lookup the file inside our RB tree */
-	epi = ep_find(ep, tfile, fd);
+	/* We need to acquire the write IRQ lock before calling ep_unlink() */
+	write_lock_irqsave(&ep->lock, flags);
 
-	error = -EINVAL;
-	switch (op) {
-	case EPOLL_CTL_ADD:
-		if (!epi) {
-			epds.events |= POLLERR | POLLHUP;
+	/* Really unlink the item from the RB tree */
+	error = ep_unlink(ep, epi);
 
-			error = ep_insert(ep, &epds, tfile, fd);
-		} else
-			error = -EEXIST;
-		break;
-	case EPOLL_CTL_DEL:
-		if (epi)
-			error = ep_remove(ep, epi);
-		else
-			error = -ENOENT;
-		break;
-	case EPOLL_CTL_MOD:
-		if (epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_modify(ep, epi, &epds);
-		} else
-			error = -ENOENT;
-		break;
-	}
+	write_unlock_irqrestore(&ep->lock, flags);
 
-	/*
-	 * The function ep_find() increments the usage count of the structure
-	 * so, if this is not NULL, we need to release it.
-	 */
-	if (epi)
-		ep_release_epitem(epi);
+	if (error)
+		goto error_return;
 
-	up_write(&ep->sem);
+	/* At this point it is safe to free the eventpoll item */
+	ep_release_epitem(epi);
 
-eexit_3:
-	fput(tfile);
-eexit_2:
-	fput(file);
-eexit_1:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p) = %d\n",
-		     current, epfd, op, fd, event, error));
+	error = 0;
+error_return:
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p) = %d\n",
+		     current, ep, file, error));
 
 	return error;
 }
 
-
-/*
- * Implement the event wait interface for the eventpoll file. It is the kernel
- * part of the user space epoll_wait(2).
- */
-asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
-			       int maxevents, int timeout)
+static void ep_free(struct eventpoll *ep)
 {
-	int error;
-	struct file *file;
-	struct eventpoll *ep;
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
-		     current, epfd, events, maxevents, timeout));
-
-	/* The maximum number of event must be greater than zero */
-	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
-		return -EINVAL;
+	struct rb_node *rbp;
+	struct epitem *epi;
 
-	/* Verify that the area passed by the user is writeable */
-	if (!access_ok(VERIFY_WRITE, events, maxevents * sizeof(struct epoll_event))) {
-		error = -EFAULT;
-		goto eexit_1;
-	}
+	/* We need to release all tasks waiting for these file */
+	if (waitqueue_active(&ep->poll_wait))
+		ep_poll_safewake(&psw, &ep->poll_wait);
 
-	/* Get the "struct file *" for the eventpoll file */
-	error = -EBADF;
-	file = fget(epfd);
-	if (!file)
-		goto eexit_1;
+	/*
+	 * We need to lock this because we could be hit by
+	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
+	 * We do not need to hold "ep->sem" here because the epoll file
+	 * is on the way to be removed and no one has references to it
+	 * anymore. The only hit might come from eventpoll_release_file() but
+	 * holding "epmutex" is sufficent here.
+	 */
+	mutex_lock(&epmutex);
 
 	/*
-	 * We have to check that the file structure underneath the fd
-	 * the user passed to us _is_ an eventpoll file.
+	 * Walks through the whole tree by unregistering poll callbacks.
 	 */
-	error = -EINVAL;
-	if (!is_file_epoll(file))
-		goto eexit_2;
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		epi = rb_entry(rbp, struct epitem, rbn);
+
+		ep_unregister_pollwait(ep, epi);
+	}
 
 	/*
-	 * At this point it is safe to assume that the "private_data" contains
-	 * our own data structure.
+	 * Walks through the whole tree by freeing each "struct epitem". At this
+	 * point we are sure no poll callbacks will be lingering around, and also by
+	 * write-holding "sem" we can be sure that no file cleanup code will hit
+	 * us during this operation. So we can avoid the lock on "ep->lock".
 	 */
-	ep = file->private_data;
+	while ((rbp = rb_first(&ep->rbr)) != 0) {
+		epi = rb_entry(rbp, struct epitem, rbn);
+		ep_remove(ep, epi);
+	}
 
-	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	mutex_unlock(&epmutex);
+}
 
-eexit_2:
-	fput(file);
-eexit_1:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d) = %d\n",
-		     current, epfd, events, maxevents, timeout, error));
+static int ep_eventpoll_release(struct inode *inode, struct file *file)
+{
+	struct eventpoll *ep = file->private_data;
 
-	return error;
+	if (ep) {
+		ep_free(ep);
+		kfree(ep);
+	}
+
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
+	return 0;
 }
 
+static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
+{
+	unsigned int pollflags = 0;
+	unsigned long flags;
+	struct eventpoll *ep = file->private_data;
 
-#ifdef TIF_RESTORE_SIGMASK
+	/* Insert inside our poll wait queue */
+	poll_wait(file, &ep->poll_wait, wait);
+
+	/* Check our condition */
+	read_lock_irqsave(&ep->lock, flags);
+	if (!list_empty(&ep->rdllist))
+		pollflags = POLLIN | POLLRDNORM;
+	read_unlock_irqrestore(&ep->lock, flags);
+
+	return pollflags;
+}
+
+/* File callbacks that implement the eventpoll file behaviour */
+static const struct file_operations eventpoll_fops = {
+	.release	= ep_eventpoll_release,
+	.poll		= ep_eventpoll_poll
+};
+
+/* Fast test to see if the file is an evenpoll file */
+static inline int is_file_epoll(struct file *f)
+{
+	return f->f_op == &eventpoll_fops;
+}
 
 /*
- * Implement the event wait interface for the eventpoll file. It is the kernel
- * part of the user space epoll_pwait(2).
+ * This is called from eventpoll_release() to unlink files from the eventpoll
+ * interface. We need to have this facility to cleanup correctly files that are
+ * closed without being removed from the eventpoll interface.
  */
-asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
-		int maxevents, int timeout, const sigset_t __user *sigmask,
-		size_t sigsetsize)
+void eventpoll_release_file(struct file *file)
 {
-	int error;
-	sigset_t ksigmask, sigsaved;
+	struct list_head *lsthead = &file->f_ep_links;
+	struct eventpoll *ep;
+	struct epitem *epi;
 
 	/*
-	 * If the caller wants a certain signal mask to be set during the wait,
-	 * we apply it here.
+	 * We don't want to get "file->f_ep_lock" because it is not
+	 * necessary. It is not necessary because we're in the "struct file"
+	 * cleanup path, and this means that noone is using this file anymore.
+	 * The only hit might come from ep_free() but by holding the semaphore
+	 * will correctly serialize the operation. We do need to acquire
+	 * "ep->sem" after "epmutex" because ep_remove() requires it when called
+	 * from anywhere but ep_free().
 	 */
-	if (sigmask) {
-		if (sigsetsize != sizeof(sigset_t))
-			return -EINVAL;
-		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
-			return -EFAULT;
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
-	}
+	mutex_lock(&epmutex);
 
-	error = sys_epoll_wait(epfd, events, maxevents, timeout);
+	while (!list_empty(lsthead)) {
+		epi = list_first_entry(lsthead, struct epitem, fllink);
 
-	/*
-	 * If we changed the signal mask, we need to restore the original one.
-	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on
-	 * the way back to userspace, before the signal mask is restored.
-	 */
-	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-				sizeof(sigsaved));
-			set_thread_flag(TIF_RESTORE_SIGMASK);
-		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+		ep = epi->ep;
+		list_del_init(&epi->fllink);
+		down_write(&ep->sem);
+		ep_remove(ep, epi);
+		up_write(&ep->sem);
 	}
 
-	return error;
+	mutex_unlock(&epmutex);
 }
 
-#endif /* #ifdef TIF_RESTORE_SIGMASK */
-
-
 static int ep_alloc(struct eventpoll **pep)
 {
 	struct eventpoll *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -720,50 +635,6 @@ static int ep_alloc(struct eventpoll **p
 	return 0;
 }
 
-
-static void ep_free(struct eventpoll *ep)
-{
-	struct rb_node *rbp;
-	struct epitem *epi;
-
-	/* We need to release all tasks waiting for these file */
-	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(&psw, &ep->poll_wait);
-
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
-	 * We do not need to hold "ep->sem" here because the epoll file
-	 * is on the way to be removed and no one has references to it
-	 * anymore. The only hit might come from eventpoll_release_file() but
-	 * holding "epmutex" is sufficent here.
-	 */
-	mutex_lock(&epmutex);
-
-	/*
-	 * Walks through the whole tree by unregistering poll callbacks.
-	 */
-	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
-		epi = rb_entry(rbp, struct epitem, rbn);
-
-		ep_unregister_pollwait(ep, epi);
-	}
-
-	/*
-	 * Walks through the whole tree by freeing each "struct epitem". At this
-	 * point we are sure no poll callbacks will be lingering around, and also by
-	 * write-holding "sem" we can be sure that no file cleanup code will hit
-	 * us during this operation. So we can avoid the lock on "ep->lock".
-	 */
-	while ((rbp = rb_first(&ep->rbr)) != 0) {
-		epi = rb_entry(rbp, struct epitem, rbn);
-		ep_remove(ep, epi);
-	}
-
-	mutex_unlock(&epmutex);
-}
-
-
 /*
  * Search the file inside the eventpoll tree. It add usage count to
  * the returned item, so the caller must call ep_release_epitem()
@@ -800,30 +671,58 @@ static struct epitem *ep_find(struct eve
 	return epir;
 }
 
-
 /*
- * Increment the usage count of the "struct epitem" making it sure
- * that the user will have a valid pointer to reference.
+ * This is the callback that is passed to the wait queue wakeup
+ * machanism. It is called by the stored file descriptors when they
+ * have events to report.
  */
-static void ep_use_epitem(struct epitem *epi)
+static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
+	int pwake = 0;
+	unsigned long flags;
+	struct epitem *epi = ep_item_from_wait(wait);
+	struct eventpoll *ep = epi->ep;
 
-	atomic_inc(&epi->usecnt);
-}
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
+		     current, epi->ffd.file, epi, ep));
 
+	write_lock_irqsave(&ep->lock, flags);
 
-/*
- * Decrement ( release ) the usage count by signaling that the user
- * has finished using the structure. It might lead to freeing the
- * structure itself if the count goes to zero.
- */
-static void ep_release_epitem(struct epitem *epi)
-{
+	/*
+	 * If the event mask does not contain any poll(2) event, we consider the
+	 * descriptor to be disabled. This condition is likely the effect of the
+	 * EPOLLONESHOT bit that disables the descriptor when an event is received,
+	 * until the next EPOLL_CTL_MOD will be issued.
+	 */
+	if (!(epi->event.events & ~EP_PRIVATE_BITS))
+		goto is_disabled;
 
-	if (atomic_dec_and_test(&epi->usecnt))
-		kmem_cache_free(epi_cache, epi);
-}
+	/* If this file is already in the ready list we exit soon */
+	if (ep_is_linked(&epi->rdllink))
+		goto is_linked;
+
+	list_add_tail(&epi->rdllink, &ep->rdllist);
+
+is_linked:
+	/*
+	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
+	 * wait list.
+	 */
+	if (waitqueue_active(&ep->wq))
+		__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
+				 TASK_INTERRUPTIBLE);
+	if (waitqueue_active(&ep->poll_wait))
+		pwake++;
+
+is_disabled:
+	write_unlock_irqrestore(&ep->lock, flags);
 
+	/* We have to call this outside the lock */
+	if (pwake)
+		ep_poll_safewake(&psw, &ep->poll_wait);
+
+	return 1;
+}
 
 /*
  * This is the callback that is used to add our wait queue to the
@@ -848,7 +747,6 @@ static void ep_ptable_queue_proc(struct 
 	}
 }
 
-
 static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
 {
 	int kcmp;
@@ -868,7 +766,6 @@ static void ep_rbtree_insert(struct even
 	rb_insert_color(&epi->rbn, &ep->rbr);
 }
 
-
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		     struct file *tfile, int fd)
 {
@@ -879,7 +776,7 @@ static int ep_insert(struct eventpoll *e
 
 	error = -ENOMEM;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
-		goto eexit_1;
+		goto error_return;
 
 	/* Item initialization follow here ... */
 	ep_rb_initnode(&epi->rbn);
@@ -909,7 +806,7 @@ static int ep_insert(struct eventpoll *e
 	 * high memory pressure.
 	 */
 	if (epi->nwait < 0)
-		goto eexit_2;
+		goto error_unregister;
 
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_ep_lock);
@@ -944,7 +841,7 @@ static int ep_insert(struct eventpoll *e
 
 	return 0;
 
-eexit_2:
+error_unregister:
 	ep_unregister_pollwait(ep, epi);
 
 	/*
@@ -957,11 +854,10 @@ eexit_2:
 	write_unlock_irqrestore(&ep->lock, flags);
 
 	kmem_cache_free(epi_cache, epi);
-eexit_1:
+error_return:
 	return error;
 }
 
-
 /*
  * Modify the interest event mask by dropping an event if the new mask
  * has a match in the current file status.
@@ -1009,231 +905,21 @@ static int ep_modify(struct eventpoll *e
 				if (waitqueue_active(&ep->wq))
 					__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
 							 TASK_INTERRUPTIBLE);
-				if (waitqueue_active(&ep->poll_wait))
-					pwake++;
-			}
-		}
-	}
-
-	write_unlock_irqrestore(&ep->lock, flags);
-
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
-
-	return 0;
-}
-
-
-/*
- * This function unregister poll callbacks from the associated file descriptor.
- * Since this must be called without holding "ep->lock" the atomic exchange trick
- * will protect us from multiple unregister.
- */
-static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
-{
-	int nwait;
-	struct list_head *lsthead = &epi->pwqlist;
-	struct eppoll_entry *pwq;
-
-	/* This is called without locks, so we need the atomic exchange */
-	nwait = xchg(&epi->nwait, 0);
-
-	if (nwait) {
-		while (!list_empty(lsthead)) {
-			pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
-
-			list_del_init(&pwq->llink);
-			remove_wait_queue(pwq->whead, &pwq->wait);
-			kmem_cache_free(pwq_cache, pwq);
-		}
-	}
-}
-
-
-/*
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
-		goto eexit_1;
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
-eexit_1:
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_unlink(%p, %p) = %d\n",
-		     current, ep, epi->ffd.file, error));
-
-	return error;
-}
-
-
-/*
- * Removes a "struct epitem" from the eventpoll RB tree and deallocates
- * all the associated resources.
- */
-static int ep_remove(struct eventpoll *ep, struct epitem *epi)
-{
-	int error;
-	unsigned long flags;
-	struct file *file = epi->ffd.file;
-
-	/*
-	 * Removes poll wait queue hooks. We _have_ to do this without holding
-	 * the "ep->lock" otherwise a deadlock might occur. This because of the
-	 * sequence of the lock acquisition. Here we do "ep->lock" then the wait
-	 * queue head lock when unregistering the wait queue. The wakeup callback
-	 * will run by holding the wait queue head lock and will call our callback
-	 * that will try to get "ep->lock".
-	 */
-	ep_unregister_pollwait(ep, epi);
-
-	/* Remove the current item from the list of epoll hooks */
-	spin_lock(&file->f_ep_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
-	spin_unlock(&file->f_ep_lock);
-
-	/* We need to acquire the write IRQ lock before calling ep_unlink() */
-	write_lock_irqsave(&ep->lock, flags);
-
-	/* Really unlink the item from the RB tree */
-	error = ep_unlink(ep, epi);
-
-	write_unlock_irqrestore(&ep->lock, flags);
-
-	if (error)
-		goto eexit_1;
-
-	/* At this point it is safe to free the eventpoll item */
-	ep_release_epitem(epi);
-
-	error = 0;
-eexit_1:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p) = %d\n",
-		     current, ep, file, error));
-
-	return error;
-}
-
-
-/*
- * This is the callback that is passed to the wait queue wakeup
- * machanism. It is called by the stored file descriptors when they
- * have events to report.
- */
-static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key)
-{
-	int pwake = 0;
-	unsigned long flags;
-	struct epitem *epi = ep_item_from_wait(wait);
-	struct eventpoll *ep = epi->ep;
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
-		     current, epi->ffd.file, epi, ep));
-
-	write_lock_irqsave(&ep->lock, flags);
-
-	/*
-	 * If the event mask does not contain any poll(2) event, we consider the
-	 * descriptor to be disabled. This condition is likely the effect of the
-	 * EPOLLONESHOT bit that disables the descriptor when an event is received,
-	 * until the next EPOLL_CTL_MOD will be issued.
-	 */
-	if (!(epi->event.events & ~EP_PRIVATE_BITS))
-		goto is_disabled;
-
-	/* If this file is already in the ready list we exit soon */
-	if (ep_is_linked(&epi->rdllink))
-		goto is_linked;
-
-	list_add_tail(&epi->rdllink, &ep->rdllist);
-
-is_linked:
-	/*
-	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
-	 * wait list.
-	 */
-	if (waitqueue_active(&ep->wq))
-		__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
-				 TASK_INTERRUPTIBLE);
-	if (waitqueue_active(&ep->poll_wait))
-		pwake++;
-
-is_disabled:
-	write_unlock_irqrestore(&ep->lock, flags);
-
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&psw, &ep->poll_wait);
-
-	return 1;
-}
-
-
-static int ep_eventpoll_close(struct inode *inode, struct file *file)
-{
-	struct eventpoll *ep = file->private_data;
-
-	if (ep) {
-		ep_free(ep);
-		kfree(ep);
-	}
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
-	return 0;
-}
-
-
-static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
-{
-	unsigned int pollflags = 0;
-	unsigned long flags;
-	struct eventpoll *ep = file->private_data;
+				if (waitqueue_active(&ep->poll_wait))
+					pwake++;
+			}
+		}
+	}
 
-	/* Insert inside our poll wait queue */
-	poll_wait(file, &ep->poll_wait, wait);
+	write_unlock_irqrestore(&ep->lock, flags);
 
-	/* Check our condition */
-	read_lock_irqsave(&ep->lock, flags);
-	if (!list_empty(&ep->rdllist))
-		pollflags = POLLIN | POLLRDNORM;
-	read_unlock_irqrestore(&ep->lock, flags);
+	/* We have to call this outside the lock */
+	if (pwake)
+		ep_poll_safewake(&psw, &ep->poll_wait);
 
-	return pollflags;
+	return 0;
 }
 
-
 /*
  * This function is called without holding the "ep->lock" since the call to
  * __copy_to_user() might sleep, and also f_op->poll() might reenable the IRQ
@@ -1345,7 +1031,6 @@ static int ep_send_events(struct eventpo
 	return eventcnt == 0 ? error: eventcnt;
 }
 
-
 /*
  * Perform the transfer of events to user space.
  */
@@ -1381,7 +1066,6 @@ static int ep_events_transfer(struct eve
 	return eventcnt;
 }
 
-
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
@@ -1451,6 +1135,260 @@ retry:
 	return res;
 }
 
+/*
+ * It opens an eventpoll file descriptor by suggesting a storage of "size"
+ * file descriptors. The size parameter is just an hint about how to size
+ * data structures. It won't prevent the user to store more than "size"
+ * file descriptors inside the epoll interface. It is the kernel part of
+ * the userspace epoll_create(2).
+ */
+asmlinkage long sys_epoll_create(int size)
+{
+	int error, fd = -1;
+	struct eventpoll *ep;
+	struct inode *inode;
+	struct file *file;
+
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
+		     current, size));
+
+	/*
+	 * Sanity check on the size parameter, and create the internal data
+	 * structure ( "struct eventpoll" ).
+	 */
+	error = -EINVAL;
+	if (size <= 0 || (error = ep_alloc(&ep)) != 0)
+		goto error_return;
+
+	/*
+	 * Creates all the items needed to setup an eventpoll file. That is,
+	 * a file structure, and inode and a free file descriptor.
+	 */
+	error = anon_inode_getfd(&fd, &inode, &file, "[eventpoll]",
+				 &eventpoll_fops, ep);
+	if (error)
+		goto error_free;
+
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
+		     current, size, fd));
+
+	return fd;
+
+error_free:
+	ep_free(ep);
+	kfree(ep);
+error_return:
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
+		     current, size, error));
+	return error;
+}
+
+/*
+ * The following function implements the controller interface for
+ * the eventpoll file that enables the insertion/removal/change of
+ * file descriptors inside the interest set.  It represents
+ * the kernel part of the user space epoll_ctl(2).
+ */
+asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
+			      struct epoll_event __user *event)
+{
+	int error;
+	struct file *file, *tfile;
+	struct eventpoll *ep;
+	struct epitem *epi;
+	struct epoll_event epds;
+
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
+		     current, epfd, op, fd, event));
+
+	error = -EFAULT;
+	if (ep_op_has_event(op) &&
+	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
+		goto error_return;
+
+	/* Get the "struct file *" for the eventpoll file */
+	error = -EBADF;
+	file = fget(epfd);
+	if (!file)
+		goto error_return;
+
+	/* Get the "struct file *" for the target file */
+	tfile = fget(fd);
+	if (!tfile)
+		goto error_fput;
+
+	/* The target file descriptor must support poll */
+	error = -EPERM;
+	if (!tfile->f_op || !tfile->f_op->poll)
+		goto error_tgt_fput;
+
+	/*
+	 * We have to check that the file structure underneath the file descriptor
+	 * the user passed to us _is_ an eventpoll file. And also we do not permit
+	 * adding an epoll file descriptor inside itself.
+	 */
+	error = -EINVAL;
+	if (file == tfile || !is_file_epoll(file))
+		goto error_tgt_fput;
+
+	/*
+	 * At this point it is safe to assume that the "private_data" contains
+	 * our own data structure.
+	 */
+	ep = file->private_data;
+
+	down_write(&ep->sem);
+
+	/* Try to lookup the file inside our RB tree */
+	epi = ep_find(ep, tfile, fd);
+
+	error = -EINVAL;
+	switch (op) {
+	case EPOLL_CTL_ADD:
+		if (!epi) {
+			epds.events |= POLLERR | POLLHUP;
+
+			error = ep_insert(ep, &epds, tfile, fd);
+		} else
+			error = -EEXIST;
+		break;
+	case EPOLL_CTL_DEL:
+		if (epi)
+			error = ep_remove(ep, epi);
+		else
+			error = -ENOENT;
+		break;
+	case EPOLL_CTL_MOD:
+		if (epi) {
+			epds.events |= POLLERR | POLLHUP;
+			error = ep_modify(ep, epi, &epds);
+		} else
+			error = -ENOENT;
+		break;
+	}
+	/*
+	 * The function ep_find() increments the usage count of the structure
+	 * so, if this is not NULL, we need to release it.
+	 */
+	if (epi)
+		ep_release_epitem(epi);
+	up_write(&ep->sem);
+
+error_tgt_fput:
+	fput(tfile);
+error_fput:
+	fput(file);
+error_return:
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p) = %d\n",
+		     current, epfd, op, fd, event, error));
+
+	return error;
+}
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_wait(2).
+ */
+asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
+			       int maxevents, int timeout)
+{
+	int error;
+	struct file *file;
+	struct eventpoll *ep;
+
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
+		     current, epfd, events, maxevents, timeout));
+
+	/* The maximum number of event must be greater than zero */
+	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
+		return -EINVAL;
+
+	/* Verify that the area passed by the user is writeable */
+	if (!access_ok(VERIFY_WRITE, events, maxevents * sizeof(struct epoll_event))) {
+		error = -EFAULT;
+		goto error_return;
+	}
+
+	/* Get the "struct file *" for the eventpoll file */
+	error = -EBADF;
+	file = fget(epfd);
+	if (!file)
+		goto error_return;
+
+	/*
+	 * We have to check that the file structure underneath the fd
+	 * the user passed to us _is_ an eventpoll file.
+	 */
+	error = -EINVAL;
+	if (!is_file_epoll(file))
+		goto error_fput;
+
+	/*
+	 * At this point it is safe to assume that the "private_data" contains
+	 * our own data structure.
+	 */
+	ep = file->private_data;
+
+	/* Time to fish for events ... */
+	error = ep_poll(ep, events, maxevents, timeout);
+
+error_fput:
+	fput(file);
+error_return:
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d) = %d\n",
+		     current, epfd, events, maxevents, timeout, error));
+
+	return error;
+}
+
+#ifdef TIF_RESTORE_SIGMASK
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_pwait(2).
+ */
+asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
+		int maxevents, int timeout, const sigset_t __user *sigmask,
+		size_t sigsetsize)
+{
+	int error;
+	sigset_t ksigmask, sigsaved;
+
+	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	if (sigmask) {
+		if (sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+			return -EFAULT;
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
+
+	error = sys_epoll_wait(epfd, events, maxevents, timeout);
+
+	/*
+	 * If we changed the signal mask, we need to restore the original one.
+	 * In case we've got a signal while waiting, we do not restore the
+	 * signal mask yet, and we allow do_signal() to deliver the signal on
+	 * the way back to userspace, before the signal mask is restored.
+	 */
+	if (sigmask) {
+		if (error == -EINTR) {
+			memcpy(&current->saved_sigmask, &sigsaved,
+				sizeof(sigsaved));
+			set_thread_flag(TIF_RESTORE_SIGMASK);
+		} else
+			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+	}
+
+	return error;
+}
+
+#endif /* #ifdef TIF_RESTORE_SIGMASK */
+
 static int __init eventpoll_init(void)
 {
 	mutex_init(&epmutex);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
