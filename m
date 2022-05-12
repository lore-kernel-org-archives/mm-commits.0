Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507D3C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 20:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357941AbiELUSs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 16:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244169AbiELUSo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 16:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CE314A255
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 13:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 166F161E38
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 20:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADB5C385B8;
        Thu, 12 May 2022 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652386719;
        bh=pjaQv4Zg8fsfELe6oX2q1+qBKlGAWXyS1rlIbHEWY8o=;
        h=Date:To:From:Subject:From;
        b=Dm0HgVLXW9JUfLgU+sYUO12EQeWRFO1z/zoc8vQVP8BjjAIL4yHy3+IBbdjwfMkDQ
         amF44dxuWFkLS7abmqj/ZFTGH4Avk5CEOrLKSqQFBAUDS5+lR2n4X/n3SZUYxHUaCJ
         YDum09TnUEnebHghwJ0ZXtLmSf8HIoM8wFrCJ1Qk=
Date:   Thu, 12 May 2022 13:18:38 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch removed from -mm tree
Message-Id: <20220512201839.6ADB5C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: remove unneeded lock page and PageMovable check
has been removed from the -mm tree.  Its filename was
     mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: remove unneeded lock page and PageMovable check

When non-lru movable page was freed from under us, __ClearPageMovable must
have been done.  Even if it's not done, ClearPageIsolated here won't hurt
as page will be freed anyway.  So we can thus remove unneeded lock page
and PageMovable check here.

Link: https://lkml.kernel.org/r/20220425132723.34824-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-unneeded-lock-page-and-pagemovable-check
+++ a/mm/migrate.c
@@ -1093,12 +1093,8 @@ static int unmap_and_move(new_page_t get
 		/* page was freed from under us. So we are done. */
 		ClearPageActive(page);
 		ClearPageUnevictable(page);
-		if (unlikely(__PageMovable(page))) {
-			lock_page(page);
-			if (!PageMovable(page))
-				ClearPageIsolated(page);
-			unlock_page(page);
-		}
+		if (unlikely(__PageMovable(page)))
+			ClearPageIsolated(page);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch
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

