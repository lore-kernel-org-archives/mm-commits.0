From: akpm@linux-foundation.org
Subject: [merged] radix-tree-remove-root-height.patch removed from -mm
 tree
Date: Mon, 23 May 2016 12:50:49 -0700
Message-ID: <57435f19.t7ea+7c6y/4wbcor%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbcEWTuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: remove root->height
has been removed from the -mm tree.  Its filename was
     radix-tree-remove-root-height.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: remove root->height

The only remaining references to root->height were in extend and shrink,
where it was updated.  Now we can remove it entirely.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    3 
 lib/radix-tree.c           |  106 ++++++++++-------------------------
 2 files changed, 31 insertions(+), 78 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-remove-root-height include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-remove-root-height
+++ a/include/linux/radix-tree.h
@@ -110,13 +110,11 @@ struct radix_tree_node {
 
 /* root tags are stored in gfp_mask, shifted by __GFP_BITS_SHIFT */
 struct radix_tree_root {
-	unsigned int		height;
 	gfp_t			gfp_mask;
 	struct radix_tree_node	__rcu *rnode;
 };
 
 #define RADIX_TREE_INIT(mask)	{					\
-	.height = 0,							\
 	.gfp_mask = (mask),						\
 	.rnode = NULL,							\
 }
@@ -126,7 +124,6 @@ struct radix_tree_root {
 
 #define INIT_RADIX_TREE(root, mask)					\
 do {									\
-	(root)->height = 0;						\
 	(root)->gfp_mask = (mask);					\
 	(root)->rnode = NULL;						\
 } while (0)
diff -puN lib/radix-tree.c~radix-tree-remove-root-height lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-remove-root-height
+++ a/lib/radix-tree.c
@@ -39,12 +39,6 @@
 
 
 /*
- * The height_to_maxindex array needs to be one deeper than the maximum
- * path as height 0 holds only 1 entry.
- */
-static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH + 1] __read_mostly;
-
-/*
  * Radix tree node cache.
  */
 static struct kmem_cache *radix_tree_node_cachep;
@@ -218,8 +212,7 @@ radix_tree_find_next_bit(const unsigned
 }
 
 #ifndef __KERNEL__
-static void dump_node(struct radix_tree_node *node,
-				unsigned shift, unsigned long index)
+static void dump_node(struct radix_tree_node *node, unsigned long index)
 {
 	unsigned long i;
 
@@ -229,8 +222,8 @@ static void dump_node(struct radix_tree_
 		node->shift, node->count, node->parent);
 
 	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
-		unsigned long first = index | (i << shift);
-		unsigned long last = first | ((1UL << shift) - 1);
+		unsigned long first = index | (i << node->shift);
+		unsigned long last = first | ((1UL << node->shift) - 1);
 		void *entry = node->slots[i];
 		if (!entry)
 			continue;
@@ -243,8 +236,7 @@ static void dump_node(struct radix_tree_
 			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
 					entry, i, first, last);
 		} else {
-			dump_node(indirect_to_ptr(entry),
-					shift - RADIX_TREE_MAP_SHIFT, first);
+			dump_node(indirect_to_ptr(entry), first);
 		}
 	}
 }
