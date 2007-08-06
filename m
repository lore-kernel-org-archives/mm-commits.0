From: akpm@linux-foundation.org
Subject: + radix-tree-use-indirect-bit.patch added to -mm tree
Date: Mon, 06 Aug 2007 11:41:11 -0700
Message-ID: <200708061841.l76IfBcv008842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759280AbXHFSlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, a.p.zijlstra@chello.nl, hugh@veritas.com


The patch titled
     radix-tree: use indirect bit
has been added to the -mm tree.  Its filename is
     radix-tree-use-indirect-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: radix-tree: use indirect bit
From: Nick Piggin <npiggin@suse.de>

Rather than sign direct radix-tree pointers with a special bit, sign the
indirect one that hangs off the root.  This means that, given a lookup_slot
operation, the invalid result will be differentiated from the valid
(previously, valid results could have the bit either set or clear).

This does not affect slot lookups which occur under lock -- they can never
return an invalid result.  Is needed in future for lockless pagecache.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   40 +++++++++++---------
 lib/radix-tree.c           |   69 +++++++++++++++++++++--------------
 2 files changed, 65 insertions(+), 44 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-use-indirect-bit include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-use-indirect-bit
+++ a/include/linux/radix-tree.h
@@ -26,28 +26,31 @@
 #include <linux/rcupdate.h>
 
 /*
- * A direct pointer (root->rnode pointing directly to a data item,
- * rather than another radix_tree_node) is signalled by the low bit
- * set in the root->rnode pointer.
- *
- * In this case root->height is also NULL, but the direct pointer tests are
- * needed for RCU lookups when root->height is unreliable.
+ * An indirect pointer (root->rnode pointing to a radix_tree_node, rather
+ * than a data item) is signalled by the low bit set in the root->rnode
+ * pointer.
+ *
+ * In this case root->height is > 0, but the indirect pointer tests are
+ * needed for RCU lookups (because root->height is unreliable). The only
+ * time callers need worry about this is when doing a lookup_slot under
+ * RCU.
  */
-#define RADIX_TREE_DIRECT_PTR	1
+#define RADIX_TREE_INDIRECT_PTR	1
+#define RADIX_TREE_RETRY ((void *)-1UL)
 
-static inline void *radix_tree_ptr_to_direct(void *ptr)
+static inline void *radix_tree_ptr_to_indirect(void *ptr)
 {
-	return (void *)((unsigned long)ptr | RADIX_TREE_DIRECT_PTR);
+	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
 }
 
-static inline void *radix_tree_direct_to_ptr(void *ptr)
+static inline void *radix_tree_indirect_to_ptr(void *ptr)
 {
-	return (void *)((unsigned long)ptr & ~RADIX_TREE_DIRECT_PTR);
+	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
 
-static inline int radix_tree_is_direct_ptr(void *ptr)
+static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
-	return (int)((unsigned long)ptr & RADIX_TREE_DIRECT_PTR);
+	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
 }
 
 /*** radix-tree API starts here ***/
@@ -130,7 +133,10 @@ do {									\
  */
 static inline void *radix_tree_deref_slot(void **pslot)
 {
-	return radix_tree_direct_to_ptr(*pslot);
+	void *ret = *pslot;
+	if (unlikely(radix_tree_is_indirect_ptr(ret)))
+		ret = RADIX_TREE_RETRY;
+	return ret;
 }
 /**
  * radix_tree_replace_slot	- replace item in a slot
@@ -142,10 +148,8 @@ static inline void *radix_tree_deref_slo
  */
 static inline void radix_tree_replace_slot(void **pslot, void *item)
 {
-	BUG_ON(radix_tree_is_direct_ptr(item));
-	rcu_assign_pointer(*pslot,
-		(void *)((unsigned long)item |
-			((unsigned long)*pslot & RADIX_TREE_DIRECT_PTR)));
+	BUG_ON(radix_tree_is_indirect_ptr(item));
+	rcu_assign_pointer(*pslot, item);
 }
 
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
diff -puN lib/radix-tree.c~radix-tree-use-indirect-bit lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-use-indirect-bit
+++ a/lib/radix-tree.c
@@ -104,7 +104,7 @@ radix_tree_node_alloc(struct radix_tree_
 			rtp->nr--;
 		}
 	}
