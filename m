From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap_-remove-code-duplication.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:16:45 -0700
Message-ID: <5535509d.zK+IGAu3DvbT8TS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbbDTTKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yury.norov@gmail.com, klimov.linux@gmail.com, linux@horizon.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: bitmap_[empty,full]: remove code duplication
has been removed from the -mm tree.  Its filename was
     lib-bitmap_-remove-code-duplication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/bitmap.c: bitmap_[empty,full]: remove code duplication

bitmap_empty() has its own implementation.  But it's clearly as simple as:

	find_first_bit(src, nbits) == nbits
	
The same is true for 'bitmap_full'.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: George Spelvin <linux@horizon.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    8 ++++----
 lib/bitmap.c           |   30 ------------------------------
 2 files changed, 4 insertions(+), 34 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap_-remove-code-duplication include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap_-remove-code-duplication
+++ a/include/linux/bitmap.h
@@ -283,16 +283,16 @@ static inline int bitmap_empty(const uns
 {
 	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
-	else
-		return __bitmap_empty(src, nbits);
+
+	return find_first_bit(src, nbits) == nbits;
 }
 
 static inline int bitmap_full(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
-	else
-		return __bitmap_full(src, nbits);
+
+	return find_first_zero_bit(src, nbits) == nbits;
 }
 
 static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
diff -puN lib/bitmap.c~lib-bitmap_-remove-code-duplication lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap_-remove-code-duplication
+++ a/lib/bitmap.c
@@ -42,36 +42,6 @@
  * for the best explanations of this ordering.
  */
 
-int __bitmap_empty(const unsigned long *bitmap, unsigned int bits)
-{
-	unsigned int k, lim = bits/BITS_PER_LONG;
-	for (k = 0; k < lim; ++k)
-		if (bitmap[k])
-			return 0;
-
-	if (bits % BITS_PER_LONG)
-		if (bitmap[k] & BITMAP_LAST_WORD_MASK(bits))
-			return 0;
-
-	return 1;
-}
-EXPORT_SYMBOL(__bitmap_empty);
-
-int __bitmap_full(const unsigned long *bitmap, unsigned int bits)
-{
-	unsigned int k, lim = bits/BITS_PER_LONG;
-	for (k = 0; k < lim; ++k)
-		if (~bitmap[k])
-			return 0;
-
-	if (bits % BITS_PER_LONG)
-		if (~bitmap[k] & BITMAP_LAST_WORD_MASK(bits))
-			return 0;
-
-	return 1;
-}
-EXPORT_SYMBOL(__bitmap_full);
