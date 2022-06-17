Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918A1C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382328AbiFQXCD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiFQXB5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D926350B
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3541DB82C02
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4684C3411B;
        Fri, 17 Jun 2022 23:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655506912;
        bh=0UGE4VsGtcCGh9AoDj/Ls5ufO44OMXpXYIoGYwy/Hgg=;
        h=Date:To:From:Subject:From;
        b=eAWCwWjDqQbVLg6HwKoK8fpdqSxMIUP2hvfjrahgvOR4RRPS+OEStydmwTLXBGRkT
         uEx9kpEoID482v5Pxl/YhIDrx4iR02YCuVSsl1eE/690RSo0j+mmQ1hoh1QgEN8nBf
         BEaqJcLyo1tXJTSsx3ct2exUWEFFKCFTbIA1U+QQ=
Date:   Fri, 17 Jun 2022 16:01:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220617230152.C4684C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: convert shrink_active_list() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch

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
Subject: mm/vmscan: convert shrink_active_list() to use a folio
Date: Fri, 17 Jun 2022 16:42:47 +0100

Remove a few hidden calls to compound_head, saving 411 bytes of text.

Link: https://lkml.kernel.org/r/20220617154248.700416-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   61 +++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-shrink_active_list-to-use-a-folio
+++ a/mm/vmscan.c
@@ -26,8 +26,7 @@
 #include <linux/file.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>	/* for try_to_release_page(),
-					buffer_heads_over_limit */
+#include <linux/buffer_head.h>	/* for buffer_heads_over_limit */
 #include <linux/mm_inline.h>
 #include <linux/backing-dev.h>
 #include <linux/rmap.h>
@@ -2489,21 +2488,21 @@ shrink_inactive_list(unsigned long nr_to
 }
 
 /*
- * shrink_active_list() moves pages from the active LRU to the inactive LRU.
+ * shrink_active_list() moves folios from the active LRU to the inactive LRU.
  *
- * We move them the other way if the page is referenced by one or more
+ * We move them the other way if the folio is referenced by one or more
  * processes.
  *
- * If the pages are mostly unmapped, the processing is fast and it is
+ * If the folios are mostly unmapped, the processing is fast and it is
  * appropriate to hold lru_lock across the whole operation.  But if
- * the pages are mapped, the processing is slow (folio_referenced()), so
- * we should drop lru_lock around each page.  It's impossible to balance
- * this, so instead we remove the pages from the LRU while processing them.
- * It is safe to rely on PG_active against the non-LRU pages in here because
- * nobody will play with that bit on a non-LRU page.
+ * the folios are mapped, the processing is slow (folio_referenced()), so
+ * we should drop lru_lock around each folio.  It's impossible to balance
+ * this, so instead we remove the folios from the LRU while processing them.
+ * It is safe to rely on the active flag against the non-LRU folios in here
+ * because nobody will play with that bit on a non-LRU folio.
  *
- * The downside is that we have to touch page->_refcount against each page.
- * But we had to alter page->flags anyway.
+ * The downside is that we have to touch folio->_refcount against each folio.
+ * But we had to alter folio->flags anyway.
  */
 static void shrink_active_list(unsigned long nr_to_scan,
 			       struct lruvec *lruvec,
@@ -2513,7 +2512,7 @@ static void shrink_active_list(unsigned
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
 	unsigned long vm_flags;
-	LIST_HEAD(l_hold);	/* The pages which were snipped off */
+	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	unsigned nr_deactivate, nr_activate;
@@ -2538,23 +2537,21 @@ static void shrink_active_list(unsigned
 
 	while (!list_empty(&l_hold)) {
 		struct folio *folio;
-		struct page *page;
 
 		cond_resched();
 		folio = lru_to_folio(&l_hold);
 		list_del(&folio->lru);
-		page = &folio->page;
 
-		if (unlikely(!page_evictable(page))) {
-			putback_lru_page(page);
+		if (unlikely(!folio_evictable(folio))) {
+			folio_putback_lru(folio);
 			continue;
 		}
 
 		if (unlikely(buffer_heads_over_limit)) {
-			if (page_has_private(page) && trylock_page(page)) {
-				if (page_has_private(page))
-					try_to_release_page(page, 0);
-				unlock_page(page);
+			if (folio_get_private(folio) && folio_trylock(folio)) {
+				if (folio_get_private(folio))
+					filemap_release_folio(folio, 0);
+				folio_unlock(folio);
 			}
 		}
 
@@ -2562,34 +2559,34 @@ static void shrink_active_list(unsigned
 		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
 				     &vm_flags) != 0) {
 			/*
-			 * Identify referenced, file-backed active pages and
+			 * Identify referenced, file-backed active folios and
 			 * give them one more trip around the active list. So
 			 * that executable code get better chances to stay in
-			 * memory under moderate memory pressure.  Anon pages
+			 * memory under moderate memory pressure.  Anon folios
 			 * are not likely to be evicted by use-once streaming
-			 * IO, plus JVM can create lots of anon VM_EXEC pages,
+			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
-				nr_rotated += thp_nr_pages(page);
-				list_add(&page->lru, &l_active);
+			if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio)) {
+				nr_rotated += folio_nr_pages(folio);
+				list_add(&folio->lru, &l_active);
 				continue;
 			}
 		}
 
-		ClearPageActive(page);	/* we are de-activating */
-		SetPageWorkingset(page);
-		list_add(&page->lru, &l_inactive);
+		folio_clear_active(folio);	/* we are de-activating */
+		folio_set_workingset(folio);
+		list_add(&folio->lru, &l_inactive);
 	}
 
 	/*
-	 * Move pages back to the lru list.
+	 * Move folios back to the lru list.
 	 */
 	spin_lock_irq(&lruvec->lru_lock);
 
 	nr_activate = move_pages_to_lru(lruvec, &l_active);
 	nr_deactivate = move_pages_to_lru(lruvec, &l_inactive);
-	/* Keep all free pages in l_active list */
+	/* Keep all free folios in l_active list */
 	list_splice(&l_inactive, &l_active);
 
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
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

