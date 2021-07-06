Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37468C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21F3C61C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhGFTTK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTTK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFE461C87;
        Tue,  6 Jul 2021 19:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598990;
        bh=cg5CoDwBrAL3olkxvderkCqCKVVGwAQfoESjyUC4E6I=;
        h=Date:From:To:Subject:From;
        b=HH95sEMTjpPRQ20lLqpJifvfDZYGaxnk9E57A/k4f3qEcWDg4LKs+91eGUyro1Yu7
         VJZxNPy9hkRG6+EymU4GaZKNfmz9ri2yKYCzX8S78jaBy0uRlJCYqQrVPLTOaQ6Dke
         viU+OWKA29gigAdQOUSGYjMRWq8PvXik9KY2nkgY=
Date:   Tue, 06 Jul 2021 12:16:30 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, liushixin2@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-remove-redundant-pfn=5Fpmd-pte-and-f?=
 =?US-ASCII?Q?ix-one-comment-mistake.patch?= removed from -mm tree
Message-ID: <20210706191630.3x_8gxLbs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: remove redundant pfn_{pmd/pte}() and fix one comment mistake
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from liushixin2@huawei.com are


