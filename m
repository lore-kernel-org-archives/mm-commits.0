Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34420C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbiESRK2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241492AbiESRKZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B809CF61
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38102B82773
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A96C385AA;
        Thu, 19 May 2022 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652980222;
        bh=2XhBPU9ntseXu7UgTkyuzbfCCGyXeZl46zgEdLOFqCA=;
        h=Date:To:From:Subject:From;
        b=RqN+OryNFTGx3DtjN5Pqpolm07oVjBoaLfMwKJqwwfFLgmmn9hV7Twtrd6SvUR2gI
         4/2G6sT24cKtdNSDsXK230L4B/nGb5CjxVErsAz2YmOZdU2O2Um0YuxgtlWFyoXZe/
         gN7VfXDMpOVe3FX4MLi+yywadFQvJ1MhJJYQH3ZM=
Date:   Thu, 19 May 2022 10:10:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch added to mm-unstable branch
Message-Id: <20220519171021.E5A96C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: fix lost swap bits in unuse_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

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
Subject: mm/swapfile: fix lost swap bits in unuse_pte()
Date: Thu, 19 May 2022 20:50:27 +0800

This is observed by code review only but not any real report.

When we turn off swapping we could have lost the bits stored in the swap
ptes.  The new rmap-exclusive bit is fine since that turned into a page
flag, but not for soft-dirty and uffd-wp.  Add them.

Link: https://lkml.kernel.org/r/20220519125030.21486-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-lost-swap-bits-in-unuse_pte
+++ a/mm/swapfile.c
@@ -1774,7 +1774,7 @@ static int unuse_pte(struct vm_area_stru
 {
 	struct page *swapcache;
 	spinlock_t *ptl;
-	pte_t *pte;
+	pte_t *pte, new_pte;
 	int ret = 1;
 
 	swapcache = page;
@@ -1823,8 +1823,12 @@ static int unuse_pte(struct vm_area_stru
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

