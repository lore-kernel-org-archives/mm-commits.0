From: akpm@linux-foundation.org
Subject: + lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 16:22:21 -0700
Message-ID: <53bb2bad./X0m2p99BcK7yu3b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:49303 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGGXWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:22 -0400
Received: by mail-oa0-f73.google.com with SMTP id eb12so1080063oac.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make the start index of bitmap_clear unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch

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
Subject: lib: bitmap: make the start index of bitmap_clear unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "start" is non-negative.

Also, use the names "start" and "len" for the two parameters for
consistency with bitmap_set.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned
+++ a/include/linux/bitmap.h
@@ -113,7 +113,7 @@ extern int __bitmap_subset(const unsigne
 extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
 
 extern void bitmap_set(unsigned long *map, unsigned int start, int len);
-extern void bitmap_clear(unsigned long *map, int start, int nr);
+extern void bitmap_clear(unsigned long *map, unsigned int start, int len);
 extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
 					 unsigned long size,
 					 unsigned long start,
diff -puN lib/bitmap.c~lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned
+++ a/lib/bitmap.c
@@ -295,21 +295,21 @@ void bitmap_set(unsigned long *map, unsi
 }
 EXPORT_SYMBOL(bitmap_set);
 
-void bitmap_clear(unsigned long *map, int start, int nr)
+void bitmap_clear(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned int size = start + len;
 	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_clear >= 0) {
+	while (len - bits_to_clear >= 0) {
 		*p &= ~mask_to_clear;
-		nr -= bits_to_clear;
+		len -= bits_to_clear;
 		bits_to_clear = BITS_PER_LONG;
 		mask_to_clear = ~0UL;
 		p++;
 	}
-	if (nr) {
+	if (len) {
 		mask_to_clear &= BITMAP_LAST_WORD_MASK(size);
 		*p &= ~mask_to_clear;
 	}
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

