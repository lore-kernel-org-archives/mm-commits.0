Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E267113AA2F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 02:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750126801; cv=none; b=jf7zzygTHxtjpeSiI0KJyy4lTiDUxT1ixYLTJKTVAQ3h6lgvrfdQJ1G/eNKRMB8SWnoY2JnA6DbjMhvig6uZ812qwi68Z6urLEEZGeDbj7bFD0szabOI0Z/F6Haix+28r0Bk3/ZoqkwpRWsBmUmPY3t3sgIC+DnG4YF4BgG7nDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750126801; c=relaxed/simple;
	bh=nUrO7f6vTGuYwk96spWAfPmVcOVQ48toGvpBGUUUR7o=;
	h=Date:To:From:Subject:Message-Id; b=GzLeteYZvKeKo0jtZAm50yO+JA36ocpsZeZ+C1zVBI46mmr+4TRwmSS9+ZNfzeY+RhJzSN3QjCHuSpPHn5Wprtqc5XvPbpYDi4inpdTUBcvzomYwkMb4tAlsditf+hsycFZJnFOAtnQ8Sxlsari5UcgDgt2y3o1GC17Z3GxOZqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/qlI0IT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/qlI0IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58391C4CEEA;
	Tue, 17 Jun 2025 02:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750126800;
	bh=nUrO7f6vTGuYwk96spWAfPmVcOVQ48toGvpBGUUUR7o=;
	h=Date:To:From:Subject:From;
	b=F/qlI0ITpkUWhMYs6zuf5fPdmbDrOampz/1J2pVh2XqoDt1v1o+vLvunXlCMI7Txh
	 b1Il3+Fpxb5YoXFkpnFo3X5i7Xb+iFx5+S4oUW+R0Mf5u7lcGqgbymG0aPuDiqcFMI
	 mdrgiyGhj/C/u96jA7QF9gJerYMOeqKc5FWTO2fw=
Date: Mon, 16 Jun 2025 19:19:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-pageblock-flags-functions-clean-up.patch added to mm-new branch
Message-Id: <20250617022000.58391C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: pageblock flags functions clean up
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-pageblock-flags-functions-clean-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-pageblock-flags-functions-clean-up.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: pageblock flags functions clean up
Date: Mon, 16 Jun 2025 22:11:09 -0400

Patch series "Make MIGRATE_ISOLATE a standalone bit", v10.

This patchset moves MIGRATE_ISOLATE to a standalone bit to avoid being
overwritten during pageblock isolation process.  Currently,
MIGRATE_ISOLATE is part of enum migratetype (in include/linux/mmzone.h),
thus, setting a pageblock to MIGRATE_ISOLATE overwrites its original
migratetype.  This causes pageblock migratetype loss during
alloc_contig_range() and memory offline, especially when the process fails
due to a failed pageblock isolation and the code tries to undo the
finished pageblock isolations.

In terms of performance for changing pageblock types, no performance
change is observed:

1. I used perf to collect stats of offlining and onlining all memory
   of a 40GB VM 10 times and see that get_pfnblock_flags_mask() and
   set_pfnblock_flags_mask() take about 0.12% and 0.02% of the whole
   process respectively with and without this patchset across 3 runs.

2. I used perf to collect stats of dd from /dev/random to a 40GB tmpfs
   file and find get_pfnblock_flags_mask() takes about 0.05% of the
   process with and without this patchset across 3 runs.


This patch (of 6):

No functional change is intended.

1. Add __NR_PAGEBLOCK_BITS for the number of pageblock flag bits and use
   roundup_pow_of_two(__NR_PAGEBLOCK_BITS) as NR_PAGEBLOCK_BITS to take
   right amount of bits for pageblock flags.
2. Rename PB_migrate_skip to PB_compact_skip.
3. Add {get,set,clear}_pfnblock_bit() to operate one a standalone bit,
   like PB_compact_skip.
3. Make {get,set}_pfnblock_flags_mask() internal functions and use
   {get,set}_pfnblock_migratetype() for pageblock migratetype operations.
4. Move pageblock flags common code to get_pfnblock_bitmap_bitidx().
3. Use MIGRATETYPE_MASK to get the migratetype of a pageblock from its
   flags.
4. Use PB_migrate_end in the definition of MIGRATETYPE_MASK instead of
   PB_migrate_bits.
5. Add a comment on is_migrate_cma_folio() to prevent one from changing it
   to use get_pageblock_migratetype() and causing issues.

Link: https://lkml.kernel.org/r/20250617021115.2331563-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250617021115.2331563-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    2 
 include/linux/mmzone.h               |   18 +-
 include/linux/page-isolation.h       |    2 
 include/linux/pageblock-flags.h      |   34 ++--
 mm/memory_hotplug.c                  |    2 
 mm/page_alloc.c                      |  171 +++++++++++++++++++------
 6 files changed, 162 insertions(+), 67 deletions(-)

