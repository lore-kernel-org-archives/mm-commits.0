Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2533344A
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081641; cv=none; b=J3QPRASrNrtJs3kkoZ9XXJw0yW0oRw2+AxvJeL5IcSFsh3eqzfuo640Jd3iunyeCJus3H/cuePwkMqTLzeqiAT1Z6Fli44pP2JHaExhctWL/b0uAaB5R2aEk60TgRH1kanuxVaPcJ9iNpGIWtUJUyzsB6Lar4Gyh3ERjag1uOzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081641; c=relaxed/simple;
	bh=jzVnd4sdqdaZ2y4JcpX7BbbGQYqE9xhALK7H49zCUuM=;
	h=Date:To:From:Subject:Message-Id; b=U7nADqoQ7Ply459B5r+EvzpYdWonCZronNR1Xr4U+rU8PerQ06tJ8St9+EPXqrlpWOZOfhzQ3JFko5N8v57Qc2IFe3wX9Mn1oMRX4/gpwZ5GOUo61EKw204mG8MB7sqvc0Ob6AO1YfpH8h2fgeMA/o4shQbdwlYssKwWvL9jlIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RlXSCWnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RlXSCWnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD051F00893;
	Thu, 10 Sep 2026 23:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081640;
	bh=09ArQ2oQaYw9O8xZJuI/yV8mxnbzCEt4Rnq1m6hJ4To=;
	h=Date:To:From:Subject;
	b=RlXSCWnPavh8OMfVfmOsmEbEJSf8PnOX9xTml1gyiWKwqfMAvAVekD9XShfhQv+/+
	 +u9KorBQCMFmCWRoSYOWheCVkpMz3r0qfd0CET3aSdOwZ+H6eM88eL8ulnbAf1zH+K
	 6zRRJQtpAQ11sZjXuL7A9F6Wo68N1+Sdl3KNydxo=
Date: Thu, 10 Sep 2026 16:07:19 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch removed from -mm tree
Message-Id: <20260910230719.EBD051F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Tue, 8 Sep 2026 11:03:34 +0800

section_nr_vmemmap_pages() no longer uses the altmap or pgmap arguments,
so drop them from the helper and its callers.

Link: https://lore.kernel.org/20260908030335.96549-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   10 ++++------
 mm/sparse.c         |    3 +--
 mm/sparse.h         |    6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

--- a/mm/sparse.c~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse.c
@@ -251,8 +251,7 @@ static void __init sparse_init_nid(int n
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
--- a/mm/sparse.h~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_order(ms);
@@ -637,7 +636,7 @@ static struct page * __meminit populate_
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -648,7 +647,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -658,8 +657,7 @@ static void free_map_bootmem(struct page
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

