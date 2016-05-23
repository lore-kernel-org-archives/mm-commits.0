From: akpm@linux-foundation.org
Subject: [merged] radix-tree-introduce-radix_tree_load_root.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:49:42 -0700
Message-ID: <57435ed6.TCMCRrfsVC4E7lXd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbcEWTtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: introduce radix_tree_load_root()
has been removed from the -mm tree.  Its filename was
     radix-tree-introduce-radix_tree_load_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: introduce radix_tree_load_root()

All the tree walking functions start with some variant of this code;
centralise it in one place so we're not chasing subtly different bugs
everywhere.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN lib/radix-tree.c~radix-tree-introduce-radix_tree_load_root lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-introduce-radix_tree_load_root
+++ a/lib/radix-tree.c
@@ -405,6 +405,29 @@ static inline unsigned long radix_tree_m
 	return height_to_maxindex[height];
 }
 
+static inline unsigned long node_maxindex(struct radix_tree_node *node)
+{
+	return radix_tree_maxindex(node->path & RADIX_TREE_HEIGHT_MASK);
+}
+
+static unsigned radix_tree_load_root(struct radix_tree_root *root,
+		struct radix_tree_node **nodep, unsigned long *maxindex)
+{
+	struct radix_tree_node *node = rcu_dereference_raw(root->rnode);
+
+	*nodep = node;
+
+	if (likely(radix_tree_is_indirect_ptr(node))) {
+		node = indirect_to_ptr(node);
+		*maxindex = node_maxindex(node);
+		return (node->path & RADIX_TREE_HEIGHT_MASK) *
+			RADIX_TREE_MAP_SHIFT;
+	}
+
+	*maxindex = 0;
+	return 0;
+}
+
 /*
  *	Extend a radix tree so it can store key @index.
  */
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