--- a/Documentation/mm/physical_memory.rst~mm-page_alloc-pageblock-flags-functions-clean-up
+++ a/Documentation/mm/physical_memory.rst
@@ -584,7 +584,7 @@ Compaction control
 
 ``compact_blockskip_flush``
   Set to true when compaction migration scanner and free scanner meet, which
-  means the ``PB_migrate_skip`` bits should be cleared.
+  means the ``PB_compact_skip`` bits should be cleared.
 
 ``contiguous``
   Set to true when the zone is contiguous (in other words, no hole).
--- a/include/linux/mmzone.h~mm-page_alloc-pageblock-flags-functions-clean-up
+++ a/include/linux/mmzone.h
@@ -92,8 +92,12 @@ extern const char * const migratetype_na
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #  define is_migrate_cma_page(_page) (get_pageblock_migratetype(_page) == MIGRATE_CMA)
-#  define is_migrate_cma_folio(folio, pfn)	(MIGRATE_CMA ==		\
-	get_pfnblock_flags_mask(&folio->page, pfn, MIGRATETYPE_MASK))
+/*
+ * __dump_folio() in mm/debug.c passes a folio pointer to on-stack struct folio,
+ * so folio_pfn() cannot be used and pfn is needed.
+ */
+#  define is_migrate_cma_folio(folio, pfn) \
+	(get_pfnblock_migratetype(&folio->page, pfn) == MIGRATE_CMA)
 #else
 #  define is_migrate_cma(migratetype) false
 #  define is_migrate_cma_page(_page) false
@@ -122,14 +126,12 @@ static inline bool migratetype_is_mergea
 
 extern int page_group_by_mobility_disabled;
 
-#define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
+#define get_pageblock_migratetype(page) \
+	get_pfnblock_migratetype(page, page_to_pfn(page))
 
-#define get_pageblock_migratetype(page)					\
-	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
+#define folio_migratetype(folio) \
+	get_pageblock_migratetype(&folio->page)
 
-#define folio_migratetype(folio)				\
-	get_pfnblock_flags_mask(&folio->page, folio_pfn(folio),		\
-			MIGRATETYPE_MASK)
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
--- a/include/linux/pageblock-flags.h~mm-page_alloc-pageblock-flags-functions-clean-up
+++ a/include/linux/pageblock-flags.h
@@ -19,15 +19,19 @@ enum pageblock_bits {
 	PB_migrate,
 	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
 			/* 3 bits required for migrate types */
-	PB_migrate_skip,/* If set the block is skipped by compaction */
+	PB_compact_skip,/* If set the block is skipped by compaction */
 
 	/*
 	 * Assume the bits will always align on a word. If this assumption
 	 * changes then get/set pageblock needs updating.
 	 */
-	NR_PAGEBLOCK_BITS
+	__NR_PAGEBLOCK_BITS
 };
 
+#define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
+
+#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -65,27 +69,23 @@ extern unsigned int pageblock_order;
 /* Forward declaration */
 struct page;
 
-unsigned long get_pfnblock_flags_mask(const struct page *page,
-				unsigned long pfn,
-				unsigned long mask);
-
-void set_pfnblock_flags_mask(struct page *page,
-				unsigned long flags,
-				unsigned long pfn,
-				unsigned long mask);
+enum migratetype get_pfnblock_migratetype(const struct page *page,
+					  unsigned long pfn);
+bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
+		      enum pageblock_bits pb_bit);
+void set_pfnblock_bit(const struct page *page, unsigned long pfn,
+		      enum pageblock_bits pb_bit);
+void clear_pfnblock_bit(const struct page *page, unsigned long pfn,
+			enum pageblock_bits pb_bit);
 
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
-	get_pfnblock_flags_mask(page, page_to_pfn(page),	\
-			(1 << (PB_migrate_skip)))
+	get_pfnblock_bit(page, page_to_pfn(page), PB_compact_skip)
 #define clear_pageblock_skip(page) \
-	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),	\
-			(1 << PB_migrate_skip))
+	clear_pfnblock_bit(page, page_to_pfn(page), PB_compact_skip)
 #define set_pageblock_skip(page) \
