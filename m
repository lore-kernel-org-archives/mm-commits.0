From: akpm@linux-foundation.org
Subject: + epoll-add-epollexclusive-flag.patch added to -mm tree
Date: Tue, 08 Dec 2015 14:05:57 -0800
Message-ID: <56675445.CjwXC52UWF27rFq2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbLHWF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, corbet@lwn.net, hagen@jauu.net, luto@amacapital.net, m@silodev.com, mingo@kernel.org, mtk.manpages@gmail.com, normalperson@yhbt.net, peterz@infradead.org, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: add EPOLLEXCLUSIVE flag
has been added to the -mm tree.  Its filename is
     epoll-add-epollexclusive-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-add-epollexclusive-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-add-epollexclusive-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: add EPOLLEXCLUSIVE flag

Currently, epoll file descriptors or epfds (the fd returned from
epoll_create[1]()) that are added to a shared wakeup source are always
added in a non-exclusive manner.  This means that when we have multiple
epfds attached to a shared fd source they are all woken up.  This creates
thundering herd type behavior.

Introduce a new 'EPOLLEXCLUSIVE' flag that can be passed as part of the
'event' argument during an epoll_ctl() EPOLL_CTL_ADD operation.  This new
flag allows for exclusive wakeups when there are multiple epfds attached
to a shared fd event source.

The implementation walks the list of exclusive waiters, and queues an
event to each epfd, until it finds the first waiter that has threads
blocked on it via epoll_wait().  The idea is to search for threads which
are idle and ready to process the wakeup events.  Thus, we queue an event
to at least 1 epfd, but may still potentially queue an event to all epfds
that are attached to the shared fd source.

Performance testing was done by Madars Vitolins using a modified version
of Enduro/X.  The use of the 'EPOLLEXCLUSIVE' flag reduce the length of
this particular workload from 860s down to 24s.

Sample epoll_clt text:

EPOLLEXCLUSIVE

  Sets an exclusive wakeup mode for the epfd file descriptor that is
  being attached to the target file descriptor, fd.  Thus, when an event
  occurs and multiple epfd file descriptors are attached to the same
  target file using EPOLLEXCLUSIVE, one or more epfds will receive an
  event with epoll_wait(2).  The default in this scenario (when
  EPOLLEXCLUSIVE is not set) is for all epfds to receive an event. 
  EPOLLEXCLUSIVE may only be specified with the op EPOLL_CTL_ADD.  

Signed-off-by: Jason Baron <jbaron@akamai.com>
Tested-by: Madars Vitolins <m@silodev.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c                 |   24 +++++++++++++++++++++---
 include/uapi/linux/eventpoll.h |    3 +++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN fs/eventpoll.c~epoll-add-epollexclusive-flag fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-add-epollexclusive-flag
+++ a/fs/eventpoll.c
@@ -92,7 +92,7 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET | EPOLLEXCLUSIVE)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -1002,6 +1002,7 @@ static int ep_poll_callback(wait_queue_t
 	unsigned long flags;
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
+	int ewake = 0;
 
 	if ((unsigned long)key & POLLFREE) {
 		ep_pwq_from_wait(wait)->whead = NULL;
@@ -1066,8 +1067,10 @@ static int ep_poll_callback(wait_queue_t
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 	 * wait list.
 	 */
-	if (waitqueue_active(&ep->wq))
+	if (waitqueue_active(&ep->wq)) {
+		ewake = 1;
 		wake_up_locked(&ep->wq);
+	}
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
@@ -1078,6 +1081,9 @@ out_unlock:
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
+	if (epi->event.events & EPOLLEXCLUSIVE)
+		return ewake;
+
 	return 1;
 }
 
@@ -1095,7 +1101,10 @@ static void ep_ptable_queue_proc(struct
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (epi->event.events & EPOLLEXCLUSIVE)
+			add_wait_queue_exclusive(whead, &pwq->wait);
+		else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
@@ -1862,6 +1871,15 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 		goto error_tgt_fput;
 
 	/*
+	 * epoll adds to the wakeup queue at EPOLL_CTL_ADD time only,
+	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
+	 * Also, we do not currently supported nested exclusive wakeups.
+	 */
+	if ((epds.events & EPOLLEXCLUSIVE) && (op == EPOLL_CTL_MOD ||
+		(op == EPOLL_CTL_ADD && is_file_epoll(tf.file))))
+		goto error_tgt_fput;
+
+	/*
 	 * At this point it is safe to assume that the "private_data" contains
 	 * our own data structure.
 	 */
diff -puN include/uapi/linux/eventpoll.h~epoll-add-epollexclusive-flag include/uapi/linux/eventpoll.h
--- a/include/uapi/linux/eventpoll.h~epoll-add-epollexclusive-flag
+++ a/include/uapi/linux/eventpoll.h
@@ -26,6 +26,9 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/* Set exclusive wakeup mode for the target file descriptor */
+#define EPOLLEXCLUSIVE (1 << 28)
+
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
  * from happening while those events are being processed.
_

Patches currently in -mm which might be from jbaron@akamai.com are

epoll-add-epollexclusive-flag.patch

