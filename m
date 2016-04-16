From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-multi-order-iteration-test.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:58:34 -0700
Message-ID: <5711d48a.7GCe1Rzo88yojRcl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDPF6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: multi-order iteration test
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-multi-order-iteration-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-multi-order-iteration-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-multi-order-iteration-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix tree test suite: multi-order iteration test

Add a unit test to verify that we can iterate over multi-order entries
properly via a radix_tree_for_each_slot() loop.

This was done with a single, somewhat complicated configuration that was
meant to test many of the various corner cases having to do with
multi-order entries:

- An iteration could begin at a sibling entry, and we need to return the
  canonical entry.
- We could have entries of various orders in the same slots[] array.
- We could have multi-order entries at a nonzero height, followed by
  indirect pointers to more radix tree nodes later in that same slots[]
  array.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/multiorder.c |   92 ++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-test-suite-multi-order-iteration-test tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-test-suite-multi-order-iteration-test
+++ a/tools/testing/radix-tree/multiorder.c
@@ -92,6 +92,96 @@ static void multiorder_insert_bug(void)
 	item_kill_tree(&tree);
 }
 
+void multiorder_iteration(void)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_iter iter;
+	void **slot;
+	int i, err;
+
+	printf("Multiorder iteration test\n");
+
+#define NUM_ENTRIES 11
+	int index[NUM_ENTRIES] = {0, 2, 4, 8, 16, 32, 34, 36, 64, 72, 128};
+	int order[NUM_ENTRIES] = {1, 1, 2, 3,  4,  1,  0,  1,  3,  0, 7};
+
+	for (i = 0; i < NUM_ENTRIES; i++) {
+		err = item_insert_order(&tree, index[i], order[i]);
+		assert(!err);
+	}
+
+	i = 0;
+	/* start from index 1 to verify we find the multi-order entry at 0 */
+	radix_tree_for_each_slot(slot, &tree, &iter, 1) {
+		int height = order[i] / RADIX_TREE_MAP_SHIFT;
+		int shift = height * RADIX_TREE_MAP_SHIFT;
+
+		assert(iter.index == index[i]);
+		assert(iter.shift == shift);
+		i++;
+	}
+
+	/*
+	 * Now iterate through the tree starting at an elevated multi-order
+	 * entry, beginning at an index in the middle of the range.
+	 */
+	i = 8;
+	radix_tree_for_each_slot(slot, &tree, &iter, 70) {
+		int height = order[i] / RADIX_TREE_MAP_SHIFT;
+		int shift = height * RADIX_TREE_MAP_SHIFT;
+
+		assert(iter.index == index[i]);
+		assert(iter.shift == shift);
+		i++;
+	}
+
+	item_kill_tree(&tree);
+}
+
+void multiorder_tagged_iteration(void)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_iter iter;
+	void **slot;
+	int i;
+
+	printf("Multiorder tagged iteration test\n");
+
+#define MT_NUM_ENTRIES 9
+	int index[MT_NUM_ENTRIES] = {0, 2, 4, 16, 32, 40, 64, 72, 128};
+	int order[MT_NUM_ENTRIES] = {1, 0, 2, 4,  3,  1,  3,  0,   7};
+
+#define TAG_ENTRIES 7
+	int tag_index[TAG_ENTRIES] = {0, 4, 16, 40, 64, 72, 128};
+
+	for (i = 0; i < MT_NUM_ENTRIES; i++)
+		assert(!item_insert_order(&tree, index[i], order[i]));
+
+	assert(!radix_tree_tagged(&tree, 1));
+
+	for (i = 0; i < TAG_ENTRIES; i++)
+		assert(radix_tree_tag_set(&tree, tag_index[i], 1));
+
+	i = 0;
+	/* start from index 1 to verify we find the multi-order entry at 0 */
+	radix_tree_for_each_tagged(slot, &tree, &iter, 1, 1) {
+		assert(iter.index == tag_index[i]);
+		i++;
+	}
+
+	/*
+	 * Now iterate through the tree starting at an elevated multi-order
+	 * entry, beginning at an index in the middle of the range.
+	 */
+	i = 4;
+	radix_tree_for_each_slot(slot, &tree, &iter, 70) {
+		assert(iter.index == tag_index[i]);
+		i++;
+	}
+
+	item_kill_tree(&tree);
+}
+
 void multiorder_checks(void)
 {
 	int i;
@@ -106,4 +196,6 @@ void multiorder_checks(void)
 		multiorder_shrink((1UL << (i + RADIX_TREE_MAP_SHIFT)), i);
 
 	multiorder_insert_bug();
+	multiorder_iteration();
+	multiorder_tagged_iteration();
 }
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-test-suite-allow-testing-other-fan-out-values.patch
radix-tree-test-suite-keep-regression-test-runs-short.patch
radix-tree-test-suite-rebuild-when-headers-change.patch
radix-tree-remove-unused-looping-macros.patch
radix-tree-add-support-for-multi-order-iterating.patch
radix-tree-test-suite-multi-order-iteration-test.patch
radix-tree-rewrite-radix_tree_tag_set.patch
radix-tree-rewrite-radix_tree_tag_clear.patch
radix-tree-rewrite-radix_tree_tag_get.patch
radix-tree-test-suite-add-multi-order-tag-test.patch
radix-tree-fix-radix_tree_dump-for-multi-order-entries.patch

