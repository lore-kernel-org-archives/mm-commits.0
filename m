Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775C336C5A1
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027568; cv=none; b=EZl1rPWI3AztXAHDEYcW0zO1RLQW3XshO+tN6ESqWT84rq2yFIZ6wA536EF2ZD3dUF/SFNUK7XN/Cn7c1LHSbKHQLngaKeChI81+14g4tSQ+CK+r6Ulsi+i7Sc84VACPdjevWd7ucBfkk2jbNXeRxe8rZe5uP9ijByKKyOK7MHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027568; c=relaxed/simple;
	bh=5Mr9Z6H49AJK6GWQQHMVUJFTcVh9074WTgChENXKzS4=;
	h=Date:To:From:Subject:Message-Id; b=o/jFPP7/L6iUSyUmOH4NVIvS0Kc3e3QJedCo1dhs38TZZSGsTV4O/yseriQfB1mqEwmpwHEVFeaJMdQaCvVDs4Hk/zYVUt8XD7FhYuE0NFqflIFIy59nQ2V2+q3+cgmv3zuhsSx4dCwuLxWwqOKO3o+qWsduLBDUnWjAKPSsbJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zvmf1/78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zvmf1/78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0F11F00893;
	Fri, 29 May 2026 04:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027565;
	bh=UhclovXAY4phN5jsetNCtVob/+I2qxuw+Rig3ufYxf0=;
	h=Date:To:From:Subject;
	b=zvmf1/782iQJUB90urf3SZnTjB3pfgQn+nHruEh8LP3khZxEiH18KsUTxCS1Ci6FR
	 FKQ4teJvv+dav1pTE8Dl7kTFV3y/kF4m20uZAQ0xFZKciv9LRFLiFbwjAw2hEcbr/F
	 NCDgvknE5D4TsKadkoM9kcdPTp1XF9rizOUtnVYg=
Date: Thu, 28 May 2026 21:06:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@kernel.org,usama.anjum@arm.com,urezki@gmail.com,terrelln@fb.com,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-optimize-free_contig_range.patch removed from -mm tree
Message-Id: <20260529040605.CD0F11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: optimize free_contig_range()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-optimize-free_contig_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/page_alloc: optimize free_contig_range()
Date: Wed, 1 Apr 2026 11:16:19 +0100

Patch series "mm: Free contiguous order-0 pages efficiently", v6.

A recent change to vmalloc caused some performance benchmark regressions
(see [1]).  I'm attempting to fix that (and at the same time significantly
improve beyond the baseline) by freeing a contiguous set of order-0 pages
as a batch.

At the same time I observed that free_contig_range() was essentially doing
the same thing as vfree() so I've fixed it there too.  While at it,
optimize the __free_contig_frozen_range() as well.

Check that the contiguous range falls in the same section.  If they aren't
enabled, the if conditions get optimized out by the compiler as
memdesc_section() returns 0.  See num_pages_contiguous() for more details
about it.


This patch (of 3):

Decompose the range of order-0 pages to be freed into the set of largest
possible power-of-2 size and aligned chunks and free them to the pcp or
buddy.  This improves on the previous approach which freed each order-0
page individually in a loop.  Testing shows performance to be improved by
more than 10x in some cases.

Since each page is order-0, we must decrement each page's reference count
individually and only consider the page for freeing as part of a high
order chunk if the reference count goes to zero.  Additionally
free_pages_prepare() must be called for each individual order-0 page too,
so that the struct page state and global accounting state can be
appropriately managed.  But once this is done, the resulting high order
chunks can be freed as a unit to the pcp or buddy.

This significantly speeds up the free operation but also has the side
benefit that high order blocks are added to the pcp instead of each page
ending up on the pcp order-0 list; memory remains more readily available
in high orders.

vmalloc will shortly become a user of this new optimized
free_contig_range() since it aggressively allocates high order
non-compound pages, but then calls split_page() to end up with contiguous
order-0 pages.  These can now be freed much more efficiently.

The execution time of the following function was measured in a server
class arm64 machine:

static int page_alloc_high_order_test(void)
{
	unsigned int order = HPAGE_PMD_ORDER;
	struct page *page;
	int i;

	for (i = 0; i < 100000; i++) {
		page = alloc_pages(GFP_KERNEL, order);
		if (!page)
			return -1;
		split_page(page, order);
		free_contig_range(page_to_pfn(page), 1UL << order);
	}

	return 0;
}

Execution time before: 4097358 usec
Execution time after:   729831 usec

Perf trace before:

    99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
            |
            ---kthread
               0xffffb33c12a26af8
               |
               |--98.13%--0xffffb33c12a26060
               |          |
               |          |--97.37%--free_contig_range
               |          |          |
               |          |          |--94.93%--___free_pages
               |          |          |          |
               |          |          |          |--55.42%--__free_frozen_pages
               |          |          |          |          |
               |          |          |          |           --43.20%--free_frozen_page_commit
               |          |          |          |                     |
               |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
               |          |          |          |
               |          |          |          |--11.53%--_raw_spin_trylock
               |          |          |          |
               |          |          |          |--8.19%--__preempt_count_dec_and_test
               |          |          |          |
               |          |          |          |--5.64%--_raw_spin_unlock
               |          |          |          |
               |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
               |          |          |          |
               |          |          |           --1.07%--free_frozen_page_commit
               |          |          |
               |          |           --1.54%--__free_frozen_pages
               |          |
               |           --0.77%--___free_pages
               |
                --0.98%--0xffffb33c12a26078
                          alloc_pages_noprof

