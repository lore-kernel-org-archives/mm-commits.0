From: akpm@linux-foundation.org
Subject: + lib-bitmap-simplify-bitmap_ord_to_pos.patch added to -mm tree
Date: Thu, 18 Dec 2014 14:29:53 -0800
Message-ID: <54935561.EjVoLYV8Gk+xotni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLRW3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: simplify bitmap_ord_to_pos
has been added to the -mm tree.  Its filename is
     lib-bitmap-simplify-bitmap_ord_to_pos.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-simplify-bitmap_ord_to_pos.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-simplify-bitmap_ord_to_pos.patch

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
Subject: lib/bitmap.c: simplify bitmap_ord_to_pos

Make the return value and the ord and nbits parameters of
bitmap_ord_to_pos unsigned.

Also, simplify the implementation and as a side effect make the result
fully defined, returning nbits for ord >= weight, in analogy with what
find_{first,next}_bit does.  This is a better sentinel than the former
("unofficial") 0.  No current users are affected by this change.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |   28 +++++++++++-----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-simplify-bitmap_ord_to_pos include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-simplify-bitmap_ord_to_pos
+++ a/include/linux/bitmap.h
@@ -171,7 +171,7 @@ extern int bitmap_find_free_region(unsig
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
-extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
+extern unsigned int bitmap_ord_to_pos(const unsigned long *bitmap, unsigned int ord, unsigned int nbits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
 
diff -puN lib/bitmap.c~lib-bitmap-simplify-bitmap_ord_to_pos lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-simplify-bitmap_ord_to_pos
+++ a/lib/bitmap.c
@@ -771,34 +771,28 @@ static int bitmap_pos_to_ord(const unsig
  * bitmap_ord_to_pos - find position of n-th set bit in bitmap
  *	@buf: pointer to bitmap
  *	@ord: ordinal bit position (n-th set bit, n >= 0)
- *	@bits: number of valid bit positions in @buf
+ *	@nbits: number of valid bit positions in @buf
  *
  * Map the ordinal offset of bit @ord in @buf to its position in @buf.
- * Value of @ord should be in range 0 <= @ord < weight(buf), else
- * results are undefined.
+ * Value of @ord should be in range 0 <= @ord < weight(buf). If @ord
+ * >= weight(buf), returns @nbits.
  *
  * If for example, just bits 4 through 7 are set in @buf, then @ord
  * values 0 through 3 will get mapped to 4 through 7, respectively,
- * and all other @ord values return undefined values.  When @ord value 3
+ * and all other @ord values returns @nbits.  When @ord value 3
  * gets mapped to (returns) @pos value 7 in this example, that means
  * that the 3rd set bit (starting with 0th) is at position 7 in @buf.
  *
- * The bit positions 0 through @bits are valid positions in @buf.
+ * The bit positions 0 through @nbits-1 are valid positions in @buf.
  */
-int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
+unsigned int bitmap_ord_to_pos(const unsigned long *buf, unsigned int ord, unsigned int nbits)
 {
-	int pos = 0;
+	unsigned int pos;
 
-	if (ord >= 0 && ord < bits) {
-		int i;
-
-		for (i = find_first_bit(buf, bits);
-		     i < bits && ord > 0;
-		     i = find_next_bit(buf, bits, i + 1))
-	     		ord--;
-		if (i < bits && ord == 0)
-			pos = i;
-	}
+	for (pos = find_first_bit(buf, nbits);
+	     pos < nbits && ord;
+	     pos = find_next_bit(buf, nbits, pos + 1))
+		ord--;
 
 	return pos;
 }
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

