From: akpm@linux-foundation.org
Subject: [folded] mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:45:13 -0800
Message-ID: <20120110224513.D3B781E0190@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:60094 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:45:15 -0500
Received: by ggnk3 with SMTP id k3so14763ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:45:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-exclude-reserved-pages-from-dirtyable-memory-fix
has been removed from the -mm tree.  Its filename was
     mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch

This patch was dropped because it was folded into mm-exclude-reserved-pages-from-dirtyable-memory.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-exclude-reserved-pages-from-dirtyable-memory-fix

fix highmem build

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory-fix
+++ a/mm/page-writeback.c
@@ -163,8 +163,7 @@ static unsigned long highmem_dirtyable_m
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
 		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) -
-		     zone->dirty_balance_reserve;
+		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mempool-fix-first-round-failure-behavior-fix.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

