Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F0AC07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893AF613EC
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhGJDn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGJDn6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:43:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F14613E4;
        Sat, 10 Jul 2021 03:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888473;
        bh=KfWEn7pb7W6sVhSZom7QMtCCvvmI2OOPSA4mfn+yJDc=;
        h=Date:From:To:Subject:From;
        b=TJAxkSgMWCJdGKRbrcITsDzdyLKUCUUkV1ulGxZMXUWPiBhOT8E+FIgNhbcGrJOAs
         TMDvQ/g7tXn90TdnQ/eABkItmMeKpYWk9tX48YZDlyXUQPV1K5BJiHdOeXoPc7KPtN
         8LjklGjokVPleZiKZ8kb5I8if3CCfsMlm5gOApIQ=
Date:   Fri, 09 Jul 2021 20:41:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, chuhu@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        gshan@redhat.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-use-struct-vm=5Fpgtable=5Fdebug-in?=
 =?us-ascii?Q?-protnone-and-devmap-tests.patch?= added to -mm tree
Message-ID: <20210710034113.UG04u%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in protnone and devmap tests
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-protnone-and-devmap-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-protnone-and-devmap-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-protnone-and-devmap-tests.patch

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
Subject: mm/debug_vm_pgtable: use struct vm_pgtable_debug in protnone and devmap tests

This uses struct vm_pgtable_debug in protnone and devmap test functions.

Link: https://lkml.kernel.org/r/20210706061748.161258-5-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyu Hu <chuhu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   52 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-struct-vm_pgtable_debug-in-protnone-and-devmap-tests
+++ a/mm/debug_vm_pgtable.c
@@ -661,9 +661,9 @@ static void __init pmd_populate_tests(st
 	WARN_ON(pmd_bad(pmd));
 }
 
-static void __init pte_special_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_special_tests(struct vm_pgtable_debug *debug)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(debug->fixed_pte_pfn, debug->page_prot);
 
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL))
 		return;
@@ -672,9 +672,9 @@ static void __init pte_special_tests(uns
 	WARN_ON(!pte_special(pte_mkspecial(pte)));
 }
 
-static void __init pte_protnone_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_protnone_tests(struct vm_pgtable_debug *debug)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(debug->fixed_pte_pfn, debug->page_prot_none);
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
@@ -685,7 +685,7 @@ static void __init pte_protnone_tests(un
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_protnone_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
 
@@ -696,25 +696,25 @@ static void __init pmd_protnone_tests(un
 		return;
 
 	pr_debug("Validating PMD protnone\n");
-	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+	pmd = pmd_mkhuge(pfn_pmd(debug->fixed_pmd_pfn, debug->page_prot_none));
 	WARN_ON(!pmd_protnone(pmd));
 	WARN_ON(!pmd_present(pmd));
 }
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_protnone_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
-static void __init pte_devmap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pte_devmap_tests(struct vm_pgtable_debug *debug)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte = pfn_pte(debug->fixed_pte_pfn, debug->page_prot);
 
 	pr_debug("Validating PTE devmap\n");
 	WARN_ON(!pte_devmap(pte_mkdevmap(pte)));
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pmd_devmap_tests(struct vm_pgtable_debug *debug)
 {
 	pmd_t pmd;
 
@@ -722,12 +722,12 @@ static void __init pmd_devmap_tests(unsi
 		return;
 
 	pr_debug("Validating PMD devmap\n");
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pfn_pmd(debug->fixed_pmd_pfn, debug->page_prot);
 	WARN_ON(!pmd_devmap(pmd_mkdevmap(pmd)));
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot)
+static void __init pud_devmap_tests(struct vm_pgtable_debug *debug)
 {
 	pud_t pud;
 
@@ -735,20 +735,20 @@ static void __init pud_devmap_tests(unsi
 		return;
 
 	pr_debug("Validating PUD devmap\n");
-	pud = pfn_pud(pfn, prot);
+	pud = pfn_pud(debug->fixed_pud_pfn, debug->page_prot);
 	WARN_ON(!pud_devmap(pud_mkdevmap(pud)));
 }
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_devmap_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* CONFIG_TRANSPARENT_HUGEPAGE */
-static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_devmap_tests(struct vm_pgtable_debug *debug) { }
+static void __init pud_devmap_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #else
-static void __init pte_devmap_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pte_devmap_tests(struct vm_pgtable_debug *debug) { }
+static void __init pmd_devmap_tests(struct vm_pgtable_debug *debug) { }
+static void __init pud_devmap_tests(struct vm_pgtable_debug *debug) { }
 #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
 
 static void __init pte_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
@@ -1270,13 +1270,13 @@ static int __init debug_vm_pgtable(void)
 	pte_savedwrite_tests(&debug);
 	pmd_savedwrite_tests(&debug);
 
-	pte_special_tests(pte_aligned, prot);
-	pte_protnone_tests(pte_aligned, protnone);
-	pmd_protnone_tests(pmd_aligned, protnone);
-
-	pte_devmap_tests(pte_aligned, prot);
-	pmd_devmap_tests(pmd_aligned, prot);
-	pud_devmap_tests(pud_aligned, prot);
+	pte_special_tests(&debug);
+	pte_protnone_tests(&debug);
+	pmd_protnone_tests(&debug);
+
+	pte_devmap_tests(&debug);
+	pmd_devmap_tests(&debug);
+	pud_devmap_tests(&debug);
 
 	pte_soft_dirty_tests(pte_aligned, prot);
 	pmd_soft_dirty_tests(pmd_aligned, prot);
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

