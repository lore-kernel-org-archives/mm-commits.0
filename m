From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:06:47 -0800
Message-ID: <548d0cd7.t9j22QIFcmFazbjo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaLNEGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, kgene.kim@samsung.com, kyungmin.park@samsung.com, lauraa@codeaurora.org, laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add alignment offset for bitmap_find_next_zero_area()
has been removed from the -mm tree.  Its filename was
     lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: lib: bitmap: add alignment offset for bitmap_find_next_zero_area()

Add a bitmap_find_next_zero_area_off() function which works like
bitmap_find_next_zero_area() function except it allows an offset to be
specified when alignment is checked.  This lets caller request a bit such
that its number plus the offset is aligned according to the mask.

[gregory.0xf0@gmail.com: Retrieved from https://patchwork.linuxtv.org/patch/6254/ and updated documentation]
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   36 +++++++++++++++++++++++++++++++-----
 lib/bitmap.c           |   24 +++++++++++++-----------
 2 files changed, 44 insertions(+), 16 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area
+++ a/include/linux/bitmap.h
@@ -45,6 +45,7 @@
  * bitmap_set(dst, pos, nbits)			Set specified bit area
  * bitmap_clear(dst, pos, nbits)		Clear specified bit area
  * bitmap_find_next_zero_area(buf, len, pos, n, mask)	Find bit free area
+ * bitmap_find_next_zero_area_off(buf, len, pos, n, mask)	as above
  * bitmap_shift_right(dst, src, n, nbits)	*dst = *src >> n
  * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
  * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
@@ -114,11 +115,36 @@ extern int __bitmap_weight(const unsigne
 
 extern void bitmap_set(unsigned long *map, unsigned int start, int len);
 extern void bitmap_clear(unsigned long *map, unsigned int start, int len);
-extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
-					 unsigned long size,
-					 unsigned long start,
-					 unsigned int nr,
-					 unsigned long align_mask);
+
+extern unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
+						    unsigned long size,
+						    unsigned long start,
+						    unsigned int nr,
+						    unsigned long align_mask,
+						    unsigned long align_offset);
+
+/**
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
+static inline unsigned long
+bitmap_find_next_zero_area(unsigned long *map,
+			   unsigned long size,
+			   unsigned long start,
+			   unsigned int nr,
+			   unsigned long align_mask)
+{
+	return bitmap_find_next_zero_area_off(map, size, start, nr,
+					      align_mask, 0);
+}
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
diff -puN lib/bitmap.c~lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area
+++ a/lib/bitmap.c
@@ -326,30 +326,32 @@ void bitmap_clear(unsigned long *map, un
 }
 EXPORT_SYMBOL(bitmap_clear);
 
-/*
- * bitmap_find_next_zero_area - find a contiguous aligned zero area
+/**
+ * bitmap_find_next_zero_area_off - find a contiguous aligned zero area
  * @map: The address to base the search on
  * @size: The bitmap size in bits
  * @start: The bitnumber to start searching at
  * @nr: The number of zeroed bits we're looking for
  * @align_mask: Alignment mask for zero area
+ * @align_offset: Alignment offset for zero area.
  *
  * The @align_mask should be one less than a power of 2; the effect is that
- * the bit offset of all zero areas this function finds is multiples of that
- * power of 2. A @align_mask of 0 means no alignment is required.
+ * the bit offset of all zero areas this function finds plus @align_offset
+ * is multiple of that power of 2.
  */
-unsigned long bitmap_find_next_zero_area(unsigned long *map,
-					 unsigned long size,
-					 unsigned long start,
-					 unsigned int nr,
-					 unsigned long align_mask)
+unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
+					     unsigned long size,
+					     unsigned long start,
+					     unsigned int nr,
+					     unsigned long align_mask,
+					     unsigned long align_offset)
 {
 	unsigned long index, end, i;
 again:
 	index = find_next_zero_bit(map, size, start);
 
 	/* Align allocation */
-	index = __ALIGN_MASK(index, align_mask);
+	index = __ALIGN_MASK(index + align_offset, align_mask) - align_offset;
 
 	end = index + nr;
 	if (end > size)
@@ -361,7 +363,7 @@ again:
 	}
 	return index;
 }
-EXPORT_SYMBOL(bitmap_find_next_zero_area);
+EXPORT_SYMBOL(bitmap_find_next_zero_area_off);
 
 /*
  * Bitmap printing & parsing functions: first version by Nadia Yvette Chambers,
_

Patches currently in -mm which might be from mina86@mina86.com are

origin.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

