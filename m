From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-simplify-bitmap_pos_to_ord.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:24 -0800
Message-ID: <54de5d00.aHlzC0D06scRdTle%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbBMUWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: simplify bitmap_pos_to_ord
has been removed from the -mm tree.  Its filename was
     lib-bitmap-simplify-bitmap_pos_to_ord.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/bitmap.c: simplify bitmap_pos_to_ord

The ordinal of a set bit is simply the number of set bits before it;
counting those doesn't need to be done one bit at a time.  While at it,
update the parameters to unsigned int.

It is not completely unthinkable that gcc would see pos as compile-time
constant 0 in one of the uses of bitmap_pos_to_ord.  Since the static
inline frontend bitmap_weight doesn't handle nbits==0 correctly (it would
behave exactly as if nbits==BITS_PER_LONG), use __bitmap_weight.

Alternatively, the last line could be spelled bitmap_weight(buf, pos+1)-1,
but this is simpler.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-simplify-bitmap_pos_to_ord lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-simplify-bitmap_pos_to_ord
+++ a/lib/bitmap.c
@@ -744,10 +744,10 @@ EXPORT_SYMBOL(bitmap_parselist_user);
 /**
  * bitmap_pos_to_ord - find ordinal of set bit at given position in bitmap
  *	@buf: pointer to a bitmap
- *	@pos: a bit position in @buf (0 <= @pos < @bits)
- *	@bits: number of valid bit positions in @buf
+ *	@pos: a bit position in @buf (0 <= @pos < @nbits)
+ *	@nbits: number of valid bit positions in @buf
  *
- * Map the bit at position @pos in @buf (of length @bits) to the
+ * Map the bit at position @pos in @buf (of length @nbits) to the
  * ordinal of which set bit it is.  If it is not set or if @pos
  * is not a valid bit position, map to -1.
  *
@@ -759,22 +759,12 @@ EXPORT_SYMBOL(bitmap_parselist_user);
  *
  * The bit positions 0 through @bits are valid positions in @buf.
  */
-static int bitmap_pos_to_ord(const unsigned long *buf, int pos, int bits)
+static int bitmap_pos_to_ord(const unsigned long *buf, unsigned int pos, unsigned int nbits)
 {
-	int i, ord;
-
-	if (pos < 0 || pos >= bits || !test_bit(pos, buf))
+	if (pos >= nbits || !test_bit(pos, buf))
 		return -1;
 
-	i = find_first_bit(buf, bits);
-	ord = 0;
-	while (i < pos) {
-		i = find_next_bit(buf, bits, i + 1);
-	     	ord++;
-	}
-	BUG_ON(i != pos);
