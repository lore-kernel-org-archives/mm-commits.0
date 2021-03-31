Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA70C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDB1C6190A
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhCaErO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCaErA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:47:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDB2A61606;
        Wed, 31 Mar 2021 04:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166020;
        bh=n7Dpj9B4GDbzHtzML5pLhDfcnoOhA0kjSxRPXEDOquo=;
        h=Date:From:To:Subject:From;
        b=qPixIPVlmznWmUCQTmQMl61gXVZzipU1Eg/rqrK8BttE2dOFoDZ7e0nfs2RXzVsx7
         UsGVFfZPu9YB1I987+tYTw+/kbRpUzodAQYXpsMoaWA1jXeejqIDythR5AKvbvipn5
         lJZIx5Qwx1Guma80NrvwvTElRPwNkcYOunWu+sdg=
Date:   Tue, 30 Mar 2021 21:46:59 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch added to
 -mm tree
Message-ID: <20210331044659.AbMlBQqHt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: remove redundant VM_BUG_ON_PAGE() on stable_tree_search()
has been added to the -mm tree.  Its filename is
     ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch

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
Subject: ksm: remove redundant VM_BUG_ON_PAGE() on stable_tree_search()

Patch series "Cleanup and fixup for ksm".

This series contains cleanups to remove unnecessary VM_BUG_ON_PAGE and
dedicated macro KSM_FLAG_MASK.  Also this fixes potential missing
rmap_item for stable_node which would result in failed rmap_walk_ksm(). 
More details can be found in the respective changelogs.


This patch (of 4):

The same VM_BUG_ON_PAGE() check is already done in the callee.  Remove
these extra caller one to simplify code slightly.

Link: https://lkml.kernel.org/r/20210330140228.45635-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210330140228.45635-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/ksm.c~ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search
+++ a/mm/ksm.c
@@ -1771,7 +1771,6 @@ chain_append:
 	 * stable_node_dup is the dup to replace.
 	 */
 	if (stable_node_dup == stable_node) {
-		VM_BUG_ON(is_stable_node_chain(stable_node_dup));
 		VM_BUG_ON(is_stable_node_dup(stable_node_dup));
 		/* chain is missing so create it */
 		stable_node = alloc_stable_node_chain(stable_node_dup,
@@ -1785,7 +1784,6 @@ chain_append:
 	 * of the current nid for this page
 	 * content.
 	 */
-	VM_BUG_ON(!is_stable_node_chain(stable_node));
 	VM_BUG_ON(!is_stable_node_dup(stable_node_dup));
 	VM_BUG_ON(page_node->head != &migrate_nodes);
 	list_del(&page_node->list);
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

