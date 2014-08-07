From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:08:11 -0700
Message-ID: <53e3dcab.+4TTtHSn6nKjytaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:51948 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:12 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so607677qgd.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: remove unnecessary mask from bitmap_complement
has been removed from the -mm tree.  Its filename was
     lib-bitmap-remove-unnecessary-mask-from-bitmap_complement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: remove unnecessary mask from bitmap_complement

Since the extra bits are "don't care", there is no reason to mask the last
word to the used bits when complementing.  This shaves off yet a few
bytes.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement
+++ a/include/linux/bitmap.h
@@ -225,7 +225,7 @@ static inline void bitmap_complement(uns
 			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
+		*dst = ~(*src);
 	else
 		__bitmap_complement(dst, src, nbits);
 }
diff -puN lib/bitmap.c~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-remove-unnecessary-mask-from-bitmap_complement
+++ a/lib/bitmap.c
@@ -93,7 +93,7 @@ void __bitmap_complement(unsigned long *
 		dst[k] = ~src[k];
 
 	if (bits % BITS_PER_LONG)
-		dst[k] = ~src[k] & BITMAP_LAST_WORD_MASK(bits);
+		dst[k] = ~src[k];
 }
 EXPORT_SYMBOL(__bitmap_complement);
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

