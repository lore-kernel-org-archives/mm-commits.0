From: akpm@linux-foundation.org
Subject: [merged]
 bitmap-use-memcmp-optimisation-in-more-situations.patch removed from -mm
 tree
Date: Tue, 11 Jul 2017 12:26:26 -0700
Message-ID: <20170711192626.dFgffBLuE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbdGKT01 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: use memcmp optimisation in more situations
has been removed from the -mm tree.  Its filename was
     bitmap-use-memcmp-optimisation-in-more-situations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: bitmap: use memcmp optimisation in more situations

Commit 7dd968163f ("bitmap: bitmap_equal memcmp optimization") was rather
more restrictive than necessary; we can use memcmp() to implement
bitmap_equal() as long as the number of bits can be proved to be a
multiple of 8.  And architectures other than s390 may be able to make good
use of this optimisation.

[arnd@arndb.de: fix build: add a memcmp() declaration]
  Link: http://lkml.kernel.org/r/20170630153908.3439707-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/20170628153221.11322-5-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/decompress.c |    1 +
 include/linux/bitmap.h                |    4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/arm/boot/compressed/decompress.c~bitmap-use-memcmp-optimisation-in-more-situations arch/arm/boot/compressed/decompress.c
--- a/arch/arm/boot/compressed/decompress.c~bitmap-use-memcmp-optimisation-in-more-situations
+++ a/arch/arm/boot/compressed/decompress.c
@@ -33,6 +33,7 @@ extern void error(char *);
 /* Not needed, but used in some headers pulled in by decompressors */
 extern char * strstr(const char * s1, const char *s2);
 extern size_t strlen(const char *s);
+extern int memcmp(const void *cs, const void *ct, size_t count);
 
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
diff -puN include/linux/bitmap.h~bitmap-use-memcmp-optimisation-in-more-situations include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-use-memcmp-optimisation-in-more-situations
+++ a/include/linux/bitmap.h
@@ -266,10 +266,8 @@ static inline int bitmap_equal(const uns
 {
 	if (small_const_nbits(nbits))
 		return !((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
-#ifdef CONFIG_S390
-	if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
+	if (__builtin_constant_p(nbits & 7) && IS_ALIGNED(nbits, 8))
 		return !memcmp(src1, src2, nbits / 8);
-#endif
 	return __bitmap_equal(src1, src2, nbits);
 }
 
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


