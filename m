From: akpm@linux-foundation.org
Subject: [merged]
 lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:26:38 -0700
Message-ID: <20170711192638.Gp4bsOybh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdGKT0j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval_tree_test.c: allow users to limit scope of endpoint
has been removed from the -mm tree.  Its filename was
     lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/interval_tree_test.c: allow users to limit scope of endpoint

Add a 'max_endpoint' parameter such that users may easily limit the size
of the intervals that are randomly generated.

Link: http://lkml.kernel.org/r/20170518174936.20265-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN lib/interval_tree_test.c~lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint lib/interval_tree_test.c
--- a/lib/interval_tree_test.c~lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint
+++ a/lib/interval_tree_test.c
@@ -16,6 +16,7 @@ __param(int, perf_loops, 100000, "Number
 __param(int, nsearches, 100, "Number of searches to the interval tree");
 __param(int, search_loops, 10000, "Number of iterations searching the tree");
 
+__param(uint, max_endpoint, ~0, "Largest value for the interval's endpoint");
 
 static struct rb_root root = RB_ROOT;
 static struct interval_tree_node *nodes = NULL;
@@ -40,18 +41,20 @@ static void init(void)
 	int i;
 
 	for (i = 0; i < nnodes; i++) {
-		u32 a = prandom_u32_state(&rnd);
-		u32 b = prandom_u32_state(&rnd);
-		if (a <= b) {
-			nodes[i].start = a;
-			nodes[i].last = b;
-		} else {
-			nodes[i].start = b;
-			nodes[i].last = a;
-		}
+		u32 b = (prandom_u32_state(&rnd) >> 4) % max_endpoint;
+		u32 a = (prandom_u32_state(&rnd) >> 4) % b;
+
+		nodes[i].start = a;
+		nodes[i].last = b;
 	}
+
+	/*
+	 * Limit the search scope to what the user defined.
+	 * Otherwise we are merely measuring empty walks,
+	 * which is pointless.
+	 */
 	for (i = 0; i < nsearches; i++)
-		queries[i] = prandom_u32_state(&rnd);
+		queries[i] = (prandom_u32_state(&rnd) >> 4) % max_endpoint;
 }
 
 static int interval_tree_test_init(void)
_

Patches currently in -mm which might be from dave@stgolabs.net are

fs-kill-config_percpu_rwsem-some-more.patch

