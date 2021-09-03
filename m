Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23F7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D951610E6
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhICU4k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238770AbhICU4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7008610E8;
        Fri,  3 Sep 2021 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702535;
        bh=zsUvUVRcm+0wBZQ2Ib95PjXQhCjVHnr0cBnKojt8dXY=;
        h=Date:From:To:Subject:From;
        b=t0N75Et6Ia0k8D6L4oveYhRMETKMMHedRJbkYtCHf9VZa3VXFnejwkcRr0LsAdBTw
         PTbzu6DAaww0NRikNeZssiA+MvVC9qgS2sWBgxHKTDv7+TTr+3N3ysoFXVroF3Qgyq
         RuavqajTapYnpkg85h2cor17t6UuYwv07OQz309c=
Date:   Fri, 03 Sep 2021 13:55:34 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, cai@lca.pw,
        catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
        chuhu@redhat.com, gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-in?=
 =?US-ASCII?Q?-protnone-and-devmap-tests.patch?= removed from -mm tree
Message-ID: <20210903205534.aYX0QcW2R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in protnone and devmap tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-protnone-and-devmap-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in protnone and devmap tests

This uses struct pgtable_debug_args in protnone and devmap test functions.
After that, the unused variable @protnone in debug_vm_pgtable() is
dropped.

Link: https://lkml.kernel.org/r/20210809092631.1888748-5-gshan@redhat.com
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

 mm/debug_vm_pgtable.c |   60 ++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-protnone-and-devmap-tests
+++ a/mm/debug_vm_pgtable.c
@@ -662,9 +662,9 @@ static void __init pmd_populate_tests(st
 	WARN_ON(pmd_bad(pmd));
 }
 
-static void __init pte_special_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_special_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL))
 		return;
@@ -673,9 +673,9 @@ static void __init pte_special_tests(uns
 	WARN_ON(!pte_special(pte_mkspecial(pte)));
 }
 
-static void __init pte_protnone_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_protnone_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
@@ -686,7 +686,7 @@ static void __init pte_protnone_tests(un
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -697,25 +697,25 @@ static void __init pmd_protnone_tests(un
 		return;
 
 	pr_debug("Validating PMD protnone\n");
-	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+	pmd = pmd_mkhuge(pfn_pmd(args->fixed_pmd_pfn, args->page_prot_none));
 	WARN_ON(!pmd_protnone(pmd));
 	WARN_ON(!pmd_present(pmd));
 }
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_protnone_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
-static void __init pte_devmap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_devmap_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
 	pr_debug("Validating PTE devmap\n");
 	WARN_ON(!pte_devmap(pte_mkdevmap(pte)));
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_devmap_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -723,12 +723,12 @@ static void __init pmd_devmap_tests(unsi
 		return;
 
 	pr_debug("Validating PMD devmap\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 	WARN_ON(!pmd_devmap(pmd_mkdevmap(pmd)));
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_devmap_tests(struct pgtable_debug_args *args)
 {
 	pud_t pud;
 
@@ -736,20 +736,20 @@ static void __init pud_devmap_tests(unsi
 		return;
 
 	pr_debug("Validating PUD devmap\n");
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->fixed_pud_pfn, args->page_prot);
 	WARN_ON(!pud_devmap(pud_mkdevmap(pud)));
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_devmap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_devmap_tests(struct pgtable_debug_args *args) { }
+static void __init pud_devmap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #else
-static void __init pte_devmap_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pte_devmap_tests(struct pgtable_debug_args *args) { }
+static void __init pmd_devmap_tests(struct pgtable_debug_args *args) { }
+static void __init pud_devmap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
 
 static void __init pte_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
@@ -1227,7 +1227,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_t *pmdp, *saved_pmdp, pmd;
 	pte_t *ptep;
 	pgtable_t saved_ptep;
-	pgprot_t prot, protnone;
+	pgprot_t prot;
 	phys_addr_t paddr;
 	unsigned long vaddr, pte_aligned, pmd_aligned;
 	unsigned long pud_aligned;
@@ -1247,12 +1247,6 @@ static int __init debug_vm_pgtable(void)
 		return 1;
 	}
 
-	/*
-	 * __P000 (or even __S000) will help create page table entries with
-	 * PROT_NONE permission as required for pxx_protnone_tests().
-	 */
-	protnone = __P000;
-
 	vma = vm_area_alloc(mm);
 	if (!vma) {
 		pr_err("vma allocation failed\n");
@@ -1327,13 +1321,13 @@ static int __init debug_vm_pgtable(void)
 	pte_savedwrite_tests(&args);
 	pmd_savedwrite_tests(&args);
 
-	pte_special_tests(pte_aligned, prot);
-	pte_protnone_tests(pte_aligned, protnone);
-	pmd_protnone_tests(pmd_aligned, protnone);
-
-	pte_devmap_tests(pte_aligned, prot);
-	pmd_devmap_tests(pmd_aligned, prot);
-	pud_devmap_tests(pud_aligned, prot);
+	pte_special_tests(&args);
+	pte_protnone_tests(&args);
+	pmd_protnone_tests(&args);
+
+	pte_devmap_tests(&args);
+	pmd_devmap_tests(&args);
+	pud_devmap_tests(&args);
 
 	pte_soft_dirty_tests(pte_aligned, prot);
 	pmd_soft_dirty_tests(pmd_aligned, prot);
_

Patches currently in -mm which might be from gshan@redhat.com are


