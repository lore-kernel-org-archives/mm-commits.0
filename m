Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26468ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiILAov (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiILAon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7509C6403
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDCED61155
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45303C433D6;
        Mon, 12 Sep 2022 00:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943478;
        bh=I0Xw2DrdkTeqiPG40obNeBzDe/7eBrudNUcn58eX+lk=;
        h=Date:To:From:Subject:From;
        b=qqLipTMKbfRYUhz1+4UFjNxC9VDcFX9D/EYvM3dp+MZgxOzzU5Ehwqxv9bD7OscSa
         nsL+jRMkfXuXxcYskhS//aiiCw3YUPA97ioga0b31K8+0hGhxHrUQeUpaCWG9Yv3s/
         C1wprq1AB25qMbCtniUSzA5p+B9LdOUHwwXe/sxQ=
Date:   Sun, 11 Sep 2022 17:44:37 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages-fix.patch removed from -mm tree
Message-Id: <20220912004438.45303C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages-fix.patch

This patch was dropped because it was folded into mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages-fix
Date: Mon, 5 Sep 2022 14:53:41 +0800

fixes per Naoya Horiguchi

Link: https://lkml.kernel.org/r/1f7ee86e-7d28-0d8c-e0de-b7a5a94519e8@huawei.com
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages-fix
+++ a/mm/memory-failure.c
@@ -2404,24 +2404,26 @@ EXPORT_SYMBOL(unpoison_memory);
 static bool isolate_page(struct page *page, struct list_head *pagelist)
 {
 	bool isolated = false;
-	bool lru = !__PageMovable(page);
 
 	if (PageHuge(page)) {
 		isolated = !isolate_hugetlb(page, pagelist);
 	} else {
+		bool lru = !__PageMovable(page);
+
 		if (lru)
 			isolated = !isolate_lru_page(page);
 		else
-			isolated = !isolate_movable_page(page, ISOLATE_UNEVICTABLE);
+			isolated = !isolate_movable_page(page,
+							 ISOLATE_UNEVICTABLE);
 
-		if (isolated)
+		if (isolated) {
 			list_add(&page->lru, pagelist);
+			if (lru)
+				inc_node_page_state(page, NR_ISOLATED_ANON +
+						    page_is_file_lru(page));
+		}
 	}
 
-	if (isolated && lru)
-		inc_node_page_state(page, NR_ISOLATED_ANON +
-				    page_is_file_lru(page));
-
 	/*
 	 * If we succeed to isolate the page, we grabbed another refcount on
 	 * the page, so we can safely drop the one we got from get_any_pages().
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
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch
mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
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

