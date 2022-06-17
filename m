Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66F4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348242AbiFQXPi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiFQXPW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:15:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D696540E
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66AE86174E
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88A7C3411B;
        Fri, 17 Jun 2022 23:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507696;
        bh=U6Y9Cbk/+e7oX9dMf/4ykzwpeHqSOgng/NfrphGUC7o=;
        h=Date:To:From:Subject:From;
        b=ZJt42g6PLPX+ZxVETMwcxkCthdwoFXTMQu0wCsglHGFi4mjeKE9eXR+o47OnbUTKk
         zicJjgjXVq8wD+luHp9SxyUKFpR/e7L3ggpdxNOPIyV5U2uNy2cVFQ8bEQUZcPeJ7J
         7zXLkbhogMSbLkqmpN+Mx1Ib/RalDTFCDfti86SA=
Date:   Fri, 17 Jun 2022 16:14:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch added to mm-unstable branch
Message-Id: <20220617231456.B88A7C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert __delete_from_swap_cache() to a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch

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
Subject: mm/swap: convert __delete_from_swap_cache() to a folio
Date: Fri, 17 Jun 2022 18:50:20 +0100

All callers now have a folio, so convert the entire function to operate
on folios.

Link: https://lkml.kernel.org/r/20220617175020.717127-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    4 ++--
 mm/swap_state.c |   25 +++++++++++++------------
 mm/vmscan.c     |    2 +-
 3 files changed, 16 insertions(+), 15 deletions(-)

--- a/mm/swap.h~mm-swap-convert-__delete_from_swap_cache-to-a-folio
+++ a/mm/swap.h
@@ -36,7 +36,7 @@ bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct page *page, swp_entry_t entry,
 		      gfp_t gfp, void **shadowp);
-void __delete_from_swap_cache(struct page *page,
+void __delete_from_swap_cache(struct folio *folio,
 			      swp_entry_t entry, void *shadow);
 void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
@@ -135,7 +135,7 @@ static inline int add_to_swap_cache(stru
 	return -1;
 }
 
-static inline void __delete_from_swap_cache(struct page *page,
+static inline void __delete_from_swap_cache(struct folio *folio,
 					swp_entry_t entry, void *shadow)
 {
 }
--- a/mm/swap_state.c~mm-swap-convert-__delete_from_swap_cache-to-a-folio
+++ a/mm/swap_state.c
@@ -133,31 +133,32 @@ unlock:
 }
 
 /*
- * This must be called only on pages that have
+ * This must be called only on folios that have
  * been verified to be in the swap cache.
  */
-void __delete_from_swap_cache(struct page *page,
+void __delete_from_swap_cache(struct folio *folio,
 			swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
-	int i, nr = thp_nr_pages(page);
+	int i;
+	long nr = folio_nr_pages(folio);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE(xas, &address_space->i_pages, idx);
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	VM_BUG_ON_PAGE(PageWriteback(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 
 	for (i = 0; i < nr; i++) {
 		void *entry = xas_store(&xas, shadow);
-		VM_BUG_ON_PAGE(entry != page, entry);
-		set_page_private(page + i, 0);
+		VM_BUG_ON_FOLIO(entry != folio, folio);
+		set_page_private(folio_page(folio, i), 0);
 		xas_next(&xas);
 	}
-	ClearPageSwapCache(page);
+	folio_clear_swapcache(folio);
 	address_space->nrpages -= nr;
-	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
-	__mod_lruvec_page_state(page, NR_SWAPCACHE, -nr);
+	__node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
+	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
 }
 
 /**
@@ -233,7 +234,7 @@ void delete_from_swap_cache(struct folio
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(&folio->page, entry, NULL);
+	__delete_from_swap_cache(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(&folio->page, entry);
--- a/mm/vmscan.c~mm-swap-convert-__delete_from_swap_cache-to-a-folio
+++ a/mm/vmscan.c
@@ -1329,7 +1329,7 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(folio, swap);
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__delete_from_swap_cache(&folio->page, swap, shadow);
+		__delete_from_swap_cache(folio, swap, shadow);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_page(&folio->page, swap);
 	} else {
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

