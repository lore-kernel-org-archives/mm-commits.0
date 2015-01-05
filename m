From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch added to -mm tree
Date: Mon, 05 Jan 2015 13:42:26 -0800
Message-ID: <54ab0542.zLPePnS70pb0pFPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbbAEVm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 16:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: change bitmap_shift_left to take unsigned parameters
has been added to the -mm tree.  Its filename is
     lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch

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

