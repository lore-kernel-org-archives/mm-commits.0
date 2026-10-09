Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45630418A23
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525544; cv=none; b=U45RFusxK4rGnbYjpYqH/xCmcHtnAf1vhtmMcKA2H3kvn1U4RSOVkkyVjHSrwLLyuWl85D7Dr1my38Om2vDdGsv98mM40HGwGlwJjTPr7trhFOp2alw8x/+nsH98xDb1fSez+uIsPopBWMOGdqiKuNIvCQxZns9A84vJOZcH0c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525544; c=relaxed/simple;
	bh=30b1NNW1rhcp4wrWiijiw+sjZpFqM9ZvpNXkT7FT1WQ=;
	h=Date:To:From:Subject:Message-Id; b=o8klLVGLTplZkxdYNKWvM2Zo5FjT7SBH1Vj/cJtB8+HCi7HFp//B5EoGNU8QegdKVk+aSdIHXWBe7Rt5TkMj2TL7VOPADA22O/lGr5ksAgYqYs9MMZMuHYsngKa6R89FfqpOrETmwr4D7C2y48Jn4lgmi5GrdHa1h0Htvftv3q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=00VIZ37m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="00VIZ37m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8D91F000FF;
	Fri,  9 Oct 2026 05:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525543;
	bh=819izHUwnqHxlk2bIZtCdgywIvxUm0pzcFhifSczCL8=;
	h=Date:To:From:Subject;
	b=00VIZ37m4PElTtiRdk1sLC1jnphGcroBiVknwbs+fPWniUlNN2H9UOGcVaYVYfdZD
	 en3YRKhLSUi7hIasEZwd2qrC19A5ZK3QynwvExgwRtZlayhpZWCFAKQ9cwJ5p/LpJo
	 MgEbWdCcN5ot7e0m3KFfL9praxVoO5A9U6EAZ2Qg=
Date: Thu, 08 Oct 2026 22:59:02 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch removed from -mm tree
Message-Id: <20261009055903.1B8D91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Wed, 30 Sep 2026 22:06:25 +0800

The device DAX vmemmap population still reserves one extra tail vmemmap
page after the head page.

Drop that extra reservation and let the shared tail page cover all tail
vmemmap pages after the head page, so DAX follows the same reservation
model as HugeTLB.

This reduces the reserved vmemmap pages for optimized DAX mappings to one
and removes the now-unneeded first-tail population from the generic and
powerpc paths to simplify the code as well.

Link: https://lore.kernel.org/20260930140627.57431-11-songmuchun@bytedance.com
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
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |   46 ---------------------
 include/linux/mm.h                       |    4 -
 mm/mm_init.c                             |    2 
 mm/sparse-vmemmap.c                      |   13 +----
 4 files changed, 8 insertions(+), 57 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1222,39 +1222,6 @@ base_mapping:
 	return 0;
 }
 
-static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int node,
-							 struct vmem_altmap *altmap,
-							 struct page *reuse)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = vmemmap_pud_alloc(p4d, node, addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, addr);
-	if (!pte)
-		return NULL;
-	radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1301,7 +1268,7 @@ int __meminit vmemmap_populate_compound_
 		if (!pte_none(*pte)) {
 			/*
 			 * This could be because we already have a compound
-			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
+			 * page whose retained vmemmap page was mapped and
 			 * this request fall in those pages.
 			 */
 			next = addr + PAGE_SIZE;
@@ -1322,16 +1289,7 @@ int __meminit vmemmap_populate_compound_
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				/*
-				 * Populate the tail pages vmemmap page
-				 * It can fall in different pmd, hence
-				 * vmemmap_populate_address()
-				 */
-				pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-
-				next = addr + 2 * PAGE_SIZE;
+				next = addr + PAGE_SIZE;
 				continue;
 			}
 
--- a/include/linux/mm.h~mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation
+++ a/include/linux/mm.h
@@ -38,6 +38,7 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
+#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -5167,7 +5168,6 @@ static inline void vmem_altmap_free(stru
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
@@ -5187,7 +5187,7 @@ static inline bool __vmemmap_can_optimiz
 	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
 	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
 	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
+	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
 }
 /*
  * If we don't have an architecture override, use the generic rule
--- a/mm/mm_init.c~mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation
+++ a/mm/mm_init.c
@@ -1056,7 +1056,7 @@ static inline unsigned long compound_nr_
 	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
-	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
+	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
 }
 
 static void __ref memmap_init_compound(struct page *head,
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation
+++ a/mm/sparse-vmemmap.c
@@ -136,7 +136,6 @@ int __meminit section_nr_vmemmap_pages(u
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
@@ -147,13 +146,13 @@ int __meminit section_nr_vmemmap_pages(u
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
+		return VMEMMAP_OPTIMIZATION_PAGES * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
+		return VMEMMAP_OPTIMIZATION_PAGES;
 
 	return 0;
 }
@@ -558,17 +557,11 @@ static int __meminit vmemmap_populate_co
 		if (!pte)
 			return -ENOMEM;
 
-		/* Populate the tail pages vmemmap page */
-		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
-		if (!pte)
-			return -ENOMEM;
-
 		/*
 		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
-		next += PAGE_SIZE;
+		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
 					    page_to_pfn(page), flags);
 		if (rc)
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

