Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC59C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FADD613F9
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGJDoI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDoI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870B2613F8;
        Sat, 10 Jul 2021 03:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888483;
        bh=2SOCvrcO3nIU/dnbnYxet6WHJaYy5+RCw6KitfnhmL4=;
        h=Date:From:To:Subject:From;
        b=uHQTY2qA3xNj3DA7XobhW/7VU3/f+quE/o9HbaAgqoxW2ZiR2ioM0unEFWW6vGCoY
         7ZZoGPAK8DMHbrGZcIUMIvKhUMh7iE9yzJ/qo0uk2y3h35Sz8Wl2IUfqjHvNGPC9Yc
         rh77yrV6McuWuS81Qp1zIt4c4eqhwV3ZrxXfhefw=
Date:   Fri, 09 Jul 2021 20:41:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch
 added to -mm tree
Message-ID: <20210710034123.U7EZ9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vm_debug_pgtable: use struct vm_pgtable_debug in PUD modifying tests
has been added to the -mm tree.  Its filename is
     mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch

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
Subject: mm/vm_debug_pgtable: use struct vm_pgtable_debug in PUD modifying tests

This uses struct vm_pgtable_debug in PUD modifying tests.  The allocated
huge page is used when set_pud_at() is used.  The corresponding tests are
skipped if the huge page doesn't exist.

Link: https://lkml.kernel.org/r/20210706061748.161258-10-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  113 +++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 63 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -338,55 +338,55 @@ static void __init pud_basic_tests(struc
 	WARN_ON(!pud_bad(pud_mkhuge(pud)));
 }
 
