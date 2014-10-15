From: akpm@linux-foundation.org
Subject: + mm-compaction-always-update-cached-scanner-positions.patch
 added to -mm tree
Date: Wed, 15 Oct 2014 13:50:10 -0700
Message-ID: <543ede02.51M0nUhErWjKArk0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaJOUuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: always update cached scanner positions
has been added to the -mm tree.  Its filename is
     mm-compaction-always-update-cached-scanner-positions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-always-update-cached-scanner-positions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-always-update-cached-scanner-positions.patch

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
Subject: mm, compaction: always update cached scanner positions

Compaction caches the migration and free scanner positions between
compaction invocations, so that the whole zone gets eventually scanned and
there is no bias towards the initial scanner positions at the
beginning/end of the zone.

The cached positions are continuously updated as scanners progress and the
updating stops as soon as a page is successfully isolated.  The reasoning
behind this is that a pageblock where isolation succeeded is likely to
succeed again in near future and it should be worth revisiting it.

However, the downside is that potentially many pages are rescanned without
successful isolation.  At worst, there might be a page where isolation
from LRU succeeds but migration fails (potentially always).  So upon
encountering this page, cached position would always stop being updated
for no good reason.  It might have been useful to let such page be
rescanned with sync compaction after async one failed, but this is now
handled by caching scanner position for async and sync mode separately
since commit 35979ef33931 ("mm, compaction: add per-zone migration pfn
cache for async compaction").

After this patch, cached positions are updated unconditionally.  In
stress-highalloc benchmark, this has decreased the numbers of scanned
pages by few percent, without affecting allocation success rates.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 --------------
 mm/internal.h   |    5 -----
 2 files changed, 19 deletions(-)

diff -puN mm/compaction.c~mm-compaction-always-update-cached-scanner-positions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-always-update-cached-scanner-positions
+++ a/mm/compaction.c
@@ -195,16 +195,12 @@ static void update_pageblock_skip(struct
 
 	/* Update where async and sync compaction should restart */
 	if (migrate_scanner) {
-		if (cc->finished_update_migrate)
-			return;
 		if (pfn > zone->compact_cached_migrate_pfn[0])
 			zone->compact_cached_migrate_pfn[0] = pfn;
 		if (cc->mode != MIGRATE_ASYNC &&
 		    pfn > zone->compact_cached_migrate_pfn[1])
 			zone->compact_cached_migrate_pfn[1] = pfn;
 	} else {
-		if (cc->finished_update_free)
-			return;
 		if (pfn < zone->compact_cached_free_pfn)
 			zone->compact_cached_free_pfn = pfn;
 	}
@@ -705,7 +701,6 @@ isolate_migratepages_block(struct compac
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 
 isolate_success:
-		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
@@ -879,15 +874,6 @@ static void isolate_freepages(struct com
 				block_start_pfn - pageblock_nr_pages;
 
 		/*
-		 * Set a flag that we successfully isolated in this pageblock.
-		 * In the next loop iteration, zone->compact_cached_free_pfn
-		 * will not be updated and thus it will effectively contain the
-		 * highest pageblock we isolated pages from.
-		 */
-		if (isolated)
-			cc->finished_update_free = true;
-
-		/*
 		 * isolate_freepages_block() might have aborted due to async
 		 * compaction being contended
 		 */
diff -puN mm/internal.h~mm-compaction-always-update-cached-scanner-positions mm/internal.h
--- a/mm/internal.h~mm-compaction-always-update-cached-scanner-positions
+++ a/mm/internal.h
@@ -136,11 +136,6 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
-	bool finished_update_free;	/* True when the zone cached pfns are
-					 * no longer being updated
-					 */
-	bool finished_update_migrate;
