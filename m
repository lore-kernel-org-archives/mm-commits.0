Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30616C433E4
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10B461994
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCSXPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 19:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCSXPN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 19:15:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 350EC61986;
        Fri, 19 Mar 2021 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616195713;
        bh=QT8gtsLG3/s3InGCjh6+nfelTX5CyuC0DuVrjWHcXD0=;
        h=Date:From:To:Subject:From;
        b=WjoM1ISCKDbAXDd+SKc0HDHStn2UGrWBFLAwa9qYUglBFniX1N8fB5WEgbEVsEaS6
         mie4iwbXP0lbuQf3LZux2e9/uLC1wTPO+7rtG4DmnesfzjHaNUdShwZmlklmNxyprr
         x22Xys2Tha7GQPd7N8QenqBexmsFTSv1Z5b63S0A=
Date:   Fri, 19 Mar 2021 16:15:12 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  +
 mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch added to
 -mm tree
Message-ID: <20210319231512.u3sqdTQqn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: rework the function vma_adjust_trans_huge()
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch

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
Subject: mm/huge_memory.c: rework the function vma_adjust_trans_huge()

Patch series "Some cleanups for huge_memory", v3.

This series contains cleanups to rework some function logics to make it
more readable, use helper function and so on.  More details can be found
in the respective changelogs.


This patch (of 6):

The current implementation of vma_adjust_trans_huge() contains some
duplicated codes.  Add helper function to get rid of these codes to make
it more succinct.

Link: https://lkml.kernel.org/r/20210318122722.13135-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210318122722.13135-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Peter Xu <peterx@redhat.com>
Cc: yuleixzhang <yulei.kernel@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Thomas Hellstrm (Intel) <thomas_os@shipmail.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge
+++ a/mm/huge_memory.c
@@ -2314,44 +2314,38 @@ void split_huge_pmd_address(struct vm_ar
 	__split_huge_pmd(vma, pmd, address, freeze, page);
 }
 
+static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+{
+	/*
+	 * If the new address isn't hpage aligned and it could previously
+	 * contain an hugepage: check if we need to split an huge pmd.
+	 */
+	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
+	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
+			 ALIGN(address, HPAGE_PMD_SIZE)))
+		split_huge_pmd_address(vma, address, false, NULL);
+}
+
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			     unsigned long start,
 			     unsigned long end,
 			     long adjust_next)
 {
-	/*
-	 * If the new start address isn't hpage aligned and it could
-	 * previously contain an hugepage: check if we need to split
-	 * an huge pmd.
-	 */
-	if (start & ~HPAGE_PMD_MASK &&
-	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
-	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_pmd_address(vma, start, false, NULL);
+	/* Check if we need to split start first. */
+	split_huge_pmd_if_needed(vma, start);
 
-	/*
-	 * If the new end address isn't hpage aligned and it could
-	 * previously contain an hugepage: check if we need to split
-	 * an huge pmd.
-	 */
-	if (end & ~HPAGE_PMD_MASK &&
-	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
-	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_pmd_address(vma, end, false, NULL);
+	/* Check if we need to split end next. */
+	split_huge_pmd_if_needed(vma, end);
 
 	/*
-	 * If we're also updating the vma->vm_next->vm_start, if the new
-	 * vm_next->vm_start isn't hpage aligned and it could previously
-	 * contain an hugepage: check if we need to split an huge pmd.
+	 * If we're also updating the vma->vm_next->vm_start,
+	 * check if we need to split it.
 	 */
 	if (adjust_next > 0) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long nstart = next->vm_start;
 		nstart += adjust_next;
-		if (nstart & ~HPAGE_PMD_MASK &&
-		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
-		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
-			split_huge_pmd_address(next, nstart, false, NULL);
+		split_huge_pmd_if_needed(next, nstart);
 	}
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch
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
mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch
mm-huge_memoryc-make-get_huge_zero_page-return-bool.patch
mm-huge_memoryc-rework-the-function-do_huge_pmd_numa_page-slightly.patch
mm-huge_memoryc-remove-redundant-pagecompound-check.patch
mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch
mm-huge_memoryc-use-helper-function-migration_entry_to_page.patch

