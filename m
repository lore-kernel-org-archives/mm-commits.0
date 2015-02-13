From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-more-signed-unsigned-conversions.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:14 -0800
Message-ID: <54de5cf6.N90nZhMBqpJuRo3w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbBMUWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: more signed->unsigned conversions
has been removed from the -mm tree.  Its filename was
     lib-bitmap-more-signed-unsigned-conversions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/bitmap.c: more signed->unsigned conversions

For consistency with the other bitmap_* functions, also make the nbits
parameter of bitmap_zero, bitmap_fill and bitmap_copy unsigned.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-more-signed-unsigned-conversions include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-more-signed-unsigned-conversions
+++ a/include/linux/bitmap.h
@@ -185,33 +185,33 @@ extern int bitmap_print_to_pagebuf(bool
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
 
-static inline void bitmap_zero(unsigned long *dst, int nbits)
+static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = 0UL;
 	else {
-		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+		unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 		memset(dst, 0, len);
 	}
 }
 
-static inline void bitmap_fill(unsigned long *dst, int nbits)
+static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 {
-	size_t nlongs = BITS_TO_LONGS(nbits);
+	unsigned int nlongs = BITS_TO_LONGS(nbits);
 	if (!small_const_nbits(nbits)) {
-		int len = (nlongs - 1) * sizeof(unsigned long);
+		unsigned int len = (nlongs - 1) * sizeof(unsigned long);
 		memset(dst, 0xff,  len);
 	}
 	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
 }
 
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
-			int nbits)
+			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src;
 	else {
-		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+		unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
 		memcpy(dst, src, len);
 	}
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

