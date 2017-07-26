From: akpm@linux-foundation.org
Subject: + lib-rbtree_testc-add-inorder-traversal-test.patch added to -mm
 tree
Date: Wed, 26 Jul 2017 14:14:27 -0700
Message-ID: <59790633.h0TcsmhkFwG/mJxX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree_test.c: add (inorder) traversal test
has been added to the -mm tree.  Its filename is
     lib-rbtree_testc-add-inorder-traversal-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rbtree_testc-add-inorder-traversal-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rbtree_testc-add-inorder-traversal-test.patch

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
Subject: lib/rbtree_test.c: add (inorder) traversal test

This adds a second test for regular rb-tree testing in that there is no
need to repeat it for the augmented flavor.

Link: http://lkml.kernel.org/r/20170719014603.19029-6-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN lib/rbtree_test.c~lib-rbtree_testc-add-inorder-traversal-test lib/rbtree_test.c
--- a/lib/rbtree_test.c~lib-rbtree_testc-add-inorder-traversal-test
+++ a/lib/rbtree_test.c
@@ -183,6 +183,7 @@ static int __init rbtree_test_init(void)
 {
 	int i, j;
 	cycles_t time1, time2, time;
+	struct rb_node *node;
 
 	nodes = kmalloc(nnodes * sizeof(*nodes), GFP_KERNEL);
 	if (!nodes)
@@ -206,8 +207,28 @@ static int __init rbtree_test_init(void)
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> %llu cycles\n", (unsigned long long)time);
+	printk(" -> test 1 (latency of nnodes insert+delete): %llu cycles\n", (unsigned long long)time);
 
+	for (i = 0; i < nnodes; i++)
+		insert(nodes + i, &root);
+
+	time1 = get_cycles();
+
+	for (i = 0; i < perf_loops; i++) {
+		for (node = rb_first(&root); node; node = rb_next(node))
+			;
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, perf_loops);
+	printk(" -> test 2 (latency of inorder traversal): %llu cycles\n", (unsigned long long)time);
+
+	for (i = 0; i < nnodes; i++)
+		erase(nodes + i, &root);
+
+	/* run checks */
 	for (i = 0; i < check_loops; i++) {
 		init();
 		for (j = 0; j < nnodes; j++) {
@@ -238,7 +259,7 @@ static int __init rbtree_test_init(void)
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> %llu cycles\n", (unsigned long long)time);
+	printk(" -> test 1 (latency of nnodes insert+delete): %llu cycles\n", (unsigned long long)time);
 
 	for (i = 0; i < check_loops; i++) {
 		init();
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

