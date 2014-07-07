From: akpm@linux-foundation.org
Subject: + lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch added to -mm tree
Date: Mon, 07 Jul 2014 16:22:15 -0700
Message-ID: <53bb2ba7.CaMRy2ga7NG/Ktcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:48766 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGGXWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:16 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so722671yha.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: remove unnecessary mask from bitmap_complement
has been added to the -mm tree.  Its filename is
     lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch

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
Subject: lib: bitmap: remove unnecessary mask from bitmap_complement

Since the extra bits are "don't care", there is no reason to mask the last
word to the used bits when complementing.  This shaves off yet a few
bytes.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement
+++ a/include/linux/bitmap.h
@@ -225,7 +225,7 @@ static inline void bitmap_complement(uns
 			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
+		*dst = ~(*src);
 	else
 		__bitmap_complement(dst, src, nbits);
 }
diff -puN lib/bitmap.c~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement
+++ a/lib/bitmap.c
@@ -93,7 +93,7 @@ void __bitmap_complement(unsigned long *
 		dst[k] = ~src[k];
 
 	if (bits % BITS_PER_LONG)
-		dst[k] = ~src[k] & BITMAP_LAST_WORD_MASK(bits);
+		dst[k] = ~src[k];
 }
 EXPORT_SYMBOL(__bitmap_complement);
 
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

