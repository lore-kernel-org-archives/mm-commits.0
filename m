From: akpm@linux-foundation.org
Subject: [folded] vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:04:13 -0700
Message-ID: <200906162204.n5GM4Dd6000507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbZFPWFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
has been removed from the -mm tree.  Its filename was
     vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch

This patch was dropped because it was folded into vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
From: Andrew Morton <akpm@linux-foundation.org>

name things consistently.

Cc: <stable@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 mm/vmscan.c            |    2 +-
 mm/vmstat.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
+++ a/include/linux/vmstat.h
@@ -37,7 +37,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 #ifdef CONFIG_NUMA
-		PGSCAN_ZONERECLAIM_FAILED,
+		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
diff -puN mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
+++ a/mm/vmscan.c
@@ -2520,7 +2520,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
 	if (!ret)
-		count_vm_event(PGSCAN_ZONERECLAIM_FAILED);
+		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
 
 	return ret;
 }
diff -puN mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix mm/vmstat.c
--- a/mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix
+++ a/mm/vmstat.c
@@ -674,7 +674,7 @@ static const char * const vmstat_text[] 
 	TEXTS_FOR_ZONES("pgscan_direct")
 
 #ifdef CONFIG_NUMA
-	"zreclaim_failed",
+	"zone_reclaim_failed",
 #endif
 	"pginodesteal",
 	"slabs_scanned",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

