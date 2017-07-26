From: akpm@linux-foundation.org
Subject: + fs-epoll-use-faster-rb_first_cached.patch added to -mm tree
Date: Wed, 26 Jul 2017 14:15:01 -0700
Message-ID: <59790655.x+QPNTd279H6e+Qq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jack@suse.cz, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/epoll: use faster rb_first_cached()
has been added to the -mm tree.  Its filename is
     fs-epoll-use-faster-rb_first_cached.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-epoll-use-faster-rb_first_cached.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-epoll-use-faster-rb_first_cached.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: fs/epoll: use faster rb_first_cached()

...  such that we can avoid the tree walks to get the node with the
smallest key.  Semantically the same, as the previously used rb_first(),
but O(1).  The main overhead is the extra footprint for the cached rb_node
pointer, which should not matter for epoll.

Link: http://lkml.kernel.org/r/20170719014603.19029-15-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN fs/eventpoll.c~fs-epoll-use-faster-rb_first_cached fs/eventpoll.c
--- a/fs/eventpoll.c~fs-epoll-use-faster-rb_first_cached
+++ a/fs/eventpoll.c
@@ -205,7 +205,7 @@ struct eventpoll {
 	struct list_head rdllist;
 
 	/* RB tree root used to store monitored fd structs */
-	struct rb_root rbr;
+	struct rb_root_cached rbr;
 
 	/*
 	 * This is a single linked list that chains all the "struct epitem" that
@@ -791,7 +791,7 @@ static int ep_remove(struct eventpoll *e
 	list_del_rcu(&epi->fllink);
 	spin_unlock(&file->f_lock);
 
-	rb_erase(&epi->rbn, &ep->rbr);
+	rb_erase_cached(&epi->rbn, &ep->rbr);
 
 	spin_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
@@ -835,7 +835,7 @@ static void ep_free(struct eventpoll *ep
 	/*
 	 * Walks through the whole tree by unregistering poll callbacks.
 	 */
-	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 
 		ep_unregister_pollwait(ep, epi);
@@ -851,7 +851,7 @@ static void ep_free(struct eventpoll *ep
 	 * a lockdep warning.
 	 */
 	mutex_lock(&ep->mtx);
-	while ((rbp = rb_first(&ep->rbr)) != NULL) {
+	while ((rbp = rb_first_cached(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
 		cond_resched();
@@ -958,7 +958,7 @@ static void ep_show_fdinfo(struct seq_fi
 	struct rb_node *rbp;
 
 	mutex_lock(&ep->mtx);
-	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
 		struct inode *inode = file_inode(epi->ffd.file);
 
@@ -1035,7 +1035,7 @@ static int ep_alloc(struct eventpoll **p
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
-	ep->rbr = RB_ROOT;
+	ep->rbr = RB_ROOT_CACHED;
 	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
 
@@ -1061,7 +1061,7 @@ static struct epitem *ep_find(struct eve
 	struct epoll_filefd ffd;
 
 	ep_set_ffd(&ffd, file, fd);
-	for (rbp = ep->rbr.rb_node; rbp; ) {
+	for (rbp = ep->rbr.rb_root.rb_node; rbp; ) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		kcmp = ep_cmp_ffd(&ffd, &epi->ffd);
 		if (kcmp > 0)
@@ -1083,7 +1083,7 @@ static struct epitem *ep_find_tfd(struct
 	struct rb_node *rbp;
 	struct epitem *epi;
 
-	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (epi->ffd.fd == tfd) {
 			if (toff == 0)
@@ -1263,20 +1263,22 @@ static void ep_ptable_queue_proc(struct
 static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
 {
 	int kcmp;
-	struct rb_node **p = &ep->rbr.rb_node, *parent = NULL;
+	struct rb_node **p = &ep->rbr.rb_root.rb_node, *parent = NULL;
 	struct epitem *epic;
+	bool leftmost = true;
 
 	while (*p) {
 		parent = *p;
 		epic = rb_entry(parent, struct epitem, rbn);
 		kcmp = ep_cmp_ffd(&epi->ffd, &epic->ffd);
-		if (kcmp > 0)
+		if (kcmp > 0) {
 			p = &parent->rb_right;
-		else
+			leftmost = false;
+		} else
 			p = &parent->rb_left;
 	}
 	rb_link_node(&epi->rbn, parent, p);
-	rb_insert_color(&epi->rbn, &ep->rbr);
+	rb_insert_color_cached(&epi->rbn, &ep->rbr, leftmost);
 }
 
 
@@ -1520,7 +1522,7 @@ error_remove_epi:
 	list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
-	rb_erase(&epi->rbn, &ep->rbr);
+	rb_erase_cached(&epi->rbn, &ep->rbr);
 
 error_unregister:
 	ep_unregister_pollwait(ep, epi);
@@ -1868,7 +1870,7 @@ static int ep_loop_check_proc(void *priv
 	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	ep->visited = 1;
 	list_add(&ep->visited_list_link, &visited_list);
-	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
 			ep_tovisit = epi->ffd.file->private_data;
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
rbtree-optimize-root-check-during-rebalancing-loop.patch
rbtree-add-some-additional-comments-for-rebalancing-cases.patch
lib-rbtree_testc-make-input-module-parameters.patch
lib-rbtree_testc-add-inorder-traversal-test.patch
lib-rbtree_testc-support-rb_root_cached.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch
mem-memcg-cache-rightmost-node.patch
block-cfq-cache-rightmost-rb_node.patch

