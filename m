From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:27 -0800
Message-ID: <54e24fdf.SmzV4mVA3w7iW3tk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbBPUQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: change bitmap_shift_left to take unsigned parameters
has been removed from the -mm tree.  Its filename was
     lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: change bitmap_shift_left to take unsigned parameters

gcc can generate slightly better code for stuff like "nbits %
BITS_PER_LONG" when it knows nbits is not negative.  Since negative size
bitmaps or shift amounts don't make sense, change these parameters of
bitmap_shift_right to unsigned.

If off >= lim (which requires shift >= nbits), k is initialized with a
large positive value, but since I've let k continue to be signed, the loop
will never run and dst will be zeroed as expected.  Inside the loop, k is
guaranteed to be non-negative, so the fact that it is promoted to unsigned
in the various expressions it appears in is harmless.

Also use "shift" and "nbits" consistently for the parameter names.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   12 ++++++------
 lib/bitmap.c           |   11 ++++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters
+++ a/include/linux/bitmap.h
@@ -98,8 +98,8 @@ extern void __bitmap_complement(unsigned
 			unsigned int nbits);
 extern void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, unsigned int nbits);
-extern void __bitmap_shift_left(unsigned long *dst,
-                        const unsigned long *src, int shift, int bits);
+extern void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, unsigned int nbits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
@@ -322,13 +322,13 @@ static inline void bitmap_shift_right(un
 		__bitmap_shift_right(dst, src, shift, nbits);
 }
 
-static inline void bitmap_shift_left(unsigned long *dst,
-			const unsigned long *src, int n, int nbits)
+static inline void bitmap_shift_left(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = (*src << n) & BITMAP_LAST_WORD_MASK(nbits);
+		*dst = (*src << shift) & BITMAP_LAST_WORD_MASK(nbits);
 	else
-		__bitmap_shift_left(dst, src, n, nbits);
+		__bitmap_shift_left(dst, src, shift, nbits);
 }
 
 static inline int bitmap_parse(const char *buf, unsigned int buflen,
diff -puN lib/bitmap.c~lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters
+++ a/lib/bitmap.c
@@ -148,18 +148,19 @@ EXPORT_SYMBOL(__bitmap_shift_right);
  *   @dst : destination bitmap
  *   @src : source bitmap
  *   @shift : shift by this many bits
- *   @bits : bitmap size, in bits
+ *   @nbits : bitmap size, in bits
  *
  * Shifting left (multiplying) means moving bits in the LS -> MS
  * direction.  Zeros are fed into the vacated LS bit positions
  * and those MS bits shifted off the top are lost.
  */
 
-void __bitmap_shift_left(unsigned long *dst,
-			const unsigned long *src, int shift, int bits)
+void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
+			unsigned int shift, unsigned int nbits)
 {
-	int k, lim = BITS_TO_LONGS(bits), left = bits % BITS_PER_LONG;
-	int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
+	int k;
+	unsigned int lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
 	for (k = lim - off - 1; k >= 0; --k) {
 		unsigned long upper, lower;
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

