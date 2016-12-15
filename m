From: akpm@linux-foundation.org
Subject: [merged] radix-tree-ensure-counts-are-initialised.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:49:28 -0800
Message-ID: <5852e5b8.M+9buldYATUXqmiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754318AbcLOSt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: ensure counts are initialised
has been removed from the -mm tree.  Its filename was
     radix-tree-ensure-counts-are-initialised.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix-tree: ensure counts are initialised

radix_tree_join() was freeing nodes with a non-zero ->exceptional count,
and radix_tree_split() wasn't zeroing ->exceptional when it allocated the
new node.  Fix this by making all callers of radix_tree_node_alloc() pass
in the new counts (and some other always-initialised fields), which will
prevent the problem recurring if in future we decide to do something
similar.

Link: http://lkml.kernel.org/r/1481667692-14500-3-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |   41 ++++++++++-----------
 tools/testing/radix-tree/multiorder.c |   45 +++++++++++++++++++++---
 2 files changed, 61 insertions(+), 25 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-ensure-counts-are-initialised lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-ensure-counts-are-initialised
+++ a/lib/radix-tree.c
@@ -288,7 +288,10 @@ static void radix_tree_dump(struct radix
  * that the caller has pinned this thread of control to the current CPU.
  */
 static struct radix_tree_node *
-radix_tree_node_alloc(struct radix_tree_root *root)
+radix_tree_node_alloc(struct radix_tree_root *root,
+			struct radix_tree_node *parent,
+			unsigned int shift, unsigned int offset,
+			unsigned int count, unsigned int exceptional)
 {
 	struct radix_tree_node *ret = NULL;
 	gfp_t gfp_mask = root_gfp_mask(root);
@@ -333,6 +336,13 @@ radix_tree_node_alloc(struct radix_tree_
 	ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 out:
 	BUG_ON(radix_tree_is_internal_node(ret));
+	if (ret) {
+		ret->parent = parent;
+		ret->shift = shift;
+		ret->offset = offset;
+		ret->count = count;
+		ret->exceptional = exceptional;
+	}
 	return ret;
 }
 
@@ -538,8 +548,8 @@ static int radix_tree_extend(struct radi
 		goto out;
 
 	do {
-		struct radix_tree_node *node = radix_tree_node_alloc(root);
-
+		struct radix_tree_node *node = radix_tree_node_alloc(root,
+							NULL, shift, 0, 1, 0);
 		if (!node)
 			return -ENOMEM;
 
@@ -550,16 +560,11 @@ static int radix_tree_extend(struct radi
 		}
 
 		BUG_ON(shift > BITS_PER_LONG);
-		node->shift = shift;
-		node->offset = 0;
-		node->count = 1;
-		node->parent = NULL;
 		if (radix_tree_is_internal_node(slot)) {
 			entry_to_node(slot)->parent = node;
-		} else {
+		} else if (radix_tree_exceptional_entry(slot)) {
 			/* Moving an exceptional root->rnode to a node */
-			if (radix_tree_exceptional_entry(slot))
-				node->exceptional = 1;
+			node->exceptional = 1;
 		}
 		node->slots[0] = slot;
 		slot = node_to_entry(node);
@@ -712,14 +717,10 @@ int __radix_tree_create(struct radix_tre
 		shift -= RADIX_TREE_MAP_SHIFT;
 		if (child == NULL) {
 			/* Have to add a child node.  */
-			child = radix_tree_node_alloc(root);
+			child = radix_tree_node_alloc(root, node, shift,
+							offset, 0, 0);
 			if (!child)
 				return -ENOMEM;
-			child->shift = shift;
-			child->offset = offset;
-			child->count = 0;
-			child->exceptional = 0;
-			child->parent = node;
 			rcu_assign_pointer(*slot, node_to_entry(child));
 			if (node)
 				node->count++;
@@ -1209,13 +1210,11 @@ int radix_tree_split(struct radix_tree_r
 
 	for (;;) {
 		if (node->shift > order) {
-			child = radix_tree_node_alloc(root);
+			child = radix_tree_node_alloc(root, node,
+					node->shift - RADIX_TREE_MAP_SHIFT,
+					offset, 0, 0);
 			if (!child)
 				goto nomem;
-			child->shift = node->shift - RADIX_TREE_MAP_SHIFT;
-			child->offset = offset;
-			child->count = 0;
-			child->parent = node;
 			if (node != parent) {
 				node->count++;
 				node->slots[offset] = node_to_entry(child);
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-ensure-counts-are-initialised tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-ensure-counts-are-initialised
+++ a/tools/testing/radix-tree/multiorder.c
@@ -355,7 +355,7 @@ void multiorder_tagged_iteration(void)
 	item_kill_tree(&tree);
 }
 
-static void __multiorder_join(unsigned long index,
+static void multiorder_join1(unsigned long index,
 				unsigned order1, unsigned order2)
 {
 	unsigned long loc;
@@ -373,7 +373,7 @@ static void __multiorder_join(unsigned l
 	item_kill_tree(&tree);
 }
 
-static void __multiorder_join2(unsigned order1, unsigned order2)
+static void multiorder_join2(unsigned order1, unsigned order2)
 {
 	RADIX_TREE(tree, GFP_KERNEL);
 	struct radix_tree_node *node;
@@ -393,6 +393,39 @@ static void __multiorder_join2(unsigned
 	item_kill_tree(&tree);
 }
 
+/*
+ * This test revealed an accounting bug for exceptional entries at one point.
+ * Nodes were being freed back into the pool with an elevated exception count
+ * by radix_tree_join() and then radix_tree_split() was failing to zero the
+ * count of exceptional entries.
+ */
+static void multiorder_join3(unsigned int order)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_node *node;
+	void **slot;
+	struct radix_tree_iter iter;
+	unsigned long i;
+
+	for (i = 0; i < (1 << order); i++) {
+		radix_tree_insert(&tree, i, (void *)0x12UL);
+	}
+
+	radix_tree_join(&tree, 0, order, (void *)0x16UL);
+	rcu_barrier();
+
+	radix_tree_split(&tree, 0, 0);
+
+	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
+		radix_tree_iter_replace(&tree, &iter, slot, (void *)0x12UL);
+	}
+
+	__radix_tree_lookup(&tree, 0, &node, NULL);
+	assert(node->exceptional == node->count);
+
+	item_kill_tree(&tree);
+}
+
 static void multiorder_join(void)
 {
 	int i, j, idx;
@@ -400,16 +433,20 @@ static void multiorder_join(void)
 	for (idx = 0; idx < 1024; idx = idx * 2 + 3) {
 		for (i = 1; i < 15; i++) {
 			for (j = 0; j < i; j++) {
-				__multiorder_join(idx, i, j);
+				multiorder_join1(idx, i, j);
 			}
 		}
 	}
 
 	for (i = 1; i < 15; i++) {
 		for (j = 0; j < i; j++) {
-			__multiorder_join2(i, j);
+			multiorder_join2(i, j);
 		}
 	}
+
+	for (i = 3; i < 10; i++) {
+		multiorder_join3(i);
+	}
 }
 
 static void check_mem(unsigned old_order, unsigned new_order, unsigned alloc)
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch

