Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE7AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbiESRKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242417AbiESRKb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:10:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F5F9CF4B
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50EB3B82772
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BD8C385AA;
        Thu, 19 May 2022 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652980228;
        bh=n7da6aLULy/lEKe59XdYmcm0pS5zHmAnvGulLEwPDvk=;
        h=Date:To:From:Subject:From;
        b=dhZOrvF+2SvF8NFnB+KCM4/zmjQlGRgoESN0wBfEeZjEUvdy6J2qbASjkNFlHii+f
         pE4FmNX+2dnndAXzDJ6rHuFSgOm8LklbWNOEaFFxQLlyqtYg7IWbzcbYnYqsb89UfM
         pNa6x1Kw3OwOHPoZjoL53PuX4lGswhVppe0TUNeQ=
Date:   Thu, 19 May 2022 10:10:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filter-out-swapin-error-entry-in-shmem-mapping.patch added to mm-unstable branch
Message-Id: <20220519171028.09BD8C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filter out swapin error entry in shmem mapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: filter out swapin error entry in shmem mapping
Date: Thu, 19 May 2022 20:50:30 +0800

There might be swapin error entries in shmem mapping.  Filter them out to
avoid "Bad swap file entry" complaint.

Link: https://lkml.kernel.org/r/20220519125030.21486-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c    |    5 ++++-
 mm/swap_state.c |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-filter-out-swapin-error-entry-in-shmem-mapping
+++ a/mm/madvise.c
@@ -248,10 +248,13 @@ static void force_shm_swapin_readahead(s
 
 		if (!xa_is_value(page))
 			continue;
+		swap = radix_to_swp_entry(page);
+		/* There might be swapin error entries in shmem mapping. */
+		if (non_swap_entry(swap))
+			continue;
 		xas_pause(&xas);
 		rcu_read_unlock();
 
-		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
 					     NULL, 0, false, &splug);
 		if (page)
--- a/mm/swap_state.c~mm-filter-out-swapin-error-entry-in-shmem-mapping
+++ a/mm/swap_state.c
@@ -410,6 +410,9 @@ struct page *find_get_incore_page(struct
 		return NULL;
 
 	swp = radix_to_swp_entry(page);
+	/* There might be swapin error entries in shmem mapping. */
+	if (non_swap_entry(swp))
+		return NULL;
 	/* Prevent swapoff from happening to us */
 	si = get_swap_device(swp);
 	if (!si)
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
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch
mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

