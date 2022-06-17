Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26CDCCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiFQXP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbiFQXPB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:15:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D35364D18
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 138B061560
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3A4C3411B;
        Fri, 17 Jun 2022 23:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507687;
        bh=yyL1aCxyBIZFEDizPBrRpdHcMT+qHHHUqpV5kth0hF4=;
        h=Date:To:From:Subject:From;
        b=yxYPk2sxwdN8P9CabrgL2sF3x2jrmkqh9IDI+sPmOhxB2uzC8aywz4ZW19/MDykDx
         mwrev5U2viPBnLYN4ww/c4RN3dTKkR57M3WQzSwNQ+Q8cGLAyG5efGuxKJzxy7P8m6
         Mljw5EOFLhWtCKyGmpQfenRnU0o0xhpSw23lYlNg=
Date:   Fri, 17 Jun 2022 16:14:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-__page_cache_release-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220617231447.6B3A4C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert __page_cache_release() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-__page_cache_release-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-__page_cache_release-to-use-a-folio.patch

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
Subject: mm/swap: convert __page_cache_release() to use a folio
Date: Fri, 17 Jun 2022 18:50:16 +0100

All the callers now have a folio.  Saves several calls to compound_head,
totalling 502 bytes of text.

Link: https://lkml.kernel.org/r/20220617175020.717127-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/mm/swap.c~mm-swap-convert-__page_cache_release-to-use-a-folio
+++ a/mm/swap.c
@@ -77,31 +77,30 @@ static DEFINE_PER_CPU(struct cpu_fbatche
  * This path almost never happens for VM activity - pages are normally freed
  * via pagevecs.  But it gets used by networking - and for compound pages.
  */
-static void __page_cache_release(struct page *page)
+static void __page_cache_release(struct folio *folio)
 {
-	if (PageLRU(page)) {
-		struct folio *folio = page_folio(page);
+	if (folio_test_lru(folio)) {
 		struct lruvec *lruvec;
 		unsigned long flags;
 
 		lruvec = folio_lruvec_lock_irqsave(folio, &flags);
-		del_page_from_lru_list(page, lruvec);
-		__clear_page_lru_flags(page);
+		lruvec_del_folio(lruvec, folio);
+		__folio_clear_lru_flags(folio);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
-	/* See comment on PageMlocked in release_pages() */
-	if (unlikely(PageMlocked(page))) {
-		int nr_pages = thp_nr_pages(page);
+	/* See comment on folio_test_mlocked in release_pages() */
+	if (unlikely(folio_test_mlocked(folio))) {
+		long nr_pages = folio_nr_pages(folio);
 
-		__ClearPageMlocked(page);
-		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+		__folio_clear_mlocked(folio);
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
 		count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
 	}
 }
 
 static void __folio_put_small(struct folio *folio)
 {
-	__page_cache_release(&folio->page);
+	__page_cache_release(folio);
 	mem_cgroup_uncharge(folio);
 	free_unref_page(&folio->page, 0);
 }
@@ -115,7 +114,7 @@ static void __folio_put_large(struct fol
 	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
 	 */
 	if (!folio_test_hugetlb(folio))
-		__page_cache_release(&folio->page);
+		__page_cache_release(folio);
 	destroy_compound_page(&folio->page);
 }
 
@@ -199,14 +198,14 @@ static void lru_add_fn(struct lruvec *lr
 
 	/*
 	 * Is an smp_mb__after_atomic() still required here, before
-	 * folio_evictable() tests PageMlocked, to rule out the possibility
+	 * folio_evictable() tests the mlocked flag, to rule out the possibility
 	 * of stranding an evictable folio on an unevictable LRU?  I think
-	 * not, because __munlock_page() only clears PageMlocked while the LRU
-	 * lock is held.
+	 * not, because __munlock_page() only clears the mlocked flag
+	 * while the LRU lock is held.
 	 *
 	 * (That is not true of __page_cache_release(), and not necessarily
-	 * true of release_pages(): but those only clear PageMlocked after
-	 * put_page_testzero() has excluded any other users of the page.)
+	 * true of release_pages(): but those only clear the mlocked flag after
+	 * folio_put_testzero() has excluded any other users of the folio.)
 	 */
 	if (folio_evictable(folio)) {
 		if (was_unevictable)
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

