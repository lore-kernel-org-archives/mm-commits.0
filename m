From: akpm@linux-foundation.org
Subject: [merged] radix-tree-split-node-path-into-offset-and-height.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:50:38 -0700
Message-ID: <57435f0e.6WkKMRMpNTxeKkSt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbcEWTuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: split node->path into offset and height
has been removed from the -mm tree.  Its filename was
     radix-tree-split-node-path-into-offset-and-height.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: split node->path into offset and height

Neither piece of information we're storing in node->path can be larger
than 64, so store each in its own unsigned char instead of shifting and
masking to store them both in an unsigned int.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    7 +-----
 lib/radix-tree.c           |   38 +++++++++++++++--------------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-split-node-path-into-offset-and-height include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-split-node-path-into-offset-and-height
+++ a/include/linux/radix-tree.h
@@ -84,16 +84,13 @@ static inline int radix_tree_is_indirect
 #define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
 					  RADIX_TREE_MAP_SHIFT))
 
-/* Height component in node->path */
-#define RADIX_TREE_HEIGHT_SHIFT	(RADIX_TREE_MAX_PATH + 1)
-#define RADIX_TREE_HEIGHT_MASK	((1UL << RADIX_TREE_HEIGHT_SHIFT) - 1)
-
 /* Internally used bits of node->count */
 #define RADIX_TREE_COUNT_SHIFT	(RADIX_TREE_MAP_SHIFT + 1)
 #define RADIX_TREE_COUNT_MASK	((1UL << RADIX_TREE_COUNT_SHIFT) - 1)
 
 struct radix_tree_node {
-	unsigned int	path;	/* Offset in parent & height from the bottom */
+	unsigned char	height;	/* From the bottom */
+	unsigned char	offset;	/* Slot offset in parent */
 	unsigned int	count;
 	union {
 		struct {
diff -puN lib/radix-tree.c~radix-tree-split-node-path-into-offset-and-height lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-split-node-path-into-offset-and-height
+++ a/lib/radix-tree.c
@@ -218,15 +218,15 @@ radix_tree_find_next_bit(const unsigned
 }
 
 #ifndef __KERNEL__
-static void dump_node(struct radix_tree_node *node, unsigned offset,
+static void dump_node(struct radix_tree_node *node,
 				unsigned shift, unsigned long index)
 {
 	unsigned long i;
 
-	pr_debug("radix node: %p offset %d tags %lx %lx %lx path %x count %d parent %p\n",
-		node, offset,
+	pr_debug("radix node: %p offset %d tags %lx %lx %lx height %d count %d parent %p\n",
+		node, node->offset,
 		node->tags[0][0], node->tags[1][0], node->tags[2][0],
-		node->path, node->count, node->parent);
+		node->height, node->count, node->parent);
 
 	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
 		unsigned long first = index | (i << shift);
@@ -243,7 +243,7 @@ static void dump_node(struct radix_tree_
 			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
 					entry, i, first, last);
 		} else {
-			dump_node(indirect_to_ptr(entry), i,
+			dump_node(indirect_to_ptr(entry),
 					shift - RADIX_TREE_MAP_SHIFT, first);
 		}
 	}
@@ -257,7 +257,7 @@ static void radix_tree_dump(struct radix
 			root->gfp_mask >> __GFP_BITS_SHIFT);
 	if (!radix_tree_is_indirect_ptr(root->rnode))
 		return;
-	dump_node(indirect_to_ptr(root->rnode), 0,
+	dump_node(indirect_to_ptr(root->rnode),
 				(root->height - 1) * RADIX_TREE_MAP_SHIFT, 0);
 }
 #endif
@@ -421,7 +421,7 @@ static inline unsigned long radix_tree_m
 
 static inline unsigned long node_maxindex(struct radix_tree_node *node)
 {
-	return radix_tree_maxindex(node->path & RADIX_TREE_HEIGHT_MASK);
+	return radix_tree_maxindex(node->height);
 }
 
 static unsigned radix_tree_load_root(struct radix_tree_root *root,
@@ -434,8 +434,7 @@ static unsigned radix_tree_load_root(str
 	if (likely(radix_tree_is_indirect_ptr(node))) {
 		node = indirect_to_ptr(node);
 		*maxindex = node_maxindex(node);
-		return (node->path & RADIX_TREE_HEIGHT_MASK) *
-			RADIX_TREE_MAP_SHIFT;
+		return node->height * RADIX_TREE_MAP_SHIFT;
 	}
 
 	*maxindex = 0;
@@ -476,9 +475,10 @@ static int radix_tree_extend(struct radi
 		}
 
 		/* Increase the height.  */
-		newheight = root->height+1;
-		BUG_ON(newheight & ~RADIX_TREE_HEIGHT_MASK);
-		node->path = newheight;
+		newheight = root->height + 1;
+		BUG_ON(newheight > BITS_PER_LONG);
+		node->height = newheight;
+		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
 		slot = root->rnode;
@@ -546,13 +546,13 @@ int __radix_tree_create(struct radix_tre
 			slot = radix_tree_node_alloc(root);
 			if (!slot)
 				return -ENOMEM;
-			slot->path = height;
+			slot->height = height;
+			slot->offset = offset;
 			slot->parent = node;
 			if (node) {
 				rcu_assign_pointer(node->slots[offset],
 							ptr_to_indirect(slot));
 				node->count++;
-				slot->path |= offset << RADIX_TREE_HEIGHT_SHIFT;
 			} else
 				rcu_assign_pointer(root->rnode,
 							ptr_to_indirect(slot));
@@ -1319,11 +1319,10 @@ struct locate_info {
 static unsigned long __locate(struct radix_tree_node *slot, void *item,
 			      unsigned long index, struct locate_info *info)
 {
-	unsigned int shift, height;
+	unsigned int shift;
 	unsigned long i;
 
-	height = slot->path & RADIX_TREE_HEIGHT_MASK;
-	shift = height * RADIX_TREE_MAP_SHIFT;
+	shift = slot->height * RADIX_TREE_MAP_SHIFT;
 
 	do {
 		shift -= RADIX_TREE_MAP_SHIFT;
@@ -1508,10 +1507,7 @@ bool __radix_tree_delete_node(struct rad
 
 		parent = node->parent;
 		if (parent) {
-			unsigned int offset;
-
-			offset = node->path >> RADIX_TREE_HEIGHT_SHIFT;
-			parent->slots[offset] = NULL;
+			parent->slots[node->offset] = NULL;
 			parent->count--;
 		} else {
 			root_tag_clear_all(root);
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

