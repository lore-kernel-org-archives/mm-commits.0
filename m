From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:13 -0700
Message-ID: <53e3dcad.y8pjsrAXvL2dFFK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49359 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaHGUIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:14 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so608123qap.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_{and,or,xor,andnot} unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: make nbits parameter of bitmap_{and,or,xor,andnot} unsigned

This change is only for consistency with the changes to the other bitmap_*
functions; it doesn't change the size of the generated code: inside
BITS_TO_LONGS there is a sizeof(long), which causes bits to be interpreted
as unsigned anyway.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   16 ++++++++--------
 lib/bitmap.c           |   24 ++++++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned
+++ a/include/linux/bitmap.h
@@ -99,13 +99,13 @@ extern void __bitmap_shift_right(unsigne
 extern void __bitmap_shift_left(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_intersects(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
@@ -188,7 +188,7 @@ static inline void bitmap_copy(unsigned
 }
 
 static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & *src2) != 0;
@@ -196,7 +196,7 @@ static inline int bitmap_and(unsigned lo
 }
 
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
@@ -205,7 +205,7 @@ static inline void bitmap_or(unsigned lo
 }
 
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
@@ -214,7 +214,7 @@ static inline void bitmap_xor(unsigned l
 }
 
 static inline int bitmap_andnot(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & ~(*src2)) != 0;
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_andorxorandnot-unsigned
+++ a/lib/bitmap.c
@@ -182,10 +182,10 @@ void __bitmap_shift_left(unsigned long *
 EXPORT_SYMBOL(__bitmap_shift_left);
 
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
@@ -195,10 +195,10 @@ int __bitmap_and(unsigned long *dst, con
 EXPORT_SYMBOL(__bitmap_and);
 
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] | bitmap2[k];
@@ -206,10 +206,10 @@ void __bitmap_or(unsigned long *dst, con
 EXPORT_SYMBOL(__bitmap_or);
 
 void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] ^ bitmap2[k];
@@ -217,10 +217,10 @@ void __bitmap_xor(unsigned long *dst, co
 EXPORT_SYMBOL(__bitmap_xor);
 
 int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

