Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4998C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE552613DC
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhGJDnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDnx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB7A4613AF;
        Sat, 10 Jul 2021 03:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888468;
        bh=xnHqHuqVfnKCUHdxEO+3wjWthbWeIqw4mNMofyJFbYY=;
        h=Date:From:To:Subject:From;
        b=0wYCoDhqH9gPaPlOSG2LMgUxmf8jdPN5mPHEoYJylQdsPb0anL2UfraN8BfAQTGC8
         86I2t6cIbUuxeLeOGFQKgGH79lqK9GTOSfj06xcsVjEGWpf3dV0vU2Y7NwHLRWr3fA
         ZdGJJ4aRpI9FEiVmreVEhxN9tD9Xn/Z7vEl8uRMA=
Date:   Fri, 09 Jul 2021 20:41:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug.patch added to -mm tree
Message-ID: <20210710034107.oVk-H%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: introduce struct vm_pgtable_debug
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug.patch

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
Subject: mm/debug_vm_pgtable: introduce struct vm_pgtable_debug

Patch series "mm/debug_vm_pgtable: Enhancements".

There are couple of issues with current implementations and this series
tries to resolve the issues:

  (a) All needed information are scattered in variables, passed to various
      test functions. The code is organized in pretty much relaxed fashion.

  (b) The page isn't allocated from buddy during page table entry modifying
      tests. The page can be invalid, conflicting to the implementations
      of set_{pud, pmd, pte}_at() on ARM64. The target page is accessed
      so that the iCache can be flushed when execution permission is given
      on ARM64. Besides, the target page can be unmapped and access to
      it causes kernel crash.

"struct vm_pgtable_debug" is introduced to address issue (a).  For issue
(b), the used page is allocated from buddy in page table entry modifying
tests.  The corresponding tets will be skipped if we fail to allocate the
(huge) page.  For other test cases, the original page around to kernel
symbol (@start_kernel) is still used.


This patch (of 12):

In debug_vm_pgtable(), there are many local variables introduced to track
the needed information and they are passed to the functions for various
test cases.  It'd better to introduce a struct as place holder for these
information.  With it, what the functions for various test cases need is
the struct, to simplify the code.  It makes the code easier to be
maintained.

Besides, set_pte_at() could access the data on the corresponding pages. 
So the test cases using set_pte_at() should have the pages allocated from
buddy.  Otherwise, we're acceessing pages that aren't owned by us.  This
causes issues like page flag corruption.  So we need the allocated pages
for these tests where set_pte_at() is used.  The struct is introduced so
that the old and new implementation can coexist so that the patches can be
organized in a easy way.

This introduces "struct vm_pgtable_debug" for above purposes.  The struct
is initialized and destroyed, but the information in the struct isn't used
yet.  They will be used in subsequent patches.

Link: https://lkml.kernel.org/r/20210706061748.161258-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20210706061748.161258-2-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  210 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 209 insertions(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug
+++ a/mm/debug_vm_pgtable.c
@@ -58,6 +58,36 @@
 #define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
+struct vm_pgtable_debug {
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
@@ -955,8 +985,180 @@ static unsigned long __init get_random_v
 	return random_vaddr;
 }
 
