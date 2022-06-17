Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFB5C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiFQXOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiFQXOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A41864D18
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC5E6174E
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E782C3411B;
        Fri, 17 Jun 2022 23:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507676;
        bh=800GW54PKAt4yXrsm4dqMTqEwlLrb4nOic9U0kJ/5Ww=;
        h=Date:To:From:Subject:From;
        b=bmIYbMYEfwsp+mSuDGLpM/bFTuks+p3MNzziuuajhRyTN8OgkNMUIJEE7Ufot4y9D
         UwnE77MwTdCHNxyVfoWorAGVYK12l9X6Lqlud2u1Y2fNWidb9M53uV/seyqaZtwloI
         tNKi7Ncp+hCwWhg7aGhATXfTt20oXNsjaRUuGaAM=
Date:   Fri, 17 Jun 2022 16:14:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-try_to_free_swap-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220617231436.1E782C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert try_to_free_swap to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-try_to_free_swap-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-try_to_free_swap-to-use-a-folio.patch

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
Subject: mm/swap: convert try_to_free_swap to use a folio
Date: Fri, 17 Jun 2022 18:50:10 +0100

Save a few calls to compound_head by converting the passed page to
a folio.  Reduces kernel text size by 74 bytes.

Link: https://lkml.kernel.org/r/20220617175020.717127-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/swapfile.c~mm-swap-convert-try_to_free_swap-to-use-a-folio
+++ a/mm/swapfile.c
@@ -1568,16 +1568,15 @@ unlock_out:
 	return ret;
 }
 
-static bool page_swapped(struct page *page)
+static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry;
 	struct swap_info_struct *si;
 
-	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!PageTransCompound(page)))
-		return page_swapcount(page) != 0;
+	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
+		return page_swapcount(&folio->page) != 0;
 
-	page = compound_head(page);
-	entry.val = page_private(page);
+	entry = folio_swap_entry(folio);
 	si = _swap_info_get(entry);
 	if (si)
 		return swap_page_trans_huge_swapped(si, entry);
@@ -1590,13 +1589,14 @@ static bool page_swapped(struct page *pa
  */
 int try_to_free_swap(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	struct folio *folio = page_folio(page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	if (!PageSwapCache(page))
+	if (!folio_test_swapcache(folio))
 		return 0;
-	if (PageWriteback(page))
+	if (folio_test_writeback(folio))
 		return 0;
-	if (page_swapped(page))
+	if (folio_swapped(folio))
 		return 0;
 
 	/*
@@ -1617,9 +1617,8 @@ int try_to_free_swap(struct page *page)
 	if (pm_suspended_storage())
 		return 0;
 
-	page = compound_head(page);
-	delete_from_swap_cache(page);
-	SetPageDirty(page);
+	delete_from_swap_cache(&folio->page);
+	folio_set_dirty(folio);
 	return 1;
 }
 
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

