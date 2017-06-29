From: akpm@linux-foundation.org
Subject: + bitmap-use-memcmp-optimisation-in-more-situations.patch added
 to -mm tree
Date: Thu, 29 Jun 2017 15:21:21 -0700
Message-ID: <59557d61.BwWqXR8xGxoClvvM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdF2WVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 18:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@infradead.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: Use memcmp optimisation in more situations
has been added to the -mm tree.  Its filename is
     bitmap-use-memcmp-optimisation-in-more-situations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-use-memcmp-optimisation-in-more-situations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-use-memcmp-optimisation-in-more-situations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: bitmap: Use memcmp optimisation in more situations


Commit 7dd968163f ("bitmap: bitmap_equal memcmp optimization") was
rather more restrictive than necessary; we can use memcmp() to implement
bitmap_equal() as long as the number of bits can be proved to be a
multiple of 8.  And architectures other than s390 may be able to make
good use of this optimisation.

Link: http://lkml.kernel.org/r/20170628153221.11322-5-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 1 file changed, 1 insertion(+), 3 deletions(-)

index c04c9d155e59..5797ca6fdfe2 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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

Patches currently in -mm which might be from willy@infradead.org are

replace-memfmt-with-string_get_size.patch
bitmap-use-memcmp-optimisation-in-more-situations.patch

