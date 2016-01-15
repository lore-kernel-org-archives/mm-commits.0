From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:33:32 -0800
Message-ID: <569973bc.5b0BYQCgGtkWFK5c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcAOWdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: consider isolated pages in zone_reclaimable_pages
has been removed from the -mm tree.  Its filename was
     mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: consider isolated pages in zone_reclaimable_pages

zone_reclaimable_pages counts how many pages are reclaimable in the given
zone.  This currently includes all pages on file lrus and anon lrus if
there is an available swap storage.  We do not consider
NR_ISOLATED_{ANON,FILE} counters though which is not correct because these
counters reflect temporarily isolated pages which are still reclaimable
because they either get back to their LRU or get freed either by the page
reclaim or page migration.

The number of these pages might be sufficiently high to confuse users of
zone_reclaimable_pages (e.g.  mbind can migrate large ranges of memory at
once).

Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages
+++ a/mm/vmscan.c
@@ -197,11 +197,13 @@ static unsigned long zone_reclaimable_pa
 	unsigned long nr;
 
 	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
-	     zone_page_state(zone, NR_INACTIVE_FILE);
+	     zone_page_state(zone, NR_INACTIVE_FILE) +
+	     zone_page_state(zone, NR_ISOLATED_FILE);
 
 	if (get_nr_swap_pages() > 0)
 		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON);
+		      zone_page_state(zone, NR_INACTIVE_ANON) +
+		      zone_page_state(zone, NR_ISOLATED_ANON);
 
 	return nr;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

