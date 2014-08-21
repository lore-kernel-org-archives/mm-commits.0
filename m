From: akpm@linux-foundation.org
Subject: +
 mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
 added to -mm tree
Date: Thu, 21 Aug 2014 15:21:57 -0700
Message-ID: <53f67105.Jr3EhhOWh17mfLvX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:47192 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaHUWV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:21:58 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2696770pde.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:21:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: do not recheck suitable_migration_target under lock
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
