From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-fix-radix_tree_create-for-sibling-entries.patch removed from -mm tree
Date: Mon, 23 May 2016 12:50:16 -0700
Message-ID: <57435ef8.zEuWe52Zh/AVJQIM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbcEWTuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix radix_tree_create for sibling entries
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-radix_tree_create-for-sibling-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix radix_tree_create for sibling entries

If the radix tree user attempted to insert a colliding entry with an
existing multiorder entry, then radix_tree_create() could encounter a
sibling entry when walking down the tree to look for a slot.  Use
radix_tree_descend() to fix the problem, and add a test-case to make sure
the problem doesn't come back in future.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |    4 ++--
 tools/testing/radix-tree/multiorder.c |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-radix_tree_create-for-sibling-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-radix_tree_create-for-sibling-entries
+++ a/lib/radix-tree.c
@@ -548,9 +548,9 @@ int __radix_tree_create(struct radix_tre
 		/* Go a level down */
 		height--;
 		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		node = indirect_to_ptr(slot);
-		slot = node->slots[offset];
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		offset = radix_tree_descend(node, &slot, offset);
 	}
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-fix-radix_tree_create-for-sibling-entries tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-fix-radix_tree_create-for-sibling-entries
+++ a/tools/testing/radix-tree/multiorder.c
@@ -135,6 +135,11 @@ static void multiorder_check(unsigned lo
 		item_check_absent(&tree, i);
 	for (i = max; i < 2*max; i++)
 		item_check_absent(&tree, i);
+	for (i = min; i < max; i++) {
+		static void *entry = (void *)
+					(0xA0 | RADIX_TREE_EXCEPTIONAL_ENTRY);
+		assert(radix_tree_insert(&tree, i, entry) == -EEXIST);
+	}
 
 	assert(item_delete(&tree, index) != 0);
 
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

