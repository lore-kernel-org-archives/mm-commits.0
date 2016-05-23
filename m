From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:49:14 -0700
Message-ID: <57435eba.aXnLheDa4FyEMP+E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbcEWTtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: add tests for radix_tree_locate_item()
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: add tests for radix_tree_locate_item()

Fairly simple tests; add various items to the tree, then make sure we can
find them again.  Also check that a pointer that we know isn't in the tree
is not found.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/kernel.h |    3 +
 tools/testing/radix-tree/main.c         |   41 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-add-tests-for-radix_tree_locate_item tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-add-tests-for-radix_tree_locate_item
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -9,6 +9,9 @@
 
 #include "../../include/linux/compiler.h"
 
+#define CONFIG_SHMEM
+#define CONFIG_SWAP
+
 #ifndef NULL
 #define NULL	0
 #endif
diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-add-tests-for-radix_tree_locate_item tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-add-tests-for-radix_tree_locate_item
+++ a/tools/testing/radix-tree/main.c
@@ -232,10 +232,51 @@ void copy_tag_check(void)
 	item_kill_tree(&tree);
 }
 
+void __locate_check(struct radix_tree_root *tree, unsigned long index)
+{
+	struct item *item;
+	unsigned long index2;
+
+	item_insert(tree, index);
+	item = item_lookup(tree, index);
+	index2 = radix_tree_locate_item(tree, item);
+	if (index != index2) {
+		printf("index %ld inserted; found %ld\n",
+			index, index2);
+		abort();
+	}
+}
+
+static void locate_check(void)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	unsigned long offset, index;
+
+	for (offset = 0; offset < (1 << 3); offset++) {
+		for (index = 0; index < (1UL << 5); index++) {
+			__locate_check(&tree, index + offset);
+		}
+		if (radix_tree_locate_item(&tree, &tree) != -1)
+			abort();
+
+		item_kill_tree(&tree);
+	}
+
+	if (radix_tree_locate_item(&tree, &tree) != -1)
+		abort();
+	__locate_check(&tree, -1);
+	if (radix_tree_locate_item(&tree, &tree) != -1)
+		abort();
+	item_kill_tree(&tree);
+}
+
 static void single_thread_tests(void)
 {
 	int i;
 
+	printf("starting single_thread_tests: %d allocated\n", nr_allocated);
+	locate_check();
+	printf("after locate_check: %d allocated\n", nr_allocated);
 	tag_check();
 	printf("after tag_check: %d allocated\n", nr_allocated);
 	gang_check();
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

