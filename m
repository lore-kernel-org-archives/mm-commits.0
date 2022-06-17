Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D472C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbiFQXBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiFQXBv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:01:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F93462CDC
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96FA36142F
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6D9C3411D;
        Fri, 17 Jun 2022 23:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655506909;
        bh=P1/Ee1WKlYEU9oeUAl410e3jRtXrqlE0hoclC2x0Nak=;
        h=Date:To:From:Subject:From;
        b=VW2XjlJqAOHI0gD/kvSYthUy966N3CVJoaGkBo8f6hKhzuiMqs9Cj3Bq8Z6iIgCWD
         lReWlcy2o5IMBZaFzLxZScQ4+DK+iyKu5rWU09vRgmM4ZTEX/fUkADMh4STK0LHIkD
         2yQGLF1jc/+AaxEOI4Gw34kyAMtCk7WEdHTNbq/Q=
Date:   Fri, 17 Jun 2022 16:01:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220617230148.EC6D9C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: convert isolate_lru_pages() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch

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
Subject: mm/vmscan: convert isolate_lru_pages() to use a folio
Date: Fri, 17 Jun 2022 16:42:45 +0100

Remove a few hidden calls to compound_head, saving 279 bytes of text.

Link: https://lkml.kernel.org/r/20220617154248.700416-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   66 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-isolate_lru_pages-to-use-a-folio
+++ a/mm/vmscan.c
@@ -160,17 +160,17 @@ struct scan_control {
 };
 
 #ifdef ARCH_HAS_PREFETCHW
-#define prefetchw_prev_lru_page(_page, _base, _field)			\
+#define prefetchw_prev_lru_folio(_folio, _base, _field)			\
 	do {								\
-		if ((_page)->lru.prev != _base) {			\
-			struct page *prev;				\
+		if ((_folio)->lru.prev != _base) {			\
+			struct folio *prev;				\
 									\
-			prev = lru_to_page(&(_page->lru));		\
+			prev = lru_to_folio(&(_folio->lru));		\
 			prefetchw(&prev->_field);			\
 		}							\
 	} while (0)
 #else
-#define prefetchw_prev_lru_page(_page, _base, _field) do { } while (0)
+#define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
 #endif
 
 /*
@@ -2145,72 +2145,72 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
 	unsigned long skipped = 0;
 	unsigned long scan, total_scan, nr_pages;
-	LIST_HEAD(pages_skipped);
+	LIST_HEAD(folios_skipped);
 
 	total_scan = 0;
 	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
 		struct list_head *move_to = src;
-		struct page *page;
+		struct folio *folio;
 
-		page = lru_to_page(src);
-		prefetchw_prev_lru_page(page, src, flags);
+		folio = lru_to_folio(src);
+		prefetchw_prev_lru_folio(folio, src, flags);
 
-		nr_pages = compound_nr(page);
+		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (page_zonenum(page) > sc->reclaim_idx) {
-			nr_skipped[page_zonenum(page)] += nr_pages;
-			move_to = &pages_skipped;
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
+			nr_skipped[folio_zonenum(folio)] += nr_pages;
+			move_to = &folios_skipped;
 			goto move;
 		}
 
 		/*
-		 * Do not count skipped pages because that makes the function
-		 * return with no isolated pages if the LRU mostly contains
-		 * ineligible pages.  This causes the VM to not reclaim any
-		 * pages, triggering a premature OOM.
-		 * Account all tail pages of THP.
+		 * Do not count skipped folios because that makes the function
+		 * return with no isolated folios if the LRU mostly contains
+		 * ineligible folios.  This causes the VM to not reclaim any
+		 * folios, triggering a premature OOM.
+		 * Account all pages in a folio.
 		 */
 		scan += nr_pages;
 
-		if (!PageLRU(page))
+		if (!folio_test_lru(folio))
 			goto move;
-		if (!sc->may_unmap && page_mapped(page))
+		if (!sc->may_unmap && folio_mapped(folio))
 			goto move;
 
 		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
+		 * Be careful not to clear the lru flag until after we're
+		 * sure the folio is not being freed elsewhere -- the
+		 * folio release code relies on it.
 		 */
-		if (unlikely(!get_page_unless_zero(page)))
+		if (unlikely(!folio_try_get(folio)))
 			goto move;
 
-		if (!TestClearPageLRU(page)) {
-			/* Another thread is already isolating this page */
-			put_page(page);
+		if (!folio_test_clear_lru(folio)) {
+			/* Another thread is already isolating this folio */
+			folio_put(folio);
 			goto move;
 		}
 
 		nr_taken += nr_pages;
-		nr_zone_taken[page_zonenum(page)] += nr_pages;
+		nr_zone_taken[folio_zonenum(folio)] += nr_pages;
 		move_to = dst;
 move:
-		list_move(&page->lru, move_to);
+		list_move(&folio->lru, move_to);
 	}
 
 	/*
-	 * Splice any skipped pages to the start of the LRU list. Note that
+	 * Splice any skipped folios to the start of the LRU list. Note that
 	 * this disrupts the LRU order when reclaiming for lower zones but
 	 * we cannot splice to the tail. If we did then the SWAP_CLUSTER_MAX
-	 * scanning would soon rescan the same pages to skip and waste lots
+	 * scanning would soon rescan the same folios to skip and waste lots
 	 * of cpu cycles.
 	 */
-	if (!list_empty(&pages_skipped)) {
+	if (!list_empty(&folios_skipped)) {
 		int zid;
 
-		list_splice(&pages_skipped, src);
+		list_splice(&folios_skipped, src);
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			if (!nr_skipped[zid])
 				continue;
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

