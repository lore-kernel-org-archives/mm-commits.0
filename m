From: akpm@linux-foundation.org
Subject: [patch 38/94] lib/rbtree-test: lower default params
Date: Fri, 17 Nov 2017 15:28:27 -0800
Message-ID: <20171117232827.41XucPWMD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964924AbdKQX23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, fengguang.wu@intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/rbtree-test: lower default params

Fengguang reported soft lockups while running the rbtree and interval tree
test modules.  The logic for these tests all occur in init phase, and we
currently are pounding with the default values for number of nodes and
number of iterations of each test.  Reduce the latter by two orders of
magnitude.  This does not influence the value of the tests in that one
thousand times by default is enough to get the picture.

Link: http://lkml.kernel.org/r/20171109161715.xai2dtwqw2frhkcm@linux-n805
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |    4 ++--
 lib/rbtree_test.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/interval_tree_test.c~lib-rbtree-test-lower-default-params lib/interval_tree_test.c
--- a/lib/interval_tree_test.c~lib-rbtree-test-lower-default-params
+++ a/lib/interval_tree_test.c
@@ -11,10 +11,10 @@
 	MODULE_PARM_DESC(name, msg);
 
 __param(int, nnodes, 100, "Number of nodes in the interval tree");
-__param(int, perf_loops, 100000, "Number of iterations modifying the tree");
+__param(int, perf_loops, 1000, "Number of iterations modifying the tree");
 
 __param(int, nsearches, 100, "Number of searches to the interval tree");
-__param(int, search_loops, 10000, "Number of iterations searching the tree");
+__param(int, search_loops, 1000, "Number of iterations searching the tree");
 __param(bool, search_all, false, "Searches will iterate all nodes in the tree");
 
 __param(uint, max_endpoint, ~0, "Largest value for the interval's endpoint");
diff -puN lib/rbtree_test.c~lib-rbtree-test-lower-default-params lib/rbtree_test.c
--- a/lib/rbtree_test.c~lib-rbtree-test-lower-default-params
+++ a/lib/rbtree_test.c
@@ -11,7 +11,7 @@
 	MODULE_PARM_DESC(name, msg);
 
 __param(int, nnodes, 100, "Number of nodes in the rb-tree");
-__param(int, perf_loops, 100000, "Number of iterations modifying the rb-tree");
+__param(int, perf_loops, 1000, "Number of iterations modifying the rb-tree");
 __param(int, check_loops, 100, "Number of iterations modifying and verifying the rb-tree");
 
 struct test_node {
_
