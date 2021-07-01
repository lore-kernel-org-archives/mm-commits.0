Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72225C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C046146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhGABuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7204D61468;
        Thu,  1 Jul 2021 01:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104060;
        bh=dNuUdCiICTfvtbB62jPvf/7gBHZvB+HwEYMvaen2rEk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y61KpBO41cxFhIPQGvy/ouH7DIoGCrWDMm4j+FgQvREK0yQZam0CqLJliVFIm368N
         u/RSxriYNpwhk7eUxwrRd3ZEszg74dhJhhUqlX0WhCE+zGV1Vv4oLp7luK0Nf8u+1F
         9knbC7xCuObqT9xh3rvhegpHlTrh81DNFgPme+wo=
Date:   Wed, 30 Jun 2021 18:47:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, liushixin2@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 011/192] mm/debug_vm_pgtable: remove redundant
 pfn_{pmd/pte}() and fix one comment mistake
Message-ID: <20210701014740.19O6xELEh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>
Subject: mm/debug_vm_pgtable: remove redundant pfn_{pmd/pte}() and fix one comment mistake

Remove redundant pfn_{pmd/pte}() in {pmd/pte}_advanced_tests() and adjust
pfn_pud() in pud_advanced_tests() to make it similar with other two
functions.

In addition, the branch condition should be CONFIG_TRANSPARENT_HUGEPAGE
instead of CONFIG_ARCH_HAS_PTE_DEVMAP.

Link: https://lkml.kernel.org/r/20210419071820.750217-2-liushixin2@huawei.com
Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake
+++ a/mm/debug_vm_pgtable.c
@@ -91,7 +91,7 @@ static void __init pte_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte;
 
 	/*
 	 * Architectures optimize set_pte_at by avoiding TLB flush.
@@ -778,12 +778,12 @@ static void __init pmd_swap_soft_dirty_t
 	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
-#else  /* !CONFIG_ARCH_HAS_PTE_DEVMAP */
+#else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
 {
 }
-#endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static void __init pte_swap_tests(unsigned long pfn, pgprot_t prot)
 {
_
