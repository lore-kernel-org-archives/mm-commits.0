Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAF33232
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837144; cv=none; b=HI6xxbkCwZOOwp0ubl1ZLMfaBhOMzDQ7A9yuSzyv80zqEUuH2G4+iPDFXAlMSHybLAMpqdrSJoL+4JD+UYFrTw1RwJ+oQ61s2Whz9KC4+JdlJjz2/aS9XwpJCtdI0FJsG2HJELc/dKRloTP5YCMQAOLGvoAnbxFEE+korahTJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837144; c=relaxed/simple;
	bh=Fyi9gAJK1jCM3NaEVV+0u//SMEXi86n0yN+hJ78mCGY=;
	h=Date:To:From:Subject:Message-Id; b=rtAYywo+6xY6RVfffbCPHrnZFCLAEaLWFpgHkk/nkN9clVl3x3YjieFC66olFyscQ61QUoLkOQwb6xgrl/Y/T5oUXYXAROOsxY18IJpVLPI5x1oqQiJdmrKIps3cSovUqWe0PlD1drK02aLcQaPpA9TPw6Nevwfz92ytMyByqOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r3Mjjawi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r3Mjjawi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C05C4CEDD;
	Tue, 14 Jan 2025 06:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837143;
	bh=Fyi9gAJK1jCM3NaEVV+0u//SMEXi86n0yN+hJ78mCGY=;
	h=Date:To:From:Subject:From;
	b=r3MjjawifURGUViI60h1m3lNIArtiZ9jAzquICrOl2VmkuvY59aJRNdiOZV1p/6gu
	 FeyeqW00maL6N38chiHEnenwsv6axWC150PnIpDGFMtcP+NpUjb5m4dHuVVB4L6+As
	 /ZYwbaExzASZIkqSSYV/ZmtbZqEkK5FZzalQJJk8=
Date: Mon, 13 Jan 2025 22:45:43 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch removed from -mm tree
Message-Id: <20250114064543.D6C05C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: asm-generic: pgalloc: provide generic __pgd_{alloc,free}
has been removed from the -mm tree.  Its filename was
     asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: asm-generic: pgalloc: provide generic __pgd_{alloc,free}
Date: Fri, 3 Jan 2025 18:44:14 +0000

We already have a generic implementation of alloc/free up to P4D level, as
well as pgd_free().  Let's finish the work and add a generic PGD-level
alloc helper as well.

Unlike at lower levels, almost all architectures need some specific magic
at PGD level (typically initialising PGD entries), so introducing a
generic pgd_alloc() isn't worth it.  Instead we introduce two new helpers,
__pgd_alloc() and __pgd_free(), and make use of them in the arch-specific
pgd_alloc() and pgd_free() wherever possible.  To accommodate as many arch
as possible, __pgd_alloc() takes a page allocation order.

Because pagetable_alloc() allocates zeroed pages, explicit zeroing in
pgd_alloc() becomes redundant and we can get rid of it.  Some trivial
implementations of pgd_free() also become unnecessary once __pgd_alloc()
is used; remove them.

Another small improvement is consistent accounting of PGD pages by using
GFP_PGTABLE_{USER,KERNEL} as appropriate.

Not all PGD allocations can be handled by the generic helpers.  In
particular, multiple architectures allocate PGDs from a kmem_cache, and
those PGDs may not be page-sized.

Link: https://lkml.kernel.org/r/20250103184415.2744423-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c                  |    2 -
 arch/arc/include/asm/pgalloc.h        |    9 +-------
 arch/arm/mm/pgd.c                     |    8 ++-----
 arch/arm64/mm/pgd.c                   |    4 +--
 arch/csky/include/asm/pgalloc.h       |    2 -
 arch/hexagon/include/asm/pgalloc.h    |    2 -
 arch/loongarch/mm/pgtable.c           |    7 ++----
 arch/m68k/include/asm/sun3_pgalloc.h  |    2 -
 arch/microblaze/include/asm/pgalloc.h |    7 ------
 arch/mips/include/asm/pgalloc.h       |    6 -----
 arch/mips/mm/pgtable.c                |    8 ++-----
 arch/nios2/mm/pgtable.c               |    3 +-
 arch/openrisc/include/asm/pgalloc.h   |    6 +----
 arch/parisc/include/asm/pgalloc.h     |   16 --------------
 arch/riscv/include/asm/pgalloc.h      |    3 --
 arch/um/kernel/mem.c                  |    7 ++----
 arch/x86/mm/pgtable.c                 |   24 +++++++++------------
 arch/xtensa/include/asm/pgalloc.h     |    2 -
 include/asm-generic/pgalloc.h         |   27 +++++++++++++++++++++++-
 19 files changed, 65 insertions(+), 80 deletions(-)

