From: akpm@linux-foundation.org
Subject: [patch 117/162] radix-tree: add support for multi-order iterating
Date: Fri, 20 May 2016 17:02:26 -0700
Message-ID: <573fa592.TcTgYWZAltBKA2y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEUAC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: add support for multi-order iterating

This enables the macros radix_tree_for_each_slot() and friends to be used
with multi-order entries.

The way that this works is that we treat all entries in a given slots[]
array as a single chunk.  If the index given to radix_tree_next_chunk()
happens to point us to a sibling entry, we will back up iter->index so
that it points to the canonical entry, and that will be the place where we
start our iteration.

As we're processing a chunk in radix_tree_next_slot(), we process
canonical entries, skip over sibling entries, and restart the chunk lookup
if we find a non-sibling indirect pointer.  This drops back to the
radix_tree_next_chunk() code, which will re-walk the tree and look for
another chunk.

This allows us to properly handle multi-order entries mixed with other
entries that are at various heights in the radix tree.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h                    |   69 +++++++++++++---
 lib/radix-tree.c                              |   66 ++++++++-------
 tools/testing/radix-tree/generated/autoconf.h |    3 
 tools/testing/radix-tree/linux/kernel.h       |    5 -
 4 files changed, 102 insertions(+), 41 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-add-support-for-multi-order-iterating include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-add-support-for-multi-order-iterating
+++ a/include/linux/radix-tree.h
@@ -330,8 +330,9 @@ static inline void radix_tree_preload_en
  * struct radix_tree_iter - radix tree iterator state
  *
  * @index:	index of current slot
- * @next_index:	next-to-last index for this chunk
+ * @next_index:	one beyond the last index for this chunk
  * @tags:	bit-mask for tag-iterating
+ * @shift:	shift for the node that holds our slots
  *
  * This radix tree iterator works in terms of "chunks" of slots.  A chunk is a
  * subinterval of slots contained within one radix tree leaf node.  It is
@@ -344,8 +345,20 @@ struct radix_tree_iter {
 	unsigned long	index;
 	unsigned long	next_index;
 	unsigned long	tags;
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	unsigned int	shift;
+#endif
 };
 
+static inline unsigned int iter_shift(struct radix_tree_iter *iter)
+{
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	return iter->shift;
+#else
+	return 0;
+#endif
+}
+
 #define RADIX_TREE_ITER_TAG_MASK	0x00FF	/* tag index in lower byte */
 #define RADIX_TREE_ITER_TAGGED		0x0100	/* lookup tagged slots */
 #define RADIX_TREE_ITER_CONTIG		0x0200	/* stop at first hole */
@@ -405,6 +418,12 @@ void **radix_tree_iter_retry(struct radi
 	return NULL;
 }
 
+static inline unsigned long
+__radix_tree_iter_add(struct radix_tree_iter *iter, unsigned long slots)
+{
+	return iter->index + (slots << iter_shift(iter));
+}
+
 /**
  * radix_tree_iter_next - resume iterating when the chunk may be invalid
  * @iter:	iterator state
@@ -416,7 +435,7 @@ void **radix_tree_iter_retry(struct radi
 static inline __must_check
 void **radix_tree_iter_next(struct radix_tree_iter *iter)
 {
-	iter->next_index = iter->index + 1;
+	iter->next_index = __radix_tree_iter_add(iter, 1);
 	iter->tags = 0;
 	return NULL;
 }
@@ -430,7 +449,12 @@ void **radix_tree_iter_next(struct radix
 static __always_inline long
 radix_tree_chunk_size(struct radix_tree_iter *iter)
 {
-	return iter->next_index - iter->index;
+	return (iter->next_index - iter->index) >> iter_shift(iter);
+}
+
+static inline void *indirect_to_ptr(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
 
 /**
@@ -448,24 +472,51 @@ static __always_inline void **
 radix_tree_next_slot(void **slot, struct radix_tree_iter *iter, unsigned flags)
 {
 	if (flags & RADIX_TREE_ITER_TAGGED) {
+		void *canon = slot;
+
 		iter->tags >>= 1;
+		if (unlikely(!iter->tags))
+			return NULL;
+		while (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
+					radix_tree_is_indirect_ptr(slot[1])) {
+			if (indirect_to_ptr(slot[1]) == canon) {
+				iter->tags >>= 1;
+				iter->index = __radix_tree_iter_add(iter, 1);
+				slot++;
+				continue;
+			}
+			iter->next_index = __radix_tree_iter_add(iter, 1);
+			return NULL;
+		}
 		if (likely(iter->tags & 1ul)) {
-			iter->index++;
+			iter->index = __radix_tree_iter_add(iter, 1);
 			return slot + 1;
 		}
-		if (!(flags & RADIX_TREE_ITER_CONTIG) && likely(iter->tags)) {
+		if (!(flags & RADIX_TREE_ITER_CONTIG)) {
 			unsigned offset = __ffs(iter->tags);
 
 			iter->tags >>= offset;
-			iter->index += offset + 1;
+			iter->index = __radix_tree_iter_add(iter, offset + 1);
 			return slot + offset + 1;
 		}
 	} else {
-		long size = radix_tree_chunk_size(iter);
+		long count = radix_tree_chunk_size(iter);
+		void *canon = slot;
 
-		while (--size > 0) {
+		while (--count > 0) {
 			slot++;
-			iter->index++;
+			iter->index = __radix_tree_iter_add(iter, 1);
+
+			if (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
+			    radix_tree_is_indirect_ptr(*slot)) {
+				if (indirect_to_ptr(*slot) == canon)
+					continue;
+				else {
+					iter->next_index = iter->index;
+					break;
+				}
+			}
+
 			if (likely(*slot))
 				return slot;
 			if (flags & RADIX_TREE_ITER_CONTIG) {
diff -puN lib/radix-tree.c~radix-tree-add-support-for-multi-order-iterating lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-support-for-multi-order-iterating
+++ a/lib/radix-tree.c
@@ -75,11 +75,6 @@ static inline void *ptr_to_indirect(void
 	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
 }
 
-static inline void *indirect_to_ptr(void *ptr)
-{
-	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
-}
-
 #define RADIX_TREE_RETRY	ptr_to_indirect(NULL)
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
@@ -885,6 +880,14 @@ int radix_tree_tag_get(struct radix_tree
 }
 EXPORT_SYMBOL(radix_tree_tag_get);
 
+static inline void __set_iter_shift(struct radix_tree_iter *iter,
+					unsigned int shift)
+{
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	iter->shift = shift;
+#endif
+}
+
 /**
  * radix_tree_next_chunk - find next chunk of slots for iteration
  *
@@ -898,7 +901,7 @@ void **radix_tree_next_chunk(struct radi
 {
 	unsigned shift, tag = flags & RADIX_TREE_ITER_TAG_MASK;
 	struct radix_tree_node *rnode, *node;
-	unsigned long index, offset, height;
+	unsigned long index, offset, maxindex;
 
 	if ((flags & RADIX_TREE_ITER_TAGGED) && !root_tag_get(root, tag))
 		return NULL;
@@ -916,33 +919,39 @@ void **radix_tree_next_chunk(struct radi
 	if (!index && iter->index)
 		return NULL;
 
-	rnode = rcu_dereference_raw(root->rnode);
+ restart:
+	shift = radix_tree_load_root(root, &rnode, &maxindex);
+	if (index > maxindex)
+		return NULL;
+
 	if (radix_tree_is_indirect_ptr(rnode)) {
 		rnode = indirect_to_ptr(rnode);
-	} else if (rnode && !index) {
+	} else if (rnode) {
 		/* Single-slot tree */