-	BUG_ON(radix_tree_is_direct_ptr(ret));
+	BUG_ON(radix_tree_is_indirect_ptr(ret));
 	return ret;
 }
 
@@ -240,7 +240,7 @@ static int radix_tree_extend(struct radi
 			return -ENOMEM;
 
 		/* Increase the height.  */
-		node->slots[0] = radix_tree_direct_to_ptr(root->rnode);
+		node->slots[0] = radix_tree_indirect_to_ptr(root->rnode);
 
 		/* Propagate the aggregated tag info into the new root */
 		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
@@ -251,6 +251,7 @@ static int radix_tree_extend(struct radi
 		newheight = root->height+1;
 		node->height = newheight;
 		node->count = 1;
+		node = radix_tree_ptr_to_indirect(node);
 		rcu_assign_pointer(root->rnode, node);
 		root->height = newheight;
 	} while (height > root->height);
@@ -274,7 +275,7 @@ int radix_tree_insert(struct radix_tree_
 	int offset;
 	int error;
 
-	BUG_ON(radix_tree_is_direct_ptr(item));
+	BUG_ON(radix_tree_is_indirect_ptr(item));
 
 	/* Make sure the tree is high enough.  */
 	if (index > radix_tree_maxindex(root->height)) {
@@ -283,7 +284,8 @@ int radix_tree_insert(struct radix_tree_
 			return error;
 	}
 
-	slot = root->rnode;
+	slot = radix_tree_indirect_to_ptr(root->rnode);
+
 	height = root->height;
 	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
 
@@ -298,7 +300,8 @@ int radix_tree_insert(struct radix_tree_
 				rcu_assign_pointer(node->slots[offset], slot);
 				node->count++;
 			} else
-				rcu_assign_pointer(root->rnode, slot);
+				rcu_assign_pointer(root->rnode,
+					radix_tree_ptr_to_indirect(slot));
 		}
 
 		/* Go a level down */
@@ -318,7 +321,7 @@ int radix_tree_insert(struct radix_tree_
 		BUG_ON(tag_get(node, 0, offset));
 		BUG_ON(tag_get(node, 1, offset));
 	} else {
-		rcu_assign_pointer(root->rnode, radix_tree_ptr_to_direct(item));
+		rcu_assign_pointer(root->rnode, item);
 		BUG_ON(root_tag_get(root, 0));
 		BUG_ON(root_tag_get(root, 1));
 	}
@@ -350,11 +353,12 @@ void **radix_tree_lookup_slot(struct rad
 	if (node == NULL)
 		return NULL;
 
-	if (radix_tree_is_direct_ptr(node)) {
+	if (!radix_tree_is_indirect_ptr(node)) {
 		if (index > 0)
 			return NULL;
 		return (void **)&root->rnode;
 	}
+	node = radix_tree_indirect_to_ptr(node);
 
 	height = node->height;
 	if (index > radix_tree_maxindex(height))
@@ -398,11 +402,12 @@ void *radix_tree_lookup(struct radix_tre
 	if (node == NULL)
 		return NULL;
 
-	if (radix_tree_is_direct_ptr(node)) {
+	if (!radix_tree_is_indirect_ptr(node)) {
 		if (index > 0)
 			return NULL;
-		return radix_tree_direct_to_ptr(node);
+		return node;
 	}
+	node = radix_tree_indirect_to_ptr(node);
 
 	height = node->height;
 	if (index > radix_tree_maxindex(height))
@@ -447,7 +452,7 @@ void *radix_tree_tag_set(struct radix_tr
 	height = root->height;
 	BUG_ON(index > radix_tree_maxindex(height));
 
-	slot = root->rnode;
+	slot = radix_tree_indirect_to_ptr(root->rnode);
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 
 	while (height > 0) {
@@ -497,7 +502,7 @@ void *radix_tree_tag_clear(struct radix_
 
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 	pathp->node = NULL;
-	slot = root->rnode;
+	slot = radix_tree_indirect_to_ptr(root->rnode);
 
 	while (height > 0) {
 		int offset;
@@ -562,8 +567,9 @@ int radix_tree_tag_get(struct radix_tree
 	if (node == NULL)
 		return 0;
 
-	if (radix_tree_is_direct_ptr(node))
+	if (!radix_tree_is_indirect_ptr(node))
 		return (index == 0);
+	node = radix_tree_indirect_to_ptr(node);
 
 	height = node->height;
 	if (index > radix_tree_maxindex(height))
@@ -716,13 +722,13 @@ radix_tree_gang_lookup(struct radix_tree
 	if (!node)
 		return 0;
 
-	if (radix_tree_is_direct_ptr(node)) {
+	if (!radix_tree_is_indirect_ptr(node)) {
 		if (first_index > 0)
 			return 0;
-		node = radix_tree_direct_to_ptr(node);
-		results[0] = rcu_dereference(node);
+		results[0] = node;
 		return 1;
 	}
+	node = radix_tree_indirect_to_ptr(node);
 
 	max_index = radix_tree_maxindex(node->height);
 
@@ -844,13 +850,13 @@ radix_tree_gang_lookup_tag(struct radix_
 	if (!node)
 		return 0;
 
-	if (radix_tree_is_direct_ptr(node)) {
+	if (!radix_tree_is_indirect_ptr(node)) {
 		if (first_index > 0)
 			return 0;
-		node = radix_tree_direct_to_ptr(node);
-		results[0] = rcu_dereference(node);
+		results[0] = node;
 		return 1;
 	}
+	node = radix_tree_indirect_to_ptr(node);
 
 	max_index = radix_tree_maxindex(node->height);
 
@@ -880,12 +886,22 @@ EXPORT_SYMBOL(radix_tree_gang_lookup_tag
 static inline void radix_tree_shrink(struct radix_tree_root *root)
 {
 	/* try to shrink tree height */
-	while (root->height > 0 &&
-			root->rnode->count == 1 &&
-			root->rnode->slots[0]) {
+	while (root->height > 0) {
 		struct radix_tree_node *to_free = root->rnode;
 		void *newptr;
 
+		BUG_ON(!radix_tree_is_indirect_ptr(to_free));
+		to_free = radix_tree_indirect_to_ptr(to_free);
+
+		/*
+		 * The candidate node has more than one child, or its child
+		 * is not at the leftmost slot, we cannot shrink.
+		 */
+		if (to_free->count != 1)
+			break;
+		if (!to_free->slots[0])
+			break;
+
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
 		 * moving the node from one part of the tree to another. If
@@ -894,8 +910,8 @@ static inline void radix_tree_shrink(str
 		 * one (root->rnode).
 		 */
 		newptr = to_free->slots[0];
-		if (root->height == 1)
-			newptr = radix_tree_ptr_to_direct(newptr);
+		if (root->height > 1)
+			newptr = radix_tree_ptr_to_indirect(newptr);
 		root->rnode = newptr;
 		root->height--;
 		/* must only free zeroed nodes into the slab */
@@ -930,12 +946,12 @@ void *radix_tree_delete(struct radix_tre
 		goto out;
 
 	slot = root->rnode;
-	if (height == 0 && root->rnode) {
-		slot = radix_tree_direct_to_ptr(slot);
+	if (height == 0) {
 		root_tag_clear_all(root);
 		root->rnode = NULL;
 		goto out;
 	}
+	slot = radix_tree_indirect_to_ptr(slot);
 
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 	pathp->node = NULL;
@@ -977,7 +993,8 @@ void *radix_tree_delete(struct radix_tre
 			radix_tree_node_free(to_free);
 
 		if (pathp->node->count) {
-			if (pathp->node == root->rnode)
+			if (pathp->node ==
+					radix_tree_indirect_to_ptr(root->rnode))
 				radix_tree_shrink(root);
 			goto out;
 		}
_

Patches currently in -mm which might be from npiggin@suse.de are

remove-zero_page.patch
mm-use-lockless-radix-tree-probe.patch
mm-improve-find_lock_page.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext2-convert-to-new-aops-fix.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
