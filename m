From: akpm@linux-foundation.org
Subject: [folded] mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:43:24 -0800
Message-ID: <20120110224325.D4A2E5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40202 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2AJWn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:43:28 -0500
Received: by eaak10 with SMTP id k10so3292eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:43:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes

Cc: Mel Gorman <mgorman@suse.de>

WARNING: line over 80 characters
#42: FILE: mm/page_alloc.c:3464:
+			/* Blocks with reserved pages will never free, skip them. */

WARNING: line over 80 characters
#61: FILE: mm/page_alloc.c:3477:
+				set_pageblock_migratetype(page, MIGRATE_RESERVE);

WARNING: line over 80 characters
#62: FILE: mm/page_alloc.c:3478:
+				move_freepages_block(zone, page, MIGRATE_RESERVE);

total: 0 errors, 3 warnings, 44 lines checked

./patches/mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3405,7 +3405,10 @@ static void setup_zone_migrate_reserve(s
 
 		/* Only test what is necessary when the reserves are not met */
 		if (reserve > 0) {
-			/* Blocks with reserved pages will never free, skip them. */
+			/*
+			 * Blocks with reserved pages will never free, skip
+			 * them.
+			 */
 			block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
 			if (pageblock_is_reserved(pfn, block_end_pfn))
 				continue;
@@ -3418,8 +3421,10 @@ static void setup_zone_migrate_reserve(s
 
 			/* Suitable for reserving if this block is movable */
 			if (block_migratetype == MIGRATE_MOVABLE) {
-				set_pageblock_migratetype(page, MIGRATE_RESERVE);
-				move_freepages_block(zone, page, MIGRATE_RESERVE);
+				set_pageblock_migratetype(page,
+							MIGRATE_RESERVE);
+				move_freepages_block(zone, page,
+							MIGRATE_RESERVE);
 				reserve--;
 				continue;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
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

