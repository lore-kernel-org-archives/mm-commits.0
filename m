Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D14C07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E056101B
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhGTV3w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhGTV3H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3F461019;
        Tue, 20 Jul 2021 22:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626818983;
        bh=ImZk89/b8x1lYkPLgJDBLNXMGvRaiTuX5yBDg/6+bfI=;
        h=Date:From:To:Subject:From;
        b=j+uej3j2tAz3TCjdE6jf0aWeU76obCFbLK3THDjdBeyNvygor8cl/3FGn9JwGtTsV
         EsVLZsnk5oY9aoNqHMPMA9nbLxqkxOH1ISH0KiMC6YyIKEhKK8mf3LhA09m8OzKivp
         eMzdF6wmcURYCCPbY45enItRCKRc+rRk/QFzVUZQ=
Date:   Tue, 20 Jul 2021 15:09:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-fix-corrupted-page-flag.patch removed from -mm tree
Message-ID: <20210720220942.VcLij%akpm@linux-foundation.org>
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

In page table entry modifying tests, set_{pud, pmd, pte}_at() are used to
populate the page table entries.  On ARM64, PG_arch_1 is set to the target
page flag if execution permission is given.  The page flag is kept when
the page is free'd to buddy's free area list.  However, it will trigger
page checking failure when it's pulled from the buddy's free area list, as
the following warning messages indicate.

   BUG: Bad page state in process memhog  pfn:08000
   page:0000000015c0a628 refcount:0 mapcount:0 \
        mapping:0000000000000000 index:0x1 pfn:0x8000
   flags: 0x7ffff8000000800(arch_1|node=0|zone=0|lastcpupid=0xfffff)
   raw: 07ffff8000000800 dead000000000100 dead000000000122 0000000000000000
   raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
   page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag(s) set

This fixes the issue by clearing PG_arch_1 through flush_dcache_page(),
right after set_{pud, pmd, pte}_at() is called.

Link: https://lkml.kernel.org/r/20210706061748.161258-13-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

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
 
