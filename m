Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0D3C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E767961164
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbhIHDA6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347361AbhIHDAu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F2F461102;
        Wed,  8 Sep 2021 02:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069982;
        bh=rw8604kd7/9KpqpygJ/6s3NPt/DT5oN6xzEWz3gtPNw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i/BUORayaPaxgy3LPseY5aHkfDhQ9Q1fysE/IN6jBLIWFGFkstSMX0IR5vF4DZL07
         DrML7kCL7emQlbeEA7EdxQBzZuhqNSCBmj2fyRCISdBygw9TbEcVPh0fhS0HdnfR4B
         wDL6cUnjJRUucUBYXArOsEUwk1ex9oy5/o/iQOH8=
Date:   Tue, 07 Sep 2021 19:59:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 121/147] bitmap: unify find_bit operations
Message-ID: <20210908025942.Sxli7QSKt%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: bitmap: unify find_bit operations

bitmap_for_each_{set,clear}_region() are similar to for_each_bit() macros
in include/linux/find.h, but interface and implementation of them are
different.

This patch adds for_each_bitrange() macros and drops unused
bitmap_*_region() API in sake of unification.

Link: https://lkml.kernel.org/r/20210814211713.180533-16-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>	[MMC]
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/renesas_sdhi_core.c |    2 
 include/linux/bitmap.h               |   33 --------------
 include/linux/find.h                 |   56 +++++++++++++++++++++++++
 mm/percpu.c                          |   20 +++-----
 4 files changed, 65 insertions(+), 46 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c~bitmap-unify-find_bit-operations
