Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E33C3526F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A231923159
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgLPEoY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEoY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:24 -0500
Date:   Tue, 15 Dec 2020 20:44:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093848;
        bh=pPBKTXTaMVTLoDKB7jOFgfvTytiEYvTQfYv1IlIr0Wc=;
        h=From:To:Subject:In-Reply-To:From;
        b=hvZiEnko7o92vMPje3ND4cSxS9PGxkpJW/Kv4j9il+K0g+52+e+R8aR9gvyZqtdjK
         LGbR26Q2R2PWaIuRTR2H4iH9rzDPpht2a0obCheob+yRyed6QIDdj/MNblCNujtoBd
         0/GVe0zC/4p0dmnpImvQOw8Ce+216Ml0zfnG04AU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bgolaszewski@baylibre.com, linus.walleij@linaro.org,
        linux-mm@kvack.org, michal.simek@xilinx.com,
        mm-commits@vger.kernel.org, syednwaris@gmail.com,
        torvalds@linux-foundation.org, vilhelm.gray@gmail.com
Subject:  [patch 33/95] bitops: introduce the for_each_set_clump
 macro
Message-ID: <20201216044407.mwZ3xRLJw%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Syed Nayyar Waris <syednwaris@gmail.com>
Subject: bitops: introduce the for_each_set_clump macro

Patch series "Introduce the for_each_set_clump macro", v12.

This patchset introduces a new generic version of for_each_set_clump.  The
previous version of for_each_set_clump8 used a fixed size 8-bit clump, but
the new generic version can work with clump (n-bits) having size between 1
and BITS_PER_LONG inclusive.  size less than 1 or more than BITS_PER_LONG
causes undefined behaviour.  The patchset utilizes the new macro in some
GPIO drivers.

The earlier 8-bit for_each_set_clump8 facilitated a for-loop syntax that
iterates over a memory region entire groups of set bits at a time.

For example, suppose you would like to iterate over a 32-bit integer 8
bits at a time, skipping over 8-bit groups with no set bit, where
XXXXXXXX represents the current 8-bit group:

    Example:        10111110 00000000 11111111 00110011
    First loop:     10111110 00000000 11111111 XXXXXXXX
    Second loop:    10111110 00000000 XXXXXXXX 00110011
    Third loop:     XXXXXXXX 00000000 11111111 00110011

Each iteration of the loop returns the next 8-bit group that has at least
one set bit.

But with the new for_each_set_clump the clump size can be different from 8
bits.  Moreover, the clump can be split at word boundary in situations
where word size is not multiple of clump size.  Following are examples
showing the working of new macro for clump sizes of 24 bits and 6 bits.

Example 1:
clump size: 24 bits, Number of clumps (or ports): 10
bitmap stores the bit information from where successive clumps are retrieved.

     /* bitmap memory region */
        0x00aa0000ff000000;  /* Most significant bits */
        0xaaaaaa0000ff0000;
        0x000000aa000000aa;
        0xbbbbabcdeffedcba;  /* Least significant bits */

Different iterations of for_each_set_clump:-
'offset' is the bit position and 'clump' is the 24 bit clump from the
above bitmap.
Iteration first:        offset: 0 clump: 0xfedcba
Iteration second:       offset: 24 clump: 0xabcdef
Iteration third:        offset: 48 clump: 0xaabbbb
Iteration fourth:       offset: 96 clump: 0xaa
Iteration fifth:        offset: 144 clump: 0xff
Iteration sixth:        offset: 168 clump: 0xaaaaaa
Iteration seventh:      offset: 216 clump: 0xff
Loop breaks because in the end the remaining bits (0x00aa) size was less
than clump size of 24 bits.

In above example it can be seen that in iteration third, the 24 bit clump
that was retrieved was split between bitmap[0] and bitmap[1].  This
example also shows that 24 bit zeroes if present in between, were skipped
(preserving the previous for_each_set_macro8 behaviour).  

Example 2:
clump size = 6 bits, Number of clumps (or ports) = 3.

     /* bitmap memory region */
        0x00aa0000ff000000;  /* Most significant bits */
        0xaaaaaa0000ff0000;
        0x0f00000000000000;
        0x0000000000000ac0;  /* Least significant bits */

