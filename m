From: akpm@linux-foundation.org
Subject: + linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch added to -mm tree
Date: Wed, 18 Feb 2015 14:53:00 -0800
Message-ID: <54e517cc.8cbaOXu3JiVMnV3v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbBRWxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 17:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, linux@horizon.com, tj@kernel.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/bitmap.h: improve BITMAP_{LAST,FIRST}_WORD_MASK
has been added to the -mm tree.  Its filename is
     linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/bitmap.h: improve BITMAP_{LAST,FIRST}_WORD_MASK

The macro BITMAP_LAST_WORD_MASK can be implemented without a conditional,
which will generally lead to slightly better generated code (221 bytes
saved for allmodconfig-GCOV_KERNEL, ~2k with GCOV_KERNEL).  As a small
bonus, this also ensures that the nbits parameter is expanded exactly
once.

In BITMAP_FIRST_WORD_MASK, if start is signed gcc is technically allowed
to assume it is positive (or divisible by BITS_PER_LONG), and hence just
do the simple mask.  It doesn't seem to use this, and even on an
architecture like x86 where the shift only depends on the lower 5 or 6
bits, and these bits are not affected by the signedness of the expression,
gcc still generates code to compute the C99 mandated value of start %
BITS_PER_LONG.  So just use a mask explicitly, also for consistency with
BITMAP_LAST_WORD_MASK.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "George Spelvin" <linux@horizon.com>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN include/linux/bitmap.h~linux-bitmaph-improve-bitmap_lastfirst_word_mask include/linux/bitmap.h
--- a/include/linux/bitmap.h~linux-bitmaph-improve-bitmap_lastfirst_word_mask
+++ a/include/linux/bitmap.h
@@ -172,12 +172,8 @@ extern unsigned int bitmap_ord_to_pos(co
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
 
-#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
-#define BITMAP_LAST_WORD_MASK(nbits)					\
-(									\
-	((nbits) % BITS_PER_LONG) ?					\
-		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
-)
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
+#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
 
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
linux-next.patch

