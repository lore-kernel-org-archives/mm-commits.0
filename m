Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E98C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68409650DF
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCHWyZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhCHWyL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 17:54:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA4F365173;
        Mon,  8 Mar 2021 22:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244050;
        bh=DjgekrxBStaQB/V5HTy/BNJUaQmykdPs5Z0JE8pZTnk=;
        h=Date:From:To:Subject:From;
        b=BdS13W4yxDGDhkHwmj0n0+BgnotNI/O28g1q9WUDI+21ODu+M0gXO3VOLOU/H9g6X
         XQzIixoWsXVV9Qij0JMmgaGyRTNIbf4lnLCkOuNYwSbqvC5fj9N4iRELGamaGx1dZw
         KzPovlv0jeERMRWjECTA07B3TSR+np4lX8oXyJdU=
Date:   Mon, 08 Mar 2021 14:54:10 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch added to -mm
 tree
Message-ID: <20210308225410.aiUXrC5wF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove unnecessary local variable ret2
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch

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
Subject: mm/huge_memory.c: remove unnecessary local variable ret2

There is no need to use a new local variable ret2 to get the return value
of handle_userfault(). Use ret directly to make code more succinct.

Link: https://lkml.kernel.org/r/20210210072409.60587-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-remove-unnecessary-local-variable-ret2
+++ a/mm/huge_memory.c
@@ -624,14 +624,12 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		/* Deliver the page fault to userland */
 		if (userfaultfd_missing(vma)) {
-			vm_fault_t ret2;
-
 			spin_unlock(vmf->ptl);
 			put_page(page);
 			pte_free(vma->vm_mm, pgtable);
-			ret2 = handle_userfault(vmf, VM_UFFD_MISSING);
-			VM_BUG_ON(ret2 & VM_FAULT_FALLBACK);
-			return ret2;
+			ret = handle_userfault(vmf, VM_UFFD_MISSING);
+			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
+			return ret;
 		}
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
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
mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch

