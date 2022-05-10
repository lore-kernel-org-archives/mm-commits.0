Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52849C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiEJEPz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbiEJEPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591E941FA1
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5560B81AF8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864ABC385C2;
        Tue, 10 May 2022 04:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155869;
        bh=4zlB0D9odQUemS7v1PcbeTGshzMJtiBqTKyFZ9YmDOA=;
        h=Date:To:From:Subject:From;
        b=VCjI1P930LC1d2+wXRyh3pD5vhC13oM44FhT/708+oyBNgSwFxsGR2r+mF91Qlo2I
         gJHPnF4Ck3x+J45wSEpea1xafo85CnUqQTKHHoOFmvAxmXykDN47PQuIdEhSVcgOrf
         nNDl8/4orRfDbAlcUXa50plRX5GCWaPYKuT3ag48=
Date:   Mon, 09 May 2022 21:11:08 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-comment-for-current_may_throttle.patch removed from -mm tree
Message-Id: <20220510041109.864ABC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: fix comment for current_may_throttle
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-comment-for-current_may_throttle.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: fix comment for current_may_throttle

Since commit 6d6435811c19 ("remove bdi_congested() and wb_congested() and
related functions"), there is no congested backing device check anymore. 
Correct the comment accordingly.

[akpm@linux-foundation.org: tweak grammar]
Link: https://lkml.kernel.org/r/20220414120202.30082-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comment-for-current_may_throttle
+++ a/mm/vmscan.c
@@ -2297,10 +2297,9 @@ static unsigned int move_pages_to_lru(st
 }
 
 /*
- * If a kernel thread (such as nfsd for loop-back mounts) services
- * a backing device by writing to the page cache it sets PF_LOCAL_THROTTLE.
- * In that case we should only throttle if the backing device it is
- * writing to is congested.  In other cases it is safe to throttle.
+ * If a kernel thread (such as nfsd for loop-back mounts) services a backing
+ * device by writing to the page cache it sets PF_LOCAL_THROTTLE. In this case
+ * we should not throttle.  Otherwise it is safe to do so.
  */
 static int current_may_throttle(void)
 {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-migration-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
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

