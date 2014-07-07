From: akpm@linux-foundation.org
Subject: + lib-bitmap-add-missing-mask-in-bitmap_andnot.patch added to -mm tree
Date: Mon, 07 Jul 2014 16:22:28 -0700
Message-ID: <53bb2bb4.I/7UD0CWXfB5rav/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:34110 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaGGXW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:29 -0400
Received: by mail-qa0-f73.google.com with SMTP id m5so723613qaj.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add missing mask in bitmap_andnot
has been added to the -mm tree.  Its filename is
     lib-bitmap-add-missing-mask-in-bitmap_andnot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-add-missing-mask-in-bitmap_andnot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-add-missing-mask-in-bitmap_andnot.patch

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
Subject: lib: bitmap: add missing mask in bitmap_andnot

Apparently, bitmap_andnot is supposed to return whether the new bitmap is
empty.  But it didn't take potential garbage bits in the last word into
account.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_andnot include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_andnot
+++ a/include/linux/bitmap.h
@@ -217,7 +217,7 @@ static inline int bitmap_andnot(unsigned
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return (*dst = *src1 & ~(*src2)) != 0;
+		return (*dst = *src1 & ~(*src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	return __bitmap_andnot(dst, src1, src2, nbits);
 }
 
diff -puN lib/bitmap.c~lib-bitmap-add-missing-mask-in-bitmap_andnot lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-add-missing-mask-in-bitmap_andnot
+++ a/lib/bitmap.c
@@ -223,11 +223,14 @@ int __bitmap_andnot(unsigned long *dst,
 				const unsigned long *bitmap2, unsigned int bits)
 {
 	unsigned int k;
-	unsigned int nr = BITS_TO_LONGS(bits);
+	unsigned int lim = bits/BITS_PER_LONG;
 	unsigned long result = 0;
 
-	for (k = 0; k < nr; k++)
+	for (k = 0; k < lim; k++)
 		result |= (dst[k] = bitmap1[k] & ~bitmap2[k]);
+	if (bits % BITS_PER_LONG)
+		result |= (dst[k] = bitmap1[k] & ~bitmap2[k] &
+			   BITMAP_LAST_WORD_MASK(bits));
 	return result != 0;
 }
 EXPORT_SYMBOL(__bitmap_andnot);
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

