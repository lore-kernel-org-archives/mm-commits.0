Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B9B22576E
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027569; cv=none; b=ml+HZ/6pq6vAwAqW/lLJZ3wo7fojytIbuYggvNam1o8KfiBMppywNG+5TbKy8dSKgGKMQR4J4vA0GxxQIrN6ZME1nIh5n2MDKpvK9a36a5wAvT03oi0QvFE85daZWpJUpkJPC7QGwkB/xMVLSha9gGz7avZ6nQj1CESo/poZbuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027569; c=relaxed/simple;
	bh=bvdMhmeYiVeY92iSMU0Rd7wQkKIe5ZS+WrRUJrdXxnA=;
	h=Date:To:From:Subject:Message-Id; b=Wbahu8CVNXV3xzByY4YGMOrf1QZPUNiyvMeRjO7KuHbsFcQqL2X+lNXHEJpvMK+FNM3JwLevYxTiHUvWJR7c2uFGMuGTv8zbcqAIvjizHnP40zAo6uRpLUK1nlIa9hoCkhZvIXfqiOkklPUeGUysKeb1iX8aDe6B+OOf4kYVAPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OulBB+Z2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OulBB+Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312D61F00898;
	Fri, 29 May 2026 04:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027567;
	bh=4DUMbFYTB5nTx1GRJGL/Q5lCjyCtVQ6sD1ANase0W0A=;
	h=Date:To:From:Subject;
	b=OulBB+Z2YpDkI1NXexfHbHTHGzxz/0Z5TQFhoCZgGNZoSHGq0e1lv6vVN5ZRjPLIi
	 lXg/3TkUPahuNKqQynd8cvjsInFD83yH+6rPEeqMLfXT6Lob2Lt5nWPrsyfsNXGpzq
	 jTRSKx4TwRkUSacYqZtl5CJKavbX/9yMoJSG2dEE=
Date: Thu, 28 May 2026 21:06:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@kernel.org,usama.anjum@arm.com,urezki@gmail.com,terrelln@fb.com,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-optimize-vfree-with-free_pages_bulk.patch removed from -mm tree
Message-Id: <20260529040607.312D61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: optimize vfree with free_pages_bulk()
has been removed from the -mm tree.  Its filename was
     vmalloc-optimize-vfree-with-free_pages_bulk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: vmalloc: optimize vfree with free_pages_bulk()
Date: Wed, 1 Apr 2026 11:16:20 +0100

Whenever vmalloc allocates high order pages (e.g.  for a huge mapping) it
must immediately split_page() to order-0 so that it remains compatible
with users that want to access the underlying struct page.  Commit
a06157804399 ("mm/vmalloc: request large order pages from buddy
allocator") recently made it much more likely for vmalloc to allocate high
order pages which are subsequently split to order-0.

Unfortunately this had the side effect of causing performance regressions
for tight vmalloc/vfree loops (e.g.  test_vmalloc.ko benchmarks).  See
Closes: tag.  This happens because the high order pages must be gotten
from the buddy but then because they are split to order-0, when they are
freed they are freed to the order-0 pcp.  Previously allocation was for
order-0 pages so they were recycled from the pcp.

It would be preferable if when vmalloc allocates an (e.g.) order-3 page
that it also frees that order-3 page to the order-3 pcp, then the
regression could be removed.

So let's do exactly that; update stats separately first as coalescing is
hard to do correctly without complexity.  Use free_pages_bulk() which uses
the new __free_contig_range() API to batch-free contiguous ranges of pfns.
This not only removes the regression, but significantly improves
performance of vfree beyond the baseline.

A selection of test_vmalloc benchmarks running on arm64 server class
system.  mm-new is the baseline.  Commit a06157804399 ("mm/vmalloc:
request large order pages from buddy allocator") was added in v6.19-rc1
where we see regressions.  Then with this change performance is much
better.  (>0 is faster, <0 is slower, (R)/(I) = statistically significant
Regression/Improvement):

+-----------------+----------------------------------------------------------+-------------------+--------------------+
| Benchmark       | Result Class                                             |   mm-new          |  this series       |
+=================+==========================================================+===================+====================+
| micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
|                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
|                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
|                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
|                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
|                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
|                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
|                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
|                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
|                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
|                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
|                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
+-----------------+----------------------------------------------------------+-------------------+--------------------+

Link: https://lore.kernel.org/20260401101634.2868165-3-usama.anjum@arm.com
Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 mm/page_alloc.c     |   28 ++++++++++++++++++++++++++++
 mm/vmalloc.c        |   16 +++++-----------
 3 files changed, 35 insertions(+), 11 deletions(-)

--- a/include/linux/gfp.h~vmalloc-optimize-vfree-with-free_pages_bulk
+++ a/include/linux/gfp.h
@@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 				struct page **page_array);
 #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
 
+void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
+
 unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
 				unsigned long nr_pages,
 				struct page **page_array);
--- a/mm/page_alloc.c~vmalloc-optimize-vfree-with-free_pages_bulk
+++ a/mm/page_alloc.c
@@ -5190,6 +5190,34 @@ failed:
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
 /*
+ * free_pages_bulk - Free an array of order-0 pages
+ * @page_array: Array of pages to free
+ * @nr_pages: The number of pages in the array
+ *
+ * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
+ * run are released with a single __free_contig_range() call.
+ *
+ * This assumes page_array is sorted in ascending PFN order. Without that,
+ * the function still frees all pages, but contiguous runs may not be
+ * detected and the freeing pattern can degrade to freeing one page at a
+ * time.
+ *
+ * Context: Sleepable process context only; calls cond_resched()
+ */
+void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
+{
+	while (nr_pages) {
+		unsigned long nr_contig = num_pages_contiguous(page_array, nr_pages);
+
+		__free_contig_range(page_to_pfn(*page_array), nr_contig);
+
+		nr_pages -= nr_contig;
+		page_array += nr_contig;
+		cond_resched();
+	}
+}
+
+/*
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
--- a/mm/vmalloc.c~vmalloc-optimize-vfree-with-free_pages_bulk
+++ a/mm/vmalloc.c
@@ -3459,19 +3459,13 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
 
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			mod_lruvec_page_state(page, NR_VMALLOC, -1);
-		__free_page(page);
-		cond_resched();
+	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
+		for (i = 0; i < vm->nr_pages; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
 	}
+	free_pages_bulk(vm->pages, vm->nr_pages);
+
 	kvfree(vm->pages);
 	kfree(vm);
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


