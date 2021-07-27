Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18A0C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8285360FA0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhG0Uwn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231516AbhG0Uwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:52:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B755C60F58;
        Tue, 27 Jul 2021 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627419161;
        bh=MT7yiLOdLRbk+NK57a2WBYD7nH3QxYwgWWyHaCh2Fmw=;
        h=Date:From:To:Subject:From;
        b=JGp2c+6HlrjmjjmELe+wVlkkHHIqcMBhvrpscndlwsR5csbfYuA82lnva6v6uklSv
         dBVZKCUcIZ4MzyMngc/2mT56sLTTrMcmJY1Ogxu6tJNH8C0OzOCxAYo0bSiyC406Um
         Q6VODb2OPO+xqGaSavX4xuRwIYomjelFNtbnPqsw=
Date:   Tue, 27 Jul 2021 13:52:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  +
 mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch added to -mm
 tree
Message-ID: <20210727205241.2GdS7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: introduce struct pgtable_debug_args
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch

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
Subject: mm/debug_vm_pgtable: introduce struct pgtable_debug_args

Patch series "mm/debug_vm_pgtable: Enhancements", v4.

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
information.  With it, what the tests functions need is the struct.  In
this way, the code is simplified and easier to be maintained.

Besides, set_xxx_at() could access the data on the corresponding pages in
the page table modifying tests.  So the accessed pages in the tests should
have been allocated from buddy.  Otherwise, we're accessing pages that
aren't owned by us.  This causes issues like page flag corruption or
kernel crash on accessing unmapped page when CONFIG_DEBUG_PAGEALLOC is
enabled.

This introduces "struct pgtable_debug_args".  The struct is initialized
and destroyed, but the information in the struct isn't used yet.  It will
be used in subsequent patches.

