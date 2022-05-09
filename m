Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB1FC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 21:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiEIVVX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiEIVVP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 17:21:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA42F20CD98
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 14:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EB1616FE
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA27C385BA;
        Mon,  9 May 2022 21:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652131039;
        bh=9NJEiIp6a5ckCouzE1Eoaf63MtQHdFDBjGeSxSZqW40=;
        h=Date:To:From:Subject:From;
        b=JJlQDypL36JPP/9knpAoo+hSVer4QJSsH+b4YhpuzriR8swxUNzcmXs+9IW7l9Yq1
         914POEjPAaoh2LAzi9ZCvp1P04NkCyU3zFKqvRgn8TLoX7u9xtvjR9VH8V3v+tAy7V
         njR1G0ekb6z8i7wyQDMvyQcQfPj4FkgsqG+RHntQ=
Date:   Mon, 09 May 2022 14:17:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        naoya.horiguchi@nec.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch added to mm-unstable branch
Message-Id: <20220509211719.BEA27C385BA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: make page_swapcount and __lru_add_drain_all
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch

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
Subject: mm/swap: make page_swapcount and __lru_add_drain_all

Make page_swapcount and __lru_add_drain_all static.  They are only used
within the file now.

Link: https://lkml.kernel.org/r/20220509131416.17553-9-linmiaohe@huawei.com
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

 include/linux/swap.h |    7 -------
 mm/swap.c            |    2 +-
 mm/swapfile.c        |    2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~mm-swap-make-page_swapcount-and-__lru_add_drain_all
+++ a/include/linux/swap.h
@@ -490,7 +490,6 @@ int swap_type_of(dev_t device, sector_t
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
-extern int page_swapcount(struct page *);
 extern int __swap_count(swp_entry_t entry);
 extern int __swp_swapcount(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
@@ -562,12 +561,6 @@ static inline void put_swap_page(struct
 {
 }
 
-
-static inline int page_swapcount(struct page *page)
-{
-	return 0;
-}
-
 static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
--- a/mm/swap.c~mm-swap-make-page_swapcount-and-__lru_add_drain_all
+++ a/mm/swap.c
@@ -748,7 +748,7 @@ static void lru_add_drain_per_cpu(struct
  * Calling this function with cpu hotplug locks held can actually lead
  * to obscure indirect dependencies via WQ context.
  */
-inline void __lru_add_drain_all(bool force_all_cpus)
+static inline void __lru_add_drain_all(bool force_all_cpus)
 {
 	/*
 	 * lru_drain_gen - Global pages generation number
--- a/mm/swapfile.c~mm-swap-make-page_swapcount-and-__lru_add_drain_all
+++ a/mm/swapfile.c
@@ -1429,7 +1429,7 @@ void swapcache_free_entries(swp_entry_t
  * This does not give an exact answer when swap count is continued,
  * but does include the high COUNT_CONTINUED flag to allow for that.
  */
-int page_swapcount(struct page *page)
+static int page_swapcount(struct page *page)
 {
 	int count = 0;
 	struct swap_info_struct *p;
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

