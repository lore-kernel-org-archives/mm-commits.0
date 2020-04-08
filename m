From: akpm@linux-foundation.org
Subject: [merged] lib-test_bitmap-make-use-of-exp2_in_bits.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:15 -0700
Message-ID: <20200408020115.l7BatiaGR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCBQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap.c: make use of EXP2_IN_BITS
has been removed from the -mm tree.  Its filename was
     lib-test_bitmap-make-use-of-exp2_in_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap.c: make use of EXP2_IN_BITS

Commit 30544ed5de43 ("lib/bitmap: introduce bitmap_replace() helper")
introduced some new test cases to the test_bitmap.c module.  Among these
it also introduced an (unused) definition.  Let's make use of
EXP2_IN_BITS.

Link: http://lkml.kernel.org/r/20200121151847.75223-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_bitmap.c~lib-test_bitmap-make-use-of-exp2_in_bits
+++ a/lib/test_bitmap.c
@@ -278,6 +278,8 @@ static void __init test_replace(void)
 	unsigned int nlongs = DIV_ROUND_UP(nbits, BITS_PER_LONG);
 	DECLARE_BITMAP(bmap, 1024);
 
+	BUILD_BUG_ON(EXP2_IN_BITS < nbits * 2);
+
 	bitmap_zero(bmap, 1024);
 	bitmap_replace(bmap, &exp2[0 * nlongs], &exp2[1 * nlongs], exp2_to_exp3_mask, nbits);
 	expect_eq_bitmap(bmap, exp3_0_1, nbits);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are
