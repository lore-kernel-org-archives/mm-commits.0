From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_bitmap-make-use-of-exp2_in_bits.patch added to
 -mm tree
Date: Mon, 24 Feb 2020 15:43:06 -0800
Message-ID: <20200224234306.n3kt7wl7t%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgBXXnI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 18:43:08 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap.c: make use of EXP2_IN_BITS
has been added to the -mm tree.  Its filename is
     lib-test_bitmap-make-use-of-exp2_in_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_bitmap-make-use-of-exp2_in_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_bitmap-make-use-of-exp2_in_bits.patch

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

lib-test_bitmap-make-use-of-exp2_in_bits.patch
