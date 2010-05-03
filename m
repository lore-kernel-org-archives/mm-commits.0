From: akpm@linux-foundation.org
Subject: + vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch added to -mm tree
Date: Mon, 03 May 2010 14:44:35 -0700
Message-ID: <201005032144.o43Lia2d023359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756146Ab0ECVpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 17:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: fix unmapping behaviour for RECLAIM_SWAP
has been added to the -mm tree.  Its filename is
     vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch

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
@@ -2563,8 +2563,8 @@ static int __zone_reclaim(struct zone *z
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
vmscan-remove-may_swap-scan-control.patch

