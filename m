Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCD5C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CBF610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349571AbhICU4w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238471AbhICU4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5A0A610E5;
        Fri,  3 Sep 2021 20:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702551;
        bh=7eiPFPC6aB72kMM0SKJ+1QXxkf6KuUl/CqekMilsDkk=;
        h=Date:From:To:Subject:From;
        b=kl978nYS1SdqTog/BDT22k9AwG3o4Sr+Zzx/tPc00WAhNujg722jUM/vy2sLE0oJ2
         3TKS20iEEs5Oft+tR5Fwya1Q+/NTc9mUIMF4eZa2IeuuvUOg/KxuZWYpwOtASsiPsw
         wQIxU1G+2Bc659iFdYuQGsA4DTWHDPY2r+LbbTuU=
Date:   Fri, 03 Sep 2021 13:55:50 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, cai@lca.pw,
        catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
        chuhu@redhat.com, gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 mm-debug_vm_pgtable-fix-corrupted-page-flag.patch removed from -mm tree
Message-ID: <20210903205550.LP6SU_46x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: fix corrupted page flag
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: fix corrupted page flag

In page table entry modifying tests, set_xxx_at() are used to populate
the page table entries. On ARM64, PG_arch_1 (PG_dcache_clean) flag is
set to the target page flag if execution permission is given. The logic
exits since commit 4f04d8f00545 ("arm64: MMU definitions"). The page
flag is kept when the page is free'd to buddy's free area list. However,
it will trigger page checking failure when it's pulled from the buddy's
free area list, as the following warning messages indicate.

   BUG: Bad page state in process memhog  pfn:08000
   page:0000000015c0a628 refcount:0 mapcount:0 \
        mapping:0000000000000000 index:0x1 pfn:0x8000
   flags: 0x7ffff8000000800(arch_1|node=0|zone=0|lastcpupid=0xfffff)
   raw: 07ffff8000000800 dead000000000100 dead000000000122 0000000000000000
   raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
   page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag(s) set

This fixes the issue by clearing PG_arch_1 through flush_dcache_page()
after set_xxx_at() is called. For architectures other than ARM64, the
unexpected overhead of cache flushing is acceptable.

Link: https://lkml.kernel.org/r/20210809092631.1888748-13-gshan@redhat.com
Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>	[powerpc 8xx]
Tested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>	[s390]
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   55 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-fix-corrupted-page-flag
+++ a/mm/debug_vm_pgtable.c
@@ -29,6 +29,8 @@
 #include <linux/start_kernel.h>
 #include <linux/sched/mm.h>
 #include <linux/io.h>
+
+#include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -119,19 +121,28 @@ static void __init pte_basic_tests(struc
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	pte_t pte;
 
 	/*
 	 * Architectures optimize set_pte_at by avoiding TLB flush.
 	 * This requires set_pte_at to be not used to update an
 	 * existing pte entry. Clear pte before we do set_pte_at
+	 *
+	 * flush_dcache_page() is called after set_pte_at() to clear
+	 * PG_arch_1 for the page on ARM64. The page flag isn't cleared
+	 * when it's released and page allocation check will fail when
+	 * the page is allocated again. For architectures other than ARM64,
+	 * the unexpected overhead of cache flushing is acceptable.
 	 */
-	if (args->pte_pfn == ULONG_MAX)
+	page = (args->pte_pfn != ULONG_MAX) ? pfn_to_page(args->pte_pfn) : NULL;
+	if (!page)
 		return;
 
 	pr_debug("Validating PTE advanced\n");
 	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	ptep_set_wrprotect(args->mm, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_write(pte));
