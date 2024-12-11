Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8279E22C363
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733924095; cv=none; b=gBSrq9pXWk1C1hbayUhpi7+kwoJUlKqndKuH+vv6s2x/fGGmU89yn1GqwBNY2Zwd1nzjFFC1AvHK9UgW12ymtV8jaKg3rQjQ5H7qxGfmE3JJqbQZtSQGPM8W+Lyr8n0EfglDNf8wYLGh34ij9PRJrkejngv0RyDkiHDPVS0FSC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733924095; c=relaxed/simple;
	bh=bUaqbjF4ESbV2fGtpVDiC88Ce30Eb/S+3ZTEyxU7KBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ly4QnXkv6K8tCWSV2FFumXTlMthc9bBdjw0hotItm4lso8yCn0zWYRyo+HLxaly7wSuPnewg2BnucCXGkGCwNQ5aTHW21BbbHXTJvttxqEfXLDdDEjrotW8ofBKFcsrZnwyei7NCG5fEZKf+VqzcX5q9QEgOiEKiAbFQBvLaFzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B1RgFci2; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1RgFci2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i9GiDd7mV5we7tJcf6kZD3utqj/HKfk4Jm9PeyRyBpw=; b=B1RgFci2vlIIve+2LNjN0RaYQn
	wiZI1z/mCmCdYBy9AcmePSQ07kmzidoqeq7ivoeEX4UlWyHJuzCV7Viyc7ryJGM7Kxlt323XRcv4W
	JSkETjheaJcCnr3121ZZiZCYw15oRSgM7toHWrFUj0pvpvH4MQzy4idxj9/bjscbkYM+rrUDcskPT
	HhZzx+SRI3rgEqtTEg8x0rMbCgigEPbHA7CFVKxehTfWpS8rN4eFCY7+vUHOi6Ci2Z36Qik+1sK3U
	/459AwWl3UKAx4f9Fzmwnser/6RkTqLDOpIZBPC4ZNNCzEVsBlNBfHV4G5xdIpuQNrQXoYS9CMgyx
	7Gu/9Wug==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLMrL-00000003pUH-0IaU;
	Wed, 11 Dec 2024 13:34:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E246230035F; Wed, 11 Dec 2024 14:34:33 +0100 (CET)
Date: Wed, 11 Dec 2024 14:34:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	zokeefe@google.com, willy@infradead.org, will@kernel.org,
	rientjes@google.com, peterx@redhat.com, muchun.song@linux.dev,
	mgorman@suse.de, luto@kernel.org, lorenzo.stoakes@oracle.com,
	jannh@google.com, hughd@google.com, david@redhat.com,
	dave.hansen@linux.intel.com, dan.carpenter@linaro.org,
	catalin.marinas@arm.com, Thomas Gleixner <tglx@linutronix.de>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: + mm-pgtable-make-ptlock-be-freed-by-rcu.patch added to
 mm-unstable branch
Message-ID: <20241211133433.GC12500@noisy.programming.kicks-ass.net>
References: <20241211030932.4DA94C4CED6@smtp.kernel.org>
 <20241211091202.GS21636@noisy.programming.kicks-ass.net>
 <e8ec5fa7-8742-4e30-afbf-279d09c49d6c@bytedance.com>
 <20241211125630.GT21636@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211125630.GT21636@noisy.programming.kicks-ass.net>

On Wed, Dec 11, 2024 at 01:56:30PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 11, 2024 at 06:31:31PM +0800, Qi Zheng wrote:
> 
> > Now, it is also possible not to use the mmu gather mechanism to
> > free PTE pages:
> > 
> > pte_free_tlb
> > --> ___pte_free_tlb
> >     --> pagetable_pte_dtor
> > 	--> ptlock_free
> >         paravirt_tlb_remove_table
> > 	--> free PTE page
> > 
> > pte_free
> > --> pagetable_pte_dtor
> >     --> ptlock_free
> >     pagetable_free
> > 
> > If we want to move the freeing of the ptlock into __tlb_remove_table(),
> > we may need to define a pagetable_pte_dtor_no_ptlock() and let
> > ___pte_free_tlb() to call it.
> > 
> > And ALLOC_SPLIT_PTLOCKS only be enabled when the spinlock debug function
> > is turned on, so I finally choose to only change ptlock itself without
> > changing the general path.
> 
> PREEMPT_RT will also have it on, and it feels a bit odd to have two
> disparate RCU frees for something so very closely related.
> 
> We could push the whole of pagetable_*_dtor into tlb_remove_table(),
> except that seems to cause trouble for p4d, which is not conforming.
> 
> Argh, all this is a giant trainwreck and needs some serious cleanup, and
> I feel your patch is just making it worse.
> 
> Notably:
> 
>  - s390 pud isn't calling the existing pagetable_pud_[cd]tor()
>  - none of the p4d things have pagetable_p4d_[cd]tor() (x86,arm64,s390,riscv)
>    and they have inconsistent accounting
>  - while much of the _ctor calls are in generic code, many of the _dtor
>    calls are in arch code for hysterial raisins, this could easily be
>    fixed
>  - if we fix ptlock_free() to handle NULL, then all the _dtor()
>    functions can use it, and we can observe they're all identical
>    and can be folded
> 
> after all that cleanup, you can move the _dtor from *_free_tlb() into
> tlb_remove_table() -- which for the above case, would then have it
> called from __tlb_remove_table_free().
> 
> Thomas, you were looking for technical debt -- there's a ton of that
> around here :/

