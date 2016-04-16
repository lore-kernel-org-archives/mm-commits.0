From: akpm@linux-foundation.org
Subject: + radix-tree-miscellaneous-fixes.patch added to -mm tree
Date: Fri, 15 Apr 2016 23:04:35 -0700
Message-ID: <5711d5f3.pr7TIdxWbi25Hlk/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: miscellaneous fixes
has been added to the -mm tree.  Its filename is
     radix-tree-miscellaneous-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-miscellaneous-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-miscellaneous-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: miscellaneous fixes

Typos, whitespace, grammar, line length, using the correct types, etc.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   70 +++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-miscellaneous-fixes lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-miscellaneous-fixes
+++ a/lib/radix-tree.c
@@ -66,7 +66,7 @@ static struct kmem_cache *radix_tree_nod
  * Per-cpu pool of preloaded nodes
  */
 struct radix_tree_preload {
-	int nr;
+	unsigned nr;
 	/* nodes->private_data points to next preallocated node */
 	struct radix_tree_node *nodes;
 };
@@ -147,7 +147,7 @@ static inline void root_tag_set(struct r
 	root->gfp_mask |= (__force gfp_t)(1 << (tag + __GFP_BITS_SHIFT));
 }
 
-static inline void root_tag_clear(struct radix_tree_root *root, unsigned int tag)
+static inline void root_tag_clear(struct radix_tree_root *root, unsigned tag)
 {
 	root->gfp_mask &= (__force gfp_t)~(1 << (tag + __GFP_BITS_SHIFT));
 }
