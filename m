From: akpm@linux-foundation.org
Subject: + lib-add-module-support-to-linked-list-sorting-tests.patch added to -mm tree
Date: Tue, 28 Feb 2017 15:57:14 -0800
Message-ID: <58b60e5a.aitDZg8Ra4kfX1iV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41778 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdCAELY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 23:11:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add module support to linked list sorting tests
has been added to the -mm tree.  Its filename is
     lib-add-module-support-to-linked-list-sorting-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-module-support-to-linked-list-sorting-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-module-support-to-linked-list-sorting-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib: add module support to linked list sorting tests

Extract the linked list sorting test code into its own source file, to
allow to compile it either to a loadable module, or builtin into the
kernel.

Link: http://lkml.kernel.org/r/1488287219-15832-4-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug    |    7 +
 lib/Makefile         |    1 
 lib/list_sort.c      |  149 ----------------------------------------
 lib/test_list_sort.c |  150 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 155 insertions(+), 152 deletions(-)

diff -puN lib/Kconfig.debug~lib-add-module-support-to-linked-list-sorting-tests lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-add-module-support-to-linked-list-sorting-tests
+++ a/lib/Kconfig.debug
@@ -1718,11 +1718,12 @@ config LKDTM
 	Documentation/fault-injection/provoke-crashes.txt
 
 config TEST_LIST_SORT
-	bool "Linked list sorting test"
-	depends on DEBUG_KERNEL
+	tristate "Linked list sorting test"
+	depends on DEBUG_KERNEL || m
 	help
 	  Enable this to turn on 'list_sort()' function test. This test is
-	  executed only once during system boot, so affects only boot time.
+	  executed only once during system boot (so affects only boot time),
+	  or at module load time.
 
 	  If unsure, say N.
 
diff -puN lib/Makefile~lib-add-module-support-to-linked-list-sorting-tests lib/Makefile
--- a/lib/Makefile~lib-add-module-support-to-linked-list-sorting-tests
+++ a/lib/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_TEST_FIRMWARE) += test_firm
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
+obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_RHASHTABLE) += test_rhashtable.o
 obj-$(CONFIG_TEST_SORT) += test_sort.o
diff -puN lib/list_sort.c~lib-add-module-support-to-linked-list-sorting-tests lib/list_sort.c
--- a/lib/list_sort.c~lib-add-module-support-to-linked-list-sorting-tests
+++ a/lib/list_sort.c
@@ -1,6 +1,3 @@
-
-#define pr_fmt(fmt) "list_sort_test: " fmt
-
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
@@ -145,149 +142,3 @@ void list_sort(void *priv, struct list_h
 	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
 }
 EXPORT_SYMBOL(list_sort);
