From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch added to
 -mm tree
Date: Thu, 18 Dec 2014 14:29:55 -0800
Message-ID: <54935563.ssVOmcJIcTx/bW8o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLRW34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: make the bits parameter of bitmap_remap unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch

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
Subject: lib/bitmap.c: make the bits parameter of bitmap_remap unsigned

Make the nbits parameter unsigned for consistency with most other
bitmap_* functions, and pull the test of empty dst out of the loop.

And rename it to nbits, both for consistency with other bitmap_*
functions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned
+++ a/include/linux/bitmap.h
@@ -160,7 +160,7 @@ extern int bitmap_parselist(const char *
 extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
 			unsigned long *dst, int nbits);
 extern void bitmap_remap(unsigned long *dst, const unsigned long *src,
-		const unsigned long *old, const unsigned long *new, int bits);
+		const unsigned long *old, const unsigned long *new, unsigned int nbits);
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
diff -puN lib/bitmap.c~lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned
+++ a/lib/bitmap.c
@@ -803,7 +803,7 @@ unsigned int bitmap_ord_to_pos(const uns
  *	@src: subset to be remapped
  *	@old: defines domain of map
  *	@new: defines range of map
- *	@bits: number of bits in each of these bitmaps
+ *	@nbits: number of bits in each of these bitmaps
  *
  * Let @old and @new define a mapping of bit positions, such that
  * whatever position is held by the n-th set bit in @old is mapped
@@ -831,22 +831,22 @@ unsigned int bitmap_ord_to_pos(const uns
  */
 void bitmap_remap(unsigned long *dst, const unsigned long *src,
 		const unsigned long *old, const unsigned long *new,
-		int bits)
+		unsigned int nbits)
 {
-	int oldbit, w;
+	unsigned int oldbit, w;
 
 	if (dst == src)		/* following doesn't handle inplace remaps */
 		return;
-	bitmap_zero(dst, bits);
+	bitmap_zero(dst, nbits);
 
-	w = bitmap_weight(new, bits);
-	for_each_set_bit(oldbit, src, bits) {
-	     	int n = bitmap_pos_to_ord(old, oldbit, bits);
+	w = bitmap_weight(new, nbits);
+	for_each_set_bit(oldbit, src, nbits) {
+		int n = bitmap_pos_to_ord(old, oldbit, nbits);
 
 		if (n < 0 || w == 0)
 			set_bit(oldbit, dst);	/* identity map */
 		else
-			set_bit(bitmap_ord_to_pos(new, n % w, bits), dst);
+			set_bit(bitmap_ord_to_pos(new, n % w, nbits), dst);
 	}
 }
 EXPORT_SYMBOL(bitmap_remap);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

