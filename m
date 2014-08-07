From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:08:19 -0700
Message-ID: <53e3dcb3.5TlMsvTnBdXCIjVl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:46392 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaHGUIT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:19 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so610791ykq.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: make nbits parameter of bitmap_weight unsigned
has been removed from the -mm tree.  Its filename was
     lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: make nbits parameter of bitmap_weight unsigned

The compiler can generate slightly smaller and simpler code when it knows
that "nbits" is non-negative.  Since no-one passes a negative bit-count,
this shouldn't affect the semantics.

I didn't change the return type, since that might change the semantics
of some expression containing a call to bitmap_weight(). Certainly an
int is capable of holding the result.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++--
 lib/bitmap.c           |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned
+++ a/include/linux/bitmap.h
@@ -110,7 +110,7 @@ extern int __bitmap_intersects(const uns
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
-extern int __bitmap_weight(const unsigned long *bitmap, int bits);
+extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
 
 extern void bitmap_set(unsigned long *map, int i, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
@@ -273,7 +273,7 @@ static inline int bitmap_full(const unsi
 		return __bitmap_full(src, nbits);
 }
 
-static inline int bitmap_weight(const unsigned long *src, int nbits)
+static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
diff -puN lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-nbits-parameter-of-bitmap_weight-unsigned
+++ a/lib/bitmap.c
@@ -259,9 +259,10 @@ int __bitmap_subset(const unsigned long
 }
 EXPORT_SYMBOL(__bitmap_subset);
 
-int __bitmap_weight(const unsigned long *bitmap, int bits)
+int __bitmap_weight(const unsigned long *bitmap, unsigned int bits)
 {
-	int k, w = 0, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
+	int w = 0;
 
 	for (k = 0; k < lim; k++)
 		w += hweight_long(bitmap[k]);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

