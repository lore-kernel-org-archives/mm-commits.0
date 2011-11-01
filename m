From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:36 -0700
Message-ID: <201111012109.pA1L9ahA031997@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15509 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab1KAVKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, min


The patch titled
     Subject: mm: vmscan: immediately reclaim end-of-LRU dirty pages when writeback completes
has been removed from the -mm tree.  Its filename was
     mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: immediately reclaim end-of-LRU dirty pages when writeback completes

When direct reclaim encounters a dirty page, it gets recycled around the
LRU for another cycle.  This patch marks the page PageReclaim similar to
deactivate_page() so that the page gets reclaimed almost immediately after
the page gets cleaned.  This is to avoid reclaiming clean pages that are
younger than a dirty page encountered at the end of the LRU that might
have been something like a use-once page.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |   10 +++++++++-
 mm/vmstat.c            |    2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes
+++ a/include/linux/mmzone.h
@@ -100,7 +100,7 @@ enum zone_stat_item {
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
-	NR_VMSCAN_WRITE_SKIP,
+	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
diff -puN mm/vmscan.c~mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes
+++ a/mm/vmscan.c
@@ -866,7 +866,15 @@ static unsigned long shrink_page_list(st
 			 */
 			if (page_is_file_cache(page) &&
 					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
-				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
+				/*
+				 * Immediately reclaim when written back.
+				 * Similar in principal to deactivate_page()
+				 * except we already have the page isolated
+				 * and know it's dirty
+				 */
+				inc_zone_page_state(page, NR_VMSCAN_IMMEDIATE);
+				SetPageReclaim(page);
+
 				goto keep_locked;
 			}
 
diff -puN mm/vmstat.c~mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes mm/vmstat.c
--- a/mm/vmstat.c~mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes
+++ a/mm/vmstat.c
@@ -702,7 +702,7 @@ const char * const vmstat_text[] = {
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
-	"nr_vmscan_write_skip",
+	"nr_vmscan_immediate_reclaim",
 	"nr_writeback_temp",
 	"nr_isolated_anon",
 	"nr_isolated_file",
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

