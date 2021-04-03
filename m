Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382AFC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15BA861184
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhDCAaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235720AbhDCAaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:30:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C76611AD;
        Sat,  3 Apr 2021 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617409814;
        bh=V1GuxRtW5G2SdP0sQhN4Qzyf/CBXmJvml71U3YP30WQ=;
        h=Date:From:To:Subject:From;
        b=JkCW6z8yLeDBucAEdDoIZL0yNU+3OqeMpjX4TeNKnWRgWZi9gV+iA2oWd74FaID7x
         yOEl31uiYYlArYVZbMoq0R94r3FgwjQrq1kVFV9rJibLckZIpo953HCHzwYq5qO2Q0
         Sma9dausk6KhT+KlhzEsXSQzCoWmx4qPdLAK2ND4=
Date:   Fri, 02 Apr 2021 17:30:13 -0700
From:   akpm@linux-foundation.org
To:     hillf.zj@alibaba-inc.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com
Subject:  +
 mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch added to -mm tree
Message-ID: <20210403003013.1JiBw7qEp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: remove redundant VM_BUG_ON() in region_add()
has been added to the -mm tree.  Its filename is
     mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch

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
Subject: mm/hugeltb: remove redundant VM_BUG_ON() in region_add()

Patch series "Cleanup and fixup for hugetlb".

This series contains cleanups to remove redundant VM_BUG_ON() and simplify
the return code.  Also this fixes potential wrong gbl_reserve value and
handle the error case in hugetlb_fix_reserve_counts().  More details can
be found in the respective changelogs.


This patch (of 4):

The same VM_BUG_ON() check is already done in the callee.  Remove this
extra one to simplify the code slightly.

Link: https://lkml.kernel.org/r/20210402093249.25137-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210402093249.25137-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugeltb-remove-redundant-vm_bug_on-in-region_add
+++ a/mm/hugetlb.c
@@ -557,7 +557,6 @@ retry:
 	resv->adds_in_progress -= in_regions_needed;
 
 	spin_unlock(&resv->lock);
-	VM_BUG_ON(add < 0);
 	return add;
 }
 
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
mm-hugeltb-fix-potential-wrong-gbl_reserve-value-for-hugetlb_acct_memory.patch
mm-hugeltb-handle-the-error-case-in-hugetlb_fix_reserve_counts.patch
mm-migratec-make-putback_movable_page-static.patch
mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case.patch
mm-migratec-fix-potential-indeterminate-pte-entry-in-migrate_vma_insert_page.patch
mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole.patch
revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch
ksm-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch
ksm-remove-dedicated-macro-ksm_flag_mask.patch
ksm-fix-potential-missing-rmap_item-for-stable_node.patch

