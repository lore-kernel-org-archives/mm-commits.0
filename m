From: akpm@linux-foundation.org
Subject: + readahead-rescue_pages-updates.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:50:05 -0800
Message-ID: <200703180750.l2I7o5O7018377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbXCRHuO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: rescue_pages() updates
has been added to the -mm tree.  Its filename is
     readahead-rescue_pages-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: rescue_pages() updates
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

- Replace @page with @mapping and @index,
  which is a more usable interface.

- Add a new parameter @ra to rescue_pages(),
  which enables detailed accounting for individual readahead methods.

- Scan all pages in the range, instead of bailing out on first uncached page.

- ClearPageReadahead() on each page.
  It's harmful to have any lookahead marks when thrashing is pending.

- Add a call to rescue_pages() in thrashing_recovery_readahead().

Stress tested in qemu.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   67 +++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff -puN mm/readahead.c~readahead-rescue_pages-updates mm/readahead.c
--- a/mm/readahead.c~readahead-rescue_pages-updates
+++ a/mm/readahead.c
@@ -731,60 +731,60 @@ unsigned long max_sane_readahead(unsigne
 /*
  * Move pages in danger (of thrashing) to the head of inactive_list.
  * Not expected to happen frequently.
- *
- * @page will be skipped: it's grabbed and won't die away.
- * The following @nr_pages-1 pages will be protected.
  */
-static unsigned long rescue_pages(struct page *page, unsigned long nr_pages)
+static unsigned long rescue_pages(struct address_space *mapping,
+				  struct file_ra_state *ra,
+				  pgoff_t index, unsigned long nr_pages)
 {
-	int pgrescue = 0;
-	pgoff_t index = page_index(page);
-	struct address_space *mapping = page_mapping(page);
-	struct page *grabbed_page = NULL;
+	struct page *grabbed_page;
+	struct page *page;
 	struct zone *zone;
+	int pgrescue = 0;
 
-	dprintk("rescue_pages(ino=%lu, index=%lu nr=%lu)\n",
+	dprintk("rescue_pages(ino=%lu, index=%lu, nr=%lu)\n",
 			mapping->host->i_ino, index, nr_pages);
 
-	for(;;) {
+	for(; nr_pages;) {
+		grabbed_page = page = find_get_page(mapping, index);
+		if (!page) {
+			index++;
+			nr_pages--;
+			continue;
+		}
+
 		zone = page_zone(page);
 		spin_lock_irq(&zone->lru_lock);
 
-		if (!PageLRU(page))
-			goto out_unlock;
+		if (!PageLRU(page)) {
+			index++;
+			nr_pages--;
+			goto next_unlock;
+		}
 
-		while (page_mapping(page) == mapping &&
-				page_index(page) == index) {
+		do {
 			struct page *the_page = page;
 			page = list_entry((page)->lru.prev, struct page, lru);
+			index++;
+			nr_pages--;
+			ClearPageReadahead(the_page);
 			if (!PageActive(the_page) &&
 					!PageLocked(the_page) &&
 					page_count(the_page) == 1) {
 				list_move(&the_page->lru, &zone->inactive_list);
 				pgrescue++;
 			}
-			index++;
-			if (!--nr_pages)
-				goto out_unlock;
-		}
+		} while (nr_pages &&
+				page_mapping(page) == mapping &&
+				page_index(page) == index);
 
+next_unlock:
 		spin_unlock_irq(&zone->lru_lock);
+		page_cache_release(grabbed_page);
 		cond_resched();
-
-		if (grabbed_page)
-			page_cache_release(grabbed_page);
-		grabbed_page = page = find_get_page(mapping, index);
-		if (!page)
-			goto out;
 	}
 
-out_unlock:
-	spin_unlock_irq(&zone->lru_lock);
-out:
-	if (grabbed_page)
-		page_cache_release(grabbed_page);
-	ra_account(NULL, RA_EVENT_READAHEAD_RESCUE, pgrescue);
-	return nr_pages;
+	ra_account(ra, RA_EVENT_READAHEAD_RESCUE, pgrescue);
+	return pgrescue;
 }
 
 /*
@@ -1131,7 +1131,7 @@ clock_based_readahead(struct address_spa
 	ra_size = ra_size * readahead_ratio / 100;
 
 	if (page && remain_space <= la_size) {
-		rescue_pages(page, la_size);
+		rescue_pages(mapping, ra, offset, la_size);
 		goto cancel_lookahead;
 	}
 
@@ -1456,7 +1456,7 @@ has_history_pages:
 	la_size = start - offset;
 	if (page && ra_size < la_size) {
 		if (ra_size < offset)
-			rescue_pages(page, la_size);
+			rescue_pages(mapping, ra, offset, la_size);
 		return -1;
 	}
 
@@ -1584,6 +1584,7 @@ thrashing_recovery_readahead(struct addr
 		 * Further thrashings will bring us back to case (3) below.
 		 */
 		ra_size = ra->readahead_index - offset;
+		rescue_pages(mapping, ra, offset, ra_size);
 	} else {
 		/*
 		 * 3) The new chunk is lost.
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
