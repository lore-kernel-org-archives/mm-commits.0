From: akpm@linux-foundation.org
Subject: [merged] introduce-config_radix_tree_multiorder.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:49:28 -0700
Message-ID: <57435ec8.jcyFoED8+wRrnny1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbcEWTt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: raxix-tree: introduce CONFIG_RADIX_TREE_MULTIORDER
has been removed from the -mm tree.  Its filename was
     introduce-config_radix_tree_multiorder.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: raxix-tree: introduce CONFIG_RADIX_TREE_MULTIORDER

I've been receiving increasingly concerned notes from 0day about how much
my recent changes have been bloating the radix tree.  Make it happier by
only including multiorder support if CONFIG_TRANSPARENT_HUGEPAGES is set. 
This is an independent Kconfig option, so other radix tree users can also
set it if they have a need.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig                             |    3 ++
 lib/radix-tree.c                        |   26 +++++++++++++++-------
 mm/Kconfig                              |    1 
 tools/testing/radix-tree/linux/kernel.h |    1 
 4 files changed, 23 insertions(+), 8 deletions(-)

diff -puN lib/Kconfig~introduce-config_radix_tree_multiorder lib/Kconfig
--- a/lib/Kconfig~introduce-config_radix_tree_multiorder
+++ a/lib/Kconfig
@@ -362,6 +362,9 @@ config INTERVAL_TREE
 
 	  for more information.
 
+config RADIX_TREE_MULTIORDER
+	bool
+
 config ASSOCIATIVE_ARRAY
 	bool
 	help
diff -puN lib/radix-tree.c~introduce-config_radix_tree_multiorder lib/radix-tree.c
--- a/lib/radix-tree.c~introduce-config_radix_tree_multiorder
+++ a/lib/radix-tree.c
@@ -484,6 +484,7 @@ int __radix_tree_create(struct radix_tre
 		slot = node->slots[offset];
 	}
 
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
 	/* Insert pointers to the canonical entry */
 	if ((shift - order) > 0) {
 		int i, n = 1 << (shift - order);
@@ -499,6 +500,7 @@ int __radix_tree_create(struct radix_tre
 			node->count++;
 		}
 	}
+#endif
 
 	if (nodep)
 		*nodep = node;
@@ -1469,6 +1471,20 @@ bool __radix_tree_delete_node(struct rad
 	return deleted;
 }
 
+static inline void delete_sibling_entries(struct radix_tree_node *node,
+					void *ptr, unsigned offset)
+{
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	int i;
+	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
+		if (node->slots[offset + i] != ptr)
+			break;
+		node->slots[offset + i] = NULL;
+		node->count--;
+	}
+#endif
+}
+
 /**
  *	radix_tree_delete_item    -    delete an item from a radix tree
  *	@root:		radix tree root
@@ -1484,7 +1500,7 @@ void *radix_tree_delete_item(struct radi
 			     unsigned long index, void *item)
 {
 	struct radix_tree_node *node;
-	unsigned int offset, i;
+	unsigned int offset;
 	void **slot;
 	void *entry;
 	int tag;
@@ -1513,13 +1529,7 @@ void *radix_tree_delete_item(struct radi
 			radix_tree_tag_clear(root, index, tag);
 	}
 
-	/* Delete any sibling slots pointing to this slot */
-	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
-		if (node->slots[offset + i] != ptr_to_indirect(slot))
-			break;
-		node->slots[offset + i] = NULL;
-		node->count--;
-	}
+	delete_sibling_entries(node, ptr_to_indirect(slot), offset);
 	node->slots[offset] = NULL;
 	node->count--;
 
diff -puN mm/Kconfig~introduce-config_radix_tree_multiorder mm/Kconfig
--- a/mm/Kconfig~introduce-config_radix_tree_multiorder
+++ a/mm/Kconfig
@@ -404,6 +404,7 @@ config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select COMPACTION
+	select RADIX_TREE_MULTIORDER
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
 	  huge tlb transparently to the applications whenever possible.
diff -puN tools/testing/radix-tree/linux/kernel.h~introduce-config_radix_tree_multiorder tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~introduce-config_radix_tree_multiorder
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -9,6 +9,7 @@
 
 #include "../../include/linux/compiler.h"
 
+#define CONFIG_RADIX_TREE_MULTIORDER
 #define CONFIG_SHMEM
 #define CONFIG_SWAP
 
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