Perf trace after:

     8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
            |
            |--5.52%--__free_contig_range
            |          |
            |          |--5.00%--free_prepared_contig_range
            |          |          |
            |          |          |--1.43%--__free_frozen_pages
            |          |          |          |
            |          |          |           --0.51%--free_frozen_page_commit
            |          |          |
            |          |          |--1.08%--_raw_spin_trylock
            |          |          |
            |          |           --0.89%--_raw_spin_unlock
            |          |
            |           --0.52%--free_pages_prepare
            |
             --2.90%--ret_from_fork
                       kthread
                       0xffffae1c12abeaf8
                       0xffffae1c12abe7a0
                       |
                        --2.69%--vfree
                                  __free_contig_range

Link: https://lore.kernel.org/20260401101634.2868165-1-usama.anjum@arm.com
Link: https://lore.kernel.org/20260401101634.2868165-2-usama.anjum@arm.com
Link: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com [1]
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 
 mm/page_alloc.c     |  112 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 110 insertions(+), 4 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-optimize-free_contig_range
+++ a/include/linux/gfp.h
@@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned l
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
+void __free_contig_range(unsigned long pfn, unsigned long nr_pages);
+
 DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
 
 #endif /* __LINUX_GFP_H */
--- a/mm/page_alloc.c~mm-page_alloc-optimize-free_contig_range
+++ a/mm/page_alloc.c
@@ -90,6 +90,9 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/* free_pages_prepare() has already been called for page(s) being freed. */
+#define FPI_PREPARED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1307,8 +1310,8 @@ static inline void pgalloc_tag_sub_pages
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-__always_inline bool __free_pages_prepare(struct page *page,
-					  unsigned int order, fpi_t fpi_flags)
+static __always_inline bool __free_pages_prepare(struct page *page,
+		unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page);
@@ -1316,6 +1319,9 @@ __always_inline bool __free_pages_prepar
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
+	if (fpi_flags & FPI_PREPARED)
+		return true;
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	trace_mm_page_free(page, order);
@@ -6762,6 +6768,105 @@ void __init page_alloc_sysctl_init(void)
 	register_sysctl_init("vm", page_alloc_sysctl_table);
 }
 
+static void free_prepared_contig_range(struct page *page,
+		unsigned long nr_pages)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	while (nr_pages) {
+		unsigned int order;
+
+		/* We are limited by the largest buddy order. */
+		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
+		/* Don't exceed the number of pages to free. */
+		order = min_t(unsigned int, order, ilog2(nr_pages));
+		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
+
+		/*
+		 * Free the chunk as a single block. Our caller has already
+		 * called free_pages_prepare() for each order-0 page.
+		 */
+		__free_frozen_pages(page, order, FPI_PREPARED);
+
+		pfn += 1UL << order;
+		page += 1UL << order;
+		nr_pages -= 1UL << order;
+	}
+}
+
+static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
+		bool is_frozen)
+{
+	struct page *page, *start = NULL;
+	unsigned long nr_start = 0;
+	unsigned long start_sec;
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++) {
+		bool can_free = true;
+
+		/*
+		 * Contiguous PFNs might not have contiguous "struct pages"
+		 * in some kernel configs: page++ across a section boundary
+		 * is undefined. Use pfn_to_page() for each PFN.
+		 */
+		page = pfn_to_page(pfn + i);
+
+		VM_WARN_ON_ONCE(PageHead(page));
+		VM_WARN_ON_ONCE(PageTail(page));
+
+		if (!is_frozen)
+			can_free = put_page_testzero(page);
+
+		if (can_free)
+			can_free = free_pages_prepare(page, 0);
+
+		if (!can_free) {
+			if (start) {
+				free_prepared_contig_range(start, i - nr_start);
+				start = NULL;
+			}
+			continue;
+		}
+
+		if (start && memdesc_section(page->flags) != start_sec) {
+			free_prepared_contig_range(start, i - nr_start);
+			start = page;
+			nr_start = i;
+			start_sec = memdesc_section(page->flags);
+		} else if (!start) {
+			start = page;
+			nr_start = i;
+			start_sec = memdesc_section(page->flags);
+		}
+	}
+
+	if (start)
+		free_prepared_contig_range(start, nr_pages - nr_start);
+}
+
+/**
+ * __free_contig_range - Free contiguous range of order-0 pages.
+ * @pfn: Page frame number of the first page in the range.
+ * @nr_pages: Number of pages to free.
+ *
+ * For each order-0 struct page in the physically contiguous range, put a
+ * reference. Free any page who's reference count falls to zero. The
+ * implementation is functionally equivalent to, but significantly faster than
+ * calling __free_page() for each struct page in a loop.
+ *
+ * Memory allocated with alloc_pages(order>=1) then subsequently split to
+ * order-0 with split_page() is an example of appropriate contiguous pages that
+ * can be freed with this API.
+ *
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
+void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
@@ -7308,8 +7413,7 @@ void free_contig_range(unsigned long pfn
 	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
 		return;
 
-	for (; nr_pages--; pfn++)
-		__free_page(pfn_to_page(pfn));
+	__free_contig_range(pfn, nr_pages);
 }
 EXPORT_SYMBOL(free_contig_range);
 #endif /* CONFIG_CONTIG_ALLOC */
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


