Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A04ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiILAjQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILAjP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:39:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB25A275DC
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EB3EB80B06
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EBCC433D7;
        Mon, 12 Sep 2022 00:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943150;
        bh=g30XRPF6RZAERBnMLq31eTEMbz+sKC2O3JSg3aujt0c=;
        h=Date:To:From:Subject:From;
        b=AEwZt6phZf+x49gi9s34HGtc4LkkInPjpGqE0emX1OBff07s9pql7vVzoVMdMUrOy
         2TQEp+kgvJ5fj3TiVWSUEpli2DGsJvLq0tKvS1BWnEoLhyo7m4sagpy6bqILQ5xjqM
         Pzm4FcgnMYqNvA/tKrYM/iJOVqrc7YpHO82UiaGo=
Date:   Sun, 11 Sep 2022 17:39:10 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch removed from -mm tree
Message-Id: <20220912003910.C6EBCC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2.patch

This patch was dropped because it was folded into mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2
Date: Tue, 23 Aug 2022 11:02:06 +0800

remove err == -EEXIST check and retry logic

Link: https://lkml.kernel.org/r/20220823030209.57434-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-call-to-restore_reserve_on_error-v2
+++ a/mm/hugetlb.c
@@ -5563,7 +5563,6 @@ static vm_fault_t hugetlb_no_page(struct
 	if (idx >= size)
 		goto out;
 
-retry:
 	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
@@ -5603,10 +5602,15 @@ retry:
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = huge_add_to_page_cache(page, mapping, idx);
 			if (err) {
+				/*
+				 * err can't be -EEXIST which implies someone
+				 * else consumed the reservation since hugetlb
+				 * fault mutex is held when add a hugetlb page
+				 * to the page cache. So it's safe to call
+				 * restore_reserve_on_error() here.
+				 */
 				restore_reserve_on_error(h, vma, haddr, page);
 				put_page(page);
-				if (err == -EEXIST)
-					goto retry;
 				goto out;
 			}
 			new_pagecache_page = true;
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

