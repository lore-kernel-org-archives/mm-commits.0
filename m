Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051D0ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiILAmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiILAmK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:42:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8143027B3E
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:42:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FA2AB80BFF
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D672CC433C1;
        Mon, 12 Sep 2022 00:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943326;
        bh=Fb0LUl6Vl1Kmz1UvHWLYbCTg0x/EQYhmhYm2Gst88KU=;
        h=Date:To:From:Subject:From;
        b=VK+Ooqq6cIzYuSyQgBcKfL9qq0WV1N6swKYHING2QtUY2qBp21Ku4SZM0DJZCR+Wy
         Sd21XRB/ScertdR9s1RRk4ejGXRIo7tT3EIPkKvf9Ab+ger9wYsQou2ijfECThvTXB
         Zr17yB3kMPsYQcMvpIfhFe8MjvogWmrPbzDLmUtI=
Date:   Sun, 11 Sep 2022 17:42:06 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hwpoison-kill-procs-if-unmap-fails-v2.patch removed from -mm tree
Message-Id: <20220912004206.D672CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwpoison-kill-procs-if-unmap-fails-v2
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-kill-procs-if-unmap-fails-v2.patch

This patch was dropped because it was folded into mm-hwpoison-kill-procs-if-unmap-fails.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm-hwpoison-kill-procs-if-unmap-fails-v2
Date: Tue, 23 Aug 2022 11:23:45 +0800

If try_to_unmap() fails, the hwpoisoned page still resides in the address
space of some processes. We should kill these processes or the hwpoisoned
page might be consumed later. collect_procs() is always called to collect
relevant processes now so they can be killed later if unmap fails.

Link: https://lkml.kernel.org/r/20220823032346.4260-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-kill-procs-if-unmap-fails-v2
+++ a/mm/memory-failure.c
@@ -1450,9 +1450,6 @@ static bool hwpoison_user_mappings(struc
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
 	 * because ttu takes the rmap data structures down.
-	 *
-	 * Error handling: We ignore errors here because
-	 * there's nothing that can be done.
 	 */
 	collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
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