Different iterations of for_each_set_clump:
'offset' is the bit position and 'clump' is the 6 bit clump from the
above bitmap.
Iteration first:        offset: 6 clump: 0x2b
Loop breaks because 6 * 3 = 18 bits traversed in bitmap.
Here 6 * 3 is clump size * no. of clumps.


This patch (of 4):

This macro iterates for each group of bits (clump) with set bits, within a
bitmap memory region.  For each iteration, "start" is set to the bit
offset of the found clump, while the respective clump value is stored to
the location pointed by "clump".

Additionally, the bitmap_get_value() and bitmap_set_value() functions are
introduced to respectively get and set a value of n-bits in a bitmap
memory region.  The n-bits can have any size from 1 to BITS_PER_LONG. 
size less than 1 or more than BITS_PER_LONG causes undefined behaviour.

Moreover, during setting value of n-bit in bitmap, if a situation arise
that the width of next n-bit is exceeding the word boundary, then it will
divide itself such that some portion of it is stored in that word, while
the remaining portion is stored in the next higher word.  Similar
situation occurs while retrieving the value from bitmap.

Link: https://lkml.kernel.org/r/cover.1603055402.git.syednwaris@gmail.com
Link: https://lkml.kernel.org/r/199b749c404450d1acb667e629ec4da37f44b60c.1603055402.git.syednwaris@gmail.com
Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h |   19 ++++++++
 include/linux/bitmap.h            |   61 ++++++++++++++++++++++++++++
 include/linux/bitops.h            |   13 +++++
 lib/find_bit.c                    |   14 ++++++
 4 files changed, 107 insertions(+)

