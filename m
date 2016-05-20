From: akpm@linux-foundation.org
Subject: [patch 111/117] mm, page_alloc: inline pageblock lookup in page
 free fast paths
Date: Thu, 19 May 2016 17:14:27 -0700
Message-ID: <573e56e3.WbZTzRMPrgRcpWlr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETAO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: inline pageblock lookup in page free fast paths

The function call overhead of get_pfnblock_flags_mask() is measurable in
the page free paths.  This patch uses an inlined version that is faster.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -
 mm/page_alloc.c        |  188 ++++++++++++++++++++-------------------
 mm/page_owner.c        |    2 
 mm/vmstat.c            |    2 
 4 files changed, 102 insertions(+), 97 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths
+++ a/include/linux/mmzone.h
@@ -85,13 +85,6 @@ extern int page_group_by_mobility_disabl
 	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
 			PB_migrate_end, MIGRATETYPE_MASK)
 
-static inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
-{
-	BUILD_BUG_ON(PB_migrate_end - PB_migrate != 2);
-	return get_pfnblock_flags_mask(page, pfn, PB_migrate_end,
-					MIGRATETYPE_MASK);
-}
-
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
diff -puN mm/page_alloc.c~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths
+++ a/mm/page_alloc.c
@@ -352,6 +352,106 @@ static inline bool update_defer_init(pg_
 }
 #endif
 
+/* Return a pointer to the bitmap storing bits affecting a block of pages */
+static inline unsigned long *get_pageblock_bitmap(struct page *page,
+							unsigned long pfn)
+{
+#ifdef CONFIG_SPARSEMEM
+	return __pfn_to_section(pfn)->pageblock_flags;
+#else
+	return page_zone(page)->pageblock_flags;
+#endif /* CONFIG_SPARSEMEM */
+}
+
+static inline int pfn_to_bitidx(struct page *page, unsigned long pfn)
+{
+#ifdef CONFIG_SPARSEMEM
+	pfn &= (PAGES_PER_SECTION-1);
+	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
+#else
+	pfn = pfn - round_down(page_zone(page)->zone_start_pfn, pageblock_nr_pages);
+	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
+#endif /* CONFIG_SPARSEMEM */
+}
+
+/**
+ * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @end_bitidx: The last bit of interest to retrieve
+ * @mask: mask of bits that the caller is interested in
+ *
+ * Return: pageblock_bits flags
+ */
+static __always_inline unsigned long __get_pfnblock_flags_mask(struct page *page,
+					unsigned long pfn,
+					unsigned long end_bitidx,
+					unsigned long mask)
+{
+	unsigned long *bitmap;
+	unsigned long bitidx, word_bitidx;
+	unsigned long word;
+
+	bitmap = get_pageblock_bitmap(page, pfn);
+	bitidx = pfn_to_bitidx(page, pfn);
+	word_bitidx = bitidx / BITS_PER_LONG;
+	bitidx &= (BITS_PER_LONG-1);
+
+	word = bitmap[word_bitidx];
+	bitidx += end_bitidx;
+	return (word >> (BITS_PER_LONG - bitidx - 1)) & mask;
+}
+
+unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
+					unsigned long end_bitidx,
+					unsigned long mask)
+{
+	return __get_pfnblock_flags_mask(page, pfn, end_bitidx, mask);
+}
+
+static __always_inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
+{
+	return __get_pfnblock_flags_mask(page, pfn, PB_migrate_end, MIGRATETYPE_MASK);
+}
+
+/**
+ * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
+ * @page: The page within the block of interest
+ * @flags: The flags to set
+ * @pfn: The target page frame number
+ * @end_bitidx: The last bit of interest
+ * @mask: mask of bits that the caller is interested in
+ */
+void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
+					unsigned long pfn,
+					unsigned long end_bitidx,
+					unsigned long mask)
+{
+	unsigned long *bitmap;
+	unsigned long bitidx, word_bitidx;
+	unsigned long old_word, word;
+
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
+
+	bitmap = get_pageblock_bitmap(page, pfn);
+	bitidx = pfn_to_bitidx(page, pfn);
+	word_bitidx = bitidx / BITS_PER_LONG;
+	bitidx &= (BITS_PER_LONG-1);
+
+	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
+
+	bitidx += end_bitidx;
+	mask <<= (BITS_PER_LONG - bitidx - 1);
+	flags <<= (BITS_PER_LONG - bitidx - 1);
+
+	word = READ_ONCE(bitmap[word_bitidx]);
+	for (;;) {
+		old_word = cmpxchg(&bitmap[word_bitidx], word, (word & ~mask) | flags);
+		if (word == old_word)
+			break;
+		word = old_word;
+	}
+}
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
@@ -6787,94 +6887,6 @@ void *__init alloc_large_system_hash(con
 	return table;
 }
 
