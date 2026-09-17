Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3CE374E73
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789609006; cv=none; b=MaPqD8sGib0ajQcuMd6SI+1bANXRIimZiDwk8SP8YGXazdTw+glmMprKuKgkImRCIp3o8VXtX7lidQIHtYz7XqVUBrXFWbKwqqlYHf5k9C3XhqD1/YUkJxOmY6kZDnM2SE/KwFOAgzGEIGpxnrHzItVHyt0b1VvAAKzJIYeQP0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789609006; c=relaxed/simple;
	bh=12wtijEN+63V+MOCfKotmpe8RHOYTHx6DiJg6jQXVIQ=;
	h=Date:To:From:Subject:Message-Id; b=gMlDnYgtp3eGAaS9FMYujOqIb9AuRqGpo41KzvwlxmERa0/DA0uv4ZxIlNsB66N84L5vNHhRxG9WF9/DHinnvMn9DlA9n75ssPkPIx+sV0WhzACLbEXUdN6YRpTYXFRITTNR647tBf6VwF5BchLNk8qoDgGKivs54nFK7a7RHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y6yPQAbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y6yPQAbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2048C1F000FF;
	Thu, 17 Sep 2026 01:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789609005;
	bh=k+34h2D71wAfHcv0Suw1YKwpJzIS1Lyr8I2J9HsH9tQ=;
	h=Date:To:From:Subject;
	b=Y6yPQAbfclSYDBruJgs6rb0Y6S1pBg1izI6lgNxXgsJCiCvRH88UhStZvK+xGos39
	 4HosRqKHBwa8StfQvAkhcviU/++OV5tHZ5NrOvUjR6C23kKxYf58s+tWFtQprnOks5
	 hESJB81Zz1ARUX/PD1nv3L1oa0DbCEMROQavCGQs=
Date: Wed, 16 Sep 2026 18:36:44 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch added to mm-unstable branch
Message-Id: <20260917013645.2048C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Wed, 16 Sep 2026 14:43:40 +0800

section_nr_vmemmap_pages() no longer uses the altmap or pgmap arguments,
so drop them from the helper and its callers.

Link: https://lore.kernel.org/20260916064341.1825793-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 mm/sparse-vmemmap.c |   10 ++++------
 mm/sparse.c         |    3 +--
 mm/sparse.h         |    6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

--- a/mm/sparse.c~mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments
+++ a/mm/sparse.c
@@ -250,8 +250,7 @@ static void __init sparse_init_nid(int n
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
 	const int order = section_compound_order(ms);
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
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

