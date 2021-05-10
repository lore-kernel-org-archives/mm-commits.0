Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33367C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13CE96142D
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhEJE2K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhEJE2K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D531861409;
        Mon, 10 May 2021 04:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620826;
        bh=mTxbcSB1urZIg8SFkHjdIvX6HjXlCBccdw1gz9EZfLI=;
        h=Date:From:To:Subject:From;
        b=kBKiumPCmRNH/oyYT495tudg6wIgE0UdouiYDb4o+gXhocgU/hOpm8E9Ajti9nqrW
         f2uTTJNYLKFWzy1R1L56XUmVuJu2w0QLBwsgd8ChqZkyPAV/4sPl86yDSCiLyRMyl0
         d//PlkSl4+BGnDLar1WHVd+zlhP4DZXw1BbsCl6s=
Date:   Sun, 09 May 2021 21:27:05 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, liushixin2@huawei.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-move-pmd-pud=5Fhuge=5Ftests-out-of-c?=
 =?US-ASCII?Q?onfig=5Ftransparent=5Fhugepage.patch?= added to -mm tree
Message-ID: <20210510042705.Qh_lO8fTJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: move {pmd/pud}_huge_tests out of CONFIG_TRANSPARENT_HUGEPAGE
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shixin Liu <liushixin2@huawei.com>
Subject: mm/debug_vm_pgtable: move {pmd/pud}_huge_tests out of CONFIG_TRANSPARENT_HUGEPAGE

The functions {pmd/pud}_set_huge and {pmd/pud}_clear_huge are not
dependent on THP.  Hence move {pmd/pud}_huge_tests out of
CONFIG_TRANSPARENT_HUGEPAGE.

Link: https://lkml.kernel.org/r/20210419071820.750217-1-liushixin2@huawei.com
Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   91 +++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 52 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage
+++ a/mm/debug_vm_pgtable.c
@@ -242,29 +242,6 @@ static void __init pmd_leaf_tests(unsign
 	WARN_ON(!pmd_leaf(pmd));
 }
 
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
-{
-	pmd_t pmd;
-
-	if (!arch_vmap_pmd_supported(prot))
-		return;
-
-	pr_debug("Validating PMD huge\n");
-	/*
-	 * X86 defined pmd_set_huge() verifies that the given
-	 * PMD is not a populated non-leaf entry.
-	 */
-	WRITE_ONCE(*pmdp, __pmd(0));
-	WARN_ON(!pmd_set_huge(pmdp, __pfn_to_phys(pfn), prot));
-	WARN_ON(!pmd_clear_huge(pmdp));
-	pmd = READ_ONCE(*pmdp);
-	WARN_ON(!pmd_none(pmd));
-}
-#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
-static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot) { }
-#endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
-
 static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
 {
 	pmd_t pmd = pfn_pmd(pfn, prot);
@@ -379,30 +356,6 @@ static void __init pud_leaf_tests(unsign
 	pud = pud_mkhuge(pud);
 	WARN_ON(!pud_leaf(pud));
 }
-
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
-{
-	pud_t pud;
-
-	if (!arch_vmap_pud_supported(prot))
-		return;
-
-	pr_debug("Validating PUD huge\n");
-	/*
-	 * X86 defined pud_set_huge() verifies that the given
-	 * PUD is not a populated non-leaf entry.
-	 */
-	WRITE_ONCE(*pudp, __pud(0));
-	WARN_ON(!pud_set_huge(pudp, __pfn_to_phys(pfn), prot));
-	WARN_ON(!pud_clear_huge(pudp));
-	pud = READ_ONCE(*pudp);
-	WARN_ON(!pud_none(pud));
-}
-#else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
-#endif /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
-
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(struct mm_struct *mm, unsigned long pfn, int idx) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
@@ -412,9 +365,6 @@ static void __init pud_advanced_tests(st
 {
 }
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
-{
-}
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(unsigned long pfn, int idx) { }
@@ -433,14 +383,51 @@ static void __init pud_advanced_tests(st
 }
 static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
 {
+	pmd_t pmd;
+
+	if (!arch_vmap_pmd_supported(prot))
+		return;
+
+	pr_debug("Validating PMD huge\n");
+	/*
+	 * X86 defined pmd_set_huge() verifies that the given
+	 * PMD is not a populated non-leaf entry.
+	 */
+	WRITE_ONCE(*pmdp, __pmd(0));
+	WARN_ON(!pmd_set_huge(pmdp, __pfn_to_phys(pfn), prot));
+	WARN_ON(!pmd_clear_huge(pmdp));
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(!pmd_none(pmd));
 }
+
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
 {
+	pud_t pud;
+
+	if (!arch_vmap_pud_supported(prot))
+		return;
+
+	pr_debug("Validating PUD huge\n");
+	/*
+	 * X86 defined pud_set_huge() verifies that the given
+	 * PUD is not a populated non-leaf entry.
+	 */
+	WRITE_ONCE(*pudp, __pud(0));
+	WARN_ON(!pud_set_huge(pudp, __pfn_to_phys(pfn), prot));
+	WARN_ON(!pud_clear_huge(pudp));
+	pud = READ_ONCE(*pudp);
+	WARN_ON(!pud_none(pud));
 }
-static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot) { }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot) { }
+static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 static void __init p4d_basic_tests(unsigned long pfn, pgprot_t prot)
 {
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch
mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch

