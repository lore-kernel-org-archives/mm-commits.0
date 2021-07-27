Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13942C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA51860F9E
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhG0UoK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhG0UoK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA0C60F9C;
        Tue, 27 Jul 2021 20:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418649;
        bh=xuny0r78fyvwmRnHIBKZc9PCNFHaOw9OXHdSRQHKOk4=;
        h=Date:From:To:Subject:From;
        b=N5Z1qha97L/O4CZb5zKQR3eAp12OcycGxFJHNq/zbp66akYw6JsQtDlOvcdnnOhHQ
         ckVChLzMWZa+oJcZvkABThFq7v2nFLoARJPa19fr8vfLLuvZ5EnsevpfN7ON8Ab0te
         FKYcxZmIkTP3AhENLK2vkijFRRAAMJwYfDgVbgoo=
Date:   Tue, 27 Jul 2021 13:44:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch removed from
 -mm tree
Message-ID: <20210727204409.Issjx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: introduce struct pgtable_debug_args
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: introduce struct pgtable_debug_args

Patch series "mm/debug_vm_pgtable: Enhancements", v3.

There are a couple of issues with current implementations and this series
tries to resolve the issues:

(a) All needed information are scattered in variables, passed to
    various test functions.  The code is organized in pretty much relaxed
    fashion.

(b) The page isn't allocated from buddy during page table entry
    modifying tests.  The page can be invalid, conflicting to the
    implementations of set_xxx_at() on ARM64.  The target page is accessed
    so that the iCache can be flushed when execution permission is given
    on ARM64.  Besides, the target page can be unmapped and access to it
    causes kernel crash.

"struct pgtable_debug_args" is introduced to address issue (a).  For issue
(b), the used page is allocated from buddy in page table entry modifying
tests.  The corresponding tets will be skipped if we fail to allocate the
(huge) page.  For other test cases, the original page around to kernel
symbol (@start_kernel) is still used.

The patches are organized as below.  PATCH[2-10] could be combined to one
patch, but it will make the review harder:

  PATCH[1] introduces "struct pgtable_debug_args" as place holder of all
           needed information. With it, the old and new implementation
           can coexist.
  PATCH[2-10] uses "struct pgtable_debug_args" in various test functions.
  PATCH[11] removes the unused code for old implementation.
  PATCH[12] fixes the issue of corrupted page flag for ARM64


This patch (of 12):

In debug_vm_pgtable(), there are many local variables introduced to track
the needed information and they are passed to the functions for various
test cases.  It'd better to introduce a struct as place holder for these
information.  With it, what the functions for various test cases need is
the struct, to simplify the code.  It also makes code easier to be
maintained.

Besides, set_xxx_at() could access the data on the corresponding pages in
the page table modifying tests.  So the accessed pages in the tests should
have been allocated from buddy.  Otherwise, we're accessing pages that
aren't owned by us.  This causes issues like page flag corruption.

This introduces "struct pgtable_debug_args".  The struct is initialized
and destroyed, but the information in the struct isn't used yet.  They
will be used in subsequent patches.

Link: https://lkml.kernel.org/r/20210719130613.334901-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20210719130613.334901-2-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  197 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 196 insertions(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args
+++ a/mm/debug_vm_pgtable.c
@@ -58,6 +58,36 @@
 #define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
+struct pgtable_debug_args {
+	struct mm_struct	*mm;
+	struct vm_area_struct	*vma;
+
+	pgd_t			*pgdp;
+	p4d_t			*p4dp;
+	pud_t			*pudp;
+	pmd_t			*pmdp;
+	pte_t			*ptep;
+
+	p4d_t			*start_p4dp;
+	pud_t			*start_pudp;
+	pmd_t			*start_pmdp;
+	pgtable_t		start_ptep;
+
+	unsigned long		vaddr;
+	pgprot_t		page_prot;
+	pgprot_t		page_prot_none;
+
+	unsigned long		pud_pfn;
+	unsigned long		pmd_pfn;
+	unsigned long		pte_pfn;
+
+	unsigned long		fixed_pgd_pfn;
+	unsigned long		fixed_p4d_pfn;
+	unsigned long		fixed_pud_pfn;
+	unsigned long		fixed_pmd_pfn;
+	unsigned long		fixed_pte_pfn;
+};
+
 static void __init pte_basic_tests(unsigned long pfn, int idx)
 {
 	pgprot_t prot = protection_map[idx];
@@ -955,8 +985,167 @@ static unsigned long __init get_random_v
 	return random_vaddr;
 }
 