-/* Return a pointer to the bitmap storing bits affecting a block of pages */
-static inline unsigned long *get_pageblock_bitmap(struct page *page,
-							unsigned long pfn)
-{
-#ifdef CONFIG_SPARSEMEM
-	return __pfn_to_section(pfn)->pageblock_flags;
-#else
-	return page_zone(page)->pageblock_flags;
-#endif /* CONFIG_SPARSEMEM */
-}
-
-static inline int pfn_to_bitidx(struct page *page, unsigned long pfn)
-{
-#ifdef CONFIG_SPARSEMEM
-	pfn &= (PAGES_PER_SECTION-1);
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
-#else
-	pfn = pfn - round_down(page_zone(page)->zone_start_pfn, pageblock_nr_pages);
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
-#endif /* CONFIG_SPARSEMEM */
-}
-
-/**
- * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
- * @page: The page within the block of interest
- * @pfn: The target page frame number
- * @end_bitidx: The last bit of interest to retrieve
- * @mask: mask of bits that the caller is interested in
- *
- * Return: pageblock_bits flags
- */
-unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
-					unsigned long end_bitidx,
-					unsigned long mask)
-{
-	unsigned long *bitmap;
-	unsigned long bitidx, word_bitidx;
-	unsigned long word;
-
-	bitmap = get_pageblock_bitmap(page, pfn);
-	bitidx = pfn_to_bitidx(page, pfn);
-	word_bitidx = bitidx / BITS_PER_LONG;
-	bitidx &= (BITS_PER_LONG-1);
-
-	word = bitmap[word_bitidx];
-	bitidx += end_bitidx;
-	return (word >> (BITS_PER_LONG - bitidx - 1)) & mask;
-}
-
-/**
- * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
- * @page: The page within the block of interest
- * @flags: The flags to set
- * @pfn: The target page frame number
- * @end_bitidx: The last bit of interest
- * @mask: mask of bits that the caller is interested in
- */
-void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
-					unsigned long pfn,
-					unsigned long end_bitidx,
-					unsigned long mask)
-{
-	unsigned long *bitmap;
-	unsigned long bitidx, word_bitidx;
-	unsigned long old_word, word;
-
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-
-	bitmap = get_pageblock_bitmap(page, pfn);
-	bitidx = pfn_to_bitidx(page, pfn);
-	word_bitidx = bitidx / BITS_PER_LONG;
-	bitidx &= (BITS_PER_LONG-1);
-
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
-
-	bitidx += end_bitidx;
-	mask <<= (BITS_PER_LONG - bitidx - 1);
-	flags <<= (BITS_PER_LONG - bitidx - 1);
-
-	word = READ_ONCE(bitmap[word_bitidx]);
-	for (;;) {
-		old_word = cmpxchg(&bitmap[word_bitidx], word, (word & ~mask) | flags);
-		if (word == old_word)
-			break;
-		word = old_word;
-	}
-}
-
 /*
  * This function checks whether pageblock includes unmovable pages or not.
  * If @count is not zero, it is okay to include less @count unmovable pages
diff -puN mm/page_owner.c~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths mm/page_owner.c
--- a/mm/page_owner.c~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths
+++ a/mm/page_owner.c
@@ -143,7 +143,7 @@ print_page_owner(char __user *buf, size_
 		goto err;
 
 	/* Print information relevant to grouping pages by mobility */
-	pageblock_mt = get_pfnblock_migratetype(page, pfn);
+	pageblock_mt = get_pageblock_migratetype(page);
 	page_mt  = gfpflags_to_migratetype(page_ext->gfp_mask);
 	ret += snprintf(kbuf + ret, count - ret,
 			"PFN %lu type %s Block %lu type %s Flags %#lx(%pGp)\n",
diff -puN mm/vmstat.c~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths
+++ a/mm/vmstat.c
@@ -1041,7 +1041,7 @@ static void pagetypeinfo_showmixedcount_
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
 		page = pfn_to_page(pfn);
-		pageblock_mt = get_pfnblock_migratetype(page, pfn);
+		pageblock_mt = get_pageblock_migratetype(page);
 
 		for (; pfn < block_end_pfn; pfn++) {
 			if (!pfn_valid_within(pfn))
_
