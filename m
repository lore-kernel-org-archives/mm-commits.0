From: akpm@linux-foundation.org
Subject: + mm-bail-out-in-shrin_inactive_list.patch added to -mm tree
Date: Mon, 25 Jul 2016 16:27:02 -0700
Message-ID: <5796a046.ZbZXHmFgOF9pGEqq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbcGYX1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 19:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bail out in shrink_inactive_list()
has been added to the -mm tree.  Its filename is
     mm-bail-out-in-shrin_inactive_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bail-out-in-shrin_inactive_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bail-out-in-shrin_inactive_list.patch

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
Subject: mm: bail out in shrink_inactive_list()

With node-lru, if there are enough reclaimable pages in highmem
but nothing in lowmem, VM can try to shrink inactive list although
the requested zone is lowmem.

The problem is that if the inactive list is full of highmem pages then a
direct reclaimer searching for a lowmem page waste CPU scanning uselessly.
It just burns out CPU.  Even, many direct reclaimers are stalled by
too_many_isolated if lots of parallel reclaimer are going on although
there are no reclaimable memory in inactive list.

I tried the experiment 4 times in 32bit 2G 8 CPU KVM machine to get
elapsed time.

	hackbench 500 process 2

= Old =

1st: 289s 2nd: 310s 3rd: 112s 4th: 272s

= Now =

1st: 31s  2nd: 132s 3rd: 162s 4th: 50s.

Link: http://lkml.kernel.org/r/1469433119-1543-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN mm/vmscan.c~mm-bail-out-in-shrin_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~mm-bail-out-in-shrin_inactive_list
+++ a/mm/vmscan.c
@@ -1652,6 +1652,31 @@ static int current_may_throttle(void)
 		bdi_write_congested(current->backing_dev_info);
 }
 
+static inline bool inactive_reclaimable_pages(struct lruvec *lruvec,
+				struct scan_control *sc,
+				enum lru_list lru)
+{
+	int zid;
+	struct zone *zone;
+	bool file = is_file_lru(lru);
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	if (!global_reclaim(sc))
+		return true;
+
+	for (zid = sc->reclaim_idx; zid >= 0; zid--) {
+		zone = &pgdat->node_zones[zid];
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_page_state_snapshot(zone, NR_ZONE_LRU_BASE +
+				LRU_FILE * file) >= SWAP_CLUSTER_MAX)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
@@ -1674,6 +1699,9 @@ shrink_inactive_list(unsigned long nr_to
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
+	if (!inactive_reclaimable_pages(lruvec, sc, lru))
+		return 0;
+
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
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
mm-show-node_pages_scanned-per-node-not-zone-fix.patch
mm-add-per-zone-lru-list-stat.patch
mm-bail-out-in-shrin_inactive_list.patch

