Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5DEC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbiEJEPi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiEJEPM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CAD2A727
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26785B81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79A5C385C5;
        Tue, 10 May 2022 04:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155859;
        bh=liQqwDALlgHmPcNP06MSDG8hTMVVynSdkm0yo2TfnA8=;
        h=Date:To:From:Subject:From;
        b=bxrpditdt+tbu5aphueIp2vD9d1B6OnIW/zSr6r1qbazowtVzm87aEEYXOQpPbbUp
         1jc3DmLgWoa7TCyuCod2DwEDg+KSbTgsNvknG3p8k4d0QaL114qAkA+nG8TCBnV9zO
         3qXzRRioqgrEEYZD2JUiqVUVfDlXR32GgySxtFVc=
Date:   Mon, 09 May 2022 21:10:59 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        naoya.horiguchi@nec.com, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failurec-dissolve-truncated-hugetlb-page.patch removed from -mm tree
Message-Id: <20220510041059.D79A5C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: dissolve truncated hugetlb page
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-dissolve-truncated-hugetlb-page.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: dissolve truncated hugetlb page

If me_huge_page meets a truncated but not yet freed hugepage, it won't be
dissolved even if we hold the last refcnt. It's because the hugepage has
NULL page_mapping while it's not anonymous hugepage too. Thus we lose the
last chance to dissolve it into buddy to save healthy subpages. Remove
PageAnon check to handle these hugepages too.

Link: https://lkml.kernel.org/r/20220414114941.11223-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-dissolve-truncated-hugetlb-page
+++ a/mm/memory-failure.c
@@ -1040,12 +1040,11 @@ static int me_huge_page(struct page_stat
 		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
-		 * migration entry prevents later access on error anonymous
-		 * hugepage, so we can free and dissolve it into buddy to
-		 * save healthy subpages.
+		 * migration entry prevents later access on error hugepage,
+		 * so we can free and dissolve it into buddy to save healthy
+		 * subpages.
 		 */
-		if (PageAnon(hpage))
-			put_page(hpage);
+		put_page(hpage);
 		if (__page_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
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

