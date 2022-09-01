Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75512ECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiIATKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiIATKr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:10:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64455F9BF
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79225B82901
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158EAC433D6;
        Thu,  1 Sep 2022 19:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059443;
        bh=CfF/Nvxr1f3vbxkXb+7s+FR7alHFqhKeA0U1RkdyvOY=;
        h=Date:To:From:Subject:From;
        b=VG+Gu6imSj5BN8+QnM24ee0x2lbjjO0t3I6Eu4d2+SVwtHrY0WlaOYiVM7EHWIwb7
         sfKWdZ/T2oRJ3M3y0aXi1Iqu0ULSwW/4ckekMEFboFaGouyr+ozMfpQeUXULPfhizZ
         icy5RkGu+vs+BUd/6XPdaQ0szD5tVfM/bD5QNzMo=
Date:   Thu, 01 Sep 2022 12:10:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-use-list_head-to-define-a-list-head.patch added to mm-unstable branch
Message-Id: <20220901191043.158EAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: use LIST_HEAD() to define a list head
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-use-list_head-to-define-a-list-head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-use-list_head-to-define-a-list-head.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: use LIST_HEAD() to define a list head
Date: Thu, 1 Sep 2022 20:00:23 +0800

Use LIST_HEAD() directly to define a list head to simplify the code.
No functional change intended.

Link: https://lkml.kernel.org/r/20220901120030.63318-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-list_head-to-define-a-list-head
+++ a/mm/hugetlb.c
@@ -459,14 +459,12 @@ static int allocate_file_region_entries(
 					int regions_needed)
 	__must_hold(&resv->lock)
 {
-	struct list_head allocated_regions;
+	LIST_HEAD(allocated_regions);
 	int to_allocate = 0, i = 0;
 	struct file_region *trg = NULL, *rg = NULL;
 
 	VM_BUG_ON(regions_needed < 0);
 
-	INIT_LIST_HEAD(&allocated_regions);
-
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
 	 * the number of in progress add operations plus regions_needed.
@@ -2352,7 +2350,7 @@ struct page *alloc_huge_page_vma(struct
 static int gather_surplus_pages(struct hstate *h, long delta)
 	__must_hold(&hugetlb_lock)
 {
-	struct list_head surplus_list;
+	LIST_HEAD(surplus_list);
 	struct page *page, *tmp;
 	int ret;
 	long i;
@@ -2367,7 +2365,6 @@ static int gather_surplus_pages(struct h
 	}
 
 	allocated = 0;
-	INIT_LIST_HEAD(&surplus_list);
 
 	ret = -ENOMEM;
 retry:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
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

