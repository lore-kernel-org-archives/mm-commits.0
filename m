From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 001/118] lib/test_bitmap: correct test data
 offsets for 32-bit
Date: Thu, 30 Jan 2020 22:11:01 -0800
Message-ID: <20200131061101.ZKr-lpeii%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:02 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, linux-mm@kvack.org, linux@rasmusvillemoes.dk, linux@roeck-us.net, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, yury.norov@gmail.com

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
Cc: <stable@vger.kernel.org>
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
