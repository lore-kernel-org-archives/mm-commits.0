From: akpm@linux-foundation.org
Subject: [merged] radix-tree-tests-add-test-for-radix_tree_iter_next.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:59 -0700
Message-ID: <56f04077.KHbzXzF3LsEbchlp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbcCUTVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree tests: add test for radix_tree_iter_next
has been removed from the -mm tree.  Its filename was
     radix-tree-tests-add-test-for-radix_tree_iter_next.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree tests: add test for radix_tree_iter_next

Without fix test crashes inside tagged iteration.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/regression3.c |   47 +++++++++++++++++++----
 1 file changed, 39 insertions(+), 8 deletions(-)

diff -puN tools/testing/radix-tree/regression3.c~radix-tree-tests-add-test-for-radix_tree_iter_next tools/testing/radix-tree/regression3.c
--- a/tools/testing/radix-tree/regression3.c~radix-tree-tests-add-test-for-radix_tree_iter_next
+++ a/tools/testing/radix-tree/regression3.c
@@ -5,6 +5,10 @@
  * In following radix_tree_next_slot current chunk size becomes zero.
  * This isn't checked and it tries to dereference null pointer in slot.
  *
+ * Helper radix_tree_iter_next reset slot to NULL and next_index to index + 1,
+ * for tagger iteraction it also must reset cached tags in iterator to abort
+ * next radix_tree_next_slot and go to slow-path into radix_tree_next_chunk.
+ *
  * Running:
  * This test should run to completion immediately. The above bug would
  * cause it to segfault.
@@ -24,26 +28,27 @@
 void regression3_test(void)
 {
 	RADIX_TREE(root, GFP_KERNEL);
-	void *ptr = (void *)4ul;
+	void *ptr0 = (void *)4ul;
+	void *ptr = (void *)8ul;
 	struct radix_tree_iter iter;
 	void **slot;
 	bool first;
 
 	printf("running regression test 3 (should take milliseconds)\n");
 
-	radix_tree_insert(&root, 0, ptr);
+	radix_tree_insert(&root, 0, ptr0);
 	radix_tree_tag_set(&root, 0, 0);
 
 	first = true;
 	radix_tree_for_each_tagged(slot, &root, &iter, 0, 0) {
-//		printk("tagged %ld %p\n", iter.index, *slot);
+		printf("tagged %ld %p\n", iter.index, *slot);
 		if (first) {
 			radix_tree_insert(&root, 1, ptr);
 			radix_tree_tag_set(&root, 1, 0);
 			first = false;
 		}
 		if (radix_tree_deref_retry(*slot)) {
-//			printk("retry %ld\n", iter.index);
+			printf("retry at %ld\n", iter.index);
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
@@ -52,13 +57,13 @@ void regression3_test(void)
 
 	first = true;
 	radix_tree_for_each_slot(slot, &root, &iter, 0) {
-//		printk("slot %ld %p\n", iter.index, *slot);
+		printf("slot %ld %p\n", iter.index, *slot);
 		if (first) {
 			radix_tree_insert(&root, 1, ptr);
 			first = false;
 		}
 		if (radix_tree_deref_retry(*slot)) {
-//			printk("retry %ld\n", iter.index);
+			printk("retry at %ld\n", iter.index);
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
@@ -67,18 +72,44 @@ void regression3_test(void)
 
 	first = true;
 	radix_tree_for_each_contig(slot, &root, &iter, 0) {
-//		printk("contig %ld %p\n", iter.index, *slot);
+		printk("contig %ld %p\n", iter.index, *slot);
 		if (first) {
 			radix_tree_insert(&root, 1, ptr);
 			first = false;
 		}
 		if (radix_tree_deref_retry(*slot)) {
-//			printk("retry %ld\n", iter.index);
+			printk("retry at %ld\n", iter.index);
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
 	}
 
+	radix_tree_for_each_slot(slot, &root, &iter, 0) {
+		printf("slot %ld %p\n", iter.index, *slot);
+		if (!iter.index) {
+			printf("next at %ld\n", iter.index);
+			slot = radix_tree_iter_next(&iter);
+		}
+	}
+
+	radix_tree_for_each_contig(slot, &root, &iter, 0) {
+		printf("contig %ld %p\n", iter.index, *slot);
+		if (!iter.index) {
+			printf("next at %ld\n", iter.index);
+			slot = radix_tree_iter_next(&iter);
+		}
+	}
+
+	radix_tree_tag_set(&root, 0, 0);
+	radix_tree_tag_set(&root, 1, 0);
+	radix_tree_for_each_tagged(slot, &root, &iter, 0, 0) {
+		printf("tagged %ld %p\n", iter.index, *slot);
+		if (!iter.index) {
+			printf("next at %ld\n", iter.index);
+			slot = radix_tree_iter_next(&iter);
+		}
+	}
+
 	radix_tree_delete(&root, 0);
 	radix_tree_delete(&root, 1);
 
_

Patches currently in -mm which might be from koct9i@gmail.com are