+static void __init destroy_args(struct pgtable_debug_args *args)
+{
+	struct page *page = NULL;
+
+	/* Free (huge) page */
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
+	    has_transparent_hugepage() &&
+	    args->pud_pfn != ULONG_MAX) {
+		page = pfn_to_page(args->pud_pfn);
+		__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		   has_transparent_hugepage() &&
+		   args->pmd_pfn != ULONG_MAX) {
+		page = pfn_to_page(args->pmd_pfn);
+		__free_pages(page, HPAGE_PMD_ORDER);
+	} else if (args->pte_pfn != ULONG_MAX) {
+		page = pfn_to_page(args->pte_pfn);
+		__free_pages(page, 0);
+	}
+
+	/* Free page table */
+	if (args->start_ptep) {
+		pte_free(args->mm, args->start_ptep);
+		mm_dec_nr_ptes(args->mm);
+	}
+
+	if (args->start_pmdp) {
+		pmd_free(args->mm, args->start_pmdp);
+		mm_dec_nr_pmds(args->mm);
+	}
+
+	if (args->start_pudp) {
+		pud_free(args->mm, args->start_pudp);
+		mm_dec_nr_puds(args->mm);
+	}
+
+	if (args->start_p4dp)
+		p4d_free(args->mm, args->p4dp);
+
+	/* Free vma and mm struct */
+	if (args->vma)
+		vm_area_free(args->vma);
+	if (args->mm)
+		mmdrop(args->mm);
+}
+
+static int __init init_args(struct pgtable_debug_args *args)
+{
+	struct page *page = NULL;
+	phys_addr_t phys;
+	int ret = 0;
+
+	/* Initialize the debugging data */
+	memset(args, 0, sizeof(*args));
+	args->page_prot      = vm_get_page_prot(VMFLAGS);
+	args->page_prot_none = __P000;
+	args->pud_pfn        = ULONG_MAX;
+	args->pmd_pfn        = ULONG_MAX;
+	args->pte_pfn        = ULONG_MAX;
+	args->fixed_pgd_pfn  = ULONG_MAX;
+	args->fixed_p4d_pfn  = ULONG_MAX;
+	args->fixed_pud_pfn  = ULONG_MAX;
+	args->fixed_pmd_pfn  = ULONG_MAX;
+	args->fixed_pte_pfn  = ULONG_MAX;
+
+	/* Allocate mm and vma */
+	args->mm = mm_alloc();
+	if (!args->mm) {
+		pr_err("Failed to allocate mm struct\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	args->vma = vm_area_alloc(args->mm);
+	if (!args->vma) {
+		pr_err("Failed to allocate vma\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* Figure out the virtual address and allocate page table entries */
+	args->vaddr = get_random_vaddr();
+	args->pgdp = pgd_offset(args->mm, args->vaddr);
+	args->p4dp = p4d_alloc(args->mm, args->pgdp, args->vaddr);
+	args->pudp = args->p4dp ?
+		     pud_alloc(args->mm, args->p4dp, args->vaddr) : NULL;
+	args->pmdp = args->pudp ?
+		     pmd_alloc(args->mm, args->pudp, args->vaddr) : NULL;
+	args->ptep = args->pmdp ?
+		     pte_alloc_map(args->mm, args->pmdp, args->vaddr) : NULL;
+	if (!args->ptep) {
+		pr_err("Failed to allocate page table\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/*
+	 * The above page table entries will be modified. Lets save the
+	 * page table entries so that they can be released when the tests
+	 * are completed.
+	 */
+	args->start_p4dp = p4d_offset(args->pgdp, 0UL);
+	args->start_pudp = pud_offset(args->p4dp, 0UL);
+	args->start_pmdp = pmd_offset(args->pudp, 0UL);
+	args->start_ptep = pmd_pgtable(READ_ONCE(*(args->pmdp)));
+
+	/*
+	 * Figure out the fixed addresses, which are all around the kernel
+	 * symbol (@start_kernel). The corresponding PFNs might be invalid,
+	 * but it's fine as the following tests won't access the pages.
+	 */
+	phys = __pa_symbol(&start_kernel);
+	args->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
+	args->fixed_p4d_pfn = __phys_to_pfn(phys & P4D_MASK);
+	args->fixed_pud_pfn = __phys_to_pfn(phys & PUD_MASK);
+	args->fixed_pmd_pfn = __phys_to_pfn(phys & PMD_MASK);
+	args->fixed_pte_pfn = __phys_to_pfn(phys & PAGE_MASK);
+
+	/*
+	 * Allocate (huge) pages because some of the tests need to access
+	 * the data in the pages. The corresponding tests will be skipped
+	 * if we fail to allocate (huge) pages.
+	 */
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
+	    has_transparent_hugepage()) {
+		page = alloc_pages(GFP_KERNEL | __GFP_NOWARN,
+				   HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		if (page) {
+			args->pud_pfn = page_to_pfn(page);
+			args->pmd_pfn = args->pud_pfn;
+			args->pte_pfn = args->pud_pfn;
+			return 0;
+		}
+	}
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    has_transparent_hugepage()) {
+		page = alloc_pages(GFP_KERNEL | __GFP_NOWARN, HPAGE_PMD_ORDER);
+		if (page) {
+			args->pmd_pfn = page_to_pfn(page);
+			args->pte_pfn = args->pmd_pfn;
+			return 0;
+		}
+	}
+
+	page = alloc_pages(GFP_KERNEL, 0);
+	if (page)
+		args->pte_pfn = page_to_pfn(page);
+
+	return 0;
+
+error:
+	destroy_args(args);
+	return ret;
+}
+
 static int __init debug_vm_pgtable(void)
 {
+	struct pgtable_debug_args args;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	pgd_t *pgdp;
@@ -970,9 +1159,13 @@ static int __init debug_vm_pgtable(void)
 	unsigned long vaddr, pte_aligned, pmd_aligned;
 	unsigned long pud_aligned, p4d_aligned, pgd_aligned;
 	spinlock_t *ptl = NULL;
-	int idx;
+	int idx, ret;
 
 	pr_info("Validating architecture page table helpers\n");
+	ret = init_args(&args);
+	if (ret)
+		return ret;
+
 	prot = vm_get_page_prot(VMFLAGS);
 	vaddr = get_random_vaddr();
 	mm = mm_alloc();
@@ -1127,6 +1320,8 @@ static int __init debug_vm_pgtable(void)
 	mm_dec_nr_pmds(mm);
 	mm_dec_nr_ptes(mm);
 	mmdrop(mm);
+
+	destroy_args(&args);
 	return 0;
 }
 late_initcall(debug_vm_pgtable);
_

Patches currently in -mm which might be from gshan@redhat.com are

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

