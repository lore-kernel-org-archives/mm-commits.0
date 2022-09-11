Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C61C6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiIKX0I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIKX0H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:26:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C652B2559C
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80235B80B22
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2394BC433B5;
        Sun, 11 Sep 2022 23:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938764;
        bh=2kMpd/Ry5g+84rcQeSdvNE8eGkBgyNpY4HCrIZi3VLY=;
        h=Date:To:From:Subject:From;
        b=e8JwUcGbnTlxvdgg2vYl+vUn+FJc8Br4I74AUyiiJCPRdDqff/RF+wBwfVg8d23G8
         R6K1+gaA9gB28+g6sERV37zeYdzKpZxoN75Ok61PT2Z7AjUMdO3M+s67R/eURXv+Ds
         YGMndgkq8i2I+6iGOLpn0+XkqPJxdJqW18wwgllE=
Date:   Sun, 11 Sep 2022 16:26:03 -0700
To:     mm-commits@vger.kernel.org, joao.m.martins@oracle.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch removed from -mm tree
Message-Id: <20220911232604.2394BC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: minor clean up for memmap_init_compound()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: minor clean up for memmap_init_compound()
Date: Sat, 11 Jun 2022 10:13:52 +0800

Since commit 5232c63f46fd ("mm: Make compound_pincount always available"),
compound_pincount_ptr is stored at first tail page now.  So we should call
prep_compound_head() after the first tail page is initialized to take
advantage of the likelihood of that tail struct page being cached given
that we will read them right after in prep_compound_head().

Link: https://lkml.kernel.org/r/20220611021352.13529-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-minor-clean-up-for-memmap_init_compound
+++ a/mm/page_alloc.c
@@ -6811,13 +6811,18 @@ static void __ref memmap_init_compound(s
 		set_page_count(page, 0);
 
 		/*
-		 * The first tail page stores compound_mapcount_ptr() and
-		 * compound_order() and the second tail page stores
-		 * compound_pincount_ptr(). Call prep_compound_head() after
-		 * the first and second tail pages have been initialized to
-		 * not have the data overwritten.
+		 * The first tail page stores compound_mapcount_ptr(),
+		 * compound_order() and compound_pincount_ptr(). Call
+		 * prep_compound_head() after the first tail page have
+		 * been initialized to not have the data overwritten.
+		 *
+		 * Note the idea to make this right after we initialize
+		 * the offending tail pages is trying to take advantage
+		 * of the likelihood of those tail struct pages being
+		 * cached given that we will read them right after in
+		 * prep_compound_head().
 		 */
-		if (pfn == head_pfn + 2)
+		if (unlikely(pfn == head_pfn + 1))
 			prep_compound_head(head, order);
 	}
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-kill-procs-if-unmap-fails-v2.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch
mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages-fix.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
hugetlb-make-hugetlb_cma_check-static.patch
hugetlb-use-helper-macro-sz_1k.patch
hugetlb-use-list_head-to-define-a-list-head.patch
hugetlb-use-sizeof-to-get-the-array-size.patch
hugetlb-use-helper-huge_ptepmd_lock.patch
hugetlb-pass-null-to-kobj_to_hstate-if-nid-is-unused.patch
hugetlb-kill-hugetlbfs_pagecache_page.patch
hugetlb-add-comment-for-subtle-sethpagevmemmapoptimized.patch
hugetlb-remove-meaningless-bug_onhuge_pte_none.patch
hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch
writeback-remove-unused-macro-dirty_full_scope.patch

