Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05270C07E9B
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0545613F2
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhGJDoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDoE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 811DC613EE;
        Sat, 10 Jul 2021 03:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888479;
        bh=Whr1chfcWAd1DAPOnl/ehnwf+47a6/H4gJyKhwiUeEc=;
        h=Date:From:To:Subject:From;
        b=k7ENNyPYXdeS6Z9FRwodnZeT67ESO9601jTiv0vXqYiSEs9cOrcMsW+VWuXVO8TAw
         OHdjCZaSO7yvb0CfFmtZ63uT8EYkQQjYjxOBghZGhZs5+cA+2fjSTAIHRj3Bbg+08E
         2GyXaq5RfUpaQYM8B9Ksq+2ANXn/3EcC4OtzB9pM=
Date:   Fri, 09 Jul 2021 20:41:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests.patch
 added to -mm tree
Message-ID: <20210710034119.zlyZU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in PTE modifying tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in PTE modifying tests

This uses struct vm_pgtable_debug in PTE modifying tests.  The allocated
page is used as set_pte_at() is used there.  The tests are skipped if the
allocated page doesn't exist.

Link: https://lkml.kernel.org/r/20210706061748.161258-8-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   71 +++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -116,10 +116,7 @@ static void __init pte_basic_tests(struc
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
 }
 
-static void __init pte_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pte_t *ptep,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+static void __init pte_advanced_tests(struct vm_pgtable_debug *debug)
 {
 	pte_t pte;
 
@@ -130,33 +127,38 @@ static void __init pte_advanced_tests(st
 	 */
 
 	pr_debug("Validating PTE advanced\n");
-	pte = pfn_pte(pfn, prot);
-	set_pte_at(mm, vaddr, ptep, pte);
-	ptep_set_wrprotect(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
+	if (debug->pte_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
+
+	pte = pfn_pte(debug->pte_pfn, debug->page_prot);
+	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
+	ptep_set_wrprotect(debug->mm, debug->vaddr, debug->ptep);
+	pte = ptep_get(debug->ptep);
 	WARN_ON(pte_write(pte));
-	ptep_get_and_clear(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
+	ptep_get_and_clear(debug->mm, debug->vaddr, debug->ptep);
+	pte = ptep_get(debug->ptep);
 	WARN_ON(!pte_none(pte));
 
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(debug->pte_pfn, debug->page_prot);
 	pte = pte_wrprotect(pte);
 	pte = pte_mkclean(pte);
-	set_pte_at(mm, vaddr, ptep, pte);
+	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
 	pte = pte_mkwrite(pte);
 	pte = pte_mkdirty(pte);
-	ptep_set_access_flags(vma, vaddr, ptep, pte, 1);
-	pte = ptep_get(ptep);
+	ptep_set_access_flags(debug->vma, debug->vaddr, debug->ptep, pte, 1);
+	pte = ptep_get(debug->ptep);
 	WARN_ON(!(pte_write(pte) && pte_dirty(pte)));
-	ptep_get_and_clear_full(mm, vaddr, ptep, 1);
-	pte = ptep_get(ptep);
+	ptep_get_and_clear_full(debug->mm, debug->vaddr, debug->ptep, 1);
+	pte = ptep_get(debug->ptep);
 	WARN_ON(!pte_none(pte));
 
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(debug->pte_pfn, debug->page_prot);
 	pte = pte_mkyoung(pte);
-	set_pte_at(mm, vaddr, ptep, pte);
-	ptep_test_and_clear_young(vma, vaddr, ptep);
-	pte = ptep_get(ptep);
+	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
+	ptep_test_and_clear_young(debug->vma, debug->vaddr, debug->ptep);
+	pte = ptep_get(debug->ptep);
 	WARN_ON(pte_young(pte));
 }
 
@@ -617,20 +619,24 @@ static void __init pgd_populate_tests(st
 }
 #endif /* PAGETABLE_P4D_FOLDED */
 
-static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
-				   unsigned long pfn, unsigned long vaddr,
-				   pgprot_t prot)
+static void __init pte_clear_tests(struct vm_pgtable_debug *debug)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte;
 
 	pr_debug("Validating PTE clear\n");
+	if (debug->pte_pfn == ULONG_MAX) {
+		pr_debug("%s: Skipped\n", __func__);
+		return;
+	}
+
+	pte = pfn_pte(debug->pte_pfn, debug->page_prot);
 #ifndef CONFIG_RISCV
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 #endif
-	set_pte_at(mm, vaddr, ptep, pte);
+	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
 	barrier();
-	pte_clear(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
+	pte_clear(debug->mm, debug->vaddr, debug->ptep);
+	pte = ptep_get(debug->ptep);
 	WARN_ON(!pte_none(pte));
 }
 
@@ -1163,7 +1169,6 @@ static int __init debug_vm_pgtable(void)
 	p4d_t *p4dp, *saved_p4dp;
 	pud_t *pudp, *saved_pudp;
 	pmd_t *pmdp, *saved_pmdp, pmd;
-	pte_t *ptep;
 	pgtable_t saved_ptep;
 	pgprot_t prot, protnone;
 	phys_addr_t paddr;
@@ -1293,11 +1298,11 @@ static int __init debug_vm_pgtable(void)
 	 * Page table modifying tests. They need to hold
 	 * proper page table lock.
 	 */
-
-	ptep = pte_offset_map_lock(mm, pmdp, vaddr, &ptl);
-	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
-	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-	pte_unmap_unlock(ptep, ptl);
+	ptl = pte_lockptr(debug.mm, debug.pmdp);
+	spin_lock(ptl);
+	pte_clear_tests(&debug);
+	pte_advanced_tests(&debug);
+	spin_unlock(ptl);
 
 	ptl = pmd_lock(mm, pmdp);
 	pmd_clear_tests(mm, pmdp);
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

