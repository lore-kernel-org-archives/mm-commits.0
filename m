Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F564C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbiDXUGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiDXUGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E891EAD0
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 428D061314
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F18C385AB;
        Sun, 24 Apr 2022 20:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650830594;
        bh=9Op8Yuq82mSl/Fe/dwyf32pynWmLY/x/fpcRGVXk1r0=;
        h=Date:To:From:Subject:From;
        b=cLuJS649tsXeIzByWIN9yMWSgyzfiD3CLnselLH5j38minkA2zGiXfC+t8BN8Qefl
         LIsGL0CLf+tOizTYZs9Tqqf/afGwKoJHi3MDz6q6UKi3/ooLfOjJ7qgVZ/lk+cC3nb
         R6ccjunquRGkYigJfRtB3JZ6mbaAq/BMtbzzAftk=
Date:   Sun, 24 Apr 2022 13:03:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, sfr@canb.auug.org.au, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, minchan@kernel.org,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch added to -mm tree
Message-Id: <20220424200314.87F18C385AB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: unuse_pte can map random data if swap read fails
has been added to the -mm tree.  Its filename is
     mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: unuse_pte can map random data if swap read fails

There is a bug in unuse_pte(): when swap page happens to be unreadable,
page filled with random data is mapped into user address space.  In case
of error, a special swap entry indicating swap read fails is set to the
page table.  So the swapcache page can be freed and the user won't end up
with a permanently mounted swap because a sector is bad.  And if the page
is accessed later, the user process will be killed so that corrupted data
is never consumed.  On the other hand, if the page is never accessed, the
user won't even notice it.

Link: https://lkml.kernel.org/r/20220424091105.48374-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1488,7 +1488,8 @@ again:
 			/* Only drop the uffd-wp marker if explicitly requested */
 			if (!zap_drop_file_uffd_wp(details))
 				continue;
-		} else if (is_hwpoison_entry(entry)) {
+		} else if (is_hwpoison_entry(entry) ||
+			   is_swapin_error_entry(entry)) {
 			if (!should_zap_cows(details))
 				continue;
 		} else {
@@ -3728,6 +3729,8 @@ vm_fault_t do_swap_page(struct vm_fault
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
@@ -1797,6 +1797,17 @@ static int unuse_pte(struct vm_area_stru
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

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
mm-vmscan-fix-comment-for-current_may_throttle.patch
mm-vmscan-fix-comment-for-isolate_lru_pages.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
mm-compaction-use-helper-isolation_suitable.patch
drivers-base-nodec-fix-compaction-sysfs-file-leak.patch
mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch
mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch
mm-compaction-remove-unneeded-pfn-update.patch
mm-compaction-remove-unneeded-assignment-to-isolate_start_pfn.patch
mm-compaction-clean-up-comment-for-sched-contention.patch
mm-compaction-clean-up-comment-about-suitable-migration-target-recheck.patch
mm-compaction-use-compact_cluster_max-in-compactionc.patch
mm-compaction-use-helper-compound_nr-in-isolate_migratepages_block.patch
mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch
mm-compaction-avoid-possible-null-pointer-dereference-in-kcompactd_cpu_online.patch
mm-compaction-make-compaction_zonelist_suitable-return-false-when-compact_success.patch
mm-compaction-simplify-the-code-in-__compact_finished.patch
mm-compaction-make-sure-highest-is-above-the-min_pfn.patch
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

