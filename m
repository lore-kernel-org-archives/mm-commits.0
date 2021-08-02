Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E0FC432BE
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA84A61038
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhHBU76 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 16:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhHBU76 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 16:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9117A60FC0;
        Mon,  2 Aug 2021 20:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627937987;
        bh=2uh45Ps7ZHUHrsYlUjK9sxBEQGGvLdlBc4Oo2CoKL+g=;
        h=Date:From:To:Subject:From;
        b=b694rzsZSU2EUIkwXaP9XmwFXPDnHxjEkTGgo04wCKUsP6zkeDzcwzu306B05ykAf
         a9WR8rIon8hbUQPGV0ZWMA3WdVqqE6+sNLuR6HLbSU86rz1wE6P9iDVpEK4FsRWmHj
         X1LkVpGlpNaO2KZCfatz5bLBxyCYo4gcnUb9ws2U=
Date:   Mon, 02 Aug 2021 13:59:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  +
 mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
 added to -mm tree
Message-ID: <20210802205947.zuE-0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PTE modifying tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in PTE modifying tests

This uses struct pgtable_debug_args in PTE modifying tests.  The allocated
page is used as set_pte_at() is used there.  The tests are skipped if the
allocated page doesn't exist.  Besides, the unused variable @pte_aligned
in debug_vm_pgtable() are dropped.

Link: https://lkml.kernel.org/r/20210802060419.1360913-8-gshan@redhat.com
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

 mm/debug_vm_pgtable.c |   64 +++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests
+++ a/mm/debug_vm_pgtable.c
@@ -117,10 +117,7 @@ static void __init pte_basic_tests(struc
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
 }
 
-static void __init pte_advanced_tests(struct mm_struct *mm,
-				      struct vm_area_struct *vma, pte_t *ptep,
-				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+static void __init pte_advanced_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte;
 
@@ -129,35 +126,37 @@ static void __init pte_advanced_tests(st
 	 * This requires set_pte_at to be not used to update an
 	 * existing pte entry. Clear pte before we do set_pte_at
 	 */
+	if (args->pte_pfn == ULONG_MAX)
+		return;
 
 	pr_debug("Validating PTE advanced\n");
-	pte = pfn_pte(pfn, prot);
-	set_pte_at(mm, vaddr, ptep, pte);
-	ptep_set_wrprotect(mm, vaddr, ptep);
-	pte = ptep_get(ptep);
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
 
@@ -618,20 +617,21 @@ static void __init pgd_populate_tests(st
 }
 #endif /* PAGETABLE_P4D_FOLDED */
 
-static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
-				   unsigned long pfn, unsigned long vaddr,
-				   pgprot_t prot)
+static void __init pte_clear_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->pte_pfn, args->page_prot);
+
+	if (args->pte_pfn == ULONG_MAX)
+		return;
 
 	pr_debug("Validating PTE clear\n");
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
 
@@ -1224,7 +1224,7 @@ static int __init debug_vm_pgtable(void)
 	pgtable_t saved_ptep;
 	pgprot_t prot;
 	phys_addr_t paddr;
-	unsigned long vaddr, pte_aligned, pmd_aligned;
+	unsigned long vaddr, pmd_aligned;
 	unsigned long pud_aligned;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
@@ -1259,10 +1259,8 @@ static int __init debug_vm_pgtable(void)
 	 */
 	paddr = __pa_symbol(&start_kernel);
 
-	pte_aligned = (paddr & PAGE_MASK) >> PAGE_SHIFT;
 	pmd_aligned = (paddr & PMD_MASK) >> PAGE_SHIFT;
 	pud_aligned = (paddr & PUD_MASK) >> PAGE_SHIFT;
-	WARN_ON(!pfn_valid(pte_aligned));
 
 	pgdp = pgd_offset(mm, vaddr);
 	p4dp = p4d_alloc(mm, pgdp, vaddr);
@@ -1344,9 +1342,9 @@ static int __init debug_vm_pgtable(void)
 	 * proper page table lock.
 	 */
 
-	ptep = pte_offset_map_lock(mm, pmdp, vaddr, &ptl);
-	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
-	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
+	ptep = pte_offset_map_lock(args.mm, args.pmdp, args.vaddr, &ptl);
+	pte_clear_tests(&args);
+	pte_advanced_tests(&args);
 	pte_unmap_unlock(ptep, ptl);
 
 	ptl = pmd_lock(mm, pmdp);
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

