Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F1EC43461
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2307B611F0
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhDKWVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235920AbhDKWVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90018610E9;
        Sun, 11 Apr 2021 22:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618179647;
        bh=8NuBf8huyHwmKlJCtRzj2LVE7Wv9bUXLxTI68Ad0LmY=;
        h=Date:From:To:Subject:From;
        b=PTdSKcQ895ORV/XlSfQFQFhik+nB5I48biPojvxObBcnvPxRqgVOcWz5UGEUNb5dm
         TU8NuR8fU7gwQBaXCc9qmbnIrTIIl0rtObROzQuQNQtI6deM3Bp+blpKxWSdU6qeHU
         3NiB9FSu5srhuB6ntzOMsPNlPLsfqr8tD1fHnE5c=
Date:   Sun, 11 Apr 2021 15:20:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        mike.kravetz@oracle.com, hillf.zj@alibaba-inc.com,
        linmiaohe@huawei.com
Subject:  [to-be-updated]
 mm-hugeltb-handle-the-error-case-in-hugetlb_fix_reserve_counts.patch removed
 from -mm tree
Message-ID: <20210411222047.eSR0t%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
has been removed from the -mm tree.  Its filename was
     mm-hugeltb-handle-the-error-case-in-hugetlb_fix_reserve_counts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()

A rare out of memory error would prevent removal of the reserve map region
for a page.  hugetlb_fix_reserve_counts() handles this rare case to avoid
dangling with incorrect counts.  Unfortunately, hugepage_subpool_get_pages
and hugetlb_acct_memory could possibly fail too.  We should correctly
handle these cases.

Link: https://lkml.kernel.org/r/20210402093249.25137-5-linmiaohe@huawei.com
Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugeltb-handle-the-error-case-in-hugetlb_fix_reserve_counts
+++ a/mm/hugetlb.c
@@ -746,13 +746,20 @@ void hugetlb_fix_reserve_counts(struct i
 {
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	long rsv_adjust;
+	bool reserved = false;
 
 	rsv_adjust = hugepage_subpool_get_pages(spool, 1);
-	if (rsv_adjust) {
+	if (rsv_adjust > 0) {
 		struct hstate *h = hstate_inode(inode);
 
-		hugetlb_acct_memory(h, 1);
+		if (!hugetlb_acct_memory(h, 1))
+			reserved = true;
+	} else if (!rsv_adjust) {
+		reserved = true;
 	}
+
+	if (!reserved)
+		pr_warn("hugetlb: fix reserve count failed\n");
 }
 
 /*
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
mm-migratec-make-putback_movable_page-static.patch
mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case.patch
mm-migratec-fix-potential-indeterminate-pte-entry-in-migrate_vma_insert_page.patch
mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole.patch
revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch
ksm-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch
ksm-remove-dedicated-macro-ksm_flag_mask.patch
ksm-fix-potential-missing-rmap_item-for-stable_node.patch