--- a/include/asm-generic/bitops/find.h~bitops-introduce-the-for_each_set_clump-macro
+++ a/include/asm-generic/bitops/find.h
@@ -97,4 +97,23 @@ extern unsigned long find_next_clump8(un
 #define find_first_clump8(clump, bits, size) \
 	find_next_clump8((clump), (bits), (size), 0)
 
+/**
+ * find_next_clump - find next clump with set bits in a memory region
+ * @clump: location to store copy of found clump
+ * @addr: address to base the search on
+ * @size: bitmap size in number of bits
+ * @offset: bit offset at which to start searching
+ * @clump_size: clump size in bits
+ *
+ * Returns the bit offset for the next set clump; the found clump value is
+ * copied to the location pointed by @clump. If no bits are set, returns @size.
+ */
+extern unsigned long find_next_clump(unsigned long *clump,
+				      const unsigned long *addr,
+				      unsigned long size, unsigned long offset,
+				      unsigned long clump_size);
+
+#define find_first_clump(clump, bits, size, clump_size) \
+	find_next_clump((clump), (bits), (size), 0, (clump_size))
+
 #endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
--- a/include/linux/bitmap.h~bitops-introduce-the-for_each_set_clump-macro
+++ a/include/linux/bitmap.h
@@ -75,7 +75,11 @@
  *  bitmap_from_arr32(dst, buf, nbits)          Copy nbits from u32[] buf to dst
  *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
  *  bitmap_get_value8(map, start)               Get 8bit value from map at start
+ *  bitmap_get_value(map, start, nbits)		Get bit value of size
+ *                                              'nbits' from map at start
  *  bitmap_set_value8(map, value, start)        Set 8bit value to map at start
+ *  bitmap_set_value(map, value, start, nbits)	Set bit value of size 'nbits'
+ *                                              of map at start
  *
  * Note, bitmap_zero() and bitmap_fill() operate over the region of
  * unsigned longs, that is, bits behind bitmap till the unsigned long
@@ -562,6 +566,34 @@ static inline unsigned long bitmap_get_v
 }
 
 /**
+ * bitmap_get_value - get a value of n-bits from the memory region
+ * @map: address to the bitmap memory region
+ * @start: bit offset of the n-bit value
+ * @nbits: size of value in bits (must be between 1 and BITS_PER_LONG inclusive).
+ *
+ * Returns value of nbits located at the @start bit offset within the @map
+ * memory region.
+ */
+static inline unsigned long bitmap_get_value(const unsigned long *map,
+					      unsigned long start,
+					      unsigned long nbits)
+{
+	const size_t index = BIT_WORD(start);
+	const unsigned long offset = start % BITS_PER_LONG;
+	const unsigned long ceiling = round_up(start + 1, BITS_PER_LONG);
+	const unsigned long space = ceiling - start;
+	unsigned long value_low, value_high;
+
+	if (space >= nbits)
+		return (map[index] >> offset) & GENMASK(nbits - 1, 0);
+	else {
+		value_low = map[index] & BITMAP_FIRST_WORD_MASK(start);
+		value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
+		return (value_low >> offset) | (value_high << space);
+	}
+}
+
+/**
  * bitmap_set_value8 - set an 8-bit value within a memory region
  * @map: address to the bitmap memory region
  * @value: the 8-bit value; values wider than 8 bits may clobber bitmap
@@ -577,6 +609,35 @@ static inline void bitmap_set_value8(uns
 	map[index] |= value << offset;
 }
 
+/**
+ * bitmap_set_value - set n-bit value within a memory region
+ * @map: address to the bitmap memory region
+ * @value: value of nbits
+ * @start: bit offset of the n-bit value
+ * @nbits: size of value in bits (must be between 1 and BITS_PER_LONG inclusive).
+ */
+static inline void bitmap_set_value(unsigned long *map,
+				    unsigned long value,
+				    unsigned long start, unsigned long nbits)
+{
+	const size_t index = BIT_WORD(start);
+	const unsigned long offset = start % BITS_PER_LONG;
+	const unsigned long ceiling = round_up(start + 1, BITS_PER_LONG);
+	const unsigned long space = ceiling - start;
+
+	value &= GENMASK(nbits - 1, 0);
+
+	if (space >= nbits) {
+		map[index] &= ~(GENMASK(nbits - 1, 0) << offset);
+		map[index] |= value << offset;
+	} else {
+		map[index + 0] &= ~BITMAP_FIRST_WORD_MASK(start);
+		map[index + 0] |= value << offset;
+		map[index + 1] &= ~BITMAP_LAST_WORD_MASK(start + nbits);
+		map[index + 1] |= value >> space;
+	}
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __LINUX_BITMAP_H */
--- a/include/linux/bitops.h~bitops-introduce-the-for_each_set_clump-macro
+++ a/include/linux/bitops.h
@@ -65,6 +65,19 @@ extern unsigned long __sw_hweight64(__u6
 	     (start) < (size); \
 	     (start) = find_next_clump8(&(clump), (bits), (size), (start) + 8))
 
+/**
+ * for_each_set_clump - iterate over bitmap for each clump with set bits
+ * @start: bit offset to start search and to store the current iteration offset
+ * @clump: location to store copy of current 8-bit clump
+ * @bits: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ * @clump_size: clump size in bits
+ */
+#define for_each_set_clump(start, clump, bits, size, clump_size) \
+	for ((start) = find_first_clump(&(clump), (bits), (size), (clump_size)); \
+	     (start) < (size); \
+	     (start) = find_next_clump(&(clump), (bits), (size), (start) + (clump_size), (clump_size)))
+
 static inline int get_bitmask_order(unsigned int count)
 {
 	int order;
--- a/lib/find_bit.c~bitops-introduce-the-for_each_set_clump-macro
+++ a/lib/find_bit.c
@@ -192,3 +192,17 @@ unsigned long find_next_clump8(unsigned
 	return offset;
 }
 EXPORT_SYMBOL(find_next_clump8);
+
+unsigned long find_next_clump(unsigned long *clump, const unsigned long *addr,
+			       unsigned long size, unsigned long offset,
+			       unsigned long clump_size)
+{
+	offset = find_next_bit(addr, size, offset);
+	if (offset == size)
+		return size;
+
+	offset = rounddown(offset, clump_size);
+	*clump = bitmap_get_value(addr, offset, clump_size);
+	return offset;
+}
+EXPORT_SYMBOL(find_next_clump);
_
