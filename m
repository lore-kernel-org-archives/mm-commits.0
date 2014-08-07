From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:15 -0700
Message-ID: <53e3dcaf.XHOXXECBaFrdnZkA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:42505 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbaHGUIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:16 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so611669qgd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_intersects unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: make nbits parameter of bitmap_intersects unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++--
 lib/bitmap.c           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned
+++ a/include/linux/bitmap.h
@@ -107,7 +107,7 @@ extern void __bitmap_xor(unsigned long *
 extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_intersects(const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
@@ -240,7 +240,7 @@ static inline int bitmap_equal(const uns
 }
 
 static inline int bitmap_intersects(const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ((*src1 & *src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_intersects-unsigned
+++ a/lib/bitmap.c
@@ -230,9 +230,9 @@ int __bitmap_andnot(unsigned long *dst,
 EXPORT_SYMBOL(__bitmap_andnot);
 
 int __bitmap_intersects(const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+			const unsigned long *bitmap2, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap1[k] & bitmap2[k])
 			return 1;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

