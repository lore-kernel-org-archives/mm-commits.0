Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EF2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383765AbiEMTWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383716AbiEMTWN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5581393E3
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 695E8B83132
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F1DC34100;
        Fri, 13 May 2022 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469693;
        bh=fHFL748elqdZvmHSXw1sg3UqHrazHEJCOnHaffP9bcA=;
        h=Date:To:From:Subject:From;
        b=Gp2ayTkeVCkWUIq5h6tTwukvTAuVJXeCOaVlX/7bp0SsIV/NuQdxh2qFZU74yI+x3
         7CHghRP8QCVf4M7Ec3RcEUXn0SAGbld28E1CEo+ff2sAZ+qEcLR50mOUr+qENrqIHw
         6JP2Y09zX82JKoV6K9GombYVjVeSiU8ZKqisQZvs=
Date:   Fri, 13 May 2022 12:21:32 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, iamjoonsoo.kim@lge.com, hch@lst.de,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch removed from -mm tree
Message-Id: <20220513192133.19F1DC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: add a comment about MADV_FREE pages check in folio_check_dirty_writeback
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: add a comment about MADV_FREE pages check in folio_check_dirty_writeback

Patch series "A few cleanup and fixup patches for vmscan

This series contains a few patches to remove obsolete comment, introduce
helper to remove duplicated code and so no.  Also we take all base pages
of THP into account in rare race condition.  More details can be found in
the respective changelogs.


This patch (of 6):

The MADV_FREE pages check in folio_check_dirty_writeback is a bit hard to
follow.  Add a comment to make the code clear.

Link: https://lkml.kernel.org/r/20220425111232.23182-2-linmiaohe@huawei.com
Suggested-by: Huang, Ying <ying.huang@intel.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback
+++ a/mm/vmscan.c
@@ -1435,7 +1435,10 @@ static void folio_check_dirty_writeback(
 
 	/*
 	 * Anonymous pages are not handled by flushers and must be written
-	 * from reclaim context. Do not stall reclaim based on them
+	 * from reclaim context. Do not stall reclaim based on them.
+	 * MADV_FREE anonymous pages are put into inactive file list too.
+	 * They could be mistakenly treated as file lru. So further anon
+	 * test is needed.
 	 */
 	if (!folio_is_file_lru(folio) ||
 	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
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

