Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBDD8003D
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434840; cv=none; b=WRB/L9l1gTpBi1c0MtoQMsl/hExEefB/UTXqn3SgDLXl9BTWpKnG1S9nIUxZ05k/GNgI4TL9yCZM9mvAzsUpuM5CjZ6II+MjB/0485UQwBPC43ZkYE0APnjF744kSCdybW7onqSgWGQYtshQxE1fxn5vYw3lYfxNdhDll6Nb6Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434840; c=relaxed/simple;
	bh=RugsNp0MFLH3gxMdzFEit4V7CR+GqOKrIBzOkhAEa9k=;
	h=Date:To:From:Subject:Message-Id; b=ImvpVeCINI8NzlcERWuhvVyl+Vdfui35Lz4RWdyi5BDNMeE09J4PZcoL3o+yaGSAIT3O1IBHE3vdlOzizLq51GslDcEpLo2Uf1dWz7OEgzxymwrwF2oFKdjQGfzrL/X8jFAzgsFH0zkAICY+Z3bUMi4fHl4Jq0G27FYaN9ivctw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jt47+LkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jt47+LkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3801F000E9;
	Fri, 26 Jun 2026 00:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434838;
	bh=8bKMvddP3DghQ+NfKAcT4QpxJDqEsf9paVhQlq69Fr8=;
	h=Date:To:From:Subject;
	b=jt47+LkYFkFidNv+Cptu25uprOIHdWZYOWqH1nuvd7E6QxQk/jz1fM9tI83Id8Dhz
	 bpvtZ1LqxPmHZ8bXFzl2SIOgYheYkmByNNIeqYdm/Szdv2jCOyu3Khj27DhzjaYqZJ
	 53jRIw8mzTltvGgXCKY6bi2kmLg1aLJpQf/6jHZo=
Date: Thu, 25 Jun 2026 17:47:18 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch added to mm-new branch
Message-Id: <20260626004718.6A3801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: panic on memmap and usemap allocation failure
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/sparse: panic on memmap and usemap allocation failure
Date: Fri, 12 Jun 2026 11:58:50 +0800

When vmemmap or usemap allocation fails, sparse_init_nid() currently marks
the section non-present and continues.  Later boot-time code can still
walk PFNs in that section without checking for this partial setup, which
leads to invalid accesses.  subsection_map_init() can also touch an
unallocated usemap.

Auditing and fixing all early PFN walkers for this case is not worth the
complexity.  These allocation failures are expected to be fatal anyway,
and other memory models already treat them that way.

Make memmap and usemap allocation failures panic immediately instead of
trying to recover and crashing later in less obvious ways.  This is also
consistent with how other memory model configurations handle memmap
allocation failures.

Link: https://lore.kernel.org/20260612035903.2468601-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

--- a/mm/sparse.c~mm-sparse-panic-on-memmap-and-usemap-allocation-failure
+++ a/mm/sparse.c
@@ -239,15 +239,8 @@ struct page __init *__populate_section_m
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map;
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	map = memmap_alloc(size, size, addr, nid, false);
-	if (!map)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
-		      __func__, size, PAGE_SIZE, nid, &addr);
-
-	return map;
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
@@ -300,17 +293,14 @@ static void __init sparse_init_nid(int n
 				   unsigned long map_count)
 {
 	unsigned long pnum;
-	struct page *map;
-	struct mem_section *ms;
 
-	if (sparse_usage_init(nid, map_count)) {
-		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
-		goto failed;
-	}
+	if (sparse_usage_init(nid, map_count))
+		panic("Failed to allocate usemap for node %d\n", nid);
 
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
+		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (pnum >= pnum_end)
@@ -318,34 +308,18 @@ static void __init sparse_init_nid(int n
 
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms)) {
+			struct page *map;
+
 			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-					nid, NULL, NULL);
-			if (!map) {
-				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
-				       __func__, nid);
-				pnum_begin = pnum;
-				sparse_usage_fini();
-				goto failed;
-			}
+							nid, NULL, NULL);
+			if (!map)
+				panic("Failed to allocate memmap for section %lu\n", pnum);
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
 							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
 	sparse_usage_fini();
-	return;
-failed:
-	/*
-	 * We failed to allocate, mark all the following pnums as not present,
-	 * except the ones already initialized earlier.
-	 */
-	for_each_present_section_nr(pnum_begin, pnum) {
-		if (pnum >= pnum_end)
-			break;
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms))
-			ms->section_mem_map = 0;
-	}
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

