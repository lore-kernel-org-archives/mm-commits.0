From: akpm@linux-foundation.org
Subject: + mm-vmscan-correctly-check-if-reclaimer-should-schedule-during-shrink_slab.patch added to -mm tree
Date: Mon, 23 May 2011 13:00:00 -0700
Message-ID: <201105232000.p4NK00DI008698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933645Ab1EWUAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 May 2011 16:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, James.Bottomley@HansenPartnership.com, chris.mason@oracle.com, cl@linux.com, colin.king@canonical.com, fengguang.wu@intel.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penberg@kernel.org, raghu.prabhu13@gmail.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: vmscan: correctly check if reclaimer should schedule during shrink_slab
has been added to the -mm tree.  Its filename is
     mm-vmscan-correctly-check-if-reclaimer-should-schedule-during-shrink_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: correctly check if reclaimer should schedule during shrink_slab
From: Minchan Kim <minchan.kim@gmail.com>

It has been reported on some laptops that kswapd is consuming large
amounts of CPU and not being scheduled when SLUB is enabled during large
amounts of file copying.  It is expected that this is due to kswapd
missing every cond_resched() point because;

shrink_page_list() calls cond_resched() if inactive pages were isolated
        which in turn may not happen if all_unreclaimable is set in
        shrink_zones(). If for whatver reason, all_unreclaimable is
        set on all zones, we can miss calling cond_resched().

balance_pgdat() only calls cond_resched if the zones are not
        balanced. For a high-order allocation that is balanced, it
        checks order-0 again. During that window, order-0 might have
        become unbalanced so it loops again for order-0 and returns
        that it was reclaiming for order-0 to kswapd(). It can then
        find that a caller has rewoken kswapd for a high-order and
        re-enters balance_pgdat() without ever calling cond_resched().

shrink_slab only calls cond_resched() if we are reclaiming slab
	pages. If there are a large number of direct reclaimers, the
	shrinker_rwsem can be contended and prevent kswapd calling
	cond_resched().

This patch modifies the shrink_slab() case.  If the semaphore is
contended, the caller will still check cond_resched().  After each
successful call into a shrinker, the check for cond_resched() remains in
case one shrinker is particularly slow.

[mgorman@suse.de: Preserve call to cond_resched after each call into shrinker]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Colin King <colin.king@canonical.com>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@kernel.org>		[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-correctly-check-if-reclaimer-should-schedule-during-shrink_slab mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-correctly-check-if-reclaimer-should-schedule-during-shrink_slab
+++ a/mm/vmscan.c
@@ -231,8 +231,11 @@ unsigned long shrink_slab(unsigned long 
 	if (scanned == 0)
 		scanned = SWAP_CLUSTER_MAX;
 
-	if (!down_read_trylock(&shrinker_rwsem))
-		return 1;	/* Assume we'll be able to shrink next time */
+	if (!down_read_trylock(&shrinker_rwsem)) {
+		/* Assume we'll be able to shrink next time */
+		ret = 1;
+		goto out;
+	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
@@ -283,6 +286,8 @@ unsigned long shrink_slab(unsigned long 
 		shrinker->nr += total_scan;
 	}
 	up_read(&shrinker_rwsem);
+out:
+	cond_resched();
 	return ret;
 }
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch
mm-vmscan-correctly-check-if-reclaimer-should-schedule-during-shrink_slab.patch
linux-next.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
writeback-elevate-queue_io-into-wb_writeback.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix-2.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch

