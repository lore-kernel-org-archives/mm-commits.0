From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-record-order-in-each-item.patch added to
 -mm tree
Date: Tue, 06 Dec 2016 12:50:29 -0800
Message-ID: <58472495.n3Gz4rF9apCyrMlC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUt7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: record order in each item
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-record-order-in-each-item.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-record-order-in-each-item.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-record-order-in-each-item.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix tree test suite: record order in each item

This probably doubles the size of each item allocated by the test suite
but it lets us check a few more things, and may be needed for upcoming API
changes that require the caller pass in the order of the entry.

Link: http://lkml.kernel.org/r/1480369871-5271-46-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/multiorder.c |    2 -
 tools/testing/radix-tree/test.c       |   29 +++++++++++++++---------
 tools/testing/radix-tree/test.h       |    6 ++--
 3 files changed, 23 insertions(+), 14 deletions(-)

diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-test-suite-record-order-in-each-item tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-test-suite-record-order-in-each-item
+++ a/tools/testing/radix-tree/multiorder.c
@@ -125,7 +125,7 @@ static void multiorder_check(unsigned lo
 	unsigned long min = index & ~((1UL << order) - 1);
 	unsigned long max = min + (1UL << order);
 	void **slot;
-	struct item *item2 = item_create(min);
+	struct item *item2 = item_create(min, order);
 	RADIX_TREE(tree, GFP_KERNEL);
 
 	printf("Multiorder index %ld, order %d\n", index, order);
diff -puN tools/testing/radix-tree/test.c~radix-tree-test-suite-record-order-in-each-item tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-test-suite-record-order-in-each-item
+++ a/tools/testing/radix-tree/test.c
@@ -24,21 +24,29 @@ int item_tag_get(struct radix_tree_root
 	return radix_tree_tag_get(root, index, tag);
 }
 
-int __item_insert(struct radix_tree_root *root, struct item *item,
-			unsigned order)
+int __item_insert(struct radix_tree_root *root, struct item *item)
 {
-	return __radix_tree_insert(root, item->index, order, item);
+	return __radix_tree_insert(root, item->index, item->order, item);
 }
 
 int item_insert(struct radix_tree_root *root, unsigned long index)
 {
-	return __item_insert(root, item_create(index), 0);
+	return __item_insert(root, item_create(index, 0));
 }
 
 int item_insert_order(struct radix_tree_root *root, unsigned long index,
 			unsigned order)
 {
-	return __item_insert(root, item_create(index), order);
+	return __item_insert(root, item_create(index, order));
+}
+
+void item_sanity(struct item *item, unsigned long index)
+{
+	unsigned long mask;
+	assert(!radix_tree_is_internal_node(item));
+	assert(item->order < BITS_PER_LONG);
+	mask = (1UL << item->order) - 1;
+	assert((item->index | mask) == (index | mask));
 }
 
 int item_delete(struct radix_tree_root *root, unsigned long index)
@@ -46,18 +54,19 @@ int item_delete(struct radix_tree_root *
 	struct item *item = radix_tree_delete(root, index);
 
 	if (item) {
-		assert(item->index == index);
+		item_sanity(item, index);
 		free(item);
 		return 1;
 	}
 	return 0;
 }
 
-struct item *item_create(unsigned long index)
+struct item *item_create(unsigned long index, unsigned int order)
 {
 	struct item *ret = malloc(sizeof(*ret));
 
 	ret->index = index;
+	ret->order = order;
 	return ret;
 }
 
@@ -66,8 +75,8 @@ void item_check_present(struct radix_tre
 	struct item *item;
 
 	item = radix_tree_lookup(root, index);
-	assert(item != 0);
-	assert(item->index == index);
+	assert(item != NULL);
+	item_sanity(item, index);
 }
 
 struct item *item_lookup(struct radix_tree_root *root, unsigned long index)
@@ -80,7 +89,7 @@ void item_check_absent(struct radix_tree
 	struct item *item;
 
 	item = radix_tree_lookup(root, index);
-	assert(item == 0);
+	assert(item == NULL);
 }
 
 /*
diff -puN tools/testing/radix-tree/test.h~radix-tree-test-suite-record-order-in-each-item tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-test-suite-record-order-in-each-item
+++ a/tools/testing/radix-tree/test.h
@@ -5,11 +5,11 @@
 
 struct item {
 	unsigned long index;
+	unsigned int order;
 };
 
-struct item *item_create(unsigned long index);
-int __item_insert(struct radix_tree_root *root, struct item *item,
-			unsigned order);
+struct item *item_create(unsigned long index, unsigned int order);
+int __item_insert(struct radix_tree_root *root, struct item *item);
 int item_insert(struct radix_tree_root *root, unsigned long index);
 int item_insert_order(struct radix_tree_root *root, unsigned long index,
 			unsigned order);
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch

