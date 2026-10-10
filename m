Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA47234D398
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791664490; cv=none; b=QXgsvf/KkLMJsEfIt2lj8LbOTLr7J7vwz0gKkoViAyxnmJs+lPeP89umIBNQEL/wPGmzKoS60smnbWccR377DNulLinvGIIOBPlzPv0N7Gr7ZsXScoMKZj5DQq9MBmiL5ZCVphPk3fI/HYRjm8SImyjb+1V3Nt7Y20z46E4bln0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791664490; c=relaxed/simple;
	bh=GN3y/xw0xGWJG6rQmUFtkfdmsp8E/Y0UyPqkxjI/HhA=;
	h=Date:To:From:Subject:Message-Id; b=ZYdm5Ap+tqOsMeHc/qaTywUMjByQ261XVIXnE22dYubjuZB7Lg8+GYyTFyMvvUAMcFcMEZc+WqKrMGEsCI2/OqiUHSfmUoPi+0sV4TNH60XNms12e1Foze0Uv7urZcdPjeQhIEcgtP6Hdnh65jbhk/oZilkGZYT4MQtQOr5zdK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TYsukK42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TYsukK42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8BA1F000FF;
	Sat, 10 Oct 2026 20:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664488;
	bh=IpN+4/Ze1F964cVApdZ3uOjAMMYBcczhxcVTcaZythQ=;
	h=Date:To:From:Subject;
	b=TYsukK42IzEc1AkTfiIuRWDeYGqPc9c53sXMgX64Cou7yZRaqUCo2UIX6n7dndYYd
	 V1UWAZq49q//J29gAGtFtSGaiO4QjSQ/nzKuhijtRF1Kp563SKbBlHBngFQ32h7KY3
	 +aYxz6RgIleCGPI1QaJ0lzaZLNkV4JLuJwxWfi+Q=
Date: Sat, 10 Oct 2026 13:34:47 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch removed from -mm tree
Message-Id: <20261010203448.4C8BA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: drop Device DAX-specific population path
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Tue, 29 Sep 2026 13:32:28 +0800

The common vmemmap path selects the shared page for optimized mappings
itself, so Device DAX no longer needs vmemmap_populate_compound_pages() to
find a shared tail page and pass its backing PFN through the generic
population helpers.

Remove the Device DAX-specific population path and let section memmap
population always use vmemmap_populate().  The powerpc retains an
architecture-specific compound-page implementation, so select it directly
from radix__vmemmap_populate() for optimizable sections.

Link: https://lore.kernel.org/20260929053231.66085-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    3 
 mm/mm_init.c                             |    2 
 mm/sparse-vmemmap.c                      |   71 ---------------------
 3 files changed, 5 insertions(+), 71 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~mm-sparse-vmemmap-drop-device-dax-specific-population-path
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1126,7 +1126,10 @@ int __meminit radix__vmemmap_populate(un
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	unsigned long pfn = page_to_pfn((struct page *)start);
 
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
--- a/mm/mm_init.c~mm-sparse-vmemmap-drop-device-dax-specific-population-path
+++ a/mm/mm_init.c
@@ -1046,7 +1046,7 @@ static void zone_device_page_init_from_t
  * initialize is a lot smaller that the total amount of struct pages being
  * mapped. This is a paired / mild layering violation with explicit knowledge
  * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap. See vmemmap_populate_compound_pages().
+ * of an altmap.
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
 					      struct dev_pagemap *pgmap)
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-device-dax-specific-population-path
+++ a/mm/sparse-vmemmap.c
@@ -503,71 +503,6 @@ int __meminit vmemmap_populate_hugepages
 	return 0;
 }
 
-#ifndef vmemmap_populate_compound_pages
-/*
- * For compound pages bigger than section size (e.g. x86 1G compound
- * pages with 2M subsection size) fill the rest of sections as tail
- * pages.
- *
- * Note that memremap_pages() resets @nr_range value and will increment
- * it after each range successful onlining. Thus the value or @nr_range
- * at section memmap populate corresponds to the in-progress range
- * being onlined here.
- */
-static bool __meminit reuse_compound_section(unsigned long start_pfn,
-					     struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
-	unsigned long offset = start_pfn -
-		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
-
-	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
-}
-
-static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-						     unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap)
-{
-	const unsigned int order = pfn_to_section_compound_order(start_pfn);
-	unsigned long size, addr;
-	pte_t *pte;
-	struct page *page;
-	int rc;
-
-	page = vmemmap_shared_tail_page(order, device_zone(node));
-	if (!page)
-		return -ENOMEM;
-
-	if (reuse_compound_section(start_pfn, pgmap))
-		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page));
-
-	size = min(end - start, (1UL << order) * sizeof(struct page));
-	for (addr = start; addr < end; addr += size) {
-		unsigned long next, last = addr + size;
-
-		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-
-		/*
-		 * Reuse the shared page for the rest of tail pages
-		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
-		 */
-		next = addr + PAGE_SIZE;
-		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page));
-		if (rc)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-#endif
-
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -580,11 +515,7 @@ struct page * __meminit __populate_secti
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
-	else
-		r = vmemmap_populate(start, end, nid, altmap);
-
+	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

