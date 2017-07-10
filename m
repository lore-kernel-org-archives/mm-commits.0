From: akpm@linux-foundation.org
Subject: [patch 093/115] lib/interval_tree_test.c: allow full tree
 search
Date: Mon, 10 Jul 2017 15:51:52 -0700
Message-ID: <20170710225152.0zZPyYO-L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43484 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754848AbdGJWvx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/interval_tree_test.c: allow full tree search

...  such that a user can specify visiting all the nodes in the tree
(intersects with the world).  This is a nice opposite from the very basic
default query which is a single point.

Link: http://lkml.kernel.org/r/20170518174936.20265-5-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN lib/interval_tree_test.c~lib-interval_tree_test-allow-full-tree-search lib/interval_tree_test.c
--- a/lib/interval_tree_test.c~lib-interval_tree_test-allow-full-tree-search
+++ a/lib/interval_tree_test.c
@@ -15,6 +15,7 @@ __param(int, perf_loops, 100000, "Number
 
 __param(int, nsearches, 100, "Number of searches to the interval tree");
 __param(int, search_loops, 10000, "Number of iterations searching the tree");
+__param(bool, search_all, false, "Searches will iterate all nodes in the tree");
 
 __param(uint, max_endpoint, ~0, "Largest value for the interval's endpoint");
 
@@ -25,13 +26,13 @@ static u32 *queries = NULL;
 static struct rnd_state rnd;
 
 static inline unsigned long
-search(unsigned long query, struct rb_root *root)
+search(struct rb_root *root, unsigned long start, unsigned long last)
 {
 	struct interval_tree_node *node;
 	unsigned long results = 0;
 
-	for (node = interval_tree_iter_first(root, query, query); node;
-	     node = interval_tree_iter_next(node, query, query))
+	for (node = interval_tree_iter_first(root, start, last); node;
+	     node = interval_tree_iter_next(node, start, last))
 		results++;
 	return results;
 }
@@ -102,8 +103,12 @@ static int interval_tree_test_init(void)
 
 	results = 0;
 	for (i = 0; i < search_loops; i++)
-		for (j = 0; j < nsearches; j++)
-			results += search(queries[j], &root);
+		for (j = 0; j < nsearches; j++) {
+			unsigned long start = search_all ? 0 : queries[j];
+			unsigned long last = search_all ? max_endpoint : queries[j];
+
+			results += search(&root, start, last);
+		}
 
 	time2 = get_cycles();
 	time = time2 - time1;
_
