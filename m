Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342062;
	b=ax2VvAZdQiunq/rMVw9yfQIO8Yi5PWB+m59C0ynlH7Fo6+RysjfEl1aG1JftLXtjcSp7
	 OK+SNn8BVU4VqbQIUSVfpEBVAcDutNFMfb8SZaRKJjp3/QvWKIS5qGx/rsZFycNc4xYf1
	 BxyS/TpvmH3L8Qn/PdOpakkd0Nx5Y54G/YJgMjzLdBBFeNLG6Pjzk0bsfxS5CQhQeCDjd
	 iWBsz4iqbtvqrrZcCnoVYasXdP8uDjUbD40C6G/cJnO0givZd/BxziXaq9G7KJ3EBEaNA
	 uuoi2pGLTRL9VwxpN5/bUKaUIqAmmwiL1DgHIz5+b9xX708aDBoMxYUxmKNCqQNgB+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342062;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WdHCm00c0MXQSqMLIep9+0Peum48YoEhuvZKP5u2gtM=;
	b=ki0Cwt7zziZ8F/fhnjgL9hWMJ0DKwMptFS+NCyf/F6OcSBNlbnnDTsEFbo5R2L6nECd1
	 B83OIdOz/TVWggo8BcWofIW0EnKRyFcYXICoCF6lVYJPuVoKNsuZCxNTNuz2ieGIMokEI
	 8evBL3MfIXTbvruwYaRVFHtnSAm8bt6lY2ijHVQg0B6Zo38h8hYrzi4nIo6/9dvOr+MB/
	 H6jk7PlRDmGAuMRmca0H/x9quVGW641L80no3yICYAS4td0FrsYjYs6i95ONq8U+QLKgJ
	 Cn+9uej3GPPqppVEjt9uplNycIEMaps0NXowPEeH3yyiosArqVc4ecZXXB+NnkeMonA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XEqSwywq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FC9606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XEqSwywq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E81F000C1;
	Fri, 30 Oct 2026 06:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793342062;
	bh=WdHCm00c0MXQSqMLIep9+0Peum48YoEhuvZKP5u2gtM=;
	h=Date:To:From:Subject;
	b=XEqSwywqIFa4HG/LY/RPQ9dqZbvwwWfoaB24UUH2WcGKOPM0qF48N5icahnwEQAmh
	 4Z98yJBby/C7j9wLjt/+J+ZZKPfKByP/a9eITUy6WOke9OdaiFQ3ZkOmiyQrT/s0fo
	 KuyBniW6vL1LaLslUAoML74TTZSXWN6Z/8xGdaJc=
Date: Thu, 29 Oct 2026 23:34:21 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,rppt@kernel.org,
	kernel@xen0n.name,james.bottomley@hansenpartnership.com,deller@gmx.de,
	david@kernel.org,chenhuacai@kernel.org,arnd@arndb.de,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-generalize-pmd-page-table-allocation.patch added to mm-new branch
Message-Id: <20261030063422.028E81F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: generalize PMD page table allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-generalize-pmd-page-table-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-generalize-pmd-page-table-allocation.patch

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
Subject: mm: generalize PMD page table allocation
Date: Wed, 14 Oct 2026 11:59:09 +0800

The generic PMD allocator assumes order-0 page tables and zero-valued
empty entries. MIPS and LoongArch need pmd_init() to install their invalid
entries, while MIPS and parisc use PMD_TABLE_ORDER to describe the
allocation size.

Default PMD_TABLE_ORDER to zero, honor architecture overrides, and invoke
pmd_init() from the generic allocator. MIPS, LoongArch, and parisc can then
use the generic GFP selection, constructor handling, and kernel ptdesc
marking instead of duplicating most of the helper.

Link: https://lore.kernel.org/20261014035910.687847-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>
---

 arch/loongarch/include/asm/pgalloc.h |   21 ---------------------
 arch/mips/include/asm/pgalloc.h      |   25 -------------------------
 arch/parisc/include/asm/pgalloc.h    |   17 -----------------
 include/asm-generic/pgalloc.h        |   12 ++++++++++--
 4 files changed, 10 insertions(+), 65 deletions(-)