-	set_pfnblock_flags_mask(page, (1 << PB_migrate_skip),	\
-			page_to_pfn(page),			\
-			(1 << PB_migrate_skip))
+	set_pfnblock_bit(page, page_to_pfn(page), PB_compact_skip)
 #else
 static inline bool get_pageblock_skip(struct page *page)
 {
--- a/include/linux/page-isolation.h~mm-page_alloc-pageblock-flags-functions-clean-up
+++ a/include/linux/page-isolation.h
@@ -25,7 +25,7 @@ static inline bool is_migrate_isolate(in
 #define MEMORY_OFFLINE	0x1
 #define REPORT_FAILURE	0x2
 
-void set_pageblock_migratetype(struct page *page, int migratetype);
+void set_pageblock_migratetype(struct page *page, enum migratetype migratetype);
 
 bool move_freepages_block_isolate(struct zone *zone, struct page *page,
 				  int migratetype);
--- a/mm/memory_hotplug.c~mm-page_alloc-pageblock-flags-functions-clean-up
+++ a/mm/memory_hotplug.c
@@ -774,7 +774,7 @@ void move_pfn_range_to_zone(struct zone
 
 	/*
 	 * TODO now we have a visible range of pages which are not associated
-	 * with their zone properly. Not nice but set_pfnblock_flags_mask
+	 * with their zone properly. Not nice but set_pfnblock_migratetype()
 	 * expects the zone spans the pfn range. All the pages in the range
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
--- a/mm/page_alloc.c~mm-page_alloc-pageblock-flags-functions-clean-up
+++ a/mm/page_alloc.c
@@ -353,81 +353,174 @@ static inline int pfn_to_bitidx(const st
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 }
 
+static __always_inline bool is_standalone_pb_bit(enum pageblock_bits pb_bit)
+{
+	return pb_bit > PB_migrate_end && pb_bit < __NR_PAGEBLOCK_BITS;
+}
+
+static __always_inline void
+get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
+			   unsigned long **bitmap_word, unsigned long *bitidx)
+{
+	unsigned long *bitmap;
+	unsigned long word_bitidx;
+
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
+	BUILD_BUG_ON(MIGRATE_TYPES > (1 << PB_migratetype_bits));
+	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
+
+	bitmap = get_pageblock_bitmap(page, pfn);
+	*bitidx = pfn_to_bitidx(page, pfn);
+	word_bitidx = *bitidx / BITS_PER_LONG;
+	*bitidx &= (BITS_PER_LONG - 1);
+	*bitmap_word = &bitmap[word_bitidx];
+}
+
+
 /**
- * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
+ * __get_pfnblock_flags_mask - Return the requested group of flags for
+ * a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
  * @pfn: The target page frame number
  * @mask: mask of bits that the caller is interested in
  *
  * Return: pageblock_bits flags
  */
-unsigned long get_pfnblock_flags_mask(const struct page *page,
-					unsigned long pfn, unsigned long mask)
+static unsigned long __get_pfnblock_flags_mask(const struct page *page,
+					       unsigned long pfn,
+					       unsigned long mask)
 {
-	unsigned long *bitmap;
-	unsigned long bitidx, word_bitidx;
+	unsigned long *bitmap_word;
+	unsigned long bitidx;
 	unsigned long word;
 
-	bitmap = get_pageblock_bitmap(page, pfn);
-	bitidx = pfn_to_bitidx(page, pfn);
-	word_bitidx = bitidx / BITS_PER_LONG;
-	bitidx &= (BITS_PER_LONG-1);
+	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
 	/*
-	 * This races, without locks, with set_pfnblock_flags_mask(). Ensure
+	 * This races, without locks, with set_pfnblock_migratetype(). Ensure
 	 * a consistent read of the memory array, so that results, even though
 	 * racy, are not corrupted.
 	 */
-	word = READ_ONCE(bitmap[word_bitidx]);
+	word = READ_ONCE(*bitmap_word);
 	return (word >> bitidx) & mask;
 }
 
-static __always_inline int get_pfnblock_migratetype(const struct page *page,
-					unsigned long pfn)
+/**
+ * get_pfnblock_bit - Check if a standalone bit of a pageblock is set
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @pb_bit: pageblock bit to check
+ *
+ * Return: true if the bit is set, otherwise false
+ */
+bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
+		      enum pageblock_bits pb_bit)
 {
-	return get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
+	unsigned long *bitmap_word;
+	unsigned long bitidx;
+
+	if (WARN_ON_ONCE(!is_standalone_pb_bit(pb_bit)))
+		return false;
+
+	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
+
+	return test_bit(bitidx + pb_bit, bitmap_word);
 }
 
 /**
- * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
+ * get_pfnblock_migratetype - Return the migratetype of a pageblock
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ *
+ * Return: The migratetype of the pageblock
+ *
+ * Use get_pfnblock_migratetype() if caller already has both @page and @pfn
+ * to save a call to page_to_pfn().
+ */
+__always_inline enum migratetype
+get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
+{
+	return __get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
+}
+
+/**
+ * __set_pfnblock_flags_mask - Set the requested group of flags for
+ * a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
- * @flags: The flags to set
  * @pfn: The target page frame number
+ * @flags: The flags to set
  * @mask: mask of bits that the caller is interested in
  */
-void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
-					unsigned long pfn,
-					unsigned long mask)
+static void __set_pfnblock_flags_mask(struct page *page, unsigned long pfn,
+				      unsigned long flags, unsigned long mask)
 {
-	unsigned long *bitmap;
-	unsigned long bitidx, word_bitidx;
+	unsigned long *bitmap_word;
+	unsigned long bitidx;
 	unsigned long word;
 
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-	BUILD_BUG_ON(MIGRATE_TYPES > (1 << PB_migratetype_bits));
-
-	bitmap = get_pageblock_bitmap(page, pfn);
-	bitidx = pfn_to_bitidx(page, pfn);
-	word_bitidx = bitidx / BITS_PER_LONG;
-	bitidx &= (BITS_PER_LONG-1);
-
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
+	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
 
 	mask <<= bitidx;
 	flags <<= bitidx;
 
-	word = READ_ONCE(bitmap[word_bitidx]);
+	word = READ_ONCE(*bitmap_word);
 	do {
-	} while (!try_cmpxchg(&bitmap[word_bitidx], &word, (word & ~mask) | flags));
+	} while (!try_cmpxchg(bitmap_word, &word, (word & ~mask) | flags));
+}
+
+/**
+ * set_pfnblock_bit - Set a standalone bit of a pageblock
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @pb_bit: pageblock bit to set
+ */
+void set_pfnblock_bit(const struct page *page, unsigned long pfn,
+		      enum pageblock_bits pb_bit)
+{
+	unsigned long *bitmap_word;
+	unsigned long bitidx;
+
+	if (WARN_ON_ONCE(!is_standalone_pb_bit(pb_bit)))
+		return;
+
+	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
+
+	set_bit(bitidx + pb_bit, bitmap_word);
 }
 
