Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D15C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiFQXCE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382512AbiFQXB4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E563633BD
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44BCEB82C04
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2BEC3411B;
        Fri, 17 Jun 2022 23:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655506911;
        bh=DYAmjxKmBknyzZGMcGuA3xm8mdYBgx34u1hKysK+8tc=;
        h=Date:To:From:Subject:From;
        b=n1F5oF1/zSzsL1NkH2JiDXPhmU8XvG/F2GZA27qQ0jmOQabtUelxwofFRz478WrIq
         G+AvLUgwKSp+S7DhtN76XK+ihQHQX5C/Ocn38NPQ75zh5WuQSYxHy+PiH3gLhwsfZf
         OU94N7fbJyT+hykVm/Yk62CpRboJ3g4Y5GKJW9b8=
Date:   Fri, 17 Jun 2022 16:01:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220617230150.DE2BEC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: convert move_pages_to_lru() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch

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
Subject: mm/vmscan: convert move_pages_to_lru() to use a folio
Date: Fri, 17 Jun 2022 16:42:46 +0100

Remove a few hidden calls to compound_head, saving 387 bytes of text on
my test configuration.

Link: https://lkml.kernel.org/r/20220617154248.700416-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   54 +++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-move_pages_to_lru-to-use-a-folio
+++ a/mm/vmscan.c
@@ -2314,8 +2314,8 @@ static int too_many_isolated(struct pgli
 }
 
 /*
- * move_pages_to_lru() moves pages from private @list to appropriate LRU list.
- * On return, @list is reused as a list of pages to be freed by the caller.
+ * move_pages_to_lru() moves folios from private @list to appropriate LRU list.
+ * On return, @list is reused as a list of folios to be freed by the caller.
  *
  * Returns the number of pages moved to the given lruvec.
  */
@@ -2323,42 +2323,42 @@ static unsigned int move_pages_to_lru(st
 				      struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
-	LIST_HEAD(pages_to_free);
-	struct page *page;
+	LIST_HEAD(folios_to_free);
 
 	while (!list_empty(list)) {
-		page = lru_to_page(list);
-		VM_BUG_ON_PAGE(PageLRU(page), page);
-		list_del(&page->lru);
-		if (unlikely(!page_evictable(page))) {
+		struct folio *folio = lru_to_folio(list);
+
+		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+		list_del(&folio->lru);
+		if (unlikely(!folio_evictable(folio))) {
 			spin_unlock_irq(&lruvec->lru_lock);
-			putback_lru_page(page);
+			folio_putback_lru(folio);
 			spin_lock_irq(&lruvec->lru_lock);
 			continue;
 		}
 
 		/*
-		 * The SetPageLRU needs to be kept here for list integrity.
+		 * The folio_set_lru needs to be kept here for list integrity.
 		 * Otherwise:
 		 *   #0 move_pages_to_lru             #1 release_pages
-		 *   if !put_page_testzero
-		 *				      if (put_page_testzero())
-		 *				        !PageLRU //skip lru_lock
-		 *     SetPageLRU()
-		 *     list_add(&page->lru,)
-		 *                                        list_add(&page->lru,)
+		 *   if (!folio_put_testzero())
+		 *				      if (folio_put_testzero())
+		 *				        !lru //skip lru_lock
+		 *     folio_set_lru()
+		 *     list_add(&folio->lru,)
+		 *                                        list_add(&folio->lru,)
 		 */
-		SetPageLRU(page);
+		folio_set_lru(folio);
 
-		if (unlikely(put_page_testzero(page))) {
-			__clear_page_lru_flags(page);
+		if (unlikely(folio_put_testzero(folio))) {
+			__folio_clear_lru_flags(folio);
 
-			if (unlikely(PageCompound(page))) {
+			if (unlikely(folio_test_large(folio))) {
 				spin_unlock_irq(&lruvec->lru_lock);
-				destroy_compound_page(page);
+				destroy_compound_page(&folio->page);
 				spin_lock_irq(&lruvec->lru_lock);
 			} else
-				list_add(&page->lru, &pages_to_free);
+				list_add(&folio->lru, &folios_to_free);
 
 			continue;
 		}
@@ -2367,18 +2367,18 @@ static unsigned int move_pages_to_lru(st
 		 * All pages were isolated from the same lruvec (and isolation
 		 * inhibits memcg migration).
 		 */
-		VM_BUG_ON_PAGE(!folio_matches_lruvec(page_folio(page), lruvec), page);
-		add_page_to_lru_list(page, lruvec);
-		nr_pages = thp_nr_pages(page);
+		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+		lruvec_add_folio(lruvec, folio);
+		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-		if (PageActive(page))
+		if (folio_test_active(folio))
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
 
 	/*
 	 * To save our caller's stack, now use input list for pages to free.
 	 */
-	list_splice(&pages_to_free, list);
+	list_splice(&folios_to_free, list);
 
 	return nr_moved;
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

