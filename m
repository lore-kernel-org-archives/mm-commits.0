From: akpm@linux-foundation.org
Subject: [merged] linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:09 -0700
Message-ID: <552fe96d.QwtsrNuWPpPU1rjB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbbDPQtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, linux@horizon.com, tj@kernel.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/bitmap.h: improve BITMAP_{LAST,FIRST}_WORD_MASK
has been removed from the -mm tree.  Its filename was
     linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: George Spelvin <linux@horizon.com>
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
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
lib-bitmap_-remove-code-duplication.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
linux-next.patch

