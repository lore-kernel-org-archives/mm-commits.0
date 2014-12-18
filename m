From: akpm@linux-foundation.org
Subject: + lib-bitmap-more-signed-unsigned-conversions.patch added to -mm
 tree
Date: Thu, 18 Dec 2014 14:29:41 -0800
Message-ID: <54935555.vPK0GoqHehA3pzA1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRW3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: more signed->unsigned conversions
has been added to the -mm tree.  Its filename is
     lib-bitmap-more-signed-unsigned-conversions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-more-signed-unsigned-conversions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-more-signed-unsigned-conversions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

