Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D246D1CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824871; cv=none; b=N03XoogM1DFUKVMnhkjweMx62mutTaG+7tEjWJtAeI3SP6JtRQW64lCH2vQCawdqFnbjw7A21Slkg4bi5XS65JYDnhamUHa1AW/yXDolXxE3xWtiRk6wVuUyd2/GDRcYyI5Q7M012OjI+wxPhGn1ro7GOL5Zos2WcRIM+gAuio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824871; c=relaxed/simple;
	bh=O81hSse3keIrXpd3jhYEzS/TIAXWdoQ5YA1vwiw+tBc=;
	h=Date:To:From:Subject:Message-Id; b=AYYmOIh/To2Ll3KYrxkUkHEhvT1GKQMusqfeSLnhTzWvzuVXeifatE5uMQJF8QnS+zL3Y2SbDIN11cGcjvirOOnrGBmVTC2e/+s+N8nj2vAAq0BMaccfn1nNaNGOGbyqQGpsnJ4qYtbGdTXn4X7eHASFafNctUl8c76sGm/nrek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCoK1I4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCoK1I4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81F6C32782;
	Fri, 12 Jul 2024 22:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824871;
	bh=O81hSse3keIrXpd3jhYEzS/TIAXWdoQ5YA1vwiw+tBc=;
	h=Date:To:From:Subject:From;
	b=OCoK1I4Iks1GKB4cJ6Wqu8srnpm9gIU5WfFWS6yBfVLmhF9mTmKLPHjyMbRG0LO0Z
	 dSMTgjgpbTtqT9MrQGWMkADy4gaMtp98UGNTBZIAqbaUbOAfFAOQS4VNU4jTsSGmNY
	 SPf96Cehy+Dg0aL4nKjaNCtmMmdfwmk9C+hThCcY=
Date: Fri, 12 Jul 2024 15:54:31 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-allow-hugepages-without-hugepd.patch removed from -mm tree
Message-Id: <20240712225431.A81F6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: allow hugepages without hugepd
has been removed from the -mm tree.  Its filename was
     powerpc-mm-allow-hugepages-without-hugepd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/mm: allow hugepages without hugepd
Date: Tue, 2 Jul 2024 15:51:23 +0200

In preparation of implementing huge pages on powerpc 8xx without hugepd,
enclose hugepd related code inside an ifdef CONFIG_ARCH_HAS_HUGEPD

This also allows removing some stubs.

Link: https://lkml.kernel.org/r/ada097ca8a4fa85a77f51719516ef2478800d77a.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                         |    1 
 arch/powerpc/include/asm/book3s/32/pgalloc.h |    2 -
 arch/powerpc/include/asm/hugetlb.h           |   10 +----
 arch/powerpc/include/asm/nohash/pgtable.h    |    2 -
 arch/powerpc/mm/hugetlbpage.c                |   33 +++++++++++++++++
 arch/powerpc/mm/pgtable.c                    |    2 +
 arch/powerpc/platforms/Kconfig.cputype       |    3 +
 7 files changed, 41 insertions(+), 12 deletions(-)

--- a/arch/powerpc/include/asm/book3s/32/pgalloc.h~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/include/asm/book3s/32/pgalloc.h
@@ -47,8 +47,6 @@ static inline void pgtable_free(void *ta
 	}
 }
 
-#define get_hugepd_cache_index(x)  (x)
-
 static inline void pgtable_free_tlb(struct mmu_gather *tlb,
 				    void *table, int shift)
 {
--- a/arch/powerpc/include/asm/hugetlb.h~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -30,10 +30,12 @@ static inline int is_hugepage_only_range
 }
 #define is_hugepage_only_range is_hugepage_only_range
 
+#ifdef CONFIG_ARCH_HAS_HUGEPD
 #define __HAVE_ARCH_HUGETLB_FREE_PGD_RANGE
 void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 			    unsigned long end, unsigned long floor,
 			    unsigned long ceiling);
+#endif
 
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
 static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
