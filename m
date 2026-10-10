Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A1134D398
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791664487; cv=none; b=DJ0APSBpb0GtuLeBNAg8EZc5zr9Rr2ertTSiPJP7N84nslEVz/kNXj5ineMG3SWMllFj54MNChRVwA8Le8tZGASm0KZLOwZsCvzf+Ds33/1nAGPv3jjKYe5FNOgwDdhK2yVZNstXhqEjVC/QH8fpb/q+MeLt3gX7Yyh11OtBtJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791664487; c=relaxed/simple;
	bh=K8INDnh6hu+AmKDTZz/GzFOl2E23+XJ0bWXPPW3kh30=;
	h=Date:To:From:Subject:Message-Id; b=cUDUdF6RVj2YzAoHAsdVLoJOjujC7Dl68FACpdJCt2UT4D45UvjZq0gfSXf2DbmgjMCa4Cg5nlyfQ6O1QVoNMIMHp9lpsYVREpU6GS2OTcqh0Cn46Pe5x63dSISrtBj6e12u/xvaUtuIMxnqkOSRXFnD8EiMOz4hOJ+Q2tvwKXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZrKvMo4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZrKvMo4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D9C1F000FF;
	Sat, 10 Oct 2026 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664486;
	bh=iixxxPisotW+AMPIlHMaKouz0dm5Y13JLeJ63iAAtkw=;
	h=Date:To:From:Subject;
	b=ZrKvMo4oHpNH1ZQ8xkbGHXnUfLEGLJ83rijImQPyWOUZunqEduptueDvC5k3RGZvl
	 llOHoNVv4GcaqTKM5AxV9V6C61z5CHvu53p6qcDKf8+d9ivszJv2sb0DbXO1dwkfma
	 AnYhlzxTVmtOFBE9T225TAxuc+ek6hpEQnA8Ai3M=
Date: Sat, 10 Oct 2026 13:34:45 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch removed from -mm tree
Message-Id: <20261010203446.21D9C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
Date: Tue, 29 Sep 2026 13:32:26 +0800

Patch series "mm: Unify device DAX and HugeTLB vmemmap population paths",
v3.

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1].  While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: unifying their vmemmap population paths.

After the preceding Device DAX conversion, both HugeTLB and Device DAX
describe optimized vmemmap mappings through memory-section metadata and
use per-zone shared tail vmemmap pages.  The generic code, however, still
carries a Device DAX-specific population flag and compound-page population
path, along with arguments and helpers needed only by that path.

This series first removes VMEMMAP_POPULATE_DAX and moves selection and
reference handling for the shared tail page into the common vmemmap
population path.  It then removes the generic Device DAX-specific
compound-page population path and routes section vmemmap population
through vmemmap_populate().  The powerpc radix path continues to use its
architecture-specific compound-page population implementation for
optimizable sections.

The remaining patches remove the unused ptpfn argument, open-code
vmemmap_populate_address() now that no caller needs its returned PTE, and
add a warning for inconsistent zone initialization of shared tail vmemmap
pages.

This is the fourth smaller step toward the broader HVO generalization. 
After this series, HugeTLB and Device DAX use the same population model
instead of parallel generic paths, while powerpc keeps its
architecture-specific implementation.


This patch (of 6):

VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in two
places: it keeps allocations on the normal path and takes a reference when
a backing page is supplied for reuse.

After Device DAX switched to the common per-zone shared tail page, both
conditions can be determined locally.  DAX supplies ptpfn for every shared
tail mapping and requests an allocation only for compound head mappings,
whose PFNs are not optimizable.  Therefore, vmemmap_optimizable_pfn()
alone selects the correct allocation path.

When ptpfn is supplied, the caller is reusing an existing backing page. 
Once the slab allocator is available, take a reference for each reused
mapping to balance the release performed by vmemmap_free().  Although the
buddy allocator is available before slab, no vmemmap population occurs in
that interval.  Earlier mappings are backed by memblock/reserved memory
and do not need page reference accounting.

Remove VMEMMAP_POPULATE_DAX and the flags argument from the vmemmap
population helpers.

Link: https://lore.kernel.org/20260929053231.66085-2-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/ [1]
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

 mm/sparse-vmemmap.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-vmemmap_populate_dax
+++ a/mm/sparse-vmemmap.c
@@ -32,12 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-/*
- * Flags for vmemmap_populate_range and friends.
- */
-/* Vmemmap population for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_DAX		0x0001
-
 #include "internal.h"
 #include "mm_init.h"
 #include "sparse.h"
@@ -241,7 +235,7 @@ struct page __ref *vmemmap_shared_tail_p
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-		struct vmem_altmap *altmap, unsigned long flags)
+		struct vmem_altmap *altmap)
 {
 	struct zone *zone;
 	struct page *page;
@@ -251,7 +245,7 @@ static __meminit void *vmemmap_alloc_pte
 	 * Device DAX still relies on vmemmap_populate_compound_pages() for
 	 * head/first-tail allocation and tail-page reuse.
 	 */
-	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
+	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -263,8 +257,7 @@ static __meminit void *vmemmap_alloc_pte
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap,
-				       unsigned long ptpfn, unsigned long flags)
+		struct vmem_altmap *altmap, unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -273,7 +266,7 @@ static pte_t * __meminit vmemmap_pte_pop
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
 			if (!p)
 				return NULL;
@@ -291,7 +284,7 @@ static pte_t * __meminit vmemmap_pte_pop
 			 * Use try_get_page() to prevent the shared page refcount
 			 * from overflowing.
 			 */
-			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			if (slab_is_available() &&
 			    !try_get_page(pfn_to_page(ptpfn)))
 				return NULL;
 		}
@@ -355,8 +348,7 @@ static pgd_t * __meminit vmemmap_pgd_pop
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn,
-					      unsigned long flags)
+					      unsigned long ptpfn)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -376,7 +368,7 @@ static pte_t * __meminit vmemmap_populat
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn, flags);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -387,15 +379,14 @@ static pte_t * __meminit vmemmap_populat
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
 					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn,
-					    unsigned long flags)
+					    unsigned long ptpfn)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn, flags);
+					       ptpfn);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -406,7 +397,7 @@ static int __meminit vmemmap_populate_ra
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
+	return vmemmap_populate_range(start, end, node, altmap, -1);
 }
 
 /*
@@ -532,7 +523,6 @@ static int __meminit vmemmap_populate_co
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
-	const unsigned long flags = VMEMMAP_POPULATE_DAX;
 	const unsigned int order = pfn_to_section_compound_order(start_pfn);
 	unsigned long size, addr;
 	pte_t *pte;
@@ -545,14 +535,14 @@ static int __meminit vmemmap_populate_co
 
 	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page), flags);
+					      page_to_pfn(page));
 
 	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
+		pte = vmemmap_populate_address(addr, node, NULL, -1);
 		if (!pte)
 			return -ENOMEM;
 
@@ -562,7 +552,7 @@ static int __meminit vmemmap_populate_co
 		 */
 		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page), flags);
+					    page_to_pfn(page));
 		if (rc)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

