Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E50C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD8060F9E
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhG0Uo1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhG0Uo1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A895F60F9C;
        Tue, 27 Jul 2021 20:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418666;
        bh=nLyCwY37pRq+h0NVSE2E20t/3UsVL7p2+jfp1tB4Y98=;
        h=Date:From:To:Subject:From;
        b=w5ehakzCvtc5bc3j+Ce3KlAv2YDOp5I1JTL4h3nzYC0ANzp/Ly8z3Cayu8rUCqAg/
         B76SAM3ck819BTc0Zt87wpFW/aosOK9H5EC8IHInLSLHTaKra3cswBBYNnHXkWah9o
         T6mzocgXejgqPojeAUhSYk742Alw0rFR++w4RyFw=
Date:   Tue, 27 Jul 2021 13:44:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
 removed from -mm tree
Message-ID: <20210727204426.zkSDM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PTE modifying tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PTE modifying tests

This uses struct pgtable_debug_args in PTE modifying tests.  The allocated
page is used as set_pte_at() is used there.  The tests are skipped if the
allocated page doesn't exist.  Besides, the unused variable @ptep and
@pte_aligned in debug_vm_pgtable() are dropped.

Link: https://lkml.kernel.org/r/20210719130613.334901-8-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   75 ++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -116,10 +116,7 @@ static void __init pte_basic_tests(struc
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
 }
 
-static void __init pte_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pte_t *ptep,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+static void __init pte_advanced_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte;
 
@@ -130,33 +127,38 @@ static void __init pte_advanced_tests(st
 	 */
 
 	pr_debug("Validating PTE advanced\n");
-	pte = pfn_pte(pfn, prot);
-	set_pte_at(mm, vaddr, ptep, pte);
-	ptep_set_wrprotect(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
+	if (args->pte_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
+
+	pte = pfn_pte(args->pte_pfn, args->page_prot);
+	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	ptep_set_wrprotect(args->mm, args->vaddr, args->ptep);
+	pte = ptep_get(args->ptep);
 	WARN_ON(pte_write(pte));
-	ptep_get_and_clear(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
+	ptep_get_and_clear(args->mm, args->vaddr, args->ptep);
+	pte = ptep_get(args->ptep);
 	WARN_ON(!pte_none(pte));
 
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	pte = pte_wrprotect(pte);
 	pte = pte_mkclean(pte);
-	set_pte_at(mm, vaddr, ptep, pte);
+	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
 	pte = pte_mkwrite(pte);
 	pte = pte_mkdirty(pte);
-	ptep_set_access_flags(vma, vaddr, ptep, pte, 1);
-	pte = ptep_get(ptep);
+	ptep_set_access_flags(args->vma, args->vaddr, args->ptep, pte, 1);
+	pte = ptep_get(args->ptep);
 	WARN_ON(!(pte_write(pte) && pte_dirty(pte)));
-	ptep_get_and_clear_full(mm, vaddr, ptep, 1);
-	pte = ptep_get(ptep);
+	ptep_get_and_clear_full(args->mm, args->vaddr, args->ptep, 1);
+	pte = ptep_get(args->ptep);
 	WARN_ON(!pte_none(pte));
 
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	pte = pte_mkyoung(pte);
-	set_pte_at(mm, vaddr, ptep, pte);
-	ptep_test_and_clear_young(vma, vaddr, ptep);
-	pte = ptep_get(ptep);
+	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	ptep_test_and_clear_young(args->vma, args->vaddr, args->ptep);
+	pte = ptep_get(args->ptep);
 	WARN_ON(pte_young(pte));
 }
 
@@ -617,20 +619,24 @@ static void __init pgd_populate_tests(st
 }
 #endif /* PAGETABLE_P4D_FOLDED */
 
-static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
-				   unsigned long pfn, unsigned long vaddr,
-				   pgprot_t prot)
+static void __init pte_clear_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte;
 
 	pr_debug("Validating PTE clear\n");
+	if (args->pte_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
+
+	pte = pfn_pte(args->pte_pfn, args->page_prot);
 #ifndef CONFIG_RISCV
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 #endif
-	set_pte_at(mm, vaddr, ptep, pte);
+	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
 	barrier();
-	pte_clear(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
+	pte_clear(args->mm, args->vaddr, args->ptep);
+	pte = ptep_get(args->ptep);
 	WARN_ON(!pte_none(pte));
 }
 
@@ -1150,11 +1156,10 @@ static int __init debug_vm_pgtable(void)
 	p4d_t *p4dp, *saved_p4dp;
 	pud_t *pudp, *saved_pudp;
 	pmd_t *pmdp, *saved_pmdp, pmd;
-	pte_t *ptep;
 	pgtable_t saved_ptep;
 	pgprot_t prot;
 	phys_addr_t paddr;
-	unsigned long vaddr, pte_aligned, pmd_aligned;
+	unsigned long vaddr, pmd_aligned;
 	unsigned long pud_aligned;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
@@ -1189,10 +1194,8 @@ static int __init debug_vm_pgtable(void)
 	 */
 	paddr = __pa_symbol(&start_kernel);
 
-	pte_aligned = (paddr & PAGE_MASK) >> PAGE_SHIFT;
 	pmd_aligned = (paddr & PMD_MASK) >> PAGE_SHIFT;
 	pud_aligned = (paddr & PUD_MASK) >> PAGE_SHIFT;
-	WARN_ON(!pfn_valid(pte_aligned));
 
 	pgdp = pgd_offset(mm, vaddr);
 	p4dp = p4d_alloc(mm, pgdp, vaddr);
@@ -1272,11 +1275,11 @@ static int __init debug_vm_pgtable(void)
 	 * Page table modifying tests. They need to hold
 	 * proper page table lock.
 	 */
-
-	ptep = pte_offset_map_lock(mm, pmdp, vaddr, &ptl);
-	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
-	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-	pte_unmap_unlock(ptep, ptl);
+	ptl = pte_lockptr(args.mm, args.pmdp);
+	spin_lock(ptl);
+	pte_clear_tests(&args);
+	pte_advanced_tests(&args);
+	spin_unlock(ptl);
 
 	ptl = pmd_lock(mm, pmdp);
 	pmd_clear_tests(mm, pmdp);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

