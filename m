Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794034445;
	b=5mYCLzfa/rCeeXTN4NOcIiEZIurcyMyp5p/B+XHEVbAbD90o0GutDXx2/YxkV3Xu56JE
	 x6/nENUgnjgN/ohPh2m8tBclk0Oz+YqLcYfU7mlOrjVJH7F1srhGFoDGeRaKrsQZFnTLh
	 HqWtJ24QwFUfPsjFxdcNa5rK6Jt0hX2uYZorme00KCvBztvDoOS4QAfYdVa7ZRo1Hhsm8
	 vGKhMs6jdGf+Y/Yinl17ZavP9tESFfBm64Zr2PHI/Hw4l+IhzB9xsE7kX53Cg9igH0CQ8
	 EFZ3Dcnng/FXyT25xudMUjFkAlJdMHB+3W1s+42vQk9A+rmDi7xGzzAuErtie1MWc/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794034445;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kUGhiF6J90gZuK5kjHHMjSdxrE0mHoL9Dzod314IJEk=;
	b=nnc30GvPVnTMSabPqjOENwIAMnEV5+8iVWXV58dT6hzCKEGP3MMT9DdSTcqshouCaIPe
	 FquMKxg9fSEpO0hkrUmlj0Nwp4vz7AoxcBDey5JQKfOjNTQp5d0HFS/B8lZdvDvY35q48
	 X42cjH6VxzIe9bSlKG1SThsgCNtb3YGMZU58XKeblTzr+GAfMhxpJvdyov/WPJNACReJk
	 vUaheJ9FEiOvsYQjKdbKil9Z9acuQTHBfMcAY19y/DpXkfniQs2bKAUapTECt5lXGDcEn
	 kbEsBlsP95hqRWw20YxGXjv6TYYsPzEH/SR2hbKbVEyhcAZSTO0bGDNfSLFLCXkouJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F9wMtgtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F204606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F9wMtgtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9129E1F0089F;
	Sat,  7 Nov 2026 06:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794034444;
	bh=kUGhiF6J90gZuK5kjHHMjSdxrE0mHoL9Dzod314IJEk=;
	h=Date:To:From:Subject;
	b=F9wMtgtlCW10MujQ7ynt96Dn2sjOBIDsxnxPkwgjBJN+4Nk5OSdLSmQsaq76c3V/P
	 lqOwQKiY2DiYvbypJF7ntDJvBdCZlekLYgRxB0w4mVXQHR3o2TfMMa3n0HuJB3EpYS
	 luYNFmJ964wMvxxc4CxhDleSEl8BX/dO52kIrD+Q=
Date: Fri, 06 Nov 2026 22:54:04 -0800
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,
	ritesh.list@gmail.com,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,lance.yang@linux.dev,
	kernel@xen0n.name,david@kernel.org,chleroy@kernel.org,chenhuacai@kernel.org,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch added to mm-new branch
Message-Id: <20261107065404.9129E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/sparse-vmemmap: drop vmemmap_can_optimize()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch

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
Subject: mm/sparse-vmemmap: drop vmemmap_can_optimize()
Date: Sat, 07 Nov 2026 12:31:21 +0800

section_vmemmap_optimizable() can already decide whether a section uses
vmemmap optimization based on the section compound order. The DAX-specific
vmemmap_can_optimize() helper duplicates that policy, so remove it to
simplify the code.

Link: https://lore.kernel.org/20261107043122.25650-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 include/linux/mm.h                   |   37 -------------------------
 include/linux/vmemmap-optimization.h |   25 +++++++++-------
 mm/sparse-vmemmap.c                  |    6 ++--
 3 files changed, 18 insertions(+), 50 deletions(-)

--- a/include/linux/mm.h~mm-sparse-vmemmap-drop-vmemmap_can_optimize
+++ a/include/linux/mm.h
@@ -38,7 +38,6 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
-#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -5385,42 +5384,6 @@ static inline void vmem_altmap_free(stru
 }
 #endif
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
-					  struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages;
-	unsigned long nr_vmemmap_pages;
-
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!pgmap || !is_power_of_2(sizeof(struct page)))
-		return false;
-
-	nr_pages = pgmap_vmemmap_nr(pgmap);
-	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
-	/*
-	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
-	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
-	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
-}
-/*
- * If we don't have an architecture override, use the generic rule
- */
-#ifndef vmemmap_can_optimize
-#define vmemmap_can_optimize __vmemmap_can_optimize
-#endif
-
-#else
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
-{
-	return false;
-}
-#endif
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
--- a/include/linux/vmemmap-optimization.h~mm-sparse-vmemmap-drop-vmemmap_can_optimize
+++ a/include/linux/vmemmap-optimization.h
@@ -31,6 +31,17 @@
 #define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -40,6 +51,9 @@ static inline unsigned int section_compo
 static inline void section_set_compound_order(struct mem_section *section,
 					      unsigned int order)
 {
+	if (order && !vmemmap_optimizable_order(order))
+		return;
+
 	VM_WARN_ON(section_compound_order(section) && order &&
 		   section_compound_order(section) != order);
 	section->compound_page_order = order;
@@ -109,15 +123,4 @@ static inline bool vmemmap_optimizable_p
 
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
-
-static inline bool vmemmap_optimizable_order(unsigned int order)
-{
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
-}
 #endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-vmemmap_can_optimize
+++ a/mm/sparse-vmemmap.c
@@ -490,6 +490,9 @@ struct page * __meminit __populate_secti
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
+	/* Altmap-backed vmemmap pages cannot be optimized. */
+	if (altmap)
+		section_vmemmap_optimization_disable(start, end);
 	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
@@ -717,10 +720,9 @@ static struct page * __meminit section_a
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	unsigned int order;
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
 	int rc;
 
-	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
 		return ERR_PTR(-EOPNOTSUPP);
 
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