-		iter->index = 0;
-		iter->next_index = 1;
+		iter->index = index;
+		iter->next_index = maxindex + 1;
 		iter->tags = 1;
+		__set_iter_shift(iter, shift);
 		return (void **)&root->rnode;
 	} else
 		return NULL;
 
-restart:
-	height = rnode->path & RADIX_TREE_HEIGHT_MASK;
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	shift -= RADIX_TREE_MAP_SHIFT;
 	offset = index >> shift;
 
-	/* Index outside of the tree */
-	if (offset >= RADIX_TREE_MAP_SIZE)
-		return NULL;
-
 	node = rnode;
 	while (1) {
 		struct radix_tree_node *slot;
+		unsigned new_off = radix_tree_descend(node, &slot, offset);
+
+		if (new_off < offset) {
+			offset = new_off;
+			index &= ~((RADIX_TREE_MAP_SIZE << shift) - 1);
+			index |= offset << shift;
+		}
+
 		if ((flags & RADIX_TREE_ITER_TAGGED) ?
-				!test_bit(offset, node->tags[tag]) :
-				!node->slots[offset]) {
+				!tag_get(node, tag, offset) : !slot) {
 			/* Hole detected */
 			if (flags & RADIX_TREE_ITER_CONTIG)
 				return NULL;
@@ -954,7 +963,10 @@ restart:
 						offset + 1);
 			else
 				while (++offset	< RADIX_TREE_MAP_SIZE) {
-					if (node->slots[offset])
+					void *slot = node->slots[offset];
+					if (is_sibling_entry(node, slot))
+						continue;
+					if (slot)
 						break;
 				}
 			index &= ~((RADIX_TREE_MAP_SIZE << shift) - 1);
@@ -964,25 +976,23 @@ restart:
 				return NULL;
 			if (offset == RADIX_TREE_MAP_SIZE)
 				goto restart;
+			slot = rcu_dereference_raw(node->slots[offset]);
 		}
 
-		/* This is leaf-node */
-		if (!shift)
-			break;
-
-		slot = rcu_dereference_raw(node->slots[offset]);
-		if (slot == NULL)
+		if ((slot == NULL) || (slot == RADIX_TREE_RETRY))
 			goto restart;
 		if (!radix_tree_is_indirect_ptr(slot))
 			break;
+
 		node = indirect_to_ptr(slot);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 	}
 
 	/* Update the iterator state */
-	iter->index = index;
-	iter->next_index = (index | RADIX_TREE_MAP_MASK) + 1;
+	iter->index = index & ~((1 << shift) - 1);
+	iter->next_index = (index | ((RADIX_TREE_MAP_SIZE << shift) - 1)) + 1;
+	__set_iter_shift(iter, shift);
 
 	/* Construct iter->tags bit-mask from node->tags[tag] array */
 	if (flags & RADIX_TREE_ITER_TAGGED) {
diff -puN /dev/null tools/testing/radix-tree/generated/autoconf.h
--- /dev/null
+++ a/tools/testing/radix-tree/generated/autoconf.h
@@ -0,0 +1,3 @@
+#define CONFIG_RADIX_TREE_MULTIORDER 1
+#define CONFIG_SHMEM 1
+#define CONFIG_SWAP 1
diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-add-support-for-multi-order-iterating tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-add-support-for-multi-order-iterating
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -8,10 +8,7 @@
 #include <limits.h>
 
 #include "../../include/linux/compiler.h"
