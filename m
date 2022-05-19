Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96132C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbiESRKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241492AbiESRK3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:10:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F789CF61
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48CBFB82770
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089C8C385AA;
        Thu, 19 May 2022 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652980226;
        bh=xJxd4JdBMDBi/7mDxslcpJSd83Wdc8XaBDS4a1kyO3Y=;
        h=Date:To:From:Subject:From;
        b=vzShDxZmdz2szjpaWcd7+zFKw1wBNnVA9XQCi/Khsn5sIdZIuQtQdkptlEk/HAiC0
         zHAJAwKfcGmglVApXna6qV6iAR0FuiKeeUeg30Q+XHm4TQfBxvDZfghR80U6xLS+bR
         Ct5oJZQG0Qo5EVppgZ5MlROGRHJlj+YGmHW4Ur2Q=
Date:   Thu, 19 May 2022 10:10:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch added to mm-unstable branch
Message-Id: <20220519171026.089C8C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: fix infinite loop when swap in shmem error at swapoff time
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch

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
Subject: mm/shmem: fix infinite loop when swap in shmem error at swapoff time
Date: Thu, 19 May 2022 20:50:29 +0800

When swap in shmem error at swapoff time, there would be a infinite loop
in the while loop in shmem_unuse_inode().  It's because swapin error is
deliberately ignored now and thus info->swapped will never reach 0.  So we
can't escape the loop in shmem_unuse().

In order to fix the issue, swapin_error entry is stored in the mapping
when swapin error occurs.  So the swapcache page can be freed and the user
won't end up with a permanently mounted swap because a sector is bad.  If
the page is accessed later, the user process will be killed so that
corrupted data is never consumed.  On the other hand, if the page is never
accessed, the user won't even notice it.

Link: https://lkml.kernel.org/r/20220519125030.21486-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/shmem.c~mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time
+++ a/mm/shmem.c
@@ -1175,6 +1175,10 @@ static int shmem_find_swap_entries(struc
 			continue;
 
 		entry = radix_to_swp_entry(folio);
+		/*
+		 * swapin error entries can be found in the mapping. But they're
+		 * deliberately ignored here as we've done everything we can do.
+		 */
 		if (swp_type(entry) != type)
 			continue;
 
@@ -1672,6 +1676,36 @@ static int shmem_replace_page(struct pag
 	return error;
 }
 
+static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
+					 struct folio *folio, swp_entry_t swap)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	swp_entry_t swapin_error;
+	void *old;
+
+	swapin_error = make_swapin_error_entry(&folio->page);
+	old = xa_cmpxchg_irq(&mapping->i_pages, index,
+			     swp_to_radix_entry(swap),
+			     swp_to_radix_entry(swapin_error), 0);
+	if (old != swp_to_radix_entry(swap))
+		return;
+
+	folio_wait_writeback(folio);
+	delete_from_swap_cache(&folio->page);
+	spin_lock_irq(&info->lock);
+	/*
+	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks won't
+	 * be 0 when inode is released and thus trigger WARN_ON(inode->i_blocks) in
+	 * shmem_evict_inode.
+	 */
+	info->alloced--;
+	info->swapped--;
+	shmem_recalc_inode(inode);
+	spin_unlock_irq(&info->lock);
+	swap_free(swap);
+}
+
 /*
  * Swap in the page pointed to by *pagep.
  * Caller has to make sure that *pagep contains a valid swapped page.
@@ -1695,6 +1729,9 @@ static int shmem_swapin_folio(struct ino
 	swap = radix_to_swp_entry(*foliop);
 	*foliop = NULL;
 
+	if (is_swapin_error_entry(swap))
+		return -EIO;
+
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
 	if (!page) {
@@ -1762,6 +1799,8 @@ static int shmem_swapin_folio(struct ino
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
 		error = -EEXIST;
+	if (error == -EIO)
+		shmem_set_folio_swapin_error(inode, index, folio, swap);
 unlock:
 	if (folio) {
 		folio_unlock(folio);
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

