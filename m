Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BD9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376621AbiEMC6i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376635AbiEMC6h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E846CA8D
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1A0862188
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291C0C34116;
        Fri, 13 May 2022 02:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410715;
        bh=CQxUAkTQfZAchor7htZ33iBH09GNUoYJ19s61nfB4Qk=;
        h=Date:To:From:Subject:From;
        b=duMmQ+VG4y0E6fqLEGUGa5ptsQIQVrreZvAZf1pEr+KwiXH9NJUB6RVyEVFSimblM
         BBAd0VXM18TgXHVl+9QjpltEaA+CjZem3LH6tiw3OqbXwATMSYYktgfWPyCr0x//TB
         Yk1VIZraLxRjbR94j/7/59bCAjpzYX+6XZHY2Yas=
Date:   Thu, 12 May 2022 19:58:34 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, iamjoonsoo.kim@lge.com, hch@lst.de,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-use-helper-folio_is_file_lru-fix.patch removed from -mm tree
Message-Id: <20220513025835.291C0C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: use helper folio_is_file_lru()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-helper-folio_is_file_lru-fix.patch

This patch was dropped because it was folded into mm-vmscan-use-helper-folio_is_file_lru.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: use helper folio_is_file_lru()

Use helper folio_is_file_lru() to check whether folio is file lru.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220428105802.21389-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-helper-folio_is_file_lru-fix
+++ a/mm/vmscan.c
@@ -1414,7 +1414,7 @@ static enum page_references folio_check_
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if ((vm_flags & VM_EXEC) && !folio_test_swapbacked(folio))
+		if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
 			return PAGEREF_ACTIVATE;
 
 		return PAGEREF_KEEP;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
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