Link: https://lkml.kernel.org/r/20210727061401.592616-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20210727061401.592616-2-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Qian Cai <cai@lca.pw>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  280 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 279 insertions(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args
+++ a/mm/debug_vm_pgtable.c
@@ -58,6 +58,37 @@
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
+	bool			is_contiguous_page;
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
@@ -955,8 +986,249 @@ static unsigned long __init get_random_v
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
+		if (args->is_contiguous_page) {
+			free_contig_range(args->pud_pfn,
+					  (1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)));
+		} else {
+			page = pfn_to_page(args->pud_pfn);
+			__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		}
+
+		args->pud_pfn = ULONG_MAX;
+		args->pmd_pfn = ULONG_MAX;
+		args->pte_pfn = ULONG_MAX;
+	}
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    has_transparent_hugepage() &&
+	    args->pmd_pfn != ULONG_MAX) {
+		if (args->is_contiguous_page) {
+			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
+		} else {
+			page = pfn_to_page(args->pmd_pfn);
+			__free_pages(page, HPAGE_PMD_ORDER);
+		}
+
+		args->pmd_pfn = ULONG_MAX;
+		args->pte_pfn = ULONG_MAX;
+	}
+
+	if (args->pte_pfn != ULONG_MAX) {
+		page = pfn_to_page(args->pte_pfn);
+		__free_pages(page, 0);
+	}
+
+	/* Free page table entries */
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
+	/*
+	 * Initialize the debugging data.
+	 *
+	 * __P000 (or even __S000) will help create page table entries with
+	 * PROT_NONE permission as required for pxx_protnone_tests().
+	 */
+	memset(args, 0, sizeof(*args));
+	args->vaddr              = get_random_vaddr();
+	args->page_prot          = vm_get_page_prot(VMFLAGS);
+	args->page_prot_none     = __P000;
+	args->is_contiguous_page = false;
+	args->pud_pfn            = ULONG_MAX;
+	args->pmd_pfn            = ULONG_MAX;
+	args->pte_pfn            = ULONG_MAX;
+	args->fixed_pgd_pfn      = ULONG_MAX;
+	args->fixed_p4d_pfn      = ULONG_MAX;
+	args->fixed_pud_pfn      = ULONG_MAX;
+	args->fixed_pmd_pfn      = ULONG_MAX;
+	args->fixed_pte_pfn      = ULONG_MAX;
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
+	/*
+	 * Allocate page table entries. They will be modified in the tests.
+	 * Lets save the page table entries so that they can be released
+	 * when the tests are completed.
+	 */
+	args->pgdp = pgd_offset(args->mm, args->vaddr);
+	args->p4dp = p4d_alloc(args->mm, args->pgdp, args->vaddr);
+	if (!args->p4dp) {
+		pr_err("Failed to allocate p4d entries\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	args->start_p4dp = p4d_offset(args->pgdp, 0UL);
+	WARN_ON(!args->start_p4dp);
+	args->pudp = pud_alloc(args->mm, args->p4dp, args->vaddr);
+	if (!args->pudp) {
+		pr_err("Failed to allocate pud entries\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	args->start_pudp = pud_offset(args->p4dp, 0UL);
+	WARN_ON(!args->start_pudp);
+	args->pmdp = pmd_alloc(args->mm, args->pudp, args->vaddr);
+	if (!args->pmdp) {
+		pr_err("Failed to allocate pmd entries\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	args->start_pmdp = pmd_offset(args->pudp, 0UL);
+	WARN_ON(!args->start_pmdp);
+	args->ptep = pte_alloc_map(args->mm, args->pmdp, args->vaddr);
+	if (!args->ptep) {
+		pr_err("Failed to allocate pte entries\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	args->start_ptep = pmd_pgtable(READ_ONCE(*args->pmdp));
+	WARN_ON(!args->start_ptep);
+
+	/*
+	 * PFN for mapping at PTE level is determined from a standard kernel
+	 * text symbol. But pfns for higher page table levels are derived by
+	 * masking lower bits of this real pfn. These derived pfns might not
+	 * exist on the platform but that does not really matter as pfn_pxx()
+	 * helpers will still create appropriate entries for the test. This
+	 * helps avoid large memory block allocations to be used for mapping
+	 * at higher page table levels in some of the tests.
+	 */
+	phys = __pa_symbol(&start_kernel);
+	args->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
+	args->fixed_p4d_pfn = __phys_to_pfn(phys & P4D_MASK);
+	args->fixed_pud_pfn = __phys_to_pfn(phys & PUD_MASK);
+	args->fixed_pmd_pfn = __phys_to_pfn(phys & PMD_MASK);
+	args->fixed_pte_pfn = __phys_to_pfn(phys & PAGE_MASK);
+	WARN_ON(!pfn_valid(args->fixed_pte_pfn));
+
+	/*
+	 * Allocate (huge) pages because some of the tests need to access
+	 * the data in the pages. The corresponding tests will be skipped
+	 * if we fail to allocate (huge) pages.
+	 */
+#ifdef CONFIG_CONTIG_ALLOC
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
+	    has_transparent_hugepage() &&
+	    (HPAGE_PUD_SHIFT - PAGE_SHIFT) >= MAX_ORDER) {
+		page = alloc_contig_pages((1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)),
+					  GFP_KERNEL, first_online_node, NULL);
+		if (page) {
+			args->is_contiguous_page = true;
+			args->pud_pfn = page_to_pfn(page);
+			args->pmd_pfn = args->pud_pfn;
+			args->pte_pfn = args->pud_pfn;
+			return 0;
+		}
+	}
+#endif
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
+	    has_transparent_hugepage() &&
+	    (HPAGE_PUD_SHIFT - PAGE_SHIFT) < MAX_ORDER) {
+		page = alloc_pages(GFP_KERNEL, HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		if (page) {
+			args->pud_pfn = page_to_pfn(page);
+			args->pmd_pfn = args->pud_pfn;
+			args->pte_pfn = args->pud_pfn;
+			return 0;
+		}
+	}
+
+#ifdef CONFIG_CONTIG_ALLOC
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    has_transparent_hugepage() &&
+	    HPAGE_PMD_ORDER >= MAX_ORDER) {
+		page = alloc_contig_pages((1 << HPAGE_PMD_ORDER), GFP_KERNEL,
+					  first_online_node, NULL);
+		if (page) {
+			args->is_contiguous_page = true;
+			args->pmd_pfn = page_to_pfn(page);
+			args->pte_pfn = args->pmd_pfn;
+			return 0;
+		}
+	}
+#endif
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    has_transparent_hugepage() &&
+	    HPAGE_PMD_ORDER < MAX_ORDER) {
+		page = alloc_pages(GFP_KERNEL, HPAGE_PMD_ORDER);
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
@@ -970,9 +1242,13 @@ static int __init debug_vm_pgtable(void)
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
@@ -1127,6 +1403,8 @@ static int __init debug_vm_pgtable(void)
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