@@ -143,6 +154,7 @@ static void __init pte_advanced_tests(st
 	pte = pte_wrprotect(pte);
 	pte = pte_mkclean(pte);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	pte = pte_mkwrite(pte);
 	pte = pte_mkdirty(pte);
 	ptep_set_access_flags(args->vma, args->vaddr, args->ptep, pte, 1);
@@ -155,6 +167,7 @@ static void __init pte_advanced_tests(st
 	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	pte = pte_mkyoung(pte);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	ptep_test_and_clear_young(args->vma, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_young(pte));
@@ -213,15 +226,24 @@ static void __init pmd_basic_tests(struc
 
 static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	pmd_t pmd;
 	unsigned long vaddr = args->vaddr;
 
 	if (!has_transparent_hugepage())
 		return;
 
-	if (args->pmd_pfn == ULONG_MAX)
+	page = (args->pmd_pfn != ULONG_MAX) ? pfn_to_page(args->pmd_pfn) : NULL;
+	if (!page)
 		return;
 
+	/*
+	 * flush_dcache_page() is called after set_pmd_at() to clear
+	 * PG_arch_1 for the page on ARM64. The page flag isn't cleared
+	 * when it's released and page allocation check will fail when
+	 * the page is allocated again. For architectures other than ARM64,
+	 * the unexpected overhead of cache flushing is acceptable.
+	 */
 	pr_debug("Validating PMD advanced\n");
 	/* Align the address wrt HPAGE_PMD_SIZE */
 	vaddr &= HPAGE_PMD_MASK;
@@ -230,6 +252,7 @@ static void __init pmd_advanced_tests(st
 
 	pmd = pfn_pmd(args->pmd_pfn, args->page_prot);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	flush_dcache_page(page);
 	pmdp_set_wrprotect(args->mm, vaddr, args->pmdp);
 	pmd = READ_ONCE(*args->pmdp);
 	WARN_ON(pmd_write(pmd));
@@ -241,6 +264,7 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_mkclean(pmd);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	flush_dcache_page(page);
 	pmd = pmd_mkwrite(pmd);
 	pmd = pmd_mkdirty(pmd);
 	pmdp_set_access_flags(args->vma, vaddr, args->pmdp, pmd, 1);
@@ -253,6 +277,7 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_mkhuge(pfn_pmd(args->pmd_pfn, args->page_prot));
 	pmd = pmd_mkyoung(pmd);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	flush_dcache_page(page);
 	pmdp_test_and_clear_young(args->vma, vaddr, args->pmdp);
 	pmd = READ_ONCE(*args->pmdp);
 	WARN_ON(pmd_young(pmd));
@@ -339,21 +364,31 @@ static void __init pud_basic_tests(struc
 
 static void __init pud_advanced_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	unsigned long vaddr = args->vaddr;
 	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
 
-	if (args->pud_pfn == ULONG_MAX)
+	page = (args->pud_pfn != ULONG_MAX) ? pfn_to_page(args->pud_pfn) : NULL;
+	if (!page)
 		return;
 
+	/*
+	 * flush_dcache_page() is called after set_pud_at() to clear
+	 * PG_arch_1 for the page on ARM64. The page flag isn't cleared
+	 * when it's released and page allocation check will fail when
+	 * the page is allocated again. For architectures other than ARM64,
+	 * the unexpected overhead of cache flushing is acceptable.
+	 */
 	pr_debug("Validating PUD advanced\n");
 	/* Align the address wrt HPAGE_PUD_SIZE */
 	vaddr &= HPAGE_PUD_MASK;
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	flush_dcache_page(page);
 	pudp_set_wrprotect(args->mm, vaddr, args->pudp);
 	pud = READ_ONCE(*args->pudp);
 	WARN_ON(pud_write(pud));
@@ -367,6 +402,7 @@ static void __init pud_advanced_tests(st
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	flush_dcache_page(page);
 	pud = pud_mkwrite(pud);
 	pud = pud_mkdirty(pud);
 	pudp_set_access_flags(args->vma, vaddr, args->pudp, pud, 1);
@@ -382,6 +418,7 @@ static void __init pud_advanced_tests(st
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
 	pud = pud_mkyoung(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	flush_dcache_page(page);
 	pudp_test_and_clear_young(args->vma, vaddr, args->pudp);
 	pud = READ_ONCE(*args->pudp);
 	WARN_ON(pud_young(pud));
@@ -594,16 +631,26 @@ static void __init pgd_populate_tests(st
 
 static void __init pte_clear_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	pte_t pte = pfn_pte(args->pte_pfn, args->page_prot);
 
-	if (args->pte_pfn == ULONG_MAX)
+	page = (args->pte_pfn != ULONG_MAX) ? pfn_to_page(args->pte_pfn) : NULL;
+	if (!page)
 		return;
 
+	/*
+	 * flush_dcache_page() is called after set_pte_at() to clear
+	 * PG_arch_1 for the page on ARM64. The page flag isn't cleared
+	 * when it's released and page allocation check will fail when
+	 * the page is allocated again. For architectures other than ARM64,
+	 * the unexpected overhead of cache flushing is acceptable.
+	 */
 	pr_debug("Validating PTE clear\n");
 #ifndef CONFIG_RISCV
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 #endif
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	barrier();
 	pte_clear(args->mm, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
_

Patches currently in -mm which might be from gshan@redhat.com are


