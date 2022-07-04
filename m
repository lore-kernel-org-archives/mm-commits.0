Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD03DCCA47C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiGDBMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiGDBLG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169306397
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9063C6129E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A34C341C6;
        Mon,  4 Jul 2022 01:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897039;
        bh=nT6O2yXp6CmDzX+XTxIrt8xyPQW4ycf96+CS384tcL8=;
        h=Date:To:From:Subject:From;
        b=jMEXsZq2mWGMoU6x2O87QBGTZCeaBUkyXP40AIOMJpfAmOM6YESZBkbQLgOAEGzMJ
         GGE56c2HMgo+9jpBIhp3+17YL1Qphqe4dQd6d7efLg1kv8T3vbiUMQdtpzdqjO63je
         x3hqt1RA09YMW6zRfXWJb3EePZ3+qj1TsTAQVC/Q=
Date:   Sun, 03 Jul 2022 18:10:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-__page_cache_release-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220704011038.E1A34C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert __page_cache_release() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-__page_cache_release-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch
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
mips-rename-pmd_order-to-pmd_table_order.patch

