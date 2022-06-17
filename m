Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E66C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbiFQXPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348242AbiFQXPV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:15:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB2165D2A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F42B61698
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AD8C3411B;
        Fri, 17 Jun 2022 23:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507693;
        bh=BaXTWE3ZJyo24K4oFBbCQgkHdwkem7VUG+BR3a5eHqY=;
        h=Date:To:From:Subject:From;
        b=Lqtrk/hurClx3/0Xb/pGsX5zIGiHb/I/wh6el41yVLtxc41GnNp2vShaARhTQAC2w
         zEM7HZik/A7BhaouU8oVpFnXw7nX05v+1J8XUijPyCjgOl+JLVyb8rkyj7R/nKorxP
         lpOTWtI7FSjemTYO8l1iUFLP6Xx4274HJP+kMd2Y=
Date:   Fri, 17 Jun 2022 16:14:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20220617231453.C6AD8C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert delete_from_swap_cache() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch

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
Subject: mm/swap: convert delete_from_swap_cache() to take a folio
Date: Fri, 17 Jun 2022 18:50:19 +0100

All but one caller already has a folio, so convert it to use a folio.

Link: https://lkml.kernel.org/r/20220617175020.717127-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +++--
 mm/shmem.c          |    4 ++--
 mm/swap.h           |    4 ++--
 mm/swap_state.c     |   16 ++++++++--------
 mm/swapfile.c       |    2 +-
 5 files changed, 16 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-swap-convert-delete_from_swap_cache-to-take-a-folio
+++ a/mm/memory-failure.c
@@ -1049,12 +1049,13 @@ static int me_swapcache_dirty(struct pag
 
 static int me_swapcache_clean(struct page_state *ps, struct page *p)
 {
+	struct folio *folio = page_folio(p);
 	int ret;
 
-	delete_from_swap_cache(p);
+	delete_from_swap_cache(folio);
 
 	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
-	unlock_page(p);
+	folio_unlock(folio);
 
 	if (has_extra_refcount(ps, p, false))
 		ret = MF_FAILED;
--- a/mm/shmem.c~mm-swap-convert-delete_from_swap_cache-to-take-a-folio
+++ a/mm/shmem.c
@@ -1691,7 +1691,7 @@ static void shmem_set_folio_swapin_error
 		return;
 
 	folio_wait_writeback(folio);
-	delete_from_swap_cache(&folio->page);
+	delete_from_swap_cache(folio);
 	spin_lock_irq(&info->lock);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks won't
@@ -1789,7 +1789,7 @@ static int shmem_swapin_folio(struct ino
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	delete_from_swap_cache(&folio->page);
+	delete_from_swap_cache(folio);
 	folio_mark_dirty(folio);
 	swap_free(swap);
 
--- a/mm/swapfile.c~mm-swap-convert-delete_from_swap_cache-to-take-a-folio
+++ a/mm/swapfile.c
@@ -1617,7 +1617,7 @@ int try_to_free_swap(struct page *page)
 	if (pm_suspended_storage())
 		return 0;
 
-	delete_from_swap_cache(&folio->page);
+	delete_from_swap_cache(folio);
 	folio_set_dirty(folio);
 	return 1;
 }
--- a/mm/swap.h~mm-swap-convert-delete_from_swap_cache-to-take-a-folio
+++ a/mm/swap.h
@@ -38,7 +38,7 @@ int add_to_swap_cache(struct page *page,
 		      gfp_t gfp, void **shadowp);
 void __delete_from_swap_cache(struct page *page,
 			      swp_entry_t entry, void *shadow);
-void delete_from_swap_cache(struct page *page);
+void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
 void free_swap_cache(struct page *page);
@@ -140,7 +140,7 @@ static inline void __delete_from_swap_ca
 {
 }
 
-static inline void delete_from_swap_cache(struct page *page)
+static inline void delete_from_swap_cache(struct folio *folio)
 {
 }
 
--- a/mm/swap_state.c~mm-swap-convert-delete_from_swap_cache-to-take-a-folio
+++ a/mm/swap_state.c
@@ -222,22 +222,22 @@ fail:
 }
 
 /*
- * This must be called only on pages that have
+ * This must be called only on folios that have
  * been verified to be in the swap cache and locked.
- * It will never put the page into the free list,
- * the caller has a reference on the page.
+ * It will never put the folio into the free list,
+ * the caller has a reference on the folio.
  */
-void delete_from_swap_cache(struct page *page)
+void delete_from_swap_cache(struct folio *folio)
 {
-	swp_entry_t entry = { .val = page_private(page) };
+	swp_entry_t entry = folio_swap_entry(folio);
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(page, entry, NULL);
+	__delete_from_swap_cache(&folio->page, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
-	put_swap_page(page, entry);
-	page_ref_sub(page, thp_nr_pages(page));
+	put_swap_page(&folio->page, entry);
+	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
_

Patches currently in -mm which might be from willy@infradead.org are

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
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch
mm-add-folios_put.patch
mm-swap-add-folio_batch_move_lru.patch
mm-swap-make-__pagevec_lru_add-static.patch
mm-swap-convert-lru_add-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate-to-a-folio_batch.patch
mm-swap-convert-lru_lazyfree-to-a-folio_batch.patch
mm-swap-convert-activate_page-to-a-folio_batch.patch
mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch
mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch
mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch

