From: akpm@linux-foundation.org
Subject: [merged] epoll-remove-debugging-code.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:25 -0700
Message-ID: <200904011840.n31IeP3e009000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933068AbZDATGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: remove debugging code
has been removed from the -mm tree.  Its filename was
     epoll-remove-debugging-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: remove debugging code
From: Davide Libenzi <davidel@xmailserver.org>

Remove debugging code from epoll.  There's no need for it to be included
into mainline code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   78 ++++++-----------------------------------------
 1 file changed, 11 insertions(+), 67 deletions(-)

diff -puN fs/eventpoll.c~epoll-remove-debugging-code fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-remove-debugging-code
+++ a/fs/eventpoll.c
@@ -71,24 +71,6 @@
  * a better scalability.
  */
 
-#define DEBUG_EPOLL 0
-
-#if DEBUG_EPOLL > 0
-#define DPRINTK(x) printk x
-#define DNPRINTK(n, x) do { if ((n) <= DEBUG_EPOLL) printk x; } while (0)
-#else /* #if DEBUG_EPOLL > 0 */
-#define DPRINTK(x) (void) 0
-#define DNPRINTK(n, x) (void) 0
-#endif /* #if DEBUG_EPOLL > 0 */
-
-#define DEBUG_EPI 0
-
-#if DEBUG_EPI != 0
-#define EPI_SLAB_DEBUG (SLAB_DEBUG_FREE | SLAB_RED_ZONE /* | SLAB_POISON */)
-#else /* #if DEBUG_EPI != 0 */
-#define EPI_SLAB_DEBUG 0
-#endif /* #if DEBUG_EPI != 0 */
-
 /* Epoll private bits inside the event mask */
 #define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
 
@@ -567,9 +549,6 @@ static int ep_remove(struct eventpoll *e
 
 	atomic_dec(&ep->user->epoll_watches);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p)\n",
-		     current, ep, file));
-
 	return 0;
 }
 
@@ -625,7 +604,6 @@ static int ep_eventpoll_release(struct i
 	if (ep)
 		ep_free(ep);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
 	return 0;
 }
 
@@ -750,8 +728,6 @@ static int ep_alloc(struct eventpoll **p
 
 	*pep = ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc() ep=%p\n",
-		     current, ep));
 	return 0;
 
 free_uid:
@@ -785,9 +761,6 @@ static struct epitem *ep_find(struct eve
 		}
 	}
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_find(%p) -> %p\n",
-		     current, file, epir));
-
 	return epir;
 }
 
@@ -803,9 +776,6 @@ static int ep_poll_callback(wait_queue_t
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
-		     current, epi->ffd.file, epi, ep));
-
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
@@ -978,9 +948,6 @@ static int ep_insert(struct eventpoll *e
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_insert(%p, %p, %d)\n",
-		     current, ep, tfile, fd));
-
 	return 0;
 
 error_unregister:
@@ -1197,41 +1164,30 @@ retry:
  */
 SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
-	int error, fd = -1;
-	struct eventpoll *ep;
+	int error;
+	struct eventpoll *ep = NULL;
 
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
 	if (flags & ~EPOLL_CLOEXEC)
 		return -EINVAL;
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
-		     current, flags));
-
 	/*
-	 * Create the internal data structure ( "struct eventpoll" ).
+	 * Create the internal data structure ("struct eventpoll").
 	 */
 	error = ep_alloc(&ep);
-	if (error < 0) {
-		fd = error;
-		goto error_return;
-	}
-
+	if (error < 0)
+		return error;
 	/*
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
-			      flags & O_CLOEXEC);
-	if (fd < 0)
+	error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
+				 flags & O_CLOEXEC);
+	if (error < 0)
 		ep_free(ep);
 
-error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, flags, fd));
-
-	return fd;
+	return error;
 }
 
 SYSCALL_DEFINE1(epoll_create, int, size)
@@ -1256,9 +1212,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	struct epitem *epi;
 	struct epoll_event epds;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
-		     current, epfd, op, fd, event));
-
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
@@ -1335,8 +1288,6 @@ error_tgt_fput:
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p) = %d\n",
-		     current, epfd, op, fd, event, error));
 
 	return error;
 }
@@ -1352,9 +1303,6 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
 	struct file *file;
 	struct eventpoll *ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
-		     current, epfd, events, maxevents, timeout));
-
 	/* The maximum number of event must be greater than zero */
 	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
 		return -EINVAL;
@@ -1391,8 +1339,6 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d) = %d\n",
-		     current, epfd, events, maxevents, timeout, error));
 
 	return error;
 }
@@ -1464,13 +1410,11 @@ static int __init eventpoll_init(void)
 
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
-			0, SLAB_HWCACHE_ALIGN|EPI_SLAB_DEBUG|SLAB_PANIC,
-			NULL);
+			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
 	/* Allocates slab cache used to allocate "struct eppoll_entry" */
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
-			sizeof(struct eppoll_entry), 0,
-			EPI_SLAB_DEBUG|SLAB_PANIC, NULL);
+			sizeof(struct eppoll_entry), 0, SLAB_PANIC, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

