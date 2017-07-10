From: akpm@linux-foundation.org
Subject: [patch 087/115] bitmap: use memcmp optimisation in more
 situations
Date: Mon, 10 Jul 2017 15:51:35 -0700
Message-ID: <20170710225135.hxGPMoC2y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754949AbdGJWvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