@@ -252,13 +244,12 @@ static void dump_node(struct radix_tree_
 /* For debug */
 static void radix_tree_dump(struct radix_tree_root *root)
 {
-	pr_debug("radix root: %p height %d rnode %p tags %x\n",
-			root, root->height, root->rnode,
+	pr_debug("radix root: %p rnode %p tags %x\n",
+			root, root->rnode,
 			root->gfp_mask >> __GFP_BITS_SHIFT);
 	if (!radix_tree_is_indirect_ptr(root->rnode))
 		return;
-	dump_node(indirect_to_ptr(root->rnode),
-				(root->height - 1) * RADIX_TREE_MAP_SHIFT, 0);
+	dump_node(indirect_to_ptr(root->rnode), 0);
 }
 #endif
 
@@ -411,14 +402,8 @@ int radix_tree_maybe_preload(gfp_t gfp_m
 EXPORT_SYMBOL(radix_tree_maybe_preload);
 
 /*
- *	Return the maximum key which can be store into a
- *	radix tree with height HEIGHT.
+ * The maximum index which can be stored in a radix tree
  */
-static inline unsigned long radix_tree_maxindex(unsigned int height)
-{
-	return height_to_maxindex[height];
-}
-
 static inline unsigned long shift_maxindex(unsigned int shift)
 {
 	return (RADIX_TREE_MAP_SIZE << shift) - 1;
@@ -450,24 +435,22 @@ static unsigned radix_tree_load_root(str
  *	Extend a radix tree so it can store key @index.
  */
 static int radix_tree_extend(struct radix_tree_root *root,
-				unsigned long index)
+				unsigned long index, unsigned int shift)
 {
 	struct radix_tree_node *slot;
-	unsigned int height;
+	unsigned int maxshift;
 	int tag;
 
-	/* Figure out what the height should be.  */
-	height = root->height + 1;
-	while (index > radix_tree_maxindex(height))
-		height++;
+	/* Figure out what the shift should be.  */
+	maxshift = shift;
+	while (index > shift_maxindex(maxshift))
+		maxshift += RADIX_TREE_MAP_SHIFT;
 
-	if (root->rnode == NULL) {
-		root->height = height;
+	slot = root->rnode;
+	if (!slot)
 		goto out;
-	}
 
 	do {
-		unsigned int newheight;
 		struct radix_tree_node *node = radix_tree_node_alloc(root);
 
 		if (!node)
@@ -479,14 +462,11 @@ static int radix_tree_extend(struct radi
 				tag_set(node, tag, 0);
 		}
 
-		/* Increase the height.  */
-		newheight = root->height;
-		BUG_ON(newheight > BITS_PER_LONG);
-		node->shift = newheight * RADIX_TREE_MAP_SHIFT;
+		BUG_ON(shift > BITS_PER_LONG);
+		node->shift = shift;
 		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
-		slot = root->rnode;
 		if (radix_tree_is_indirect_ptr(slot)) {
 			slot = indirect_to_ptr(slot);
 			slot->parent = node;
@@ -495,10 +475,11 @@ static int radix_tree_extend(struct radi
 		node->slots[0] = slot;
 		node = ptr_to_indirect(node);
 		rcu_assign_pointer(root->rnode, node);
-		root->height = ++newheight;
-	} while (height > root->height);
+		shift += RADIX_TREE_MAP_SHIFT;
+		slot = node;
+	} while (shift <= maxshift);
 out:
-	return height * RADIX_TREE_MAP_SHIFT;
+	return maxshift + RADIX_TREE_MAP_SHIFT;
 }
 
 /**
@@ -531,15 +512,13 @@ int __radix_tree_create(struct radix_tre
 
 	/* Make sure the tree is high enough.  */
 	if (max > maxindex) {
-		int error = radix_tree_extend(root, max);
+		int error = radix_tree_extend(root, max, shift);
 		if (error < 0)
 			return error;
 		shift = error;
 		slot = root->rnode;
-		if (order == shift) {
+		if (order == shift)
 			shift += RADIX_TREE_MAP_SHIFT;
-			root->height++;
-		}
 	}
 
 	offset = 0;			/* uninitialised var warning */
@@ -1412,32 +1391,32 @@ unsigned long radix_tree_locate_item(str
 #endif /* CONFIG_SHMEM && CONFIG_SWAP */
 
 /**
- *	radix_tree_shrink    -    shrink height of a radix tree to minimal
+ *	radix_tree_shrink    -    shrink radix tree to minimum height
  *	@root		radix tree root
  */
 static inline bool radix_tree_shrink(struct radix_tree_root *root)
 {
 	bool shrunk = false;
 
-	/* try to shrink tree height */
-	while (root->height > 0) {
+	for (;;) {
 		struct radix_tree_node *to_free = root->rnode;
 		struct radix_tree_node *slot;
 
-		BUG_ON(!radix_tree_is_indirect_ptr(to_free));
+		if (!radix_tree_is_indirect_ptr(to_free))
+			break;
 		to_free = indirect_to_ptr(to_free);
 
 		/*
 		 * The candidate node has more than one child, or its child
-		 * is not at the leftmost slot, or it is a multiorder entry,
-		 * we cannot shrink.
+		 * is not at the leftmost slot, or the child is a multiorder
+		 * entry, we cannot shrink.
 		 */
 		if (to_free->count != 1)
 			break;
 		slot = to_free->slots[0];
 		if (!slot)
 			break;
-		if (!radix_tree_is_indirect_ptr(slot) && (root->height > 1))
+		if (!radix_tree_is_indirect_ptr(slot) && to_free->shift)
 			break;
 
 		if (radix_tree_is_indirect_ptr(slot)) {
@@ -1454,7 +1433,6 @@ static inline bool radix_tree_shrink(str
 		 * one (root->rnode) as far as dependent read barriers go.
 		 */
 		root->rnode = slot;
-		root->height--;
 
 		/*
 		 * We have a dilemma here. The node's slot[0] must not be
@@ -1515,7 +1493,6 @@ bool __radix_tree_delete_node(struct rad
 			parent->count--;
 		} else {
 			root_tag_clear_all(root);
-			root->height = 0;
 			root->rnode = NULL;
 		}
 
@@ -1631,26 +1608,6 @@ radix_tree_node_ctor(void *arg)
 	INIT_LIST_HEAD(&node->private_list);
 }
 
-static __init unsigned long __maxindex(unsigned int height)
-{
-	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
-	int shift = RADIX_TREE_INDEX_BITS - width;
-
-	if (shift < 0)
-		return ~0UL;
-	if (shift >= BITS_PER_LONG)
-		return 0UL;
-	return ~0UL >> shift;
-}
-
-static __init void radix_tree_init_maxindex(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(height_to_maxindex); i++)
-		height_to_maxindex[i] = __maxindex(i);
-}
-
 static int radix_tree_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
@@ -1677,6 +1634,5 @@ void __init radix_tree_init(void)
 			sizeof(struct radix_tree_node), 0,
 			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
 			radix_tree_node_ctor);
-	radix_tree_init_maxindex();
 	hotcpu_notifier(radix_tree_callback, 0);
 }
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