--- a/arch/loongarch/include/asm/pgalloc.h~mm-generalize-pmd-page-table-allocation
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
@@ -47,26 +46,6 @@ extern pgd_t *pgd_alloc(struct mm_struct
 #define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
-
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *pmd;
-	struct ptdesc *ptdesc;
-
-	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, 0);
-	if (!ptdesc)
-		return NULL;
-
-	if (!pagetable_pmd_ctor(mm, ptdesc)) {
-		pagetable_free(ptdesc);
-		return NULL;
-	}
-
-	pmd = ptdesc_address(ptdesc);
-	pmd_init(pmd);
-	return pmd;
-}
-
 #define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
--- a/arch/mips/include/asm/pgalloc.h~mm-generalize-pmd-page-table-allocation
+++ a/arch/mips/include/asm/pgalloc.h
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
@@ -29,11 +28,6 @@ static inline void pmd_populate(struct m
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
-/*
- * Initialize a new pmd table with invalid pointers.
- */
-extern void pmd_init(void *addr);
-
 #ifndef __PAGETABLE_PMD_FOLDED
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
@@ -52,25 +46,6 @@ extern pgd_t *pgd_alloc(struct mm_struct
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pmd_t *pmd;
-	struct ptdesc *ptdesc;
-
-	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, PMD_TABLE_ORDER);
-	if (!ptdesc)
-		return NULL;
-
-	if (!pagetable_pmd_ctor(mm, ptdesc)) {
-		pagetable_free(ptdesc);
-		return NULL;
-	}
-
-	pmd = ptdesc_address(ptdesc);
-	pmd_init(pmd);
-	return pmd;
-}
-
 #define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
--- a/arch/parisc/include/asm/pgalloc.h~mm-generalize-pmd-page-table-allocation
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -10,7 +10,6 @@
 
 #include <asm/cache.h>
 
-#define __HAVE_ARCH_PMD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 /* Allocate the top level pgd (page directory) */
@@ -29,22 +28,6 @@ static inline void pud_populate(struct m
 			(__u32)(__pa((unsigned long)pmd) >> PxD_VALUE_SHIFT)));
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct ptdesc *ptdesc;
-	gfp_t gfp = GFP_PGTABLE_USER;
-
-	if (mm == &init_mm)
-		gfp = GFP_PGTABLE_KERNEL;
-	ptdesc = pagetable_alloc(gfp, PMD_TABLE_ORDER);
-	if (!ptdesc)
-		return NULL;
-	if (!pagetable_pmd_ctor(mm, ptdesc)) {
-		pagetable_free(ptdesc);
-		return NULL;
-	}
-	return ptdesc_address(ptdesc);
-}
 #endif
 
 static inline void
--- a/include/asm-generic/pgalloc.h~mm-generalize-pmd-page-table-allocation
+++ a/include/asm-generic/pgalloc.h
@@ -125,6 +125,10 @@ static inline void pte_free(struct mm_st
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
+#ifndef PMD_TABLE_ORDER
+#define PMD_TABLE_ORDER	0
+#endif
+
 #ifndef __HAVE_ARCH_PMD_ALLOC_ONE
 /**
  * pmd_alloc_one - allocate memory for a PMD-level page table
@@ -140,11 +144,12 @@ static inline void pte_free(struct mm_st
 static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
 {
 	struct ptdesc *ptdesc;
+	pmd_t *pmd;
 	gfp_t gfp = GFP_PGTABLE_USER;
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	ptdesc = pagetable_alloc_noprof(gfp, 0);
+	ptdesc = pagetable_alloc_noprof(gfp, PMD_TABLE_ORDER);
 	if (!ptdesc)
 		return NULL;
 	if (!pagetable_pmd_ctor(mm, ptdesc)) {
@@ -152,10 +157,13 @@ static inline pmd_t *pmd_alloc_one_nopro
 		return NULL;
 	}
 
+	pmd = ptdesc_address(ptdesc);
+	pmd_init(pmd);
+
 	if (mm == &init_mm)
 		ptdesc_set_kernel(ptdesc);
 
-	return ptdesc_address(ptdesc);
+	return pmd;
 }
 #define pmd_alloc_one(...)	alloc_hooks(pmd_alloc_one_noprof(__VA_ARGS__))
 #endif
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch

