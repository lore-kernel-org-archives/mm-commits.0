From: akpm@linux-foundation.org
Subject: + epoll-remove-debugging-code.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:12:56 -0800
Message-ID: <200901290812.n0T8CueE029891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbZA2IQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:16:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     epoll: remove debugging code
has been added to the -mm tree.  Its filename is
     epoll-remove-debugging-code.patch

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
Subject: epoll: remove debugging code
From: Davide Libenzi <davidel@xmailserver.org>

Remove debugging code from epoll.  There's no need for it to be included
into mainline code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   60 +++--------------------------------------------
 1 file changed, 4 insertions(+), 56 deletions(-)

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
 
@@ -580,9 +562,6 @@ static int ep_remove(struct eventpoll *e
 
 	atomic_dec(&ep->user->epoll_watches);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p)\n",
-		     current, ep, file));
-
 	return 0;
 }
 
@@ -634,12 +613,9 @@ static void ep_free(struct eventpoll *ep
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
 {
-	struct eventpoll *ep = file->private_data;
-
-	if (ep)
-		ep_free(ep);
+	if (file->private_data)
+		ep_free((struct eventpoll *) file->private_data);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
 	return 0;
 }
 
@@ -764,8 +740,6 @@ static int ep_alloc(struct eventpoll **p
 
 	*pep = ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc() ep=%p\n",
-		     current, ep));
 	return 0;
 
 free_uid:
@@ -799,9 +773,6 @@ static struct epitem *ep_find(struct eve
 		}
 	}
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_find(%p) -> %p\n",
-		     current, file, epir));
-
 	return epir;
 }
 
@@ -817,9 +788,6 @@ static int ep_poll_callback(wait_queue_t
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
-		     current, epi->ffd.file, epi, ep));
-
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
@@ -991,9 +959,6 @@ static int ep_insert(struct eventpoll *e
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_insert(%p, %p, %d)\n",
-		     current, ep, tfile, fd));
-
 	return 0;
 
 error_unregister:
@@ -1213,9 +1178,6 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
-		     current, flags));
-
 	error = -EINVAL;
 	if (flags & ~EPOLL_CLOEXEC)
 		goto error_return;
@@ -1239,8 +1201,6 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 		atomic_inc(&ep->user->epoll_devs);
 
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, flags, error));
 
 	return error;
 }
@@ -1267,9 +1227,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	struct epitem *epi;
 	struct epoll_event epds;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
-		     current, epfd, op, fd, event));
-
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
@@ -1346,8 +1303,6 @@ error_tgt_fput:
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p) = %d\n",
-		     current, epfd, op, fd, event, error));
 
 	return error;
 }
@@ -1363,9 +1318,6 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
 	struct file *file;
 	struct eventpoll *ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
-		     current, epfd, events, maxevents, timeout));
-
 	/* The maximum number of event must be greater than zero */
 	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
 		return -EINVAL;
@@ -1402,8 +1354,6 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d) = %d\n",
-		     current, epfd, events, maxevents, timeout, error));
 
 	return error;
 }
@@ -1473,13 +1423,11 @@ static int __init eventpoll_init(void)
 
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

linux-next.patch
epoll-fix-own-poll.patch
epoll-remove-debugging-code.patch

