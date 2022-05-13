Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A11C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379628AbiEMTWX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383765AbiEMTVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0067538782
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90DB26225B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B01C34100;
        Fri, 13 May 2022 19:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469689;
        bh=N2xr+0NmGL9UO5c5mXoyUhemwohfkIRibOw87O0D/PM=;
        h=Date:To:From:Subject:From;
        b=G2zKdEhMxHRkt7Oh2eiDTr1/AhXwJsVsP4bFCg5SLqenraFsj+sm3b2l2vd/O0wkV
         m71QqM6twKFF6Os8jj6eIl1M2HhCSK8pumNCEDNakfvTLFRRasmd5iNH+8QGfFoeDb
         aoyl162zwPjNpRa5r5pcPTkV0PQHVzag5zTXMzwM=
Date:   Fri, 13 May 2022 12:21:28 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        hch@infradead.org, hannes@cmpxchg.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch removed from -mm tree
Message-Id: <20220513192128.E2B01C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: take min_slab_pages into account when try to call shrink_node
has been removed from the -mm tree.  Its filename was
     mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: take min_slab_pages into account when try to call shrink_node

Since commit 6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from
shrink_zone()"), slab reclaim and lru page reclaim are done together in
the shrink_node.  So we should take min_slab_pages into account when try
to call shrink_node.

Link: https://lkml.kernel.org/r/20220425112118.20924-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node
+++ a/mm/vmscan.c
@@ -4713,7 +4713,8 @@ static int __node_reclaim(struct pglist_
 	noreclaim_flag = memalloc_noreclaim_save();
 	set_task_reclaim_state(p, &sc.reclaim_state);
 
-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages) {
+	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
+	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
 		/*
 		 * Free memory by calling shrink node with increasing
 		 * priorities until we have enough memory freed.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch
mm-swap-use-helper-macro-__attr_rw.patch
mm-swap-fold-__swap_info_get-into-its-sole-caller.patch
mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch
mm-swap-print-bad-swap-offset-entry-in-get_swap_device.patch
mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch
mm-swap-remove-unneeded-p-=-null-check-in-__swap_duplicate.patch
mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch
mm-swap-add-helper-swap_offset_available.patch
mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch
mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch
mm-swap-fix-the-comment-of-get_kernel_pages.patch
mm-swap-fix-comment-about-swap-extent.patch

