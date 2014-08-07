From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:08:29 -0700
Message-ID: <53e3dcbd.7vMWcyKueJ/fffPY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:60301 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:30 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so842597iec.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: change parameter of bitmap_*_region to unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-change-parameter-of-bitmap__region-to-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

