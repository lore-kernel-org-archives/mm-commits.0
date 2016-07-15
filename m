From: akpm@linux-foundation.org
Subject: + mm-show-node_pages_scanned-per-node-not-zone.patch added to -mm tree
Date: Fri, 15 Jul 2016 13:36:58 -0700
Message-ID: <5789496a.BLumYzLpIKr3wv67%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbcGOUg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 16:36:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: show node_pages_scanned per node, not zone
has been added to the -mm tree.  Its filename is
     mm-show-node_pages_scanned-per-node-not-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-show-node_pages_scanned-per-node-not-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-show-node_pages_scanned-per-node-not-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: show node_pages_scanned per node, not zone

The node_pages_scanned represents the number of scanned pages of node for
reclaim so it's pointless to show it as kilobytes.

As well, node_pages_scanned is per-node value, not per-zone.

This patch changes node_pages_scanned per-zone-killobytes
with per-node-count.

Link: http://lkml.kernel.org/r/1468588165-12461-5-git-send-email-mgorman@techsingularity.net
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone
+++ a/mm/page_alloc.c
@@ -4313,6 +4313,7 @@ void show_free_areas(unsigned int filter
 #endif
 			" writeback_tmp:%lukB"
 			" unstable:%lukB"
+			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -4335,6 +4336,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
+			node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED),
 			!pgdat_reclaimable(pgdat) ? "yes" : "no");
 	}
 
@@ -4365,7 +4367,6 @@ void show_free_areas(unsigned int filter
 			" free_pcp:%lukB"
 			" local_pcp:%ukB"
 			" free_cma:%lukB"
-			" node_pages_scanned:%lu"
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
@@ -4383,8 +4384,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
 			K(this_cpu_read(zone->pageset->pcp.count)),
-			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
-			K(node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED)));
+			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
 			printk(" %ld", zone->lowmem_reserve[i]);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix.patch
zsmalloc-page-migration-support-fix-2.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch
mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch

