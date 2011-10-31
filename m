From: akpm@linux-foundation.org
Subject: [folded] mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:40:28 -0700
Message-ID: <201110312340.p9VNeSLJ032666@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1JaXkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-isolate-mode-from-define-to-bitwise-type-fix
has been removed from the -mm tree.  Its filename was
     mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch

This patch was dropped because it was folded into mm-change-isolate-mode-from-define-to-bitwise-type.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm-change-isolate-mode-from-define-to-bitwise-type-fix

[c1e8b0ae8, mm-change-isolate-mode-from-define-to-bitwise-type]
made a mistake on the bitwise type.

This patch corrects it.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-change-isolate-mode-from-define-to-bitwise-type-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-change-isolate-mode-from-define-to-bitwise-type-fix
+++ a/include/linux/mmzone.h
@@ -165,9 +165,9 @@ static inline int is_unevictable_lru(enu
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate inactive pages */
-#define ISOLATE_INACTIVE	((__force fmode_t)0x1)
+#define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
 /* Isolate active pages */
-#define ISOLATE_ACTIVE		((__force fmode_t)0x2)
+#define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
vmscan-add-block-plug-for-page-reclaim.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch
mm-compaction-make-compact_zone_order-static.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch
mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch

