From: akpm@linux-foundation.org
Subject: [patch 070/126] lib/rbtree_test.c: add (inorder) traversal
 test
Date: Fri, 08 Sep 2017 16:14:49 -0700
Message-ID: <20170908231449.QI2LJY_Xo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
