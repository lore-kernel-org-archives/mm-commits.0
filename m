From: akpm@linux-foundation.org
Subject: [patch 132/162] radix-tree: replace node->height with node->shift
Date: Fri, 20 May 2016 17:03:10 -0700
Message-ID: <573fa5be.89DYAQ0kvOReviXK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcEUADL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: replace node->height with node->shift

node->shift represents the shift necessary for looking in the slots array
at this level.  It is equal to the old (node->height - 1) *
RADIX_TREE_MAP_SHIFT.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +-
 lib/radix-tree.c           |   30 ++++++++++++++++--------------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-replace-node-height-with-node-shift include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-replace-node-height-with-node-shift
+++ a/include/linux/radix-tree.h
@@ -89,7 +89,7 @@ static inline int radix_tree_is_indirect
 #define RADIX_TREE_COUNT_MASK	((1UL << RADIX_TREE_COUNT_SHIFT) - 1)
 
 struct radix_tree_node {
-	unsigned char	height;	/* From the bottom */
+	unsigned char	shift;	/* Bits remaining in each slot */
 	unsigned char	offset;	/* Slot offset in parent */
 	unsigned int	count;
 	union {
diff -puN lib/radix-tree.c~radix-tree-replace-node-height-with-node-shift lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-replace-node-height-with-node-shift
+++ a/lib/radix-tree.c
@@ -223,10 +223,10 @@ static void dump_node(struct radix_tree_
 {
 	unsigned long i;
 
-	pr_debug("radix node: %p offset %d tags %lx %lx %lx height %d count %d parent %p\n",
+	pr_debug("radix node: %p offset %d tags %lx %lx %lx shift %d count %d parent %p\n",
 		node, node->offset,
 		node->tags[0][0], node->tags[1][0], node->tags[2][0],
-		node->height, node->count, node->parent);
+		node->shift, node->count, node->parent);
 
 	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
 		unsigned long first = index | (i << shift);
@@ -419,9 +419,14 @@ static inline unsigned long radix_tree_m
 	return height_to_maxindex[height];
 }
 
+static inline unsigned long shift_maxindex(unsigned int shift)
+{
+	return (RADIX_TREE_MAP_SIZE << shift) - 1;
+}
+
 static inline unsigned long node_maxindex(struct radix_tree_node *node)
 {
-	return radix_tree_maxindex(node->height);
+	return shift_maxindex(node->shift);
 }
 
 static unsigned radix_tree_load_root(struct radix_tree_root *root,
@@ -434,7 +439,7 @@ static unsigned radix_tree_load_root(str
 	if (likely(radix_tree_is_indirect_ptr(node))) {
 		node = indirect_to_ptr(node);
 		*maxindex = node_maxindex(node);
-		return node->height * RADIX_TREE_MAP_SHIFT;
+		return node->shift + RADIX_TREE_MAP_SHIFT;
 	}
 
 	*maxindex = 0;
@@ -475,9 +480,9 @@ static int radix_tree_extend(struct radi
 		}
 
 		/* Increase the height.  */
-		newheight = root->height + 1;
+		newheight = root->height;
 		BUG_ON(newheight > BITS_PER_LONG);
-		node->height = newheight;
+		node->shift = newheight * RADIX_TREE_MAP_SHIFT;
 		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
@@ -490,7 +495,7 @@ static int radix_tree_extend(struct radi
 		node->slots[0] = slot;
 		node = ptr_to_indirect(node);
 		rcu_assign_pointer(root->rnode, node);
-		root->height = newheight;
+		root->height = ++newheight;
 	} while (height > root->height);
 out:
 	return height * RADIX_TREE_MAP_SHIFT;
@@ -519,7 +524,7 @@ int __radix_tree_create(struct radix_tre
 {
 	struct radix_tree_node *node = NULL, *slot;
 	unsigned long maxindex;
-	unsigned int height, shift, offset;
+	unsigned int shift, offset;
 	unsigned long max = index | ((1UL << order) - 1);
 
 	shift = radix_tree_load_root(root, &slot, &maxindex);
@@ -537,16 +542,15 @@ int __radix_tree_create(struct radix_tre
 		}
 	}
 
-	height = root->height;
-
 	offset = 0;			/* uninitialised var warning */
 	while (shift > order) {
+		shift -= RADIX_TREE_MAP_SHIFT;
 		if (slot == NULL) {
 			/* Have to add a child node.  */
 			slot = radix_tree_node_alloc(root);
 			if (!slot)
 				return -ENOMEM;
-			slot->height = height;
+			slot->shift = shift;
 			slot->offset = offset;
 			slot->parent = node;
 			if (node) {
@@ -560,8 +564,6 @@ int __radix_tree_create(struct radix_tre
 			break;
 
 		/* Go a level down */
-		height--;
-		shift -= RADIX_TREE_MAP_SHIFT;
 		node = indirect_to_ptr(slot);
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		offset = radix_tree_descend(node, &slot, offset);
@@ -1322,7 +1324,7 @@ static unsigned long __locate(struct rad
 	unsigned int shift;
 	unsigned long i;
 
-	shift = slot->height * RADIX_TREE_MAP_SHIFT;
+	shift = slot->shift + RADIX_TREE_MAP_SHIFT;
 
 	do {
 		shift -= RADIX_TREE_MAP_SHIFT;
_
