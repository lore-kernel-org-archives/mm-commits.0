Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F8CC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAAFE60FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhG0UoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhG0UoV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8303660FA0;
        Tue, 27 Jul 2021 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418660;
        bh=+AVrF0fADuyBL8W1+ZXQyW+UDcPChl33iQ87IFslHsU=;
        h=Date:From:To:Subject:From;
        b=R+DHfGppGMzGRulQS2tBivhuUv7UHxGQldZl1PJhtQZ4SzNf5MGvCA20qBTPA0vNl
         TZTHN0GW3SxBqNVHACSN6a2HdYrdoGLXnOtMndRZJ+he7REeUGwTuTUnUebqENa4pc
         WoGapw/xAwejlvP6Lt97+tyRNN3UVP9e3tdocwgU=
Date:   Tue, 27 Jul 2021 13:44:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-in?=
 =?us-ascii?Q?-soft=5Fdirty-and-swap-tests.patch?= removed from -mm tree
Message-ID: <20210727204420.3Y0Zc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in soft_dirty and swap tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in soft_dirty and swap tests

This uses struct pgtable_debug_args in the soft_dirty and swap test
functions.

Link: https://lkml.kernel.org/r/20210719130613.334901-6-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   48 +++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-soft_dirty-and-swap-tests
+++ a/mm/debug_vm_pgtable.c
@@ -751,9 +751,9 @@ static void __init pmd_devmap_tests(stru
 static void __init pud_devmap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
 
-static void __init pte_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
@@ -763,9 +763,9 @@ static void __init pte_soft_dirty_tests(
 	WARN_ON(pte_soft_dirty(pte_clear_soft_dirty(pte)));
 }
 
-static void __init pte_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
@@ -776,7 +776,7 @@ static void __init pte_swap_soft_dirty_t
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -787,12 +787,12 @@ static void __init pmd_soft_dirty_tests(
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
 
@@ -804,31 +804,29 @@ static void __init pmd_swap_soft_dirty_t
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
@@ -837,13 +835,13 @@ static void __init pmd_swap_tests(unsign
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
@@ -1257,13 +1255,13 @@ static int __init debug_vm_pgtable(void)
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

mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

