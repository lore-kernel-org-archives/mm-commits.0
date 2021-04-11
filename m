Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBA1C433B4
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8BE611AD
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbhDKWYS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhDKWYQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:24:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C844610E9;
        Sun, 11 Apr 2021 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618179839;
        bh=4klYXeDMBDJyDK5Xlf2t7uajogTZo229r/GmYoHChMs=;
        h=Date:From:To:Subject:From;
        b=ffl0pCBCvJKkY9mxRo9H6Vm33wwutYx5HaJkRyRH3I2R03AGiqwClPxrACP/YhsOt
         U6EjXnCkQbqVXY3EYpfw/lnmMb2jniKD3ZnRKpSe090eXvx0/k/bEoZTWWuaN9vPxT
         H7Hx+gS3tpHZje9IQZCYQ64UMBoUuap1r3JSToVE=
Date:   Sun, 11 Apr 2021 15:23:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        linfeilong@huawei.com, linmiaohe@huawei.com
Subject:  +
 mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch added
 to -mm tree
Message-ID: <20210411222359.mSaEu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: simplify the return code of __vma_reservation_common()
has been added to the -mm tree.  Its filename is
     mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch

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
Subject: mm/hugeltb: simplify the return code of __vma_reservation_common()

It's guaranteed that the vma is associated with a resv_map, i.e.  either
VM_MAYSHARE or HPAGE_RESV_OWNER, when the code reaches here or we would
have returned via !resv check above.  So it's unneeded to check whether
HPAGE_RESV_OWNER is set here.  Simplify the return code to make it more
clear.

Link: https://lkml.kernel.org/r/20210410072348.20437-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/hugetlb.c~mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common
+++ a/mm/hugetlb.c
@@ -2174,27 +2174,26 @@ static long __vma_reservation_common(str
 
 	if (vma->vm_flags & VM_MAYSHARE)
 		return ret;
-	else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) && ret >= 0) {
-		/*
-		 * In most cases, reserves always exist for private mappings.
-		 * However, a file associated with mapping could have been
-		 * hole punched or truncated after reserves were consumed.
-		 * As subsequent fault on such a range will not use reserves.
-		 * Subtle - The reserve map for private mappings has the
-		 * opposite meaning than that of shared mappings.  If NO
-		 * entry is in the reserve map, it means a reservation exists.
-		 * If an entry exists in the reserve map, it means the
-		 * reservation has already been consumed.  As a result, the
-		 * return value of this routine is the opposite of the
-		 * value returned from reserve map manipulation routines above.
-		 */
-		if (ret)
-			return 0;
-		else
-			return 1;
-	}
-	else
-		return ret < 0 ? ret : 0;
+	/*
+	 * We know private mapping must have HPAGE_RESV_OWNER set.
+	 *
+	 * In most cases, reserves always exist for private mappings.
+	 * However, a file associated with mapping could have been
+	 * hole punched or truncated after reserves were consumed.
+	 * As subsequent fault on such a range will not use reserves.
+	 * Subtle - The reserve map for private mappings has the
+	 * opposite meaning than that of shared mappings.  If NO
+	 * entry is in the reserve map, it means a reservation exists.
+	 * If an entry exists in the reserve map, it means the
+	 * reservation has already been consumed.  As a result, the
+	 * return value of this routine is the opposite of the
+	 * value returned from reserve map manipulation routines above.
+	 */
+	if (ret > 0)
+		return 0;
+	if (ret == 0)
+		return 1;
+	return ret;
 }
 
 static long vma_needs_reservation(struct hstate *h,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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
khugepaged-use-helper-function-range_in_vma-in-collapse_pte_mapped_thp.patch
khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch
khugepaged-remove-meaningless-pte_present-check-in-khugepaged_scan_pmd.patch
mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch
mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch
mm-hugeltb-clarify-chg-freed-wont-go-negative-in-hugetlb_unreserve_pages.patch
mm-hugeltb-handle-the-error-case-in-hugetlb_fix_reserve_counts.patch
mm-hugetlb-remove-unused-variable-pseudo_vma-in-remove_inode_hugepages.patch
mm-migratec-make-putback_movable_page-static.patch
mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case.patch
mm-migratec-fix-potential-indeterminate-pte-entry-in-migrate_vma_insert_page.patch
mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole.patch
revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch
ksm-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch
ksm-remove-dedicated-macro-ksm_flag_mask.patch
ksm-fix-potential-missing-rmap_item-for-stable_node.patch

