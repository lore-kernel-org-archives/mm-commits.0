Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70449C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiEJEVv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiEJEUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF952B0328
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0830C61766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DDCC385C5;
        Tue, 10 May 2022 04:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156122;
        bh=oyMlPGzssMIWh6+FwRCBS60BbbShr7ZdIa826rU+qb4=;
        h=Date:To:From:Subject:From;
        b=nMU9EMJsGnbFpR0sWjqqgKhfG25cQCt9QJluXrEPMZ12bzk42kFo6plnmXIjn+3OD
         0mp8eYOtNSmQHhi6A9pnO2CcUkRWbICHzX+Mle/IAN3p50yXVGOoWQsC2f4MUOUfW1
         H/+sSUcHQ1O1p7CsXjSO5MJOPBk9JV/g393fpTHk=
Date:   Mon, 09 May 2022 21:15:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, sfr@canb.auug.org.au, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, minchan@kernel.org,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch removed from -mm tree
Message-Id: <20220510041522.62DDCC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: free hwpoison and swapin error entry in madvise_free_pte_range
has been removed from the -mm tree.  Its filename was
     mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: free hwpoison and swapin error entry in madvise_free_pte_range

Once the MADV_FREE operation has succeeded, callers can expect they might
get zero-fill pages if accessing the memory again.  Therefore it should be
safe to delete the hwpoison entry and swapin error entry.  There is no
reason to kill the process if it has called MADV_FREE on the range.

Link: https://lkml.kernel.org/r/20220424091105.48374-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range
+++ a/mm/madvise.c
@@ -624,11 +624,14 @@ static int madvise_free_pte_range(pmd_t
 			swp_entry_t entry;
 
 			entry = pte_to_swp_entry(ptent);
-			if (non_swap_entry(entry))
-				continue;
-			nr_swap--;
-			free_swap_and_cache(entry);
-			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			if (!non_swap_entry(entry)) {
+				nr_swap--;
+				free_swap_and_cache(entry);
+				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			} else if (is_hwpoison_entry(entry) ||
+				   is_swapin_error_entry(entry)) {
+				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			}
 			continue;
 		}
 
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

