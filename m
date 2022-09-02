Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACDCECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiIBX3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiIBX2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:28:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F883B0B15
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F33FFB82E07
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B200BC433D7;
        Fri,  2 Sep 2022 23:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161277;
        bh=Y+dwxk4EmNo60tk3Y9SsnxfrilL58TF4qzSjzumbK84=;
        h=Date:To:From:Subject:From;
        b=I4CfHMEDnXB6cGLxPyB43wkhg86H6fkNfS0epLBEGVdpW8tHoNgC8syBUVGgnVsZY
         54iHp36iRz6JFKYndRl2U1J3gRN48e9Fnrmp4ERg06Y5IDSDuAugnWG0OecH4KLrBb
         kU75719Us9pEY5Ckj1haTp0EO5v6gjJyY+wEk3YQ=
Date:   Fri, 02 Sep 2022 16:27:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220902232757.B200BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge_memory: convert split_huge_page_to_list() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: huge_memory: convert split_huge_page_to_list() to use a folio
Date: Fri, 2 Sep 2022 20:46:48 +0100

Saves many calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-53-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   49 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~huge_memory-convert-split_huge_page_to_list-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -2622,27 +2622,26 @@ bool can_split_folio(struct folio *folio
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct folio *folio = page_folio(page);
-	struct page *head = &folio->page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(head);
-	XA_STATE(xas, &head->mapping->i_pages, head->index);
+	struct deferred_split *ds_queue = get_deferred_split_queue(&folio->page);
+	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
 
-	VM_BUG_ON_PAGE(!PageLocked(head), head);
-	VM_BUG_ON_PAGE(!PageCompound(head), head);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	is_hzp = is_huge_zero_page(head);
-	VM_WARN_ON_ONCE_PAGE(is_hzp, head);
+	is_hzp = is_huge_zero_page(&folio->page);
+	VM_WARN_ON_ONCE_FOLIO(is_hzp, folio);
 	if (is_hzp)
 		return -EBUSY;
 
-	if (PageWriteback(head))
+	if (folio_test_writeback(folio))
 		return -EBUSY;
 
-	if (PageAnon(head)) {
+	if (folio_test_anon(folio)) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
 		 * prevent the anon_vma disappearing so we first we take a
@@ -2651,7 +2650,7 @@ int split_huge_page_to_list(struct page
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = page_get_anon_vma(head);
+		anon_vma = page_get_anon_vma(&folio->page);
 		if (!anon_vma) {
 			ret = -EBUSY;
 			goto out;
@@ -2662,7 +2661,7 @@ int split_huge_page_to_list(struct page
 	} else {
 		gfp_t gfp;
 
-		mapping = head->mapping;
+		mapping = folio->mapping;
 
 		/* Truncated ? */
 		if (!mapping) {
@@ -2679,7 +2678,7 @@ int split_huge_page_to_list(struct page
 			goto out;
 		}
 
-		xas_split_alloc(&xas, head, compound_order(head), gfp);
+		xas_split_alloc(&xas, folio, folio_order(folio), gfp);
 		if (xas_error(&xas)) {
 			ret = xas_error(&xas);
 			goto out;
@@ -2693,7 +2692,7 @@ int split_huge_page_to_list(struct page
 		 * but on 32-bit, i_size_read() takes an irq-unsafe seqlock,
 		 * which cannot be nested inside the page tree lock. So note
 		 * end now: i_size itself may be changed at any moment, but
-		 * head page lock is good enough to serialize the trimming.
+		 * folio lock is good enough to serialize the trimming.
 		 */
 		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
 		if (shmem_mapping(mapping))
@@ -2709,38 +2708,38 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
-	unmap_page(head);
+	unmap_page(&folio->page);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
 	if (mapping) {
 		/*
-		 * Check if the head page is present in page cache.
-		 * We assume all tail are present too, if head is there.
+		 * Check if the folio is present in page cache.
+		 * We assume all tail are present too, if folio is there.
 		 */
 		xas_lock(&xas);
 		xas_reset(&xas);
-		if (xas_load(&xas) != head)
+		if (xas_load(&xas) != folio)
 			goto fail;
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	if (page_ref_freeze(head, 1 + extra_pins)) {
-		if (!list_empty(page_deferred_list(head))) {
+	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+		if (!list_empty(page_deferred_list(&folio->page))) {
 			ds_queue->split_queue_len--;
-			list_del(page_deferred_list(head));
+			list_del(page_deferred_list(&folio->page));
 		}
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
-			int nr = thp_nr_pages(head);
+			int nr = folio_nr_pages(folio);
 
-			xas_split(&xas, head, thp_order(head));
-			if (PageSwapBacked(head)) {
-				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
+			xas_split(&xas, folio, folio_order(folio));
+			if (folio_test_swapbacked(folio)) {
+				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
 							-nr);
 			} else {
-				__mod_lruvec_page_state(head, NR_FILE_THPS,
+				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
 							-nr);
 				filemap_nr_thps_dec(mapping);
 			}
_

Patches currently in -mm which might be from willy@infradead.org are

tools-fix-compilation-after-gfp_typesh-split.patch
mm-fix-vm_bug_on-in-__delete_from_swap_cache.patch
vmscan-check-folio_test_private-not-folio_get_private.patch
support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mm-vmscan-fix-a-lot-of-comments.patch
mm-add-the-first-tail-page-to-struct-folio.patch
mm-reimplement-folio_order-and-folio_nr_pages.patch
mm-add-split_folio.patch
mm-add-folio_add_lru_vma.patch
shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch
shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch
shmem-convert-shmem_replace_page-to-use-folios-throughout.patch
mm-swapfile-remove-page_swapcount.patch
mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch
mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch
mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch
mm-swap-convert-put_swap_page-to-put_swap_folio.patch
mm-convert-do_swap_page-to-use-a-folio.patch
mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch
memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch
shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch
shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch
swap-add-swap_cache_get_folio.patch
shmem-eliminate-struct-page-from-shmem_swapin_folio.patch
shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch
shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch
shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch
shmem-add-shmem_get_folio.patch
shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch
shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch
shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch
shmem-convert-shmem_fallocate-to-use-a-folio.patch
shmem-convert-shmem_symlink-to-use-a-folio.patch
shmem-convert-shmem_get_link-to-use-a-folio.patch
khugepaged-call-shmem_get_folio.patch
userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch
shmem-remove-shmem_getpage.patch
swapfile-convert-try_to_unuse-to-use-a-folio.patch
swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch
swapfile-convert-unuse_pte_range-to-use-a-folio.patch
mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch
mm-remove-lookup_swap_cache.patch
swap_state-convert-free_swap_cache-to-use-a-folio.patch
swap-convert-swap_writepage-to-use-a-folio.patch
mm-convert-do_wp_page-to-use-a-folio.patch
huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch
madvise-convert-madvise_free_pte_range-to-use-a-folio.patch
uprobes-use-folios-more-widely-in-__replace_page.patch
ksm-use-a-folio-in-replace_page.patch
mm-convert-do_swap_page-to-use-folio_free_swap.patch
memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch
mm-remove-try_to_free_swap.patch
rmap-convert-page_move_anon_rmap-to-use-a-folio.patch
migrate-convert-__unmap_and_move-to-use-folios.patch
migrate-convert-unmap_and_move_huge_page-to-use-folios.patch
huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch
huge_memory-convert-unmap_page-to-unmap_folio.patch
mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch
rmap-remove-page_unlock_anon_vma_read.patch
uprobes-use-new_folio-in-__replace_page.patch
mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

