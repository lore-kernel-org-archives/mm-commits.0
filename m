From: akpm@linux-foundation.org
Subject: + mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch added to -mm tree
Date: Thu, 03 Sep 2009 14:06:06 -0700
Message-ID: <200909032106.n83L66AK013019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932244AbZICVHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 17:07:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm/vsmcan: check shrink_active_list() sc->isolate_pages() return value
has been added to the -mm tree.  Its filename is
     mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch

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
Subject: mm/vsmcan: check shrink_active_list() sc->isolate_pages() return value
From: Vincent Li <macli@brc.ubc.ca>

If we can't isolate pages from LRU list, we don't have to account page
movement, either.  Already, in commit 5343daceec, KOSAKI did it about
shrink_inactive_list.

This patch removes unnecessary overhead of page accounting and locking in
shrink_active_list as follow-up work of commit 5343daceec.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value mm/vmscan.c
--- a/mm/vmscan.c~mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value
+++ a/mm/vmscan.c
@@ -1319,9 +1319,12 @@ static void shrink_active_list(unsigned 
 	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
-	reclaim_stat->recent_scanned[file] += nr_taken;
-
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
+
+	if (nr_taken == 0)
+		goto done;
+
+	reclaim_stat->recent_scanned[file] += nr_taken;
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
 	else
@@ -1385,6 +1388,7 @@ static void shrink_active_list(unsigned 
 							nr_rotated);
 	__mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
 							nr_deactivated);
+done:
 	spin_unlock_irq(&zone->lru_lock);
 }
 
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

mm-memory-failure-remove-config_unevictable_lru-config-option.patch
mm-count-only-reclaimable-lru-pages-v2.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-vmscan-remove-page_queue_congested-comment.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

