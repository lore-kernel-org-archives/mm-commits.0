Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAC6C433E6
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C045364FD8
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhBFDHQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhBFDB4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:01:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1DD264FB4;
        Fri,  5 Feb 2021 22:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612563298;
        bh=LWkBMCob2VYYjnKbdxTFQhr4NbqlL/4Yl9rYDciEJYI=;
        h=Date:From:To:Subject:From;
        b=sGdwA8jrqokhTmkVw/LLxqkbqZDmFm53ulmywNkNMWBM/Gu9NdQs7nFhiwBjGRw+D
         br1mYYwsMnvRcKs/wp6T6DdFk8h3bbVfzhhLHsr7Oi2hArmaof0pdnM6lG4ngK0S+j
         WO5XimSI+n8xCfHOSMtIXiA614u6INtqPzwchbkY=
Date:   Fri, 05 Feb 2021 14:14:57 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chrisw@sous-sol.org,
        ian.pratt@xensource.com, linmiaohe@huawei.com, mingo@elte.hu,
        mm-commits@vger.kernel.org
Subject:  +
 mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch added to -mm tree
Message-ID: <20210205221457.-xfPuKwFN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix potential pte_unmap_unlock pte error
has been added to the -mm tree.  Its filename is
     mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch

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
Subject: mm/memory.c: fix potential pte_unmap_unlock pte error

If all pte entry is none in 'non-create' case, we would break the loop with
pte unchanged.  Then the wrong pte - 1 would be passed to pte_unmap_unlock.
This is a theoretical issue which may not be a real bug. So it's not worth
cc stable.

Link: https://lkml.kernel.org/r/20210205081925.59809-1-linmiaohe@huawei.com
Fixes: aee16b3cee27 ("Add apply_to_page_range() which applies a function to a pte range")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Pratt <ian.pratt@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memoryc-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/memory.c
@@ -2382,18 +2382,18 @@ static int apply_to_pte_range(struct mm_
 				     pte_fn_t fn, void *data, bool create,
 				     pgtbl_mod_mask *mask)
 {
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	int err = 0;
 	spinlock_t *ptl;
 
 	if (create) {
-		pte = (mm == &init_mm) ?
+		mapped_pte = pte = (mm == &init_mm) ?
 			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -ENOMEM;
 	} else {
-		pte = (mm == &init_mm) ?
+		mapped_pte = pte = (mm == &init_mm) ?
 			pte_offset_kernel(pmd, addr) :
 			pte_offset_map_lock(mm, pmd, addr, &ptl);
 	}
@@ -2416,7 +2416,7 @@ static int apply_to_pte_range(struct mm_
 	arch_leave_lazy_mmu_mode();
 
 	if (mm != &init_mm)
-		pte_unmap_unlock(pte-1, ptl);
+		pte_unmap_unlock(mapped_pte, ptl);
 	return err;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-hugetlb-fix-some-comment-typos.patch
mm-remove-unused-return-value-of-set_huge_zero_page.patch
hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
hugetlbfs-fix-some-comment-typos.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

