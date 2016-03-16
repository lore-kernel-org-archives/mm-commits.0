From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:13 -0700
Message-ID: <56e9ba99.B9sxCEUkM5ATpu3c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499AbcCPT5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aaron.lu@intel.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix invalid free_pfn and compact_cached_free_pfn
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: fix invalid free_pfn and compact_cached_free_pfn

free_pfn and compact_cached_free_pfn are the pointer that remember restart
position of freepage scanner.  When they are reset or invalid, we set them
to zone_end_pfn because freepage scanner works in reverse direction.  But,
because zone range is defined as [zone_start_pfn, zone_end_pfn),
zone_end_pfn is invalid to access.  Therefore, we should not store it to
free_pfn and compact_cached_free_pfn.  Instead, we need to store
zone_end_pfn - 1 to them.  There is one more thing we should consider. 
Freepage scanner scan reversely by pageblock unit.  If free_pfn and
compact_cached_free_pfn are set to middle of pageblock, it regards that
sitiation as that it already scans front part of pageblock so we lose
opportunity to scan there.  To fix-up, this patch do round_down() to
guarantee that reset position will be pageblock aligned.

Note that thanks to the current pageblock_pfn_to_page() implementation,
actual access to zone_end_pfn doesn't happen until now.  But, following
patch will change pageblock_pfn_to_page() so this patch is needed from now
on.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn
+++ a/mm/compaction.c
@@ -200,7 +200,8 @@ static void reset_cached_positions(struc
 {
 	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
 	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
-	zone->compact_cached_free_pfn = zone_end_pfn(zone);
+	zone->compact_cached_free_pfn =
+			round_down(zone_end_pfn(zone) - 1, pageblock_nr_pages);
 }
 
 /*
@@ -1371,11 +1372,11 @@ static int compact_zone(struct zone *zon
 	 */
 	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
-	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
-		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
+	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
+		cc->free_pfn = round_down(end_pfn - 1, pageblock_nr_pages);
 		zone->compact_cached_free_pfn = cc->free_pfn;
 	}
-	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn > end_pfn) {
+	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn >= end_pfn) {
 		cc->migrate_pfn = start_pfn;
 		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

