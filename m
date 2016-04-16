From: akpm@linux-foundation.org
Subject: + radix-tree-introduce-radix_tree_replace_clear_tags.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 23:05:03 -0700
Message-ID: <5711d60f.TJ9Qku+fP1ZNp5eI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: introduce radix_tree_replace_clear_tags()
has been added to the -mm tree.  Its filename is
     radix-tree-introduce-radix_tree_replace_clear_tags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-introduce-radix_tree_replace_clear_tags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-introduce-radix_tree_replace_clear_tags.patch

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
Subject: radix-tree: introduce radix_tree_replace_clear_tags()

In addition to replacing the entry, we also clear all associated tags. 
This is really a one-off special for page_cache_tree_delete() which had
far too much detailed knowledge about how the radix tree works.

For efficiency, factor node_tag_clear() out of radix_tree_tag_clear() It
can be used by radix_tree_delete_item() as well as
radix_tree_replace_clear_tags().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    9 ++--
 lib/radix-tree.c           |   76 +++++++++++++++++++++--------------
 mm/filemap.c               |   23 +---------
 3 files changed, 56 insertions(+), 52 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-introduce-radix_tree_replace_clear_tags include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-introduce-radix_tree_replace_clear_tags
+++ a/include/linux/radix-tree.h
@@ -281,9 +281,12 @@ bool __radix_tree_delete_node(struct rad
 			      struct radix_tree_node *node);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
-unsigned int
-radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items);
+struct radix_tree_node *radix_tree_replace_clear_tags(
+				struct radix_tree_root *root,
+				unsigned long index, void *entry);
+unsigned int radix_tree_gang_lookup(struct radix_tree_root *root,
+			void **results, unsigned long first_index,
+			unsigned int max_items);
 unsigned int radix_tree_gang_lookup_slot(struct radix_tree_root *root,
 			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items);
diff -puN lib/radix-tree.c~radix-tree-introduce-radix_tree_replace_clear_tags lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-introduce-radix_tree_replace_clear_tags
+++ a/lib/radix-tree.c
@@ -740,6 +740,26 @@ void *radix_tree_tag_set(struct radix_tr
 }
 EXPORT_SYMBOL(radix_tree_tag_set);
 
+static void node_tag_clear(struct radix_tree_root *root,
+				struct radix_tree_node *node,
+				unsigned int tag, unsigned int offset)
+{
+	while (node) {
+		if (!tag_get(node, tag, offset))
+			return;
+		tag_clear(node, tag, offset);
+		if (any_tag_set(node, tag))
+			return;
+
+		offset = node->offset;
+		node = node->parent;
+	}
+
+	/* clear the root's tag bit */
+	if (root_tag_get(root, tag))
+		root_tag_clear(root, tag);
+}
+
 /**
  *	radix_tree_tag_clear - clear a tag on a radix tree node
  *	@root:		radix tree root
@@ -776,28 +796,9 @@ void *radix_tree_tag_clear(struct radix_
 		offset = radix_tree_descend(parent, &node, offset);
 	}
 
-	if (node == NULL)
-		goto out;
-
-	index >>= shift;
-
-	while (parent) {
-		if (!tag_get(parent, tag, offset))
-			goto out;
-		tag_clear(parent, tag, offset);
-		if (any_tag_set(parent, tag))
-			goto out;
-
-		index >>= RADIX_TREE_MAP_SHIFT;
-		offset = index & RADIX_TREE_MAP_MASK;
-		parent = parent->parent;
-	}
+	if (node)
+		node_tag_clear(root, parent, tag, offset);
 
-	/* clear the root's tag bit */
-	if (root_tag_get(root, tag))
-		root_tag_clear(root, tag);
-
-out:
 	return node;
 }
 EXPORT_SYMBOL(radix_tree_tag_clear);
@@ -1526,14 +1527,9 @@ void *radix_tree_delete_item(struct radi
 
 	offset = get_slot_offset(node, slot);
 
-	/*
-	 * Clear all tags associated with the item to be deleted.
-	 * This way of doing it would be inefficient, but seldom is any set.
-	 */
-	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-		if (tag_get(node, tag, offset))
-			radix_tree_tag_clear(root, index, tag);
-	}
+	/* Clear all tags associated with the item to be deleted.  */
+	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+		node_tag_clear(root, node, tag, offset);
 
 	delete_sibling_entries(node, node_to_entry(slot), offset);
 	node->slots[offset] = NULL;
@@ -1560,6 +1556,28 @@ void *radix_tree_delete(struct radix_tre
 }
 EXPORT_SYMBOL(radix_tree_delete);
 
+struct radix_tree_node *radix_tree_replace_clear_tags(
+			struct radix_tree_root *root,
+			unsigned long index, void *entry)
+{
+	struct radix_tree_node *node;
+	void **slot;
+
+	__radix_tree_lookup(root, index, &node, &slot);
+
+	if (node) {
+		unsigned int tag, offset = get_slot_offset(node, slot);
+		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+			node_tag_clear(root, node, tag, offset);
+	} else {
+		/* Clear root node tags */
+		root->gfp_mask &= __GFP_BITS_MASK;
+	}
+
+	radix_tree_replace_slot(slot, entry);
+	return node;
+}
+
 /**
  *	radix_tree_tagged - test whether any items in the tree are tagged
  *	@root:		radix tree root
diff -puN mm/filemap.c~radix-tree-introduce-radix_tree_replace_clear_tags mm/filemap.c
--- a/mm/filemap.c~radix-tree-introduce-radix_tree_replace_clear_tags
+++ a/mm/filemap.c
@@ -114,14 +114,11 @@ static void page_cache_tree_delete(struc
 				   struct page *page, void *shadow)
 {
 	struct radix_tree_node *node;
-	unsigned long index;
-	unsigned int offset;
-	unsigned int tag;
-	void **slot;
 
 	VM_BUG_ON(!PageLocked(page));
 
-	__radix_tree_lookup(&mapping->page_tree, page->index, &node, &slot);
+	node = radix_tree_replace_clear_tags(&mapping->page_tree, page->index,
+								shadow);
 
 	if (shadow) {
 		mapping->nrexceptional++;
@@ -135,23 +132,9 @@ static void page_cache_tree_delete(struc
 	}
 	mapping->nrpages--;
 
-	if (!node) {
-		/* Clear direct pointer tags in root node */
-		mapping->page_tree.gfp_mask &= __GFP_BITS_MASK;
-		radix_tree_replace_slot(slot, shadow);
+	if (!node)
 		return;
-	}
-
-	/* Clear tree tags for the removed page */
-	index = page->index;
-	offset = index & RADIX_TREE_MAP_MASK;
-	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-		if (test_bit(offset, node->tags[tag]))
-			radix_tree_tag_clear(&mapping->page_tree, index, tag);
-	}
 
-	/* Delete page, swap shadow entry */
-	radix_tree_replace_slot(slot, shadow);
 	workingset_node_pages_dec(node);
 	if (shadow)
 		workingset_node_shadows_inc(node);
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

