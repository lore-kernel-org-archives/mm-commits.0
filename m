From: akpm@linux-foundation.org
Subject: + lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch added to -mm tree
Date: Mon, 07 Jul 2014 16:22:24 -0700
Message-ID: <53bb2bb0.Wsu91BwnChN6nYv2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:60224 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGGXWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:22:25 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1094626pab.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:22:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: change parameter of bitmap_*_region to unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch

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
Subject: lib: bitmap: change parameter of bitmap_*_region to unsigned

Changing the pos parameter of __reg_op to unsigned allows the compiler to
generate slightly smaller and simpler code.  Also update its callers
bitmap_*_region to receive and pass unsigned int.  The return types of
bitmap_find_free_region and bitmap_allocate_region are still int to allow
a negative error code to be returned.  An int is certainly capable of
representing any realistic return value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    6 +++---
 lib/bitmap.c           |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-change-parameter-of-bitmap__region-to-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-change-parameter-of-bitmap__region-to-unsigned
+++ a/include/linux/bitmap.h
@@ -140,9 +140,9 @@ extern void bitmap_onto(unsigned long *d
 		const unsigned long *relmap, int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		int sz, int bits);
-extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int order);
-extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
-extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
+extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
+extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
+extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
 extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 
diff -puN lib/bitmap.c~lib-bitmap-change-parameter-of-bitmap__region-to-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-change-parameter-of-bitmap__region-to-unsigned
+++ a/lib/bitmap.c
@@ -1042,7 +1042,7 @@ enum {
 	REG_OP_RELEASE,		/* clear all bits in region */
 };
 
-static int __reg_op(unsigned long *bitmap, int pos, int order, int reg_op)
+static int __reg_op(unsigned long *bitmap, unsigned int pos, int order, int reg_op)
 {
 	int nbits_reg;		/* number of bits in region */
 	int index;		/* index first long of region in bitmap */
@@ -1108,11 +1108,11 @@ done:
  * Return the bit offset in bitmap of the allocated region,
  * or -errno on failure.
  */
-int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
+int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order)
 {
-	int pos, end;		/* scans bitmap by regions of size order */
+	unsigned int pos, end;		/* scans bitmap by regions of size order */
 
-	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
+	for (pos = 0 ; (end = pos + (1U << order)) <= bits; pos = end) {
 		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			continue;
 		__reg_op(bitmap, pos, order, REG_OP_ALLOC);
@@ -1133,7 +1133,7 @@ EXPORT_SYMBOL(bitmap_find_free_region);
  *
  * No return value.
  */
-void bitmap_release_region(unsigned long *bitmap, int pos, int order)
+void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
 {
 	__reg_op(bitmap, pos, order, REG_OP_RELEASE);
 }
@@ -1150,7 +1150,7 @@ EXPORT_SYMBOL(bitmap_release_region);
  * Return 0 on success, or %-EBUSY if specified region wasn't
  * free (not all bits were zero).
  */
-int bitmap_allocate_region(unsigned long *bitmap, int pos, int order)
+int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
 {
 	if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 		return -EBUSY;
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

