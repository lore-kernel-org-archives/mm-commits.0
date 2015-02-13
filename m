From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-simplify-bitmap_ord_to_pos.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:26 -0800
Message-ID: <54de5d02.uHc4umP/K2M8ndmB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbbBMUW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: simplify bitmap_ord_to_pos
has been removed from the -mm tree.  Its filename was
     lib-bitmap-simplify-bitmap_ord_to_pos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

