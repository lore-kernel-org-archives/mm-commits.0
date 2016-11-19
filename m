From: akpm@linux-foundation.org
Subject: + lib-radix-tree-native-accounting-of-exceptional-entries.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 16:45:36 -0800
Message-ID: <582fa0b0.HNWFojdOVGu3q3UN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbcKSAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 19:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: radix-tree: native accounting of exceptional entries
has been added to the -mm tree.  Its filename is
     lib-radix-tree-native-accounting-of-exceptional-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-radix-tree-native-accounting-of-exceptional-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-radix-tree-native-accounting-of-exceptional-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: lib: radix-tree: native accounting of exceptional entries

The way the page cache is sneaking shadow entries of evicted pages into
the radix tree past the node entry accounting and tracking them manually
in the upper bits of node->count is fraught with problems.

These shadow entries are marked in the tree as exceptional entries, which
are a native concept to the radix tree.  Maintain an explicit counter of
exceptional entries in the radix tree node.  Subsequent patches will
switch shadow entry tracking over to that counter.

DAX and shmem are the other users of exceptional entries.  Since slot
replacements that change the entry type from regular to exceptional must
now be accounted, introduce a __radix_tree_replace() function that does
replacement and accounting, and switch DAX and shmem over.

The increase in radix tree node size is temporary.  A followup patch
switches the shadow tracking to this new scheme and we'll no longer need
the upper bits in node->count and shrink that back to one byte.

Link: http://lkml.kernel.org/r/20161117192945.GA23430@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |    5 ++-
 include/linux/radix-tree.h |   10 +++++--
 lib/radix-tree.c           |   46 ++++++++++++++++++++++++++++++++---
 mm/shmem.c                 |    8 +++---
 4 files changed, 57 insertions(+), 12 deletions(-)

