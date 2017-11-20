From: akpm@linux-foundation.org
Subject: [merged]
 epoll-remove-ep_call_nested-from-ep_eventpoll_poll.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:25:00 -0800
Message-ID: <20171120212500.apMLMFV3_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbdKTVZB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, houtao1@huawei.com, jbaron@akamai.com, mm-commits@vger.kernel.org, sqazi@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: epoll: remove ep_call_nested() from ep_eventpoll_poll()
has been removed from the -mm tree.  Its filename was
     epoll-remove-ep_call_nested-from-ep_eventpoll_poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: remove ep_call_nested() from ep_eventpoll_poll()

The use of ep_call_nested() in ep_eventpoll_poll(), which is the .poll
routine for an epoll fd, is used to prevent excessively deep epoll
nesting, and to prevent circular paths.

However, we are already preventing these conditions during EPOLL_CTL_ADD. 
In terms of too deep epoll chains, we do in fact allow deep nesting of the
epoll fds themselves (deeper than EP_MAX_NESTS), however we don't allow
more than EP_MAX_NESTS when an epoll file descriptor is actually connected
to a wakeup source.  Thus, we do not require the use of ep_call_nested(),
since ep_eventpoll_poll(), which is called via ep_scan_ready_list() only
continues nesting if there are events available.

Since ep_call_nested() is implemented using a global lock, applications
that make use of nested epoll can see large performance improvements with
this change.

Davidlohr said:

: Improvements are quite obscene actually, such as for the following
: epoll_wait() benchmark with 2 level nesting on a 80 core IvyBridge:
: 
: ncpus  vanilla     dirty     delta
: 1      2447092     3028315   +23.75%
: 4      231265      2986954   +1191.57%
: 8      121631      2898796   +2283.27%
: 16     59749       2902056   +4757.07%
: 32     26837	     2326314   +8568.30%
: 64     12926       1341281   +10276.61%
: 
: (http://linux-scalability.org/epoll/epoll-test.c)

Link: http://lkml.kernel.org/r/1509430214-5599-1-git-send-email-jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Salman Qazi <sqazi@google.com>
Cc: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   82 ++++++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 46 deletions(-)

diff -puN fs/eventpoll.c~epoll-remove-ep_call_nested-from-ep_eventpoll_poll fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-remove-ep_call_nested-from-ep_eventpoll_poll
+++ a/fs/eventpoll.c
@@ -276,9 +276,6 @@ static DEFINE_MUTEX(epmutex);
 /* Used to check for epoll file descriptor inclusion loops */
 static struct nested_calls poll_loop_ncalls;
 
-/* Used to call file's f_op->poll() under the nested calls boundaries */
-static struct nested_calls poll_readywalk_ncalls;
-
 /* Slab cache used to allocate "struct epitem" */
 static struct kmem_cache *epi_cache __read_mostly;
 
@@ -867,11 +864,33 @@ static int ep_eventpoll_release(struct i
 	return 0;
 }
 
-static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
+static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
+			       void *priv);
+static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
+				 poll_table *pt);
+
+/*
+ * Differs from ep_eventpoll_poll() in that internal callers already have
+ * the ep->mtx so we need to start from depth=1, such that mutex_lock_nested()
+ * is correctly annotated.
+ */
+static unsigned int ep_item_poll(struct epitem *epi, poll_table *pt, int depth)
 {
-	pt->_key = epi->event.events;
+	struct eventpoll *ep;
+	bool locked;
 
-	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+	pt->_key = epi->event.events;
+	if (!is_file_epoll(epi->ffd.file))
+		return epi->ffd.file->f_op->poll(epi->ffd.file, pt) &
+		       epi->event.events;
+
+	ep = epi->ffd.file->private_data;
+	poll_wait(epi->ffd.file, &ep->poll_wait, pt);
+	locked = pt && (pt->_qproc == ep_ptable_queue_proc);
+
+	return ep_scan_ready_list(epi->ffd.file->private_data,
+				  ep_read_events_proc, &depth, depth,
+				  locked) & epi->event.events;
 }
 
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
@@ -879,13 +898,15 @@ static int ep_read_events_proc(struct ev
 {
 	struct epitem *epi, *tmp;
 	poll_table pt;
+	int depth = *(int *)priv;
 
 	init_poll_funcptr(&pt, NULL);
+	depth++;
 
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (ep_item_poll(epi, &pt))
+		if (ep_item_poll(epi, &pt, depth)) {
 			return POLLIN | POLLRDNORM;
-		else {
+		} else {
 			/*
 			 * Item has been dropped into the ready list by the poll
 			 * callback, but it's not actually ready, as far as
@@ -899,48 +920,20 @@ static int ep_read_events_proc(struct ev
 	return 0;
 }
 
-static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
-				 poll_table *pt);
-
-struct readyevents_arg {
-	struct eventpoll *ep;
-	bool locked;
-};
-
-static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
-{
-	struct readyevents_arg *arg = priv;
-
-	return ep_scan_ready_list(arg->ep, ep_read_events_proc, NULL,
-				  call_nests + 1, arg->locked);
-}
-
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 {
-	int pollflags;
 	struct eventpoll *ep = file->private_data;
-	struct readyevents_arg arg;
-
-	/*
-	 * During ep_insert() we already hold the ep->mtx for the tfile.
-	 * Prevent re-aquisition.
-	 */
-	arg.locked = wait && (wait->_qproc == ep_ptable_queue_proc);
-	arg.ep = ep;
+	int depth = 0;
 
 	/* Insert inside our poll wait queue */
 	poll_wait(file, &ep->poll_wait, wait);
 
 	/*
 	 * Proceed to find out if wanted events are really available inside
-	 * the ready list. This need to be done under ep_call_nested()
-	 * supervision, since the call to f_op->poll() done on listed files
-	 * could re-enter here.
+	 * the ready list.
 	 */
-	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, &arg, ep, current);
-
-	return pollflags != -1 ? pollflags : 0;
+	return ep_scan_ready_list(ep, ep_read_events_proc,
+				  &depth, depth, false);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -1459,7 +1452,7 @@ static int ep_insert(struct eventpoll *e
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
-	revents = ep_item_poll(epi, &epq.pt);
+	revents = ep_item_poll(epi, &epq.pt, 1);
 
 	/*
 	 * We have to check if something went wrong during the poll wait queue
@@ -1593,7 +1586,7 @@ static int ep_modify(struct eventpoll *e
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = ep_item_poll(epi, &pt);
+	revents = ep_item_poll(epi, &pt, 1);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1661,7 +1654,7 @@ static int ep_send_events_proc(struct ev
 
 		list_del_init(&epi->rdllink);
 
-		revents = ep_item_poll(epi, &pt);
+		revents = ep_item_poll(epi, &pt, 1);
 
 		/*
 		 * If the event mask intersect the caller-requested one,
@@ -2307,9 +2300,6 @@ static int __init eventpoll_init(void)
 	ep_nested_calls_init(&poll_safewake_ncalls);
 #endif
 
-	/* Initialize the structure used to perform file's f_op->poll() calls */
-	ep_nested_calls_init(&poll_readywalk_ncalls);