@@ -67,14 +69,6 @@ static inline void flush_hugetlb_page(st
 {
 }
 
-#define hugepd_shift(x) 0
-static inline pte_t *hugepte_offset(hugepd_t hpd, unsigned long addr,
-				    unsigned pdshift)
-{
-	return NULL;
-}
-
-
 static inline void __init gigantic_hugetlb_cma_reserve(void)
 {
 }
--- a/arch/powerpc/include/asm/nohash/pgtable.h~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -340,7 +340,7 @@ static inline void __set_pte_at(struct m
 
 #define pgprot_writecombine pgprot_noncached_wc
 
-#ifdef CONFIG_HUGETLB_PAGE
+#ifdef CONFIG_ARCH_HAS_HUGEPD
 static inline int hugepd_ok(hugepd_t hpd)
 {
 #ifdef CONFIG_PPC_8xx
--- a/arch/powerpc/Kconfig~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/Kconfig
@@ -135,7 +135,6 @@ config PPC
 	select ARCH_HAS_DMA_MAP_DIRECT 		if PPC_PSERIES
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_HUGEPD			if HUGETLB_PAGE
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -42,6 +42,7 @@ pte_t *huge_pte_offset(struct mm_struct
 	return __find_linux_pte(mm->pgd, addr, NULL, NULL);
 }
 
+#ifdef CONFIG_ARCH_HAS_HUGEPD
 static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
 			   unsigned long address, unsigned int pdshift,
 			   unsigned int pshift, spinlock_t *ptl)
@@ -193,6 +194,36 @@ pte_t *huge_pte_alloc(struct mm_struct *
 
 	return hugepte_offset(*hpdp, addr, pdshift);
 }
+#else
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+		      unsigned long addr, unsigned long sz)
+{
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	addr &= ~(sz - 1);
+
+	p4d = p4d_offset(pgd_offset(mm, addr), addr);
+	if (!mm_pud_folded(mm) && sz >= P4D_SIZE)
+		return (pte_t *)p4d;
+
+	pud = pud_alloc(mm, p4d, addr);
+	if (!pud)
+		return NULL;
+	if (!mm_pmd_folded(mm) && sz >= PUD_SIZE)
+		return (pte_t *)pud;
+
+	pmd = pmd_alloc(mm, pud, addr);
+	if (!pmd)
+		return NULL;
+
+	if (sz >= PMD_SIZE)
+		return (pte_t *)pmd;
+
+	return pte_alloc_huge(mm, pmd, addr);
+}
+#endif
 
 #ifdef CONFIG_PPC_BOOK3S_64
 /*
@@ -248,6 +279,7 @@ int __init alloc_bootmem_huge_page(struc
 	return __alloc_bootmem_huge_page(h, nid);
 }
 
+#ifdef CONFIG_ARCH_HAS_HUGEPD
 #ifndef CONFIG_PPC_BOOK3S_64
 #define HUGEPD_FREELIST_SIZE \
 	((PAGE_SIZE - sizeof(struct hugepd_freelist)) / sizeof(pte_t))
@@ -505,6 +537,7 @@ void hugetlb_free_pgd_range(struct mmu_g
 		}
 	} while (addr = next, addr != end);
 }
+#endif
 
 bool __init arch_hugetlb_valid_size(unsigned long size)
 {
--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/mm/pgtable.c
@@ -496,8 +496,10 @@ out_huge:
 	if (!hpdp)
 		return NULL;
 
+#ifdef CONFIG_ARCH_HAS_HUGEPD
 	ret_pte = hugepte_offset(*hpdp, ea, pdshift);
 	pdshift = hugepd_shift(*hpdp);
+#endif
 out:
 	if (hpage_shift)
 		*hpage_shift = pdshift;
--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-allow-hugepages-without-hugepd
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -37,6 +37,7 @@ config PPC_85xx
 
 config PPC_8xx
 	bool "Freescale 8xx"
+	select ARCH_HAS_HUGEPD if HUGETLB_PAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select FSL_SOC
 	select PPC_KUEP
@@ -98,6 +99,7 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_HUGEPD if HUGETLB_PAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select HAVE_MOVE_PMD
@@ -290,6 +292,7 @@ config PPC_BOOK3S
 config PPC_E500
 	select FSL_EMB_PERFMON
 	bool
+	select ARCH_HAS_HUGEPD if HUGETLB_PAGE
 	select ARCH_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
 	select PPC_SMP_MUXED_IPI
 	select PPC_DOORBELL
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


