Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C918EC6FA86
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiIBX3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiIBX16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD935F5480
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE6161E2F
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE17C433C1;
        Fri,  2 Sep 2022 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161273;
        bh=4rmjsV+lXq9AcNazGs+/4jSBFANG3d5vXzo9BkmZ+XQ=;
        h=Date:To:From:Subject:From;
        b=SKMxjhA+IpaMi7VZ8m4qSWFyTRluXoATOCFpGXVqg+d5RAG4cpcPbh86B1mqEFqBi
         4bUmRcYriGCZ4EXiFXx74mWG4qAmEr8KEM36ENMh1LFOubVgIQMMHPoKFh8PoTk7tP
         3ieQ9iaKU15U2ADj6FAg46pgXgs/ycFvKICDJ5x0=
Date:   Fri, 02 Sep 2022 16:27:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-convert-__unmap_and_move-to-use-folios.patch added to mm-unstable branch
Message-Id: <20220902232753.BCE17C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate: convert __unmap_and_move() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     migrate-convert-__unmap_and_move-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-convert-__unmap_and_move-to-use-folios.patch

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
Subject: migrate: convert __unmap_and_move() to use folios
Date: Fri, 2 Sep 2022 20:46:46 +0100

Removes a lot of calls to compound_head().  Also remove a VM_BUG_ON that
can never trigger as the PageAnon bit is the bottom bit of page->mapping.

Link: https://lkml.kernel.org/r/20220902194653.1739778-51-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   75 ++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

--- a/mm/migrate.c~migrate-convert-__unmap_and_move-to-use-folios
+++ a/mm/migrate.c
@@ -993,17 +993,15 @@ out:
 	return rc;
 }
 
