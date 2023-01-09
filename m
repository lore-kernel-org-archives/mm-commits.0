Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FB3C54EBD
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbjAIXEh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjAIXEg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:04:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F65373B0
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32E96611DE
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36637C433D2;
        Mon,  9 Jan 2023 23:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673305474;
        bh=4EBbtVYXMRxo8sicRsGAnLNFOmXItgKSFChP4J0fCgk=;
        h=Date:To:From:Subject:From;
        b=VluCFw7Pm1Z3i/fzhTYBH1MLjZwgi16UtEXJfLnt+DCPukvxInhyiU1H1WkzEoCBP
         AFKc3dRohUOAWotdE0rVE+A9hoIDw5/YoakPBJvoR0Ceqs8i3ZPsLVIEAGBk9DFk3z
         COl3QfJCIyXHnoz4GaTiu7HmX/ODzjxIH/MqPicQ=
Date:   Mon, 09 Jan 2023 15:04:33 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        fvdl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch added to mm-unstable branch
Message-Id: <20230109230434.36637C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: use valid physical memory for pmd/pud tests
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/debug: use valid physical memory for pmd/pud tests
Date: Mon, 9 Jan 2023 17:43:32 +0000

The page table debug tests need a physical address to validate low-level
page table manipulation with.  The memory at this address is not actually
touched, it just encoded in the page table entries at various levels
during the tests only.

Since the memory is not used, the code just picks the physical address of
the start_kernel symbol.  This value is then truncated to get a properly
aligned address that is to be used for various tests.  Because of the
truncation, the address might not actually exist, or might not describe a
complete huge page.  That's not a problem for most tests, but the
arch-specific code may check for attribute validity and consistency.  The
x86 version of {pud,pmd}_set_huge actually validates the MTRRs for the
PMD/PUD range.  This may fail with an address derived from start_kernel,
depending on where the kernel was loaded and what the physical memory
layout of the system is.  This then leads to false negatives for the
{pud,pmd}_set_huge tests.

Avoid this by finding a properly aligned memory range that exists and is
usable.  If such a range is not found, skip the tests that needed it.

Link: https://lkml.kernel.org/r/20230109174332.329366-1-fvdl@google.com
Fixes: 399145f9eb6c ("mm/debug: add tests validating architecture page table helpers")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  103 ++++++++++++++++++++++++++++++++--------
 1 file changed, 84 insertions(+), 19 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug-use-valid-physical-memory-for-pmd-pud-tests
+++ a/mm/debug_vm_pgtable.c
@@ -15,6 +15,7 @@
 #include <linux/hugetlb.h>
 #include <linux/kernel.h>
 #include <linux/kconfig.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/mm_types.h>
