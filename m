From: akpm@linux-foundation.org
Subject: [merged]
 lib-rbtree_testc-make-input-module-parameters.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:41:37 -0700
Message-ID: <20170911194137.AqRWnqwf0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49970 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTli (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree_test.c: make input module parameters
has been removed from the -mm tree.  Its filename was
     lib-rbtree_testc-make-input-module-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/rbtree_test.c: make input module parameters

Allows for more flexible debugging.

Link: http://lkml.kernel.org/r/20170719014603.19029-5-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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


