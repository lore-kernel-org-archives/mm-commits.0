From: akpm@linux-foundation.org
Subject: + lib-bitmap-simplify-bitmap_pos_to_ord.patch added to -mm tree
Date: Thu, 18 Dec 2014 14:29:51 -0800
Message-ID: <5493555f.ECumoAMTV8Heihuh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaLRW3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: simplify bitmap_pos_to_ord
has been added to the -mm tree.  Its filename is
     lib-bitmap-simplify-bitmap_pos_to_ord.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-simplify-bitmap_pos_to_ord.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-simplify-bitmap_pos_to_ord.patch

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
