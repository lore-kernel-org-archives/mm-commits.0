From: akpm@linux-foundation.org
Subject: [patch 139/162] radix-tree: rename radix_tree_is_indirect_ptr()
Date: Fri, 20 May 2016 17:03:30 -0700
Message-ID: <573fa5d2.vQKtlzYS3R1W6G1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbcEUADc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rename radix_tree_is_indirect_ptr()

As with indirect_to_ptr(), ptr_to_indirect() and RADIX_TREE_INDIRECT_PTR,
change radix_tree_is_indirect_ptr() to radix_tree_is_internal_node().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h      |   10 +++---
 lib/radix-tree.c                |   48 +++++++++++++++---------------
 tools/testing/radix-tree/test.c |    4 +-
 3 files changed, 31 insertions(+), 31 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-rename-radix_tree_is_indirect_ptr include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-rename-radix_tree_is_indirect_ptr
+++ a/include/linux/radix-tree.h
@@ -57,7 +57,7 @@
 #define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
 		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
 
-static inline int radix_tree_is_indirect_ptr(void *ptr)
+static inline int radix_tree_is_internal_node(void *ptr)
 {
 	return (int)((unsigned long)ptr & RADIX_TREE_INTERNAL_NODE);
 }
@@ -224,7 +224,7 @@ static inline void *radix_tree_deref_slo
  */
 static inline int radix_tree_deref_retry(void *arg)
 {
-	return unlikely(radix_tree_is_indirect_ptr(arg));
+	return unlikely(radix_tree_is_internal_node(arg));
 }
 
 /**
@@ -259,7 +259,7 @@ static inline int radix_tree_exception(v
  */
 static inline void radix_tree_replace_slot(void **pslot, void *item)
 {
-	BUG_ON(radix_tree_is_indirect_ptr(item));
+	BUG_ON(radix_tree_is_internal_node(item));
 	rcu_assign_pointer(*pslot, item);
 }
 
