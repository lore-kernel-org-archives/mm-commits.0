Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9DDC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B7E64F34
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhBXUDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235378AbhBXUCw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E33564E2B;
        Wed, 24 Feb 2021 20:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196897;
        bh=iyqlcazRZhVYI57v2Zx9aYSd+L+Iv187sM8HOlA8XAY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PhbPM7szZXniPW2hv7OwpQiAotztIUjM+68K6mmIbiS34AUi/sr+1R7XxU114o/EV
         m3rduAMduArjGqX1xZXBxUl9hU1DZ4SmSDt0x4KOx1ktmnXr/d6WXHNeWlCpLhVD16
         pMoILaK+6mJDmoVS+xKegdzl6bcAWb/N8AawvPFs=
Date:   Wed, 24 Feb 2021 12:01:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
        gerald.schaefer@de.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        paul.walmsley@sifive.com, steven.price@arm.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com
Subject:  [patch 026/173] mm/debug_vm_pgtable/basic: iterate over
 entire protection_map[]
Message-ID: <20210224200136.SOwEQBEbR%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable/basic: iterate over entire protection_map[]

Currently the basic tests just validate various page table transformations
after starting with vm_get_page_prot(VM_READ|VM_WRITE|VM_EXEC) protection.
Instead scan over the entire protection_map[] for better coverage.  It
also makes sure that all these basic page table tranformations checks hold
true irrespective of the starting protection value for the page table
entry.  There is also a slight change in the debug print format for basic
tests to capture the protection value it is being tested with.  The
modified output looks something like

[pte_basic_tests          ]: Validating PTE basic ()
[pte_basic_tests          ]: Validating PTE basic (read)
[pte_basic_tests          ]: Validating PTE basic (write)
[pte_basic_tests          ]: Validating PTE basic (read|write)
[pte_basic_tests          ]: Validating PTE basic (exec)
[pte_basic_tests          ]: Validating PTE basic (read|exec)
[pte_basic_tests          ]: Validating PTE basic (write|exec)
[pte_basic_tests          ]: Validating PTE basic (read|write|exec)
[pte_basic_tests          ]: Validating PTE basic (shared)
[pte_basic_tests          ]: Validating PTE basic (read|shared)
[pte_basic_tests          ]: Validating PTE basic (write|shared)
[pte_basic_tests          ]: Validating PTE basic (read|write|shared)
[pte_basic_tests          ]: Validating PTE basic (exec|shared)
[pte_basic_tests          ]: Validating PTE basic (read|exec|shared)
[pte_basic_tests          ]: Validating PTE basic (write|exec|shared)
[pte_basic_tests          ]: Validating PTE basic (read|write|exec|shared)

This adds a missing argument 'struct mm_struct *' in pud_basic_tests()
test .  This never got exposed before as PUD based THP is available only
on X86 platform where mm_pmd_folded(mm) call gets macro replaced without
requiring the mm_struct i.e __is_defined(__PAGETABLE_PMD_FOLDED).

Link: https://lkml.kernel.org/r/1611137241-26220-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> [s390]
Reviewed-by: Steven Price <steven.price@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   47 +++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 12 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-basic-iterate-over-entire-protection_map
+++ a/mm/debug_vm_pgtable.c
@@ -58,11 +58,13 @@
 #define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
-static void __init pte_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_basic_tests(unsigned long pfn, int idx)
 {
+	pgprot_t prot = protection_map[idx];
 	pte_t pte = pfn_pte(pfn, prot);
+	unsigned long val = idx, *ptr = &val;
 
-	pr_debug("Validating PTE basic\n");
+	pr_debug("Validating PTE basic (%pGv)\n", ptr);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -141,14 +143,16 @@ static void __init pte_savedwrite_tests(
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_basic_tests(unsigned long pfn, int idx)
 {
+	pgprot_t prot = protection_map[idx];
 	pmd_t pmd = pfn_pmd(pfn, prot);
+	unsigned long val = idx, *ptr = &val;
 
 	if (!has_transparent_hugepage())
 		return;
 
-	pr_debug("Validating PMD basic\n");
+	pr_debug("Validating PMD basic (%pGv)\n", ptr);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -274,14 +278,16 @@ static void __init pmd_savedwrite_tests(
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx)
 {
+	pgprot_t prot = protection_map[idx];
 	pud_t pud = pfn_pud(pfn, prot);
+	unsigned long val = idx, *ptr = &val;
 
 	if (!has_transparent_hugepage())
 		return;
 
-	pr_debug("Validating PUD basic\n");
+	pr_debug("Validating PUD basic (%pGv)\n", ptr);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -398,7 +404,7 @@ static void __init pud_huge_tests(pud_t
 #endif /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pud_t *pudp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -411,8 +417,8 @@ static void __init pud_huge_tests(pud_t
 }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_basic_tests(unsigned long pfn, int idx) { }
+static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
 static void __init pmd_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pmd_t *pmdp,
 				      unsigned long pfn, unsigned long vaddr,
@@ -938,6 +944,7 @@ static int __init debug_vm_pgtable(void)
 	unsigned long vaddr, pte_aligned, pmd_aligned;
 	unsigned long pud_aligned, p4d_aligned, pgd_aligned;
 	spinlock_t *ptl = NULL;
+	int idx;
 
 	pr_info("Validating architecture page table helpers\n");
 	prot = vm_get_page_prot(VMFLAGS);
@@ -1002,9 +1009,25 @@ static int __init debug_vm_pgtable(void)
 	saved_pmdp = pmd_offset(pudp, 0UL);
 	saved_ptep = pmd_pgtable(pmd);
 
-	pte_basic_tests(pte_aligned, prot);
-	pmd_basic_tests(pmd_aligned, prot);
-	pud_basic_tests(pud_aligned, prot);
+	/*
+	 * Iterate over the protection_map[] to make sure that all
+	 * the basic page table transformation validations just hold
+	 * true irrespective of the starting protection value for a
+	 * given page table entry.
+	 */
+	for (idx = 0; idx < ARRAY_SIZE(protection_map); idx++) {
+		pte_basic_tests(pte_aligned, idx);
+		pmd_basic_tests(pmd_aligned, idx);
+		pud_basic_tests(mm, pud_aligned, idx);
+	}
+
+	/*
+	 * Both P4D and PGD level tests are very basic which do not
+	 * involve creating page table entries from the protection
+	 * value and the given pfn. Hence just keep them out from
+	 * the above iteration for now to save some test execution
+	 * time.
+	 */
 	p4d_basic_tests(p4d_aligned, prot);
 	pgd_basic_tests(pgd_aligned, prot);
 
_
