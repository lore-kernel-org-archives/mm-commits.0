From: akpm@linux-foundation.org
Subject: - radix-tree-fix-small-lockless-radix-tree-bug.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:05 -0700
Message-ID: <200806160604.m5G645Tu010654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbYFPGEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, npiggin@suse.de, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     radix-tree: fix small lockless radix-tree bug
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-small-lockless-radix-tree-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: fix small lockless radix-tree bug
From: Nick Piggin <nickpiggin@yahoo.com.au>

We shrink a radix tree when its root node has only one child, in the left
most slot.  The child becomes the new root node.  To perform this
operation in a manner compatible with concurrent lockless lookups, we
atomically switch the root pointer from the parent to its child.

However a concurrent lockless lookup may now have loaded a pointer to the
parent (and is presently deciding what to do next).  For this reason, we
also have to keep the parent node in a valid state after shrinking the
tree, until the next RCU grace period -- otherwise this lookup with the
parent pointer may not do the right thing.  Notably, we need to keep the
child in the left most slot there in case that is requested by the lookup.

This is all pretty standard RCU stuff.  It is worth repeating because in
my eagerness to obey the radix tree node constructor scheme, I had broken
it by zeroing the radix tree node before the grace period.

What could happen is that a lookup can load the parent pointer, then
decide it wants to follow the left most child slot, only to find the slot
contained NULL due to the concurrent shrinker having zeroed the parent
node before waiting for a grace period.  The lookup would return a false
negative as a result.

Fix it by doing that clearing in the RCU callback.  I would normally want
to rip out the constructor entirely, but radix tree nodes are one of those
places where they make sense (only few cachelines will be touched soon
after allocation).


This was never actually found in any lockless pagecache testing or by the
test harness, but by seeing the odd problem with my scalable vmap rewrite.
 I have not tickled the test harness into reproducing it yet, but I'll
keep working at it.

Fortunately, it is not a problem anywhere lockless pagecache is used in
mainline kernels (pagecache probe is not a guarantee, and brd does not
have concurrent lookups and deletes).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |  120 +++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 58 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-small-lockless-radix-tree-bug lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-small-lockless-radix-tree-bug
+++ a/lib/radix-tree.c
@@ -88,6 +88,57 @@ static inline gfp_t root_gfp_mask(struct
 	return root->gfp_mask & __GFP_BITS_MASK;
 }
 
+static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	__set_bit(offset, node->tags[tag]);
+}
+
+static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	__clear_bit(offset, node->tags[tag]);
+}
+
+static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	return test_bit(offset, node->tags[tag]);
+}
+
+static inline void root_tag_set(struct radix_tree_root *root, unsigned int tag)
+{
+	root->gfp_mask |= (__force gfp_t)(1 << (tag + __GFP_BITS_SHIFT));
+}
+
+static inline void root_tag_clear(struct radix_tree_root *root, unsigned int tag)
+{
+	root->gfp_mask &= (__force gfp_t)~(1 << (tag + __GFP_BITS_SHIFT));
+}
+
+static inline void root_tag_clear_all(struct radix_tree_root *root)
+{
+	root->gfp_mask &= __GFP_BITS_MASK;
+}
+
+static inline int root_tag_get(struct radix_tree_root *root, unsigned int tag)
+{
+	return (__force unsigned)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
+}
+
+/*
+ * Returns 1 if any slot in the node has this tag set.
+ * Otherwise returns 0.
+ */
+static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
+{
+	int idx;
+	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
+		if (node->tags[tag][idx])
+			return 1;
+	}
+	return 0;
+}
 /*
  * This assumes that the caller has performed appropriate preallocation, and
  * that the caller has pinned this thread of control to the current CPU.
@@ -124,6 +175,17 @@ static void radix_tree_node_rcu_free(str
 {
 	struct radix_tree_node *node =
 			container_of(head, struct radix_tree_node, rcu_head);
+
+	/*
+	 * must only free zeroed nodes into the slab. radix_tree_shrink
+	 * can leave us with a non-NULL entry in the first slot, so clear
+	 * that here to make sure.
+	 */
+	tag_clear(node, 0, 0);
+	tag_clear(node, 1, 0);
+	node->slots[0] = NULL;
+	node->count = 0;
+
 	kmem_cache_free(radix_tree_node_cachep, node);
 }
 
@@ -165,59 +227,6 @@ out:
 }
 EXPORT_SYMBOL(radix_tree_preload);
 
-static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	__set_bit(offset, node->tags[tag]);
-}
-
-static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	__clear_bit(offset, node->tags[tag]);
-}
-
-static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	return test_bit(offset, node->tags[tag]);
-}
-
-static inline void root_tag_set(struct radix_tree_root *root, unsigned int tag)
-{
-	root->gfp_mask |= (__force gfp_t)(1 << (tag + __GFP_BITS_SHIFT));
-}
-
-
-static inline void root_tag_clear(struct radix_tree_root *root, unsigned int tag)
-{
-	root->gfp_mask &= (__force gfp_t)~(1 << (tag + __GFP_BITS_SHIFT));
-}
-
-static inline void root_tag_clear_all(struct radix_tree_root *root)
-{
-	root->gfp_mask &= __GFP_BITS_MASK;
-}
-
-static inline int root_tag_get(struct radix_tree_root *root, unsigned int tag)
-{
-	return (__force unsigned)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
-}
-
-/*
- * Returns 1 if any slot in the node has this tag set.
- * Otherwise returns 0.
- */
-static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
-{
-	int idx;
-	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
-		if (node->tags[tag][idx])
-			return 1;
-	}
-	return 0;
-}
-
 /*
  *	Return the maximum key which can be store into a
  *	radix tree with height HEIGHT.
@@ -930,11 +939,6 @@ static inline void radix_tree_shrink(str
 			newptr = radix_tree_ptr_to_indirect(newptr);
 		root->rnode = newptr;
 		root->height--;
-		/* must only free zeroed nodes into the slab */
-		tag_clear(to_free, 0, 0);
-		tag_clear(to_free, 1, 0);
-		to_free->slots[0] = NULL;
-		to_free->count = 0;
 		radix_tree_node_free(to_free);
 	}
 }
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
linux-next.patch
git-unionfs.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
generic_file_aio_read-cleanups.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-hugh-fix3.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

