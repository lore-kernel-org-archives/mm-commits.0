From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:09 -0700
Message-ID: <53e3dca9.qj0o4UboTwLZ8w/6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47283 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:10 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so611316yhl.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_complement unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: make nbits parameter of bitmap_complement unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    6 +++---
 lib/bitmap.c           |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned
+++ a/include/linux/bitmap.h
@@ -93,7 +93,7 @@ extern int __bitmap_full(const unsigned
 extern int __bitmap_equal(const unsigned long *bitmap1,
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
-			int bits);
+			unsigned int nbits);
 extern void __bitmap_shift_right(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern void __bitmap_shift_left(unsigned long *dst,
@@ -222,7 +222,7 @@ static inline int bitmap_andnot(unsigned
 }
 
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
-			int nbits)
+			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
@@ -231,7 +231,7 @@ static inline void bitmap_complement(uns
 }
 
 static inline int bitmap_equal(const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_complement-unsigned
+++ a/lib/bitmap.c
@@ -86,9 +86,9 @@ int __bitmap_equal(const unsigned long *
 }
 EXPORT_SYMBOL(__bitmap_equal);
 
-void __bitmap_complement(unsigned long *dst, const unsigned long *src, int bits)
+void __bitmap_complement(unsigned long *dst, const unsigned long *src, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		dst[k] = ~src[k];
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

