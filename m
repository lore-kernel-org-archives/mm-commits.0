Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFB3C4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbjAFAXp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbjAFAXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:23:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C98C3D5EB
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 089A4B81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF94C433D2;
        Fri,  6 Jan 2023 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672964618;
        bh=Bs+jhPhb+zb4jfklyNyy7cspNY6DEZyLk3oH7SHagF4=;
        h=Date:To:From:Subject:From;
        b=oXZHkYhXc9CS+iCvWMGIYO0cnJJ+8KBVt5YaAWEM2M7Jf+hBYRGgyR0CNs/9F9M15
         6DnaRxbbBxhg4PzcwXfhKVdAawW0Qb0raUNKrgBRhO9D03kGUhr6TPNY2UmrE2T9qq
         XliCjaES40I+pjxLmDdC5wEFbNX1mJvBSoZN5hfc=
Date:   Thu, 05 Jan 2023 16:23:37 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        fvdl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch added to mm-unstable branch
Message-Id: <20230106002338.9DF94C433D2@smtp.kernel.org>
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
Date: Thu, 5 Jan 2023 21:50:25 +0000

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

Link: https://lkml.kernel.org/r/20230105215025.422635-1-fvdl@google.com
Fixes: 399145f9eb6c ("mm/debug: add tests validating architecture page table helpers")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   70 ++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 9 deletions(-)

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
@@ -80,6 +81,8 @@ struct pgtable_debug_args {
 	unsigned long		pmd_pfn;
 	unsigned long		pte_pfn;
 
+	phys_addr_t		fixed_alignment;
+
 	unsigned long		fixed_pgd_pfn;
 	unsigned long		fixed_p4d_pfn;
 	unsigned long		fixed_pud_pfn;
@@ -430,7 +433,8 @@ static void __init pmd_huge_tests(struct
 {
 	pmd_t pmd;
 
-	if (!arch_vmap_pmd_supported(args->page_prot))
+	if (!arch_vmap_pmd_supported(args->page_prot) ||
+	    args->fixed_alignment < PMD_SIZE)
 		return;
 
 	pr_debug("Validating PMD huge\n");
@@ -449,7 +453,8 @@ static void __init pud_huge_tests(struct
 {
 	pud_t pud;
 
-	if (!arch_vmap_pud_supported(args->page_prot))
+	if (!arch_vmap_pud_supported(args->page_prot) ||
+	    args->fixed_alignment < PUD_SIZE)
 		return;
 
 	pr_debug("Validating PUD huge\n");
@@ -1077,11 +1082,41 @@ debug_vm_pgtable_alloc_huge_page(struct
 	return page;
 }
 
+/*
+ * Check if a physical memory range described by <pstart, pend> contains
+ * an area that is of size psize, and aligned to the same.
+ *
+ * Don't use address 0, and check for overflow.
+ */
+static int __init phys_align_check(phys_addr_t pstart,
+	phys_addr_t pend, phys_addr_t psize, phys_addr_t *physp,
+	phys_addr_t *alignp)
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
+		return 1;
+	}
+
+	return 0;
+}
+
+
 static int __init init_args(struct pgtable_debug_args *args)
 {
 	struct page *page = NULL;
 	phys_addr_t phys;
 	int ret = 0;
+	u64 idx;
+	phys_addr_t pstart, pend;
 
 	/*
 	 * Initialize the debugging data.
@@ -1161,15 +1196,32 @@ static int __init init_args(struct pgtab
 	WARN_ON(!args->start_ptep);
 
 	/*
-	 * PFN for mapping at PTE level is determined from a standard kernel
-	 * text symbol. But pfns for higher page table levels are derived by
-	 * masking lower bits of this real pfn. These derived pfns might not
-	 * exist on the platform but that does not really matter as pfn_pxx()
-	 * helpers will still create appropriate entries for the test. This
-	 * helps avoid large memory block allocations to be used for mapping
-	 * at higher page table levels in some of the tests.
+	 * Find a valid physical range, preferably aligned to PUD_SIZE.
+	 * Return the address and the alignment. It doesn't need to be
+	 * allocated, it just needs to exist as usable memory. The memory
+	 * won't be touched.
+	 *
+	 * The alignment is recorded, and can be checked to see if we
+	 * can run the tests that require and actual valid physical
+	 * address range on some architectures ({pmd,pud}_huge_test
+	 * on x86).
 	 */
+
 	phys = __pa_symbol(&start_kernel);
+	args->fixed_alignment = PAGE_SIZE;
+
+	for_each_mem_range(idx, &pstart, &pend) {
+		if (phys_align_check(pstart, pend, PUD_SIZE, &phys,
+				&args->fixed_alignment))
+			break;
+
+		if (args->fixed_alignment >= PMD_SIZE)
+			continue;
+
+		(void)phys_align_check(pstart, pend, PMD_SIZE, &phys,
+				&args->fixed_alignment);
+	}
+
 	args->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
 	args->fixed_p4d_pfn = __phys_to_pfn(phys & P4D_MASK);
 	args->fixed_pud_pfn = __phys_to_pfn(phys & PUD_MASK);
_

Patches currently in -mm which might be from fvdl@google.com are

mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch

