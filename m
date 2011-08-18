From: akpm@linux-foundation.org
Subject: + mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch added to -mm tree
Date: Thu, 18 Aug 2011 16:54:50 -0700
Message-ID: <201108182354.p7INsoeh002689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab1HRXz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 19:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, riel@redhat.com, tytso@mit.edu


The patch titled
     mm: vmscan: immediately reclaim end-of-LRU dirty pages when writeback completes
has been added to the -mm tree.  Its filename is
     mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch

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
Subject: mm: vmscan: immediately reclaim end-of-LRU dirty pages when writeback completes
From: Mel Gorman <mgorman@suse.de>

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
Signed-off-by: Andrew Morton <>
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
@@ -867,7 +867,15 @@ static unsigned long shrink_page_list(st
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

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
hugepages-fix-race-between-hugetlbfs-umount-and-quota-update-checkpatch-fixes.patch

