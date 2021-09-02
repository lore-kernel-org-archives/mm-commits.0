Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B1DC43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552126113E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347724AbhIBVx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347715AbhIBVxZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:53:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23F66112E;
        Thu,  2 Sep 2021 21:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619546;
        bh=xOrApKRrchXFPVZwM6Tv/zzssvHfmXlkyGQ35la78uw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zxTpskieunmxRaNCP8F/nfQitD3KvWE3b4AJBO7bIZnYcLuf4i6Ir+RqzTyhV4d3B
         GPiK4dwOOJPtJ+9d6MnQoSmgqFOrXYdh+a1Tqlxs+gtsnpRJZGJrtEhRGFTxu9RZZc
         Zp6HWk35mZrhKiXDbtnyAADvIpStgP8qyBw51GYk=
Date:   Thu, 02 Sep 2021 14:52:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, cai@lca.pw, catalin.marinas@arm.com,
        christophe.leroy@csgroup.eu, chuhu@redhat.com,
        gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 046/212] mm/debug_vm_pgtable: use struct
 pgtable_debug_args in leaf and savewrite tests
Message-ID: <20210902215225.S-cMxFoqM%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in leaf and savewrite tests

This uses struct pgtable_debug_args in the leaf and savewrite test
functions.

Link: https://lkml.kernel.org/r/20210809092631.1888748-4-gshan@redhat.com
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

 mm/debug_vm_pgtable.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-leaf-and-savewrite-tests
+++ a/mm/debug_vm_pgtable.c
@@ -161,9 +161,9 @@ static void __init pte_advanced_tests(st
 	WARN_ON(pte_young(pte));
 }
 
-static void __init pte_savedwrite_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_savedwrite_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
@@ -262,7 +262,7 @@ static void __init pmd_advanced_tests(st
 	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
 }
 
-static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_leaf_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -270,7 +270,7 @@ static void __init pmd_leaf_tests(unsign
 		return;
 
 	pr_debug("Validating PMD leaf\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 
 	/*
 	 * PMD based THP is a leaf entry.
@@ -279,7 +279,7 @@ static void __init pmd_leaf_tests(unsign
 	WARN_ON(!pmd_leaf(pmd));
 }
 
-static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_savedwrite_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -290,7 +290,7 @@ static void __init pmd_savedwrite_tests(
 		return;
 
 	pr_debug("Validating PMD saved write\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot_none);
 	WARN_ON(!pmd_savedwrite(pmd_mk_savedwrite(pmd_clear_savedwrite(pmd))));
 	WARN_ON(pmd_savedwrite(pmd_clear_savedwrite(pmd_mk_savedwrite(pmd))));
 }
@@ -388,7 +388,7 @@ static void __init pud_advanced_tests(st
 	pudp_huge_get_and_clear(mm, vaddr, pudp);
 }
 
-static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_leaf_tests(struct pgtable_debug_args *args)
 {
 	pud_t pud;
 
@@ -396,7 +396,7 @@ static void __init pud_leaf_tests(unsign
 		return;
 
 	pr_debug("Validating PUD leaf\n");
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->fixed_pud_pfn, args->page_prot);
 	/*
 	 * PUD based THP is a leaf entry.
 	 */
@@ -411,7 +411,7 @@ static void __init pud_advanced_tests(st
 				      pgprot_t prot)
 {
 }
-static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_leaf_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx) { }
@@ -428,9 +428,9 @@ static void __init pud_advanced_tests(st
 				      pgprot_t prot)
 {
 }
-static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_leaf_tests(struct pgtable_debug_args *args) { }
+static void __init pud_leaf_tests(struct pgtable_debug_args *args) { }
+static void __init pmd_savedwrite_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
@@ -1321,11 +1321,11 @@ static int __init debug_vm_pgtable(void)
 	p4d_basic_tests(&args);
 	pgd_basic_tests(&args);
 
-	pmd_leaf_tests(pmd_aligned, prot);
-	pud_leaf_tests(pud_aligned, prot);
+	pmd_leaf_tests(&args);
+	pud_leaf_tests(&args);
 
-	pte_savedwrite_tests(pte_aligned, protnone);
-	pmd_savedwrite_tests(pmd_aligned, protnone);
+	pte_savedwrite_tests(&args);
+	pmd_savedwrite_tests(&args);
 
 	pte_special_tests(pte_aligned, prot);
 	pte_protnone_tests(pte_aligned, protnone);
_
