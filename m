Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D446C54EE9
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIBX26 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiIBX2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDF6FBA66
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B66DB82E0B
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B6BC433D7;
        Fri,  2 Sep 2022 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161275;
        bh=KoXj7sjsAtMnoVUg+LXCk24tVeO8TMSEA0xi9qnE1is=;
        h=Date:To:From:Subject:From;
        b=x1DDS4QK12iLgl18wuSmpkLrQE6XcsxYMo18X1TNRZM9WZYg9Gwpk4xu7IVdK/YEH
         Oj+KkVTNONJ6dvpEzHxbvUuXf020UwZDl3eT1rWV8jUs5wiH03BV0HnvjgrVi5teW1
         19ofEWYTpAwAArLaidcWVPOQD6jv033zWgunzO1Q=
Date:   Fri, 02 Sep 2022 16:27:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-convert-unmap_and_move_huge_page-to-use-folios.patch added to mm-unstable branch
Message-Id: <20220902232755.C3B6BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate: convert unmap_and_move_huge_page() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     migrate-convert-unmap_and_move_huge_page-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-convert-unmap_and_move_huge_page-to-use-folios.patch

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
Subject: migrate: convert unmap_and_move_huge_page() to use folios
Date: Fri, 2 Sep 2022 20:46:47 +0100

Saves several calls to compound_head() and removes a couple of uses of
page->lru.

Link: https://lkml.kernel.org/r/20220902194653.1739778-52-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/migrate.c~migrate-convert-unmap_and_move_huge_page-to-use-folios
+++ a/mm/migrate.c
@@ -1263,7 +1263,7 @@ static int unmap_and_move_huge_page(new_
 	if (!hugepage_migration_supported(page_hstate(hpage)))
 		return -ENOSYS;
 
-	if (page_count(hpage) == 1) {
+	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
 		putback_active_hugepage(hpage);
 		return MIGRATEPAGE_SUCCESS;
@@ -1274,7 +1274,7 @@ static int unmap_and_move_huge_page(new_
 		return -ENOMEM;
 	dst = page_folio(new_hpage);
 
-	if (!trylock_page(hpage)) {
+	if (!folio_trylock(src)) {
 		if (!force)
 			goto out;
 		switch (mode) {
@@ -1284,29 +1284,29 @@ static int unmap_and_move_huge_page(new_
 		default:
 			goto out;
 		}
-		lock_page(hpage);
+		folio_lock(src);
 	}
 
 	/*
 	 * Check for pages which are in the process of being freed.  Without
-	 * page_mapping() set, hugetlbfs specific move page routine will not
+	 * folio_mapping() set, hugetlbfs specific move page routine will not
 	 * be called and we could leak usage counts for subpools.
 	 */
-	if (hugetlb_page_subpool(hpage) && !page_mapping(hpage)) {
+	if (hugetlb_page_subpool(hpage) && !folio_mapping(src)) {
 		rc = -EBUSY;
 		goto out_unlock;
 	}
 
-	if (PageAnon(hpage))
-		anon_vma = page_get_anon_vma(hpage);
+	if (folio_test_anon(src))
+		anon_vma = page_get_anon_vma(&src->page);
 
-	if (unlikely(!trylock_page(new_hpage)))
+	if (unlikely(!folio_trylock(dst)))
 		goto put_anon;
 
-	if (page_mapped(hpage)) {
+	if (folio_mapped(src)) {
 		enum ttu_flags ttu = 0;
 
-		if (!PageAnon(hpage)) {
+		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
 			 * call huge_pmd_unshare.  Because of this, take
@@ -1327,7 +1327,7 @@ static int unmap_and_move_huge_page(new_
 			i_mmap_unlock_write(mapping);
 	}
 
-	if (!page_mapped(hpage))
+	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
@@ -1335,7 +1335,7 @@ static int unmap_and_move_huge_page(new_
 			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
 
 unlock_put_anon:
-	unlock_page(new_hpage);
+	folio_unlock(dst);
 
 put_anon:
 	if (anon_vma)
@@ -1347,12 +1347,12 @@ put_anon:
 	}
 
 out_unlock:
-	unlock_page(hpage);
+	folio_unlock(src);
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
 		putback_active_hugepage(hpage);
 	else if (rc != -EAGAIN)
-		list_move_tail(&hpage->lru, ret);
+		list_move_tail(&src->lru, ret);
 
 	/*
 	 * If migration was not successful and there's a freeing callback, use
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

