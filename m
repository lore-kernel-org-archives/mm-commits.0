Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D3AC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C7761019
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhGTV3Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232345AbhGTV3E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D33C361208;
        Tue, 20 Jul 2021 22:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626818970;
        bh=Fy/bBD7c0Vz4ASbD3JzXt3gsgd23sA9FX2OICOAxo0U=;
        h=Date:From:To:Subject:From;
        b=R3PolktsiyOgTal21r0oOgGAtv11HwImz3FaVudorTxM/gqOrmLVkNTGKb/MM5XQC
         oakNckNtyLntylEdTc0yOVYx2UZLt4NaPNhcsADmCz5tU19ffpQSLyteN477J2VSnZ
         59JQQPRzEhrN/1GYADEZE+PxWUiDhmuc65MjySYo=
Date:   Tue, 20 Jul 2021 15:09:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pmd-modifying-tests.patch
 removed from -mm tree
Message-ID: <20210720220929.bFO6U%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in PMD modifying tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pmd-modifying-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in PMD modifying tests

This uses struct vm_pgtable_debug in PMD modifying tests.  The allocated
huge page is used when set_pmd_at() is used.  The corresponding tests are
skipped if the huge page doesn't exist.

Link: https://lkml.kernel.org/r/20210706061748.161258-9-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   99 ++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 52 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pmd-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -213,54 +213,54 @@ static void __init pmd_basic_tests(struc
 	WARN_ON(!pmd_bad(pmd_mkhuge(pmd)));
 }
 
-static void __init pmd_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pmd_t *pmdp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot, pgtable_t pgtable)
+static void __init pmd_advanced_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
+	unsigned long vaddr = (debug->vaddr & HPAGE_PMD_MASK);
 
 	if (!has_transparent_hugepage())
 		return;
 
 	pr_debug("Validating PMD advanced\n");
-	/* Align the address wrt HPAGE_PMD_SIZE */
-	vaddr &= HPAGE_PMD_MASK;
+	if (debug->pmd_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
 
-	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
+	pgtable_trans_huge_deposit(debug->mm, debug->pmdp, debug->start_ptep);
 
-	pmd = pfn_pmd(pfn, prot);
-	set_pmd_at(mm, vaddr, pmdp, pmd);
-	pmdp_set_wrprotect(mm, vaddr, pmdp);
-	pmd = READ_ONCE(*pmdp);
+	pmd = pfn_pmd(debug->pmd_pfn, debug->page_prot);
+	set_pmd_at(debug->mm, vaddr, debug->pmdp, pmd);
+	pmdp_set_wrprotect(debug->mm, vaddr, debug->pmdp);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(pmd_write(pmd));
-	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
-	pmd = READ_ONCE(*pmdp);
+	pmdp_huge_get_and_clear(debug->mm, vaddr, debug->pmdp);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(!pmd_none(pmd));
 
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(debug->pmd_pfn, debug->page_prot);
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_mkclean(pmd);
-	set_pmd_at(mm, vaddr, pmdp, pmd);
+	set_pmd_at(debug->mm, vaddr, debug->pmdp, pmd);
 	pmd = pmd_mkwrite(pmd);
 	pmd = pmd_mkdirty(pmd);
-	pmdp_set_access_flags(vma, vaddr, pmdp, pmd, 1);
-	pmd = READ_ONCE(*pmdp);
+	pmdp_set_access_flags(debug->vma, vaddr, debug->pmdp, pmd, 1);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(!(pmd_write(pmd) && pmd_dirty(pmd)));
-	pmdp_huge_get_and_clear_full(vma, vaddr, pmdp, 1);
-	pmd = READ_ONCE(*pmdp);
+	pmdp_huge_get_and_clear_full(debug->vma, vaddr, debug->pmdp, 1);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(!pmd_none(pmd));
 
-	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+	pmd = pmd_mkhuge(pfn_pmd(debug->pmd_pfn, debug->page_prot));
 	pmd = pmd_mkyoung(pmd);
-	set_pmd_at(mm, vaddr, pmdp, pmd);
-	pmdp_test_and_clear_young(vma, vaddr, pmdp);
-	pmd = READ_ONCE(*pmdp);
+	set_pmd_at(debug->mm, vaddr, debug->pmdp, pmd);
+	pmdp_test_and_clear_young(debug->vma, vaddr, debug->pmdp);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(pmd_young(pmd));
 
 	/*  Clear the pte entries  */
-	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
-	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
+	pmdp_huge_get_and_clear(debug->mm, vaddr, debug->pmdp);
+	pgtable_trans_huge_withdraw(debug->mm, debug->pmdp);
 }
 
 static void __init pmd_leaf_tests(struct vm_pgtable_debug *debug)
