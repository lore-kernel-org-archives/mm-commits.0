From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-add-missing-mask-in-bitmap_andnot.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:37 -0700
Message-ID: <53e3dcc5.mQIKJmsdtj/HlbjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:32867 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHGUIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:38 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so837300oig.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add missing mask in bitmap_andnot
has been removed from the -mm tree.  Its filename was
     lib-bitmap-add-missing-mask-in-bitmap_andnot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: add missing mask in bitmap_andnot

Apparently, bitmap_andnot is supposed to return whether the new bitmap is
empty.  But it didn't take potential garbage bits in the last word into
account.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_andnot include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_andnot
+++ a/include/linux/bitmap.h
@@ -217,7 +217,7 @@ static inline int bitmap_andnot(unsigned
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return (*dst = *src1 & ~(*src2)) != 0;
+		return (*dst = *src1 & ~(*src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	return __bitmap_andnot(dst, src1, src2, nbits);
 }
 
diff -puN lib/bitmap.c~lib-bitmap-add-missing-mask-in-bitmap_andnot lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-add-missing-mask-in-bitmap_andnot
+++ a/lib/bitmap.c
@@ -223,11 +223,14 @@ int __bitmap_andnot(unsigned long *dst,
 				const unsigned long *bitmap2, unsigned int bits)
 {
 	unsigned int k;
-	unsigned int nr = BITS_TO_LONGS(bits);
+	unsigned int lim = bits/BITS_PER_LONG;
 	unsigned long result = 0;
 
-	for (k = 0; k < nr; k++)
+	for (k = 0; k < lim; k++)
 		result |= (dst[k] = bitmap1[k] & ~bitmap2[k]);
+	if (bits % BITS_PER_LONG)
+		result |= (dst[k] = bitmap1[k] & ~bitmap2[k] &
+			   BITMAP_LAST_WORD_MASK(bits));
 	return result != 0;
 }
 EXPORT_SYMBOL(__bitmap_andnot);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

