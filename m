From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 11/25] lib: test get_count_order/long in
 test_bitops.c
Date: Wed, 10 Jun 2020 18:41:53 -0700
Message-ID: <20200611014153.h3w2RHIfq%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBlz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:55 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, geert@linux-m68k.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib: test get_count_order/long in test_bitops.c

Add some tests for get_count_order/long in test_bitops.c.

[akpm@linux-foundation.org: define local `i']
[akpm@linux-foundation.org: enhancement, warning fix, cleanup per Geert]
[akpm@linux-foundation.org: fix loop bound, per Wei Yang]
Link: http://lkml.kernel.org/r/20200602223728.32722-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   10 ++++----
 lib/test_bitops.c |   53 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.debug~lib-test-get_count_order-long-in-test_bitopsc
+++ a/lib/Kconfig.debug
@@ -2052,15 +2052,15 @@ config TEST_LKM
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
@@ -24,14 +28,59 @@ enum bitops_fun {
 
 static DECLARE_BITMAP(g_bitmap, BITOPS_LENGTH);
 
+static unsigned int order_comb[][2] = {
+	{0x00000003,  2},
+	{0x00000004,  2},
+	{0x00001fff, 13},
+	{0x00002000, 13},
+	{0x50000000, 31},
+	{0x80000000, 31},
+	{0x80003000, 32},
+};
+
+#ifdef CONFIG_64BIT
+static unsigned long order_comb_long[][2] = {
+	{0x0000000300000000, 34},
+	{0x0000000400000000, 34},
+	{0x00001fff00000000, 45},
+	{0x0000200000000000, 45},
+	{0x5000000000000000, 63},
+	{0x8000000000000000, 63},
+	{0x8000300000000000, 64},
+};
+#endif
+
 static int __init test_bitops_startup(void)
 {
+	int i;
+
 	pr_warn("Loaded test module\n");
 	set_bit(BITOPS_4, g_bitmap);
 	set_bit(BITOPS_7, g_bitmap);
 	set_bit(BITOPS_11, g_bitmap);
 	set_bit(BITOPS_31, g_bitmap);
 	set_bit(BITOPS_88, g_bitmap);
+
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+		if (order_comb[i][1] != get_count_order(order_comb[i][0]))
+			pr_warn("get_count_order wrong for %x\n",
+				       order_comb[i][0]);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+		if (order_comb[i][1] != get_count_order_long(order_comb[i][0]))
+			pr_warn("get_count_order_long wrong for %x\n",
+				       order_comb[i][0]);
+	}
+
+#ifdef CONFIG_64BIT
+	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
+		if (order_comb_long[i][1] !=
+			       get_count_order_long(order_comb_long[i][0]))
+			pr_warn("get_count_order_long wrong for %lx\n",
+				       order_comb_long[i][0]);
+	}
+#endif
 	return 0;
 }
 
@@ -55,6 +104,6 @@ static void __exit test_bitops_unstartup
 module_init(test_bitops_startup);
 module_exit(test_bitops_unstartup);
 
-MODULE_AUTHOR("Jesse Brandeburg <jesse.brandeburg@intel.com>");
+MODULE_AUTHOR("Jesse Brandeburg <jesse.brandeburg@intel.com>, Wei Yang <richard.weiyang@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Bit testing module");
_
