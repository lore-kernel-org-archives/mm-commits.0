From: akpm@linux-foundation.org
Subject: +
 lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
 added to -mm tree
Date: Wed, 05 Nov 2014 13:53:21 -0800
Message-ID: <545a9c51./hTu/G8EydyLrZAY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKEVxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 16:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.nazarewicz@samsung.com, gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, kgene.kim@samsung.com, kyungmin.park@samsung.com, lauraa@codeaurora.org, laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add alignment offset for bitmap_find_next_zero_area()
has been added to the -mm tree.  Its filename is
     lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: lib: bitmap: add alignment offset for bitmap_find_next_zero_area()

Add a bitmap_find_next_zero_area_off() function which works like
bitmap_find_next_zero_area() function except it allows an offset to be
specified when alignment is checked.  This lets caller request a bit such
that its number plus the offset is aligned according to the mask.

[gregory.0xf0@gmail.com: Retrieved from https://patchwork.linuxtv.org/patch/6254/ and updated documentation]
Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
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

Patches currently in -mm which might be from m.nazarewicz@samsung.com are

lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch

