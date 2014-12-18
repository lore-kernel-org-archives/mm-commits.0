From: akpm@linux-foundation.org
Subject: + lib-bitmap-update-bitmap_onto-to-unsigned.patch added to -mm
 tree
Date: Thu, 18 Dec 2014 14:29:47 -0800
Message-ID: <5493555b.R7L0t6U5Xa299QsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaLRW3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: update bitmap_onto to unsigned
has been added to the -mm tree.  Its filename is
     lib-bitmap-update-bitmap_onto-to-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-update-bitmap_onto-to-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-update-bitmap_onto-to-unsigned.patch

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
Subject: lib/bitmap.c: update bitmap_onto to unsigned

Change the nbits parameter of bitmap_onto to unsigned int for consistency
with other bitmap_* functions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-update-bitmap_onto-to-unsigned include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-update-bitmap_onto-to-unsigned
+++ a/include/linux/bitmap.h
@@ -164,7 +164,7 @@ extern void bitmap_remap(unsigned long *
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
-		const unsigned long *relmap, int bits);
+		const unsigned long *relmap, unsigned int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		int sz, int bits);
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
diff -puN lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-update-bitmap_onto-to-unsigned
+++ a/lib/bitmap.c
@@ -1006,9 +1006,9 @@ EXPORT_SYMBOL(bitmap_bitremap);
  * All bits in @dst not set by the above rule are cleared.
  */
 void bitmap_onto(unsigned long *dst, const unsigned long *orig,
-			const unsigned long *relmap, int bits)
+			const unsigned long *relmap, unsigned int bits)
 {
-	int n, m;       	/* same meaning as in above comment */
+	unsigned int n, m;       	/* same meaning as in above comment */
 
 	if (dst == orig)	/* following doesn't handle inplace mappings */
 		return;
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