--- a/arch/alpha/mm/init.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/alpha/mm/init.c
@@ -42,7 +42,7 @@ pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *ret, *init;
 
-	ret = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	ret = __pgd_alloc(mm, 0);
 	init = pgd_offset(&init_mm, 0UL);
 	if (ret) {
 #ifdef CONFIG_ALPHA_LARGE_VMALLOC
--- a/arch/arc/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/arc/include/asm/pgalloc.h
@@ -53,19 +53,14 @@ static inline void pmd_populate(struct m
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *ret = (pgd_t *) __get_free_page(GFP_KERNEL);
+	pgd_t *ret = __pgd_alloc(mm, 0);
 
 	if (ret) {
 		int num, num2;
-		num = USER_PTRS_PER_PGD + USER_KERNEL_GUTTER / PGDIR_SIZE;
-		memzero(ret, num * sizeof(pgd_t));
 
+		num = USER_PTRS_PER_PGD + USER_KERNEL_GUTTER / PGDIR_SIZE;
 		num2 = VMALLOC_SIZE / PGDIR_SIZE;
 		memcpy(ret + num, swapper_pg_dir + num, num2 * sizeof(pgd_t));
-
-		memzero(ret + num + num2,
-			       (PTRS_PER_PGD - num - num2) * sizeof(pgd_t));
-
 	}
 	return ret;
 }
--- a/arch/arm64/mm/pgd.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/arm64/mm/pgd.c
@@ -33,7 +33,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	gfp_t gfp = GFP_PGTABLE_USER;
 
 	if (pgdir_is_page_size())
-		return (pgd_t *)__get_free_page(gfp);
+		return __pgd_alloc(mm, 0);
 	else
 		return kmem_cache_alloc(pgd_cache, gfp);
 }
@@ -41,7 +41,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 	if (pgdir_is_page_size())
-		free_page((unsigned long)pgd);
+		__pgd_free(mm, pgd);
 	else
 		kmem_cache_free(pgd_cache, pgd);
 }
--- a/arch/arm/mm/pgd.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/arm/mm/pgd.c
@@ -17,11 +17,11 @@
 #include "mm.h"
 
 #ifdef CONFIG_ARM_LPAE
-#define _pgd_alloc(mm)		kmalloc_array(PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL)
+#define _pgd_alloc(mm)		kmalloc_array(PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL | __GFP_ZERO)
 #define _pgd_free(mm, pgd)	kfree(pgd)
 #else
-#define _pgd_alloc(mm)		(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
-#define _pgd_free(mm, pgd)	free_pages((unsigned long)pgd, 2)
+#define _pgd_alloc(mm)		__pgd_alloc(mm, 2)
+#define _pgd_free(mm, pgd)	__pgd_free(mm, pgd)
 #endif
 
 /*
@@ -39,8 +39,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (!new_pgd)
 		goto no_pgd;
 
-	memset(new_pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
-
 	/*
 	 * Copy over the kernel and IO PGD entries
 	 */
