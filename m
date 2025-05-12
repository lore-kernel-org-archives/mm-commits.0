Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8417AC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011084; cv=none; b=swuZdxClI5SNc/XjeTw8Xbx5jWMvUuyYBWtRskSEdhBP+IL8ycLUofjv1m2ZrnAB442CEU6JK1s5aP+WTlFCig8WbgStz0f/mRDvmS06zF5DKJWWvBr2ZSIV6F7K+rI16hsQMrvIFxdweBsF264PL3GdtbPAD2k4ACSPiW9lRhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011084; c=relaxed/simple;
	bh=zzcBpbiUpPmZBPi7w75Skc/vXFRmA5k1wqgoZixTyhk=;
	h=Date:To:From:Subject:Message-Id; b=ncG+gqE/lvwCDu5GgYPe3SRfv772FZXcCXJAlC6vEtLM/xzVhKvqHj11gErL5B+s+h9Vkry3UCfKF/6A2N4ex6qBMQ0RungkMyIv8USz4BM/by9uNXDBx8bW98h5yYUaCAqNgKo1JhnHMlQn8MjckStws09vaPb2nD7h5TBir8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KS93Mv/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KS93Mv/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B08C4CEE4;
	Mon, 12 May 2025 00:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011084;
	bh=zzcBpbiUpPmZBPi7w75Skc/vXFRmA5k1wqgoZixTyhk=;
	h=Date:To:From:Subject:From;
	b=KS93Mv/WusrdZGcV3chPNfnPF2F1mV4S02UYr2owAk3YXc/sLRFoskOC0mJfwjKgD
	 gQ4ZzY1G5wX76EEQd5VuZBF1/pWAarU/MalBed0Wq1fJg7LZWhZS45AAjo6XvkTR8i
	 6VKwp9ZUNtUJu7EXvW5AC5J2XsWrBZhzESiD9LQQ=
Date: Sun, 11 May 2025 17:51:23 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch removed from -mm tree
Message-Id: <20250512005124.50B08C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: use enum to identify pgtable level instead of *_SHIFT
has been removed from the -mm tree.  Its filename was
     arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: arm64: mm: use enum to identify pgtable level instead of *_SHIFT
Date: Tue, 8 Apr 2025 10:52:18 +0100

Commit 90292aca9854 ("arm64: mm: use appropriate ctors for page tables")
introduced pgtable ctor calls in pgd_pgtable_alloc().  To identify the
pgtable level and call the appropriate ctor, the *_SHIFT value associated
with the pgtable level is used.  However, those values do not
unambiguously identify a level, because if a given level is folded, the
*_SHIFT value will be equal to that of the upper level (e.g.  PMD_SHIFT ==
PUD_SHIFT if PMD is folded).

As things stand, there is probably not much damaged done by calling the
ctor for a different level, and ARCH_ENABLE_SPLIT_PMD_PTLOCK is only
selected if PMD isn't folded (so we don't needlessly initialise
pmd_ptlock).  Still, this is pretty confusing, and it would get even more
confusing when adding ctor calls for the remaining levels.

Let's simplify all this by using an enum to identify the pgtable level
instead; this way folding becomes irrelevant.  This is inspired by one of
the m68k pgtable allocators (arch/m68k/include/asm/motorola_pgalloc.h).

Link: https://lkml.kernel.org/r/20250408095222.860601-9-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   54 +++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift
+++ a/arch/arm64/mm/mmu.c
@@ -46,6 +46,13 @@
 #define NO_CONT_MAPPINGS	BIT(1)
 #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
 
