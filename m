From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test-get_count_order-long-in-test_bitopsc.patch
 added to -mm tree
Date: Tue, 02 Jun 2020 15:53:41 -0700
Message-ID: <20200602225341.p6GQ12cbg%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbgFBWxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 18:53:42 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib: test get_count_order/long in test_bitops.c
has been added to the -mm tree.  Its filename is
     lib-test-get_count_order-long-in-test_bitopsc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test-get_count_order-long-in-test_bitopsc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test-get_count_order-long-in-test_bitopsc.patch

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
Subject: lib: test get_count_order/long in test_bitops.c

Add some test for get_count_order/long in test_bitops.c.

Link: http://lkml.kernel.org/r/20200602223728.32722-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   10 +++++-----
 lib/test_bitops.c |   40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.debug~lib-test-get_count_order-long-in-test_bitopsc
+++ a/lib/Kconfig.debug
@@ -2029,15 +2029,15 @@ config TEST_LKM
 	  If unsure, say N.
 
 config TEST_BITOPS
-	tristate "Test module for compilation of clear_bit/set_bit operations"
+	tristate "Test module for compilation of bitops operations"
 	depends on m
 	help
 	  This builds the "test_bitops" module that is much like the
 	  TEST_LKM module except that it does a basic exercise of the
-	  clear_bit and set_bit macros to make sure there are no compiler
-	  warnings from C=1 sparse checker or -Wextra compilations. It has
-	  no dependencies and doesn't run or load unless explicitly requested
-	  by name.  for example: modprobe test_bitops.
+	  set/clear_bit macros and get_count_order/long to make sure there are
+	  no compiler warnings from C=1 sparse checker or -Wextra
+	  compilations. It has no dependencies and doesn't run or load unless
+	  explicitly requested by name.  for example: modprobe test_bitops.
 
 	  If unsure, say N.
 
--- a/lib/test_bitops.c~lib-test-get_count_order-long-in-test_bitopsc
+++ a/lib/test_bitops.c
@@ -9,7 +9,11 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 
-/* a tiny module only meant to test set/clear_bit */
+/* a tiny module only meant to test
+ *
+ *   set/clear_bit
+ *   get_count_order/long
+ */
 
 /* use an enum because thats the most common BITMAP usage */
 enum bitops_fun {
@@ -24,6 +28,26 @@ enum bitops_fun {
 
 static DECLARE_BITMAP(g_bitmap, BITOPS_LENGTH);
 
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
 static int __init test_bitops_startup(void)
 {
 	pr_warn("Loaded test module\n");
@@ -32,6 +56,18 @@ static int __init test_bitops_startup(vo
 	set_bit(BITOPS_11, g_bitmap);
 	set_bit(BITOPS_31, g_bitmap);
 	set_bit(BITOPS_88, g_bitmap);
+
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+		if (order_comb[i][1] != get_count_order(order_comb[i][0]))
+			pr_warn("get_count_order wrong for %x\n",
+				       order_comb[i][0]); }
+
+	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
+		if (order_comb_long[i][1] !=
+			       get_count_order_long(order_comb_long[i][0]))
+			pr_warn("get_count_order_long wrong for %lx\n",
+				       order_comb_long[i][0]); }
+
 	return 0;
 }
 
@@ -55,6 +91,6 @@ static void __exit test_bitops_unstartup
 module_init(test_bitops_startup);
 module_exit(test_bitops_unstartup);
 
-MODULE_AUTHOR("Jesse Brandeburg <jesse.brandeburg@intel.com>");
+MODULE_AUTHOR("Jesse Brandeburg <jesse.brandeburg@intel.com>, Wei Yang <richard.weiyang@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Bit testing module");
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-test-get_count_order-long-in-test_bitopsc.patch
