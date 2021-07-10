Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DABDC07E9B
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7057D613DF
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhGJDnz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDny (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:43:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88A95613D0;
        Sat, 10 Jul 2021 03:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888469;
        bh=XhBrREV6+tYXV8Nd0LxrwhsOO+HZrrJcA4eI9Sz6Vjg=;
        h=Date:From:To:Subject:From;
        b=SsVbaVUmv71IRDoRKv3geu25rPbduW+Ga/IZ8AbnX9K1tGf8j520cjZpHs9RtcnQt
         7kckCFoDUjgHOxk661MwL0fDLN4YxDVnmc285gni6cPu4JUfXmbasIzPU9DfkhNFdF
         iUAoRRuEQLrIoTOwMslB+i26/rubV9v+AWYPs1nk=
Date:   Fri, 09 Jul 2021 20:41:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests.patch added to
 -mm tree
Message-ID: <20210710034109.BkLF0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in basic tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in basic tests

This uses struct vm_pgtable_debug in the basic test functions.  There are
more cleanups applied:

   * Move hugetlb_basic_tests() so that the basic tests are treated
     as a bundle.

   * Drop parameters to {pgd, p4d}_basic_tests() as they're never
     used.

Link: https://lkml.kernel.org/r/20210706061748.161258-3-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   47 +++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests
+++ a/mm/debug_vm_pgtable.c
@@ -88,10 +88,10 @@ struct vm_pgtable_debug {
 	unsigned long		fixed_pte_pfn;
 };
 
-static void __init pte_basic_tests(unsigned long pfn, int idx)
+static void __init pte_basic_tests(struct vm_pgtable_debug *debug, int idx)
 {
 	pgprot_t prot = protection_map[idx];
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(debug->fixed_pte_pfn, prot);
 	unsigned long val = idx, *ptr = &val;
 
 	pr_debug("Validating PTE basic (%pGv)\n", ptr);
@@ -173,7 +173,7 @@ static void __init pte_savedwrite_tests(
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_basic_tests(unsigned long pfn, int idx)
+static void __init pmd_basic_tests(struct vm_pgtable_debug *debug, int idx)
 {
 	pgprot_t prot = protection_map[idx];
 	unsigned long val = idx, *ptr = &val;
@@ -183,7 +183,7 @@ static void __init pmd_basic_tests(unsig
 		return;
 
 	pr_debug("Validating PMD basic (%pGv)\n", ptr);
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(debug->fixed_pmd_pfn, prot);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -295,7 +295,7 @@ static void __init pmd_savedwrite_tests(
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx)
+static void __init pud_basic_tests(struct vm_pgtable_debug *debug, int idx)
 {
 	pgprot_t prot = protection_map[idx];
 	unsigned long val = idx, *ptr = &val;
@@ -305,7 +305,7 @@ static void __init pud_basic_tests(struc
 		return;
 
 	pr_debug("Validating PUD basic (%pGv)\n", ptr);
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(debug->fixed_pud_pfn, prot);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -326,7 +326,7 @@ static void __init pud_basic_tests(struc
 	WARN_ON(pud_dirty(pud_wrprotect(pud_mkclean(pud))));
 	WARN_ON(!pud_dirty(pud_wrprotect(pud_mkdirty(pud))));
 
-	if (mm_pmd_folded(mm))
+	if (mm_pmd_folded(debug->mm))
 		return;
 
 	/*
@@ -403,7 +403,7 @@ static void __init pud_leaf_tests(unsign
 	WARN_ON(!pud_leaf(pud));
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
+static void __init pud_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pud_t *pudp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -413,8 +413,8 @@ static void __init pud_advanced_tests(st
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_basic_tests(unsigned long pfn, int idx) { }
-static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
+static void __init pmd_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
+static void __init pud_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
 static void __init pmd_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pmd_t *pmdp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -475,7 +475,7 @@ static void __init pmd_huge_tests(pmd_t
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
-static void __init p4d_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init p4d_basic_tests(void)
 {
 	p4d_t p4d;
 
@@ -484,7 +484,7 @@ static void __init p4d_basic_tests(unsig
 	WARN_ON(!p4d_same(p4d, p4d));
 }
 
-static void __init pgd_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init pgd_basic_tests(void)
 {
 	pgd_t pgd;
 
@@ -889,7 +889,7 @@ static void __init swap_migration_tests(
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init hugetlb_basic_tests(struct vm_pgtable_debug *debug)
 {
 	struct page *page;
 	pte_t pte;
@@ -899,21 +899,21 @@ static void __init hugetlb_basic_tests(u
 	 * Accessing the page associated with the pfn is safe here,
 	 * as it was previously derived from a real kernel symbol.
 	 */
-	page = pfn_to_page(pfn);
-	pte = mk_huge_pte(page, prot);
+	page = pfn_to_page(debug->fixed_pmd_pfn);
+	pte = mk_huge_pte(page, debug->page_prot);
 
 	WARN_ON(!huge_pte_dirty(huge_pte_mkdirty(pte)));
 	WARN_ON(!huge_pte_write(huge_pte_mkwrite(huge_pte_wrprotect(pte))));
 	WARN_ON(huge_pte_write(huge_pte_wrprotect(huge_pte_mkwrite(pte))));
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(debug->fixed_pmd_pfn, debug->page_prot);
 
 	WARN_ON(!pte_huge(pte_mkhuge(pte)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
 #else  /* !CONFIG_HUGETLB_PAGE */
-static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init hugetlb_basic_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1248,9 +1248,9 @@ static int __init debug_vm_pgtable(void)
 	 * given page table entry.
 	 */
 	for (idx = 0; idx < ARRAY_SIZE(protection_map); idx++) {
-		pte_basic_tests(pte_aligned, idx);
-		pmd_basic_tests(pmd_aligned, idx);
-		pud_basic_tests(mm, pud_aligned, idx);
+		pte_basic_tests(&debug, idx);
+		pmd_basic_tests(&debug, idx);
+		pud_basic_tests(&debug, idx);
 	}
 
 	/*
@@ -1260,8 +1260,9 @@ static int __init debug_vm_pgtable(void)
 	 * the above iteration for now to save some test execution
 	 * time.
 	 */
-	p4d_basic_tests(p4d_aligned, prot);
-	pgd_basic_tests(pgd_aligned, prot);
+	p4d_basic_tests();
+	pgd_basic_tests();
+	hugetlb_basic_tests(&debug);
 
 	pmd_leaf_tests(pmd_aligned, prot);
 	pud_leaf_tests(pud_aligned, prot);
@@ -1290,8 +1291,6 @@ static int __init debug_vm_pgtable(void)
 	pmd_thp_tests(pmd_aligned, prot);
 	pud_thp_tests(pud_aligned, prot);
 
-	hugetlb_basic_tests(pte_aligned, prot);
-
 	/*
 	 * Page table modifying tests. They need to hold
 	 * proper page table lock.
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

