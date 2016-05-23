From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch removed from -mm tree
Date: Mon, 23 May 2016 12:49:45 -0700
Message-ID: <57435ed9.ra9p4c9N6A4niU1q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbcEWTtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix extending the tree for multi-order entries at offset 0
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix extending the tree for multi-order entries at offset 0

The current code will insert entries at each level, as if we're going to
add a new entry at the bottom level, so we then get an -EEXIST when we try
to insert the entry into the tree.  The best way to fix this is to not
check 'order' when inserting into an empty tree.

We still need to 'extend' the tree to the height necessary for the maximum
index corresponding to this entry, so pass that value to
radix_tree_extend() rather than the index we're asked to create, or we
won't create a tree that's deep enough.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0 lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0
+++ a/lib/radix-tree.c
@@ -432,7 +432,7 @@ static unsigned radix_tree_load_root(str
  *	Extend a radix tree so it can store key @index.
  */
 static int radix_tree_extend(struct radix_tree_root *root,
-				unsigned long index, unsigned order)
+				unsigned long index)
 {
 	struct radix_tree_node *node;
 	struct radix_tree_node *slot;
@@ -444,7 +444,7 @@ static int radix_tree_extend(struct radi
 	while (index > radix_tree_maxindex(height))
 		height++;
 
-	if ((root->rnode == NULL) && (order == 0)) {
+	if (root->rnode == NULL) {
 		root->height = height;
 		goto out;
 	}
@@ -467,7 +467,7 @@ static int radix_tree_extend(struct radi
 		node->count = 1;
 		node->parent = NULL;
 		slot = root->rnode;
-		if (radix_tree_is_indirect_ptr(slot) && newheight > 1) {
+		if (radix_tree_is_indirect_ptr(slot)) {
 			slot = indirect_to_ptr(slot);
 			slot->parent = node;
 			slot = ptr_to_indirect(slot);
@@ -478,7 +478,7 @@ static int radix_tree_extend(struct radi
 		root->height = newheight;
 	} while (height > root->height);
 out:
-	return 0;
+	return height * RADIX_TREE_MAP_SHIFT;
 }
 
 /**
@@ -503,20 +503,26 @@ int __radix_tree_create(struct radix_tre
 			void ***slotp)
 {
 	struct radix_tree_node *node = NULL, *slot;
+	unsigned long maxindex;
 	unsigned int height, shift, offset;
-	int error;
+	unsigned long max = index | ((1UL << order) - 1);
+
+	shift = radix_tree_load_root(root, &slot, &maxindex);
 
 	/* Make sure the tree is high enough.  */
-	if (index > radix_tree_maxindex(root->height)) {
-		error = radix_tree_extend(root, index, order);
-		if (error)
+	if (max > maxindex) {
+		int error = radix_tree_extend(root, max);
+		if (error < 0)
 			return error;
+		shift = error;
+		slot = root->rnode;
+		if (order == shift) {
+			shift += RADIX_TREE_MAP_SHIFT;
+			root->height++;
+		}
 	}
 
-	slot = root->rnode;
-
 	height = root->height;
-	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	offset = 0;			/* uninitialised var warning */
 	while (shift > order) {
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

