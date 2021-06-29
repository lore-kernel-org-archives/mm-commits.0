Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DB1C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4626E61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF2Chj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2Chi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E55FF61D03;
        Tue, 29 Jun 2021 02:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934111;
        bh=ToBOjZv52pvR6C4cVouZXOpI+HkjOfSgOvVnbe3NFxM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aLkRM/mLs37dxw2S0nE5b/n4CUuMn0xPyDUz/dx75d00ZjxxCI+TW4vKjR6w5hVt0
         xdwazFAVWdigvFOWdyKRlvNGY5WEwvCZW8juq783Y4ni+qvI7AWrmoog98OkupK4qz
         XMDh2ecmo6/xbwVqBx0ie0szF6qMjllF/AwAYTnM=
Date:   Mon, 28 Jun 2021 19:35:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 036/192] mm/debug_vm_pgtable: ensure THP
 availability via has_transparent_hugepage()
Message-ID: <20210629023510.MaqJhVzCv%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: ensure THP availability via has_transparent_hugepage()

On certain platforms, THP support could not just be validated via the
build option CONFIG_TRANSPARENT_HUGEPAGE.  Instead
has_transparent_hugepage() also needs to be called upon to verify THP
runtime support.  Otherwise the debug test will just run into unusable THP
helpers like in the case of a 4K hash config on powerpc platform [1]. 
This just moves all pfn_pmd() and pfn_pud() after THP runtime validation
with has_transparent_hugepage() which prevents the mentioned problem.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=213069

Link: https://lkml.kernel.org/r/1621397588-19211-1-git-send-email-anshuman.khandual@arm.com
Fixes: 787d563b8642 ("mm/debug_vm_pgtable: fix kernel crash by checking for THP support")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   63 ++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 12 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-ensure-thp-availability-via-has_transparent_hugepage
+++ a/mm/debug_vm_pgtable.c
@@ -146,13 +146,14 @@ static void __init pte_savedwrite_tests(
 static void __init pmd_basic_tests(unsigned long pfn, int idx)
 {
 	pgprot_t prot = protection_map[idx];
-	pmd_t pmd = pfn_pmd(pfn, prot);
 	unsigned long val = idx, *ptr = &val;
+	pmd_t pmd;
 
 	if (!has_transparent_hugepage())
 		return;
 
 	pr_debug("Validating PMD basic (%pGv)\n", ptr);
+	pmd = pfn_pmd(pfn, prot);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -185,7 +186,7 @@ static void __init pmd_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot, pgtable_t pgtable)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
 
 	if (!has_transparent_hugepage())
 		return;
@@ -232,9 +233,14 @@ static void __init pmd_advanced_tests(st
 
 static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
+
+	if (!has_transparent_hugepage())
+		return;
 
 	pr_debug("Validating PMD leaf\n");
+	pmd = pfn_pmd(pfn, prot);
+
 	/*
 	 * PMD based THP is a leaf entry.
 	 */
@@ -267,12 +273,16 @@ static void __init pmd_huge_tests(pmd_t
 
 static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
 
+	if (!has_transparent_hugepage())
+		return;
+
 	pr_debug("Validating PMD saved write\n");
+	pmd = pfn_pmd(pfn, prot);
 	WARN_ON(!pmd_savedwrite(pmd_mk_savedwrite(pmd_clear_savedwrite(pmd))));
 	WARN_ON(pmd_savedwrite(pmd_clear_savedwrite(pmd_mk_savedwrite(pmd))));
 }
@@ -281,13 +291,14 @@ static void __init pmd_savedwrite_tests(
 static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx)
 {
 	pgprot_t prot = protection_map[idx];
-	pud_t pud = pfn_pud(pfn, prot);
 	unsigned long val = idx, *ptr = &val;
+	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
 
 	pr_debug("Validating PUD basic (%pGv)\n", ptr);
+	pud = pfn_pud(pfn, prot);
 
 	/*
 	 * This test needs to be executed after the given page table entry
@@ -323,7 +334,7 @@ static void __init pud_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot)
 {
-	pud_t pud = pfn_pud(pfn, prot);
+	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
@@ -332,6 +343,7 @@ static void __init pud_advanced_tests(st
 	/* Align the address wrt HPAGE_PUD_SIZE */
 	vaddr &= HPAGE_PUD_MASK;
 
+	pud = pfn_pud(pfn, prot);
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_set_wrprotect(mm, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
@@ -370,9 +382,13 @@ static void __init pud_advanced_tests(st
 
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
 {
-	pud_t pud = pfn_pud(pfn, prot);
+	pud_t pud;
+
+	if (!has_transparent_hugepage())
+		return;
 
 	pr_debug("Validating PUD leaf\n");
+	pud = pfn_pud(pfn, prot);
 	/*
 	 * PUD based THP is a leaf entry.
 	 */
@@ -654,12 +670,16 @@ static void __init pte_protnone_tests(un
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+	pmd_t pmd;
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
 
+	if (!has_transparent_hugepage())
+		return;
+
 	pr_debug("Validating PMD protnone\n");
+	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 	WARN_ON(!pmd_protnone(pmd));
 	WARN_ON(!pmd_present(pmd));
 }
@@ -679,18 +699,26 @@ static void __init pte_devmap_tests(unsi
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
+
+	if (!has_transparent_hugepage())
+		return;
 
 	pr_debug("Validating PMD devmap\n");
+	pmd = pfn_pmd(pfn, prot);
 	WARN_ON(!pmd_devmap(pmd_mkdevmap(pmd)));
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot)
 {
-	pud_t pud = pfn_pud(pfn, prot);
+	pud_t pud;
+
+	if (!has_transparent_hugepage())
+		return;
 
 	pr_debug("Validating PUD devmap\n");
+	pud = pfn_pud(pfn, prot);
 	WARN_ON(!pud_devmap(pud_mkdevmap(pud)));
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
@@ -733,25 +761,33 @@ static void __init pte_swap_soft_dirty_t
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
 
+	if (!has_transparent_hugepage())
+		return;
+
 	pr_debug("Validating PMD soft dirty\n");
+	pmd = pfn_pmd(pfn, prot);
 	WARN_ON(!pmd_soft_dirty(pmd_mksoft_dirty(pmd)));
 	WARN_ON(pmd_soft_dirty(pmd_clear_soft_dirty(pmd)));
 }
 
 static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
 		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
+	if (!has_transparent_hugepage())
+		return;
+
 	pr_debug("Validating PMD swap soft dirty\n");
+	pmd = pfn_pmd(pfn, prot);
 	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
@@ -780,6 +816,9 @@ static void __init pmd_swap_tests(unsign
 	swp_entry_t swp;
 	pmd_t pmd;
 
+	if (!has_transparent_hugepage())
+		return;
+
 	pr_debug("Validating PMD swap\n");
 	pmd = pfn_pmd(pfn, prot);
 	swp = __pmd_to_swp_entry(pmd);
_
