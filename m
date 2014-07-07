From: akpm@linux-foundation.org
Subject: + lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 16:22:20 -0700
Message-ID: <53bb2bac.4S0D8UgbbxvU6fc2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52793 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaGGXWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:21 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so1089300obc.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make the start index of bitmap_set unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch

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
Subject: lib: bitmap: make the start index of bitmap_set unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "start" is non-negative.

Also, use the names "start" and "len" for the two parameters in both
header file and implementation, instead of the previous mix.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-the-start-index-of-bitmap_set-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-the-start-index-of-bitmap_set-unsigned
+++ a/include/linux/bitmap.h
@@ -112,7 +112,7 @@ extern int __bitmap_subset(const unsigne
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
 
-extern void bitmap_set(unsigned long *map, int i, int len);
+extern void bitmap_set(unsigned long *map, unsigned int start, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
 extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
 					 unsigned long size,
diff -puN lib/bitmap.c~lib-bitmap-make-the-start-index-of-bitmap_set-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-the-start-index-of-bitmap_set-unsigned
+++ a/lib/bitmap.c
@@ -274,21 +274,21 @@ int __bitmap_weight(const unsigned long
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
-void bitmap_set(unsigned long *map, int start, int nr)
+void bitmap_set(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned int size = start + len;
 	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_set >= 0) {
+	while (len - bits_to_set >= 0) {
 		*p |= mask_to_set;
-		nr -= bits_to_set;
+		len -= bits_to_set;
 		bits_to_set = BITS_PER_LONG;
 		mask_to_set = ~0UL;
 		p++;
 	}
-	if (nr) {
+	if (len) {
 		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
 		*p |= mask_to_set;
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