-
-#ifdef CONFIG_TEST_LIST_SORT
-
-#include <linux/slab.h>
-#include <linux/random.h>
-
-/*
- * The pattern of set bits in the list length determines which cases
- * are hit in list_sort().
- */
-#define TEST_LIST_LEN (512+128+2) /* not including head */
-
-#define TEST_POISON1 0xDEADBEEF
-#define TEST_POISON2 0xA324354C
-
-struct debug_el {
-	unsigned int poison1;
-	struct list_head list;
-	unsigned int poison2;
-	int value;
-	unsigned serial;
-};
-
-/* Array, containing pointers to all elements in the test list */
-static struct debug_el **elts __initdata;
-
-static int __init check(struct debug_el *ela, struct debug_el *elb)
-{
-	if (ela->serial >= TEST_LIST_LEN) {
-		pr_err("error: incorrect serial %d\n", ela->serial);
-		return -EINVAL;
-	}
-	if (elb->serial >= TEST_LIST_LEN) {
-		pr_err("error: incorrect serial %d\n", elb->serial);
-		return -EINVAL;
-	}
-	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
-		pr_err("error: phantom element\n");
-		return -EINVAL;
-	}
-	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
-		pr_err("error: bad poison: %#x/%#x\n",
-			ela->poison1, ela->poison2);
-		return -EINVAL;
-	}
-	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
-		pr_err("error: bad poison: %#x/%#x\n",
-			elb->poison1, elb->poison2);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
-{
-	struct debug_el *ela, *elb;
-
-	ela = container_of(a, struct debug_el, list);
-	elb = container_of(b, struct debug_el, list);
-
-	check(ela, elb);
-	return ela->value - elb->value;
-}
-
-static int __init list_sort_test(void)
-{
-	int i, count = 1, err = -ENOMEM;
-	struct debug_el *el;
-	struct list_head *cur;
-	LIST_HEAD(head);
-
-	pr_debug("start testing list_sort()\n");
-
-	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
-	if (!elts) {
-		pr_err("error: cannot allocate memory\n");
-		return err;
-	}
-
-	for (i = 0; i < TEST_LIST_LEN; i++) {
-		el = kmalloc(sizeof(*el), GFP_KERNEL);
-		if (!el) {
-			pr_err("error: cannot allocate memory\n");
-			goto exit;
-		}
-		 /* force some equivalencies */
-		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
-		el->serial = i;
-		el->poison1 = TEST_POISON1;
-		el->poison2 = TEST_POISON2;
-		elts[i] = el;
-		list_add_tail(&el->list, &head);
-	}
-
-	list_sort(NULL, &head, cmp);
-
-	err = -EINVAL;
-	for (cur = head.next; cur->next != &head; cur = cur->next) {
-		struct debug_el *el1;
-		int cmp_result;
-
-		if (cur->next->prev != cur) {
-			pr_err("error: list is corrupted\n");
-			goto exit;
-		}
-
-		cmp_result = cmp(NULL, cur, cur->next);
-		if (cmp_result > 0) {
-			pr_err("error: list is not sorted\n");
-			goto exit;
-		}
-
-		el = container_of(cur, struct debug_el, list);
-		el1 = container_of(cur->next, struct debug_el, list);
-		if (cmp_result == 0 && el->serial >= el1->serial) {
-			pr_err("error: order of equivalent elements not "
-				"preserved\n");
-			goto exit;
-		}
-
-		if (check(el, el1)) {
-			pr_err("error: element check failed\n");
-			goto exit;
-		}
-		count++;
-	}
-	if (head.prev != cur) {
-		pr_err("error: list is corrupted\n");
-		goto exit;
-	}
-
-
-	if (count != TEST_LIST_LEN) {
-		pr_err("error: bad list length %d", count);
-		goto exit;
-	}
-
-	err = 0;
-exit:
-	for (i = 0; i < TEST_LIST_LEN; i++)
-		kfree(elts[i]);
-	kfree(elts);
-	return err;
-}
-late_initcall(list_sort_test);
-#endif /* CONFIG_TEST_LIST_SORT */
diff -puN /dev/null lib/test_list_sort.c
--- /dev/null
+++ a/lib/test_list_sort.c
@@ -0,0 +1,150 @@
+#define pr_fmt(fmt) "list_sort_test: " fmt
+
+#include <linux/kernel.h>
+#include <linux/list_sort.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+
+/*
+ * The pattern of set bits in the list length determines which cases
+ * are hit in list_sort().
+ */
+#define TEST_LIST_LEN (512+128+2) /* not including head */
+
+#define TEST_POISON1 0xDEADBEEF
+#define TEST_POISON2 0xA324354C
+
+struct debug_el {
+	unsigned int poison1;
+	struct list_head list;
+	unsigned int poison2;
+	int value;
+	unsigned serial;
+};
+
+/* Array, containing pointers to all elements in the test list */
+static struct debug_el **elts __initdata;
+
+static int __init check(struct debug_el *ela, struct debug_el *elb)
+{
+	if (ela->serial >= TEST_LIST_LEN) {
+		pr_err("error: incorrect serial %d\n", ela->serial);
+		return -EINVAL;
+	}
+	if (elb->serial >= TEST_LIST_LEN) {
+		pr_err("error: incorrect serial %d\n", elb->serial);
+		return -EINVAL;
+	}
+	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
+		pr_err("error: phantom element\n");
+		return -EINVAL;
+	}
+	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
+		pr_err("error: bad poison: %#x/%#x\n",
+			ela->poison1, ela->poison2);
+		return -EINVAL;
+	}
+	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
+		pr_err("error: bad poison: %#x/%#x\n",
+			elb->poison1, elb->poison2);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct debug_el *ela, *elb;
+
+	ela = container_of(a, struct debug_el, list);
+	elb = container_of(b, struct debug_el, list);
+
+	check(ela, elb);
+	return ela->value - elb->value;
+}
+
+static int __init list_sort_test(void)
+{
+	int i, count = 1, err = -ENOMEM;
+	struct debug_el *el;
+	struct list_head *cur;
+	LIST_HEAD(head);
+
+	pr_debug("start testing list_sort()\n");
+
+	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
+	if (!elts) {
+		pr_err("error: cannot allocate memory\n");
+		return err;
+	}
+
+	for (i = 0; i < TEST_LIST_LEN; i++) {
+		el = kmalloc(sizeof(*el), GFP_KERNEL);
+		if (!el) {
+			pr_err("error: cannot allocate memory\n");
+			goto exit;
+		}
+		 /* force some equivalencies */
+		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
+		el->serial = i;
+		el->poison1 = TEST_POISON1;
+		el->poison2 = TEST_POISON2;
+		elts[i] = el;
+		list_add_tail(&el->list, &head);
+	}
+
+	list_sort(NULL, &head, cmp);
+
+	err = -EINVAL;
+	for (cur = head.next; cur->next != &head; cur = cur->next) {
+		struct debug_el *el1;
+		int cmp_result;
+
+		if (cur->next->prev != cur) {
+			pr_err("error: list is corrupted\n");
+			goto exit;
+		}
+
+		cmp_result = cmp(NULL, cur, cur->next);
+		if (cmp_result > 0) {
+			pr_err("error: list is not sorted\n");
+			goto exit;
+		}
+
+		el = container_of(cur, struct debug_el, list);
+		el1 = container_of(cur->next, struct debug_el, list);
+		if (cmp_result == 0 && el->serial >= el1->serial) {
+			pr_err("error: order of equivalent elements not "
+				"preserved\n");
+			goto exit;
+		}
+
+		if (check(el, el1)) {
+			pr_err("error: element check failed\n");
+			goto exit;
+		}
+		count++;
+	}
+	if (head.prev != cur) {
+		pr_err("error: list is corrupted\n");
+		goto exit;
+	}
+
+
+	if (count != TEST_LIST_LEN) {
+		pr_err("error: bad list length %d", count);
+		goto exit;
+	}
+
+	err = 0;
+exit:
+	for (i = 0; i < TEST_LIST_LEN; i++)
+		kfree(elts[i]);
+	kfree(elts);
+	return err;
+}
+module_init(list_sort_test);
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from geert@linux-m68k.org are

revert-lib-test_sortc-make-it-explicitly-non-modular.patch
lib-add-module-support-to-array-based-sort-tests.patch
lib-add-module-support-to-linked-list-sorting-tests.patch

