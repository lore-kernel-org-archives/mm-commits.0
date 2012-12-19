From: akpm@linux-foundation.org
Subject: [merged] vmscan-comment-too_many_isolated.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:53 -0800
Message-ID: <20121219204253.99520100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61559 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2LSUmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:55 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so278091vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: comment too_many_isolated()
has been removed from the -mm tree.  Its filename was
     vmscan-comment-too_many_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: vmscan: comment too_many_isolated()

Comment "Why it's doing so" rather than "What it does" as proposed by
Andrew Morton.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-comment-too_many_isolated mm/vmscan.c
--- a/mm/vmscan.c~vmscan-comment-too_many_isolated
+++ a/mm/vmscan.c
@@ -1177,7 +1177,11 @@ int isolate_lru_page(struct page *page)
 }
 
 /*
- * Are there way too many processes in the direct reclaim path already?
+ * A direct reclaimer may isolate SWAP_CLUSTER_MAX pages from the LRU list and
+ * then get resheduled. When there are massive number of tasks doing page
+ * allocation, such sleeping direct reclaimers may keep piling up on each CPU,
+ * the LRU list will go small and be scanned faster than necessary, leading to
+ * unnecessary swapping, thrashing and OOM.
  */
 static int too_many_isolated(struct zone *zone, int file,
 		struct scan_control *sc)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

