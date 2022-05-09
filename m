Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A01C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 21:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiEIVVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 17:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiEIVVV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 17:21:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E652120F9F7
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 14:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A277DB8197F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A389C385BB;
        Mon,  9 May 2022 21:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652131042;
        bh=dMAzBgLv6b/j4vkNTRA8L6tKb/uHAFE3uhkoA9AX+x0=;
        h=Date:To:From:Subject:From;
        b=rPi3E0uil9mGv6uipzp6udt1HBvZUdKNqR5y6DVYSp4oXxFHoqzK3DdPU8IruftAU
         4R3cgAOfrxBDc8f921GzX14di5/GrMkZJSVKyIxCkrpE1MyqHFOOf9jQTJMes23lqk
         YCbY/IrKFLsFa+TmrSN3eN0N2WazfZ0K8SNLKPsA=
Date:   Mon, 09 May 2022 14:17:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        naoya.horiguchi@nec.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch added to mm-unstable branch
Message-Id: <20220509211722.3A389C385BB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: avoid calling swp_swap_info when try to check SWP_STABLE_WRITES
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: mm/swap: avoid calling swp_swap_info when try to check SWP_STABLE_WRITES

Use flags of si directly to check SWP_STABLE_WRITES to avoid possible
READ_ONCE and thus save some cpu cycles.

Link: https://lkml.kernel.org/r/20220509131416.17553-10-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes
+++ a/mm/memory.c
@@ -3907,7 +3907,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			exclusive = true;
 		} else if (exclusive && PageWriteback(page) &&
-			  (swp_swap_info(entry)->flags & SWP_STABLE_WRITES)) {
+			  (si->flags & SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
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

