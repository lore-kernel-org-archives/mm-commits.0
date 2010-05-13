From: akpm@linux-foundation.org
Subject: [nacked] vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch removed from -mm tree
Date: Thu, 13 May 2010 12:14:12 -0700
Message-ID: <201005131914.o4DJEDhP014820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab0EMTPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 15:15:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: fix unmapping behaviour for RECLAIM_SWAP
has been removed from the -mm tree.  Its filename was
     vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: fix unmapping behaviour for RECLAIM_SWAP
From: Johannes Weiner <hannes@cmpxchg.org>

The RECLAIM_SWAP flag in zone_reclaim_mode controls whether zone_reclaim()
is allowed to swap or not (obviously).

This is currently implemented by allowing or forbidding reclaim to unmap
pages, which also controls reclaim of shared pages and is thus not
appropriate.

We can do better by using the sc->may_swap parameter instead, which
controls whether the anon lists are scanned.

Unmapping of pages is then allowed per default from zone_reclaim().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-unmapping-behaviour-for-reclaim_swap mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-unmapping-behaviour-for-reclaim_swap
+++ a/mm/vmscan.c
@@ -2565,8 +2565,8 @@ static int __zone_reclaim(struct zone *z
 	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
-		.may_swap = 1,
+		.may_unmap = 1,
+		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-document-follow_page.patch
vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch

