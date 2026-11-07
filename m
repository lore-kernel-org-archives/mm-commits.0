Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794034437;
	b=t+1ciEabByX3kI0JdyD18/S689G1V1HZhK1htENPZE+n4xj8vPMa2aZfL12Q/6fTmjnT
	 kxHPoL6ESl2D5ByiCN8tqNJkQ1HdyWeCACxIYYppKdeNIfmggiVsOYk0OEtF2oiwplDUo
	 w+kIrDXa3uszYVqClPQUvOS5BQ321yiiI3XsaL0PmEtLM0q2i3U3tgZbj7sN/KOShKj96
	 BdOFalD8XM8DABNnKhlRavvj6KskyqY3c3Xo56OcPKWNeGT/GDIygMNKXt2eL17iuAAcW
	 Ex2skaJzTfRvYBJtsaO4whX+1dLsMZxUvfecRMuz0jfHcymd45+SNXGb+xA9hG+zOtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794034437;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nFnZYeAcfjw+rlYICJH+o/kD1mWyaMeT0fiWpFvN+ig=;
	b=Ih0Ror4ZowJBg40IixR+bY/BxVTtbPJ/9opcFMdv5i62XDsEZ73DaDih26aP4rLPjwyC
	 j9w+3Htdd6lcON2s5FOtkd4aGiWCM8rodhqUuXORMovuPYLFg9OGrahRKSbo8FYXmP3ed
	 otF9ChMfG1VgsJZUAmcn+/u6LxTYMOPjTEcIaF/8X2uF7oPJYEQ+ccpCGPk9BIX1JJs8S
	 yv+Ulq/2pj3/O7e+avO7S1XpoJ9EBLp/xZUrIokZLlzy94KW/MecBY1D3VjbdeHDRDzc2
	 69AUU8ncfjd7GcVNJUQ8d2x/LbpcjSi+R+hYPxNF8kRyhKTZXT/j5GNp6KZfisxPQAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GJuBLU+h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875E606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 06:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GJuBLU+h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0CE1F0089F;
	Sat,  7 Nov 2026 06:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794034436;
	bh=nFnZYeAcfjw+rlYICJH+o/kD1mWyaMeT0fiWpFvN+ig=;
	h=Date:To:From:Subject;
	b=GJuBLU+huXhGcYVUZ7BkV1MDxXay3csys41qiwskoQ7zQdGP4IGrN9tP1I6Yzc9e8
	 9iJAoKFmMLi+UbxbZd2mc2ggj7BD7dNz+eW6C95HRYOK0eqXaYcb164gzp2M/uZtLC
	 eosXGTLtaVPaxvmt0Ri6ZQ3R2+StAU7PSYz4lqUk=
Date: Fri, 06 Nov 2026 22:53:55 -0800
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,
	ritesh.list@gmail.com,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,lance.yang@linux.dev,
	kernel@xen0n.name,david@kernel.org,chleroy@kernel.org,chenhuacai@kernel.org,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-make-vmemmap_populate_compound_pages-static.patch added to mm-new branch
Message-Id: <20261107065356.5C0CE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: powerpc/mm: make vmemmap_populate_compound_pages() static
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-make-vmemmap_populate_compound_pages-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-make-vmemmap_populate_compound_pages-static.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: powerpc/mm: make vmemmap_populate_compound_pages() static
Date: Sat, 07 Nov 2026 12:31:18 +0800

Patch series "mm: Simplify device DAX vmemmap optimization plumbing", v3.

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: simplifying the device DAX vmemmap
optimization plumbing.

After device DAX was converted to section-based vmemmap optimization,
whether a mapping can be optimized is carried in mem_section, and the
architecture-specific population path can handle any remaining fallback.
The code still retains the DAX-specific vmemmap_can_optimize() helper, a
PowerPC override, and @pgmap arguments threaded through lower-level
vmemmap population and memory-removal interfaces. These duplicate the
section-order policy and keep otherwise generic paths coupled to
dev_pagemap.

This series removes that obsolete plumbing by consolidating the
optimization policy around memory-section metadata and simplifying the
generic and architecture-specific population paths. This also eliminates
dependencies that are no longer needed once the optimization state is
carried by the memory section.

This leaves the section compound order as the single source of truth for
vmemmap optimization and decouples the generic sparse-vmemmap and
memory-hotplug paths from device DAX.

This is another smaller step toward the broader HVO generalization.


This patch (of 5):

vmemmap_populate_compound_pages() is no longer used outside
radix_pgtable.c.

Make it static and drop the unused dev_pagemap argument from
its only remaining caller to simplify the code.

Link: https://lore.kernel.org/20261107043122.25650-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261107043122.25650-2-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/ [1]
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 arch/powerpc/include/asm/book3s/64/radix.h |    6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   |   13 +++++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/radix.h~powerpc-mm-make-vmemmap_populate_compound_pages-static
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -356,11 +356,5 @@ int radix__remove_section_mapping(unsign
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-make-vmemmap_populate_compound_pages-static
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1117,7 +1117,9 @@ static inline pte_t *vmemmap_pte_alloc(p
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1132,7 +1134,7 @@ int __meminit radix__vmemmap_populate(un
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		return vmemmap_populate_compound_pages(pfn, start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1228,10 +1230,9 @@ base_mapping:
 	return 0;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch
powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
loongarch-mm-disable-device-dax-vmemmap-optimization.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

