From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:19 -0800
Message-ID: <54e24fd7.auFt+frGP4cQiow0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbBPUPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: change bitmap_shift_right to take unsigned parameters
has been removed from the -mm tree.  Its filename was
     lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: change bitmap_shift_right to take unsigned parameters

I've previously changed the nbits parameter of most bitmap_* functions to
unsigned; now it is bitmap_shift_{left,right}'s turn.  This alone saves
some .text, but while at it I found that there were a few other things one
could do.  The end result of these seven patches is

$ scripts/bloat-o-meter /tmp/bitmap.o.{old,new}
add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-328 (-328)
function                                     old     new   delta
__bitmap_shift_right                         384     226    -158
__bitmap_shift_left                          306     136    -170

and less importantly also a smaller stack footprint

$ stack-o-meter.pl master bitmap
file                 function                       old  new  delta
lib/bitmap.o         __bitmap_shift_right             24    8  -16
lib/bitmap.o         __bitmap_shift_left              24    0  -24

For each pair of 0 <= shift <= nbits <= 256 I've tested the end result
with a few randomly filled src buffers (including garbage beyond nbits),
in each case verifying that the shift {left,right}-most bits of dst are
zero and the remaining nbits-shift bits correspond to src, so I'm fairly
confident I didn't screw up.  That hasn't stopped me from being wrong
before, though.



This patch (of 7):

gcc can generate slightly better code for stuff like "nbits %
BITS_PER_LONG" when it knows nbits is not negative.  Since negative size
bitmaps or shift amounts don't make sense, change these parameters of
bitmap_shift_right to unsigned.

The expressions involving "lim - 1" are still ok, since if lim is 0 the
loop is never executed.

Also use "shift" and "nbits" consistently for the parameter names.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   12 ++++++------
 lib/bitmap.c           |   10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters
+++ a/include/linux/bitmap.h
@@ -96,8 +96,8 @@ extern int __bitmap_equal(const unsigned
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
 			unsigned int nbits);
-extern void __bitmap_shift_right(unsigned long *dst,
-                        const unsigned long *src, int shift, int bits);
+extern void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, unsigned int nbits);
 extern void __bitmap_shift_left(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
@@ -313,13 +313,13 @@ static inline int bitmap_weight(const un
 	return __bitmap_weight(src, nbits);
 }
 
-static inline void bitmap_shift_right(unsigned long *dst,
-			const unsigned long *src, int n, int nbits)
+static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> n;
+		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> shift;
 	else
-		__bitmap_shift_right(dst, src, n, nbits);
+		__bitmap_shift_right(dst, src, shift, nbits);
 }
 
 static inline void bitmap_shift_left(unsigned long *dst,
diff -puN lib/bitmap.c~lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters
+++ a/lib/bitmap.c
@@ -104,17 +104,17 @@ EXPORT_SYMBOL(__bitmap_complement);
  *   @dst : destination bitmap
  *   @src : source bitmap
  *   @shift : shift by this many bits
- *   @bits : bitmap size, in bits
+ *   @nbits : bitmap size, in bits
  *
  * Shifting right (dividing) means moving bits in the MS -> LS bit
  * direction.  Zeros are fed into the vacated MS positions and the
  * LS bits shifted off the bottom are lost.
  */
-void __bitmap_shift_right(unsigned long *dst,
-			const unsigned long *src, int shift, int bits)
+void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
+			unsigned shift, unsigned nbits)
 {
-	int k, lim = BITS_TO_LONGS(bits), left = bits % BITS_PER_LONG;
-	int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
+	unsigned k, lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
 	unsigned long mask = (1UL << left) - 1;
 	for (k = 0; off + k < lim; ++k) {
 		unsigned long upper, lower;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

