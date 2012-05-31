From: akpm@linux-foundation.org
Subject: [merged] radix-tree-fix-preload-vector-size.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:12 -0700
Message-ID: <20120531192012.51A97A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52141 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EaTUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:13 -0400
Received: by qcsp5 with SMTP id p5so137051qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix preload vector size
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-preload-vector-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Nick Piggin <npiggin@kernel.dk>
Subject: radix-tree: fix preload vector size

We are not preallocating a sufficient number of nodes.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix-tree-fix-preload-vector-size lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-preload-vector-size
+++ a/lib/radix-tree.c
@@ -73,11 +73,24 @@ static unsigned long height_to_maxindex[
 static struct kmem_cache *radix_tree_node_cachep;
 
 /*
+ * The radix tree is variable-height, so an insert operation not only has
+ * to build the branch to its corresponding item, it also has to build the
+ * branch to existing items if the size has to be increased (by
+ * radix_tree_extend).
+ *
+ * The worst case is a zero height tree with just a single item at index 0,
+ * and then inserting an item at index ULONG_MAX. This requires 2 new branches
+ * of RADIX_TREE_MAX_PATH size to be created, with only the root node shared.
+ * Hence:
+ */
+#define RADIX_TREE_PRELOAD_SIZE (RADIX_TREE_MAX_PATH * 2 - 1)
+
+/*
  * Per-cpu pool of preloaded nodes
  */
 struct radix_tree_preload {
 	int nr;
-	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
+	struct radix_tree_node *nodes[RADIX_TREE_PRELOAD_SIZE];
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
_

Patches currently in -mm which might be from npiggin@kernel.dk are

origin.patch
linux-next.patch