Some of the above are in the below... I gave up after a while.

---

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index e75422864d1b..62c4f1e5cc24 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -15,6 +15,8 @@
 
 #define __HAVE_ARCH_PGD_FREE
 #define __HAVE_ARCH_PUD_FREE
+#define __HAVE_ARCH_P4D_FREE
+#define __HAVE_ARCH_P4D_ALLOC
 #include <asm-generic/pgalloc.h>
 
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
@@ -87,22 +89,19 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgdp, p4d_t *p4dp)
 
 static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	gfp_t gfp = GFP_PGTABLE_USER;
+	if (pgtable_l5_enabled())
+		return __p4d_alloc_one(mm, addr);
 
-	if (mm == &init_mm)
-		gfp = GFP_PGTABLE_KERNEL;
-	return (p4d_t *)get_zeroed_page(gfp);
+	return NULL;
 }
 
 static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 {
 	if (!pgtable_l5_enabled())
 		return;
-	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	free_page((unsigned long)p4d);
+	__p4d_free(mm, p4d);
 }
 
-#define __p4d_free_tlb(tlb, p4d, addr)  p4d_free((tlb)->mm, p4d)
 #else
 static inline void __pgd_populate(pgd_t *pgdp, phys_addr_t p4dp, pgdval_t prot)
 {
diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index a947c6e784ed..777b130134e0 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -111,4 +111,18 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pudp,
 }
 #endif
 
+#if CONFIG_PGTABLE_LEVELS > 4
+static inline void __p4d_free_tlb(struct mmu_gather *tlb, pud_t *pudp,
+				  unsigned long addr)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(pudp);
+
+	if (!pgtable_l5_enabled())
+		return;
+
+	pagetable_p4d_dtor(ptdesc);
+	tlb_remove_ptdesc(tlb, ptdesc);
+}
+#endif
+
 #endif
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index f52264304f77..065b5517c99b 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -14,6 +14,8 @@
 #ifdef CONFIG_MMU
 #define __HAVE_ARCH_PUD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_FREE
+#define __HAVE_ARCH_P4D_ALLOC_ONE
+#define __HAVE_ARCH_P4D_FREE
 #include <asm-generic/pgalloc.h>
 
 static inline void riscv_tlb_remove_ptdesc(struct mmu_gather *tlb, void *pt)
@@ -118,23 +120,12 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 #define p4d_alloc_one p4d_alloc_one
 static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	if (pgtable_l5_enabled) {
-		gfp_t gfp = GFP_PGTABLE_USER;
-
-		if (mm == &init_mm)
-			gfp = GFP_PGTABLE_KERNEL;
-		return (p4d_t *)get_zeroed_page(gfp);
-	}
+	if (pgtable_l5_enabled)
+		return __p4d_alloc_one(mm, addr);
 
 	return NULL;
 }
 
-static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
-{
-	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	free_page((unsigned long)p4d);
-}
-
 #define p4d_free p4d_free
 static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 {
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index dcd836b59beb..6fd31c34f2b1 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -8,6 +8,8 @@
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE
 #define __HAVE_ARCH_PGD_FREE
+#define __HAVE_ARCH_P4D_ALLOC_ONE
+#define __HAVE_ARCH_P4D_FREE
 #include <asm-generic/pgalloc.h>
 
 static inline int  __paravirt_pgd_alloc(struct mm_struct *mm) { return 0; }
@@ -147,13 +149,13 @@ static inline void pgd_populate_safe(struct mm_struct *mm, pgd_t *pgd, p4d_t *p4
 	set_pgd_safe(pgd, __pgd(_PAGE_TABLE | __pa(p4d)));
 }
 
+
 static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	gfp_t gfp = GFP_KERNEL_ACCOUNT;
+	if (pgtable_l5_enabled())
+		return __p4d_alloc_one(mm, addr);
 
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
-	return (p4d_t *)get_zeroed_page(gfp);
+	return NULL;
 }
 
 static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
