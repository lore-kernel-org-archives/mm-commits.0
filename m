From: akpm@linux-foundation.org
Subject: [merged] vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:58 -0700
Message-ID: <200906171834.n5HIYwEE000946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535AbZFQSfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: don't export nr_saved_scan in /proc/zoneinfo
has been removed from the -mm tree.  Its filename was
     vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: don't export nr_saved_scan in /proc/zoneinfo
From: Wu Fengguang <fengguang.wu@intel.com>

The lru->nr_saved_scan's are not meaningful counters for even kernel
developers.  They typically are smaller than 32 and are always 0 for large
lists.  So remove them from /proc/zoneinfo.

Hopefully this interface change won't break too many scripts. 
/proc/zoneinfo is too unstructured to be script friendly, and I wonder the
affected scripts - if there are any - are still bleeding since the not
long ago commit "vmscan: split LRU lists into anon & file sets", which
also touched the "scanned" line :)

If we are to re-export accumulated vmscan counts in the future, they can
go to new lines in /proc/zoneinfo instead of the current form, or to
/sys/devices/system/node/node0/meminfo?

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN mm/vmstat.c~vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo mm/vmstat.c
--- a/mm/vmstat.c~vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo
+++ a/mm/vmstat.c
@@ -710,7 +710,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
-		   "\n        scanned  %lu (aa: %lu ia: %lu af: %lu if: %lu)"
+		   "\n        scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
@@ -718,10 +718,6 @@ static void zoneinfo_show_print(struct s
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->pages_scanned,
-		   zone->lru[LRU_ACTIVE_ANON].nr_saved_scan,
-		   zone->lru[LRU_INACTIVE_ANON].nr_saved_scan,
-		   zone->lru[LRU_ACTIVE_FILE].nr_saved_scan,
-		   zone->lru[LRU_INACTIVE_FILE].nr_saved_scan,
 		   zone->spanned_pages,
 		   zone->present_pages);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

