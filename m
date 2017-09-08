From: akpm@linux-foundation.org
Subject: [patch 081/126] block/cfq: cache rightmost rb_node
Date: Fri, 08 Sep 2017 16:15:25 -0700
Message-ID: <20170908231525.wWPJQ0Nzs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXP0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: block/cfq: cache rightmost rb_node

For the same reasons we already cache the leftmost pointer, apply the same
optimization for rb_last() calls.  Users must explicitly do this as
rb_root_cached only deals with the smallest node.

[dave@stgolabs.net: brain fart #1]
  Link: http://lkml.kernel.org/r/20170731155955.GD21328@linux-80c1.suse
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
@@ -1180,6 +1182,9 @@ static struct cfq_group *cfq_rb_first_gr
 
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 {
+	if (root->rb_rightmost == n)
+		root->rb_rightmost = rb_prev(n);
+
 	rb_erase_cached(n, &root->rb);
 	RB_CLEAR_NODE(n);
 
@@ -1236,20 +1241,24 @@ __cfq_group_service_tree_add(struct cfq_
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
@@ -1352,7 +1361,7 @@ cfq_group_notify_queue_add(struct cfq_da
 	 * so that groups get lesser vtime based on their weights, so that
 	 * if group does not loose all if it was not continuously backlogged.
 	 */
-	n = rb_last(&st->rb.rb_root);
+	n = st->rb_rightmost;
 	if (n) {
 		__cfqg = rb_entry_cfqg(n);
 		cfqg->vdisktime = __cfqg->vdisktime +
@@ -2201,7 +2210,7 @@ static void cfq_service_tree_add(struct
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&st->rb.rb_root);
+		parent = st->rb_rightmost;
 		if (parent && parent != &cfqq->rb_node) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
_