diff -puN fs/dax.c~lib-radix-tree-native-accounting-of-exceptional-entries fs/dax.c
--- a/fs/dax.c~lib-radix-tree-native-accounting-of-exceptional-entries
+++ a/fs/dax.c
@@ -643,12 +643,13 @@ static void *dax_insert_mapping_entry(st
 		}
 		mapping->nrexceptional++;
 	} else {
+		struct radix_tree_node *node;
 		void **slot;
 		void *ret;
 
-		ret = __radix_tree_lookup(page_tree, index, NULL, &slot);
+		ret = __radix_tree_lookup(page_tree, index, &node, &slot);
 		WARN_ON_ONCE(ret != entry);
-		radix_tree_replace_slot(slot, new_entry);
+		__radix_tree_replace(page_tree, node, slot, new_entry);
 	}
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
diff -puN include/linux/radix-tree.h~lib-radix-tree-native-accounting-of-exceptional-entries include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix-tree-native-accounting-of-exceptional-entries
+++ a/include/linux/radix-tree.h
@@ -85,9 +85,10 @@ static inline bool radix_tree_is_interna
 #define RADIX_TREE_COUNT_MASK	((1UL << RADIX_TREE_COUNT_SHIFT) - 1)
 
 struct radix_tree_node {
-	unsigned char	shift;	/* Bits remaining in each slot */
-	unsigned char	offset;	/* Slot offset in parent */
-	unsigned int	count;
+	unsigned char	shift;		/* Bits remaining in each slot */
+	unsigned char	offset;		/* Slot offset in parent */
+	unsigned int	count;		/* Total entry count */
+	unsigned char	exceptional;	/* Exceptional entry count */
 	union {
 		struct {
 			/* Used when ascending tree */
@@ -276,6 +277,9 @@ void *__radix_tree_lookup(struct radix_t
 			  struct radix_tree_node **nodep, void ***slotp);
 void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
 void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+void __radix_tree_replace(struct radix_tree_root *root,
+			  struct radix_tree_node *node,
+			  void **slot, void *item);
 bool __radix_tree_delete_node(struct radix_tree_root *root,
 			      struct radix_tree_node *node);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
diff -puN lib/radix-tree.c~lib-radix-tree-native-accounting-of-exceptional-entries lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-tree-native-accounting-of-exceptional-entries
+++ a/lib/radix-tree.c
@@ -220,10 +220,10 @@ static void dump_node(struct radix_tree_
 {
 	unsigned long i;
 
-	pr_debug("radix node: %p offset %d tags %lx %lx %lx shift %d count %d parent %p\n",
+	pr_debug("radix node: %p offset %d tags %lx %lx %lx shift %d count %d exceptional %d parent %p\n",
 		node, node->offset,
 		node->tags[0][0], node->tags[1][0], node->tags[2][0],
-		node->shift, node->count, node->parent);
+		node->shift, node->count, node->exceptional, node->parent);
 
 	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
 		unsigned long first = index | (i << node->shift);
@@ -522,8 +522,13 @@ static int radix_tree_extend(struct radi
 		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
-		if (radix_tree_is_internal_node(slot))
+		if (radix_tree_is_internal_node(slot)) {
 			entry_to_node(slot)->parent = node;
+		} else {
+			/* Moving an exceptional root->rnode to a node */
+			if (radix_tree_exceptional_entry(slot))
+				node->exceptional = 1;
+		}
 		node->slots[0] = slot;
 		slot = node_to_entry(node);
 		rcu_assign_pointer(root->rnode, slot);
@@ -649,6 +654,8 @@ int __radix_tree_insert(struct radix_tre
 	if (node) {
 		unsigned offset = get_slot_offset(node, slot);
 		node->count++;
+		if (radix_tree_exceptional_entry(item))
+			node->exceptional++;
 		BUG_ON(tag_get(node, 0, offset));
 		BUG_ON(tag_get(node, 1, offset));
 		BUG_ON(tag_get(node, 2, offset));
@@ -747,6 +754,37 @@ void *radix_tree_lookup(struct radix_tre
 EXPORT_SYMBOL(radix_tree_lookup);
 
 /**
+ * __radix_tree_replace		- replace item in a slot
+ * @root:	radix tree root
+ * @node:	pointer to tree node
+ * @slot:	pointer to slot in @node
+ * @item:	new item to store in the slot.
+ *
+ * For use with __radix_tree_lookup().  Caller must hold tree write locked
+ * across slot lookup and replacement.
+ */
+void __radix_tree_replace(struct radix_tree_root *root,
+			  struct radix_tree_node *node,
+			  void **slot, void *item)
+{
+	void *old = rcu_dereference_raw(*slot);
+	int exceptional;
+
+	WARN_ON_ONCE(radix_tree_is_internal_node(item));
+	WARN_ON_ONCE(!!item - !!old);
+
+	exceptional = !!radix_tree_exceptional_entry(item) -
+		      !!radix_tree_exceptional_entry(old);
+
+	WARN_ON_ONCE(exceptional && !node && slot != (void **)&root->rnode);
+
+	if (node)
+		node->exceptional += exceptional;
+
+	rcu_assign_pointer(*slot, item);
+}
+
+/**
  *	radix_tree_tag_set - set a tag on a radix tree node
  *	@root:		radix tree root
  *	@index:		index key
@@ -1561,6 +1599,8 @@ void *radix_tree_delete_item(struct radi
 	delete_sibling_entries(node, node_to_entry(slot), offset);
 	node->slots[offset] = NULL;
 	node->count--;
+	if (radix_tree_exceptional_entry(entry))
+		node->exceptional--;
 
 	__radix_tree_delete_node(root, node);
 
diff -puN mm/shmem.c~lib-radix-tree-native-accounting-of-exceptional-entries mm/shmem.c
--- a/mm/shmem.c~lib-radix-tree-native-accounting-of-exceptional-entries
+++ a/mm/shmem.c
@@ -300,18 +300,18 @@ void shmem_uncharge(struct inode *inode,
 static int shmem_radix_tree_replace(struct address_space *mapping,
 			pgoff_t index, void *expected, void *replacement)
 {
+	struct radix_tree_node *node;
 	void **pslot;
 	void *item;
 
 	VM_BUG_ON(!expected);
 	VM_BUG_ON(!replacement);
-	pslot = radix_tree_lookup_slot(&mapping->page_tree, index);
-	if (!pslot)
+	item = __radix_tree_lookup(&mapping->page_tree, index, &node, &pslot);
+	if (!item)
 		return -ENOENT;
-	item = radix_tree_deref_slot_protected(pslot, &mapping->tree_lock);
 	if (item != expected)
 		return -ENOENT;
-	radix_tree_replace_slot(pslot, replacement);
+	__radix_tree_replace(&mapping->page_tree, node, pslot, replacement);
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-khugepaged-close-use-after-free-race-during-shmem-collapsing.patch
mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch
mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch
lib-radix-tree-native-accounting-of-exceptional-entries.patch
lib-radix-tree-check-accounting-of-existing-slot-replacement-users.patch
lib-radix-tree-add-entry-deletion-support-to-__radix_tree_replace.patch
lib-radix-tree-update-callback-for-changing-leaf-nodes.patch
mm-workingset-move-shadow-entry-tracking-to-radix-tree-exceptional-tracking.patch
mm-workingset-restore-refault-tracking-for-single-page-files.patch