@@ -161,8 +163,7 @@ static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 	if (!pgtable_l5_enabled())
 		return;
 
-	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	free_page((unsigned long)p4d);
+	__p4d_free(mm, p4d);
 }
 
 extern void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d);
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 7c48f5fbf8aa..21c7ddb73660 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -215,6 +215,61 @@ static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 
 #endif /* CONFIG_PGTABLE_LEVELS > 3 */
 
+#if CONFIG_PGTABLE_LEVELS > 4
+
+static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
+{
+	gfp_t gfp = GFP_PGTABLE_USER;
+	struct ptdesc *ptdesc;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	gfp &= ~__GFP_HIGHMEM;
+
+	ptdesc = pagetable_alloc_noprof(gfp, 0);
+	if (!ptdesc)
+		return NULL;
+
+	pagetable_p4d_ctor(ptdesc);
+	return ptdesc_address(ptdesc);
+}
+#define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
+
+#ifndef __HAVE_ARCH_P4D_ALLOC_ONE
+/**
+ * p4d_alloc_one - allocate memory for a PUD-level page table
+ * @mm: the mm_struct of the current context
+ *
+ * Allocate memory for a page table using %GFP_PGTABLE_USER for user context
+ * and %GFP_PGTABLE_KERNEL for kernel context.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+static inline p4d_t *p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
+{
+	return __p4d_alloc_one_noprof(mm, addr);
+}
+#define p4d_alloc_one(...)	alloc_hooks(p4d_alloc_one_noprof(__VA_ARGS__))
+#endif
+
+static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
+
+	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
+	pagetable_p4d_dtor(ptdesc);
+	pagetable_free(ptdesc);
+}
+
+#ifndef __HAVE_ARCH_P4D_FREE
+static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
+{
+	__p4d_free(mm, p4d);
+}
+#endif
+
+#endif /* CONFIG_PGTABLE_LEVELS > 4 */
+
 #ifndef __HAVE_ARCH_PGD_FREE
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c39c4945946c..49833cb0395c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3001,7 +3001,7 @@ static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 	return true;
 }
 
-static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
@@ -3010,6 +3010,11 @@ static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+{
+	pagetable_dtor(ptdesc);
+}
+
 pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
@@ -3077,14 +3082,6 @@ static inline bool pmd_ptlock_init(struct ptdesc *ptdesc)
 	return ptlock_init(ptdesc);
 }
 
-static inline void pmd_ptlock_free(struct ptdesc *ptdesc)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON_PAGE(ptdesc->pmd_huge_pte, ptdesc_page(ptdesc));
-#endif
-	ptlock_free(ptdesc);
-}
-
 #define pmd_huge_pte(mm, pmd) (pmd_ptdesc(pmd)->pmd_huge_pte)
 
 #else
@@ -3095,7 +3092,6 @@ static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 }
 
 static inline bool pmd_ptlock_init(struct ptdesc *ptdesc) { return true; }
-static inline void pmd_ptlock_free(struct ptdesc *ptdesc) {}
 
 #define pmd_huge_pte(mm, pmd) ((mm)->pmd_huge_pte)
 
@@ -3121,11 +3117,7 @@ static inline bool pagetable_pmd_ctor(struct ptdesc *ptdesc)
 
 static inline void pagetable_pmd_dtor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
-	pmd_ptlock_free(ptdesc);
-	__folio_clear_pgtable(folio);
-	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+	pagetable_dtor(ptdesc);
 }
 
 /*
@@ -3156,11 +3148,21 @@ static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 }
 
 static inline void pagetable_pud_dtor(struct ptdesc *ptdesc)
+{
+	pagetable_dtor(ptdesc);
+}
+
+static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	__folio_clear_pgtable(folio);
-	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
+static inline void pagetable_p4d_dtor(struct ptdesc *ptdesc)
+{
+	pagetable_dtor(ptdesc);
 }
 
 extern void __init pagecache_init(void);
diff --git a/mm/memory.c b/mm/memory.c
index 75c2dfd04f72..ba19d34769b5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6959,7 +6959,8 @@ bool ptlock_alloc(struct ptdesc *ptdesc)
 
 void ptlock_free(struct ptdesc *ptdesc)
 {
-	kmem_cache_free(page_ptl_cachep, ptdesc->ptl);
+	if (ptdesc->ptl)
+		kmem_cache_free(page_ptl_cachep, ptdesc->ptl);
 }
 #endif
 
