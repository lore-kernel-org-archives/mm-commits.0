From: akpm@linux-foundation.org
Subject: +
 lib-interval_tree_test-make-test-options-module-parameters.patch added to
 -mm tree
Date: Thu, 18 May 2017 12:32:07 -0700
Message-ID: <591df6b7.JZw33UHP+7I5OpB0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755682AbdERTcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 15:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval_tree_test.c: make test options module parameters
has been added to the -mm tree.  Its filename is
     lib-interval_tree_test-make-test-options-module-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-interval_tree_test-make-test-options-module-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-interval_tree_test-make-test-options-module-parameters.patch

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
Subject: lib/interval_tree_test.c: make test options module parameters

Allows for more flexible debugging.

Link: http://lkml.kernel.org/r/20170518174936.20265-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |   57 +++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff -puN lib/interval_tree_test.c~lib-interval_tree_test-make-test-options-module-parameters lib/interval_tree_test.c
--- a/lib/interval_tree_test.c~lib-interval_tree_test-make-test-options-module-parameters
+++ a/lib/interval_tree_test.c
@@ -1,16 +1,25 @@
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/interval_tree.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 #include <asm/timex.h>
 
-#define NODES        100
-#define PERF_LOOPS   100000
-#define SEARCHES     100
-#define SEARCH_LOOPS 10000
+#define __param(type, name, init, msg)		\
+	static type name = init;		\
+	module_param(name, type, 0444);		\
+	MODULE_PARM_DESC(name, msg);
+
+__param(int, nnodes, 100, "Number of nodes in the interval tree");
+__param(int, perf_loops, 100000, "Number of iterations modifying the tree");
+
+__param(int, nsearches, 100, "Number of searches to the interval tree");
+__param(int, search_loops, 10000, "Number of iterations searching the tree");
+
 
 static struct rb_root root = RB_ROOT;
-static struct interval_tree_node nodes[NODES];
-static u32 queries[SEARCHES];
+static struct interval_tree_node *nodes = NULL;
+static u32 *queries = NULL;
 
 static struct rnd_state rnd;
 
@@ -29,7 +38,8 @@ search(unsigned long query, struct rb_ro
 static void init(void)
 {
 	int i;
-	for (i = 0; i < NODES; i++) {
+
+	for (i = 0; i < nnodes; i++) {
 		u32 a = prandom_u32_state(&rnd);
 		u32 b = prandom_u32_state(&rnd);
 		if (a <= b) {
@@ -40,7 +50,7 @@ static void init(void)
 			nodes[i].last = a;
 		}
 	}
-	for (i = 0; i < SEARCHES; i++)
+	for (i = 0; i < nsearches; i++)
 		queries[i] = prandom_u32_state(&rnd);
 }
 
@@ -50,6 +60,16 @@ static int interval_tree_test_init(void)
 	unsigned long results;
 	cycles_t time1, time2, time;
 
+	nodes = kmalloc(nnodes * sizeof(struct interval_tree_node), GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
+
+	queries = kmalloc(nsearches * sizeof(int), GFP_KERNEL);
+	if (!queries) {
+		kfree(nodes);
+		return -ENOMEM;
+	}
+
 	printk(KERN_ALERT "interval tree insert/remove");
 
 	prandom_seed_state(&rnd, 3141592653589793238ULL);
@@ -57,39 +77,42 @@ static int interval_tree_test_init(void)
 
 	time1 = get_cycles();
 
-	for (i = 0; i < PERF_LOOPS; i++) {
-		for (j = 0; j < NODES; j++)
+	for (i = 0; i < perf_loops; i++) {
+		for (j = 0; j < nnodes; j++)
 			interval_tree_insert(nodes + j, &root);
-		for (j = 0; j < NODES; j++)
+		for (j = 0; j < nnodes; j++)
 			interval_tree_remove(nodes + j, &root);
 	}
 
 	time2 = get_cycles();
 	time = time2 - time1;
 
-	time = div_u64(time, PERF_LOOPS);
+	time = div_u64(time, perf_loops);
 	printk(" -> %llu cycles\n", (unsigned long long)time);
 
 	printk(KERN_ALERT "interval tree search");
 
-	for (j = 0; j < NODES; j++)
+	for (j = 0; j < nnodes; j++)
 		interval_tree_insert(nodes + j, &root);
 
 	time1 = get_cycles();
 
 	results = 0;
-	for (i = 0; i < SEARCH_LOOPS; i++)
-		for (j = 0; j < SEARCHES; j++)
+	for (i = 0; i < search_loops; i++)
+		for (j = 0; j < nsearches; j++)
 			results += search(queries[j], &root);
 
 	time2 = get_cycles();
 	time = time2 - time1;
 
-	time = div_u64(time, SEARCH_LOOPS);
-	results = div_u64(results, SEARCH_LOOPS);
+	time = div_u64(time, search_loops);
+	results = div_u64(results, search_loops);
 	printk(" -> %llu cycles (%lu results)\n",
 	       (unsigned long long)time, results);
 
+	kfree(queries);
+	kfree(nodes);
+
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch
lib-interval_tree_test-make-test-options-module-parameters.patch
lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint.patch
lib-interval_tree_test-allow-full-tree-search.patch

