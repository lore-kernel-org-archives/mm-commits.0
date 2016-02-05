From: akpm@linux-foundation.org
Subject: + radix-tree-tests-add-regression3-test.patch added to -mm tree
Date: Fri, 05 Feb 2016 14:20:46 -0800
Message-ID: <56b5203e.MjSYceuZDUTc5+BG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbcBEWUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 17:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree tests: add regression3 test
has been added to the -mm tree.  Its filename is
     radix-tree-tests-add-regression3-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-tests-add-regression3-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-tests-add-regression3-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree tests: add regression3 test

After calling radix_tree_iter_retry(), 'slot' will be set to NULL.  This
can cause radix_tree_next_slot() to dereference the NULL pointer.  Add
Konstantin Khlebnikov's test to the regression framework.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reported-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/Makefile       |    2 
 tools/testing/radix-tree/linux/kernel.h |    1 
 tools/testing/radix-tree/main.c         |    1 
 tools/testing/radix-tree/regression.h   |    1 
 tools/testing/radix-tree/regression3.c  |   86 ++++++++++++++++++++++
 5 files changed, 90 insertions(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/Makefile~radix-tree-tests-add-regression3-test tools/testing/radix-tree/Makefile
--- a/tools/testing/radix-tree/Makefile~radix-tree-tests-add-regression3-test
+++ a/tools/testing/radix-tree/Makefile
@@ -3,7 +3,7 @@ CFLAGS += -I. -g -Wall -D_LGPL_SOURCE
 LDFLAGS += -lpthread -lurcu
 TARGETS = main
 OFILES = main.o radix-tree.o linux.o test.o tag_check.o find_next_bit.o \
-	 regression1.o regression2.o
+	 regression1.o regression2.o regression3.o
 
 targets: $(TARGETS)
 
diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-tests-add-regression3-test tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-tests-add-regression3-test
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -13,6 +13,7 @@
 
 #define BUG_ON(expr)	assert(!(expr))
 #define __init
+#define __must_check
 #define panic(expr)
 #define printk printf
 #define __force
diff -puN tools/testing/radix-tree/main.c~radix-tree-tests-add-regression3-test tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-tests-add-regression3-test
+++ a/tools/testing/radix-tree/main.c
@@ -261,6 +261,7 @@ int main(void)
 
 	regression1_test();
 	regression2_test();
+	regression3_test();
 	single_thread_tests();
 
 	sleep(1);
diff -puN tools/testing/radix-tree/regression.h~radix-tree-tests-add-regression3-test tools/testing/radix-tree/regression.h
--- a/tools/testing/radix-tree/regression.h~radix-tree-tests-add-regression3-test
+++ a/tools/testing/radix-tree/regression.h
@@ -3,5 +3,6 @@
 
 void regression1_test(void);
 void regression2_test(void);
+void regression3_test(void);
 
 #endif
diff -puN /dev/null tools/testing/radix-tree/regression3.c
--- /dev/null
+++ a/tools/testing/radix-tree/regression3.c
@@ -0,0 +1,86 @@
+/*
+ * Regression3
+ * Description:
+ * Helper radix_tree_iter_retry resets next_index to the current index.
+ * In following radix_tree_next_slot current chunk size becomes zero.
+ * This isn't checked and it tries to dereference null pointer in slot.
+ *
+ * Running:
+ * This test should run to completion immediately. The above bug would
+ * cause it to segfault.
+ *
+ * Upstream commit:
+ * Not yet
+ */
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/radix-tree.h>
+#include <stdlib.h>
+#include <stdio.h>
+
+#include "regression.h"
+
+void regression3_test(void)
+{
+	RADIX_TREE(root, GFP_KERNEL);
+	void *ptr = (void *)4ul;
+	struct radix_tree_iter iter;
+	void **slot;
+	bool first;
+
+	printf("running regression test 3 (should take milliseconds)\n");
+
+	radix_tree_insert(&root, 0, ptr);
+	radix_tree_tag_set(&root, 0, 0);
+
+	first = true;
+	radix_tree_for_each_tagged(slot, &root, &iter, 0, 0) {
+//		printk("tagged %ld %p\n", iter.index, *slot);
+		if (first) {
+			radix_tree_insert(&root, 1, ptr);
+			radix_tree_tag_set(&root, 1, 0);
+			first = false;
+		}
+		if (radix_tree_deref_retry(*slot)) {
+//			printk("retry %ld\n", iter.index);
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+	}
+	radix_tree_delete(&root, 1);
+
+	first = true;
+	radix_tree_for_each_slot(slot, &root, &iter, 0) {
+//		printk("slot %ld %p\n", iter.index, *slot);
+		if (first) {
+			radix_tree_insert(&root, 1, ptr);
+			first = false;
+		}
+		if (radix_tree_deref_retry(*slot)) {
+//			printk("retry %ld\n", iter.index);
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+	}
+	radix_tree_delete(&root, 1);
+
+	first = true;
+	radix_tree_for_each_contig(slot, &root, &iter, 0) {
+//		printk("contig %ld %p\n", iter.index, *slot);
+		if (first) {
+			radix_tree_insert(&root, 1, ptr);
+			first = false;
+		}
+		if (radix_tree_deref_retry(*slot)) {
+//			printk("retry %ld\n", iter.index);
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+	}
+
+	radix_tree_delete(&root, 0);
+	radix_tree_delete(&root, 1);
+
+	printf("regression test 3 passed\n");
+}
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write.patch
radix-tree-fix-oops-after-radix_tree_iter_retry.patch
radix-tree-tests-add-regression3-test.patch

