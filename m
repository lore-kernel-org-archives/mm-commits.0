From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:22:22 -0800
Message-ID: <54de5cfe.fspK5uYLzu042d8N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbBMUWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: change parameters of bitmap_fold to unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/bitmap.c: change parameters of bitmap_fold to unsigned

Change the sz and nbits parameters of bitmap_fold to unsigned int for
consistency with other bitmap_* functions, and to save another few bytes
in the generated code.

[akpm@linux-foundation.org: fix kerneldoc]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned
+++ a/include/linux/bitmap.h
@@ -166,7 +166,7 @@ extern int bitmap_bitremap(int oldbit,
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 		const unsigned long *relmap, unsigned int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
-		int sz, int bits);
+		unsigned int sz, unsigned int nbits);
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
diff -puN lib/bitmap.c~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned
+++ a/lib/bitmap.c
@@ -1039,22 +1039,22 @@ EXPORT_SYMBOL(bitmap_onto);
  *	@dst: resulting smaller bitmap
  *	@orig: original larger bitmap
  *	@sz: specified size
- *	@bits: number of bits in each of these bitmaps
+ *	@nbits: number of bits in each of these bitmaps
  *
  * For each bit oldbit in @orig, set bit oldbit mod @sz in @dst.
  * Clear all other bits in @dst.  See further the comment and
  * Example [2] for bitmap_onto() for why and how to use this.
  */
 void bitmap_fold(unsigned long *dst, const unsigned long *orig,
-			int sz, int bits)
+			unsigned int sz, unsigned int nbits)
 {
-	int oldbit;
+	unsigned int oldbit;
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
-	bitmap_zero(dst, bits);
+	bitmap_zero(dst, nbits);
 
-	for_each_set_bit(oldbit, orig, bits)
+	for_each_set_bit(oldbit, orig, nbits)
 		set_bit(oldbit % sz, dst);
 }
 EXPORT_SYMBOL(bitmap_fold);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

