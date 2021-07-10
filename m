Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3A3C07E9C
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32A2361403
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhGJDoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDoM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:44:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86DA3613FE;
        Sat, 10 Jul 2021 03:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888487;
        bh=P7/mH9QB71l1ifKjA2sM3llVA3baS+PEyL8ys0vsQRg=;
        h=Date:From:To:Subject:From;
        b=fCbTEFFrQoI6+9/tQZ17iFfXIeGu6ZlEwLa/dvGQW1S+ruoEcUiIk9aVv19IdZ6oe
         K4R6Ci4a7x+HqmYMzFnVKLVfS8w6NQxasRAg8tfkgqxINlyEh75X9wIfUuX9gzrVoT
         hHjcSOmqM4k/Uf/ck30p2M+Dj4LCZrTG/lFjCiRk=
Date:   Fri, 09 Jul 2021 20:41:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  + mm-debug_vm_pgtable-remove-unused-code.patch added to -mm
 tree
Message-ID: <20210710034127.-OEMQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: remove unused code
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-remove-unused-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-remove-unused-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-remove-unused-code.patch

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
Subject: mm/debug_vm_pgtable: remove unused code

The variables used by old implementation isn't needed as we switched to
"struct vm_pgtable_debug".  Lets just remove them.

Link: https://lkml.kernel.org/r/20210706061748.161258-12-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   99 ++--------------------------------------
 1 file changed, 6 insertions(+), 93 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-remove-unused-code
+++ a/mm/debug_vm_pgtable.c
@@ -33,14 +33,6 @@
 #include <asm/tlbflush.h>
 
 /*
- * Please refer Documentation/vm/arch_pgtable_helpers.rst for the semantics
- * expectations that are being validated here. All future changes in here
- * or the documentation need to be in sync.
- */
-
-#define VMFLAGS	(VM_READ|VM_WRITE|VM_EXEC)
-
-/*
  * On s390 platform, the lower 4 bits are used to identify given page table
  * entry type. But these bits might affect the ability to clear entries with
  * pxx_clear() because of how dynamic page table folding works on s390. So
@@ -1025,7 +1017,12 @@ static int __init alloc_mem(struct vm_pg
 	phys_addr_t phys;
 	int ret = 0;
 
-	/* Initialize the debugging data */
+	/*
+	 * Initialize the debugging data. For @page_prot, please refer
+	 * Documentation/vm/arch_pgtable_helpers.rst for the semantics
+	 * expectations that are being validated here. All future changes
+	 * in here or the documentation need to be in sync.
+	 */
 	debug->mm             = NULL;
 	debug->vma            = NULL;
 	debug->pgdp           = NULL;
@@ -1137,17 +1134,6 @@ error:
 static int __init debug_vm_pgtable(void)
 {
 	struct vm_pgtable_debug debug;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-	pgd_t *pgdp;
-	p4d_t *p4dp, *saved_p4dp;
-	pud_t *pudp, *saved_pudp;
-	pmd_t *pmdp, *saved_pmdp, pmd;
-	pgtable_t saved_ptep;
-	pgprot_t prot, protnone;
-	phys_addr_t paddr;
-	unsigned long vaddr, pte_aligned, pmd_aligned;
-	unsigned long pud_aligned, p4d_aligned, pgd_aligned;
 	spinlock_t *ptl = NULL;
 	int idx, ret;
 
@@ -1156,68 +1142,6 @@ static int __init debug_vm_pgtable(void)
 	if (ret)
 		return ret;
 
-	prot = vm_get_page_prot(VMFLAGS);
-	vaddr = get_random_vaddr();
-	mm = mm_alloc();
-	if (!mm) {
-		pr_err("mm_struct allocation failed\n");
-		return 1;
-	}
-
-	/*
-	 * __P000 (or even __S000) will help create page table entries with
-	 * PROT_NONE permission as required for pxx_protnone_tests().
-	 */
-	protnone = __P000;
-
-	vma = vm_area_alloc(mm);
-	if (!vma) {
-		pr_err("vma allocation failed\n");
-		return 1;
-	}
-
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
-	pte_aligned = (paddr & PAGE_MASK) >> PAGE_SHIFT;
-	pmd_aligned = (paddr & PMD_MASK) >> PAGE_SHIFT;
-	pud_aligned = (paddr & PUD_MASK) >> PAGE_SHIFT;
-	p4d_aligned = (paddr & P4D_MASK) >> PAGE_SHIFT;
-	pgd_aligned = (paddr & PGDIR_MASK) >> PAGE_SHIFT;
-	WARN_ON(!pfn_valid(pte_aligned));
-
-	pgdp = pgd_offset(mm, vaddr);
-	p4dp = p4d_alloc(mm, pgdp, vaddr);
-	pudp = pud_alloc(mm, p4dp, vaddr);
-	pmdp = pmd_alloc(mm, pudp, vaddr);
-	/*
-	 * Allocate pgtable_t
-	 */
-	if (pte_alloc(mm, pmdp)) {
-		pr_err("pgtable allocation failed\n");
-		return 1;
-	}
-
-	/*
-	 * Save all the page table page addresses as the page table
-	 * entries will be used for testing with random or garbage
-	 * values. These saved addresses will be used for freeing
-	 * page table pages.
-	 */
-	pmd = READ_ONCE(*pmdp);
-	saved_p4dp = p4d_offset(pgdp, 0UL);
-	saved_pudp = pud_offset(p4dp, 0UL);
-	saved_pmdp = pmd_offset(pudp, 0UL);
-	saved_ptep = pmd_pgtable(pmd);
-
 	/*
 	 * Iterate over the protection_map[] to make sure that all
 	 * the basic page table transformation validations just hold
@@ -1299,17 +1223,6 @@ static int __init debug_vm_pgtable(void)
 	pgd_populate_tests(&debug);
 	spin_unlock(&(debug.mm->page_table_lock));
 
-	p4d_free(mm, saved_p4dp);
-	pud_free(mm, saved_pudp);
-	pmd_free(mm, saved_pmdp);
-	pte_free(mm, saved_ptep);
-
-	vm_area_free(vma);
-	mm_dec_nr_puds(mm);
-	mm_dec_nr_pmds(mm);
-	mm_dec_nr_ptes(mm);
-	mmdrop(mm);
-
 	free_mem(&debug);
 	return 0;
 }
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