@@ -417,12 +417,7 @@ static void __init pud_leaf_tests(struct
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
 static void __init pud_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
-static void __init pmd_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pmd_t *pmdp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot, pgtable_t pgtable)
-{
-}
+static void __init pmd_advanced_tests(struct vm_pgtable_debug *debug) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pud_t *pudp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -435,11 +430,11 @@ static void __init pmd_savedwrite_tests(
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
+static void __init pmd_huge_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
 
-	if (!arch_vmap_pmd_supported(prot))
+	if (!arch_vmap_pmd_supported(debug->page_prot))
 		return;
 
 	pr_debug("Validating PMD huge\n");
@@ -447,10 +442,11 @@ static void __init pmd_huge_tests(pmd_t
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*pmdp, __pmd(0));
-	WARN_ON(!pmd_set_huge(pmdp, __pfn_to_phys(pfn), prot));
-	WARN_ON(!pmd_clear_huge(pmdp));
-	pmd = READ_ONCE(*pmdp);
+	WRITE_ONCE(*(debug->pmdp), __pmd(0));
+	WARN_ON(!pmd_set_huge(debug->pmdp, __pfn_to_phys(debug->fixed_pmd_pfn),
+			      debug->page_prot));
+	WARN_ON(!pmd_clear_huge(debug->pmdp));
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(!pmd_none(pmd));
 }
 
@@ -473,7 +469,7 @@ static void __init pud_huge_tests(pud_t
 	WARN_ON(!pud_none(pud));
 }
 #else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
-static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_huge_tests(struct vm_pgtable_debug *debug) { }
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
@@ -640,20 +636,19 @@ static void __init pte_clear_tests(struc
 	WARN_ON(!pte_none(pte));
 }
 
-static void __init pmd_clear_tests(struct mm_struct *mm, pmd_t *pmdp)
+static void __init pmd_clear_tests(struct vm_pgtable_debug *debug)
 {
-	pmd_t pmd = READ_ONCE(*pmdp);
+	pmd_t pmd = READ_ONCE(*(debug->pmdp));
 
 	pr_debug("Validating PMD clear\n");
 	pmd = __pmd(pmd_val(pmd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pmdp, pmd);
-	pmd_clear(pmdp);
-	pmd = READ_ONCE(*pmdp);
+	WRITE_ONCE(*(debug->pmdp), pmd);
+	pmd_clear(debug->pmdp);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(!pmd_none(pmd));
 }
 
-static void __init pmd_populate_tests(struct mm_struct *mm, pmd_t *pmdp,
-				      pgtable_t pgtable)
+static void __init pmd_populate_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
 
@@ -662,8 +657,8 @@ static void __init pmd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pmd_bad().
 	 */
-	pmd_populate(mm, pmdp, pgtable);
-	pmd = READ_ONCE(*pmdp);
+	pmd_populate(debug->mm, debug->pmdp, debug->start_ptep);
+	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(pmd_bad(pmd));
 }
 
@@ -1304,11 +1299,11 @@ static int __init debug_vm_pgtable(void)
 	pte_advanced_tests(&debug);
 	spin_unlock(ptl);
 
-	ptl = pmd_lock(mm, pmdp);
-	pmd_clear_tests(mm, pmdp);
-	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot, saved_ptep);
-	pmd_huge_tests(pmdp, pmd_aligned, prot);
-	pmd_populate_tests(mm, pmdp, saved_ptep);
+	ptl = pmd_lock(debug.mm, debug.pmdp);
+	pmd_clear_tests(&debug);
+	pmd_advanced_tests(&debug);
+	pmd_huge_tests(&debug);
+	pmd_populate_tests(&debug);
 	spin_unlock(ptl);
 
 	ptl = pud_lock(mm, pudp);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

