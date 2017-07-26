From: akpm@linux-foundation.org
Subject: + lib-rbtree_testc-make-input-module-parameters.patch added to
 -mm tree
Date: Wed, 26 Jul 2017 14:14:23 -0700
Message-ID: <5979062f.DtwYK59PWyecwU0K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVOY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree_test.c: make input module parameters
has been added to the -mm tree.  Its filename is
     lib-rbtree_testc-make-input-module-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rbtree_testc-make-input-module-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rbtree_testc-make-input-module-parameters.patch

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
Subject: lib/rbtree_test.c: make input module parameters

Allows for more flexible debugging.

Link: http://lkml.kernel.org/r/20170719014603.19029-5-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <>
---

 lib/rbtree_test.c |   55 +++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff -puN lib/rbtree_test.c~lib-rbtree_testc-make-input-module-parameters lib/rbtree_test.c
--- a/lib/rbtree_test.c~lib-rbtree_testc-make-input-module-parameters
+++ a/lib/rbtree_test.c
@@ -1,11 +1,18 @@
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 #include <asm/timex.h>
 
-#define NODES       100
-#define PERF_LOOPS  100000
-#define CHECK_LOOPS 100
+#define __param(type, name, init, msg)		\
+	static type name = init;		\
+	module_param(name, type, 0444);		\
+	MODULE_PARM_DESC(name, msg);
+
+__param(int, nnodes, 100, "Number of nodes in the rb-tree");
+__param(int, perf_loops, 100000, "Number of iterations modifying the rb-tree");
+__param(int, check_loops, 100, "Number of iterations modifying and verifying the rb-tree");
 
 struct test_node {
 	u32 key;
@@ -17,7 +24,7 @@ struct test_node {
 };
 
 static struct rb_root root = RB_ROOT;
-static struct test_node nodes[NODES];
+static struct test_node *nodes = NULL;
 
 static struct rnd_state rnd;
 
@@ -95,7 +102,7 @@ static void erase_augmented(struct test_
 static void init(void)
 {
 	int i;
-	for (i = 0; i < NODES; i++) {
+	for (i = 0; i < nnodes; i++) {
 		nodes[i].key = prandom_u32_state(&rnd);
 		nodes[i].val = prandom_u32_state(&rnd);
 	}
@@ -177,6 +184,10 @@ static int __init rbtree_test_init(void)
 	int i, j;
 	cycles_t time1, time2, time;
 
+	nodes = kmalloc(nnodes * sizeof(*nodes), GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
+
 	printk(KERN_ALERT "rbtree testing");
 
 	prandom_seed_state(&rnd, 3141592653589793238ULL);
@@ -184,27 +195,27 @@ static int __init rbtree_test_init(void)
 
 	time1 = get_cycles();
 
-	for (i = 0; i < PERF_LOOPS; i++) {
-		for (j = 0; j < NODES; j++)
+	for (i = 0; i < perf_loops; i++) {
+		for (j = 0; j < nnodes; j++)
 			insert(nodes + j, &root);
-		for (j = 0; j < NODES; j++)
+		for (j = 0; j < nnodes; j++)
 			erase(nodes + j, &root);
 	}
 
 	time2 = get_cycles();
 	time = time2 - time1;
 
-	time = div_u64(time, PERF_LOOPS);
+	time = div_u64(time, perf_loops);
 	printk(" -> %llu cycles\n", (unsigned long long)time);
 
-	for (i = 0; i < CHECK_LOOPS; i++) {
+	for (i = 0; i < check_loops; i++) {
 		init();
-		for (j = 0; j < NODES; j++) {
+		for (j = 0; j < nnodes; j++) {
 			check(j);
 			insert(nodes + j, &root);
 		}
-		for (j = 0; j < NODES; j++) {
-			check(NODES - j);
+		for (j = 0; j < nnodes; j++) {
+			check(nnodes - j);
 			erase(nodes + j, &root);
 		}
 		check(0);
@@ -216,32 +227,34 @@ static int __init rbtree_test_init(void)
 
 	time1 = get_cycles();
 
-	for (i = 0; i < PERF_LOOPS; i++) {
-		for (j = 0; j < NODES; j++)
+	for (i = 0; i < perf_loops; i++) {
+		for (j = 0; j < nnodes; j++)
 			insert_augmented(nodes + j, &root);
-		for (j = 0; j < NODES; j++)
+		for (j = 0; j < nnodes; j++)
 			erase_augmented(nodes + j, &root);
 	}
 
 	time2 = get_cycles();
 	time = time2 - time1;
 
-	time = div_u64(time, PERF_LOOPS);
+	time = div_u64(time, perf_loops);
 	printk(" -> %llu cycles\n", (unsigned long long)time);
 
-	for (i = 0; i < CHECK_LOOPS; i++) {
+	for (i = 0; i < check_loops; i++) {
 		init();
-		for (j = 0; j < NODES; j++) {
+		for (j = 0; j < nnodes; j++) {
 			check_augmented(j);
 			insert_augmented(nodes + j, &root);
 		}
-		for (j = 0; j < NODES; j++) {
-			check_augmented(NODES - j);
+		for (j = 0; j < nnodes; j++) {
+			check_augmented(nnodes - j);
 			erase_augmented(nodes + j, &root);
 		}
 		check_augmented(0);
 	}
 
+	kfree(nodes);
+
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
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

