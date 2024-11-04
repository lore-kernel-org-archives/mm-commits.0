Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7349290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695945; cv=none; b=D8KKkGRIrfQzBvcs6BEd0UasSySz0EnuYozs3opcBgWwgDmvd1nLqAQoTXuQWowTCXB+Oi/0ErboCSDurLyl4JO9dc0t9BmxRs91gnoV7TZEf0CtNJI8PZTCoMI7uDvR82ggy3qywusuVwmQKVr1xoGXCyMJzDgdKZQbRPmEHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695945; c=relaxed/simple;
	bh=Sj1MvtxsLjWC5Q1RwnumEWeqetdPABrDdj0GddgrwjM=;
	h=Date:To:From:Subject:Message-Id; b=cG8zOmqW6spz9TqnMn4P4+2pxohCxXUCaPoF4h3YzviKUzLA2rQFbWWUdLOG8LEnofUUXJPVxuyX3L0oqdrJk+LFdxNMXva7DJOEHVI/QcUKy/1zz9bEiLCZjnxIVjt/Fz7fvpKkLhHn2aHTriGdOnlns9aNEA03RV5loAUOc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lomVOGHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lomVOGHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB73C4CECE;
	Mon,  4 Nov 2024 04:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695944;
	bh=Sj1MvtxsLjWC5Q1RwnumEWeqetdPABrDdj0GddgrwjM=;
	h=Date:To:From:Subject:From;
	b=lomVOGHJ8QBlLpb7Rmbhu1UdhNvuO8aR6b96wpKac46GChqLmkbi3FbNCAR+QRZoz
	 R/YapTdKYQYq5LrN32vWs3Zn++W2hifgCck3tvzjBw3x3r7XfovVg5VvibQLFAjqCB
	 W2OQ/fZawlGzb6RKKu/mUGtnKJDMr2iB+86ZxTHI=
Date: Sun, 03 Nov 2024 20:52:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,minchan@kernel.org,kaleshsingh@google.com,jaewon31.kim@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] vmscan-add-a-vmscan-event-for-reclaim_pages-v3.patch removed from -mm tree
Message-Id: <20241104045224.6BB73C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmscan-add-a-vmscan-event-for-reclaim_pages-v3
has been removed from the -mm tree.  Its filename was
     vmscan-add-a-vmscan-event-for-reclaim_pages-v3.patch

This patch was dropped because it was folded into vmscan-add-a-vmscan-event-for-reclaim_pages.patch

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan-add-a-vmscan-event-for-reclaim_pages-v3
Date: Wed, 16 Oct 2024 23:32:27 +0900

use sc.nr_scanned rather than new counting

Link: https://lkml.kernel.org/r/20241016143227.961162-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~vmscan-add-a-vmscan-event-for-reclaim_pages-v3
+++ a/mm/vmscan.c
@@ -2127,7 +2127,6 @@ static void shrink_active_list(unsigned
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
-				      unsigned int nr_scanned,
 				      struct pglist_data *pgdat)
 {
 	struct reclaim_stat stat;
@@ -2147,7 +2146,7 @@ static unsigned int reclaim_folio_list(s
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
@@ -2155,7 +2154,6 @@ static unsigned int reclaim_folio_list(s
 unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
-	unsigned int nr_scanned = 0;
 	unsigned int nr_reclaimed = 0;
 	LIST_HEAD(node_folio_list);
 	unsigned int noreclaim_flag;
@@ -2172,18 +2170,15 @@ unsigned long reclaim_pages(struct list_
 		if (nid == folio_nid(folio)) {
 			folio_clear_active(folio);
 			list_move(&folio->lru, &node_folio_list);
-			nr_scanned += folio_nr_pages(folio);
 			continue;
 		}
 
-		nr_reclaimed += reclaim_folio_list(&node_folio_list, nr_scanned,
-						   NODE_DATA(nid));
-		nr_scanned = 0;
+		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, nr_scanned,
-					   NODE_DATA(nid));
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
+
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return nr_reclaimed;
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

vmscan-add-a-vmscan-event-for-reclaim_pages.patch

