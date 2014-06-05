From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-terminate-async-compaction-when-rescheduling.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:51:51 -0700
Message-ID: <5390ca57.Tlty78U2AjBFEdhs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaFETvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@suse.de, rientjes@google.com

Subject: [merged] mm-compaction-terminate-async-compaction-when-rescheduling.patch removed from -mm tree
To: rientjes@google.com,mgorman@suse.de,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:51 -0700


The patch titled
     Subject: mm, compaction: terminate async compaction when rescheduling
has been removed from the -mm tree.  Its filename was
     mm-compaction-terminate-async-compaction-when-rescheduling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: terminate async compaction when rescheduling

Async compaction terminates prematurely when need_resched(), see
compact_checklock_irqsave().  This can never trigger, however, if the
cond_resched() in isolate_migratepages_range() always takes care of the
scheduling.

If the cond_resched() actually triggers, then terminate this pageblock
scan for async compaction as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-terminate-async-compaction-when-rescheduling mm/compaction.c
--- a/mm/compaction.c~mm-compaction-terminate-async-compaction-when-rescheduling
+++ a/mm/compaction.c
@@ -494,8 +494,13 @@ isolate_migratepages_range(struct zone *
 			return 0;
 	}
 
+	if (cond_resched()) {
+		/* Async terminates prematurely on need_resched() */
+		if (cc->mode == MIGRATE_ASYNC)
+			return 0;
+	}
+
 	/* Time to isolate some pages for migration */
-	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
 		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

