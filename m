From: akpm@linux-foundation.org
Subject: [patch 03/18] include/linux/bitmap.h: cleanup
Date: Wed, 03 Aug 2016 13:45:54 -0700
Message-ID: <57a25802.thsZvHJXgDiWozLT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbcHCUqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dahi@linux.vnet.ibm.com, schwidefsky@de.ibm.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/bitmap.h: cleanup

Remove two unneeded `else's.

Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization-fix
+++ a/include/linux/bitmap.h
@@ -266,13 +266,12 @@ static inline int bitmap_equal(const uns
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
+		return !((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 #ifdef CONFIG_S390
-	else if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
+	if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
 		return !memcmp(src1, src2, nbits / 8);
 #endif
-	else
-		return __bitmap_equal(src1, src2, nbits);
+	return __bitmap_equal(src1, src2, nbits);
 }
 
 static inline int bitmap_intersects(const unsigned long *src1,
_
