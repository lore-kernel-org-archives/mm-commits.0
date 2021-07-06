Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DF6C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E1561C97
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhGFTTI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTTH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8606961C7A;
        Tue,  6 Jul 2021 19:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598988;
        bh=HMB/Y7mBlxfREdxiyH6djQ0VDf5jPA5SySC4m+hn/Iw=;
        h=Date:From:To:Subject:From;
        b=1lVLymUlizhlD7uIrGglo1WDsXmpAAbdh+xUjoHJWlimNbT8qFkSgIw7N88bO9a0Y
         SReFHAx2jmQdz8FCdqv2MdU6s5oWhKUwokBS4NAuxACblGr+QwTZ+at7xRV2ObHAJd
         nrnXRThmGMoN+yOeRthlIRoYkAj365QDzs4PG3+Y=
Date:   Tue, 06 Jul 2021 12:16:28 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, liushixin2@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-move-pmd-pud=5Fhuge=5Ftests-out-of-c?=
 =?US-ASCII?Q?onfig=5Ftransparent=5Fhugepage.patch?= removed from -mm tree
Message-ID: <20210706191628._Q2Nzj9Hm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: move {pmd/pud}_huge_tests out of CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -248,29 +248,6 @@ static void __init pmd_leaf_tests(unsign
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
 	pmd_t pmd;
@@ -395,30 +372,6 @@ static void __init pud_leaf_tests(unsign
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
@@ -428,9 +381,6 @@ static void __init pud_advanced_tests(st
 {
 }
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
-{
-}
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(unsigned long pfn, int idx) { }
@@ -449,14 +399,51 @@ static void __init pud_advanced_tests(st
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


