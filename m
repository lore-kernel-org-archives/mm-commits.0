Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B03AC4320A
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CD860F9E
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhG0Uol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhG0Uol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:44:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E619460F9C;
        Tue, 27 Jul 2021 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418681;
        bh=UvNuSFlJONYei9XPrKZ7wA/gofQGp9om6IpS404Hrgs=;
        h=Date:From:To:Subject:From;
        b=LfUr6EMIQ9OC7mH65as3hBIgI7da/9iI5D6hRaDZ629+BPQWnV7VMPQQO1Xd2xYHs
         nwNorB6gOb7EE8SFt0wB8Z8ziGe2wVpxkC4Uc/4nC8Xstf6Lzt0jfPQwNVMvYxRo7H
         cjjaY7qpmRWFza2hGwlF5QU+YmbfZd8VnNuaY+rY=
Date:   Tue, 27 Jul 2021 13:44:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-fix-corrupted-page-flag.patch removed from -mm tree
Message-ID: <20210727204440.yAtxa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: fix corrupted page flag
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: fix corrupted page flag

In page table entry modifying tests, set_xxx_at() are used to populate the
page table entries.  On ARM64, PG_arch_1 is set to the target page flag if
execution permission is given.  The page flag is kept when the page is
free'd to buddy's free area list.  However, it will trigger page checking
failure when it's pulled from the buddy's free area list, as the following
warning messages indicate.

   BUG: Bad page state in process memhog  pfn:08000
   page:0000000015c0a628 refcount:0 mapcount:0 \
        mapping:0000000000000000 index:0x1 pfn:0x8000
   flags: 0x7ffff8000000800(arch_1|node=0|zone=0|lastcpupid=0xfffff)
   raw: 07ffff8000000800 dead000000000100 dead000000000122 0000000000000000
   raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
   page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag(s) set

This fixes the issue by clearing PG_arch_1 through flush_dcache_page()
after set_xxx_at() is called.

Link: https://lkml.kernel.org/r/20210719130613.334901-13-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

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
 
@@ -118,6 +120,7 @@ static void __init pte_basic_tests(struc
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	pte_t pte;
 
 	/*
@@ -127,13 +130,16 @@ static void __init pte_advanced_tests(st
 	 */
 
 	pr_debug("Validating PTE advanced\n");
-	if (args->pte_pfn == ULONG_MAX) {
+	page = (args->pte_pfn != ULONG_MAX) ?
+	       pfn_to_page(args->pte_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
 
 	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	ptep_set_wrprotect(args->mm, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_write(pte));
@@ -145,6 +151,7 @@ static void __init pte_advanced_tests(st
 	pte = pte_wrprotect(pte);
 	pte = pte_mkclean(pte);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	pte = pte_mkwrite(pte);
 	pte = pte_mkdirty(pte);
 	ptep_set_access_flags(args->vma, args->vaddr, args->ptep, pte, 1);
@@ -157,6 +164,7 @@ static void __init pte_advanced_tests(st
 	pte = pfn_pte(args->pte_pfn, args->page_prot);
 	pte = pte_mkyoung(pte);
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	ptep_test_and_clear_young(args->vma, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_young(pte));
@@ -215,6 +223,7 @@ static void __init pmd_basic_tests(struc
 
 static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	pmd_t pmd;
 	unsigned long vaddr = (args->vaddr & HPAGE_PMD_MASK);
 
@@ -222,7 +231,9 @@ static void __init pmd_advanced_tests(st
 		return;
 
 	pr_debug("Validating PMD advanced\n");
-	if (args->pmd_pfn == ULONG_MAX) {
+	page = (args->pmd_pfn != ULONG_MAX) ?
+	       pfn_to_page(args->pmd_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
@@ -231,6 +242,7 @@ static void __init pmd_advanced_tests(st
 
 	pmd = pfn_pmd(args->pmd_pfn, args->page_prot);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	flush_dcache_page(page);
 	pmdp_set_wrprotect(args->mm, vaddr, args->pmdp);
 	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(pmd_write(pmd));
@@ -242,6 +254,7 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_mkclean(pmd);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	flush_dcache_page(page);
 	pmd = pmd_mkwrite(pmd);
 	pmd = pmd_mkdirty(pmd);
 	pmdp_set_access_flags(args->vma, vaddr, args->pmdp, pmd, 1);
@@ -254,6 +267,7 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_mkhuge(pfn_pmd(args->pmd_pfn, args->page_prot));
 	pmd = pmd_mkyoung(pmd);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+	flush_dcache_page(page);
 	pmdp_test_and_clear_young(args->vma, vaddr, args->pmdp);
 	pmd = READ_ONCE(*(args->pmdp));
 	WARN_ON(pmd_young(pmd));
@@ -340,6 +354,7 @@ static void __init pud_basic_tests(struc
 
 static void __init pud_advanced_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	unsigned long vaddr = (args->vaddr & HPAGE_PUD_MASK);
 	pud_t pud;
 
@@ -347,13 +362,16 @@ static void __init pud_advanced_tests(st
 		return;
 
 	pr_debug("Validating PUD advanced\n");
-	if (args->pud_pfn == ULONG_MAX) {
+	page = (args->pud_pfn != ULONG_MAX) ?
+	       pfn_to_page(args->pud_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	flush_dcache_page(page);
 	pudp_set_wrprotect(args->mm, vaddr, args->pudp);
 	pud = READ_ONCE(*(args->pudp));
 	WARN_ON(pud_write(pud));
@@ -367,6 +385,7 @@ static void __init pud_advanced_tests(st
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	flush_dcache_page(page);
 	pud = pud_mkwrite(pud);
 	pud = pud_mkdirty(pud);
 	pudp_set_access_flags(args->vma, vaddr, args->pudp, pud, 1);
@@ -382,6 +401,7 @@ static void __init pud_advanced_tests(st
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
 	pud = pud_mkyoung(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
+	flush_dcache_page(page);
 	pudp_test_and_clear_young(args->vma, vaddr, args->pudp);
 	pud = READ_ONCE(*(args->pudp));
 	WARN_ON(pud_young(pud));
@@ -596,10 +616,13 @@ static void __init pgd_populate_tests(st
 
 static void __init pte_clear_tests(struct pgtable_debug_args *args)
 {
+	struct page *page;
 	pte_t pte;
 
 	pr_debug("Validating PTE clear\n");
-	if (args->pte_pfn == ULONG_MAX) {
+	page = (args->pte_pfn != ULONG_MAX) ?
+	       pfn_to_page(args->pte_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
@@ -609,6 +632,7 @@ static void __init pte_clear_tests(struc
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 #endif
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	flush_dcache_page(page);
 	barrier();
 	pte_clear(args->mm, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
_

Patches currently in -mm which might be from gshan@redhat.com are


