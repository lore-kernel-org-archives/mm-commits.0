From: akpm@linux-foundation.org
Subject: [merged] bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:29 -0800
Message-ID: <200912162041.nBGKfT1B013813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965042AbZLPUms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:42:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, LW@KARO-electronics.de, benh@kernel.crashing.org, davem@davemloft.net, fenghua.yu@intel.com, fujita.tomonori@lab.ntt.co.jp, gregkh@suse.de, hpa@zytor.com, joer


The patch titled
     bitmap: introduce bitmap_set, bitmap_clear, bitmap_find_next_zero_area
has been removed from the -mm tree.  Its filename was
     bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap: introduce bitmap_set, bitmap_clear, bitmap_find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>

This introduces new bitmap functions:

bitmap_set: Set specified bit area
bitmap_clear: Clear specified bit area
bitmap_find_next_zero_area: Find free bit area

These are mostly stolen from iommu helper. The differences are:

- Use find_next_bit instead of doing test_bit for each bit

- Rewrite bitmap_set and bitmap_clear

  Instead of setting or clearing for each bit.

- Check the last bit of the limit

  iommu-helper doesn't want to find such area

- The return value if there is no zero area

  find_next_zero_area in iommu helper: returns -1
  bitmap_find_next_zero_area: return >= bitmap size

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lothar Wassmann <LW@KARO-electronics.de>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   11 +++++
 lib/bitmap.c           |   81 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area
+++ a/include/linux/bitmap.h
@@ -42,6 +42,9 @@
  * bitmap_empty(src, nbits)			Are all bits zero in *src?
  * bitmap_full(src, nbits)			Are all bits set in *src?
  * bitmap_weight(src, nbits)			Hamming Weight: number set bits
+ * bitmap_set(dst, pos, nbits)			Set specified bit area
+ * bitmap_clear(dst, pos, nbits)		Clear specified bit area
+ * bitmap_find_next_zero_area(buf, len, pos, n, mask)	Find bit free area
  * bitmap_shift_right(dst, src, n, nbits)	*dst = *src >> n
  * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
  * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
@@ -108,6 +111,14 @@ extern int __bitmap_subset(const unsigne
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
+extern void bitmap_set(unsigned long *map, int i, int len);
+extern void bitmap_clear(unsigned long *map, int start, int nr);
+extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
+					 unsigned long size,
+					 unsigned long start,
+					 unsigned int nr,
+					 unsigned long align_mask);
+
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
diff -puN lib/bitmap.c~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area lib/bitmap.c
--- a/lib/bitmap.c~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area
+++ a/lib/bitmap.c
@@ -271,6 +271,87 @@ int __bitmap_weight(const unsigned long 
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
+
+void bitmap_set(unsigned long *map, int start, int nr)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const int size = start + nr;
+	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
+
+	while (nr - bits_to_set >= 0) {
+		*p |= mask_to_set;
+		nr -= bits_to_set;
+		bits_to_set = BITS_PER_LONG;
+		mask_to_set = ~0UL;
+		p++;
+	}
+	if (nr) {
+		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
+		*p |= mask_to_set;
+	}
+}
+EXPORT_SYMBOL(bitmap_set);
+
+void bitmap_clear(unsigned long *map, int start, int nr)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const int size = start + nr;
+	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
+
+	while (nr - bits_to_clear >= 0) {
+		*p &= ~mask_to_clear;
+		nr -= bits_to_clear;
+		bits_to_clear = BITS_PER_LONG;
+		mask_to_clear = ~0UL;
+		p++;
+	}
+	if (nr) {
+		mask_to_clear &= BITMAP_LAST_WORD_MASK(size);
+		*p &= ~mask_to_clear;
+	}
+}
+EXPORT_SYMBOL(bitmap_clear);
+
+/*
+ * bitmap_find_next_zero_area - find a contiguous aligned zero area
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ * @align_mask: Alignment mask for zero area
+ *
+ * The @align_mask should be one less than a power of 2; the effect is that
+ * the bit offset of all zero areas this function finds is multiples of that
+ * power of 2. A @align_mask of 0 means no alignment is required.
+ */
+unsigned long bitmap_find_next_zero_area(unsigned long *map,
+					 unsigned long size,
+					 unsigned long start,
+					 unsigned int nr,
+					 unsigned long align_mask)
+{
+	unsigned long index, end, i;
+again:
+	index = find_next_zero_bit(map, size, start);
+
+	/* Align allocation */
+	index = __ALIGN_MASK(index, align_mask);
+
+	end = index + nr;
+	if (end > size)
+		return end;
+	i = find_next_bit(map, end, index);
+	if (i < end) {
+		start = i + 1;
+		goto again;
+	}
+	return index;
+}
+EXPORT_SYMBOL(bitmap_find_next_zero_area);
+
 /*
  * Bitmap printing & parsing functions: first version by Bill Irwin,
  * second version by Paul Jackson, third by Joe Korty.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
x86-optimize-hweight32.patch
ntfs-use-bitmap_weight.patch

