From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-reset-compaction-scanner-positions.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:44 -0700
Message-ID: <552fe8a0.+6KlAtLwpRM1PCS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbDPQqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gioh.kim@lge.com, iamjoonsoo.kim@lge.com, mel@csn.ul.ie, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: reset compaction scanner positions
has been removed from the -mm tree.  Its filename was
     mm-compaction-reset-compaction-scanner-positions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gioh Kim <gioh.kim@lge.com>
Subject: mm/compaction: reset compaction scanner positions

When the compaction is activated via /proc/sys/vm/compact_memory it would
better scan the whole zone.  And some platforms, for instance ARM, have
the start_pfn of a zone at zero.  Therefore the first try to compact via
/proc doesn't work.  It needs to reset the compaction scanner position
first.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/compaction.c~mm-compaction-reset-compaction-scanner-positions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-reset-compaction-scanner-positions
+++ a/mm/compaction.c
@@ -1605,6 +1605,14 @@ static void __compact_pgdat(pg_data_t *p
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
+		/*
+		 * When called via /proc/sys/vm/compact_memory
+		 * this makes sure we compact the whole zone regardless of
+		 * cached scanner positions.
+		 */
+		if (cc->order == -1)
+			__reset_isolation_suitable(zone);
+
 		if (cc->order == -1 || !compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
_

Patches currently in -mm which might be from gioh.kim@lge.com are

origin.patch

