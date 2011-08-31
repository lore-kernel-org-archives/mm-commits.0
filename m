From: akpm@linux-foundation.org
Subject: + mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update.patch added to -mm tree
Date: Wed, 31 Aug 2011 16:14:54 -0700
Message-ID: <201108312314.p7VNEsrZ000903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab1HaXP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 19:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update
has been added to the -mm tree.  Its filename is
     mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update.patch

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
Subject: mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update
From: Mel Gorman <mgorman@suse.de>

This patch expands on a comment on how we throttle from reclaim context. 
It should be merged with
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update
+++ a/mm/vmscan.c
@@ -1548,11 +1548,27 @@ shrink_inactive_list(unsigned long nr_to
 	putback_lru_pages(zone, sc, nr_anon, nr_file, &page_list);
 
 	/*
-	 * If we have encountered a high number of dirty pages under writeback
-	 * then we are reaching the end of the LRU too quickly and global
-	 * limits are not enough to throttle processes due to the page
-	 * distribution throughout zones. Scale the number of dirty pages that
-	 * must be under writeback before being throttled to priority.
+	 * If reclaim is isolating dirty pages under writeback, it implies
+	 * that the long-lived page allocation rate is exceeding the page
+	 * laundering rate. Either the global limits are not being effective
+	 * at throttling processes due to the page distribution throughout
+	 * zones or there is heavy usage of a slow backing device. The
+	 * only option is to throttle from reclaim context which is not ideal
+	 * as there is no guarantee the dirtying process is throttled in the
+	 * same way balance_dirty_pages() manages.
+	 *
+	 * This scales the number of dirty pages that must be under writeback
+	 * before throttling depending on priority. It is a simple backoff
+	 * function that has the most effect in the range DEF_PRIORITY to
+	 * DEF_PRIORITY-2 which is the priority reclaim is considered to be
+	 * in trouble and reclaim is considered to be in trouble.
+	 *
+	 * DEF_PRIORITY   100% isolated pages must be PageWriteback to throttle
+	 * DEF_PRIORITY-1  50% must be PageWriteback
+	 * DEF_PRIORITY-2  25% must be PageWriteback, kswapd in trouble
+	 * ...
+	 * DEF_PRIORITY-6 For SWAP_CLUSTER_MAX isolated pages, throttle if any
+	 *                     isolated page is PageWriteback
 	 */
 	if (nr_writeback && nr_writeback >= (nr_taken >> (DEF_PRIORITY-priority)))
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch

