From: akpm@linux-foundation.org
Subject: + radix-tree-make-radix_tree_descend-more-useful.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 23:05:05 -0700
Message-ID: <5711d611.oP0PNE14R9sUHpCh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbcDPGFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: make radix_tree_descend() more useful
has been added to the -mm tree.  Its filename is
     radix-tree-make-radix_tree_descend-more-useful.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-make-radix_tree_descend-more-useful.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-make-radix_tree_descend-more-useful.patch

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
Subject: radix-tree: make radix_tree_descend() more useful

Now that the shift amount is stored in the node, radix_tree_descend() can
calculate offset itself from index, which removes several lines of code
from each of the tree walkers.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   78 +++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 52 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-make-radix_tree_descend-more-useful lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-make-radix_tree_descend-more-useful
+++ a/lib/radix-tree.c
@@ -94,9 +94,10 @@ static inline unsigned long get_slot_off
 	return slot - parent->slots;
 }
 
-static unsigned radix_tree_descend(struct radix_tree_node *parent,
-				struct radix_tree_node **nodep, unsigned offset)
+static unsigned int radix_tree_descend(struct radix_tree_node *parent,
+			struct radix_tree_node **nodep, unsigned long index)
 {
+	unsigned int offset = (index >> parent->shift) & RADIX_TREE_MAP_MASK;
 	void **entry = rcu_dereference_raw(parent->slots[offset]);
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
@@ -536,8 +537,7 @@ int __radix_tree_create(struct radix_tre
 
 		/* Go a level down */
 		node = entry_to_node(child);
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		offset = radix_tree_descend(node, &child, offset);
+		offset = radix_tree_descend(node, &child, index);
 		slot = &node->slots[offset];
 	}
 
@@ -625,13 +625,12 @@ void *__radix_tree_lookup(struct radix_t
 {
 	struct radix_tree_node *node, *parent;
 	unsigned long maxindex;
-	unsigned int shift;
 	void **slot;
 
  restart:
 	parent = NULL;
 	slot = (void **)&root->rnode;
-	shift = radix_tree_load_root(root, &node, &maxindex);
+	radix_tree_load_root(root, &node, &maxindex);
 	if (index > maxindex)
 		return NULL;
 
@@ -641,9 +640,7 @@ void *__radix_tree_lookup(struct radix_t
 		if (node == RADIX_TREE_RETRY)
 			goto restart;
 		parent = entry_to_node(node);
-		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		offset = radix_tree_descend(parent, &node, offset);
+		offset = radix_tree_descend(parent, &node, index);
 		slot = parent->slots + offset;
 	}
 
@@ -713,19 +710,15 @@ void *radix_tree_tag_set(struct radix_tr
 {
 	struct radix_tree_node *node, *parent;
 	unsigned long maxindex;
-	unsigned int shift;
 
-	shift = radix_tree_load_root(root, &node, &maxindex);
+	radix_tree_load_root(root, &node, &maxindex);
 	BUG_ON(index > maxindex);
 
 	while (radix_tree_is_internal_node(node)) {
 		unsigned offset;
 
-		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-
 		parent = entry_to_node(node);
-		offset = radix_tree_descend(parent, &node, offset);
+		offset = radix_tree_descend(parent, &node, index);
 		BUG_ON(!node);
 
 		if (!tag_get(parent, tag, offset))
@@ -779,21 +772,17 @@ void *radix_tree_tag_clear(struct radix_
 {
 	struct radix_tree_node *node, *parent;
 	unsigned long maxindex;
-	unsigned int shift;
 	int uninitialized_var(offset);
 
-	shift = radix_tree_load_root(root, &node, &maxindex);
+	radix_tree_load_root(root, &node, &maxindex);
 	if (index > maxindex)
 		return NULL;
 
 	parent = NULL;
 
 	while (radix_tree_is_internal_node(node)) {
-		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-
 		parent = entry_to_node(node);
-		offset = radix_tree_descend(parent, &node, offset);
+		offset = radix_tree_descend(parent, &node, index);
 	}
 
 	if (node)
@@ -823,25 +812,21 @@ int radix_tree_tag_get(struct radix_tree
 {
 	struct radix_tree_node *node, *parent;
 	unsigned long maxindex;
-	unsigned int shift;
 
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	shift = radix_tree_load_root(root, &node, &maxindex);
+	radix_tree_load_root(root, &node, &maxindex);
 	if (index > maxindex)
 		return 0;
 	if (node == NULL)
 		return 0;
 
 	while (radix_tree_is_internal_node(node)) {
-		int offset;
-
-		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		unsigned offset;
 
 		parent = entry_to_node(node);
-		offset = radix_tree_descend(parent, &node, offset);
+		offset = radix_tree_descend(parent, &node, index);
 
 		if (!node)
 			return 0;
@@ -874,7 +859,7 @@ static inline void __set_iter_shift(stru
 void **radix_tree_next_chunk(struct radix_tree_root *root,
 			     struct radix_tree_iter *iter, unsigned flags)
 {
-	unsigned shift, tag = flags & RADIX_TREE_ITER_TAG_MASK;
+	unsigned tag = flags & RADIX_TREE_ITER_TAG_MASK;
 	struct radix_tree_node *node, *child;
 	unsigned long index, offset, maxindex;
 
@@ -895,7 +880,7 @@ void **radix_tree_next_chunk(struct radi
 		return NULL;
 
  restart:
-	shift = radix_tree_load_root(root, &child, &maxindex);
+	radix_tree_load_root(root, &child, &maxindex);
 	if (index > maxindex)
 		return NULL;
 	if (!child)
@@ -912,9 +897,7 @@ void **radix_tree_next_chunk(struct radi
 
 	do {
 		node = entry_to_node(child);
-		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		offset = radix_tree_descend(node, &child, offset);
+		offset = radix_tree_descend(node, &child, index);
 
 		if ((flags & RADIX_TREE_ITER_TAGGED) ?
 				!tag_get(node, tag, offset) : !child) {
@@ -936,7 +919,7 @@ void **radix_tree_next_chunk(struct radi
 						break;
 				}
 			index &= ~node_maxindex(node);
-			index += offset << shift;
+			index += offset << node->shift;
 			/* Overflow after ~0UL */
 			if (!index)
 				return NULL;
@@ -952,7 +935,7 @@ void **radix_tree_next_chunk(struct radi
 	/* Update the iterator state */
 	iter->index = (index &~ node_maxindex(node)) | (offset << node->shift);
 	iter->next_index = (index | node_maxindex(node)) + 1;
-	__set_iter_shift(iter, shift);
+	__set_iter_shift(iter, node->shift);
 
 	/* Construct iter->tags bit-mask from node->tags[tag] array */
 	if (flags & RADIX_TREE_ITER_TAGGED) {
@@ -1010,10 +993,10 @@ unsigned long radix_tree_range_tag_if_ta
 {
 	struct radix_tree_node *parent, *node, *child;
 	unsigned long maxindex;
-	unsigned int shift = radix_tree_load_root(root, &child, &maxindex);
 	unsigned long tagged = 0;
 	unsigned long index = *first_indexp;
 
+	radix_tree_load_root(root, &child, &maxindex);
 	last_index = min(last_index, maxindex);
 	if (index > last_index)
 		return 0;
@@ -1030,11 +1013,9 @@ unsigned long radix_tree_range_tag_if_ta
 	}
 
 	node = entry_to_node(child);
-	shift -= RADIX_TREE_MAP_SHIFT;
 
 	for (;;) {
-		unsigned offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		offset = radix_tree_descend(node, &child, offset);
+		unsigned offset = radix_tree_descend(node, &child, index);
 		if (!child)
 			goto next;
 		if (!tag_get(node, iftag, offset))
@@ -1042,7 +1023,6 @@ unsigned long radix_tree_range_tag_if_ta
 		/* Sibling slots never have tags set on them */
 		if (radix_tree_is_internal_node(child)) {
 			node = entry_to_node(child);
-			shift -= RADIX_TREE_MAP_SHIFT;
 			continue;
 		}
 
@@ -1063,12 +1043,12 @@ unsigned long radix_tree_range_tag_if_ta
 			tag_set(parent, settag, offset);
 		}
  next:
-		/* Go to next item at level determined by 'shift' */
-		index = ((index >> shift) + 1) << shift;
+		/* Go to next entry in node */
+		index = ((index >> node->shift) + 1) << node->shift;
 		/* Overflow can happen when last_index is ~0UL... */
 		if (index > last_index || !index)
 			break;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		offset = (index >> node->shift) & RADIX_TREE_MAP_MASK;
 		while (offset == 0) {
 			/*
 			 * We've fully scanned this node. Go up. Because
@@ -1076,8 +1056,7 @@ unsigned long radix_tree_range_tag_if_ta
 			 * we do below cannot wander astray.
 			 */
 			node = node->parent;
-			shift += RADIX_TREE_MAP_SHIFT;
-			offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+			offset = (index >> node->shift) & RADIX_TREE_MAP_MASK;
 		}
 		if (is_sibling_entry(node, node->slots[offset]))
 			goto next;
@@ -1275,13 +1254,10 @@ struct locate_info {
 static unsigned long __locate(struct radix_tree_node *slot, void *item,
 			      unsigned long index, struct locate_info *info)
 {
-	unsigned int shift;
 	unsigned long base, i;
 
-	shift = slot->shift + RADIX_TREE_MAP_SHIFT;
-
 	do {
-		shift -= RADIX_TREE_MAP_SHIFT;
+		unsigned int shift = slot->shift;
 		base = index & ~((1UL << shift) - 1);
 
 		for (i = (index >> shift) & RADIX_TREE_MAP_MASK;
@@ -1305,9 +1281,7 @@ static unsigned long __locate(struct rad
 			slot = node;
 			break;
 		}
-		if (i == RADIX_TREE_MAP_SIZE)
-			break;
-	} while (shift);
+	} while (i < RADIX_TREE_MAP_SIZE);
 
 out:
 	if ((index == 0) && (i == RADIX_TREE_MAP_SIZE))
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

