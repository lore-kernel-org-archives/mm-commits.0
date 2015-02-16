From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:29 -0800
Message-ID: <54e24fe1.dlPLgCzmyL8+fxBl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbBPUQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: eliminate branch in __bitmap_shift_left
has been removed from the -mm tree.  Its filename was
     lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: eliminate branch in __bitmap_shift_left

We can shift the bits from lower and upper into place before assembling
dst[k + off]; moving the shift of lower into the branch where we already
know that rem is non-zero allows us to remove a conditional.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-eliminate-branch-in-__bitmap_shift_left lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-eliminate-branch-in-__bitmap_shift_left
+++ a/lib/bitmap.c
@@ -169,15 +169,14 @@ void __bitmap_shift_left(unsigned long *
 		 * word below and make them the bottom rem bits of result.
 		 */
 		if (rem && k > 0)
-			lower = src[k - 1];
+			lower = src[k - 1] >> (BITS_PER_LONG - rem);
 		else
 			lower = 0;
 		upper = src[k];
 		if (left && k == lim - 1)
 			upper &= (1UL << left) - 1;
-		dst[k + off] = upper << rem;
-		if (rem)
-			dst[k + off] |= lower >> (BITS_PER_LONG - rem);
+		upper <<= rem;
+		dst[k + off] = lower | upper;
 		if (left && k + off == lim - 1)
 			dst[k + off] &= (1UL << left) - 1;
 	}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

