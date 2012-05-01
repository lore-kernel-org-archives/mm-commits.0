From: akpm@linux-foundation.org
Subject: + radix-tree-fix-preload-vector-size.patch added to -mm tree
Date: Tue, 01 May 2012 12:09:38 -0700
Message-ID: <20120501190938.9D7D3A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52867 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab2EATJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:09:40 -0400
Received: by qcsp5 with SMTP id p5so503420qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:09:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@kernel.dk


The patch titled
     Subject: radix-tree: fix preload vector size
has been added to the -mm tree.  Its filename is
     radix-tree-fix-preload-vector-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: radix-tree: fix preload vector size

Patches currently in -mm which might be from npiggin@kernel.dk are

radix-tree-fix-preload-vector-size.patch

