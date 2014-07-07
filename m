From: akpm@linux-foundation.org
Subject: + lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch added to -mm tree
Date: Mon, 07 Jul 2014 16:22:18 -0700
Message-ID: <53bb2baa.swwdZruL2YgUTf6m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:33525 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaGGXWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:20 -0400
Received: by mail-pa0-f73.google.com with SMTP id kq14so1096323pab.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_subset unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned.patch

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
Subject: lib: bitmap: make nbits parameter of bitmap_subset unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++--
 lib/bitmap.c           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned
+++ a/include/linux/bitmap.h
@@ -109,7 +109,7 @@ extern int __bitmap_andnot(unsigned long
 extern int __bitmap_intersects(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
 extern void bitmap_set(unsigned long *map, int i, int len);
@@ -249,7 +249,7 @@ static inline int bitmap_intersects(cons
 }
 
 static inline int bitmap_subset(const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! ((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_subset-unsigned
+++ a/lib/bitmap.c
@@ -245,9 +245,9 @@ int __bitmap_intersects(const unsigned l
 EXPORT_SYMBOL(__bitmap_intersects);
 
 int __bitmap_subset(const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+		    const unsigned long *bitmap2, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap1[k] & ~bitmap2[k])
 			return 0;
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

