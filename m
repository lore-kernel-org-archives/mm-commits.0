From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-test_bitops-do-the-full-test-during-module-init.patch added to -mm tree
Date: Mon, 06 Jul 2020 15:49:10 -0700
Message-ID: <20200706224910.cDgtSLTT8%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFWtL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 18:49:11 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, geert@linux-m68k.org, jesse.brandeburg@intel.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib/test_bitops: do the full test during module init
has been added to the -mm tree.  Its filename is
     lib-test_bitops-do-the-full-test-during-module-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_bitops-do-the-full-test-during-module-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_bitops-do-the-full-test-during-module-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib/test_bitops: do the full test during module init

Currently, the bitops test consists of two parts: one part is executed
during module load, the second part during module unload.  This is
cumbersome for the user, as he has to perform two steps to execute all
tests, and is different from most (all?) other tests.

Merge the two parts, so both are executed during module load.

Link: http://lkml.kernel.org/r/20200706112900.7097-1-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/lib/test_bitops.c~lib-test_bitops-do-the-full-test-during-module-init
+++ a/lib/test_bitops.c
@@ -52,9 +52,9 @@ static unsigned long order_comb_long[][2
 
 static int __init test_bitops_startup(void)
 {
-	int i;
+	int i, bit_set;
 
-	pr_warn("Loaded test module\n");
+	pr_info("Starting bitops test\n");
 	set_bit(BITOPS_4, g_bitmap);
 	set_bit(BITOPS_7, g_bitmap);
 	set_bit(BITOPS_11, g_bitmap);
@@ -81,12 +81,8 @@ static int __init test_bitops_startup(vo
 				       order_comb_long[i][0]);
 	}
 #endif
-	return 0;
-}
 
-static void __exit test_bitops_unstartup(void)
-{
-	int bit_set;
+	barrier();
 
 	clear_bit(BITOPS_4, g_bitmap);
 	clear_bit(BITOPS_7, g_bitmap);
@@ -98,7 +94,13 @@ static void __exit test_bitops_unstartup
 	if (bit_set != BITOPS_LAST)
 		pr_err("ERROR: FOUND SET BIT %d\n", bit_set);
 
-	pr_warn("Unloaded test module\n");
+	pr_info("Completed bitops test\n");
+
+	return 0;
+}
+
+static void __exit test_bitops_unstartup(void)
+{
 }
 
 module_init(test_bitops_startup);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

lib-test_bitops-do-the-full-test-during-module-init.patch
