Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891BA15218A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941192; cv=none; b=XARePguaH2UwdLgLRIKCb0A2IMUDIW9HXDfYJjOuqAVrqCxkoHCJ1a6rWyWO8Ryky/xTwGCVvVEc8Rr7vcx8Mko89pIfq5rjDDfRDmD2WW8KOfAyT0s1ECd0zFz42jEhhYLCvLSgoDPcxzdF8fkYmIR2yBMmL5y662kDYngFj7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941192; c=relaxed/simple;
	bh=IXjShlUs5D/rFk4RzrCGbloltVd9+gFVELdBHMYRtvc=;
	h=Date:To:From:Subject:Message-Id; b=mexPxRmlZLpOBAa2YbB1kYLkBWwnWIC+S5nq/gesFYuRu3TGs3Xg1dVkclwiwLJzeOMPlffHSFAUuvPpMIicO21aT8RHx3/LOf5mHOY/9VzEC3PkM+k8UHLJJNYATQCaHftHBJstg91COI32valgW0NADBFIGUii8/KTbvNzFLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SUc4W1Wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SUc4W1Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E643C116B1;
	Tue,  2 Jul 2024 17:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941192;
	bh=IXjShlUs5D/rFk4RzrCGbloltVd9+gFVELdBHMYRtvc=;
	h=Date:To:From:Subject:From;
	b=SUc4W1WxGi0fsGgDqs/02ctl4Na+OjRwVU/MnQ2two+Wm0j6e22or4fsDS6ZjacOi
	 as3OAuMvjAZhEfowEiQGQEIPlQLOyqQlY9QvP6gr3cgb/FizvLCLaDac8XdK26Yr7K
	 fWq5USdxxFPyABnvvRza8osomQWM34ZemJEoPZSA=
Date: Tue, 02 Jul 2024 10:26:31 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-allow-hugepages-without-hugepd.patch added to mm-unstable branch
Message-Id: <20240702172632.5E643C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: allow hugepages without hugepd
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-allow-hugepages-without-hugepd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-allow-hugepages-without-hugepd.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch

