From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:26:13 -0700
Message-ID: <51d496f5.b8RHl0Whcjiy8Nw3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3GCV0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [folded-merged] mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:26:13 -0700


The patch titled
     Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch

This patch was dropped because it was folded into mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix

Historically, kswapd used to congestion_wait() at higher priorities if it
was not making forward progress. This made no sense as the failure to make
progress could be completely independent of IO. It was later replaced by
wait_iff_congested() and removed entirely by commit 258401a6 (mm: don't
wait on congested zones in balance_pgdat()) as it was duplicating logic
in shrink_inactive_list().

This is problematic. If kswapd encounters many pages under writeback and
it continues to scan until it reaches the high watermark then it will
quickly skip over the pages under writeback and reclaim clean young
pages or push applications out to swap.

The use of wait_iff_congested() is not suited to kswapd as it will only
stall if the underlying BDI is really congested or a direct reclaimer was
unable to write to the underlying BDI. kswapd bypasses the BDI congestion
as it sets PF_SWAPWRITE but even if this was taken into account then it
would cause direct reclaimers to stall on writeback which is not desirable.

This patch sets a ZONE_WRITEBACK flag if direct reclaim or kswapd is
encountering too many pages under writeback. If this flag is set and
kswapd encounters a PageReclaim page under writeback then it'll assume
that the LRU lists are being recycled too quickly before IO can complete
and block waiting for some IO to complete.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix
+++ a/mm/vmscan.c
@@ -732,9 +732,11 @@ static unsigned long shrink_page_list(st
 		 *    under writeback and this page is both under writeback and
 		 *    PageReclaim then it indicates that pages are being queued
 		 *    for IO but are being recycled through the LRU before the
-		 *    IO can complete. In this case, wait on the IO to complete
-		 *    and then clear the ZONE_WRITEBACK flag to recheck if the
-		 *    condition exists.
+		 *    IO can complete. Waiting on the page itself risks an
+		 *    indefinite stall if it is impossible to writeback the
+		 *    page due to IO error or disconnected storage so instead
+		 *    block for HZ/10 or until some IO completes then clear the
+		 *    ZONE_WRITEBACK flag to recheck if the condition exists.
 		 *
 		 * 2) Global reclaim encounters a page, memcg encounters a
 		 *    page that is not marked for immediate reclaim or
@@ -764,7 +766,7 @@ static unsigned long shrink_page_list(st
 			if (current_is_kswapd() &&
 			    PageReclaim(page) &&
 			    zone_is_reclaim_writeback(zone)) {
-				wait_on_page_writeback(page);
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
 				zone_clear_flag(zone, ZONE_WRITEBACK);
 
 			/* Case 2 above */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
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

