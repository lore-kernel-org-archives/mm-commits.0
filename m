From: akpm@linux-foundation.org
Subject: [merged] vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:44 -0700
Message-ID: <200909222038.n8MKci6P002023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbZIVUmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: don't attempt to reclaim anon page in lumpy reclaim when no swap space is available
has been removed from the -mm tree.  Its filename was
     vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: don't attempt to reclaim anon page in lumpy reclaim when no swap space is available
From: Minchan Kim <minchan.kim@gmail.com>

The VM already avoids attempting to reclaim anon pages in various places,
But it doesn't avoid it for lumpy reclaim.

It shuffles lru list unnecessary so that it is pointless.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/vmscan.c~vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable mm/vmscan.c
--- a/mm/vmscan.c~vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable
+++ a/mm/vmscan.c
@@ -935,6 +935,16 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
+
+			/*
+			 * If we don't have enough swap space, reclaiming of
+			 * anon page which don't already have a swap slot is
+			 * pointless.
+			 */
+			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
+					!PageSwapCache(cursor_page))
+				continue;
+
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch

