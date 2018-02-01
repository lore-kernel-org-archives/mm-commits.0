From: akpm@linux-foundation.org
Subject: + bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix.patch
 added to -mm tree
Date: Thu, 01 Feb 2018 14:29:01 -0800
Message-ID: <5a7394ad.zKbVLddk+O0e4y14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbeBAW3D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 17:29:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ynorov@caviumnetworks.com, ben@decadent.org.uk, davem@davemloft.net, decot@googlers.com, geert@linux-m68k.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rename bitmap_copy_safe to bitmap_copy_clear_tail
has been added to the -mm tree.  Its filename is
     bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <ynorov@caviumnetworks.com>
Subject: rename bitmap_copy_safe to bitmap_copy_clear_tail

Rename is proposed in review:
https://lkml.org/lkml/2018/1/8/1052

Link: http://lkml.kernel.org/r/20180201172508.5739-3-ynorov@caviumnetworks.com
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: David Decotigny <decot@googlers.com>,
Cc: David S. Miller <davem@davemloft.net>,
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix
+++ a/include/linux/bitmap.h
@@ -233,7 +233,7 @@ static inline void bitmap_copy(unsigned
 /*
  * Copy bitmap and clear tail bits in last word.
  */
-static inline void bitmap_copy_safe(unsigned long *dst,
+static inline void bitmap_copy_clear_tail(unsigned long *dst,
 		const unsigned long *src, unsigned int nbits)
 {
 	bitmap_copy(dst, src, nbits);
@@ -251,11 +251,11 @@ extern void bitmap_from_arr32(unsigned l
 extern void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 							unsigned int nbits);
 #else
-#define bitmap_from_arr32(bitmap, buf, nbits)		\
-	bitmap_copy_safe((unsigned long *) (bitmap),	\
+#define bitmap_from_arr32(bitmap, buf, nbits)			\
+	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
 			(const unsigned long *) (buf), (nbits))
-#define bitmap_to_arr32(buf, bitmap, nbits)		\
-	bitmap_copy_safe((unsigned long *) (buf),	\
+#define bitmap_to_arr32(buf, bitmap, nbits)			\
+	bitmap_copy_clear_tail((unsigned long *) (buf),		\
 			(const unsigned long *) (bitmap), (nbits))
 #endif
 
_

Patches currently in -mm which might be from ynorov@caviumnetworks.com are

bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch
bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32-fix.patch
bitmap-replace-bitmap_fromto_u32array.patch
lib-test_find_bitc-rename-to-find_bit_benchmarkc.patch
lib-find_bit_benchmarkc-improvements.patch

