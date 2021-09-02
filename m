Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4156FC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F002610FD
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347765AbhIBVxt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347784AbhIBVxo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A9B60724;
        Thu,  2 Sep 2021 21:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619565;
        bh=qX/6USi2CHfe04MysNWeDNwOkUrXKQz0PbVQalZ5I+U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ne9W2R9pcy2h83ZwmqBINEUL5qQARtOd3blqMy609MjDHNjbPbsoaXeLToBrOztL4
         q8WRywSdQvzYpMPXEt2jnvxx+bM2m6kUbTqsxh9kRT31nK6s5En9d7jP62Jz78ykMc
         oPCHmLyihGpMJwOEj2YZc4CyprSMm+OPWPaChINQ=
Date:   Thu, 02 Sep 2021 14:52:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, cai@lca.pw, catalin.marinas@arm.com,
        christophe.leroy@csgroup.eu, chuhu@redhat.com,
        gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 052/212] mm/debug_vm_pgtable: use struct
 pgtable_debug_args in PUD modifying tests
Message-ID: <20210902215245.EBN-DnQx8%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PUD modifying tests

This uses struct pgtable_debug_args in PUD modifying tests.  The allocated
huge page is used when set_pud_at() is used.  The corresponding tests are
skipped if the huge page doesn't exist.  Besides, the following unused
variables in debug_vm_pgtable() are dropped: @prot, @paddr, @pud_aligned.

Link: https://lkml.kernel.org/r/20210809092631.1888748-10-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>	[powerpc 8xx]
Tested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>	[s390]
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  126 +++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 78 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -337,55 +337,56 @@ static void __init pud_basic_tests(struc
 	WARN_ON(!pud_bad(pud_mkhuge(pud)));
 }
 
-static void __init pud_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pud_t *pudp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+static void __init pud_advanced_tests(struct pgtable_debug_args *args)
 {
+	unsigned long vaddr = args->vaddr;
 	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
 
+	if (args->pud_pfn == ULONG_MAX)
+		return;
+
 	pr_debug("Validating PUD advanced\n");
 	/* Align the address wrt HPAGE_PUD_SIZE */
 	vaddr &= HPAGE_PUD_MASK;
 
-	pud = pfn_pud(pfn, prot);
-	set_pud_at(mm, vaddr, pudp, pud);
-	pudp_set_wrprotect(mm, vaddr, pudp);
-	pud = READ_ONCE(*pudp);
+	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	pudp_set_wrprotect(args->mm, vaddr, args->pudp);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(pud_write(pud));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pudp_huge_get_and_clear(mm, vaddr, pudp);
-	pud = READ_ONCE(*pudp);
+	pudp_huge_get_and_clear(args->mm, vaddr, args->pudp);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->pud_pfn, args->page_prot);
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
-	set_pud_at(mm, vaddr, pudp, pud);
+	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	pud = pud_mkwrite(pud);
 	pud = pud_mkdirty(pud);
-	pudp_set_access_flags(vma, vaddr, pudp, pud, 1);
-	pud = READ_ONCE(*pudp);
+	pudp_set_access_flags(args->vma, vaddr, args->pudp, pud, 1);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!(pud_write(pud) && pud_dirty(pud)));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pudp_huge_get_and_clear_full(mm, vaddr, pudp, 1);
-	pud = READ_ONCE(*pudp);
+	pudp_huge_get_and_clear_full(args->mm, vaddr, args->pudp, 1);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->pud_pfn, args->page_prot);
 	pud = pud_mkyoung(pud);
-	set_pud_at(mm, vaddr, pudp, pud);
-	pudp_test_and_clear_young(vma, vaddr, pudp);
-	pud = READ_ONCE(*pudp);
+	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	pudp_test_and_clear_young(args->vma, vaddr, args->pudp);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(pud_young(pud));
 
-	pudp_huge_get_and_clear(mm, vaddr, pudp);
+	pudp_huge_get_and_clear(args->mm, vaddr, args->pudp);
 }
 
 static void __init pud_leaf_tests(struct pgtable_debug_args *args)
@@ -405,24 +406,14 @@ static void __init pud_leaf_tests(struct
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx) { }
-static void __init pud_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pud_t *pudp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
-{
-}
+static void __init pud_advanced_tests(struct pgtable_debug_args *args) { }
 static void __init pud_leaf_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx) { }
 static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx) { }
 static void __init pmd_advanced_tests(struct pgtable_debug_args *args) { }
-static void __init pud_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pud_t *pudp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
-{
-}
+static void __init pud_advanced_tests(struct pgtable_debug_args *args) { }
 static void __init pmd_leaf_tests(struct pgtable_debug_args *args) { }
 static void __init pud_leaf_tests(struct pgtable_debug_args *args) { }
 static void __init pmd_savedwrite_tests(struct pgtable_debug_args *args) { }