+++ a/drivers/mmc/host/renesas_sdhi_core.c
@@ -647,7 +647,7 @@ static int renesas_sdhi_select_tuning(st
 	 * is at least SH_MOBILE_SDHI_MIN_TAP_ROW probes long then use the
 	 * center index as the tap, otherwise bail out.
 	 */
-	bitmap_for_each_set_region(bitmap, rs, re, 0, taps_size) {
+	for_each_set_bitrange(rs, re, bitmap, taps_size) {
 		if (re - rs > tap_cnt) {
 			tap_end = re;
 			tap_start = rs;
--- a/include/linux/bitmap.h~bitmap-unify-find_bit-operations
+++ a/include/linux/bitmap.h
@@ -55,12 +55,6 @@ struct device;
  *  bitmap_clear(dst, pos, nbits)               Clear specified bit area
  *  bitmap_find_next_zero_area(buf, len, pos, n, mask)  Find bit free area
  *  bitmap_find_next_zero_area_off(buf, len, pos, n, mask, mask_off)  as above
- *  bitmap_next_clear_region(map, &start, &end, nbits)  Find next clear region
- *  bitmap_next_set_region(map, &start, &end, nbits)  Find next set region
- *  bitmap_for_each_clear_region(map, rs, re, start, end)
- *  						Iterate over all clear regions
- *  bitmap_for_each_set_region(map, rs, re, start, end)
- *  						Iterate over all set regions
  *  bitmap_shift_right(dst, src, n, nbits)      *dst = *src >> n
  *  bitmap_shift_left(dst, src, n, nbits)       *dst = *src << n
  *  bitmap_cut(dst, src, first, n, nbits)       Cut n bits from first, copy rest
@@ -459,14 +453,6 @@ static inline void bitmap_replace(unsign
 		__bitmap_replace(dst, old, new, mask, nbits);
 }
 
-static inline void bitmap_next_clear_region(unsigned long *bitmap,
-					    unsigned int *rs, unsigned int *re,
-					    unsigned int end)
-{
-	*rs = find_next_zero_bit(bitmap, end, *rs);
-	*re = find_next_bit(bitmap, end, *rs + 1);
-}
-
 static inline void bitmap_next_set_region(unsigned long *bitmap,
 					  unsigned int *rs, unsigned int *re,
 					  unsigned int end)
@@ -475,25 +461,6 @@ static inline void bitmap_next_set_regio
 	*re = find_next_zero_bit(bitmap, end, *rs + 1);
 }
 
-/*
- * Bitmap region iterators.  Iterates over the bitmap between [@start, @end).
- * @rs and @re should be integer variables and will be set to start and end
- * index of the current clear or set region.
- */
-#define bitmap_for_each_clear_region(bitmap, rs, re, start, end)	     \
-	for ((rs) = (start),						     \
-	     bitmap_next_clear_region((bitmap), &(rs), &(re), (end));	     \
-	     (rs) < (re);						     \
-	     (rs) = (re) + 1,						     \
-	     bitmap_next_clear_region((bitmap), &(rs), &(re), (end)))
-
-#define bitmap_for_each_set_region(bitmap, rs, re, start, end)		     \
-	for ((rs) = (start),						     \
-	     bitmap_next_set_region((bitmap), &(rs), &(re), (end));	     \
-	     (rs) < (re);						     \
-	     (rs) = (re) + 1,						     \
-	     bitmap_next_set_region((bitmap), &(rs), &(re), (end)))
-
 /**
  * BITMAP_FROM_U64() - Represent u64 value in the format suitable for bitmap.
  * @n: u64 value
--- a/include/linux/find.h~bitmap-unify-find_bit-operations
+++ a/include/linux/find.h
@@ -302,6 +302,62 @@ unsigned long find_next_bit_le(const voi
 	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
 
 /**
+ * for_each_set_bitrange - iterate over all set bit ranges [b; e)
+ * @b: bit offset of start of current bitrange (first set bit)
+ * @e: bit offset of end of current bitrange (first unset bit)
+ * @addr: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ */
+#define for_each_set_bitrange(b, e, addr, size)			\
+	for ((b) = find_next_bit((addr), (size), 0),		\
+	     (e) = find_next_zero_bit((addr), (size), (b) + 1);	\
+	     (b) < (size);					\
+	     (b) = find_next_bit((addr), (size), (e) + 1),	\
+	     (e) = find_next_zero_bit((addr), (size), (b) + 1))
+
+/**
+ * for_each_set_bitrange_from - iterate over all set bit ranges [b; e)
+ * @b: bit offset of start of current bitrange (first set bit); must be initialized
+ * @e: bit offset of end of current bitrange (first unset bit)
+ * @addr: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ */
+#define for_each_set_bitrange_from(b, e, addr, size)		\
+	for ((b) = find_next_bit((addr), (size), (b)),		\
+	     (e) = find_next_zero_bit((addr), (size), (b) + 1);	\
+	     (b) < (size);					\
+	     (b) = find_next_bit((addr), (size), (e) + 1),	\
+	     (e) = find_next_zero_bit((addr), (size), (b) + 1))
+
+/**
+ * for_each_clear_bitrange - iterate over all unset bit ranges [b; e)
+ * @b: bit offset of start of current bitrange (first unset bit)
+ * @e: bit offset of end of current bitrange (first set bit)
+ * @addr: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ */
+#define for_each_clear_bitrange(b, e, addr, size)		\
+	for ((b) = find_next_zero_bit((addr), (size), 0),	\
+	     (e) = find_next_bit((addr), (size), (b) + 1);	\
+	     (b) < (size);					\
+	     (b) = find_next_zero_bit((addr), (size), (e) + 1),	\
+	     (e) = find_next_bit((addr), (size), (b) + 1))
+
+/**
+ * for_each_clear_bitrange_from - iterate over all unset bit ranges [b; e)
+ * @b: bit offset of start of current bitrange (first set bit); must be initialized
+ * @e: bit offset of end of current bitrange (first unset bit)
+ * @addr: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ */
+#define for_each_clear_bitrange_from(b, e, addr, size)		\
+	for ((b) = find_next_zero_bit((addr), (size), (b)),	\
+	     (e) = find_next_bit((addr), (size), (b) + 1);	\
+	     (b) < (size);					\
+	     (b) = find_next_zero_bit((addr), (size), (e) + 1),	\
+	     (e) = find_next_bit((addr), (size), (b) + 1))
+
+/**
  * for_each_set_clump8 - iterate over bitmap for each 8-bit clump with set bits
  * @start: bit offset to start search and to store the current iteration offset
  * @clump: location to store copy of current 8-bit clump
--- a/mm/percpu.c~bitmap-unify-find_bit-operations
+++ a/mm/percpu.c
@@ -779,7 +779,7 @@ static void pcpu_block_refresh_hint(stru
 {
 	struct pcpu_block_md *block = chunk->md_blocks + index;
 	unsigned long *alloc_map = pcpu_index_alloc_map(chunk, index);
-	unsigned int rs, re, start;	/* region start, region end */
+	unsigned int start, end;	/* region start, region end */
 
 	/* promote scan_hint to contig_hint */
 	if (block->scan_hint) {
@@ -795,9 +795,8 @@ static void pcpu_block_refresh_hint(stru
 	block->right_free = 0;
 
 	/* iterate over free areas and update the contig hints */
-	bitmap_for_each_clear_region(alloc_map, rs, re, start,
-				     PCPU_BITMAP_BLOCK_BITS)
-		pcpu_block_update(block, rs, re);
+	for_each_clear_bitrange_from(start, end, alloc_map, PCPU_BITMAP_BLOCK_BITS)
+		pcpu_block_update(block, start, end);
 }
 
 /**
@@ -1852,13 +1851,12 @@ area_found:
 
 	/* populate if not all pages are already there */
 	if (!is_atomic) {
-		unsigned int page_start, page_end, rs, re;
+		unsigned int page_end, rs, re;
 
-		page_start = PFN_DOWN(off);
+		rs = PFN_DOWN(off);
 		page_end = PFN_UP(off + size);
 
-		bitmap_for_each_clear_region(chunk->populated, rs, re,
-					     page_start, page_end) {
+		for_each_clear_bitrange_from(rs, re, chunk->populated, page_end) {
 			WARN_ON(chunk->immutable);
 
 			ret = pcpu_populate_chunk(chunk, rs, re, pcpu_gfp);
@@ -2014,8 +2012,7 @@ static void pcpu_balance_free(bool empty
 	list_for_each_entry_safe(chunk, next, &to_free, list) {
 		unsigned int rs, re;
 
-		bitmap_for_each_set_region(chunk->populated, rs, re, 0,
-					   chunk->nr_pages) {
+		for_each_set_bitrange(rs, re, chunk->populated, chunk->nr_pages) {
 			pcpu_depopulate_chunk(chunk, rs, re);
 			spin_lock_irq(&pcpu_lock);
 			pcpu_chunk_depopulated(chunk, rs, re);
@@ -2085,8 +2082,7 @@ retry_pop:
 			continue;
 
 		/* @chunk can't go away while pcpu_alloc_mutex is held */
-		bitmap_for_each_clear_region(chunk->populated, rs, re, 0,
-					     chunk->nr_pages) {
+		for_each_clear_bitrange(rs, re, chunk->populated, chunk->nr_pages) {
 			int nr = min_t(int, re - rs, nr_to_pop);
 
 			spin_unlock_irq(&pcpu_lock);
_
