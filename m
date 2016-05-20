From: akpm@linux-foundation.org
Subject: [patch 101/117] mm, page_alloc: check once if a zone has isolated pageblocks
Date: Thu, 19 May 2016 17:13:58 -0700
Message-ID: <573e56c6.WfQYldv2hJT+iw16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETAOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: check once if a zone has isolated pageblocks

When bulk freeing pages from the per-cpu lists the zone is checked for
isolated pageblocks on every release.  This patch checks it once per
drain.

[mgorman@techsingularity.net: fix locking radce, per Vlastimil]
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks
+++ a/mm/page_alloc.c
@@ -831,8 +831,10 @@ static void free_pcppages_bulk(struct zo
 	int batch_free = 0;
 	int to_free = count;
 	unsigned long nr_scanned;
+	bool isolated_pageblocks;
 
 	spin_lock(&zone->lock);
+	isolated_pageblocks = has_isolate_pageblock(zone);
 	nr_scanned = zone_page_state(zone, NR_PAGES_SCANNED);
 	if (nr_scanned)
 		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
@@ -870,7 +872,7 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_ISOLATE page should not go to pcplists */
 			VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
 			/* Pageblock could have been isolated meanwhile */
-			if (unlikely(has_isolate_pageblock(zone)))
+			if (unlikely(isolated_pageblocks))
 				mt = get_pageblock_migratetype(page);
 
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
_
