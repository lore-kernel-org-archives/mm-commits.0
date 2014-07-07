From: akpm@linux-foundation.org
Subject: + lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 16:22:11 -0700
Message-ID: <53bb2ba3.FIByknePBkz3viYN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:57915 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaGGXWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:12 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so1089274obc.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_empty unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned.patch

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
Subject: lib: bitmap: make nbits parameter of bitmap_empty unsigned

Many functions in lib/bitmap.c start with an expression such as lim =
bits/BITS_PER_LONG.  Since bits has type (signed) int, and since gcc
cannot know that it is in fact non-negative, it generates worse code than
it could.  These patches, mostly consisting of changing various parameters
to unsigned, gives a slight overall code reduction:

add/remove: 1/1 grow/shrink: 8/16 up/down: 251/-414 (-163)
function                                     old     new   delta
tick_device_uses_broadcast                   335     425     +90
__irq_alloc_descs                            498     554     +56
__bitmap_andnot                               73     115     +42
__bitmap_and                                  70     101     +31
bitmap_weight                                  -      11     +11
copy_hugetlb_page_range                      752     762     +10
follow_hugetlb_page                          846     854      +8
hugetlb_init                                1415    1417      +2
hugetlb_nrpages_setup                        130     131      +1
hugetlb_add_hstate                           377     376      -1
bitmap_allocate_region                        82      80      -2
select_task_rq_fair                         2202    2191     -11
hweight_long                                  66      55     -11
__reg_op                                     230     219     -11
dm_stats_message                            2849    2833     -16
bitmap_parselist                              92      74     -18
__bitmap_weight                              115      97     -18
__bitmap_subset                              153     129     -24
__bitmap_full                                128     104     -24
__bitmap_empty                               120      96     -24
bitmap_set                                   179     149     -30
bitmap_clear                                 185     155     -30
__bitmap_equal                               136     105     -31
__bitmap_intersects                          148     108     -40
__bitmap_complement                          109      67     -42
tick_device_setup_broadcast_func.isra         81       -     -81

[The increases in __bitmap_and{,not} are due to bug fixes 17/18,18/18.  No
idea why bitmap_weight suddenly appears.] While 163 bytes treewide is
insignificant, I believe the bitmap functions are often called with locks
held, so saving even a few cycles might be worth it.

While making these changes, I found a few other things that might be worth
including.  16,17,18 are actual bug fixes.  The rest shouldn't change the
behaviour of any of the functions, provided no-one passed negative nbits
values.  If something should come up, it should be fairly bisectable.

A few issues I thought about, but didn't know what to do with:

* Many of the functions misbehave if nbits is compile-time 0; the
  out-of-line functions generally handle 0 correctly.  bitmap_fill() is
  particularly bad, whether the 0 is known at compile time or not.  It
  would probably be nice to add detection of at least compile-time 0 and
  handle that appropriately.

* I didn't change __bitmap_shift_{left,right} to use unsigned because I
  want to fully understand why the algorithm works before making that
  change.  However, AFAICT, they behave correctly for all (positive) shift
  amounts.  This is not the case for the small_const_nbits versions.  If
  for example nbits = n = BITS_PER_LONG, the shift operators turn into
  no-ops (at least on x86), so one get *dst = *src, whereas one would
  expect to get *dst=0.  That difference in behaviour is somewhat
  annoying.


This patch (of 18):

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++--
 lib/bitmap.c           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned
+++ a/include/linux/bitmap.h
@@ -88,7 +88,7 @@
  * lib/bitmap.c provides these functions:
  */
 
-extern int __bitmap_empty(const unsigned long *bitmap, int bits);
+extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_full(const unsigned long *bitmap, int bits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
                 	const unsigned long *bitmap2, int bits);
@@ -257,7 +257,7 @@ static inline int bitmap_subset(const un
 		return __bitmap_subset(src1, src2, nbits);
 }
 
-static inline int bitmap_empty(const unsigned long *src, int nbits)
+static inline int bitmap_empty(const unsigned long *src, unsigned nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_empty-unsigned
+++ a/lib/bitmap.c
@@ -40,9 +40,9 @@
  * for the best explanations of this ordering.
  */
 
-int __bitmap_empty(const unsigned long *bitmap, int bits)
+int __bitmap_empty(const unsigned long *bitmap, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap[k])
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

