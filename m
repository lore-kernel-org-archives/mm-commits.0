From: akpm@linux-foundation.org
Subject: [patch 122/162] radix-tree test suite: add multi-order tag test
Date: Fri, 20 May 2016 17:02:41 -0700
Message-ID: <573fa5a1.pZekuW/S1LnW0OPw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcEUACm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree test suite: add multi-order tag test

Add a generic test for multi-order tag verification, and call it using
several different configurations.

This test creates a multi-order radix tree using the given index and
order, and then sets, checks and clears tags using the indices covered by
the single multi-order radix tree entry.

With the various calls done by this test we verify root multi-order
entries without siblings, multi-order entries without siblings in a radix
tree node, as well as multi-order entries with siblings of various sizes.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/multiorder.c |   97 ++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-test-suite-add-multi-order-tag-test tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-test-suite-add-multi-order-tag-test
+++ a/tools/testing/radix-tree/multiorder.c
@@ -19,6 +19,102 @@
 
 #include "test.h"
 
+#define for_each_index(i, base, order) \
+	for (i = base; i < base + (1 << order); i++)
+
+static void __multiorder_tag_test(int index, int order)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	int base, err, i;
+
+	/* our canonical entry */
+	base = index & ~((1 << order) - 1);
+
+	printf("Multiorder tag test with index %d, canonical entry %d\n",
+			index, base);
+
+	err = item_insert_order(&tree, index, order);
+	assert(!err);
+
+	/*
+	 * Verify we get collisions for covered indices.  We try and fail to
+	 * insert an exceptional entry so we don't leak memory via
+	 * item_insert_order().
+	 */
+	for_each_index(i, base, order) {
+		err = __radix_tree_insert(&tree, i, order,
+				(void *)(0xA0 | RADIX_TREE_EXCEPTIONAL_ENTRY));
+		assert(err == -EEXIST);
+	}
+
+	for_each_index(i, base, order) {
+		assert(!radix_tree_tag_get(&tree, i, 0));
+		assert(!radix_tree_tag_get(&tree, i, 1));
+	}
+
+	assert(radix_tree_tag_set(&tree, index, 0));
+
+	for_each_index(i, base, order) {
+		assert(radix_tree_tag_get(&tree, i, 0));
+		assert(!radix_tree_tag_get(&tree, i, 1));
+	}
+
+	assert(radix_tree_tag_clear(&tree, index, 0));
+
+	for_each_index(i, base, order) {
+		assert(!radix_tree_tag_get(&tree, i, 0));
+		assert(!radix_tree_tag_get(&tree, i, 1));
+	}
+
+	assert(!radix_tree_tagged(&tree, 0));
+	assert(!radix_tree_tagged(&tree, 1));
+
+	item_kill_tree(&tree);
+}
+
+static void multiorder_tag_tests(void)
+{
+	/* test multi-order entry for indices 0-7 with no sibling pointers */
+	__multiorder_tag_test(0, 3);
+	__multiorder_tag_test(5, 3);
+
+	/* test multi-order entry for indices 8-15 with no sibling pointers */
+	__multiorder_tag_test(8, 3);
+	__multiorder_tag_test(15, 3);
+
+	/*
+	 * Our order 5 entry covers indices 0-31 in a tree with height=2.
+	 * This is broken up as follows:
+	 * 0-7:		canonical entry
+	 * 8-15:	sibling 1
+	 * 16-23:	sibling 2
+	 * 24-31:	sibling 3
+	 */
+	__multiorder_tag_test(0, 5);
+	__multiorder_tag_test(29, 5);
+
+	/* same test, but with indices 32-63 */
+	__multiorder_tag_test(32, 5);
+	__multiorder_tag_test(44, 5);
+
+	/*
+	 * Our order 8 entry covers indices 0-255 in a tree with height=3.
+	 * This is broken up as follows:
+	 * 0-63:	canonical entry
+	 * 64-127:	sibling 1
+	 * 128-191:	sibling 2
+	 * 192-255:	sibling 3
+	 */
+	__multiorder_tag_test(0, 8);
+	__multiorder_tag_test(190, 8);
+
+	/* same test, but with indices 256-511 */
+	__multiorder_tag_test(256, 8);
+	__multiorder_tag_test(300, 8);
+
+	__multiorder_tag_test(0x12345678UL, 8);
+}
+
 static void multiorder_check(unsigned long index, int order)
 {
 	unsigned long i;
@@ -196,6 +292,7 @@ void multiorder_checks(void)
 		multiorder_shrink((1UL << (i + RADIX_TREE_MAP_SHIFT)), i);
 
 	multiorder_insert_bug();
+	multiorder_tag_tests();
 	multiorder_iteration();
 	multiorder_tagged_iteration();
 }
_