@@ -448,11 +439,11 @@ static void __init pmd_huge_tests(struct
 	WARN_ON(!pmd_none(pmd));
 }
 
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
+static void __init pud_huge_tests(struct pgtable_debug_args *args)
 {
 	pud_t pud;
 
-	if (!arch_vmap_pud_supported(prot))
+	if (!arch_vmap_pud_supported(args->page_prot))
 		return;
 
 	pr_debug("Validating PUD huge\n");
@@ -460,15 +451,15 @@ static void __init pud_huge_tests(pud_t
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*pudp, __pud(0));
-	WARN_ON(!pud_set_huge(pudp, __pfn_to_phys(pfn), prot));
-	WARN_ON(!pud_clear_huge(pudp));
-	pud = READ_ONCE(*pudp);
+	WRITE_ONCE(*args->pudp, __pud(0));
+	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
+	WARN_ON(!pud_clear_huge(args->pudp));
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
 }
 #else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
 static void __init pmd_huge_tests(struct pgtable_debug_args *args) { }
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
+static void __init pud_huge_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 static void __init p4d_basic_tests(struct pgtable_debug_args *args)
@@ -490,27 +481,26 @@ static void __init pgd_basic_tests(struc
 }
 
 #ifndef __PAGETABLE_PUD_FOLDED
-static void __init pud_clear_tests(struct mm_struct *mm, pud_t *pudp)
+static void __init pud_clear_tests(struct pgtable_debug_args *args)
 {
-	pud_t pud = READ_ONCE(*pudp);
+	pud_t pud = READ_ONCE(*args->pudp);
 
-	if (mm_pmd_folded(mm))
+	if (mm_pmd_folded(args->mm))
 		return;
 
 	pr_debug("Validating PUD clear\n");
 	pud = __pud(pud_val(pud) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pudp, pud);
-	pud_clear(pudp);
-	pud = READ_ONCE(*pudp);
+	WRITE_ONCE(*args->pudp, pud);
+	pud_clear(args->pudp);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
 }
 
-static void __init pud_populate_tests(struct mm_struct *mm, pud_t *pudp,
-				      pmd_t *pmdp)
+static void __init pud_populate_tests(struct pgtable_debug_args *args)
 {
 	pud_t pud;
 
-	if (mm_pmd_folded(mm))
+	if (mm_pmd_folded(args->mm))
 		return;
 
 	pr_debug("Validating PUD populate\n");
@@ -518,16 +508,13 @@ static void __init pud_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pud_bad().
 	 */
-	pud_populate(mm, pudp, pmdp);
-	pud = READ_ONCE(*pudp);
+	pud_populate(args->mm, args->pudp, args->start_pmdp);
+	pud = READ_ONCE(*args->pudp);
 	WARN_ON(pud_bad(pud));
 }
 #else  /* !__PAGETABLE_PUD_FOLDED */
-static void __init pud_clear_tests(struct mm_struct *mm, pud_t *pudp) { }
-static void __init pud_populate_tests(struct mm_struct *mm, pud_t *pudp,
-				      pmd_t *pmdp)
-{
-}
+static void __init pud_clear_tests(struct pgtable_debug_args *args) { }
+static void __init pud_populate_tests(struct pgtable_debug_args *args) { }
 #endif /* PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_P4D_FOLDED
@@ -1217,10 +1204,7 @@ static int __init debug_vm_pgtable(void)
 	pud_t *pudp, *saved_pudp;
 	pmd_t *pmdp, *saved_pmdp, pmd;
 	pgtable_t saved_ptep;
-	pgprot_t prot;
-	phys_addr_t paddr;
 	unsigned long vaddr;
-	unsigned long pud_aligned;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
 
@@ -1229,7 +1213,6 @@ static int __init debug_vm_pgtable(void)
 	if (ret)
 		return ret;
 
-	prot = vm_get_page_prot(VMFLAGS);
 	vaddr = get_random_vaddr();
 	mm = mm_alloc();
 	if (!mm) {
@@ -1243,19 +1226,6 @@ static int __init debug_vm_pgtable(void)
 		return 1;
 	}
 
-	/*
-	 * PFN for mapping at PTE level is determined from a standard kernel
-	 * text symbol. But pfns for higher page table levels are derived by
-	 * masking lower bits of this real pfn. These derived pfns might not
-	 * exist on the platform but that does not really matter as pfn_pxx()
-	 * helpers will still create appropriate entries for the test. This
-	 * helps avoid large memory block allocations to be used for mapping
-	 * at higher page table levels.
-	 */
-	paddr = __pa_symbol(&start_kernel);
-
-	pud_aligned = (paddr & PUD_MASK) >> PAGE_SHIFT;
-
 	pgdp = pgd_offset(mm, vaddr);
 	p4dp = p4d_alloc(mm, pgdp, vaddr);
 	pudp = pud_alloc(mm, p4dp, vaddr);
@@ -1348,11 +1318,11 @@ static int __init debug_vm_pgtable(void)
 	pmd_populate_tests(&args);
 	spin_unlock(ptl);
 
-	ptl = pud_lock(mm, pudp);
-	pud_clear_tests(mm, pudp);
-	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
-	pud_huge_tests(pudp, pud_aligned, prot);
-	pud_populate_tests(mm, pudp, saved_pmdp);
+	ptl = pud_lock(args.mm, args.pudp);
+	pud_clear_tests(&args);
+	pud_advanced_tests(&args);
+	pud_huge_tests(&args);
+	pud_populate_tests(&args);
 	spin_unlock(ptl);
 
 	spin_lock(&mm->page_table_lock);
_
