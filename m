Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990B2C636C8
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE5B6120D
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhGTVfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231770AbhGTVdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B48261019;
        Tue, 20 Jul 2021 22:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626819264;
        bh=vJmaMyATxiS0m0Kbm3iinJmfa05uVMeok+SFxRaiusE=;
        h=Date:From:To:Subject:From;
        b=hcZjB7QgM5zgwMWa7JMLb/I6IvATs4xj5Zx0nkq28A3GkgciISNdA6E7ANXUZq2KR
         Ddlbn/GF+FzHnjaaAGfB8HZr4hR+3Lpey2pcSAechIZG2w/tr9VoVWh9fzr0WRjvUP
         5Y02GExg8cKapAQsy8bIpHYzAytDPRijMCklzgKQ=
Date:   Tue, 20 Jul 2021 15:14:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
 added to -mm tree
Message-ID: <20210720221423.riaPV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PMD modifying tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PMD modifying tests

This uses struct pgtable_debug_args in PMD modifying tests.  The allocated
huge page is used when set_pmd_at() is used.  The corresponding tests are
skipped if the huge page doesn't exist.  Besides, the unused variable
@pmd_aligned in debug_vm_pgtable() is dropped.

Link: https://lkml.kernel.org/r/20210719130613.334901-9-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  102 ++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 54 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -213,54 +213,54 @@ static void __init pmd_basic_tests(struc
 	WARN_ON(!pmd_bad(pmd_mkhuge(pmd)));
 }
 
-static void __init pmd_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pmd_t *pmdp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot, pgtable_t pgtable)
+static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
+	unsigned long vaddr = (args->vaddr & HPAGE_PMD_MASK);
 
 	if (!has_transparent_hugepage())
 		return;
 
 	pr_debug("Validating PMD advanced\n");
-	/* Align the address wrt HPAGE_PMD_SIZE */
-	vaddr &= HPAGE_PMD_MASK;
+	if (args->pmd_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
 
-	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
+	pgtable_trans_huge_deposit(args->mm, args->pmdp, args->start_ptep);
 
-	pmd = pfn_pmd(pfn, prot);
-	set_pmd_at(mm, vaddr, pmdp, pmd);
-	pmdp_set_wrprotect(mm, vaddr, pmdp);
-	pmd = READ_ONCE(*pmdp);
+	pmd = pfn_pmd(args->pmd_pfn, args->page_prot);
+	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	pmdp_set_wrprotect(args->mm, vaddr, args->pmdp);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(pmd_write(pmd));
-	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
-	pmd = READ_ONCE(*pmdp);
+	pmdp_huge_get_and_clear(args->mm, vaddr, args->pmdp);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(!pmd_none(pmd));
 
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->pmd_pfn, args->page_prot);
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_mkclean(pmd);
-	set_pmd_at(mm, vaddr, pmdp, pmd);
+	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
 	pmd = pmd_mkwrite(pmd);
 	pmd = pmd_mkdirty(pmd);
-	pmdp_set_access_flags(vma, vaddr, pmdp, pmd, 1);
-	pmd = READ_ONCE(*pmdp);
+	pmdp_set_access_flags(args->vma, vaddr, args->pmdp, pmd, 1);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(!(pmd_write(pmd) && pmd_dirty(pmd)));
-	pmdp_huge_get_and_clear_full(vma, vaddr, pmdp, 1);
-	pmd = READ_ONCE(*pmdp);
+	pmdp_huge_get_and_clear_full(args->vma, vaddr, args->pmdp, 1);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(!pmd_none(pmd));
 
-	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+	pmd = pmd_mkhuge(pfn_pmd(args->pmd_pfn, args->page_prot));
 	pmd = pmd_mkyoung(pmd);
-	set_pmd_at(mm, vaddr, pmdp, pmd);
-	pmdp_test_and_clear_young(vma, vaddr, pmdp);
-	pmd = READ_ONCE(*pmdp);
+	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	pmdp_test_and_clear_young(args->vma, vaddr, args->pmdp);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(pmd_young(pmd));
 
 	/*  Clear the pte entries  */
