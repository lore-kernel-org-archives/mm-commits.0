Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4224AC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 17:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20541610E7
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 17:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbhHIR7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236036AbhHIR5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 13:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3B236101D;
        Mon,  9 Aug 2021 17:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628531852;
        bh=1MWU3X0xmV9yoAHG84VKHnCCxwk8Sx6xQPg/F2Qxrn0=;
        h=Date:From:To:Subject:From;
        b=u4WexCyQw6uYjguvI71g6R08eBJ+sT2UkNjRLE6J8289TFE52xhijyFT/NsvOsIkR
         XtPRfv2a9vsewmywxxv+jAOSf+y+XSBeaFLSYjJJiOMJynixH9DaTPyt2ao4RMA74N
         O0v4NeoQ2Pn+qY46PTe5vktEWLZR5FSxHDLL97/c=
Date:   Mon, 09 Aug 2021 10:57:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-basic-tests.patch
 removed from -mm tree
Message-ID: <20210809175731.FxKT8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in basic tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-basic-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in basic tests

This uses struct pgtable_debug_args in the basic test functions.  The
unused variables @pgd_aligned and @p4d_aligned in debug_vm_pgtable() are
dropped.

Link: https://lkml.kernel.org/r/20210802060419.1360913-3-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   50 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-basic-tests
+++ a/mm/debug_vm_pgtable.c
@@ -89,10 +89,10 @@ struct pgtable_debug_args {
 	unsigned long		fixed_pte_pfn;
 };
 
-static void __init pte_basic_tests(unsigned long pfn, int idx)
+static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
 {
 	pgprot_t prot = protection_map[idx];
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, prot);
 	unsigned long val = idx, *ptr = &val;
 
 	pr_debug("Validating PTE basic (%pGv)\n", ptr);
@@ -174,7 +174,7 @@ static void __init pte_savedwrite_tests(
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_basic_tests(unsigned long pfn, int idx)
+static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 {
 	pgprot_t prot = protection_map[idx];
 	unsigned long val = idx, *ptr = &val;
@@ -184,7 +184,7 @@ static void __init pmd_basic_tests(unsig
 		return;
 
 	pr_debug("Validating PMD basic (%pGv)\n", ptr);
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, prot);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -296,7 +296,7 @@ static void __init pmd_savedwrite_tests(
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx)
+static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx)
 {
 	pgprot_t prot = protection_map[idx];
 	unsigned long val = idx, *ptr = &val;
@@ -306,7 +306,7 @@ static void __init pud_basic_tests(struc
 		return;
 
 	pr_debug("Validating PUD basic (%pGv)\n", ptr);
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->fixed_pud_pfn, prot);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -327,7 +327,7 @@ static void __init pud_basic_tests(struc
 	WARN_ON(pud_dirty(pud_wrprotect(pud_mkclean(pud))));
 	WARN_ON(!pud_dirty(pud_wrprotect(pud_mkdirty(pud))));
 
-	if (mm_pmd_folded(mm))
+	if (mm_pmd_folded(args->mm))
 		return;
 
 	/*
@@ -404,7 +404,7 @@ static void __init pud_leaf_tests(unsign
 	WARN_ON(!pud_leaf(pud));
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
+static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pud_t *pudp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -414,8 +414,8 @@ static void __init pud_advanced_tests(st
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_basic_tests(unsigned long pfn, int idx) { }
-static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
+static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx) { }
+static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx) { }
 static void __init pmd_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pmd_t *pmdp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -476,7 +476,7 @@ static void __init pmd_huge_tests(pmd_t
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
-static void __init p4d_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init p4d_basic_tests(struct pgtable_debug_args *args)
 {
 	p4d_t p4d;
 
@@ -485,7 +485,7 @@ static void __init p4d_basic_tests(unsig
 	WARN_ON(!p4d_same(p4d, p4d));
 }
 
-static void __init pgd_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init pgd_basic_tests(struct pgtable_debug_args *args)
 {
 	pgd_t pgd;
 
@@ -890,7 +890,7 @@ static void __init swap_migration_tests(
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init hugetlb_basic_tests(struct pgtable_debug_args *args)
 {
 	struct page *page;
 	pte_t pte;
@@ -900,21 +900,21 @@ static void __init hugetlb_basic_tests(u
 	 * Accessing the page associated with the pfn is safe here,
 	 * as it was previously derived from a real kernel symbol.
 	 */
-	page = pfn_to_page(pfn);
-	pte = mk_huge_pte(page, prot);
+	page = pfn_to_page(args->fixed_pmd_pfn);
+	pte = mk_huge_pte(page, args->page_prot);
 
 	WARN_ON(!huge_pte_dirty(huge_pte_mkdirty(pte)));
 	WARN_ON(!huge_pte_write(huge_pte_mkwrite(huge_pte_wrprotect(pte))));
 	WARN_ON(huge_pte_write(huge_pte_wrprotect(huge_pte_mkwrite(pte))));
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(args->fixed_pmd_pfn, args->page_prot);
 
 	WARN_ON(!pte_huge(pte_mkhuge(pte)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
 #else  /* !CONFIG_HUGETLB_PAGE */
-static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init hugetlb_basic_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1229,7 +1229,7 @@ static int __init debug_vm_pgtable(void)
 	pgprot_t prot, protnone;
 	phys_addr_t paddr;
 	unsigned long vaddr, pte_aligned, pmd_aligned;
-	unsigned long pud_aligned, p4d_aligned, pgd_aligned;
+	unsigned long pud_aligned;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
 
@@ -1272,8 +1272,6 @@ static int __init debug_vm_pgtable(void)
 	pte_aligned = (paddr & PAGE_MASK) >> PAGE_SHIFT;
 	pmd_aligned = (paddr & PMD_MASK) >> PAGE_SHIFT;
 	pud_aligned = (paddr & PUD_MASK) >> PAGE_SHIFT;
-	p4d_aligned = (paddr & P4D_MASK) >> PAGE_SHIFT;
-	pgd_aligned = (paddr & PGDIR_MASK) >> PAGE_SHIFT;
 	WARN_ON(!pfn_valid(pte_aligned));
 
 	pgdp = pgd_offset(mm, vaddr);
@@ -1307,9 +1305,9 @@ static int __init debug_vm_pgtable(void)
 	 * given page table entry.
 	 */
 	for (idx = 0; idx < ARRAY_SIZE(protection_map); idx++) {
-		pte_basic_tests(pte_aligned, idx);
-		pmd_basic_tests(pmd_aligned, idx);
-		pud_basic_tests(mm, pud_aligned, idx);
+		pte_basic_tests(&args, idx);
+		pmd_basic_tests(&args, idx);
+		pud_basic_tests(&args, idx);
 	}
 
 	/*
@@ -1319,8 +1317,8 @@ static int __init debug_vm_pgtable(void)
 	 * the above iteration for now to save some test execution
 	 * time.
 	 */
-	p4d_basic_tests(p4d_aligned, prot);
-	pgd_basic_tests(pgd_aligned, prot);
+	p4d_basic_tests(&args);
+	pgd_basic_tests(&args);
 
 	pmd_leaf_tests(pmd_aligned, prot);
 	pud_leaf_tests(pud_aligned, prot);
@@ -1349,7 +1347,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_thp_tests(pmd_aligned, prot);
 	pud_thp_tests(pud_aligned, prot);
 
-	hugetlb_basic_tests(pte_aligned, prot);
+	hugetlb_basic_tests(&args);
 
 	/*
 	 * Page table modifying tests. They need to hold
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-leaf-and-savewrite-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-protnone-and-devmap-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

