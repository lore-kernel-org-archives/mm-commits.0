From: akpm@linux-foundation.org
Subject: [failures] vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-available.patch removed from -mm tree
Date: Fri, 03 Jul 2009 01:59:19 -0700
Message-ID: <200907030859.n638xJ3K004904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbZGCJAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jul 2009 05:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: don't attempt to reclaim anon page in lumpy reclaim when no swap space is available
has been removed from the -mm tree.  Its filename was
     vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-available.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: don't attempt to reclaim anon page in lumpy reclaim when no swap space is available
From: Minchan Kim <minchan.kim@gmail.com>

VM already avoids attempting to reclaim anon pages in various places, But
it doesn't avoid it for lumpy reclaim.

It shuffles lru list unnecessary so that it is pointless.

__isolate_lru_page is called on slow path so that some condition check
could be not critical about performance.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmscan.c~vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-available mm/vmscan.c
--- a/mm/vmscan.c~vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-available
+++ a/mm/vmscan.c
@@ -823,7 +823,13 @@ int __isolate_lru_page(struct page *page
 	 * When this function is being called for lumpy reclaim, we
 	 * initially look into all LRU pages, active, inactive and
 	 * unevictable; only give shrink_page_list evictable pages.
+	 *
+	 * If we don't have enough swap space, reclaiming of anon page
+	 * which don't already have a swap slot is pointless.
 	 */
+	if (nr_swap_pages <= 0 && (PageAnon(page) && !PageSwapCache(page)))
+		return ret;
+
 	if (PageUnevictable(page))
 		return ret;
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-available.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch

