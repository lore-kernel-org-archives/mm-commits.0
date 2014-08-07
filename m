From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:08:21 -0700
Message-ID: <53e3dcb5.hCtf4kuQOsHEXPEF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:65106 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaHGUIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:22 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1177169pab.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make the start index of bitmap_set unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-the-start-index-of-bitmap_set-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

