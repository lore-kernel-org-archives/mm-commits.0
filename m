Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1CEC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5EDD60FBF
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhG0Uwx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231961AbhG0Uww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:52:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9150C6056B;
        Tue, 27 Jul 2021 20:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627419171;
        bh=1bPx/jsmTpm5ZRoJCrqbw6ozUTJzFNsHZ8cN8C/t6Qg=;
        h=Date:From:To:Subject:From;
        b=B5PNK/HEPc2DceLzSgulnoRBrR+MQSIfUOZabu4Ub/jHL/eNXjozTaj05tAVr5BGX
         jfw0W06o+N53Sx+4PihkmNt7RbRpaHDb4MscGUB790wWphxpYasXqDBTfyGjMgkdLn
         wlPGcNMChzpKHhIv01QWutcqy6Mboau+iorHdL8w=
Date:   Tue, 27 Jul 2021 13:52:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        gerald.schaefer@linux.ibm.com, chuhu@redhat.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com, cai@lca.pw,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        gshan@redhat.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-pgtable=5Fdebug=5Fargs-?=
 =?us-ascii?Q?in-migration-and-thp-tests.patch?= added to -mm tree
Message-ID: <20210727205251.t4M69%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in migration and thp tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct pgtable_debug_args in migration and thp tests

This uses struct pgtable_debug_args in the migration and thp test
functions.  It's notable that the pre-allocated page is used in
swap_migration_tests() as set_pte_at() is used there.

Link: https://lkml.kernel.org/r/20210727061401.592616-7-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-pgtable_debug_args-in-migration-and-thp-tests
+++ a/mm/debug_vm_pgtable.c
@@ -845,7 +845,7 @@ static void __init pmd_swap_tests(struct
 static void __init pmd_swap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
-static void __init swap_migration_tests(void)
+static void __init swap_migration_tests(struct pgtable_debug_args *args)
 {
 	struct page *page;
 	swp_entry_t swp;
@@ -861,9 +861,10 @@ static void __init swap_migration_tests(
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
 
@@ -884,7 +885,6 @@ static void __init swap_migration_tests(
 	WARN_ON(!is_migration_entry(swp));
 	WARN_ON(is_writable_migration_entry(swp));
 	__ClearPageLocked(page);
-	__free_page(page);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -916,7 +916,7 @@ static void __init hugetlb_basic_tests(s
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_thp_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_thp_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -935,7 +935,7 @@ static void __init pmd_thp_tests(unsigne
 	 * needs to return true. pmd_present() should be true whenever
 	 * pmd_trans_huge() returns true.
 	 */
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot);
 	WARN_ON(!pmd_trans_huge(pmd_mkhuge(pmd)));
 
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
@@ -945,7 +945,7 @@ static void __init pmd_thp_tests(unsigne
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_thp_tests(struct pgtable_debug_args *args)
 {
 	pud_t pud;
 
@@ -953,7 +953,7 @@ static void __init pud_thp_tests(unsigne
 		return;
 
 	pr_debug("Validating PUD based THP\n");
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(args->fixed_pud_pfn, args->page_prot);
 	WARN_ON(!pud_trans_huge(pud_mkhuge(pud)));
 
 	/*
@@ -965,11 +965,11 @@ static void __init pud_thp_tests(unsigne
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
@@ -1345,10 +1345,10 @@ static int __init debug_vm_pgtable(void)
 	pte_swap_tests(&args);
 	pmd_swap_tests(&args);
 
-	swap_migration_tests();
+	swap_migration_tests(&args);
 
-	pmd_thp_tests(pmd_aligned, prot);
-	pud_thp_tests(pud_aligned, prot);
+	pmd_thp_tests(&args);
+	pud_thp_tests(&args);
 
 	hugetlb_basic_tests(&args);
 
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

