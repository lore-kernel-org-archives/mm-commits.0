Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0058C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC1C260FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhG0UoY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhG0UoY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD1560D07;
        Tue, 27 Jul 2021 20:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418663;
        bh=YY7L/ebW/Xvxw2YfIjnit4IYJts9A6gYu6IfhBMzV9E=;
        h=Date:From:To:Subject:From;
        b=EJY0IG4OQWdqRoPmpIEZJ2B948YmS+QjWzdjHpH5xvEmCUNNYPXjdg6xSFQvslp8i
         sZfJCubBwuMSrBp6ZGPVZLEOK5XErEzC3WUNkSQy1t2DcGzS/G41UI+z1/WrABKQ5Z
         HLK04fyKbAbYIk4hj8s1srYM12wILyL8NghQc3Ng=
Date:   Tue, 27 Jul 2021 13:44:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-?=
 =?us-ascii?Q?in-migration-and-thp-tests.patch?= removed from -mm tree
Message-ID: <20210727204423.Uzuh4%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in migration and thp tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in migration and thp tests

This uses struct pgtable_debug_args in the migration and thp test
functions.  It's notable that the pre-allocated page is used in
swap_migration_tests() as set_pte_at() is used there.

Link: https://lkml.kernel.org/r/20210719130613.334901-7-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests
+++ a/mm/debug_vm_pgtable.c
@@ -844,7 +844,7 @@ static void __init pmd_swap_tests(struct
 static void __init pmd_swap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
-static void __init swap_migration_tests(void)
+static void __init swap_migration_tests(struct pgtable_debug_args *args)
 {
 	struct page *page;
 	swp_entry_t swp;
@@ -860,9 +860,10 @@ static void __init swap_migration_tests(
 	 * problematic. Lets allocate a dedicated page explicitly for this
 	 * purpose that will be freed subsequently.
 	 */
-	page = alloc_page(GFP_KERNEL);
+	page = (args->pte_pfn != ULONG_MAX) ?
+	       pfn_to_page(args->pte_pfn) : NULL;
 	if (!page) {
-		pr_err("page allocation failed\n");
+		pr_err("no page available\n");
 		return;
 	}
 
@@ -883,7 +884,6 @@ static void __init swap_migration_tests(
 	WARN_ON(!is_migration_entry(swp));
 	WARN_ON(is_writable_migration_entry(swp));
 	__ClearPageLocked(page);
-	__free_page(page);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -915,7 +915,7 @@ static void __init hugetlb_basic_tests(s
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_thp_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_thp_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -934,7 +934,7 @@ static void __init pmd_thp_tests(unsigne
 	 * needs to return true. pmd_present() should be true whenever
 	 * pmd_trans_huge() returns true.
 	 */
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 	WARN_ON(!pmd_trans_huge(pmd_mkhuge(pmd)));
 
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
@@ -944,7 +944,7 @@ static void __init pmd_thp_tests(unsigne
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_thp_tests(struct pgtable_debug_args *args)
 {
 	pud_t pud;
 
@@ -952,7 +952,7 @@ static void __init pud_thp_tests(unsigne
 		return;
 
 	pr_debug("Validating PUD based THP\n");
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->fixed_pud_pfn, args->page_prot);
 	WARN_ON(!pud_trans_huge(pud_mkhuge(pud)));
 
 	/*
@@ -964,11 +964,11 @@ static void __init pud_thp_tests(unsigne
 	 */
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_thp_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_thp_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_thp_tests(struct pgtable_debug_args *args) { }
+static void __init pud_thp_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static unsigned long __init get_random_vaddr(void)
@@ -1263,10 +1263,10 @@ static int __init debug_vm_pgtable(void)
 	pte_swap_tests(&args);
 	pmd_swap_tests(&args);
 
-	swap_migration_tests();
+	swap_migration_tests(&args);
 
-	pmd_thp_tests(pmd_aligned, prot);
-	pud_thp_tests(pud_aligned, prot);
+	pmd_thp_tests(&args);
+	pud_thp_tests(&args);
 
 	/*
 	 * Page table modifying tests. They need to hold
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pmd-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