--- a/arch/csky/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/csky/include/asm/pgalloc.h
@@ -44,7 +44,7 @@ static inline pgd_t *pgd_alloc(struct mm
 	pgd_t *ret;
 	pgd_t *init;
 
-	ret = (pgd_t *) __get_free_page(GFP_KERNEL);
+	ret = __pgd_alloc(mm, 0);
 	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init((unsigned long *)ret);
--- a/arch/hexagon/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -22,7 +22,7 @@ static inline pgd_t *pgd_alloc(struct mm
 {
 	pgd_t *pgd;
 
-	pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	pgd = __pgd_alloc(mm, 0);
 
 	/*
 	 * There may be better ways to do this, but to ensure
--- a/arch/loongarch/mm/pgtable.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/loongarch/mm/pgtable.c
@@ -23,11 +23,10 @@ EXPORT_SYMBOL(tlb_virt_to_page);
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *init, *ret = NULL;
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL & ~__GFP_HIGHMEM, 0);
+	pgd_t *init, *ret;
 
-	if (ptdesc) {
-		ret = (pgd_t *)ptdesc_address(ptdesc);
+	ret = __pgd_alloc(mm, 0);
+	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init(ret);
 		memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
--- a/arch/m68k/include/asm/sun3_pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -43,7 +43,7 @@ static inline pgd_t * pgd_alloc(struct m
 {
 	pgd_t *new_pgd;
 
-	new_pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+	new_pgd = __pgd_alloc(mm, 0);
 	memcpy(new_pgd, swapper_pg_dir, PAGE_SIZE);
 	memset(new_pgd, 0, (PAGE_OFFSET >> PGDIR_SHIFT));
 	return new_pgd;
--- a/arch/microblaze/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -21,12 +21,7 @@
 
 extern void __bad_pte(pmd_t *pmd);
 
-static inline pgd_t *get_pgd(void)
-{
-	return (pgd_t *)__get_free_pages(GFP_KERNEL|__GFP_ZERO, 0);
-}
-
-#define pgd_alloc(mm)		get_pgd()
+#define pgd_alloc(mm)		__pgd_alloc(mm, 0)
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
--- a/arch/mips/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/mips/include/asm/pgalloc.h
@@ -15,7 +15,6 @@
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
-#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
@@ -49,11 +48,6 @@ static inline void pud_populate(struct m
 extern void pgd_init(void *addr);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	pagetable_free(virt_to_ptdesc(pgd));
-}
-
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
--- a/arch/mips/mm/pgtable.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/mips/mm/pgtable.c
@@ -10,12 +10,10 @@
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *init, *ret = NULL;
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL & ~__GFP_HIGHMEM,
-			PGD_TABLE_ORDER);
+	pgd_t *init, *ret;
 
-	if (ptdesc) {
-		ret = ptdesc_address(ptdesc);
+	ret = __pgd_alloc(mm, PGD_TABLE_ORDER);
+	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init(ret);
 		memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
--- a/arch/nios2/mm/pgtable.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/nios2/mm/pgtable.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 
 #include <asm/cpuinfo.h>
+#include <asm/pgalloc.h>
 
 /* pteaddr:
  *   ptbase | vpn* | zero
@@ -54,7 +55,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *ret, *init;
 
-	ret = (pgd_t *) __get_free_page(GFP_KERNEL);
+	ret = __pgd_alloc(mm, 0);
 	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init(ret);
--- a/arch/openrisc/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -41,15 +41,13 @@ static inline void pmd_populate(struct m
  */
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *ret = (pgd_t *)__get_free_page(GFP_KERNEL);
+	pgd_t *ret = __pgd_alloc(mm, 0);
 
-	if (ret) {
-		memset(ret, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
+	if (ret)
 		memcpy(ret + USER_PTRS_PER_PGD,
 		       swapper_pg_dir + USER_PTRS_PER_PGD,
 		       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
 
-	}
 	return ret;
 }
 
--- a/arch/parisc/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -11,26 +11,12 @@
 #include <asm/cache.h>
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
-#define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
 /* Allocate the top level pgd (page directory) */
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd;
-
-	pgd = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_TABLE_ORDER);
-	if (unlikely(pgd == NULL))
-		return NULL;
-
-	memset(pgd, 0, PAGE_SIZE << PGD_TABLE_ORDER);
-
-	return pgd;
-}
-
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_pages((unsigned long)pgd, PGD_TABLE_ORDER);
+	return __pgd_alloc(mm, PGD_TABLE_ORDER);
 }
 
 #if CONFIG_PGTABLE_LEVELS == 3
--- a/arch/riscv/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -130,9 +130,8 @@ static inline pgd_t *pgd_alloc(struct mm
 {
 	pgd_t *pgd;
 
-	pgd = (pgd_t *)__get_free_page(GFP_KERNEL);
+	pgd = __pgd_alloc(mm, 0);
 	if (likely(pgd != NULL)) {
-		memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
 		/* Copy kernel mappings */
 		sync_kernel_mappings(pgd);
 	}
--- a/arch/um/kernel/mem.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/um/kernel/mem.c
@@ -214,14 +214,13 @@ void free_initmem(void)
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL);
+	pgd_t *pgd = __pgd_alloc(mm, 0);
 
-	if (pgd) {
-		memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
+	if (pgd)
 		memcpy(pgd + USER_PTRS_PER_PGD,
 		       swapper_pg_dir + USER_PTRS_PER_PGD,
 		       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
-	}
+
 	return pgd;
 }
 
--- a/arch/x86/mm/pgtable.c~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/x86/mm/pgtable.c
@@ -397,15 +397,14 @@ void __init pgtable_cache_init(void)
 				      SLAB_PANIC, NULL);
 }
 
