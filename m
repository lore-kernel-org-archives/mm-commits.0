Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8E9C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BEBF216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881253;
	bh=rLf11sD7nHjYMgkyLj4rNQ1nywfvBBSvAT2rjueGj4k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TFy7M19upR/oxtkUiWaVd/nLakGhIbF29SXFz0WlHN0KOfqvgavkVKl/qVHoPNfXu
	 SBwi+9FUS4JHncDVrLieCXt3DcbS9LHHB2aMzKuWeO0Rptg39AyI9G+zLQiYeB6jI1
	 zrlbvLvXVpyr7JGgMfp9nX122WcTC+ydyVIF+rDI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391398AbgJPUrc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUrc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C432620878;
        Fri, 16 Oct 2020 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881252;
        bh=rLf11sD7nHjYMgkyLj4rNQ1nywfvBBSvAT2rjueGj4k=;
        h=Date:From:To:Subject:From;
        b=jgH1RC9kmq37lWxGBYR9Zj6urskOsxalVTpJ/i1nWnRcrk9gQEOzADQDEt5XZ0Uxu
         pV9XMvbt+YFm5kR9+KaEypPfpkqZFF1VbcIW7nZnjbJptFRDgWjJno+IdujYXuXyDr
         09qUaGz0E2wmEigtcjxn3zkxmLcTUiQFIT51RETI=
Date:   Fri, 16 Oct 2020 13:47:31 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtables-hugevmap-use-the-arch-helper-to-?=
 =?US-ASCII?Q?identify-huge-vmap-support.patch?= removed from -mm tree
Message-ID: <20201016204731.N_I3nKKH4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtables/hugevmap: use the arch helper to identify huge vmap support.
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtables/hugevmap: use the arch helper to identify huge vmap support.

ppc64 supports huge vmap only with radix translation.  Hence use arch
helper to determine the huge vmap support.

Link: https://lkml.kernel.org/r/20200902114222.181353-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support
+++ a/mm/debug_vm_pgtable.c
@@ -28,6 +28,7 @@
 #include <linux/swapops.h>
 #include <linux/start_kernel.h>
 #include <linux/sched/mm.h>
+#include <linux/io.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -206,11 +207,12 @@ static void __init pmd_leaf_tests(unsign
 	WARN_ON(!pmd_leaf(pmd));
 }
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+	if (!arch_ioremap_pmd_supported())
 		return;
 
 	pr_debug("Validating PMD huge\n");
@@ -224,6 +226,9 @@ static void __init pmd_huge_tests(pmd_t
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!pmd_none(pmd));
 }
+#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
+static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
 {
@@ -320,11 +325,12 @@ static void __init pud_leaf_tests(unsign
 	WARN_ON(!pud_leaf(pud));
 }
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
 {
 	pud_t pud;
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+	if (!arch_ioremap_pud_supported())
 		return;
 
 	pr_debug("Validating PUD huge\n");
@@ -338,6 +344,10 @@ static void __init pud_huge_tests(pud_t
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!pud_none(pud));
 }
+#else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
+#endif /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