+enum pgtable_type {
+	TABLE_PTE,
+	TABLE_PMD,
+	TABLE_PUD,
+	TABLE_P4D,
+};
+
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
@@ -107,7 +114,7 @@ pgprot_t phys_mem_access_prot(struct fil
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
-static phys_addr_t __init early_pgtable_alloc(int shift)
+static phys_addr_t __init early_pgtable_alloc(enum pgtable_type pgtable_type)
 {
 	phys_addr_t phys;
 
@@ -192,7 +199,7 @@ static void init_pte(pte_t *ptep, unsign
 static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 				unsigned long end, phys_addr_t phys,
 				pgprot_t prot,
-				phys_addr_t (*pgtable_alloc)(int),
+				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 				int flags)
 {
 	unsigned long next;
@@ -207,7 +214,7 @@ static void alloc_init_cont_pte(pmd_t *p
 		if (flags & NO_EXEC_MAPPINGS)
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pte_phys = pgtable_alloc(PAGE_SHIFT);
+		pte_phys = pgtable_alloc(TABLE_PTE);
 		ptep = pte_set_fixmap(pte_phys);
 		init_clear_pgtable(ptep);
 		ptep += pte_index(addr);
@@ -243,7 +250,7 @@ static void alloc_init_cont_pte(pmd_t *p
 
 static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot,
-		     phys_addr_t (*pgtable_alloc)(int), int flags)
+		     phys_addr_t (*pgtable_alloc)(enum pgtable_type), int flags)
 {
 	unsigned long next;
 
@@ -277,7 +284,8 @@ static void init_pmd(pmd_t *pmdp, unsign
 static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 				unsigned long end, phys_addr_t phys,
 				pgprot_t prot,
-				phys_addr_t (*pgtable_alloc)(int), int flags)
+				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+				int flags)
 {
 	unsigned long next;
 	pud_t pud = READ_ONCE(*pudp);
@@ -294,7 +302,7 @@ static void alloc_init_cont_pmd(pud_t *p
 		if (flags & NO_EXEC_MAPPINGS)
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pmd_phys = pgtable_alloc(PMD_SHIFT);
+		pmd_phys = pgtable_alloc(TABLE_PMD);
 		pmdp = pmd_set_fixmap(pmd_phys);
 		init_clear_pgtable(pmdp);
 		pmdp += pmd_index(addr);
@@ -325,7 +333,7 @@ static void alloc_init_cont_pmd(pud_t *p
 
 static void alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			   phys_addr_t phys, pgprot_t prot,
-			   phys_addr_t (*pgtable_alloc)(int),
+			   phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 			   int flags)
 {
 	unsigned long next;
@@ -339,7 +347,7 @@ static void alloc_init_pud(p4d_t *p4dp,
 		if (flags & NO_EXEC_MAPPINGS)
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pud_phys = pgtable_alloc(PUD_SHIFT);
+		pud_phys = pgtable_alloc(TABLE_PUD);
 		pudp = pud_set_fixmap(pud_phys);
 		init_clear_pgtable(pudp);
 		pudp += pud_index(addr);
@@ -383,7 +391,7 @@ static void alloc_init_pud(p4d_t *p4dp,
 
 static void alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			   phys_addr_t phys, pgprot_t prot,
-			   phys_addr_t (*pgtable_alloc)(int),
+			   phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 			   int flags)
 {
 	unsigned long next;
@@ -397,7 +405,7 @@ static void alloc_init_p4d(pgd_t *pgdp,
 		if (flags & NO_EXEC_MAPPINGS)
 			pgdval |= PGD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		p4d_phys = pgtable_alloc(P4D_SHIFT);
+		p4d_phys = pgtable_alloc(TABLE_P4D);
 		p4dp = p4d_set_fixmap(p4d_phys);
 		init_clear_pgtable(p4dp);
 		p4dp += p4d_index(addr);
@@ -427,7 +435,7 @@ static void alloc_init_p4d(pgd_t *pgdp,
 static void __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 					unsigned long virt, phys_addr_t size,
 					pgprot_t prot,
-					phys_addr_t (*pgtable_alloc)(int),
+					phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 					int flags)
 {
 	unsigned long addr, end, next;
@@ -455,7 +463,7 @@ static void __create_pgd_mapping_locked(
 static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				 unsigned long virt, phys_addr_t size,
 				 pgprot_t prot,
-				 phys_addr_t (*pgtable_alloc)(int),
+				 phys_addr_t (*pgtable_alloc)(enum pgtable_type),
 				 int flags)
 {
 	mutex_lock(&fixmap_lock);
@@ -468,10 +476,11 @@ static void __create_pgd_mapping(pgd_t *
 extern __alias(__create_pgd_mapping_locked)
 void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
 			     phys_addr_t size, pgprot_t prot,
-			     phys_addr_t (*pgtable_alloc)(int), int flags);
+			     phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+			     int flags);
 #endif
 
-static phys_addr_t __pgd_pgtable_alloc(int shift)
+static phys_addr_t __pgd_pgtable_alloc(enum pgtable_type pgtable_type)
 {
 	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
 	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL & ~__GFP_ZERO);
@@ -480,23 +489,26 @@ static phys_addr_t __pgd_pgtable_alloc(i
 	return __pa(ptr);
 }
 
-static phys_addr_t pgd_pgtable_alloc(int shift)
+static phys_addr_t pgd_pgtable_alloc(enum pgtable_type pgtable_type)
 {
-	phys_addr_t pa = __pgd_pgtable_alloc(shift);
+	phys_addr_t pa = __pgd_pgtable_alloc(pgtable_type);
 	struct ptdesc *ptdesc = page_ptdesc(phys_to_page(pa));
 
 	/*
 	 * Call proper page table ctor in case later we need to
 	 * call core mm functions like apply_to_page_range() on
 	 * this pre-allocated page table.
-	 *
-	 * We don't select ARCH_ENABLE_SPLIT_PMD_PTLOCK if pmd is
-	 * folded, and if so pagetable_pte_ctor() becomes nop.
 	 */
-	if (shift == PAGE_SHIFT)
+	switch (pgtable_type) {
+	case TABLE_PTE:
 		BUG_ON(!pagetable_pte_ctor(NULL, ptdesc));
-	else if (shift == PMD_SHIFT)
+		break;
+	case TABLE_PMD:
 		BUG_ON(!pagetable_pmd_ctor(NULL, ptdesc));
+		break;
+	default:
+		break;
+	}
 
 	return pa;
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