-static inline pgd_t *_pgd_alloc(void)
+static inline pgd_t *_pgd_alloc(struct mm_struct *mm)
 {
 	/*
 	 * If no SHARED_KERNEL_PMD, PAE kernel is running as a Xen domain.
 	 * We allocate one page for pgd.
 	 */
 	if (!SHARED_KERNEL_PMD)
-		return (pgd_t *)__get_free_pages(GFP_PGTABLE_USER,
-						 PGD_ALLOCATION_ORDER);
+		return __pgd_alloc(mm, PGD_ALLOCATION_ORDER);
 
 	/*
 	 * Now PAE kernel is not running as a Xen domain. We can allocate
@@ -414,24 +413,23 @@ static inline pgd_t *_pgd_alloc(void)
 	return kmem_cache_alloc(pgd_cache, GFP_PGTABLE_USER);
 }
 
-static inline void _pgd_free(pgd_t *pgd)
+static inline void _pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 	if (!SHARED_KERNEL_PMD)
-		free_pages((unsigned long)pgd, PGD_ALLOCATION_ORDER);
+		__pgd_free(mm, pgd);
 	else
 		kmem_cache_free(pgd_cache, pgd);
 }
 #else
 
-static inline pgd_t *_pgd_alloc(void)
+static inline pgd_t *_pgd_alloc(struct mm_struct *mm)
 {
-	return (pgd_t *)__get_free_pages(GFP_PGTABLE_USER,
-					 PGD_ALLOCATION_ORDER);
+	return __pgd_alloc(mm, PGD_ALLOCATION_ORDER);
 }
 
-static inline void _pgd_free(pgd_t *pgd)
+static inline void _pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	free_pages((unsigned long)pgd, PGD_ALLOCATION_ORDER);
+	__pgd_free(mm, pgd);
 }
 #endif /* CONFIG_X86_PAE */
 
@@ -441,7 +439,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	pmd_t *u_pmds[MAX_PREALLOCATED_USER_PMDS];
 	pmd_t *pmds[MAX_PREALLOCATED_PMDS];
 
-	pgd = _pgd_alloc();
+	pgd = _pgd_alloc(mm);
 
 	if (pgd == NULL)
 		goto out;
@@ -484,7 +482,7 @@ out_free_pmds:
 	if (sizeof(pmds) != 0)
 		free_pmds(mm, pmds, PREALLOCATED_PMDS);
 out_free_pgd:
-	_pgd_free(pgd);
+	_pgd_free(mm, pgd);
 out:
 	return NULL;
 }
@@ -494,7 +492,7 @@ void pgd_free(struct mm_struct *mm, pgd_
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
-	_pgd_free(pgd);
+	_pgd_free(mm, pgd);
 }
 
 /*
--- a/arch/xtensa/include/asm/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -29,7 +29,7 @@
 static inline pgd_t*
 pgd_alloc(struct mm_struct *mm)
 {
-	return (pgd_t*) __get_free_page(GFP_KERNEL | __GFP_ZERO);
+	return __pgd_alloc(mm, 0);
 }
 
 static inline void ptes_clear(pte_t *ptep)
--- a/include/asm-generic/pgalloc.h~asm-generic-pgalloc-provide-generic-__pgd_allocfree
+++ a/include/asm-generic/pgalloc.h
@@ -258,10 +258,35 @@ static inline void p4d_free(struct mm_st
 
 #endif /* CONFIG_PGTABLE_LEVELS > 4 */
 
+static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order)
+{
+	gfp_t gfp = GFP_PGTABLE_USER;
+	struct ptdesc *ptdesc;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	gfp &= ~__GFP_HIGHMEM;
+
+	ptdesc = pagetable_alloc_noprof(gfp, order);
+	if (!ptdesc)
+		return NULL;
+
+	return ptdesc_address(ptdesc);
+}
+#define __pgd_alloc(...)	alloc_hooks(__pgd_alloc_noprof(__VA_ARGS__))
+
+static inline void __pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(pgd);
+
+	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
+	pagetable_free(ptdesc);
+}
+
 #ifndef __HAVE_ARCH_PGD_FREE
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pagetable_free(virt_to_ptdesc(pgd));
+	__pgd_free(mm, pgd);
 }
 #endif
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


