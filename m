From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
 added to -mm tree
Date: Mon, 05 Jan 2015 13:42:18 -0800
Message-ID: <54ab053a.XZCmgnD9mZZnMvE8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbbAEVmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 16:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: change bitmap_shift_right to take unsigned parameters
has been added to the -mm tree.  Its filename is
     lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch

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

lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
lib-remove-strnicmp.patch
lib-interval_treec-simplify-includes.patch
lib-sortc-use-simpler-includes.patch
lib-dynamic_queue_limitsc-simplify-includes.patch
lib-halfmd4c-simplify-includes.patch
lib-idrc-remove-redundant-include.patch
lib-genallocc-remove-redundant-include.patch
lib-list_sortc-rearrange-includes.patch
lib-md5c-simplify-include.patch
lib-llistc-remove-redundant-include.patch
lib-kobject_ueventc-remove-redundant-include.patch
lib-nlattrc-remove-redundant-include.patch
lib-plistc-remove-redundant-include.patch
lib-radix-treec-change-to-simpler-include.patch
lib-show_memc-remove-redundant-include.patch
lib-sortc-move-include-inside-if-0.patch
lib-stmp_devicec-replace-moduleh-include.patch
lib-strncpy_from_userc-replace-moduleh-include.patch
lib-percpu_idac-remove-redundant-includes.patch
lib-lcmc-replace-include.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

