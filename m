From: akpm@linux-foundation.org
Subject: + block-cfq-replace-cfq_rb_root-leftmost-caching.patch added to
 -mm tree
Date: Wed, 19 Jul 2017 15:53:06 -0700
Message-ID: <596fe2d2.6ZC872BqPQ0oS6RQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932861AbdGSWxH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, axboe@fb.com, dbueso@suse.de, jack@suse.cz, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block/cfq: replace cfq_rb_root leftmost caching
has been added to the -mm tree.  Its filename is
     block-cfq-replace-cfq_rb_root-leftmost-caching.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-cfq-replace-cfq_rb_root-leftmost-caching.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-cfq-replace-cfq_rb_root-leftmost-caching.patch

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
Subject: block/cfq: replace cfq_rb_root leftmost caching

...  with the generic rbtree flavor instead.  No changes in semantics
whatsoever.

Link: http://lkml.kernel.org/r/20170629171553.2146-6-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |   70 ++++++++++++------------------------------
 1 file changed, 20 insertions(+), 50 deletions(-)

diff -puN block/cfq-iosched.c~block-cfq-replace-cfq_rb_root-leftmost-caching block/cfq-iosched.c
--- a/block/cfq-iosched.c~block-cfq-replace-cfq_rb_root-leftmost-caching
+++ a/block/cfq-iosched.c
@@ -93,13 +93,12 @@ struct cfq_ttime {
  * move this into the elevator for the rq sorting as well.
  */
 struct cfq_rb_root {
-	struct rb_root rb;
-	struct rb_node *left;
+	struct rb_root_cached rb;
 	unsigned count;
 	u64 min_vdisktime;
 	struct cfq_ttime ttime;
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, \
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT_CACHED, \
 			.ttime = {.last_end_request = ktime_get_ns(),},}
 
 /*
@@ -984,10 +983,9 @@ static inline u64 max_vdisktime(u64 min_
 
 static void update_min_vdisktime(struct cfq_rb_root *st)
 {
-	struct cfq_group *cfqg;
+	if (!RB_EMPTY_ROOT(&st->rb.rb_root)) {
+		struct cfq_group *cfqg = rb_entry_cfqg(st->rb.rb_leftmost);
 
-	if (st->left) {
-		cfqg = rb_entry_cfqg(st->left);
 		st->min_vdisktime = max_vdisktime(st->min_vdisktime,
 						  cfqg->vdisktime);
 	}
@@ -1169,46 +1167,25 @@ cfq_choose_req(struct cfq_data *cfqd, st
 	}
 }
 
-/*
- * The below is leftmost cache rbtree addon
- */
 static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 {
 	/* Service tree is empty */
 	if (!root->count)
 		return NULL;
 
-	if (!root->left)
-		root->left = rb_first(&root->rb);
-
-	if (root->left)
-		return rb_entry(root->left, struct cfq_queue, rb_node);
-
-	return NULL;
+	return rb_entry(rb_first_cached(&root->rb), struct cfq_queue, rb_node);
 }
 
 static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
 {
-	if (!root->left)
-		root->left = rb_first(&root->rb);
-
-	if (root->left)
-		return rb_entry_cfqg(root->left);
-
-	return NULL;
+	return rb_entry_cfqg(rb_first_cached(&root->rb));
 }
 
-static void rb_erase_init(struct rb_node *n, struct rb_root *root)
+static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 {
-	rb_erase(n, root);
+	rb_erase_cached(n, &root->rb);
 	RB_CLEAR_NODE(n);
-}
 
-static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
-{
-	if (root->left == n)
-		root->left = NULL;
-	rb_erase_init(n, &root->rb);
 	--root->count;
 }
 
@@ -1258,11 +1235,11 @@ cfqg_key(struct cfq_rb_root *st, struct
 static void
 __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
-	struct rb_node **node = &st->rb.rb_node;
+	struct rb_node **node = &st->rb.rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct cfq_group *__cfqg;
 	s64 key = cfqg_key(st, cfqg);
-	int left = 1;
+	bool leftmost = true;
 
 	while (*node != NULL) {
 		parent = *node;
@@ -1272,15 +1249,12 @@ __cfq_group_service_tree_add(struct cfq_
 			node = &parent->rb_left;
 		else {
 			node = &parent->rb_right;
-			left = 0;
+			leftmost = false;
 		}
 	}
 
-	if (left)
-		st->left = &cfqg->rb_node;
-
 	rb_link_node(&cfqg->rb_node, parent, node);
-	rb_insert_color(&cfqg->rb_node, &st->rb);
+	rb_insert_color_cached(&cfqg->rb_node, &st->rb, leftmost);
 }
 
 /*
@@ -1381,7 +1355,7 @@ cfq_group_notify_queue_add(struct cfq_da
 	 * so that groups get lesser vtime based on their weights, so that
 	 * if group does not loose all if it was not continuously backlogged.
 	 */
-	n = rb_last(&st->rb);
+	n = rb_last(&st->rb.rb_root);
 	if (n) {
 		__cfqg = rb_entry_cfqg(n);
 		cfqg->vdisktime = __cfqg->vdisktime +
@@ -2223,14 +2197,14 @@ static void cfq_service_tree_add(struct
 	struct cfq_queue *__cfqq;
 	u64 rb_key;
 	struct cfq_rb_root *st;
-	int left;
+	bool leftmost = true;
 	int new_cfqq = 1;
 	u64 now = ktime_get_ns();
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&st->rb);
+		parent = rb_last(&st->rb.rb_root);
 		if (parent && parent != &cfqq->rb_node) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
@@ -2264,10 +2238,9 @@ static void cfq_service_tree_add(struct
 		cfqq->service_tree = NULL;
 	}
 
-	left = 1;
 	parent = NULL;
 	cfqq->service_tree = st;
-	p = &st->rb.rb_node;
+	p = &st->rb.rb_root.rb_node;
 	while (*p) {
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
@@ -2279,16 +2252,13 @@ static void cfq_service_tree_add(struct
 			p = &parent->rb_left;
 		else {
 			p = &parent->rb_right;
-			left = 0;
+			leftmost = false;
 		}
 	}
 
-	if (left)
-		st->left = &cfqq->rb_node;
-
 	cfqq->rb_key = rb_key;
 	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &st->rb);
+	rb_insert_color_cached(&cfqq->rb_node, &st->rb, leftmost);
 	st->count++;
 	if (add_front || !new_cfqq)
 		return;
@@ -2735,7 +2705,7 @@ static struct cfq_queue *cfq_get_next_qu
 	/* There is nothing to dispatch */
 	if (!st)
 		return NULL;
-	if (RB_EMPTY_ROOT(&st->rb))
+	if (RB_EMPTY_ROOT(&st->rb.rb_root))
 		return NULL;
 	return cfq_rb_first(st);
 }
@@ -3221,7 +3191,7 @@ static struct cfq_group *cfq_get_next_cf
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	struct cfq_group *cfqg;
 
-	if (RB_EMPTY_ROOT(&st->rb))
+	if (RB_EMPTY_ROOT(&st->rb.rb_root))
 		return NULL;
 	cfqg = cfq_rb_first_group(st);
 	update_min_vdisktime(st);
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch

