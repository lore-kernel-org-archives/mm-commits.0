From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-always-update-cached-scanner-positions-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:15:25 -0800
Message-ID: <5488d40d.oPy3EQmLSMPRDEvV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbaLJXP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm-compaction-always-update-cached-scanner-positions-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-always-update-cached-scanner-positions-fix.patch

This patch was dropped because it was folded into mm-compaction-always-update-cached-scanner-positions.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] mm-compaction-always-update-cached-scanner-positions-fix

This patch-fix addresses Joonsoo Kim's concerns about free pages
potentially being skipped when they are isolated and then returned due to
migration failure.  It does so by setting the cached scanner pfn to the
pageblock where where the free page with the highest pfn of all returned
free pages resides.  A small downside is that release_freepages() no
longer returns the number of freed pages, which has been used in a
VM_BUG_ON check.  I don't think the check was important enough to warrant
a more complex solution.

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

 mm/compaction.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-always-update-cached-scanner-positions-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-always-update-cached-scanner-positions-fix
+++ a/mm/compaction.c
@@ -41,15 +41,17 @@ static inline void count_compact_events(
 static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
-	unsigned long count = 0;
+	unsigned long high_pfn = 0;
 
 	list_for_each_entry_safe(page, next, freelist, lru) {
+		unsigned long pfn = page_to_pfn(page);
 		list_del(&page->lru);
 		__free_page(page);
-		count++;
+		if (pfn > high_pfn)
+			high_pfn = pfn;
 	}
 
-	return count;
+	return high_pfn;
 }
 
 static void map_pages(struct list_head *list)
@@ -1237,9 +1239,24 @@ static int compact_zone(struct zone *zon
 	}
 
 out:
-	/* Release free pages and check accounting */
-	cc->nr_freepages -= release_freepages(&cc->freepages);
-	VM_BUG_ON(cc->nr_freepages != 0);
+	/*
+	 * Release free pages and update where the free scanner should restart,
+	 * so we don't leave any returned pages behind in the next attempt.
+	 */
+	if (cc->nr_freepages > 0) {
+		unsigned long free_pfn = release_freepages(&cc->freepages);
+		cc->nr_freepages = 0;
+
+		VM_BUG_ON(free_pfn == 0);
+		/* The cached pfn is always the first in a pageblock */
+		free_pfn &= ~(pageblock_nr_pages-1);
+		/*
+		 * Only go back, not forward. The cached pfn might have been
+		 * already reset to zone end in compact_finished()
+		 */
+		if (free_pfn > zone->compact_cached_free_pfn)
+			zone->compact_cached_free_pfn = free_pfn;
+	}
 
 	trace_mm_compaction_end(ret);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch

