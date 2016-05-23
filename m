From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:50:24 -0700
Message-ID: <57435f00.jXFRQxA+X0re6UsP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbcEWTuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix radix_tree_range_tag_if_tagged() for multiorder entries
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix radix_tree_range_tag_if_tagged() for multiorder entries

I had previously decided that tagging a single multiorder entry would
count as tagging 2^order entries for the purposes of 'nr_to_tag'.  I now
believe that decision to be a mistake, and it should count as a single
entry.  That's more likely to be what callers expect.

When walking back up the tree from a newly-tagged entry, the current code
assumed we were starting from the lowest level of the tree; if we have a
multiorder entry with an order at least RADIX_TREE_MAP_SHIFT in size then
we need to shift the index by 'shift' before we start walking back up the
tree, or we will end up not setting tags on higher entries, and then
mistakenly thinking that entries below a certain point in the tree are not
tagged.

If the first index we examine is a sibling entry of a tagged multiorder
entry, we were not tagging it.  We need to examine the canonical entry,
and the easiest way to do that is to use radix_tree_descend().  We then
have to skip over sibling slots when looking for the next entry in the
tree or we will end up walking back to the canonical entry.

Add several tests for radix_tree_range_tag_if_tagged().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |   76 ++++++++++--------------
 tools/testing/radix-tree/multiorder.c |   25 +++++++
 tools/testing/radix-tree/tag_check.c  |   10 +++
 3 files changed, 67 insertions(+), 44 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries
+++ a/lib/radix-tree.c
@@ -1033,14 +1033,13 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned long nr_to_tag,
 		unsigned int iftag, unsigned int settag)
 {
-	unsigned int height = root->height;
-	struct radix_tree_node *node = NULL;
-	struct radix_tree_node *slot;
-	unsigned int shift;
+	struct radix_tree_node *slot, *node = NULL;
+	unsigned long maxindex;
+	unsigned int shift = radix_tree_load_root(root, &slot, &maxindex);
 	unsigned long tagged = 0;
 	unsigned long index = *first_indexp;
 
-	last_index = min(last_index, radix_tree_maxindex(height));
+	last_index = min(last_index, maxindex);
 	if (index > last_index)
 		return 0;
 	if (!nr_to_tag)
@@ -1049,80 +1048,71 @@ unsigned long radix_tree_range_tag_if_ta
 		*first_indexp = last_index + 1;
 		return 0;
 	}
