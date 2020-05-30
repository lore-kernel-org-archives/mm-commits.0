From: akpm@linux-foundation.org
Subject: + lib-make-a-test-module-with-get_count_order-long.patch
 added to -mm tree
Date: Fri, 29 May 2020 17:51:13 -0700
Message-ID: <20200530005113.XEdmA8r9Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgE3AvO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 20:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib: make a test module with get_count_order/long
has been added to the -mm tree.  Its filename is
     lib-make-a-test-module-with-get_count_order-long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-make-a-test-module-with-get_count_order-long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-make-a-test-module-with-get_count_order-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib: make a test module with get_count_order/long

A test module to make sure get_count_order/long returns the correct
result.

Link: http://lkml.kernel.org/r/20200530004328.30530-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                  |   13 +++++
 lib/Makefile                       |    2 
 lib/test_getorder.c                |   64 +++++++++++++++++++++++++++
 tools/testing/selftests/lib/config |    1 
 4 files changed, 80 insertions(+)

--- a/lib/Kconfig.debug~lib-make-a-test-module-with-get_count_order-long
+++ a/lib/Kconfig.debug
@@ -2035,6 +2035,19 @@ config TEST_LKM
 
 	  If unsure, say N.
 
+config TEST_GETORDER
+	tristate "Test module for compilation of get_count_order operations"
+	depends on m
+	help
+	  This builds the "test_getorder" module that is much like the
+	  TEST_LKM module except that it does a basic exercise of the
+	  get_count_order and get_count_order_long to make sure there are no
+	  compiler warnings from C=1 sparse checker or -Wextra compilations.
+	  It has no dependencies and doesn't run or load unless explicitly
+	  requested by name. For example: modprobe test_getorder.
+
+	  If unsure, say N.
+
 config TEST_VMALLOC
 	tristate "Test module for stress/performance analysis of vmalloc allocator"
 	default n
--- a/lib/Makefile~lib-make-a-test-module-with-get_count_order-long
+++ a/lib/Makefile
@@ -76,6 +76,8 @@ obj-$(CONFIG_TEST_SORT) += test_sort.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
+obj-$(CONFIG_TEST_GETORDER) += test_getorder.o
+CFLAGS_test_getorder.o += -Werror
 obj-$(CONFIG_TEST_PRINTF) += test_printf.o
 obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
 obj-$(CONFIG_TEST_STRSCPY) += test_strscpy.o
--- /dev/null
+++ a/lib/test_getorder.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Author: Wei Yang <richard.weiyang@gmail.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+/* a tiny module only meant to test get_count_order/long */
+unsigned int order_comb[][2] = {
+	{0x00000003,  2},
+	{0x00000004,  2},
+	{0x00001fff, 13},
+	{0x00002000, 13},
+	{0x50000000, 31},
+	{0x80000000, 31},
+	{0x80003000, 32},
+};
+
+unsigned long order_comb_long[][2] = {
+	{0x0000000300000000, 34},
+	{0x0000000400000000, 34},
+	{0x00001fff00000000, 45},
+	{0x0000200000000000, 45},
+	{0x5000000000000000, 63},
+	{0x8000000000000000, 63},
+	{0x8000300000000000, 64},
+};
+
+static int __init test_getorder_startup(void)
+{
+	int i;
+
+	pr_warn("Loaded test module\n");
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+		if (order_comb[i][1] != get_count_order(order_comb[i][0]))
+			pr_warn("get_count_order wrong for %x\n",
+					order_comb[i][0]);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
+		if (order_comb_long[i][1] !=
+				get_count_order_long(order_comb_long[i][0]))
+			pr_warn("get_count_order_long wrong for %lx\n",
+					order_comb_long[i][0]);
+	}
+
+	return 0;
+}
+
+static void __exit test_getorder_unstartup(void)
+{
+	pr_warn("Unloaded test module\n");
+}
+
+module_init(test_getorder_startup);
+module_exit(test_getorder_unstartup);
+
+MODULE_AUTHOR("Wei Yang <richard.weiyang@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("get_count_order/long testing module");
--- a/tools/testing/selftests/lib/config~lib-make-a-test-module-with-get_count_order-long
+++ a/tools/testing/selftests/lib/config
@@ -1,4 +1,5 @@
 CONFIG_TEST_PRINTF=m
 CONFIG_TEST_BITMAP=m
+CONFIG_TEST_GETORDER=m
 CONFIG_PRIME_NUMBERS=m
 CONFIG_TEST_STRSCPY=m
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch
mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
mm-swapfilec-simplify-the-calculation-of-n_goal.patch
mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch
mm-swapfilec-found_free-could-be-represented-by-tmp-max.patch
mm-swapfilec-tmp-is-always-smaller-than-max.patch
mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable.patch
mm-swapfilec-__swap_entry_free-always-free-1-entry.patch
mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
bitops-simplify-get_count_order_long.patch
lib-make-a-test-module-with-get_count_order-long.patch
