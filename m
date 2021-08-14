Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67690C4320A
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5AC60F51
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhHNWST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233549AbhHNWSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9662C60EE0;
        Sat, 14 Aug 2021 22:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979469;
        bh=XbKIv5X/OmblemqqLRe1cW+c7LodZin0qKUn2xr7Eg0=;
        h=Date:From:To:Subject:From;
        b=X2V4+xE9mF1p0AEQFsHsw5UzhO5rBpokUU0OQIJkHhpU0PhQSwll4yyMZBrxbiOV3
         W/0imGsftced0kVsFYBSzFE+Qz1JbeWwFNXmzz/ajrz+VbrWdSrIYHi7xCejJfou79
         9gWNJSL+bA8Tqx4j3+HPW0ZD+fPH4Qal4EXttAzg=
Date:   Sat, 14 Aug 2021 15:17:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + bitmap-unify-find_bit-operations.patch added to -mm tree
Message-ID: <20210814221749.G7Fmi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: unify find_bit operations
has been added to the -mm tree.  Its filename is
     bitmap-unify-find_bit-operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitmap-unify-find_bit-operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitmap-unify-find_bit-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: kernel test robot <lkp@intel.com>
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
@@ -1855,13 +1854,12 @@ area_found:
 
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
@@ -2017,8 +2015,7 @@ static void pcpu_balance_free(bool empty
 	list_for_each_entry_safe(chunk, next, &to_free, list) {
 		unsigned int rs, re;
 
-		bitmap_for_each_set_region(chunk->populated, rs, re, 0,
-					   chunk->nr_pages) {
+		for_each_set_bitrange(rs, re, chunk->populated, chunk->nr_pages) {
 			pcpu_depopulate_chunk(chunk, rs, re);
 			spin_lock_irq(&pcpu_lock);
 			pcpu_chunk_depopulated(chunk, rs, re);
@@ -2088,8 +2085,7 @@ retry_pop:
 			continue;
 
 		/* @chunk can't go away while pcpu_alloc_mutex is held */
-		bitmap_for_each_clear_region(chunk->populated, rs, re, 0,
-					     chunk->nr_pages) {
+		for_each_clear_bitrange(rs, re, chunk->populated, chunk->nr_pages) {
 			int nr = min_t(int, re - rs, nr_to_pop);
 
 			spin_unlock_irq(&pcpu_lock);
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

