From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:25 -0800
Message-ID: <54e24fdd.aMPsoNHx2cAkp+yp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbbBPUWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: yet another simplification in __bitmap_shift_right
has been removed from the -mm tree.  Its filename was
     lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: yet another simplification in __bitmap_shift_right

If left is 0, we can just let mask be ~0UL, so that anding with it is a
no-op.  Conveniently, BITMAP_LAST_WORD_MASK provides precisely what we
need, and we can eliminate left.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-yet-another-simplification-in-__bitmap_shift_right lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-yet-another-simplification-in-__bitmap_shift_right
+++ a/lib/bitmap.c
@@ -113,9 +113,9 @@ EXPORT_SYMBOL(__bitmap_complement);
 void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 			unsigned shift, unsigned nbits)
 {
-	unsigned k, lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned k, lim = BITS_TO_LONGS(nbits);
 	unsigned off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
-	unsigned long mask = (1UL << left) - 1;
+	unsigned long mask = BITMAP_LAST_WORD_MASK(nbits);
 	for (k = 0; off + k < lim; ++k) {
 		unsigned long upper, lower;
 
@@ -127,12 +127,12 @@ void __bitmap_shift_right(unsigned long
 			upper = 0;
 		else {
 			upper = src[off + k + 1];
-			if (off + k + 1 == lim - 1 && left)
+			if (off + k + 1 == lim - 1)
 				upper &= mask;
 			upper <<= (BITS_PER_LONG - rem);
 		}
 		lower = src[off + k];
-		if (left && off + k == lim - 1)
+		if (off + k == lim - 1)
 			lower &= mask;
 		lower >>= rem;
 		dst[k] = lower | upper;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