-static void __init pud_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pud_t *pudp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+static void __init pud_advanced_tests(struct vm_pgtable_debug *debug)
 {
+	unsigned long vaddr = (debug->vaddr & HPAGE_PUD_MASK);
 	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
 
 	pr_debug("Validating PUD advanced\n");
-	/* Align the address wrt HPAGE_PUD_SIZE */
-	vaddr &= HPAGE_PUD_MASK;
+	if (debug->pud_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
 
-	pud = pfn_pud(pfn, prot);
-	set_pud_at(mm, vaddr, pudp, pud);
-	pudp_set_wrprotect(mm, vaddr, pudp);
-	pud = READ_ONCE(*pudp);
+	pud = pfn_pud(debug->pud_pfn, debug->page_prot);
+	set_pud_at(debug->mm, vaddr, debug->pudp, pud);
+	pudp_set_wrprotect(debug->mm, vaddr, debug->pudp);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(pud_write(pud));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pudp_huge_get_and_clear(mm, vaddr, pudp);
-	pud = READ_ONCE(*pudp);
+	pudp_huge_get_and_clear(debug->mm, vaddr, debug->pudp);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(debug->pud_pfn, debug->page_prot);
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
-	set_pud_at(mm, vaddr, pudp, pud);
+	set_pud_at(debug->mm, vaddr, debug->pudp, pud);
 	pud = pud_mkwrite(pud);
 	pud = pud_mkdirty(pud);
-	pudp_set_access_flags(vma, vaddr, pudp, pud, 1);
-	pud = READ_ONCE(*pudp);
+	pudp_set_access_flags(debug->vma, vaddr, debug->pudp, pud, 1);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(!(pud_write(pud) && pud_dirty(pud)));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pudp_huge_get_and_clear_full(mm, vaddr, pudp, 1);
-	pud = READ_ONCE(*pudp);
+	pudp_huge_get_and_clear_full(debug->mm, vaddr, debug->pudp, 1);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(debug->pud_pfn, debug->page_prot);
 	pud = pud_mkyoung(pud);
-	set_pud_at(mm, vaddr, pudp, pud);
-	pudp_test_and_clear_young(vma, vaddr, pudp);
-	pud = READ_ONCE(*pudp);
+	set_pud_at(debug->mm, vaddr, debug->pudp, pud);
+	pudp_test_and_clear_young(debug->vma, vaddr, debug->pudp);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(pud_young(pud));
 
-	pudp_huge_get_and_clear(mm, vaddr, pudp);
+	pudp_huge_get_and_clear(debug->mm, vaddr, debug->pudp);
 }
 
 static void __init pud_leaf_tests(struct vm_pgtable_debug *debug)
@@ -406,24 +406,14 @@ static void __init pud_leaf_tests(struct
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
-static void __init pud_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pud_t *pudp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
-{
-}
+static void __init pud_advanced_tests(struct vm_pgtable_debug *debug) { }
 static void __init pud_leaf_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
 static void __init pud_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
 static void __init pmd_advanced_tests(struct vm_pgtable_debug *debug) { }
-static void __init pud_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pud_t *pudp,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
-{
-}
+static void __init pud_advanced_tests(struct vm_pgtable_debug *debug) { }
 static void __init pmd_leaf_tests(struct vm_pgtable_debug *debug) { }
 static void __init pud_leaf_tests(struct vm_pgtable_debug *debug) { }
 static void __init pmd_savedwrite_tests(struct vm_pgtable_debug *debug) { }
@@ -450,11 +440,11 @@ static void __init pmd_huge_tests(struct
 	WARN_ON(!pmd_none(pmd));
 }
 
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
+static void __init pud_huge_tests(struct vm_pgtable_debug *debug)
 {
 	pud_t pud;
 
-	if (!arch_vmap_pud_supported(prot))
+	if (!arch_vmap_pud_supported(debug->page_prot))
 		return;
 
 	pr_debug("Validating PUD huge\n");
@@ -462,15 +452,16 @@ static void __init pud_huge_tests(pud_t
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*pudp, __pud(0));
-	WARN_ON(!pud_set_huge(pudp, __pfn_to_phys(pfn), prot));
-	WARN_ON(!pud_clear_huge(pudp));
-	pud = READ_ONCE(*pudp);
+	WRITE_ONCE(*(debug->pudp), __pud(0));
+	WARN_ON(!pud_set_huge(debug->pudp, __pfn_to_phys(debug->fixed_pud_pfn),
+			      debug->page_prot));
+	WARN_ON(!pud_clear_huge(debug->pudp));
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(!pud_none(pud));
 }
 #else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
 static void __init pmd_huge_tests(struct vm_pgtable_debug *debug) { }
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
+static void __init pud_huge_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 static void __init p4d_basic_tests(void)
@@ -492,27 +483,26 @@ static void __init pgd_basic_tests(void)
 }
 
 #ifndef __PAGETABLE_PUD_FOLDED
-static void __init pud_clear_tests(struct mm_struct *mm, pud_t *pudp)
+static void __init pud_clear_tests(struct vm_pgtable_debug *debug)
 {
-	pud_t pud = READ_ONCE(*pudp);
+	pud_t pud = READ_ONCE(*(debug->pudp));
 
-	if (mm_pmd_folded(mm))
+	if (mm_pmd_folded(debug->mm))
 		return;
 
 	pr_debug("Validating PUD clear\n");
 	pud = __pud(pud_val(pud) | RANDOM_ORVALUE);
-	WRITE_ONCE(*pudp, pud);
-	pud_clear(pudp);
-	pud = READ_ONCE(*pudp);
+	WRITE_ONCE(*(debug->pudp), pud);
+	pud_clear(debug->pudp);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(!pud_none(pud));
 }
 
-static void __init pud_populate_tests(struct mm_struct *mm, pud_t *pudp,
-				      pmd_t *pmdp)
+static void __init pud_populate_tests(struct vm_pgtable_debug *debug)
 {
 	pud_t pud;
 
-	if (mm_pmd_folded(mm))
+	if (mm_pmd_folded(debug->mm))
 		return;
 
 	pr_debug("Validating PUD populate\n");
@@ -520,16 +510,13 @@ static void __init pud_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pud_bad().
 	 */
-	pud_populate(mm, pudp, pmdp);
-	pud = READ_ONCE(*pudp);
+	pud_populate(debug->mm, debug->pudp, debug->start_pmdp);
+	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(pud_bad(pud));
 }
 #else  /* !__PAGETABLE_PUD_FOLDED */
-static void __init pud_clear_tests(struct mm_struct *mm, pud_t *pudp) { }
-static void __init pud_populate_tests(struct mm_struct *mm, pud_t *pudp,
-				      pmd_t *pmdp)
-{
-}
+static void __init pud_clear_tests(struct vm_pgtable_debug *debug) { }
+static void __init pud_populate_tests(struct vm_pgtable_debug *debug) { }
 #endif /* PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_P4D_FOLDED
@@ -1306,11 +1293,11 @@ static int __init debug_vm_pgtable(void)
 	pmd_populate_tests(&debug);
 	spin_unlock(ptl);
 
-	ptl = pud_lock(mm, pudp);
-	pud_clear_tests(mm, pudp);
-	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
-	pud_huge_tests(pudp, pud_aligned, prot);
-	pud_populate_tests(mm, pudp, saved_pmdp);
+	ptl = pud_lock(debug.mm, debug.pudp);
+	pud_clear_tests(&debug);
+	pud_advanced_tests(&debug);
+	pud_huge_tests(&debug);
+	pud_populate_tests(&debug);
 	spin_unlock(ptl);
 
 	spin_lock(&mm->page_table_lock);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-leaf-and-savewrite-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-protnone-and-devmap-tests.patch
mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-soft_dirty-and-swap-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-migration-and-thp-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pmd-modifying-tests.patch
mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

