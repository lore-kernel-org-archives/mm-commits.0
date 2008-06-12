From: akpm@linux-foundation.org
Subject: + radix-tree-fix-small-lockless-radix-tree-bug.patch added to -mm tree
Date: Thu, 12 Jun 2008 12:34:50 -0700
Message-ID: <200806121934.m5CJYpw2002868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbYFLTlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 15:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, npiggin@suse.de, paulmck@us.ibm.com


The patch titled
     radix-tree: fix small lockless radix-tree bug
has been added to the -mm tree.  Its filename is
     radix-tree-fix-small-lockless-radix-tree-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: fix small lockless radix-tree bug
From: Nick Piggin <nickpiggin@yahoo.com.au>

When shrinking a radix-tree, we do it in a lockless manner by atomically
switching the root pointer away from the redundant node (one that only has
a single entry in the left most slot), and switching it over to its lone
child.

Because a lockless lookup may have got a reference to the parent and be in
the middle of deciding what to do with it while it is being swapped away
for its child.  For this reason, we also have to keep it around and in a
valid state for the lookup to proceed and give a valid result, for at
least an RCU grace period.  So we need to keep the child in the left most
slot there in case that is requested by the lookup.

This is all pretty standard RCU stuff.  It is worth repeating because in
my eagerness to obey the radix tree node constructor scheme, I had broken
this by zeroing the radix tree node before the grace period.

Fix it by clearing those fields in the RCU callback.  I would normally
want to rip out the constructor entirely, but radix tree nodes are one of
those places where they make sense (only few cachelines will be touched
soon after allocation).

This was never actually observed in any lockless pagecache testing or
using the test harness, but as a rare problem testing my scalable vmap
rewrite.

Fortunately, it is not a problem anywhere lockless pagecache is used in
mainline kernels (pagecache probe is not a guarantee, and brd does not
have concurrent lookups and deletes).

However, it would eventually pop up for someone using lockless pagecache.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

git-unionfs.patch
radix-tree-fix-small-lockless-radix-tree-bug.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
generic_file_aio_read-cleanups.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-hugh-fix3.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

