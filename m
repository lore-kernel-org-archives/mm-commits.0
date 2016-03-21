From: akpm@linux-foundation.org
Subject: [merged]
 radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:41:37 -0700
Message-ID: <56f04061.1EznghxT52cmYvjR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbcCUTVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: tag all internal tree nodes as indirect pointers
has been removed from the -mm tree.  Its filename was
     radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix_tree: tag all internal tree nodes as indirect pointers

Set the 'indirect_ptr' bit on all the pointers to internal nodes, not just
on the root node.  This enables the following patches to support
multi-order entries in the radix tree.  This patch is split out for ease
of bisection.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                |   24 ++++++++++++++++++------
 tools/testing/radix-tree/test.c |    5 +++--
 2 files changed, 21 insertions(+), 8 deletions(-)

diff -puN lib/radix-tree.c~radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers lib/radix-tree.c
--- a/lib/radix-tree.c~radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers
+++ a/lib/radix-tree.c
@@ -368,9 +368,10 @@ static int radix_tree_extend(struct radi
 		node->count = 1;
 		node->parent = NULL;
 		slot = root->rnode;
-		if (newheight > 1) {
+		if (radix_tree_is_indirect_ptr(slot) && newheight > 1) {
 			slot = indirect_to_ptr(slot);
 			slot->parent = node;
+			slot = ptr_to_indirect(slot);
 		}
 		node->slots[0] = slot;
 		node = ptr_to_indirect(node);
@@ -425,17 +426,20 @@ int __radix_tree_create(struct radix_tre
 			slot->path = height;
 			slot->parent = node;
 			if (node) {
-				rcu_assign_pointer(node->slots[offset], slot);
+				rcu_assign_pointer(node->slots[offset],
+							ptr_to_indirect(slot));
 				node->count++;
 				slot->path |= offset << RADIX_TREE_HEIGHT_SHIFT;
 			} else
-				rcu_assign_pointer(root->rnode, ptr_to_indirect(slot));
+				rcu_assign_pointer(root->rnode,
+							ptr_to_indirect(slot));
 		}
 
 		/* Go a level down */
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		node = slot;
 		slot = node->slots[offset];
+		slot = indirect_to_ptr(slot);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
 	}
@@ -533,6 +537,7 @@ void *__radix_tree_lookup(struct radix_t
 		node = rcu_dereference_raw(*slot);
 		if (node == NULL)
 			return NULL;
+		node = indirect_to_ptr(node);
 
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
@@ -619,6 +624,7 @@ void *radix_tree_tag_set(struct radix_tr
 			tag_set(slot, tag, offset);
 		slot = slot->slots[offset];
 		BUG_ON(slot == NULL);
+		slot = indirect_to_ptr(slot);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
 	}
@@ -658,11 +664,12 @@ void *radix_tree_tag_clear(struct radix_
 		goto out;
 
 	shift = height * RADIX_TREE_MAP_SHIFT;
-	slot = indirect_to_ptr(root->rnode);
+	slot = root->rnode;
 
 	while (shift) {
 		if (slot == NULL)
 			goto out;
+		slot = indirect_to_ptr(slot);
 
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
@@ -738,6 +745,7 @@ int radix_tree_tag_get(struct radix_tree
 
 		if (node == NULL)
 			return 0;
+		node = indirect_to_ptr(node);
 
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		if (!tag_get(node, tag, offset))
@@ -838,6 +846,7 @@ restart:
 		node = rcu_dereference_raw(node->slots[offset]);
 		if (node == NULL)
 			goto restart;
+		node = indirect_to_ptr(node);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 	}
@@ -939,6 +948,7 @@ unsigned long radix_tree_range_tag_if_ta
 			shift -= RADIX_TREE_MAP_SHIFT;
 			node = slot;
 			slot = slot->slots[offset];
+			slot = indirect_to_ptr(slot);
 			continue;
 		}
 
@@ -1195,6 +1205,7 @@ static unsigned long __locate(struct rad
 		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			goto out;
+		slot = indirect_to_ptr(slot);
 	}
 
 	/* Bottom level: check items */
@@ -1278,7 +1289,8 @@ static inline void radix_tree_shrink(str
 		 */
 		if (to_free->count != 1)
 			break;
-		if (!to_free->slots[0])
+		slot = to_free->slots[0];
+		if (!slot)
 			break;
 
 		/*
@@ -1288,8 +1300,8 @@ static inline void radix_tree_shrink(str
 		 * (to_free->slots[0]), it will be safe to dereference the new
 		 * one (root->rnode) as far as dependent read barriers go.
 		 */
-		slot = to_free->slots[0];
 		if (root->height > 1) {
+			slot = indirect_to_ptr(slot);
 			slot->parent = NULL;
 			slot = ptr_to_indirect(slot);
 		}
diff -puN tools/testing/radix-tree/test.c~radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers
+++ a/tools/testing/radix-tree/test.c
@@ -142,6 +142,8 @@ static int verify_node(struct radix_tree
 	int i;
 	int j;
 
+	slot = indirect_to_ptr(slot);
+
 	/* Verify consistency at this level */
 	for (i = 0; i < RADIX_TREE_TAG_LONGS; i++) {
 		if (slot->tags[tag][i]) {
@@ -184,8 +186,7 @@ void verify_tag_consistency(struct radix
 {
 	if (!root->height)
 		return;
-	verify_node(indirect_to_ptr(root->rnode),
-			tag, root->height, !!root_tag_get(root, tag));
+	verify_node(root->rnode, tag, root->height, !!root_tag_get(root, tag));
 }
 
 void item_kill_tree(struct radix_tree_root *root)
_

Patches currently in -mm which might be from willy@linux.intel.com are


