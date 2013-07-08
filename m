From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:00 -0700
Message-ID: <51db120c.ckYv8dz6B7hjE3U8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3GHTZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:00 -0700


The patch titled
     Subject: mm: vmscan: treat pages marked for immediate reclaim as zone congestion
has been removed from the -mm tree.  Its filename was
     mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: treat pages marked for immediate reclaim as zone congestion

Currently a zone will only be marked congested if the underlying BDI is
congested but if dirty pages are spread across zones it is possible that
an individual zone is full of dirty pages without being congested.  The
impact is that zone gets scanned very quickly potentially reclaiming
really clean pages.  This patch treats pages marked for immediate reclaim
as congested for the purposes of marking a zone ZONE_CONGESTED and
stalling in wait_iff_congested.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion
+++ a/mm/vmscan.c
@@ -761,9 +761,15 @@ static unsigned long shrink_page_list(st
 		if (dirty && !writeback)
 			nr_unqueued_dirty++;
 
-		/* Treat this page as congested if underlying BDI is */
+		/*
+		 * Treat this page as congested if the underlying BDI is or if
+		 * pages are cycling through the LRU so quickly that the
+		 * pages marked for immediate reclaim are making it to the
+		 * end of the LRU a second time.
+		 */
 		mapping = page_mapping(page);
-		if (mapping && bdi_write_congested(mapping->backing_dev_info))
+		if ((mapping && bdi_write_congested(mapping->backing_dev_info)) ||
+		    (writeback && PageReclaim(page)))
 			nr_congested++;
 
 		/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

