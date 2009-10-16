From: akpm@linux-foundation.org
Subject: + bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:25:25 -0700
Message-ID: <200910162225.n9GMPQcx011513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbZJPW1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, LW@KARO-electronics.de, benh@kernel.crashing.org, davem@davemloft.net, fenghua.yu@intel.com, fujita.tomonori@lab.ntt.co.jp, gregkh@suse.de, hpa@zytor.com, joerg.roedel@amd.com, khubert@gmail.com, mingo@redhat.com, paulus@samba.org, rolandd@cisco.com, tglx@linutronix.de, tony.luck@intel.com, yevgenyp@mellanox.co.il


The patch titled
     bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area fix
has been added to the -mm tree.  Its filename is
     bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area fix
From: Akinobu Mita <akinobu.mita@gmail.com>

- Rewrite bitmap_set and bitmap_clear

  Instead of setting or clearing for each bit.

- Fix off-by-one errors in bitmap_find_next_zero_area

  This bug was derived from find_next_zero_area in iommu-helper.

- Add kerneldoc for bitmap_find_next_zero_area

This patch is supposed to be folded into
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch

* -v2
- Remove an extra test at the "index" value by find_next_bit

Index was just returned by find_next_zero_bit, so we know it's zero.

Noticed-by: Kyle Hubert <khubert@gmail.com>
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


diff -puN lib/bitmap.c~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix lib/bitmap.c
--- a/lib/bitmap.c~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix
+++ a/lib/bitmap.c
@@ -271,28 +271,62 @@ int __bitmap_weight(const unsigned long 
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
-void bitmap_set(unsigned long *map, int i, int len)
-{
-	int end = i + len;
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
 
-	while (i < end) {
-		__set_bit(i, map);
-		i++;
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
 	}
 }
 EXPORT_SYMBOL(bitmap_set);
 
 void bitmap_clear(unsigned long *map, int start, int nr)
 {
-	int end = start + nr;
-
-	while (start < end) {
-		__clear_bit(start, map);
-		start++;
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
 	}
 }
 EXPORT_SYMBOL(bitmap_clear);
 
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
 unsigned long bitmap_find_next_zero_area(unsigned long *map,
 					 unsigned long size,
 					 unsigned long start,
@@ -304,12 +338,12 @@ again:
 	index = find_next_zero_bit(map, size, start);
 
 	/* Align allocation */
-	index = (index + align_mask) & ~align_mask;
+	index = __ALIGN_MASK(index, align_mask);
 
 	end = index + nr;
-	if (end >= size)
+	if (end > size)
 		return end;
-	i = find_next_bit(map, end, index);
+	i = find_next_bit(map, end, index + 1);
 	if (i < end) {
 		start = i + 1;
 		goto again;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area.patch
iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

