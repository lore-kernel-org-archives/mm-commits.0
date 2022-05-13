Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiEMCQF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376472AbiEMCPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:15:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA501AD85
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A7B3B82AF2
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDD9C34114;
        Fri, 13 May 2022 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652408148;
        bh=54xST5OSJiLVaj/kZ5KHBPiqn5DR9p0QE2525KH76Kk=;
        h=Date:To:From:Subject:From;
        b=SgXJtorQcSfeJVjttS0Pirj6Hsi+mJ75mvj8JSnmtNvKo7yf7IQ0c8mAKrI1W4dru
         hOGa19B0TFPTL3b+kccFWarTFY4ET8x6GmMO+iaa0oFFKX5qVsZFsn9eMIemsTmNiW
         ZZooevXOQtcYyNk10e16EA8SMzboFuyXZLKNmEmU=
Date:   Thu, 12 May 2022 19:15:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, sfr@canb.auug.org.au, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, minchan@kernel.org,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch removed from -mm tree
Message-Id: <20220513021547.ECDD9C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: fix lost swap bits in unuse_pte()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fix lost swap bits in unuse_pte()

This is observed by code review only but not any real report.

When we turn off swapping we could have lost the bits stored in the swap
ptes.  The new rmap-exclusive bit is fine since that turned into a page
flag, but not for soft-dirty and uffd-wp.  Add them.

Link: https://lkml.kernel.org/r/20220424091105.48374-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-lost-swap-bits-in-unuse_pte
+++ a/mm/swapfile.c
@@ -1783,7 +1783,7 @@ static int unuse_pte(struct vm_area_stru
 {
 	struct page *swapcache;
 	spinlock_t *ptl;
-	pte_t *pte;
+	pte_t *pte, new_pte;
 	int ret = 1;
 
 	swapcache = page;
@@ -1832,8 +1832,12 @@ static int unuse_pte(struct vm_area_stru
 		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
-	set_pte_at(vma->vm_mm, addr, pte,
-		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
+	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
+	if (pte_swp_soft_dirty(*pte))
+		new_pte = pte_mksoft_dirty(new_pte);
+	if (pte_swp_uffd_wp(*pte))
+		new_pte = pte_mkuffd_wp(new_pte);
+	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	swap_free(entry);
 out:
 	pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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

