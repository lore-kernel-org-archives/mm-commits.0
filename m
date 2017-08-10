From: akpm@linux-foundation.org
Subject: + bitmap-introduce-bitmap_from_u64.patch added to -mm tree
Date: Thu, 10 Aug 2017 13:48:12 -0700
Message-ID: <598cc68c.nlz1ExTnyQdyt4+T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752800AbdHJUsN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 16:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ynorov@caviumnetworks.com, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mchehab@kernel.org, noamca@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: introduce BITMAP_FROM_U64()
has been added to the -mm tree.  Its filename is
     bitmap-introduce-bitmap_from_u64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-introduce-bitmap_from_u64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-introduce-bitmap_from_u64.patch

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
Subject: bitmap: introduce BITMAP_FROM_U64()

The macro is the compile-time analogue of bitmap_from_u64() with the same
purpose: convert the 64-bit number to the properly ordered pair of 32-bit
parts, suitable for filling the bitmap in 32-bit BE environment.

Use it to make test_bitmap_parselist() correct for 32-bit BE ABIs.

Tested on BE mips/qemu.

Link: http://lkml.kernel.org/r/20170810172916.24144-1-ynorov@caviumnetworks.com
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Noam Camus <noamca@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   32 ++++++++++++++++++++++++++
 lib/test_bitmap.c      |   47 ++++++++++++++++++++++++++-------------
 2 files changed, 64 insertions(+), 15 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64 include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64
+++ a/include/linux/bitmap.h
@@ -361,6 +361,38 @@ static inline int bitmap_parse(const cha
 }
 
 /*
+ * BITMAP_FROM_U64() - Represent u64 value in the format suitable for bitmap.
+ *
+ * Linux bitmaps are internally the arrays on unsigned longs, i.e. 32-bit
+ * integers in 32-bit environment, and 64-bit integers in 64-bit one.
+ *
+ * There are four combinations of endianess and length of the word in linux ABIs:
+ * LE64, BE64, LE32 and BE32.
+ *
+ * On 64-bit kernels 64-bit LE and BE numbers are naturally ordered in
+ * bitmaps and therefore don't require any special handling.
+ *
+ * On 32-bit kernels 32-bit LE ABI orders lo word of 64-bit number in the memory
+ * prior to hi, and 32-bit BE orders hi word prior to lo. The bitmap in other
+ * hand is represented as the array of 32-bit words, and the position of the
+ * bit N may therefore be calculated as: word #(N/32) and bit #(N%32) in that
+ * word. For example, bit #42 is located at 10th position of 2nd word.
+ * It matches 32-bit LE ABI, and we can simply let the compiler store 64-bit
+ * value on the memory as it usually does. But for BE we therefore need to swap
+ * hi and lo words manually.
+ *
+ * With all that, the macro BITMAP_FROM_U64() does explicit reorder of hi and lo
+ * parts of u64. For LE32 it does nothing in fact, and for BE environment it
+ * swaps hi and lo words, as it expected by bitmap.
+ */
+#if __BITS_PER_LONG == 64
+#define BITMAP_FROM_U64(n) (n)
+#else
+#define BITMAP_FROM_U64(n) ((unsigned long) ((u64)(n) & ULONG_MAX)), \
+				((unsigned long) ((u64)(n) >> 32))
+#endif
+
+/*
  * bitmap_from_u64 - Check and swap words within u64.
  *  @mask: source bitmap
  *  @dst:  destination bitmap
diff -puN lib/test_bitmap.c~bitmap-introduce-bitmap_from_u64 lib/test_bitmap.c
--- a/lib/test_bitmap.c~bitmap-introduce-bitmap_from_u64
+++ a/lib/test_bitmap.c
@@ -175,24 +175,41 @@ struct test_bitmap_parselist{
 	const int flags;
 };
 
-static const unsigned long exp[] = {1, 2, 0x0000ffff, 0xffff0000, 0x55555555,
-				0xaaaaaaaa, 0x11111111, 0x22222222, 0xffffffff,
-				0xfffffffe, 0x3333333311111111, 0xffffffff77777777};
-static const unsigned long exp2[] = {0x3333333311111111, 0xffffffff77777777};
+static const unsigned long exp[] __initconst = {
+	BITMAP_FROM_U64(1),
+	BITMAP_FROM_U64(2),
+	BITMAP_FROM_U64(0x0000ffff),
+	BITMAP_FROM_U64(0xffff0000),
+	BITMAP_FROM_U64(0x55555555),
+	BITMAP_FROM_U64(0xaaaaaaaa),
+	BITMAP_FROM_U64(0x11111111),
+	BITMAP_FROM_U64(0x22222222),
+	BITMAP_FROM_U64(0xffffffff),
+	BITMAP_FROM_U64(0xfffffffe),
+	BITMAP_FROM_U64(0x3333333311111111),
+	BITMAP_FROM_U64(0xffffffff77777777)
+};
+
+static const unsigned long exp2[] __initconst = {
+	BITMAP_FROM_U64(0x3333333311111111),
+	BITMAP_FROM_U64(0xffffffff77777777)
+};
 
 static const struct test_bitmap_parselist parselist_tests[] __initconst = {
+#define step (sizeof(u64) / sizeof(unsigned long))
+
 	{0, "0",			&exp[0], 8, 0},
-	{0, "1",			&exp[1], 8, 0},
-	{0, "0-15",			&exp[2], 32, 0},
-	{0, "16-31",			&exp[3], 32, 0},
-	{0, "0-31:1/2",			&exp[4], 32, 0},
-	{0, "1-31:1/2",			&exp[5], 32, 0},
-	{0, "0-31:1/4",			&exp[6], 32, 0},
-	{0, "1-31:1/4",			&exp[7], 32, 0},
-	{0, "0-31:4/4",			&exp[8], 32, 0},
-	{0, "1-31:4/4",			&exp[9], 32, 0},
-	{0, "0-31:1/4,32-63:2/4",	&exp[10], 64, 0},
-	{0, "0-31:3/4,32-63:4/4",	&exp[11], 64, 0},
+	{0, "1",			&exp[1 * step], 8, 0},
+	{0, "0-15",			&exp[2 * step], 32, 0},
+	{0, "16-31",			&exp[3 * step], 32, 0},
+	{0, "0-31:1/2",			&exp[4 * step], 32, 0},
+	{0, "1-31:1/2",			&exp[5 * step], 32, 0},
+	{0, "0-31:1/4",			&exp[6 * step], 32, 0},
+	{0, "1-31:1/4",			&exp[7 * step], 32, 0},
+	{0, "0-31:4/4",			&exp[8 * step], 32, 0},
+	{0, "1-31:4/4",			&exp[9 * step], 32, 0},
+	{0, "0-31:1/4,32-63:2/4",	&exp[10 * step], 64, 0},
+	{0, "0-31:3/4,32-63:4/4",	&exp[11 * step], 64, 0},
 
 	{0, "0-31:1/4,32-63:2/4,64-95:3/4,96-127:4/4",	exp2, 128, 0},
 
_

Patches currently in -mm which might be from ynorov@caviumnetworks.com are

lib-make-bitmap_parselist-thread-safe-and-much-faster.patch
lib-add-test-for-bitmap_parselist.patch
bitmap-introduce-bitmap_from_u64.patch

