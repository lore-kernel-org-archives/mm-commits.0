From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test-get_count_order-long-in-test_bitopsc-fix.patch removed from -mm
 tree
Date: Wed, 10 Jun 2020 18:20:05 -0700
Message-ID: <20200611012005.k9qjV8D07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFKBUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, geert@linux-m68k.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib-test-get_count_order-long-in-test_bitopsc-fix
has been removed from the -mm tree.  Its filename was
     lib-test-get_count_order-long-in-test_bitopsc-fix.patch

This patch was dropped because it was folded into lib-test-get_count_order-long-in-test_bitopsc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test-get_count_order-long-in-test_bitopsc-fix

- use order_comb[] to test get_count_order_long() as well, per Geert

- avoid warnings on 32-bit, reported by Geert

- coding-style cleanups

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/lib/test_bitops.c~lib-test-get_count_order-long-in-test_bitopsc-fix
+++ a/lib/test_bitops.c
@@ -28,7 +28,7 @@ enum bitops_fun {
 
 static DECLARE_BITMAP(g_bitmap, BITOPS_LENGTH);
 
-unsigned int order_comb[][2] = {
+static unsigned int order_comb[][2] = {
 	{0x00000003,  2},
 	{0x00000004,  2},
 	{0x00001fff, 13},
@@ -38,7 +38,8 @@ unsigned int order_comb[][2] = {
 	{0x80003000, 32},
 };
 
-unsigned long order_comb_long[][2] = {
+#ifdef CONFIG_64BIT
+static unsigned long order_comb_long[][2] = {
 	{0x0000000300000000, 34},
 	{0x0000000400000000, 34},
 	{0x00001fff00000000, 45},
@@ -47,6 +48,7 @@ unsigned long order_comb_long[][2] = {
 	{0x8000000000000000, 63},
 	{0x8000300000000000, 64},
 };
+#endif
 
 static int __init test_bitops_startup(void)
 {
@@ -62,14 +64,23 @@ static int __init test_bitops_startup(vo
 	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
 		if (order_comb[i][1] != get_count_order(order_comb[i][0]))
 			pr_warn("get_count_order wrong for %x\n",
-				       order_comb[i][0]); }
+				       order_comb[i][0]);
+	}
 
-	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+		if (order_comb[i][1] != get_count_order_long(order_comb[i][0]))
+			pr_warn("get_count_order_long wrong for %x\n",
+				       order_comb[i][0]);
+	}
+
+#ifdef CONFIG_64BIT
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
 		if (order_comb_long[i][1] !=
 			       get_count_order_long(order_comb_long[i][0]))
 			pr_warn("get_count_order_long wrong for %lx\n",
-				       order_comb_long[i][0]); }