-static int __unmap_and_move(struct page *page, struct page *newpage,
+static int __unmap_and_move(struct folio *src, struct folio *dst,
 				int force, enum migrate_mode mode)
 {
-	struct folio *folio = page_folio(page);
-	struct folio *dst = page_folio(newpage);
 	int rc = -EAGAIN;
 	bool page_was_mapped = false;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__PageMovable(page);
+	bool is_lru = !__PageMovable(&src->page);
 
-	if (!trylock_page(page)) {
+	if (!folio_trylock(src)) {
 		if (!force || mode == MIGRATE_ASYNC)
 			goto out;
 
@@ -1023,10 +1021,10 @@ static int __unmap_and_move(struct page
 		if (current->flags & PF_MEMALLOC)
 			goto out;
 
-		lock_page(page);
+		folio_lock(src);
 	}
 
-	if (PageWriteback(page)) {
+	if (folio_test_writeback(src)) {
 		/*
 		 * Only in the case of a full synchronous migration is it
 		 * necessary to wait for PageWriteback. In the async case,
@@ -1043,12 +1041,12 @@ static int __unmap_and_move(struct page
 		}
 		if (!force)
 			goto out_unlock;
-		wait_on_page_writeback(page);
+		folio_wait_writeback(src);
 	}
 
 	/*
-	 * By try_to_migrate(), page->mapcount goes down to 0 here. In this case,
-	 * we cannot notice that anon_vma is freed while we migrates a page.
+	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
+	 * we cannot notice that anon_vma is freed while we migrate a page.
 	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
@@ -1060,22 +1058,22 @@ static int __unmap_and_move(struct page
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
-	if (PageAnon(page) && !PageKsm(page))
-		anon_vma = page_get_anon_vma(page);
+	if (folio_test_anon(src) && !folio_test_ksm(src))
+		anon_vma = page_get_anon_vma(&src->page);
 
 	/*
 	 * Block others from accessing the new page when we get around to
 	 * establishing additional references. We are usually the only one
-	 * holding a reference to newpage at this point. We used to have a BUG
-	 * here if trylock_page(newpage) fails, but would like to allow for
-	 * cases where there might be a race with the previous use of newpage.
+	 * holding a reference to dst at this point. We used to have a BUG
+	 * here if folio_trylock(dst) fails, but would like to allow for
+	 * cases where there might be a race with the previous use of dst.
 	 * This is much like races on refcount of oldpage: just don't BUG().
 	 */
-	if (unlikely(!trylock_page(newpage)))
+	if (unlikely(!folio_trylock(dst)))
 		goto out_unlock;
 
 	if (unlikely(!is_lru)) {
-		rc = move_to_new_folio(dst, folio, mode);
+		rc = move_to_new_folio(dst, src, mode);
 		goto out_unlock_both;
 	}
 
@@ -1083,7 +1081,7 @@ static int __unmap_and_move(struct page
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
 	 * and treated as swapcache but it has no rmap yet.
-	 * Calling try_to_unmap() against a page->mapping==NULL page will
+	 * Calling try_to_unmap() against a src->mapping==NULL page will
 	 * trigger a BUG.  So handle it here.
 	 * 2. An orphaned page (see truncate_cleanup_page) might have
 	 * fs-private metadata. The page can be picked up due to memory
@@ -1091,57 +1089,56 @@ static int __unmap_and_move(struct page
 	 * invisible to the vm, so the page can not be migrated.  So try to
 	 * free the metadata, so the page can be freed.
 	 */
-	if (!page->mapping) {
-		VM_BUG_ON_PAGE(PageAnon(page), page);
-		if (page_has_private(page)) {
-			try_to_free_buffers(folio);
+	if (!src->mapping) {
+		if (folio_test_private(src)) {
+			try_to_free_buffers(src);
 			goto out_unlock_both;
 		}
-	} else if (page_mapped(page)) {
+	} else if (folio_mapped(src)) {
 		/* Establish migration ptes */
-		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
-				page);
-		try_to_migrate(folio, 0);
+		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
+			       !folio_test_ksm(src) && !anon_vma, src);
+		try_to_migrate(src, 0);
 		page_was_mapped = true;
 	}
 
-	if (!page_mapped(page))
-		rc = move_to_new_folio(dst, folio, mode);
+	if (!folio_mapped(src))
+		rc = move_to_new_folio(dst, src, mode);
 
 	/*
-	 * When successful, push newpage to LRU immediately: so that if it
+	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
-	 * automatically build up the correct newpage->mlock_count for it.
+	 * automatically build up the correct dst->mlock_count for it.
 	 *
 	 * We would like to do something similar for the old page, when
 	 * unsuccessful, and other cases when a page has been temporarily
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		lru_cache_add(newpage);
+		folio_add_lru(dst);
 		if (page_was_mapped)
 			lru_add_drain();
 	}
 
 	if (page_was_mapped)
-		remove_migration_ptes(folio,
-			rc == MIGRATEPAGE_SUCCESS ? dst : folio, false);
+		remove_migration_ptes(src,
+			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
 
 out_unlock_both:
-	unlock_page(newpage);
+	folio_unlock(dst);
 out_unlock:
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
-	unlock_page(page);
+	folio_unlock(src);
 out:
 	/*
-	 * If migration is successful, decrease refcount of the newpage,
+	 * If migration is successful, decrease refcount of dst,
 	 * which will not free the page because new page owner increased
 	 * refcounter.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS)
-		put_page(newpage);
+		folio_put(dst);
 
 	return rc;
 }
@@ -1157,6 +1154,7 @@ static int unmap_and_move(new_page_t get
 				   enum migrate_reason reason,
 				   struct list_head *ret)
 {
+	struct folio *dst, *src = page_folio(page);
 	int rc = MIGRATEPAGE_SUCCESS;
 	struct page *newpage = NULL;
 
@@ -1174,9 +1172,10 @@ static int unmap_and_move(new_page_t get
 	newpage = get_new_page(page, private);
 	if (!newpage)
 		return -ENOMEM;
+	dst = page_folio(newpage);
 
 	newpage->private = 0;
-	rc = __unmap_and_move(page, newpage, force, mode);
+	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(newpage, reason);
 
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

