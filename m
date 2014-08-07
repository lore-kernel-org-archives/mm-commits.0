From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-add-missing-mask-in-bitmap_and.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:08:35 -0700
Message-ID: <53e3dcc3.dq72AKXqfC44TeRx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:47407 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHGUIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:36 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so611419vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add missing mask in bitmap_and
has been removed from the -mm tree.  Its filename was
     lib-bitmap-add-missing-mask-in-bitmap_and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: add missing mask in bitmap_and

Apparently, bitmap_and is supposed to return whether the new bitmap is
empty.  But it didn't take potential garbage bits in the last word into
account.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_and include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_and
+++ a/include/linux/bitmap.h
@@ -191,7 +191,7 @@ static inline int bitmap_and(unsigned lo
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return (*dst = *src1 & *src2) != 0;
+		return (*dst = *src1 & *src2 & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	return __bitmap_and(dst, src1, src2, nbits);
 }
 
diff -puN lib/bitmap.c~lib-bitmap-add-missing-mask-in-bitmap_and lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-add-missing-mask-in-bitmap_and
+++ a/lib/bitmap.c
@@ -185,11 +185,14 @@ int __bitmap_and(unsigned long *dst, con
 				const unsigned long *bitmap2, unsigned int bits)
 {
 	unsigned int k;
-	unsigned int nr = BITS_TO_LONGS(bits);
+	unsigned int lim = bits/BITS_PER_LONG;
 	unsigned long result = 0;
 
-	for (k = 0; k < nr; k++)
+	for (k = 0; k < lim; k++)
 		result |= (dst[k] = bitmap1[k] & bitmap2[k]);
+	if (bits % BITS_PER_LONG)
+		result |= (dst[k] = bitmap1[k] & bitmap2[k] &
+			   BITMAP_LAST_WORD_MASK(bits));
 	return result != 0;
 }
 EXPORT_SYMBOL(__bitmap_and);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

