From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch added
 to -mm tree
Date: Mon, 07 Jul 2014 16:22:14 -0700
Message-ID: <53bb2ba6.S7185LrukQv416Bm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:45185 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaGGXWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:15 -0400
Received: by mail-qc0-f201.google.com with SMTP id i17so45752qcy.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_complement unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch

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
Subject: lib: bitmap: make nbits parameter of bitmap_complement unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    6 +++---
 lib/bitmap.c           |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned
+++ a/include/linux/bitmap.h
@@ -93,7 +93,7 @@ extern int __bitmap_full(const unsigned
 extern int __bitmap_equal(const unsigned long *bitmap1,
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
-			int bits);
+			unsigned int nbits);
 extern void __bitmap_shift_right(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern void __bitmap_shift_left(unsigned long *dst,
@@ -222,7 +222,7 @@ static inline int bitmap_andnot(unsigned
 }
 
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
-			int nbits)
+			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
@@ -231,7 +231,7 @@ static inline void bitmap_complement(uns
 }
 
 static inline int bitmap_equal(const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned
+++ a/lib/bitmap.c
@@ -86,9 +86,9 @@ int __bitmap_equal(const unsigned long *
 }
 EXPORT_SYMBOL(__bitmap_equal);
 
-void __bitmap_complement(unsigned long *dst, const unsigned long *src, int bits)
+void __bitmap_complement(unsigned long *dst, const unsigned long *src, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		dst[k] = ~src[k];
 
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

