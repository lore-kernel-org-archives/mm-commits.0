Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E707C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D86B61056
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhHISHu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhHISHh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 14:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D656101D;
        Mon,  9 Aug 2021 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628532436;
        bh=XdgsRDmcHIIiwyUo6vnnsRtFic8ZsTeZOdFcLIIuGAc=;
        h=Date:From:To:Subject:From;
        b=julUbsyzloi9XI8JPB+m+az31oTSeoYHvNKQzCjVu7KkDn1iZlGeQU4dLHHLFN9ct
         Kc1ao8xa/LBSKIBAR3V6szQ2GwirfIbtf3xMORV4r57Ml62O398c9h/OzvnGY3MHAt
         nNbaORv+UyvF97Evqi0WlvDwUUBvDzs2wtuMonKI=
Date:   Mon, 09 Aug 2021 11:07:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-in?=
 =?us-ascii?Q?-soft=5Fdirty-and-swap-tests.patch?= added to -mm tree
Message-ID: <20210809180716.GAqb_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in soft_dirty and swap tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in soft_dirty and swap tests

This uses struct pgtable_debug_args in the soft_dirty and swap test
functions.

Link: https://lkml.kernel.org/r/20210809092631.1888748-6-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>	[powerpc 8xx]
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   48 +++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests
+++ a/mm/debug_vm_pgtable.c
@@ -752,9 +752,9 @@ static void __init pmd_devmap_tests(stru
 static void __init pud_devmap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
 
-static void __init pte_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
@@ -764,9 +764,9 @@ static void __init pte_soft_dirty_tests(
 	WARN_ON(pte_soft_dirty(pte_clear_soft_dirty(pte)));
 }
 
-static void __init pte_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
@@ -777,7 +777,7 @@ static void __init pte_swap_soft_dirty_t
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -788,12 +788,12 @@ static void __init pmd_soft_dirty_tests(
 		return;
 
 	pr_debug("Validating PMD soft dirty\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 	WARN_ON(!pmd_soft_dirty(pmd_mksoft_dirty(pmd)));
 	WARN_ON(pmd_soft_dirty(pmd_clear_soft_dirty(pmd)));
 }
 
-static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -805,31 +805,29 @@ static void __init pmd_swap_soft_dirty_t
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
-{
-}
+static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args) { }
+static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void __init pte_swap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t swp;
 	pte_t pte;
 
 	pr_debug("Validating PTE swap\n");
-	pte = pfn_pte(pfn, prot);
+	pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 	swp = __pte_to_swp_entry(pte);
 	pte = __swp_entry_to_pte(swp);
-	WARN_ON(pfn != pte_pfn(pte));
+	WARN_ON(args->fixed_pte_pfn != pte_pfn(pte));
 }
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-static void __init pmd_swap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t swp;
 	pmd_t pmd;
@@ -838,13 +836,13 @@ static void __init pmd_swap_tests(unsign
 		return;
 
 	pr_debug("Validating PMD swap\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 	swp = __pmd_to_swp_entry(pmd);
 	pmd = __swp_entry_to_pmd(swp);
-	WARN_ON(pfn != pmd_pfn(pmd));
+	WARN_ON(args->fixed_pmd_pfn != pmd_pfn(pmd));
 }
 #else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
-static void __init pmd_swap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_swap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
 static void __init swap_migration_tests(void)
@@ -1329,13 +1327,13 @@ static int __init debug_vm_pgtable(void)
 	pmd_devmap_tests(&args);
 	pud_devmap_tests(&args);
 
-	pte_soft_dirty_tests(pte_aligned, prot);
-	pmd_soft_dirty_tests(pmd_aligned, prot);
-	pte_swap_soft_dirty_tests(pte_aligned, prot);
-	pmd_swap_soft_dirty_tests(pmd_aligned, prot);
+	pte_soft_dirty_tests(&args);
+	pmd_soft_dirty_tests(&args);
+	pte_swap_soft_dirty_tests(&args);
+	pmd_swap_soft_dirty_tests(&args);
 
-	pte_swap_tests(pte_aligned, prot);
-	pmd_swap_tests(pmd_aligned, prot);
+	pte_swap_tests(&args);
+	pmd_swap_tests(&args);
 
 	swap_migration_tests();
 
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-introduce-struct-pgtable_debug_args.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-basic-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-leaf-and-savewrite-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-protnone-and-devmap-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