+static void __init free_mem(struct vm_pgtable_debug *debug)
+{
+	struct page *page = NULL;
+	int order = 0;
+
+	/* Free (huge) page */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	if (has_transparent_hugepage() &&
+	    debug->pud_pfn != ULONG_MAX) {
+		page = pfn_to_page(debug->pud_pfn);
+		order = HPAGE_PUD_SHIFT - PAGE_SHIFT;
+	}
+#endif
+
+	if (has_transparent_hugepage() &&
+	    debug->pmd_pfn != ULONG_MAX && !page) {
+		page = pfn_to_page(debug->pmd_pfn);
+		order = HPAGE_PMD_ORDER;
+	}
+#endif
+
+	if (debug->pte_pfn != ULONG_MAX && !page) {
+		page = pfn_to_page(debug->pte_pfn);
+		order = 0;
+	}
+
+	if (page)
+		__free_pages(page, order);
+
+	/* Free page table */
+	if (debug->start_ptep) {
+		pte_free(debug->mm, debug->start_ptep);
+		mm_dec_nr_ptes(debug->mm);
+	}
+
+	if (debug->start_pmdp) {
+		pmd_free(debug->mm, debug->start_pmdp);
+		mm_dec_nr_pmds(debug->mm);
+	}
+
+	if (debug->start_pudp) {
+		pud_free(debug->mm, debug->start_pudp);
+		mm_dec_nr_puds(debug->mm);
+	}
+
+	if (debug->start_p4dp)
+		p4d_free(debug->mm, debug->p4dp);
+
+	/* Free vma and mm struct */
+	if (debug->vma)
+		vm_area_free(debug->vma);
+	if (debug->mm)
+		mmdrop(debug->mm);
+}
+
+static int __init alloc_mem(struct vm_pgtable_debug *debug)
+{
+	struct page *page = NULL;
+	phys_addr_t phys;
+	int ret = 0;
+
+	/* Initialize the debugging data */
+	debug->mm             = NULL;
+	debug->vma            = NULL;
+	debug->pgdp           = NULL;
+	debug->p4dp           = NULL;
+	debug->pudp           = NULL;
+	debug->pmdp           = NULL;
+	debug->ptep           = NULL;
+	debug->start_p4dp     = NULL;
+	debug->start_pudp     = NULL;
+	debug->start_pmdp     = NULL;
+	debug->start_ptep     = NULL;
+	debug->vaddr          = 0UL;
+	debug->page_prot      = vm_get_page_prot(VM_READ | VM_WRITE | VM_EXEC);
+	debug->page_prot_none = __P000;
+	debug->pud_pfn        = ULONG_MAX;
+	debug->pmd_pfn        = ULONG_MAX;
+	debug->pte_pfn        = ULONG_MAX;
+	debug->fixed_pgd_pfn  = ULONG_MAX;
+	debug->fixed_p4d_pfn  = ULONG_MAX;
+	debug->fixed_pud_pfn  = ULONG_MAX;
+	debug->fixed_pmd_pfn  = ULONG_MAX;
+	debug->fixed_pte_pfn  = ULONG_MAX;
+
+	/* Allocate mm and vma */
+	debug->mm = mm_alloc();
+	if (!debug->mm) {
+		pr_warn("Failed to allocate mm struct\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	debug->vma = vm_area_alloc(debug->mm);
+	if (!debug->vma) {
+		pr_warn("Failed to allocate vma\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* Figure out the virtual address and allocate page table entries */
+	debug->vaddr = get_random_vaddr();
+	debug->pgdp = pgd_offset(debug->mm, debug->vaddr);
+	debug->p4dp = p4d_alloc(debug->mm, debug->pgdp, debug->vaddr);
+	debug->pudp = debug->p4dp ?
+		      pud_alloc(debug->mm, debug->p4dp, debug->vaddr) : NULL;
+	debug->pmdp = debug->pudp ?
+		      pmd_alloc(debug->mm, debug->pudp, debug->vaddr) : NULL;
+	debug->ptep = debug->pmdp ?
+		      pte_alloc_map(debug->mm, debug->pmdp, debug->vaddr) : NULL;
+	if (!debug->ptep) {
+		pr_warn("Failed to allocate page table\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/*
+	 * The above page table entries will be modified. Lets save the
+	 * page table entries so that they can be released when the tests
+	 * are completed.
+	 */
+	debug->start_p4dp = p4d_offset(debug->pgdp, 0UL);
+	debug->start_pudp = pud_offset(debug->p4dp, 0UL);
+	debug->start_pmdp = pmd_offset(debug->pudp, 0UL);
+	debug->start_ptep = pmd_pgtable(*(debug->pmdp));
+
+	/*
+	 * Figure out the fixed addresses, which are all around the kernel
+	 * symbol (@start_kernel). The corresponding PFNs might be invalid,
+	 * but it's fine as the following tests won't access the pages.
+	 */
+	phys = __pa_symbol(&start_kernel);
+	debug->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
+	debug->fixed_p4d_pfn = __phys_to_pfn(phys & P4D_MASK);
+	debug->fixed_pud_pfn = __phys_to_pfn(phys & PUD_MASK);
+	debug->fixed_pmd_pfn = __phys_to_pfn(phys & PMD_MASK);
+	debug->fixed_pte_pfn = __phys_to_pfn(phys & PAGE_MASK);
+
+	/*
+	 * Allocate (huge) pages because some of the tests need to access
+	 * the data in the pages. The corresponding tests will be skipped
+	 * if we fail to allocate (huge) pages.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	if (has_transparent_hugepage()) {
+		page = alloc_pages(GFP_KERNEL, HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		if (page)
+			debug->pud_pfn = page_to_pfn(page);
+	}
+#endif
+
+	if (has_transparent_hugepage()) {
+		page = page ? page : alloc_pages(GFP_KERNEL, HPAGE_PMD_ORDER);
+		if (page)
+			debug->pmd_pfn = page_to_pfn(page);
+	}
+#endif
+
+	page = page ? page : alloc_pages(GFP_KERNEL, 0);
+	if (page)
+		debug->pte_pfn = page_to_pfn(page);
+
+	return 0;
+
+error:
+	free_mem(debug);
+	return ret;
+}
+
 static int __init debug_vm_pgtable(void)
 {
+	struct vm_pgtable_debug debug;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	pgd_t *pgdp;
@@ -970,9 +1172,13 @@ static int __init debug_vm_pgtable(void)
 	unsigned long vaddr, pte_aligned, pmd_aligned;
 	unsigned long pud_aligned, p4d_aligned, pgd_aligned;
 	spinlock_t *ptl = NULL;
-	int idx;
+	int idx, ret;
 
 	pr_info("Validating architecture page table helpers\n");
+	ret = alloc_mem(&debug);
+	if (ret)
+		return ret;
+
 	prot = vm_get_page_prot(VMFLAGS);
 	vaddr = get_random_vaddr();
 	mm = mm_alloc();
@@ -1127,6 +1333,8 @@ static int __init debug_vm_pgtable(void)
 	mm_dec_nr_pmds(mm);
 	mm_dec_nr_ptes(mm);
 	mmdrop(mm);
+
+	free_mem(&debug);
 	return 0;
 }
 late_initcall(debug_vm_pgtable);
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

