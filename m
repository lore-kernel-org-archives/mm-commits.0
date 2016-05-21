From: akpm@linux-foundation.org
Subject: [patch 101/162] radix tree test suite: add tests for
 radix_tree_locate_item()
Date: Fri, 20 May 2016 17:01:39 -0700
Message-ID: <573fa563.lqhr4XFtVGyPNWnN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcEUABk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

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