@@ -110,6 +112,7 @@ static void __init pte_basic_tests(struc
 
 static void __init pte_advanced_tests(struct vm_pgtable_debug *debug)
 {
+	struct page *page;
 	pte_t pte;
 
 	/*
@@ -119,13 +122,17 @@ static void __init pte_advanced_tests(st
 	 */
 
 	pr_debug("Validating PTE advanced\n");
-	if (debug->pte_pfn == ULONG_MAX) {
+
+	page = (debug->pte_pfn != ULONG_MAX) ?
+	       pfn_to_page(debug->pte_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
 
 	pte = pfn_pte(debug->pte_pfn, debug->page_prot);
 	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
+	flush_dcache_page(page);
 	ptep_set_wrprotect(debug->mm, debug->vaddr, debug->ptep);
 	pte = ptep_get(debug->ptep);
 	WARN_ON(pte_write(pte));
@@ -137,6 +144,7 @@ static void __init pte_advanced_tests(st
 	pte = pte_wrprotect(pte);
 	pte = pte_mkclean(pte);
 	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
+	flush_dcache_page(page);
 	pte = pte_mkwrite(pte);
 	pte = pte_mkdirty(pte);
 	ptep_set_access_flags(debug->vma, debug->vaddr, debug->ptep, pte, 1);
@@ -149,6 +157,7 @@ static void __init pte_advanced_tests(st
 	pte = pfn_pte(debug->pte_pfn, debug->page_prot);
 	pte = pte_mkyoung(pte);
 	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
+	flush_dcache_page(page);
 	ptep_test_and_clear_young(debug->vma, debug->vaddr, debug->ptep);
 	pte = ptep_get(debug->ptep);
 	WARN_ON(pte_young(pte));
@@ -207,6 +216,7 @@ static void __init pmd_basic_tests(struc
 
 static void __init pmd_advanced_tests(struct vm_pgtable_debug *debug)
 {
+	struct page *page;
 	pmd_t pmd;
 	unsigned long vaddr = (debug->vaddr & HPAGE_PMD_MASK);
 
@@ -214,7 +224,10 @@ static void __init pmd_advanced_tests(st
 		return;
 
 	pr_debug("Validating PMD advanced\n");
-	if (debug->pmd_pfn == ULONG_MAX) {
+
+	page = (debug->pmd_pfn != ULONG_MAX) ?
+	       pfn_to_page(debug->pmd_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
@@ -223,6 +236,7 @@ static void __init pmd_advanced_tests(st
 
 	pmd = pfn_pmd(debug->pmd_pfn, debug->page_prot);
 	set_pmd_at(debug->mm, vaddr, debug->pmdp, pmd);
+	flush_dcache_page(page);
 	pmdp_set_wrprotect(debug->mm, vaddr, debug->pmdp);
 	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(pmd_write(pmd));
@@ -234,6 +248,7 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_mkclean(pmd);
 	set_pmd_at(debug->mm, vaddr, debug->pmdp, pmd);
+	flush_dcache_page(page);
 	pmd = pmd_mkwrite(pmd);
 	pmd = pmd_mkdirty(pmd);
 	pmdp_set_access_flags(debug->vma, vaddr, debug->pmdp, pmd, 1);
@@ -246,6 +261,7 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_mkhuge(pfn_pmd(debug->pmd_pfn, debug->page_prot));
 	pmd = pmd_mkyoung(pmd);
 	set_pmd_at(debug->mm, vaddr, debug->pmdp, pmd);
+	flush_dcache_page(page);
 	pmdp_test_and_clear_young(debug->vma, vaddr, debug->pmdp);
 	pmd = READ_ONCE(*(debug->pmdp));
 	WARN_ON(pmd_young(pmd));
@@ -332,6 +348,7 @@ static void __init pud_basic_tests(struc
 
 static void __init pud_advanced_tests(struct vm_pgtable_debug *debug)
 {
+	struct page *page;
 	unsigned long vaddr = (debug->vaddr & HPAGE_PUD_MASK);
 	pud_t pud;
 
@@ -339,13 +356,17 @@ static void __init pud_advanced_tests(st
 		return;
 
 	pr_debug("Validating PUD advanced\n");
-	if (debug->pud_pfn == ULONG_MAX) {
+
+	page = (debug->pud_pfn != ULONG_MAX) ?
+	       pfn_to_page(debug->pud_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
 
 	pud = pfn_pud(debug->pud_pfn, debug->page_prot);
 	set_pud_at(debug->mm, vaddr, debug->pudp, pud);
+	flush_dcache_page(page);
 	pudp_set_wrprotect(debug->mm, vaddr, debug->pudp);
 	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(pud_write(pud));
@@ -359,6 +380,7 @@ static void __init pud_advanced_tests(st
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(debug->mm, vaddr, debug->pudp, pud);
+	flush_dcache_page(page);
 	pud = pud_mkwrite(pud);
 	pud = pud_mkdirty(pud);
 	pudp_set_access_flags(debug->vma, vaddr, debug->pudp, pud, 1);
@@ -374,6 +396,7 @@ static void __init pud_advanced_tests(st
 	pud = pfn_pud(debug->pud_pfn, debug->page_prot);
 	pud = pud_mkyoung(pud);
 	set_pud_at(debug->mm, vaddr, debug->pudp, pud);
+	flush_dcache_page(page);
 	pudp_test_and_clear_young(debug->vma, vaddr, debug->pudp);
 	pud = READ_ONCE(*(debug->pudp));
 	WARN_ON(pud_young(pud));
@@ -588,10 +611,14 @@ static void __init pgd_populate_tests(st
 
 static void __init pte_clear_tests(struct vm_pgtable_debug *debug)
 {
+	struct page *page;
 	pte_t pte;
 
 	pr_debug("Validating PTE clear\n");
-	if (debug->pte_pfn == ULONG_MAX) {
+
+	page = (debug->pte_pfn != ULONG_MAX) ?
+	       pfn_to_page(debug->pte_pfn) : NULL;
+	if (!page) {
 		pr_debug("%s: Skipped\n", __func__);
 		return;
 	}
@@ -601,6 +628,7 @@ static void __init pte_clear_tests(struc
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 #endif
 	set_pte_at(debug->mm, debug->vaddr, debug->ptep, pte);
+	flush_dcache_page(page);
 	barrier();
 	pte_clear(debug->mm, debug->vaddr, debug->ptep);
 	pte = ptep_get(debug->ptep);
_

Patches currently in -mm which might be from gshan@redhat.com are


