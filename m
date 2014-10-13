From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:33 -0700
Message-ID: <543c17b5.30BCxbjgYuLW0Wmm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaJMSTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: do not recheck suitable_migration_target under lock
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: do not recheck suitable_migration_target under lock

isolate_freepages_block() rechecks if the pageblock is suitable to be a
target for migration after it has taken the zone->lock.  However, the
check has been optimized to occur only once per pageblock, and
compact_checklock_irqsave() might be dropping and reacquiring lock, which
means somebody else might have changed the pageblock's migratetype
meanwhile.

Furthermore, nothing prevents the migratetype to change right after
isolate_freepages_block() has finished isolating.  Given how imperfect
this is, it's simpler to just rely on the check done in
isolate_freepages() without lock, and not pretend that the recheck under
lock guarantees anything.  It is just a heuristic after all.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN mm/compaction.c~mm-compaction-do-not-recheck-suitable_migration_target-under-lock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-recheck-suitable_migration_target-under-lock
+++ a/mm/compaction.c
@@ -276,7 +276,6 @@ static unsigned long isolate_freepages_b
 	struct page *cursor, *valid_page = NULL;
 	unsigned long flags;
 	bool locked = false;
-	bool checked_pageblock = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -307,18 +306,6 @@ static unsigned long isolate_freepages_b
 		if (!locked)
 			break;
 
-		/* Recheck this is a suitable migration target under lock */
-		if (!strict && !checked_pageblock) {
-			/*
-			 * We need to check suitability of pageblock only once
-			 * and this isolate_freepages_block() is called with
-			 * pageblock range, so just check once is sufficient.
-			 */
-			checked_pageblock = true;
-			if (!suitable_migration_target(page))
-				break;
-		}
