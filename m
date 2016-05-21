From: akpm@linux-foundation.org
Subject: [patch 114/162] radix-tree: fix several shrinking bugs with
 multiorder entries
Date: Fri, 20 May 2016 17:02:17 -0700
Message-ID: <573fa589.kosuJ0w8TejjIbow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbcEUACT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix several shrinking bugs with multiorder entries

Setting the indirect bit on the user data entry used to be unambiguous
because the tree walking code knew not to expect internal nodes in the
last level of the tree.  Multiorder entries can appear at any level of the
tree, and a leaf with the indirect bit set is indistinguishable from a
pointer to a node.

Introduce a special entry (RADIX_TREE_RETRY) which is neither a valid user
entry, nor a valid pointer to a node.  The radix_tree_deref_retry()
function continues to work the same way, but tree walking code can
distinguish it from a pointer to a node.

Also fix the condition for setting slot->parent to NULL; it does not
matter what height the tree is, it only matters whether slot is an
indirect pointer.  Move this code above the comment which is referring to
the assignment to root->rnode.

Also fix the condition for preventing the tree from shrinking to a single
entry if it's a multiorder entry.

Add a test-case to the test suite that checks that the tree goes back down
to its original height after an item is inserted & deleted from a higher
index in the tree.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |   23 +++++++-------
 tools/testing/radix-tree/multiorder.c |   39 ++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 11 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-several-shrinking-bugs-with-multiorder-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-several-shrinking-bugs-with-multiorder-entries
+++ a/lib/radix-tree.c
@@ -80,6 +80,8 @@ static inline void *indirect_to_ptr(void
 	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
 
+#define RADIX_TREE_RETRY	ptr_to_indirect(NULL)
+
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
 /* Sibling slots point directly to another slot in the same node */
 static inline bool is_sibling_entry(struct radix_tree_node *parent, void *node)
@@ -1443,6 +1445,14 @@ static inline void radix_tree_shrink(str
 		slot = to_free->slots[0];
 		if (!slot)
 			break;
+		if (!radix_tree_is_indirect_ptr(slot) && (root->height > 1))
+			break;
+
+		if (radix_tree_is_indirect_ptr(slot)) {
+			slot = indirect_to_ptr(slot);
+			slot->parent = NULL;
+			slot = ptr_to_indirect(slot);
+		}
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
@@ -1451,14 +1461,6 @@ static inline void radix_tree_shrink(str
 		 * (to_free->slots[0]), it will be safe to dereference the new
 		 * one (root->rnode) as far as dependent read barriers go.
 		 */
-		if (root->height > 1) {
-			if (!radix_tree_is_indirect_ptr(slot))
-				break;
-
-			slot = indirect_to_ptr(slot);
-			slot->parent = NULL;
-			slot = ptr_to_indirect(slot);
-		}
 		root->rnode = slot;
 		root->height--;
 
@@ -1480,9 +1482,8 @@ static inline void radix_tree_shrink(str
 		 * also results in a stale slot). So tag the slot as indirect
 		 * to force callers to retry.
 		 */
-		if (root->height == 0)
-			*((unsigned long *)&to_free->slots[0]) |=
-						RADIX_TREE_INDIRECT_PTR;
+		if (!radix_tree_is_indirect_ptr(slot))
+			to_free->slots[0] = RADIX_TREE_RETRY;
 
 		radix_tree_node_free(to_free);
 	}
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-fix-several-shrinking-bugs-with-multiorder-entries tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-fix-several-shrinking-bugs-with-multiorder-entries
+++ a/tools/testing/radix-tree/multiorder.c
@@ -46,6 +46,41 @@ static void multiorder_check(unsigned lo
 		item_check_absent(&tree, i);
 }
 
+static void multiorder_shrink(unsigned long index, int order)
+{
+	unsigned long i;
+	unsigned long max = 1 << order;
+	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_node *node;
+
+	printf("Multiorder shrink index %ld, order %d\n", index, order);
+
+	assert(item_insert_order(&tree, 0, order) == 0);
+
+	node = tree.rnode;
+
+	assert(item_insert(&tree, index) == 0);
+	assert(node != tree.rnode);
+
+	assert(item_delete(&tree, index) != 0);
+	assert(node == tree.rnode);
+
+	for (i = 0; i < max; i++) {
+		struct item *item = item_lookup(&tree, i);
+		assert(item != 0);
+		assert(item->index == 0);
+	}
+	for (i = max; i < 2*max; i++)
+		item_check_absent(&tree, i);
+
+	if (!item_delete(&tree, 0)) {
+		printf("failed to delete index %ld (order %d)\n", index, order);		abort();
+	}
+
+	for (i = 0; i < 2*max; i++)
+		item_check_absent(&tree, i);
+}
+
 void multiorder_checks(void)
 {
 	int i;
@@ -55,4 +90,8 @@ void multiorder_checks(void)
 		multiorder_check(0, i);
 		multiorder_check((1UL << i) + 1, i);
 	}
+
+	for (i = 0; i < 15; i++)
+		multiorder_shrink((1UL << (i + RADIX_TREE_MAP_SHIFT)), i);
+
 }
_
