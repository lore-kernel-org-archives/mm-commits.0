From: akpm@linux-foundation.org
Subject: [patch 089/114] radix tree test suite: record order in each item
Date: Wed, 14 Dec 2016 15:08:23 -0800
Message-ID: <5851d0e7.fe6MyU7dILvMRhUe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934101AbcLNXIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com

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
Cc: Matthew Wilcox <mawilcox@microsoft.com>
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
