From: akpm@linux-foundation.org
Subject: + block-cfq-cache-rightmost-rb_node.patch added to -mm tree
Date: Wed, 26 Jul 2017 14:15:05 -0700
Message-ID: <59790659.E3F/1+8D6IR95nNK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdGZVPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, axboe@fb.com, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: block/cfq: cache rightmost rb_node
has been added to the -mm tree.  Its filename is
     block-cfq-cache-rightmost-rb_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-cfq-cache-rightmost-rb_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-cfq-cache-rightmost-rb_node.patch

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
Subject: block/cfq: cache rightmost rb_node

For the same reasons we already cache the leftmost pointer, apply the same
optimization for rb_last() calls.  Users must explicitly do this as
rb_root_cached only deals with the smallest node.

Link: http://lkml.kernel.org/r/20170719014603.19029-18-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN block/cfq-iosched.c~block-cfq-cache-rightmost-rb_node block/cfq-iosched.c
--- a/block/cfq-iosched.c~block-cfq-cache-rightmost-rb_node
+++ a/block/cfq-iosched.c
@@ -94,11 +94,13 @@ struct cfq_ttime {
  */
 struct cfq_rb_root {
 	struct rb_root_cached rb;
+	struct rb_node *rb_rightmost;
 	unsigned count;
 	u64 min_vdisktime;
 	struct cfq_ttime ttime;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT_CACHED, \
+			.rb_rightmost = NULL,			     \
 			.ttime = {.last_end_request = ktime_get_ns(),},}
 
 /*
@@ -1183,6 +1185,9 @@ static struct cfq_group *cfq_rb_first_gr
 
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 {
+	if (root->rb_rightmost == n)
+		root->rb_rightmost = rb_next(n);
+
 	rb_erase_cached(n, &root->rb);
 	RB_CLEAR_NODE(n);
 
@@ -1239,20 +1244,24 @@ __cfq_group_service_tree_add(struct cfq_
 	struct rb_node *parent = NULL;
 	struct cfq_group *__cfqg;
 	s64 key = cfqg_key(st, cfqg);
-	bool leftmost = true;
+	bool leftmost = true, rightmost = true;
 
 	while (*node != NULL) {
 		parent = *node;
 		__cfqg = rb_entry_cfqg(parent);
 
-		if (key < cfqg_key(st, __cfqg))
+		if (key < cfqg_key(st, __cfqg)) {
 			node = &parent->rb_left;
-		else {
+			rightmost = false;
+		} else {
 			node = &parent->rb_right;
 			leftmost = false;
 		}
 	}
 
+	if (rightmost)
+		st->rb_rightmost = &cfqg->rb_node;
+
 	rb_link_node(&cfqg->rb_node, parent, node);
 	rb_insert_color_cached(&cfqg->rb_node, &st->rb, leftmost);
 }
@@ -1355,7 +1364,7 @@ cfq_group_notify_queue_add(struct cfq_da
 	 * so that groups get lesser vtime based on their weights, so that
 	 * if group does not loose all if it was not continuously backlogged.
 	 */
-	n = rb_last(&st->rb.rb_root);
+	n = st->rb_rightmost;
 	if (n) {
 		__cfqg = rb_entry_cfqg(n);
 		cfqg->vdisktime = __cfqg->vdisktime +
@@ -2204,7 +2213,7 @@ static void cfq_service_tree_add(struct
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&st->rb.rb_root);
+		parent = st->rb_rightmost;
 		if (parent && parent != &cfqq->rb_node) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
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