-	if (height == 0) {
+	if (!radix_tree_is_indirect_ptr(slot)) {
 		*first_indexp = last_index + 1;
 		root_tag_set(root, settag);
 		return 1;
 	}
 
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	slot = indirect_to_ptr(root->rnode);
+	node = indirect_to_ptr(slot);
+	shift -= RADIX_TREE_MAP_SHIFT;
 
 	for (;;) {
 		unsigned long upindex;
-		int offset;
+		unsigned offset;
 
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		if (!slot->slots[offset])
+		offset = radix_tree_descend(node, &slot, offset);
+		if (!slot)
 			goto next;
-		if (!tag_get(slot, iftag, offset))
+		if (!tag_get(node, iftag, offset))
 			goto next;
-		if (shift) {
-			node = slot;
-			slot = slot->slots[offset];
-			if (radix_tree_is_indirect_ptr(slot)) {
-				slot = indirect_to_ptr(slot);
-				shift -= RADIX_TREE_MAP_SHIFT;
-				continue;
-			} else {
-				slot = node;
-				node = node->parent;
-			}
+		/* Sibling slots never have tags set on them */
+		if (radix_tree_is_indirect_ptr(slot)) {
+			node = indirect_to_ptr(slot);
+			shift -= RADIX_TREE_MAP_SHIFT;
+			continue;
 		}
 
 		/* tag the leaf */
-		tagged += 1 << shift;
-		tag_set(slot, settag, offset);
+		tagged++;
+		tag_set(node, settag, offset);
 
+		slot = node->parent;
 		/* walk back up the path tagging interior nodes */
-		upindex = index;
-		while (node) {
+		upindex = index >> shift;
+		while (slot) {
 			upindex >>= RADIX_TREE_MAP_SHIFT;
 			offset = upindex & RADIX_TREE_MAP_MASK;
 
 			/* stop if we find a node with the tag already set */
-			if (tag_get(node, settag, offset))
+			if (tag_get(slot, settag, offset))
 				break;
-			tag_set(node, settag, offset);
-			node = node->parent;
+			tag_set(slot, settag, offset);
+			slot = slot->parent;
 		}
 
-		/*
-		 * Small optimization: now clear that node pointer.
-		 * Since all of this slot's ancestors now have the tag set
-		 * from setting it above, we have no further need to walk
-		 * back up the tree setting tags, until we update slot to
-		 * point to another radix_tree_node.
-		 */
-		node = NULL;
-
-next:
+ next:
 		/* Go to next item at level determined by 'shift' */
 		index = ((index >> shift) + 1) << shift;
 		/* Overflow can happen when last_index is ~0UL... */
 		if (index > last_index || !index)
 			break;
-		if (tagged >= nr_to_tag)
-			break;
-		while (((index >> shift) & RADIX_TREE_MAP_MASK) == 0) {
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		while (offset == 0) {
 			/*
 			 * We've fully scanned this node. Go up. Because
 			 * last_index is guaranteed to be in the tree, what
 			 * we do below cannot wander astray.
 			 */
-			slot = slot->parent;
+			node = node->parent;
 			shift += RADIX_TREE_MAP_SHIFT;
+			offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		}
+		if (is_sibling_entry(node, node->slots[offset]))
+			goto next;
+		if (tagged >= nr_to_tag)
+			break;
 	}
 	/*
 	 * We need not to tag the root tag if there is no tag which is set with
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries
+++ a/tools/testing/radix-tree/multiorder.c
@@ -26,6 +26,7 @@ static void __multiorder_tag_test(int in
 {
 	RADIX_TREE(tree, GFP_KERNEL);
 	int base, err, i;
+	unsigned long first = 0;
 
 	/* our canonical entry */
 	base = index & ~((1 << order) - 1);
@@ -59,13 +60,16 @@ static void __multiorder_tag_test(int in
 		assert(!radix_tree_tag_get(&tree, i, 1));
 	}
 
+	assert(radix_tree_range_tag_if_tagged(&tree, &first, ~0UL, 10, 0, 1) == 1);
 	assert(radix_tree_tag_clear(&tree, index, 0));
 
 	for_each_index(i, base, order) {
 		assert(!radix_tree_tag_get(&tree, i, 0));
-		assert(!radix_tree_tag_get(&tree, i, 1));
+		assert(radix_tree_tag_get(&tree, i, 1));
 	}
 
+	assert(radix_tree_tag_clear(&tree, index, 1));
+
 	assert(!radix_tree_tagged(&tree, 0));
 	assert(!radix_tree_tagged(&tree, 1));
 
@@ -244,6 +248,7 @@ void multiorder_tagged_iteration(void)
 	RADIX_TREE(tree, GFP_KERNEL);
 	struct radix_tree_iter iter;
 	void **slot;
+	unsigned long first = 0;
 	int i;
 
 	printf("Multiorder tagged iteration test\n");
@@ -279,6 +284,24 @@ void multiorder_tagged_iteration(void)
 		assert(iter.index == tag_index[i]);
 		i++;
 	}
+
+	radix_tree_range_tag_if_tagged(&tree, &first, ~0UL,
+					MT_NUM_ENTRIES, 1, 2);
+
+	i = 0;
+	radix_tree_for_each_tagged(slot, &tree, &iter, 1, 2) {
+		assert(iter.index == tag_index[i]);
+		i++;
+	}
+
+	first = 1;
+	radix_tree_range_tag_if_tagged(&tree, &first, ~0UL,
+					MT_NUM_ENTRIES, 1, 0);
+	i = 0;
+	radix_tree_for_each_tagged(slot, &tree, &iter, 0, 0) {
+		assert(iter.index == tag_index[i]);
+		i++;
+	}
 
 	item_kill_tree(&tree);
 }
diff -puN tools/testing/radix-tree/tag_check.c~radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries tools/testing/radix-tree/tag_check.c
--- a/tools/testing/radix-tree/tag_check.c~radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries
+++ a/tools/testing/radix-tree/tag_check.c
@@ -12,6 +12,7 @@
 static void
 __simple_checks(struct radix_tree_root *tree, unsigned long index, int tag)
 {
+	unsigned long first = 0;
 	int ret;
 
 	item_check_absent(tree, index);
@@ -22,6 +23,10 @@ __simple_checks(struct radix_tree_root *
 	item_tag_set(tree, index, tag);
 	ret = item_tag_get(tree, index, tag);
 	assert(ret != 0);
+	ret = radix_tree_range_tag_if_tagged(tree, &first, ~0UL, 10, tag, !tag);
+	assert(ret == 1);
+	ret = item_tag_get(tree, index, !tag);
+	assert(ret != 0);
 	ret = item_delete(tree, index);
 	assert(ret != 0);
 	item_insert(tree, index);
@@ -304,6 +309,7 @@ static void single_check(void)
 	struct item *items[BATCH];
 	RADIX_TREE(tree, GFP_KERNEL);
 	int ret;
+	unsigned long first = 0;
 
 	item_insert(&tree, 0);
 	item_tag_set(&tree, 0, 0);
@@ -313,6 +319,10 @@ static void single_check(void)
 	assert(ret == 0);
 	verify_tag_consistency(&tree, 0);
 	verify_tag_consistency(&tree, 1);
+	ret = radix_tree_range_tag_if_tagged(&tree, &first, 10, 10, 0, 1);
+	assert(ret == 1);
+	ret = radix_tree_gang_lookup_tag(&tree, (void **)items, 0, BATCH, 1);
+	assert(ret == 1);
 	item_kill_tree(&tree);
 }
 
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

