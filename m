From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-test-suite-start-adding-multiorder-tests.patch removed from -mm
 tree
Date: Mon, 23 May 2016 12:49:48 -0700
Message-ID: <57435edc.uzCBPWQq7zpyJO4i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbcEWTtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: start adding multiorder tests
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-start-adding-multiorder-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: start adding multiorder tests

Test suite infrastructure for working with multiorder entries.

The test itself is pretty basic: Add an entry, check that all expected
indices return that entry and that indices around that entry don't return
an entry.  Then delete the entry and check no index returns that entry. 
Tests a few edge conditions including the multiorder entry at index 0 and
at a higher index.  Also tests deleting through an alias as well as
through the canonical index.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/Makefile     |    2 
 tools/testing/radix-tree/main.c       |    2 
 tools/testing/radix-tree/multiorder.c |   58 ++++++++++++++++++++++++
 tools/testing/radix-tree/test.c       |   13 ++++-
 tools/testing/radix-tree/test.h       |    6 ++
 5 files changed, 76 insertions(+), 5 deletions(-)

diff -puN tools/testing/radix-tree/Makefile~radix-tree-test-suite-start-adding-multiorder-tests tools/testing/radix-tree/Makefile
--- a/tools/testing/radix-tree/Makefile~radix-tree-test-suite-start-adding-multiorder-tests
+++ a/tools/testing/radix-tree/Makefile
@@ -3,7 +3,7 @@ CFLAGS += -I. -g -Wall -D_LGPL_SOURCE
 LDFLAGS += -lpthread -lurcu
 TARGETS = main
 OFILES = main.o radix-tree.o linux.o test.o tag_check.o find_next_bit.o \
-	 regression1.o regression2.o regression3.o
+	 regression1.o regression2.o regression3.o multiorder.o
 
 targets: $(TARGETS)
 
diff -puN tools/testing/radix-tree/main.c~radix-tree-test-suite-start-adding-multiorder-tests tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-test-suite-start-adding-multiorder-tests
+++ a/tools/testing/radix-tree/main.c
@@ -275,6 +275,8 @@ static void single_thread_tests(bool lon
 	int i;
 
 	printf("starting single_thread_tests: %d allocated\n", nr_allocated);
+	multiorder_checks();
+	printf("after multiorder_check: %d allocated\n", nr_allocated);
 	locate_check();
 	printf("after locate_check: %d allocated\n", nr_allocated);
 	tag_check();
diff -puN /dev/null tools/testing/radix-tree/multiorder.c
--- /dev/null
+++ a/tools/testing/radix-tree/multiorder.c
@@ -0,0 +1,58 @@
+/*
+ * multiorder.c: Multi-order radix tree entry testing
+ * Copyright (c) 2016 Intel Corporation
+ * Author: Ross Zwisler <ross.zwisler@linux.intel.com>
+ * Author: Matthew Wilcox <matthew.r.wilcox@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/radix-tree.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+
+#include "test.h"
+
+static void multiorder_check(unsigned long index, int order)
+{
+	unsigned long i;
+	unsigned long min = index & ~((1UL << order) - 1);
+	unsigned long max = min + (1UL << order);
+	RADIX_TREE(tree, GFP_KERNEL);
+
+	printf("Multiorder index %ld, order %d\n", index, order);
+
+	assert(item_insert_order(&tree, index, order) == 0);
+
+	for (i = min; i < max; i++) {
+		struct item *item = item_lookup(&tree, i);
+		assert(item != 0);
+		assert(item->index == index);
+	}
+	for (i = 0; i < min; i++)
+		item_check_absent(&tree, i);
+	for (i = max; i < 2*max; i++)
+		item_check_absent(&tree, i);
+
+	assert(item_delete(&tree, index) != 0);
+
+	for (i = 0; i < 2*max; i++)
+		item_check_absent(&tree, i);
+}
+
+void multiorder_checks(void)
+{
+	int i;
+
+	for (i = 0; i < 20; i++) {
+		multiorder_check(200, i);
+		multiorder_check(0, i);
+		multiorder_check((1UL << i) + 1, i);
+	}
+}
diff -puN tools/testing/radix-tree/test.c~radix-tree-test-suite-start-adding-multiorder-tests tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-test-suite-start-adding-multiorder-tests
+++ a/tools/testing/radix-tree/test.c
@@ -24,14 +24,21 @@ int item_tag_get(struct radix_tree_root
 	return radix_tree_tag_get(root, index, tag);
 }
 
-int __item_insert(struct radix_tree_root *root, struct item *item)
+int __item_insert(struct radix_tree_root *root, struct item *item,
+			unsigned order)
 {
-	return radix_tree_insert(root, item->index, item);
+	return __radix_tree_insert(root, item->index, order, item);
 }
 
 int item_insert(struct radix_tree_root *root, unsigned long index)
 {
-	return __item_insert(root, item_create(index));
+	return __item_insert(root, item_create(index), 0);
+}
+
+int item_insert_order(struct radix_tree_root *root, unsigned long index,
+			unsigned order)
+{
+	return __item_insert(root, item_create(index), order);
 }
 
 int item_delete(struct radix_tree_root *root, unsigned long index)
diff -puN tools/testing/radix-tree/test.h~radix-tree-test-suite-start-adding-multiorder-tests tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-test-suite-start-adding-multiorder-tests
+++ a/tools/testing/radix-tree/test.h
@@ -8,8 +8,11 @@ struct item {
 };
 
 struct item *item_create(unsigned long index);
-int __item_insert(struct radix_tree_root *root, struct item *item);
+int __item_insert(struct radix_tree_root *root, struct item *item,
+			unsigned order);
 int item_insert(struct radix_tree_root *root, unsigned long index);
+int item_insert_order(struct radix_tree_root *root, unsigned long index,
+			unsigned order);
 int item_delete(struct radix_tree_root *root, unsigned long index);
 struct item *item_lookup(struct radix_tree_root *root, unsigned long index);
 
@@ -23,6 +26,7 @@ void item_full_scan(struct radix_tree_ro
 void item_kill_tree(struct radix_tree_root *root);
 
 void tag_check(void);
+void multiorder_checks(void);
 
 struct item *
 item_tag_set(struct radix_tree_root *root, unsigned long index, int tag);
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

