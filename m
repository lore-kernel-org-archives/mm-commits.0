Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29BB1A9F8C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334157; cv=none; b=E8qahvtOLasT/KvbO7dCFAroVN1ikgHX5DJcfJEiiaUKaQzL6U+fS23nld3KtWN3ForBW5nW5ybDV9qgtmNoXOhDx/Qy8QlPYduuzmExl4bY5JM/Q08yn84q2triIkNHsUxNsNJxrwQGUxRAxvDOKwVbPb1GOxpeKVa4FtdSWys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334157; c=relaxed/simple;
	bh=KUVWLKG/jzWQLA678BG+9EPc7ynJ84blYk1NnQO0yWI=;
	h=Date:To:From:Subject:Message-Id; b=ZFlPzA0Jb9F4si/T3CS13jMSntwcHLHXHh8zkM3g4XHQ8HjjKLZ1S+GcGnqJGnmTnh53b3CljjcYNIyvRYE8G8SK0Ho5zCJDH3BO6sl9SLx1XH6J3L9nD9L/bOunCYHc02rZ58LH4qbN1r2xsPJfRvF1Hx6mIz/c74CQBdcNafM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6vZudXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6vZudXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593931F0089B;
	Wed,  7 Oct 2026 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334156;
	bh=xbJXnMihAma8FrOVzSAlEIDdyzjivP3TA4Z6qYVx77Q=;
	h=Date:To:From:Subject;
	b=R6vZudXnuJ9tjdtAnZTPMMTcHyaDE8InQWNOJQpKs4Yr/9mBn2ZonDGv9QTGHsh2q
	 +vS/r0m3W3/h7/OYlMEnwCMzXfICy1qOZ9JKU/cAJfOJ+wYjYm0kqmY6c/nJMpv37B
	 6jEJgee3KWhMulksVL9TZVniQW5pl7Ze5he65Noc=
Date: Tue, 06 Oct 2026 17:49:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch removed from -mm tree
Message-Id: <20261007004916.593931F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: move helpers ahead of future callers
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: move helpers ahead of future callers
Date: Thu, 10 Sep 2026 14:32:46 +0800

Prepare for section-based vmemmap optimization by moving helpers that
follow-up changes will use.  vmemmap_get_tail() will be called from the
PTE population path.  section_nr_vmemmap_pages() will be made visible
outside the memory hotplug code and called from sparse_init_nid().

Move vmemmap_alloc_block_zero() together with vmemmap_get_tail(), since
the tail helper depends on it.  Move section_nr_vmemmap_pages() earlier
into its own CONFIG_MEMORY_HOTPLUG block.  That lets the later patch
change its visibility and callers without also moving the function body.

No functional change is intended.

Link: https://lore.kernel.org/20260910063256.64386-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/sparse-vmemmap.c |  134 +++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 65 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-move-helpers-ahead-of-future-callers
+++ a/mm/sparse-vmemmap.c
@@ -148,6 +148,75 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return vmemmap_pages * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return vmemmap_pages;
+
+	return 0;
+}
+#endif
+
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+#endif
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -181,17 +250,6 @@ static pte_t * __meminit vmemmap_pte_pop
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -323,33 +381,6 @@ void vmemmap_wrprotect_hvo(unsigned long
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
-
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
-		return NULL;
-
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
-		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
-
-	return tail;
-}
-
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
@@ -646,33 +677,6 @@ void offline_mem_sections(unsigned long
 	}
 }
 
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
-	const unsigned long pages_per_compound = 1UL << order;
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
-
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
-
-	if (order < PFN_SECTION_SHIFT) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
-	}
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
-
-	return 0;
-}
-
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


