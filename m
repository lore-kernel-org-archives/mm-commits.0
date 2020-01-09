From: akpm@linux-foundation.org
Subject: +
 lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch added to -mm
 tree
Date: Thu, 09 Jan 2020 12:08:59 -0800
Message-ID: <20200109200859.iJHcLkTnG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgAIUJA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 15:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, linux@roeck-us.net, mm-commits@vger.kernel.org, yury.norov@gmail.com


The patch titled
     Subject: lib/test_bitmap: correct test data offsets for 32-bit
has been added to the -mm tree.  Its filename is
     lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap: correct test data offsets for 32-bit

On 32-bit platform the size of long is only 32 bits which makes wrong
offset in the array of 64 bit size.

Calculate offset based on BITS_PER_LONG.

Link: http://lkml.kernel.org/r/20200109103601.45929-1-andriy.shevchenko@linux.intel.com
Fixes: 30544ed5de43 ("lib/bitmap: introduce bitmap_replace() helper")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/test_bitmap.c~lib-test_bitmap-correct-test-data-offsets-for-32-bit
+++ a/lib/test_bitmap.c
@@ -275,22 +275,23 @@ static void __init test_copy(void)
 static void __init test_replace(void)
 {
 	unsigned int nbits = 64;
+	unsigned int nlongs = DIV_ROUND_UP(nbits, BITS_PER_LONG);
 	DECLARE_BITMAP(bmap, 1024);
 
 	bitmap_zero(bmap, 1024);
-	bitmap_replace(bmap, &exp2[0], &exp2[1], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[0 * nlongs], &exp2[1 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_0_1, nbits);
 
 	bitmap_zero(bmap, 1024);
-	bitmap_replace(bmap, &exp2[1], &exp2[0], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[1 * nlongs], &exp2[0 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_1_0, nbits);
 
 	bitmap_fill(bmap, 1024);
-	bitmap_replace(bmap, &exp2[0], &exp2[1], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[0 * nlongs], &exp2[1 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_0_1, nbits);
 
 	bitmap_fill(bmap, 1024);
-	bitmap_replace(bmap, &exp2[1], &exp2[0], exp2_to_exp3_mask, nbits);
+	bitmap_replace(bmap, &exp2[1 * nlongs], &exp2[0 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_1_0, nbits);
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch
mm-early_remap-use-%pa-to-print-resource_size_t-variables.patch
io-mapping-use-phys_pfn-macro-in-io_mapping_map_atomic_wc.patch
