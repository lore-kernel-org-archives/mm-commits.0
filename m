From: akpm@linux-foundation.org
Subject: + vmscan-evict-streaming-io-first.patch added to -mm tree
Date: Tue, 18 Nov 2008 21:32:20 -0800
Message-ID: <200811190532.mAJ5WK92017899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYKSFcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 00:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, gene.heskett@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscan: evict streaming IO first
has been added to the -mm tree.  Its filename is
     vmscan-evict-streaming-io-first.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: evict streaming IO first
From: Rik van Riel <riel@redhat.com>

Count the insertion of new pages in the statistics used to drive the
pageout scanning code.  This should help the kernel quickly evict
streaming file IO.

We count on the fact that new file pages start on the inactive file LRU
and new anonymous pages start on the active anon list.  This means
streaming file IO will increment the recent scanned file statistic, while
leaving the recent rotated file statistic alone, driving pageout scanning
to the file LRUs.

Pageout activity does its own list manipulation.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Gene Heskett <gene.heskett@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~vmscan-evict-streaming-io-first mm/swap.c
--- a/mm/swap.c~vmscan-evict-streaming-io-first
+++ a/mm/swap.c
@@ -445,6 +445,7 @@ void ____pagevec_lru_add(struct pagevec 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 		struct zone *pagezone = page_zone(page);
+		int file;
 
 		if (pagezone != zone) {
 			if (zone)
@@ -456,8 +457,12 @@ void ____pagevec_lru_add(struct pagevec 
 		VM_BUG_ON(PageUnevictable(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
-		if (is_active_lru(lru))
+		file = is_file_lru(lru);
+		zone->recent_scanned[file]++;
+		if (is_active_lru(lru)) {
 			SetPageActive(page);
+			zone->recent_rotated[file]++;
+		}
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
_

Patches currently in -mm which might be from riel@redhat.com are

vmscan-let-gfp_nofs-go-to-swap-again.patch
vmscan-fix-get_scan_ratio-comment.patch
linux-next.patch
vmscan-evict-streaming-io-first.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

