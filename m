From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-avoid-excessive-compaction-latency-during-fault.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:51:49 -0700
Message-ID: <5390ca55.GifliDPZ5Xlo8DSk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaFETvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, hughd@google.com, gthelen@google.com, rientjes@google.com

Subject: [merged] mm-thp-avoid-excessive-compaction-latency-during-fault.patch removed from -mm tree
To: rientjes@google.com,gthelen@google.com,hughd@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:49 -0700


The patch titled
     Subject: mm, thp: avoid excessive compaction latency during fault
has been removed from the -mm tree.  Its filename was
     mm-thp-avoid-excessive-compaction-latency-during-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: avoid excessive compaction latency during fault

Synchronous memory compaction can be very expensive: it can iterate an
enormous amount of memory without aborting, constantly rescheduling,
waiting on page locks and lru_lock, etc, if a pageblock cannot be
defragmented.

Unfortunately, it's too expensive for transparent hugepage page faults and
it's much better to simply fallback to pages.  On 128GB machines, we find
that synchronous memory compaction can take O(seconds) for a single thp
fault.

Now that async compaction remembers where it left off without strictly
relying on sync compaction, this makes thp allocations best-effort without
causing egregious latency during fault.  We still need to retry async
compaction after reclaim, but this won't stall for seconds.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault mm/page_alloc.c
--- a/mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault
+++ a/mm/page_alloc.c
@@ -2575,7 +2575,14 @@ rebalance:
 					&did_some_progress);
 	if (page)
 		goto got_pg;
-	migration_mode = MIGRATE_SYNC_LIGHT;
+
+	/*
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

