From: akpm@linux-foundation.org
Subject: + radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 23:04:51 -0700
Message-ID: <5711d603.qA35mGDVsRc8zKXR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rename indirect_to_ptr() to entry_to_node()
has been added to the -mm tree.  Its filename is
     radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rename indirect_to_ptr() to entry_to_node()

Mirrors the earlier commit introducing node_to_entry().

Also change the type returned to be a struct radix_tree_node pointer. 
That lets us simplify a couple of places in the radix tree shrink & extend
paths where we could convert an entry into a pointer, modify the node,
then convert the pointer back into an entry.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h      |   12 +++----
 lib/radix-tree.c                |   48 +++++++++++++-----------------
 tools/testing/radix-tree/test.c |    4 +-
 tools/testing/radix-tree/test.h |    1 
 4 files changed, 28 insertions(+), 37 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-rename-indirect_to_ptr-to-entry_to_node include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-rename-indirect_to_ptr-to-entry_to_node
+++ a/include/linux/radix-tree.h
@@ -442,7 +442,7 @@ radix_tree_chunk_size(struct radix_tree_
 	return (iter->next_index - iter->index) >> iter_shift(iter);
 }
 
-static inline void *indirect_to_ptr(void *ptr)
+static inline struct radix_tree_node *entry_to_node(void *ptr)
 {
 	return (void *)((unsigned long)ptr & ~RADIX_TREE_INTERNAL_NODE);
 }