@@ -159,7 +159,7 @@ static inline void root_tag_clear_all(st
 
 static inline int root_tag_get(struct radix_tree_root *root, unsigned int tag)
 {
-	return (__force unsigned)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
+	return (__force int)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
 }
 
 static inline unsigned root_tags_get(struct radix_tree_root *root)
@@ -173,7 +173,7 @@ static inline unsigned root_tags_get(str
  */
 static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
 {
-	int idx;
+	unsigned idx;
 	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
 		if (node->tags[tag][idx])
 			return 1;
@@ -273,9 +273,9 @@ radix_tree_node_alloc(struct radix_tree_
 	gfp_t gfp_mask = root_gfp_mask(root);
 
 	/*
-	 * Preload code isn't irq safe and it doesn't make sence to use
-	 * preloading in the interrupt anyway as all the allocations have to
-	 * be atomic. So just do normal allocation when in interrupt.
+	 * Preload code isn't irq safe and it doesn't make sense to use
+	 * preloading during an interrupt anyway as all the allocations have
+	 * to be atomic. So just do normal allocation when in interrupt.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) && !in_interrupt()) {
 		struct radix_tree_preload *rtp;
@@ -448,7 +448,6 @@ static unsigned radix_tree_load_root(str
 static int radix_tree_extend(struct radix_tree_root *root,
 				unsigned long index)
 {
-	struct radix_tree_node *node;
 	struct radix_tree_node *slot;
 	unsigned int height;
 	int tag;
@@ -465,7 +464,9 @@ static int radix_tree_extend(struct radi
 
 	do {
 		unsigned int newheight;
-		if (!(node = radix_tree_node_alloc(root)))
+		struct radix_tree_node *node = radix_tree_node_alloc(root);
+
+		if (!node)
 			return -ENOMEM;
 
 		/* Propagate the aggregated tag info into the new root */
@@ -542,7 +543,8 @@ int __radix_tree_create(struct radix_tre
 	while (shift > order) {
 		if (slot == NULL) {
 			/* Have to add a child node.  */
-			if (!(slot = radix_tree_node_alloc(root)))
+			slot = radix_tree_node_alloc(root);
+			if (!slot)
 				return -ENOMEM;
 			slot->path = height;
 			slot->parent = node;
@@ -722,13 +724,13 @@ EXPORT_SYMBOL(radix_tree_lookup);
  *	radix_tree_tag_set - set a tag on a radix tree node
  *	@root:		radix tree root
  *	@index:		index key
- *	@tag: 		tag index
+ *	@tag:		tag index
  *
  *	Set the search tag (which must be < RADIX_TREE_MAX_TAGS)
  *	corresponding to @index in the radix tree.  From
  *	the root all the way down to the leaf node.
  *
- *	Returns the address of the tagged item.   Setting a tag on a not-present
+ *	Returns the address of the tagged item.  Setting a tag on a not-present
  *	item is a bug.
  */
 void *radix_tree_tag_set(struct radix_tree_root *root,
@@ -767,11 +769,11 @@ EXPORT_SYMBOL(radix_tree_tag_set);
  *	radix_tree_tag_clear - clear a tag on a radix tree node
  *	@root:		radix tree root
  *	@index:		index key
- *	@tag: 		tag index
+ *	@tag:		tag index
  *
  *	Clear the search tag (which must be < RADIX_TREE_MAX_TAGS)
- *	corresponding to @index in the radix tree.  If
- *	this causes the leaf node to have no tags set then clear the tag in the
+ *	corresponding to @index in the radix tree.  If this causes
+ *	the leaf node to have no tags set then clear the tag in the
  *	next-to-leaf node, etc.
  *
  *	Returns the address of the tagged item on success, else NULL.  ie:
@@ -829,7 +831,7 @@ EXPORT_SYMBOL(radix_tree_tag_clear);
  * radix_tree_tag_get - get a tag on a radix tree node
  * @root:		radix tree root
  * @index:		index key
- * @tag: 		tag index (< RADIX_TREE_MAX_TAGS)
+ * @tag:		tag index (< RADIX_TREE_MAX_TAGS)
  *
  * Return values:
  *
@@ -1035,7 +1037,7 @@ EXPORT_SYMBOL(radix_tree_next_chunk);
  * set is outside the range we are scanning. This reults in dangling tags and
  * can lead to problems with later tag operations (e.g. livelocks on lookups).
  *
- * The function returns number of leaves where the tag was set and sets
+ * The function returns the number of leaves where the tag was set and sets
  * *first_indexp to the first unscanned index.
  * WARNING! *first_indexp can wrap if last_index is ULONG_MAX. Caller must
  * be prepared to handle that.
@@ -1153,9 +1155,10 @@ EXPORT_SYMBOL(radix_tree_range_tag_if_ta
  *
  *	Like radix_tree_lookup, radix_tree_gang_lookup may be called under
  *	rcu_read_lock. In this case, rather than the returned results being
- *	an atomic snapshot of the tree at a single point in time, the semantics
- *	of an RCU protected gang lookup are as though multiple radix_tree_lookups
- *	have been issued in individual locks, and results stored in 'results'.
+ *	an atomic snapshot of the tree at a single point in time, the
+ *	semantics of an RCU protected gang lookup are as though multiple
+ *	radix_tree_lookups have been issued in individual locks, and results
+ *	stored in 'results'.
  */
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
@@ -1461,7 +1464,7 @@ static inline void radix_tree_shrink(str
 		 * their slot to become empty sooner or later.
 		 *
 		 * For example, lockless pagecache will look up a slot, deref
-		 * the page pointer, and if the page is 0 refcount it means it
+		 * the page pointer, and if the page has 0 refcount it means it
 		 * was concurrently deleted from pagecache so try the deref
 		 * again. Fortunately there is already a requirement for logic
 		 * to retry the entire slot lookup -- the indirect pointer
@@ -1650,24 +1653,23 @@ static __init void radix_tree_init_maxin
 }
 
 static int radix_tree_callback(struct notifier_block *nfb,
-                            unsigned long action,
-                            void *hcpu)
+				unsigned long action, void *hcpu)
 {
-       int cpu = (long)hcpu;
-       struct radix_tree_preload *rtp;
-       struct radix_tree_node *node;
-
-       /* Free per-cpu pool of perloaded nodes */
-       if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-               rtp = &per_cpu(radix_tree_preloads, cpu);
-               while (rtp->nr) {
+	int cpu = (long)hcpu;
+	struct radix_tree_preload *rtp;
+	struct radix_tree_node *node;
+
+	/* Free per-cpu pool of preloaded nodes */
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		rtp = &per_cpu(radix_tree_preloads, cpu);
+		while (rtp->nr) {
 			node = rtp->nodes;
 			rtp->nodes = node->private_data;
 			kmem_cache_free(radix_tree_node_cachep, node);
 			rtp->nr--;
-               }
-       }
-       return NOTIFY_OK;
+		}
+	}
+	return NOTIFY_OK;
 }
 
 void __init radix_tree_init(void)
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-introduce-radix_tree_empty.patch
radix-tree-test-suite-fix-build.patch
radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch
introduce-config_radix_tree_multiorder.patch
radix-tree-add-missing-sibling-entry-functionality.patch
radix-tree-fix-sibling-entry-insertion.patch
radix-tree-fix-deleting-a-multi-order-entry-through-an-alias.patch
radix-tree-remove-restriction-on-multi-order-entries.patch
radix-tree-introduce-radix_tree_load_root.patch
radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch
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