@@ -468,7 +468,7 @@ radix_tree_next_slot(void **slot, struct
 		if (unlikely(!iter->tags))
 			return NULL;
 		while (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
-					radix_tree_is_indirect_ptr(slot[1])) {
+					radix_tree_is_internal_node(slot[1])) {
 			if (entry_to_node(slot[1]) == canon) {
 				iter->tags >>= 1;
 				iter->index = __radix_tree_iter_add(iter, 1);
@@ -498,7 +498,7 @@ radix_tree_next_slot(void **slot, struct
 			iter->index = __radix_tree_iter_add(iter, 1);
 
 			if (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
-			    radix_tree_is_indirect_ptr(*slot)) {
+			    radix_tree_is_internal_node(*slot)) {
 				if (entry_to_node(*slot) == canon)
 					continue;
 				iter->next_index = iter->index;
diff -puN lib/radix-tree.c~radix-tree-rename-radix_tree_is_indirect_ptr lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rename-radix_tree_is_indirect_ptr
+++ a/lib/radix-tree.c
@@ -100,7 +100,7 @@ static unsigned radix_tree_descend(struc
 	void **entry = rcu_dereference_raw(parent->slots[offset]);
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
-	if (radix_tree_is_indirect_ptr(entry)) {
+	if (radix_tree_is_internal_node(entry)) {
 		unsigned long siboff = get_slot_offset(parent, entry);
 		if (siboff < RADIX_TREE_MAP_SIZE) {
 			offset = siboff;
@@ -232,7 +232,7 @@ static void dump_node(struct radix_tree_
 					entry, i,
 					*(void **)entry_to_node(entry),
 					first, last);
-		} else if (!radix_tree_is_indirect_ptr(entry)) {
+		} else if (!radix_tree_is_internal_node(entry)) {
 			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
 					entry, i, first, last);
 		} else {
@@ -247,7 +247,7 @@ static void radix_tree_dump(struct radix
 	pr_debug("radix root: %p rnode %p tags %x\n",
 			root, root->rnode,
 			root->gfp_mask >> __GFP_BITS_SHIFT);
-	if (!radix_tree_is_indirect_ptr(root->rnode))
+	if (!radix_tree_is_internal_node(root->rnode))
 		return;
 	dump_node(entry_to_node(root->rnode), 0);
 }
@@ -302,7 +302,7 @@ radix_tree_node_alloc(struct radix_tree_
 	ret = kmem_cache_alloc(radix_tree_node_cachep,
 			       gfp_mask | __GFP_ACCOUNT);
 out:
-	BUG_ON(radix_tree_is_indirect_ptr(ret));
+	BUG_ON(radix_tree_is_internal_node(ret));
 	return ret;
 }
 
@@ -421,7 +421,7 @@ static unsigned radix_tree_load_root(str
 
 	*nodep = node;
 
-	if (likely(radix_tree_is_indirect_ptr(node))) {
+	if (likely(radix_tree_is_internal_node(node))) {
 		node = entry_to_node(node);
 		*maxindex = node_maxindex(node);
 		return node->shift + RADIX_TREE_MAP_SHIFT;
@@ -467,7 +467,7 @@ static int radix_tree_extend(struct radi
 		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
-		if (radix_tree_is_indirect_ptr(slot))
+		if (radix_tree_is_internal_node(slot))
 			entry_to_node(slot)->parent = node;
 		node->slots[0] = slot;
 		slot = node_to_entry(node);
@@ -535,7 +535,7 @@ int __radix_tree_create(struct radix_tre
 			} else
 				rcu_assign_pointer(root->rnode,
 							node_to_entry(slot));
-		} else if (!radix_tree_is_indirect_ptr(slot))
+		} else if (!radix_tree_is_internal_node(slot))
 			break;
 
 		/* Go a level down */
@@ -585,7 +585,7 @@ int __radix_tree_insert(struct radix_tre
 	void **slot;
 	int error;
 
-	BUG_ON(radix_tree_is_indirect_ptr(item));
+	BUG_ON(radix_tree_is_internal_node(item));
 
 	error = __radix_tree_create(root, index, order, &node, &slot);
 	if (error)
@@ -637,7 +637,7 @@ void *__radix_tree_lookup(struct radix_t
 	if (index > maxindex)
 		return NULL;
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		unsigned offset;
 
 		if (node == RADIX_TREE_RETRY)
@@ -720,7 +720,7 @@ void *radix_tree_tag_set(struct radix_tr
 	shift = radix_tree_load_root(root, &node, &maxindex);
 	BUG_ON(index > maxindex);
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		unsigned offset;
 
 		shift -= RADIX_TREE_MAP_SHIFT;
@@ -770,7 +770,7 @@ void *radix_tree_tag_clear(struct radix_
 
 	parent = NULL;
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
@@ -835,7 +835,7 @@ int radix_tree_tag_get(struct radix_tree
 	if (node == NULL)
 		return 0;
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		int offset;
 
 		shift -= RADIX_TREE_MAP_SHIFT;
@@ -900,7 +900,7 @@ void **radix_tree_next_chunk(struct radi
 	if (index > maxindex)
 		return NULL;
 
-	if (radix_tree_is_indirect_ptr(rnode)) {
+	if (radix_tree_is_internal_node(rnode)) {
 		rnode = entry_to_node(rnode);
 	} else if (rnode) {
 		/* Single-slot tree */
@@ -957,7 +957,7 @@ void **radix_tree_next_chunk(struct radi
 
 		if ((slot == NULL) || (slot == RADIX_TREE_RETRY))
 			goto restart;
-		if (!radix_tree_is_indirect_ptr(slot))
+		if (!radix_tree_is_internal_node(slot))
 			break;
 
 		node = entry_to_node(slot);
@@ -1039,7 +1039,7 @@ unsigned long radix_tree_range_tag_if_ta
 		*first_indexp = last_index + 1;
 		return 0;
 	}
-	if (!radix_tree_is_indirect_ptr(slot)) {
+	if (!radix_tree_is_internal_node(slot)) {
 		*first_indexp = last_index + 1;
 		root_tag_set(root, settag);
 		return 1;
@@ -1059,7 +1059,7 @@ unsigned long radix_tree_range_tag_if_ta
 		if (!tag_get(node, iftag, offset))
 			goto next;
 		/* Sibling slots never have tags set on them */
-		if (radix_tree_is_indirect_ptr(slot)) {
+		if (radix_tree_is_internal_node(slot)) {
 			node = entry_to_node(slot);
 			shift -= RADIX_TREE_MAP_SHIFT;
 			continue;
@@ -1152,7 +1152,7 @@ radix_tree_gang_lookup(struct radix_tree
 		results[ret] = rcu_dereference_raw(*slot);
 		if (!results[ret])
 			continue;
-		if (radix_tree_is_indirect_ptr(results[ret])) {
+		if (radix_tree_is_internal_node(results[ret])) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
@@ -1235,7 +1235,7 @@ radix_tree_gang_lookup_tag(struct radix_
 		results[ret] = rcu_dereference_raw(*slot);
 		if (!results[ret])
 			continue;
-		if (radix_tree_is_indirect_ptr(results[ret])) {
+		if (radix_tree_is_internal_node(results[ret])) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
@@ -1311,7 +1311,7 @@ static unsigned long __locate(struct rad
 					rcu_dereference_raw(slot->slots[i]);
 			if (node == RADIX_TREE_RETRY)
 				goto out;
-			if (!radix_tree_is_indirect_ptr(node)) {
+			if (!radix_tree_is_internal_node(node)) {
 				if (node == item) {
 					info->found_index = index;
 					info->stop = true;
@@ -1357,7 +1357,7 @@ unsigned long radix_tree_locate_item(str
 	do {
 		rcu_read_lock();
 		node = rcu_dereference_raw(root->rnode);
-		if (!radix_tree_is_indirect_ptr(node)) {
+		if (!radix_tree_is_internal_node(node)) {
 			rcu_read_unlock();
 			if (node == item)
 				info.found_index = 0;
@@ -1398,7 +1398,7 @@ static inline bool radix_tree_shrink(str
 		struct radix_tree_node *to_free = root->rnode;
 		struct radix_tree_node *slot;
 
-		if (!radix_tree_is_indirect_ptr(to_free))
+		if (!radix_tree_is_internal_node(to_free))
 			break;
 		to_free = entry_to_node(to_free);
 
@@ -1412,10 +1412,10 @@ static inline bool radix_tree_shrink(str
 		slot = to_free->slots[0];
 		if (!slot)
 			break;
-		if (!radix_tree_is_indirect_ptr(slot) && to_free->shift)
+		if (!radix_tree_is_internal_node(slot) && to_free->shift)
 			break;
 
-		if (radix_tree_is_indirect_ptr(slot))
+		if (radix_tree_is_internal_node(slot))
 			entry_to_node(slot)->parent = NULL;
 
 		/*
@@ -1445,7 +1445,7 @@ static inline bool radix_tree_shrink(str
 		 * also results in a stale slot). So tag the slot as indirect
 		 * to force callers to retry.
 		 */
-		if (!radix_tree_is_indirect_ptr(slot))
+		if (!radix_tree_is_internal_node(slot))
 			to_free->slots[0] = RADIX_TREE_RETRY;
 
 		radix_tree_node_free(to_free);
diff -puN tools/testing/radix-tree/test.c~radix-tree-rename-radix_tree_is_indirect_ptr tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-rename-radix_tree_is_indirect_ptr
+++ a/tools/testing/radix-tree/test.c
@@ -193,7 +193,7 @@ static int verify_node(struct radix_tree
 void verify_tag_consistency(struct radix_tree_root *root, unsigned int tag)
 {
 	struct radix_tree_node *node = root->rnode;
-	if (!radix_tree_is_indirect_ptr(node))
+	if (!radix_tree_is_internal_node(node))
 		return;
 	verify_node(node, tag, !!root_tag_get(root, tag));
 }
@@ -222,7 +222,7 @@ void tree_verify_min_height(struct radix
 {
 	unsigned shift;
 	struct radix_tree_node *node = root->rnode;
-	if (!radix_tree_is_indirect_ptr(node)) {
+	if (!radix_tree_is_internal_node(node)) {
 		assert(maxindex == 0);
 		return;
 	}
_