@@ -469,7 +469,7 @@ radix_tree_next_slot(void **slot, struct
 			return NULL;
 		while (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
 					radix_tree_is_indirect_ptr(slot[1])) {
-			if (indirect_to_ptr(slot[1]) == canon) {
+			if (entry_to_node(slot[1]) == canon) {
 				iter->tags >>= 1;
 				iter->index = __radix_tree_iter_add(iter, 1);
 				slot++;
@@ -499,12 +499,10 @@ radix_tree_next_slot(void **slot, struct
 
 			if (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
 			    radix_tree_is_indirect_ptr(*slot)) {
-				if (indirect_to_ptr(*slot) == canon)
+				if (entry_to_node(*slot) == canon)
 					continue;
-				else {
-					iter->next_index = iter->index;
-					break;
-				}
+				iter->next_index = iter->index;
+				break;
 			}
 
 			if (likely(*slot))
diff -puN lib/radix-tree.c~radix-tree-rename-indirect_to_ptr-to-entry_to_node lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rename-indirect_to_ptr-to-entry_to_node
+++ a/lib/radix-tree.c
@@ -230,13 +230,13 @@ static void dump_node(struct radix_tree_
 		if (is_sibling_entry(node, entry)) {
 			pr_debug("radix sblng %p offset %ld val %p indices %ld-%ld\n",
 					entry, i,
-					*(void **)indirect_to_ptr(entry),
+					*(void **)entry_to_node(entry),
 					first, last);
 		} else if (!radix_tree_is_indirect_ptr(entry)) {
 			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
 					entry, i, first, last);
 		} else {
-			dump_node(indirect_to_ptr(entry), first);
+			dump_node(entry_to_node(entry), first);
 		}
 	}
 }
@@ -249,7 +249,7 @@ static void radix_tree_dump(struct radix
 			root->gfp_mask >> __GFP_BITS_SHIFT);
 	if (!radix_tree_is_indirect_ptr(root->rnode))
 		return;
-	dump_node(indirect_to_ptr(root->rnode), 0);
+	dump_node(entry_to_node(root->rnode), 0);
 }
 #endif
 
@@ -422,7 +422,7 @@ static unsigned radix_tree_load_root(str
 	*nodep = node;
 
 	if (likely(radix_tree_is_indirect_ptr(node))) {
-		node = indirect_to_ptr(node);
+		node = entry_to_node(node);
 		*maxindex = node_maxindex(node);
 		return node->shift + RADIX_TREE_MAP_SHIFT;
 	}
@@ -467,11 +467,8 @@ static int radix_tree_extend(struct radi
 		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
-		if (radix_tree_is_indirect_ptr(slot)) {
-			slot = indirect_to_ptr(slot);
-			slot->parent = node;
-			slot = node_to_entry(slot);
-		}
+		if (radix_tree_is_indirect_ptr(slot))
+			entry_to_node(slot)->parent = node;
 		node->slots[0] = slot;
 		slot = node_to_entry(node);
 		rcu_assign_pointer(root->rnode, slot);
@@ -542,7 +539,7 @@ int __radix_tree_create(struct radix_tre
 			break;
 
 		/* Go a level down */
-		node = indirect_to_ptr(slot);
+		node = entry_to_node(slot);
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		offset = radix_tree_descend(node, &slot, offset);
 	}
@@ -645,7 +642,7 @@ void *__radix_tree_lookup(struct radix_t
 
 		if (node == RADIX_TREE_RETRY)
 			goto restart;
-		parent = indirect_to_ptr(node);
+		parent = entry_to_node(node);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		offset = radix_tree_descend(parent, &node, offset);
@@ -729,7 +726,7 @@ void *radix_tree_tag_set(struct radix_tr
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
-		parent = indirect_to_ptr(node);
+		parent = entry_to_node(node);
 		offset = radix_tree_descend(parent, &node, offset);
 		BUG_ON(!node);
 
@@ -777,7 +774,7 @@ void *radix_tree_tag_clear(struct radix_
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
-		parent = indirect_to_ptr(node);
+		parent = entry_to_node(node);
 		offset = radix_tree_descend(parent, &node, offset);
 	}
 
@@ -844,7 +841,7 @@ int radix_tree_tag_get(struct radix_tree
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
-		parent = indirect_to_ptr(node);
+		parent = entry_to_node(node);
 		offset = radix_tree_descend(parent, &node, offset);
 
 		if (!node)
@@ -904,7 +901,7 @@ void **radix_tree_next_chunk(struct radi
 		return NULL;
 
 	if (radix_tree_is_indirect_ptr(rnode)) {
-		rnode = indirect_to_ptr(rnode);
+		rnode = entry_to_node(rnode);
 	} else if (rnode) {
 		/* Single-slot tree */
 		iter->index = index;
@@ -963,7 +960,7 @@ void **radix_tree_next_chunk(struct radi
 		if (!radix_tree_is_indirect_ptr(slot))
 			break;
 
-		node = indirect_to_ptr(slot);
+		node = entry_to_node(slot);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 	}
@@ -1048,7 +1045,7 @@ unsigned long radix_tree_range_tag_if_ta
 		return 1;
 	}
 
-	node = indirect_to_ptr(slot);
+	node = entry_to_node(slot);
 	shift -= RADIX_TREE_MAP_SHIFT;
 
 	for (;;) {
@@ -1063,7 +1060,7 @@ unsigned long radix_tree_range_tag_if_ta
 			goto next;
 		/* Sibling slots never have tags set on them */
 		if (radix_tree_is_indirect_ptr(slot)) {
-			node = indirect_to_ptr(slot);
+			node = entry_to_node(slot);
 			shift -= RADIX_TREE_MAP_SHIFT;
 			continue;
 		}
@@ -1323,7 +1320,7 @@ static unsigned long __locate(struct rad
 				}
 				continue;
 			}
-			node = indirect_to_ptr(node);
+			node = entry_to_node(node);
 			if (is_sibling_entry(slot, node))
 				continue;
 			slot = node;
@@ -1368,7 +1365,7 @@ unsigned long radix_tree_locate_item(str
 			break;
 		}
 
-		node = indirect_to_ptr(node);
+		node = entry_to_node(node);
 
 		max_index = node_maxindex(node);
 		if (cur_index > max_index) {
@@ -1404,7 +1401,7 @@ static inline bool radix_tree_shrink(str
 
 		if (!radix_tree_is_indirect_ptr(to_free))
 			break;
-		to_free = indirect_to_ptr(to_free);
+		to_free = entry_to_node(to_free);
 
 		/*
 		 * The candidate node has more than one child, or its child
@@ -1419,11 +1416,8 @@ static inline bool radix_tree_shrink(str
 		if (!radix_tree_is_indirect_ptr(slot) && to_free->shift)
 			break;
 
-		if (radix_tree_is_indirect_ptr(slot)) {
-			slot = indirect_to_ptr(slot);
-			slot->parent = NULL;
-			slot = node_to_entry(slot);
-		}
+		if (radix_tree_is_indirect_ptr(slot))
+			entry_to_node(slot)->parent = NULL;
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
@@ -1482,7 +1476,7 @@ bool __radix_tree_delete_node(struct rad
 		struct radix_tree_node *parent;
 
 		if (node->count) {
-			if (node == indirect_to_ptr(root->rnode))
+			if (node == entry_to_node(root->rnode))
 				deleted |= radix_tree_shrink(root);
 			return deleted;
 		}
diff -puN tools/testing/radix-tree/test.c~radix-tree-rename-indirect_to_ptr-to-entry_to_node tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-rename-indirect_to_ptr-to-entry_to_node
+++ a/tools/testing/radix-tree/test.c
@@ -149,7 +149,7 @@ static int verify_node(struct radix_tree
 	int i;
 	int j;
 
-	slot = indirect_to_ptr(slot);
+	slot = entry_to_node(slot);
 
 	/* Verify consistency at this level */
 	for (i = 0; i < RADIX_TREE_TAG_LONGS; i++) {
@@ -227,7 +227,7 @@ void tree_verify_min_height(struct radix
 		return;
 	}
 
-	node = indirect_to_ptr(node);
+	node = entry_to_node(node);
 	assert(maxindex <= node_maxindex(node));
 
 	shift = node->shift;
diff -puN tools/testing/radix-tree/test.h~radix-tree-rename-indirect_to_ptr-to-entry_to_node tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-rename-indirect_to_ptr-to-entry_to_node
+++ a/tools/testing/radix-tree/test.h
@@ -39,7 +39,6 @@ void verify_tag_consistency(struct radix
 extern int nr_allocated;
 
 /* Normally private parts of lib/radix-tree.c */
-void *indirect_to_ptr(void *ptr);
 void radix_tree_dump(struct radix_tree_root *root);
 int root_tag_get(struct radix_tree_root *root, unsigned int tag);
 unsigned long node_maxindex(struct radix_tree_node *);
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-introduce-radix_tree_empty.patch
radix-tree-test-suite-fix-build.patch
radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch
introduce-config_radix_tree_multiorder.patch
radix-tree-add-missing-sibling-entry-functionality.patch
radix-tree-fix-sibling-entry-insertion.patch
radix-tree-fix-deleting-a-multi-order-entry-through-an-alias.patch
radix-tree-remove-restriction-on-multi-order-entries.patch
radix-tree-introduce-radix_tree_load_root.patch
radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch
radix-tree-test-suite-start-adding-multiorder-tests.patch
radix-tree-fix-several-shrinking-bugs-with-multiorder-entries.patch
radix-tree-rewrite-__radix_tree_lookup.patch
radix-tree-fix-multiorder-bug_on-in-radix_tree_insert.patch
radix-tree-fix-radix_tree_create-for-sibling-entries.patch
radix-tree-rewrite-radix_tree_locate_item.patch
radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch
radix-tree-add-copyright-statements.patch
drivers-hwspinlock-use-correct-radix-tree-api.patch
radix-tree-miscellaneous-fixes.patch
radix-tree-split-node-path-into-offset-and-height.patch
radix-tree-replace-node-height-with-node-shift.patch
radix-tree-remove-a-use-of-root-height-from-delete_node.patch
radix-tree-test-suite-remove-dependencies-on-height.patch
radix-tree-remove-root-height.patch
radix-tree-rename-indirect_ptr-to-internal_node.patch
radix-tree-rename-ptr_to_indirect-to-node_to_entry.patch
radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch
radix-tree-rename-radix_tree_is_indirect_ptr.patch
radix-tree-change-naming-conventions-in-radix_tree_shrink.patch
radix-tree-tidy-up-next_chunk.patch
radix-tree-tidy-up-range_tag_if_tagged.patch
radix-tree-tidy-up-__radix_tree_create.patch
radix-tree-introduce-radix_tree_replace_clear_tags.patch
radix-tree-make-radix_tree_descend-more-useful.patch
radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

