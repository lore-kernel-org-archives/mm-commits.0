From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:07 -0700
Message-ID: <53e3dca7.r0WB/89jJc6Ligrj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:34129 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:08 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so878986igd.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_equal unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: make nbits parameter of bitmap_equal unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned
+++ a/include/linux/bitmap.h
@@ -91,7 +91,7 @@
 extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_full(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
-                	const unsigned long *bitmap2, int bits);
+			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
 			int bits);
 extern void __bitmap_shift_right(unsigned long *dst,
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_equal-unsigned
+++ a/lib/bitmap.c
@@ -71,9 +71,9 @@ int __bitmap_full(const unsigned long *b
 EXPORT_SYMBOL(__bitmap_full);
 
 int __bitmap_equal(const unsigned long *bitmap1,
-		const unsigned long *bitmap2, int bits)
+		const unsigned long *bitmap2, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap1[k] != bitmap2[k])
 			return 0;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

