From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-update-bitmap_onto-to-unsigned.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:22:20 -0800
Message-ID: <54de5cfc.1gTdQhh07FwuI1Il%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbBMUWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: update bitmap_onto to unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-update-bitmap_onto-to-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/bitmap.c: update bitmap_onto to unsigned

Change the nbits parameter of bitmap_onto to unsigned int for consistency
with other bitmap_* functions.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-update-bitmap_onto-to-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-update-bitmap_onto-to-unsigned
+++ a/include/linux/bitmap.h
@@ -164,7 +164,7 @@ extern void bitmap_remap(unsigned long *
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
-		const unsigned long *relmap, int bits);
+		const unsigned long *relmap, unsigned int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		int sz, int bits);
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
diff -puN lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned
+++ a/lib/bitmap.c
@@ -1006,9 +1006,9 @@ EXPORT_SYMBOL(bitmap_bitremap);
  * All bits in @dst not set by the above rule are cleared.
  */
 void bitmap_onto(unsigned long *dst, const unsigned long *orig,
-			const unsigned long *relmap, int bits)
+			const unsigned long *relmap, unsigned int bits)
 {
-	int n, m;       	/* same meaning as in above comment */
+	unsigned int n, m;	/* same meaning as in above comment */
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
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