-	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
-	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
+	pmdp_huge_get_and_clear(args->mm, vaddr, args->pmdp);
+	pgtable_trans_huge_withdraw(args->mm, args->pmdp);
 }
 
 static void __init pmd_leaf_tests(struct pgtable_debug_args *args)
@@ -417,12 +417,7 @@ static void __init pud_leaf_tests(struct
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx) { }
 static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx) { }
-static void __init pmd_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pmd_t *pmdp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot, pgtable_t pgtable)
-{
-}
+static void __init pmd_advanced_tests(struct pgtable_debug_args *args) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pud_t *pudp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -435,11 +430,11 @@ static void __init pmd_savedwrite_tests(
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
+static void __init pmd_huge_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!arch_vmap_pmd_supported(prot))
+	if (!arch_vmap_pmd_supported(args->page_prot))
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
+	WRITE_ONCE(*(args->pmdp), __pmd(0));
+	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn),
+			      args->page_prot));
+	WARN_ON(!pmd_clear_huge(args->pmdp));
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(!pmd_none(pmd));
 }
 
@@ -473,7 +469,7 @@ static void __init pud_huge_tests(pud_t
 	WARN_ON(!pud_none(pud));
 }
 #else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
-static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_huge_tests(struct pgtable_debug_args *args) { }
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
@@ -640,20 +636,19 @@ static void __init pte_clear_tests(struc
 	WARN_ON(!pte_none(pte));
 }
 
-static void __init pmd_clear_tests(struct mm_struct *mm, pmd_t *pmdp)
+static void __init pmd_clear_tests(struct pgtable_debug_args *args)
 {
-	pmd_t pmd = READ_ONCE(*pmdp);
+	pmd_t pmd = READ_ONCE(*(args->pmdp));
 
 	pr_debug("Validating PMD clear\n");
 	pmd = __pmd(pmd_val(pmd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pmdp, pmd);
-	pmd_clear(pmdp);
-	pmd = READ_ONCE(*pmdp);
+	WRITE_ONCE(*(args->pmdp), pmd);
+	pmd_clear(args->pmdp);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(!pmd_none(pmd));
 }
 
-static void __init pmd_populate_tests(struct mm_struct *mm, pmd_t *pmdp,
-				      pgtable_t pgtable)
+static void __init pmd_populate_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -662,8 +657,8 @@ static void __init pmd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pmd_bad().
 	 */
-	pmd_populate(mm, pmdp, pgtable);
-	pmd = READ_ONCE(*pmdp);
+	pmd_populate(args->mm, args->pmdp, args->start_ptep);
+	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(pmd_bad(pmd));
 }
 
@@ -1159,7 +1154,7 @@ static int __init debug_vm_pgtable(void)
 	pgtable_t saved_ptep;
 	pgprot_t prot;
 	phys_addr_t paddr;
-	unsigned long vaddr, pmd_aligned;
+	unsigned long vaddr;
 	unsigned long pud_aligned;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
@@ -1194,7 +1189,6 @@ static int __init debug_vm_pgtable(void)
 	 */
 	paddr = __pa_symbol(&start_kernel);
 
-	pmd_aligned = (paddr & PMD_MASK) >> PAGE_SHIFT;
 	pud_aligned = (paddr & PUD_MASK) >> PAGE_SHIFT;
 
 	pgdp = pgd_offset(mm, vaddr);
@@ -1281,11 +1275,11 @@ static int __init debug_vm_pgtable(void)
 	pte_advanced_tests(&args);
 	spin_unlock(ptl);
 
-	ptl = pmd_lock(mm, pmdp);
-	pmd_clear_tests(mm, pmdp);
-	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot, saved_ptep);
-	pmd_huge_tests(pmdp, pmd_aligned, prot);
-	pmd_populate_tests(mm, pmdp, saved_ptep);
+	ptl = pmd_lock(args.mm, args.pmdp);
+	pmd_clear_tests(&args);
+	pmd_advanced_tests(&args);
+	pmd_huge_tests(&args);
+	pmd_populate_tests(&args);
 	spin_unlock(ptl);
 
 	ptl = pud_lock(mm, pudp);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-basic-tests.patch
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

