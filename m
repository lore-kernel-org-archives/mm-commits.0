From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch added to -mm tree
Date: Wed, 26 Jun 2013 12:44:14 -0700
Message-ID: <51cb448e.0uwp8xLZ4z2hXTpc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3FZToP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 15:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, david@fromorbit.com, mgorman@suse.de

Subject: + mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch added to -mm tree
To: mgorman@suse.de,david@fromorbit.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 12:44:14 -0700


The patch titled
     Subject: mm: vmscan: do not scale writeback pages when deciding whether to set ZONE_WRITEBACK
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not scale writeback pages when deciding whether to set ZONE_WRITEBACK

After the patch "mm: vmscan: Flatten kswapd priority loop" was merged the
scanning priority of kswapd changed.  The priority now raises until it is
scanning enough pages to meet the high watermark.  shrink_inactive_list
sets ZONE_WRITEBACK if a number of pages were encountered under writeback
but this value is scaled based on the priority.  As kswapd frequently
scans with a higher priority now it is relatively easy to set
ZONE_WRITEBACK.  This patch removes the scaling and treates writeback
pages similar to how it treats unqueued dirty pages and congested pages. 
The user-visible effect should be that kswapd will writeback fewer pages
from reclaim context.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback
+++ a/mm/vmscan.c
@@ -1477,25 +1477,11 @@ shrink_inactive_list(unsigned long nr_to
 	 * as there is no guarantee the dirtying process is throttled in the
 	 * same way balance_dirty_pages() manages.
 	 *
-	 * This scales the number of dirty pages that must be under writeback
-	 * before a zone gets flagged ZONE_WRITEBACK. It is a simple backoff
-	 * function that has the most effect in the range DEF_PRIORITY to
-	 * DEF_PRIORITY-2 which is the priority reclaim is considered to be
-	 * in trouble and reclaim is considered to be in trouble.
-	 *
-	 * DEF_PRIORITY   100% isolated pages must be PageWriteback to throttle
-	 * DEF_PRIORITY-1  50% must be PageWriteback
-	 * DEF_PRIORITY-2  25% must be PageWriteback, kswapd in trouble
-	 * ...
-	 * DEF_PRIORITY-6 For SWAP_CLUSTER_MAX isolated pages, throttle if any
-	 *                     isolated page is PageWriteback
-	 *
 	 * Once a zone is flagged ZONE_WRITEBACK, kswapd will count the number
 	 * of pages under pages flagged for immediate reclaim and stall if any
 	 * are encountered in the nr_immediate check below.
 	 */
-	if (nr_writeback && nr_writeback >=
-			(nr_taken >> (DEF_PRIORITY - sc->priority)))
+	if (nr_writeback && nr_writeback == nr_taken)
 		zone_set_flag(zone, ZONE_WRITEBACK);
 
 	/*
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch
mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch
documentation-update-address_space_operations.patch
documentation-document-the-is_dirty_writeback-aops-callback.patch
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
mm-vmscan-avoid-direct-reclaim-scanning-at-maximum-priority.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

