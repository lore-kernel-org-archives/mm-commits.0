From: akpm@linux-foundation.org
Subject: [merged] radix-tree-add-missing-sibling-entry-functionality.patch removed from -mm tree
Date: Mon, 23 May 2016 12:49:31 -0700
Message-ID: <57435ecb./W9nMtcDzi8ajPYI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbcEWTtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: add missing sibling entry functionality
has been removed from the -mm tree.  Its filename was
     radix-tree-add-missing-sibling-entry-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: add missing sibling entry functionality

The code I previously added to enable multiorder radix tree entries was
untested and therefore buggy.  This commit adds the support functions that
Ross and I decided were necessary over a four-week period of iterating
various designs.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN lib/radix-tree.c~radix-tree-add-missing-sibling-entry-functionality lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-missing-sibling-entry-functionality
+++ a/lib/radix-tree.c
@@ -80,6 +80,46 @@ static inline void *indirect_to_ptr(void
 	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
 
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+/* Sibling slots point directly to another slot in the same node */
+static inline bool is_sibling_entry(struct radix_tree_node *parent, void *node)
+{
+	void **ptr = node;
+	return (parent->slots <= ptr) &&
+			(ptr < parent->slots + RADIX_TREE_MAP_SIZE);
+}
+#else
+static inline bool is_sibling_entry(struct radix_tree_node *parent, void *node)
+{
+	return false;
+}
+#endif
+
+static inline unsigned long get_slot_offset(struct radix_tree_node *parent,
+						 void **slot)
+{
+	return slot - parent->slots;
+}
+
+static unsigned radix_tree_descend(struct radix_tree_node *parent,
+				struct radix_tree_node **nodep, unsigned offset)
+{
+	void **entry = rcu_dereference_raw(parent->slots[offset]);
+
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	if (radix_tree_is_indirect_ptr(entry)) {
+		unsigned long siboff = get_slot_offset(parent, entry);
+		if (siboff < RADIX_TREE_MAP_SIZE) {
+			offset = siboff;
+			entry = rcu_dereference_raw(parent->slots[offset]);
+		}
+	}
+#endif
+
+	*nodep = (void *)entry;
+	return offset;
+}
+
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
 	return root->gfp_mask & __GFP_BITS_MASK;
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

