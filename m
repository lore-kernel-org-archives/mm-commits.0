From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-the-range-check-for-backward-merging.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:42 -0800
Message-ID: <201001212127.o0LLRgBN030662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab0AUV2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ki@epsilou.com, cl@linux-foundation.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc: fix the range check for backward merging
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-the-range-check-for-backward-merging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc: fix the range check for backward merging
From: Kazuhisa Ichikawa <ki@epsilou.com>

The current check for 'backward merging' within add_active_range() does
not seem correct.  start_pfn must be compared against
early_node_map[i].start_pfn (and NOT against .end_pfn) to find out whether
the new region is backward-mergeable with the existing range.

Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-the-range-check-for-backward-merging mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-the-range-check-for-backward-merging
+++ a/mm/page_alloc.c
@@ -3998,7 +3998,7 @@ void __init add_active_range(unsigned in
 		}
 
 		/* Merge backward if suitable */
-		if (start_pfn < early_node_map[i].end_pfn &&
+		if (start_pfn < early_node_map[i].start_pfn &&
 				end_pfn >= early_node_map[i].start_pfn) {
 			early_node_map[i].start_pfn = start_pfn;
 			return;
_

Patches currently in -mm which might be from ki@epsilou.com are

origin.patch

