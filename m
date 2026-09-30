Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC5551B190
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 18:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793623; cv=none; b=juNQKqCs0Q3AbBuC5g6AMcWexLUBtlcwVQFmBvaSIRqc6Pg/IHlK0QDwodzEt2iooSPKPwJaOgIgh341Ku46wJ4iWMN+BpZVC9ce+nwbBQht8FZmDpDSRigUmSgWNQlZEmE2WSP6tQaRxX4R0vRkaS5G1UsGnJ7jKBqnU8K/IT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793623; c=relaxed/simple;
	bh=DsEN+3tp6JivfKBiR4bYIyfQvvlvg2Vet4Rp5EMgFdE=;
	h=Date:To:From:Subject:Message-Id; b=lSqUGeHrVSrzigOWK72X4yE3M972JVK6jUBem+5ybZnOYYxMwsT7XnKCQHUsVYPd+Pfn7wUk+33Pe3Hpi19SYXizijGBhxEfRptMn08fOMJBNT7A+qCPJqocBzhYJTl6US3m/9INbfNiqUskbjQjpSLwYdSNknXWdzaX8Keq8lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DjML5xp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DjML5xp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BA31F00898;
	Wed, 30 Sep 2026 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790793622;
	bh=ZbjCIonQJKlSwSXTR0RZ2DlB7Z6Rqb234xTBebOFC2w=;
	h=Date:To:From:Subject;
	b=DjML5xp74KNtOMPiqMuortl+0D67naFWzkd38Diwc2ABZCGFhaVK042ISGgIqGbKT
	 SQ8nMtIr/O/m4TPGieXBMPBjSWsecM2H2HKNOtPjdZz1Wt71Nla/1XbaHiVgx46nuk
	 Qg3XfeLy94YONcg5O1klkGOz2r78ILhrmId6B4FI=
Date: Wed, 30 Sep 2026 11:40:21 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch removed from -mm tree
Message-Id: <20260930184022.17BA31F00898@smtp.kernel.org>
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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Sun, 27 Sep 2026 10:54:40 +0800

section_nr_vmemmap_pages() no longer uses the altmap or pgmap
arguments, so drop them from the helper and its callers.

Link: https://lore.kernel.org/20260927025441.741633-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
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
@@ -670,7 +669,7 @@ static struct page * __meminit populate_
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -681,7 +680,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -691,8 +690,7 @@ static void free_map_bootmem(struct page
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

