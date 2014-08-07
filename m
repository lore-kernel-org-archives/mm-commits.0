From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:08:05 -0700
Message-ID: <53e3dca5.6hvEH9lUJw2ubtS0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:39867 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:06 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so879602igi.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_full unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: make nbits parameter of bitmap_full unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++--
 lib/bitmap.c           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned
+++ a/include/linux/bitmap.h
@@ -89,7 +89,7 @@
  */
 
 extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
-extern int __bitmap_full(const unsigned long *bitmap, int bits);
+extern int __bitmap_full(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
                 	const unsigned long *bitmap2, int bits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
@@ -265,7 +265,7 @@ static inline int bitmap_empty(const uns
 		return __bitmap_empty(src, nbits);
 }
 
-static inline int bitmap_full(const unsigned long *src, int nbits)
+static inline int bitmap_full(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_full-unsigned
+++ a/lib/bitmap.c
@@ -55,9 +55,9 @@ int __bitmap_empty(const unsigned long *
 }
 EXPORT_SYMBOL(__bitmap_empty);
 
-int __bitmap_full(const unsigned long *bitmap, int bits)
+int __bitmap_full(const unsigned long *bitmap, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (~bitmap[k])
 			return 0;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

