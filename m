Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1607DC07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020AA613E4
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhGJDn4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDn4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AF8C613E3;
        Sat, 10 Jul 2021 03:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888471;
        bh=SiiYqPmtXDbP/zctDIiegN6i0dN2ReKa7DYzJOjwrzM=;
        h=Date:From:To:Subject:From;
        b=ULEiizJK2037FuC4DChZjdT/y4JgauOSqytrAKoX+YX9bPSTB7fdZgdnxfBeVUL0E
         4E6jxZejULdumPPj6oP4XBnG73EcIi/1KHsD/jmBedK1aDUR9Xxa8kq1xVKJzfkImA
         NSQduha/plSgXmUqAexgy7kDk0Z2SpMDitbQY5Tk=
Date:   Fri, 09 Jul 2021 20:41:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-vm=5Fpgtable=5Fdebug-i?=
 =?us-ascii?Q?n-leaf-and-savewrite-tests.patch?= added to -mm tree
Message-ID: <20210710034111.Ri9hG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in leaf and savewrite tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-leaf-and-savewrite-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-leaf-and-savewrite-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-leaf-and-savewrite-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in leaf and savewrite tests

This uses struct vm_pgtable_debug in the leaf and savewrite test
functions.

Link: https://lkml.kernel.org/r/20210706061748.161258-4-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-leaf-and-savewrite-tests
+++ a/mm/debug_vm_pgtable.c
@@ -160,9 +160,9 @@ static void __init pte_advanced_tests(st
 	WARN_ON(pte_young(pte));
 }
 
-static void __init pte_savedwrite_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_savedwrite_tests(struct vm_pgtable_debug *debug)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(debug->fixed_pte_pfn, debug->page_prot_none);
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
@@ -261,7 +261,7 @@ static void __init pmd_advanced_tests(st
 	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
 }
 
-static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_leaf_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
 
@@ -269,7 +269,7 @@ static void __init pmd_leaf_tests(unsign
 		return;
 
 	pr_debug("Validating PMD leaf\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(debug->fixed_pmd_pfn, debug->page_prot);
 
 	/*
 	 * PMD based THP is a leaf entry.
@@ -278,7 +278,7 @@ static void __init pmd_leaf_tests(unsign
 	WARN_ON(!pmd_leaf(pmd));
 }
 
-static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_savedwrite_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
 
@@ -289,7 +289,7 @@ static void __init pmd_savedwrite_tests(
 		return;
 
 	pr_debug("Validating PMD saved write\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(debug->fixed_pmd_pfn, debug->page_prot_none);
 	WARN_ON(!pmd_savedwrite(pmd_mk_savedwrite(pmd_clear_savedwrite(pmd))));
 	WARN_ON(pmd_savedwrite(pmd_clear_savedwrite(pmd_mk_savedwrite(pmd))));
 }
@@ -387,7 +387,7 @@ static void __init pud_advanced_tests(st
 	pudp_huge_get_and_clear(mm, vaddr, pudp);
 }
 
-static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_leaf_tests(struct vm_pgtable_debug *debug)
 {
 	pud_t pud;
 
@@ -395,7 +395,7 @@ static void __init pud_leaf_tests(unsign
 		return;
 
 	pr_debug("Validating PUD leaf\n");
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(debug->fixed_pud_pfn, debug->page_prot);
 	/*
 	 * PUD based THP is a leaf entry.
 	 */
@@ -410,7 +410,7 @@ static void __init pud_advanced_tests(st
 				      pgprot_t prot)
 {
 }
-static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_leaf_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(struct vm_pgtable_debug *debug, int idx) { }
@@ -427,9 +427,9 @@ static void __init pud_advanced_tests(st
 				      pgprot_t prot)
 {
 }
-static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_leaf_tests(struct vm_pgtable_debug *debug) { }
+static void __init pud_leaf_tests(struct vm_pgtable_debug *debug) { }
+static void __init pmd_savedwrite_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
@@ -1264,11 +1264,11 @@ static int __init debug_vm_pgtable(void)
 	pgd_basic_tests();
 	hugetlb_basic_tests(&debug);
 
-	pmd_leaf_tests(pmd_aligned, prot);
-	pud_leaf_tests(pud_aligned, prot);
+	pmd_leaf_tests(&debug);
+	pud_leaf_tests(&debug);
 
-	pte_savedwrite_tests(pte_aligned, protnone);
-	pmd_savedwrite_tests(pmd_aligned, protnone);
+	pte_savedwrite_tests(&debug);
+	pmd_savedwrite_tests(&debug);
 
 	pte_special_tests(pte_aligned, prot);
 	pte_protnone_tests(pte_aligned, protnone);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-debug_vm_pgtable-introduce-struct-vm_pgtable_debug.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-basic-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-leaf-and-savewrite-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-protnone-and-devmap-tests.patch
mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-soft_dirty-and-swap-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-migration-and-thp-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pte-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pmd-modifying-tests.patch
mm-vm_debug_pgtable-use-struct-vm_pgtable_debug-in-pud-modifying-tests.patch
mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-pgd-and-p4d-modifying-tests.patch
mm-debug_vm_pgtable-remove-unused-code.patch
mm-debug_vm_pgtable-fix-corrupted-page-flag.patch