-void set_pageblock_migratetype(struct page *page, int migratetype)
+/**
+ * clear_pfnblock_bit - Clear a standalone bit of a pageblock
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @pb_bit: pageblock bit to clear
+ */
+void clear_pfnblock_bit(const struct page *page, unsigned long pfn,
+			enum pageblock_bits pb_bit)
+{
+	unsigned long *bitmap_word;
+	unsigned long bitidx;
+
+	if (WARN_ON_ONCE(!is_standalone_pb_bit(pb_bit)))
+		return;
+
+	get_pfnblock_bitmap_bitidx(page, pfn, &bitmap_word, &bitidx);
+
+	clear_bit(bitidx + pb_bit, bitmap_word);
+}
+
+/**
+ * set_pageblock_migratetype - Set the migratetype of a pageblock
+ * @page: The page within the block of interest
+ * @migratetype: migratetype to set
+ */
+__always_inline void set_pageblock_migratetype(struct page *page,
+					       enum migratetype migratetype)
 {
 	if (unlikely(page_group_by_mobility_disabled &&
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
-	set_pfnblock_flags_mask(page, (unsigned long)migratetype,
-				page_to_pfn(page), MIGRATETYPE_MASK);
+	__set_pfnblock_flags_mask(page, page_to_pfn(page),
+				  (unsigned long)migratetype, MIGRATETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -667,7 +760,7 @@ static inline void __add_to_free_list(st
 	int nr_pages = 1 << order;
 
 	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
-		     "page type is %lu, passed migratetype is %d (nr=%d)\n",
+		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
 	if (tail)
@@ -693,7 +786,7 @@ static inline void move_to_free_list(str
 
 	/* Free page moving can fail, so it happens before the type update */
 	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt,
-		     "page type is %lu, passed migratetype is %d (nr=%d)\n",
+		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), old_mt, nr_pages);
 
 	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
@@ -715,7 +808,7 @@ static inline void __del_page_from_free_
 	int nr_pages = 1 << order;
 
         VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
-		     "page type is %lu, passed migratetype is %d (nr=%d)\n",
+		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
 	/* clear reported state and update reported page count */
@@ -3123,7 +3216,7 @@ static struct page *rmqueue_pcplist(stru
 
 /*
  * Do not instrument rmqueue() with KMSAN. This function may call
- * __msan_poison_alloca() through a call to set_pfnblock_flags_mask().
+ * __msan_poison_alloca() through a call to set_pfnblock_migratetype().
  * If __msan_poison_alloca() attempts to allocate pages for the stack depot, it
  * may call rmqueue() again, which will result in a deadlock.
  */
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rename-config_page_block_order-to-config_page_block_max_order.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