@@ -80,6 +81,7 @@ struct pgtable_debug_args {
 	unsigned long		pmd_pfn;
 	unsigned long		pte_pfn;
 
+	unsigned long		fixed_alignment;
 	unsigned long		fixed_pgd_pfn;
 	unsigned long		fixed_p4d_pfn;
 	unsigned long		fixed_pud_pfn;
@@ -430,7 +432,8 @@ static void __init pmd_huge_tests(struct
 {
 	pmd_t pmd;
 
-	if (!arch_vmap_pmd_supported(args->page_prot))
+	if (!arch_vmap_pmd_supported(args->page_prot) ||
+	    args->fixed_alignment < PMD_SIZE)
 		return;
 
 	pr_debug("Validating PMD huge\n");
@@ -449,7 +452,8 @@ static void __init pud_huge_tests(struct
 {
 	pud_t pud;
 
-	if (!arch_vmap_pud_supported(args->page_prot))
+	if (!arch_vmap_pud_supported(args->page_prot) ||
+	    args->fixed_alignment < PUD_SIZE)
 		return;
 
 	pr_debug("Validating PUD huge\n");
@@ -1077,10 +1081,86 @@ debug_vm_pgtable_alloc_huge_page(struct
 	return page;
 }
 
+/*
+ * Check if a physical memory range described by <pstart, pend> contains
+ * an area that is of size psize, and aligned to psize.
+ *
+ * Don't use address 0, an all-zeroes physical address might mask bugs, and
+ * it's not used on x86.
+ */
+static void  __init phys_align_check(phys_addr_t pstart,
+	phys_addr_t pend, unsigned long psize, phys_addr_t *physp,
+	unsigned long *alignp)
+{
+	phys_addr_t aligned_start, aligned_end;
+
+	if (pstart == 0)
+		pstart = PAGE_SIZE;
+
+	aligned_start = ALIGN(pstart, psize);
+	aligned_end = aligned_start + psize;
+
+	if (aligned_end > aligned_start && aligned_end <= pend) {
+		*alignp = psize;
+		*physp = aligned_start;
+	}
+}
+
+static void __init init_fixed_pfns(struct pgtable_debug_args *args)
+{
+	u64 idx;
+	phys_addr_t phys, pstart, pend;
+
+	/*
+	 * Initialize the fixed pfns. To do this, try to find a
+	 * valid physical range, preferably aligned to PUD_SIZE,
+	 * but settling for aligned to PMD_SIZE as a fallback. If
+	 * neither of those is found, use the physical address of
+	 * the start_kernel symbol.
+	 *
+	 * The memory doesn't need to be allocated, it just needs to exist
+	 * as usable memory. It won't be touched.
+	 *
+	 * The alignment is recorded, and can be checked to see if we
+	 * can run the tests that require an actual valid physical
+	 * address range on some architectures ({pmd,pud}_huge_test
+	 * on x86).
+	 */
+
+	phys = __pa_symbol(&start_kernel);
+	args->fixed_alignment = PAGE_SIZE;
+
+	for_each_mem_range(idx, &pstart, &pend) {
+		/* First check for a PUD-aligned area */
+		phys_align_check(pstart, pend, PUD_SIZE, &phys,
+				&args->fixed_alignment);
+
+		/* If a PUD-aligned area is found, we're done */
+		if (args->fixed_alignment >= PUD_SIZE)
+			break;
+
+		/*
+		 * If no PMD-aligned area found yet, check for one,
+		 * but continue the loop to look for a PUD-aligned area.
+		 */
+		if (args->fixed_alignment < PMD_SIZE) {
+			phys_align_check(pstart, pend, PMD_SIZE, &phys,
+					&args->fixed_alignment);
+		}
+	}
+
+	args->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
+	args->fixed_p4d_pfn = __phys_to_pfn(phys & P4D_MASK);
+	args->fixed_pud_pfn = __phys_to_pfn(phys & PUD_MASK);
+	args->fixed_pmd_pfn = __phys_to_pfn(phys & PMD_MASK);
+	args->fixed_pte_pfn = __phys_to_pfn(phys & PAGE_MASK);
+	WARN_ON(!pfn_valid(args->fixed_pte_pfn));
+}
+
+
 static int __init init_args(struct pgtable_debug_args *args)
 {
 	struct page *page = NULL;
-	phys_addr_t phys;
 	int ret = 0;
 
 	/*
@@ -1160,22 +1240,7 @@ static int __init init_args(struct pgtab
 	args->start_ptep = pmd_pgtable(READ_ONCE(*args->pmdp));
 	WARN_ON(!args->start_ptep);
 
-	/*
-	 * PFN for mapping at PTE level is determined from a standard kernel
-	 * text symbol. But pfns for higher page table levels are derived by
-	 * masking lower bits of this real pfn. These derived pfns might not
-	 * exist on the platform but that does not really matter as pfn_pxx()
-	 * helpers will still create appropriate entries for the test. This
-	 * helps avoid large memory block allocations to be used for mapping
-	 * at higher page table levels in some of the tests.
-	 */
-	phys = __pa_symbol(&start_kernel);
-	args->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
-	args->fixed_p4d_pfn = __phys_to_pfn(phys & P4D_MASK);
-	args->fixed_pud_pfn = __phys_to_pfn(phys & PUD_MASK);
-	args->fixed_pmd_pfn = __phys_to_pfn(phys & PMD_MASK);
-	args->fixed_pte_pfn = __phys_to_pfn(phys & PAGE_MASK);
-	WARN_ON(!pfn_valid(args->fixed_pte_pfn));
+	init_fixed_pfns(args);
 
 	/*
 	 * Allocate (huge) pages because some of the tests need to access
_

Patches currently in -mm which might be from fvdl@google.com are

mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch

