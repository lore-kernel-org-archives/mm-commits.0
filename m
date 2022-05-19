Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6826FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiESRKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242403AbiESRKX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2389F9CF45
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7319FB82770
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE2EC385AA;
        Thu, 19 May 2022 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652980219;
        bh=dy8LQpuip3mSXe9GkloQ7F90HFFBnhLso19cyZLq+ew=;
        h=Date:To:From:Subject:From;
        b=CRPyzZmq9yiLEOomfUuj/s3LoWeaJ3nNMyYDT+v0aQWEUcDnGueI9FnJbHKgjNu4q
         m5plutz0vf4rF3AH3M7pUI97SH77/NhYwiyIyrUzgTsSprzyZy2EqGk8V5+2nfHLwW
         iSc60Sw/5zZJaHvOykNl+0lmrEklGt9aigroJLXQ=
Date:   Thu, 19 May 2022 10:10:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch added to mm-unstable branch
Message-Id: <20220519171019.1DE2EC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: unuse_pte can map random data if swap read fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch

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
Subject: mm/swapfile: unuse_pte can map random data if swap read fails
Date: Thu, 19 May 2022 20:50:26 +0800

Patch series "A few fixup patches for mm", v4.

This series contains a few patches to avoid mapping random data if swap
read fails and fix lost swap bits in unuse_pte.  Also we free hwpoison and
swapin error entry in madvise_free_pte_range and so on.  More details can
be found in the respective changelogs.  


This patch (of 5):

There is a bug in unuse_pte(): when swap page happens to be unreadable,
page filled with random data is mapped into user address space.  In case
of error, a special swap entry indicating swap read fails is set to the
page table.  So the swapcache page can be freed and the user won't end up
with a permanently mounted swap because a sector is bad.  And if the page
is accessed later, the user process will be killed so that corrupted data
is never consumed.  On the other hand, if the page is never accessed, the
user won't even notice it.

Link: https://lkml.kernel.org/r/20220519125030.21486-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220519125030.21486-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h    |    7 ++++++-
 include/linux/swapops.h |   10 ++++++++++
 mm/memory.c             |    5 ++++-
 mm/swapfile.c           |   11 +++++++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails
+++ a/include/linux/swap.h
@@ -55,6 +55,10 @@ static inline int current_is_kswapd(void
  * actions on faults.
  */
 
+#define SWP_SWAPIN_ERROR_NUM 1
+#define SWP_SWAPIN_ERROR     (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
+			     SWP_MIGRATION_NUM + SWP_DEVICE_NUM + \
+			     SWP_PTE_MARKER_NUM)
 /*
  * PTE markers are used to persist information onto PTEs that are mapped with
  * file-backed memories.  As its name "PTE" hints, it should only be applied to
@@ -120,7 +124,8 @@ static inline int current_is_kswapd(void
 
 #define MAX_SWAPFILES \
 	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
-	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - SWP_PTE_MARKER_NUM)
+	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - \
+	SWP_PTE_MARKER_NUM - SWP_SWAPIN_ERROR_NUM)
 
 /*
  * Magic header for a swap area. The first part of the union is
--- a/include/linux/swapops.h~mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails
+++ a/include/linux/swapops.h
@@ -108,6 +108,16 @@ static inline void *swp_to_radix_entry(s
 	return xa_mk_value(entry.val);
 }
 
+static inline swp_entry_t make_swapin_error_entry(struct page *page)
+{
+	return swp_entry(SWP_SWAPIN_ERROR, page_to_pfn(page));
+}
+
+static inline int is_swapin_error_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_SWAPIN_ERROR;
+}
+
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
--- a/mm/memory.c~mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails
+++ a/mm/memory.c
@@ -1496,7 +1496,8 @@ again:
 			/* Only drop the uffd-wp marker if explicitly requested */
 			if (!zap_drop_file_uffd_wp(details))
 				continue;
-		} else if (is_hwpoison_entry(entry)) {
+		} else if (is_hwpoison_entry(entry) ||
+			   is_swapin_error_entry(entry)) {
 			if (!should_zap_cows(details))
 				continue;
 		} else {
@@ -3742,6 +3743,8 @@ vm_fault_t do_swap_page(struct vm_fault
 			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
+		} else if (is_swapin_error_entry(entry)) {
+			ret = VM_FAULT_SIGBUS;
 		} else if (is_pte_marker_entry(entry)) {
 			ret = handle_pte_marker(vmf);
 		} else {
--- a/mm/swapfile.c~mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails
+++ a/mm/swapfile.c
@@ -1788,6 +1788,17 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
+	if (unlikely(!PageUptodate(page))) {
+		pte_t pteval;
+
+		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
+		pteval = swp_entry_to_pte(make_swapin_error_entry(page));
+		set_pte_at(vma->vm_mm, addr, pte, pteval);
+		swap_free(entry);
+		ret = 0;
+		goto out;
+	}
+
 	/* See do_swap_page() */
 	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
 	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
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

