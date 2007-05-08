From: akpm@linux-foundation.org
Subject: - readahead-rescue_pages-updates.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:48 -0700
Message-ID: <200705080815.l488FmcR019073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934648AbXEHIQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: rescue_pages() updates
has been removed from the -mm tree.  Its filename was
     readahead-rescue_pages-updates.patch

This patch was dropped because an updated version will be merged

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
@@ -734,60 +734,60 @@ unsigned long max_sane_readahead(unsigne
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
@@ -1134,7 +1134,7 @@ clock_based_readahead(struct address_spa
 	ra_size = ra_size * readahead_ratio / 100;
 
 	if (page && remain_space <= la_size) {
-		rescue_pages(page, la_size);
+		rescue_pages(mapping, ra, offset, la_size);
 		goto cancel_lookahead;
 	}
 
@@ -1459,7 +1459,7 @@ has_history_pages:
 	la_size = start - offset;
 	if (page && ra_size < la_size) {
 		if (ra_size < offset)
-			rescue_pages(page, la_size);
+			rescue_pages(mapping, ra, offset, la_size);
 		return -1;
 	}
 
@@ -1587,6 +1587,7 @@ thrashing_recovery_readahead(struct addr
 		 * Further thrashings will bring us back to case (3) below.
 		 */
 		ra_size = ra->readahead_index - offset;
+		rescue_pages(mapping, ra, offset, ra_size);
 	} else {
 		/*
 		 * 3) The new chunk is lost.
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
