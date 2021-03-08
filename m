Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FE8C43381
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD0A6528A
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCHVCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhCHVC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 16:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA676652AB;
        Mon,  8 Mar 2021 21:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615237347;
        bh=e7kiJS3EW96+D09FRdtIhsrMv7joK2nH551JIvJiwr4=;
        h=Date:From:To:Subject:From;
        b=rZ8qOSKJaFtlDxmbx7wR2ZBDvetDE24BuFh49eUSAiLQUHN6JIuz4O4PGTHlIqlTc
         60W0iaE2917pWy9zbt1K+YC/lJa/m1AfuS47cgR1IES1a+N0ZEFBuzhzawK7QUJDty
         U+qzUW8KMXE4dR6mvUj7nOTCM708imDr/hGYJHIM=
Date:   Mon, 08 Mar 2021 13:02:26 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ebru.akagunduz@gmail.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@redhat.com
Subject:  +
 khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch added to -mm
 tree
Message-ID: <20210308210226.T_pBYgbUk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: reuse the smp_wmb() inside __SetPageUptodate()
has been added to the -mm tree.  Its filename is
     khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: reuse the smp_wmb() inside __SetPageUptodate()

smp_wmb() is needed to avoid the copy_huge_page writes to become visible
after the set_pmd_at() write here.  But we can reuse the smp_wmb() inside
__SetPageUptodate() to remove this redundant one.

Link: https://lkml.kernel.org/r/20210306032947.35921-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate
+++ a/mm/khugepaged.c
@@ -1183,19 +1183,18 @@ static void collapse_huge_page(struct mm
 	__collapse_huge_page_copy(pte, new_page, vma, address, pte_ptl,
 			&compound_pagelist);
 	pte_unmap(pte);
+	/*
+	 * spin_lock() below is not the equivalent of smp_wmb(), but
+	 * the smp_wmb() inside __SetPageUptodate() can be reused to
+	 * avoid the copy_huge_page writes to become visible after
+	 * the set_pmd_at() write.
+	 */
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 
 	_pmd = mk_huge_pmd(new_page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
-	/*
-	 * spin_lock() below is not the equivalent of smp_wmb(), so
-	 * this is needed to avoid the copy_huge_page writes to become
-	 * visible after the set_pmd_at() write.
-	 */
-	smp_wmb();
-
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address, true);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch
khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch
khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter.patch
khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch

