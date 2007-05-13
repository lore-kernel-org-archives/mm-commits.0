From: akpm@linux-foundation.org
Subject: + epoll-fix-some-comments.patch added to -mm tree
Date: Sun, 13 May 2007 12:33:01 -0700
Message-ID: <200705131933.l4DJX0Wb001868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578AbXEMTdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 15:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     epoll: fix some comments
has been added to the -mm tree.  Its filename is
     epoll-fix-some-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: epoll: fix some comments
From: Davide Libenzi <davidel@xmailserver.org>

Fixes some epoll code comments.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   48 ++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-some-comments fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-some-comments
+++ a/fs/eventpoll.c
@@ -134,7 +134,7 @@ struct poll_safewake {
  * have an entry of this type linked to the "rbr" RB tree.
  */
 struct epitem {
-	/* RB-Tree node used to link this structure to the eventpoll rb-tree */
+	/* RB tree node used to link this structure to the eventpoll RB tree */
 	struct rb_node rbn;
 
 	/* List header used to link this structure to the eventpoll ready list */
@@ -191,7 +191,7 @@ struct eventpoll {
 	/* List of ready file descriptors */
 	struct list_head rdllist;
 
-	/* RB-Tree root used to store monitored fd structs */
+	/* RB tree root used to store monitored fd structs */
 	struct rb_root rbr;
 
 	/*
@@ -241,7 +241,7 @@ static struct kmem_cache *epi_cache __re
 static struct kmem_cache *pwq_cache __read_mostly;
 
 
-/* Setup the structure that is used as key for the rb-tree */
+/* Setup the structure that is used as key for the RB tree */
 static inline void ep_set_ffd(struct epoll_filefd *ffd,
 			      struct file *file, int fd)
 {
@@ -249,7 +249,7 @@ static inline void ep_set_ffd(struct epo
 	ffd->fd = fd;
 }
 
-/* Compare rb-tree keys */
+/* Compare RB tree keys */
 static inline int ep_cmp_ffd(struct epoll_filefd *p1,
 			     struct epoll_filefd *p2)
 {
@@ -257,20 +257,20 @@ static inline int ep_cmp_ffd(struct epol
 	        (p1->file < p2->file ? -1 : p1->fd - p2->fd));
 }
 
-/* Special initialization for the rb-tree node to detect linkage */
+/* Special initialization for the RB tree node to detect linkage */
 static inline void ep_rb_initnode(struct rb_node *n)
 {
 	rb_set_parent(n, n);
 }
 
-/* Removes a node from the rb-tree and marks it for a fast is-linked check */
+/* Removes a node from the RB tree and marks it for a fast is-linked check */
 static inline void ep_rb_erase(struct rb_node *n, struct rb_root *r)
 {
 	rb_erase(n, r);
 	rb_set_parent(n, n);
 }
 
-/* Fast check to verify that the item is linked to the main rb-tree */
+/* Fast check to verify that the item is linked to the main RB tree */
 static inline int ep_rb_linked(struct rb_node *n)
 {
 	return rb_parent(n) != n;
@@ -531,6 +531,8 @@ void eventpoll_release_file(struct file 
 	 * We don't want to get "file->f_ep_lock" because it is not
 	 * necessary. It is not necessary because we're in the "struct file"
 	 * cleanup path, and this means that noone is using this file anymore.
+	 * So, for example, epoll_ctl() cannot hit here sicne if we reach this
+	 * point, the file counter already went to zero and fget() would fail.
 	 * The only hit might come from ep_free() but by holding the mutex
 	 * will correctly serialize the operation. We do need to acquire
 	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
@@ -802,7 +804,9 @@ error_unregister:
 
 	/*
 	 * We need to do this because an event could have been arrived on some
-	 * allocated wait queue.
+	 * allocated wait queue. Note that we don't care about the ep->ovflist
+	 * list, since that is used/cleaned only inside a section bound by "mtx".
+	 * And ep_insert() is called with "mtx" held.
 	 */
 	spin_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
@@ -845,8 +849,7 @@ static int ep_modify(struct eventpoll *e
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
-	 * list, push it inside. If the item is not "hot" and it is currently
-	 * registered inside the ready list, unlink it.
+	 * list, push it inside.
 	 */
 	if (revents & event->events) {
 		if (!ep_is_linked(&epi->rdllink)) {
@@ -966,15 +969,16 @@ errxit:
 	ep->ovflist = EP_UNACTIVE_PTR;
 
 	/*
-	 * In case of error in the event-send loop, we might still have items
-	 * inside the "txlist". We need to splice them back inside ep->rdllist.
+	 * In case of error in the event-send loop, or in case the number of
+	 * ready events exceeds the userspace limit, we need to splice the
+	 * "txlist" back inside ep->rdllist.
 	 */
 	list_splice(&txlist, &ep->rdllist);
 
 	if (!list_empty(&ep->rdllist)) {
 		/*
 		 * Wake up (if active) both the eventpoll wait list and the ->poll()
-		 * wait list.
+		 * wait list (delayed after we release the lock).
 		 */
 		if (waitqueue_active(&ep->wq))
 			__wake_up_locked(&ep->wq, TASK_UNINTERRUPTIBLE |
@@ -1064,11 +1068,10 @@ retry:
 }
 
 /*
- * It opens an eventpoll file descriptor by suggesting a storage of "size"
- * file descriptors. The size parameter is just an hint about how to size
- * data structures. It won't prevent the user to store more than "size"
- * file descriptors inside the epoll interface. It is the kernel part of
- * the userspace epoll_create(2).
+ * It opens an eventpoll file descriptor. The "size" parameter is there
+ * for historical reasons, when epoll was using an hash instead of an
+ * RB tree. With the current implementation, the "size" parameter is ignored
+ * (besides sanity checks).
  */
 asmlinkage long sys_epoll_create(int size)
 {
@@ -1114,8 +1117,7 @@ error_return:
 /*
  * The following function implements the controller interface for
  * the eventpoll file that enables the insertion/removal/change of
- * file descriptors inside the interest set.  It represents
- * the kernel part of the user space epoll_ctl(2).
+ * file descriptors inside the interest set.
  */
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
 			      struct epoll_event __user *event)
@@ -1167,7 +1169,11 @@ asmlinkage long sys_epoll_ctl(int epfd, 
 
 	mutex_lock(&ep->mtx);
 
-	/* Try to lookup the file inside our RB tree */
+	/*
+	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
+	 * above, we can be sure to be able to use the item looked up by
+	 * ep_find() till we release the mutex.
+	 */
 	epi = ep_find(ep, tfile, fd);
 
 	error = -EINVAL;
_

Patches currently in -mm which might be from davidel@xmailserver.org are

fix-epoll-single-pass-code-and-add-wait-exclusive-flag.patch
epoll-locks-changes-and-cleanups.patch
epoll-fix-some-comments.patch
