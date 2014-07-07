From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 16:22:16 -0700
Message-ID: <53bb2ba8.sEQm/C17YVygVm9Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49451 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaGGXWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id x13so723647qcv.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_{and,or,xor,andnot} unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch

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
Subject: lib: bitmap: make nbits parameter of bitmap_{and,or,xor,andnot} unsigned

This change is only for consistency with the changes to the other bitmap_*
functions; it doesn't change the size of the generated code: inside
BITS_TO_LONGS there is a sizeof(long), which causes bits to be interpreted
as unsigned anyway.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   16 ++++++++--------
 lib/bitmap.c           |   24 ++++++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned
+++ a/include/linux/bitmap.h
@@ -99,13 +99,13 @@ extern void __bitmap_shift_right(unsigne
 extern void __bitmap_shift_left(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_intersects(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
@@ -188,7 +188,7 @@ static inline void bitmap_copy(unsigned
 }
 
 static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & *src2) != 0;
@@ -196,7 +196,7 @@ static inline int bitmap_and(unsigned lo
 }
 
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
@@ -205,7 +205,7 @@ static inline void bitmap_or(unsigned lo
 }
 
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
@@ -214,7 +214,7 @@ static inline void bitmap_xor(unsigned l
 }
 
 static inline int bitmap_andnot(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & ~(*src2)) != 0;
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned
+++ a/lib/bitmap.c
@@ -182,10 +182,10 @@ void __bitmap_shift_left(unsigned long *
 EXPORT_SYMBOL(__bitmap_shift_left);
 
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
@@ -195,10 +195,10 @@ int __bitmap_and(unsigned long *dst, con
 EXPORT_SYMBOL(__bitmap_and);
 
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] | bitmap2[k];
@@ -206,10 +206,10 @@ void __bitmap_or(unsigned long *dst, con
 EXPORT_SYMBOL(__bitmap_or);
 
 void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] ^ bitmap2[k];
@@ -217,10 +217,10 @@ void __bitmap_xor(unsigned long *dst, co
 EXPORT_SYMBOL(__bitmap_xor);
 
 int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch
lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch
lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch
lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned.patch
lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch
lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch
lib-bitmap-simplify-bitmap_parselist.patch
lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch
lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch
lib-bitmap-micro-optimize-bitmap_allocate_region.patch
lib-bitmap-add-missing-mask-in-bitmap_shift_right.patch
lib-bitmap-add-missing-mask-in-bitmap_and.patch
lib-bitmap-add-missing-mask-in-bitmap_andnot.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch

