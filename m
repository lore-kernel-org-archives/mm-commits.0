From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:23 -0700
Message-ID: <53e3dcb7.SavD6vgfSRsyjIxs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52940 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbaHGUIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:24 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so609610qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make the start index of bitmap_clear unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-the-start-index-of-bitmap_clear-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

