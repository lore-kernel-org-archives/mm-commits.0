Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B239DC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B5361019
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhGTV33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhGTV3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:29:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6EBE611CE;
        Tue, 20 Jul 2021 22:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626818979;
        bh=2xbGj5ThhL8Ib5/i1JM9tkY6Vh4CRXXT4vywkaF4+E0=;
        h=Date:From:To:Subject:From;
        b=gW0DZfBwCTs1Zvww4Ssnb7y80xk3kHgHQma3PBV95jxVbbYSYwja5qDBlYGBFmAxD
         dgW9ztprNbrN3rx+cxWIMRGpj0bB7kwPOW0QmdAPKhzixHfde7qM4ctWJXRgdxepWe
         nU/STRUEjmYhJrZSJt7AWAcLQPobCnc0QFQviZ6U=
Date:   Tue, 20 Jul 2021 15:09:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-remove-unused-code.patch removed from -mm tree
Message-ID: <20210720220938.BSIpE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: remove unused code
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-remove-unused-code.patch

This patch was dropped because an updated version will be merged

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

mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

