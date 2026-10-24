Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832519;
	b=F/xLPiv2CRDJyYQ69N/2CKxX5skDpINoO0ysbi1WJ7lzumK45BaOjeTKT0l505zdaoRs
	 ZyIfS4rJ8xYHC4Pl/0gb46kIc7mbIb7RuR9c9iwBcbSpak/p6n9/iJvkubW0dUtqkWlhR
	 TchpWjYtPNJbDNkfHp77aDlxqx6XKNx8DuM2AKoVo1hWuftxAYOlHg4+rr9pa+58+n4m3
	 WUWMOMzFS0V/qM+6R5kF5ZjQcn6mRnVImU0c3k1XLkurDiyzeHblANdJqhVw3cIADcsq1
	 PTHrUkAqN8XyZgXhdUkm7i1yi9lv2nqZykDerrJX5lhP0b0bVdY3BHkebm8ixsHkehA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832519;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=O1QZkei0Ityifl+LUX9ibbcFwxVb9g/VIXpmyz/Zzt0=;
	b=S8Rfxjx4I+sX4YUHeC4zaWfOa99FT8o6fjEhogwodjSE2GoeIi+/zvvDfYj/B+9MoJ8T
	 zKD3tazFD4Q2CnsozDP9ORe4RztHEkU+xNz3WJHVscN2wDxlLckAzeHUmBi4m2kiANLV6
	 RZrlhOmedBBkmVu4UVkrkqnZI6EhzJn8zGuCBmqKhRfelCDoEzW4vR7zKe8RbbdQHs+1Y
	 rInGLWDWJDIXOHJHqupoYL48JEsYgDQJnpX+xhsAtQwDOhnQ3H20xpPad8S+c9NBbAA2Y
	 zyuFFfsVMWsyyydXHVfRyZSjYvxRUa9yeJzCqTs3S6rQ+He5zsSaSVitNAjOQI2rWfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jJBY47Am;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93672606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jJBY47Am
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618E01F01825;
	Sat, 24 Oct 2026 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832519;
	bh=O1QZkei0Ityifl+LUX9ibbcFwxVb9g/VIXpmyz/Zzt0=;
	h=Date:To:From:Subject;
	b=jJBY47AmwwaVpwod7OBgYCeouJB0yZSRSdn773jKS26T/yb5GZMwlYfYpmtlRxKOT
	 Q21KlNLQ4sL7Rgk8s7J8cW2cA4SsmPuu2c2LWDSfVAKKY1yp1flrZGr6NeoKUAMDfi
	 K1O1pyMP2EAE1tHiA+XCn96kX4Ce01ZfJdFBgLD0=
Date: Sat, 24 Oct 2026 02:01:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch removed from -mm tree
Message-Id: <20261024090159.618E01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse-vmemmap: drop Device DAX-specific population path
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Sat, 10 Oct 2026 15:57:52 +0800

The common vmemmap path selects the shared page for optimized mappings
itself, so Device DAX no longer needs vmemmap_populate_compound_pages() to
find a shared tail page and pass its backing PFN through the generic
population helpers.

Remove the Device DAX-specific population path and let section memmap
population always use vmemmap_populate().  The powerpc retains an
architecture-specific compound-page implementation, so select it directly
from radix__vmemmap_populate() for optimizable sections.

Link: https://lore.kernel.org/20261010075755.83339-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
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

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

