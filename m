From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch added to
 -mm tree
Date: Thu, 05 Jan 2017 15:46:34 -0800
Message-ID: <586edada.NjOyYwjm0I1NdkNU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55430 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162123AbdAEXpQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:45:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: enhance mm_vmscan_lru_shrink_inactive tracepoint
has been added to the -mm tree.  Its filename is
     mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: enhance mm_vmscan_lru_shrink_inactive tracepoint

mm_vmscan_lru_shrink_inactive will currently report the number of scanned
and reclaimed pages.  This doesn't give us an idea how the reclaim went
except for the overall effectiveness though.  Export and show other
counters which will tell us why we couldn't reclaim some pages.

	- nr_dirty, nr_writeback, nr_congested and nr_immediate tells
	  us how many pages are blocked due to IO
	- nr_activate tells us how many pages were moved to the active
	  list
	- nr_ref_keep reports how many pages are kept on the LRU due
	  to references (mostly for the file pages which are about to
	  go for another round through the inactive list)
	- nr_unmap_fail - how many pages failed to unmap

All these are rather low level so they might change in future but the
tracepoint is already implementation specific so no tools should be
depending on its stability.

Link: http://lkml.kernel.org/r/20170104101942.4860-7-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   29 ++++++++++++++++++++++++++---
 mm/vmscan.c                   |   14 ++++++++++++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint
+++ a/include/trace/events/vmscan.h
@@ -340,14 +340,27 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
+		unsigned long nr_dirty, unsigned long nr_writeback,
+		unsigned long nr_congested, unsigned long nr_immediate,
+		unsigned long nr_activate, unsigned long nr_ref_keep,
+		unsigned long nr_unmap_fail,
 		int priority, int file),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, priority, file),
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, nr_dirty, nr_writeback,
+		nr_congested, nr_immediate, nr_activate, nr_ref_keep,
+		nr_unmap_fail, priority, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_reclaimed)
+		__field(unsigned long, nr_dirty)
+		__field(unsigned long, nr_writeback)
+		__field(unsigned long, nr_congested)
+		__field(unsigned long, nr_immediate)
+		__field(unsigned long, nr_activate)
+		__field(unsigned long, nr_ref_keep)
+		__field(unsigned long, nr_unmap_fail)
 		__field(int, priority)
 		__field(int, reclaim_flags)
 	),
@@ -356,14 +369,24 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		__entry->nid = nid;
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_dirty = nr_dirty;
+		__entry->nr_writeback = nr_writeback;
+		__entry->nr_congested = nr_congested;
+		__entry->nr_immediate = nr_immediate;
+		__entry->nr_activate = nr_activate;
+		__entry->nr_ref_keep = nr_ref_keep;
+		__entry->nr_unmap_fail = nr_unmap_fail;
 		__entry->priority = priority;
 		__entry->reclaim_flags = trace_shrink_flags(file);
 	),
 
-	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld priority=%d flags=%s",
+	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld nr_dirty=%ld nr_writeback=%ld nr_congested=%ld nr_immediate=%ld nr_activate=%ld nr_ref_keep=%ld nr_unmap_fail=%ld priority=%d flags=%s",
 		__entry->nid,
 		__entry->nr_scanned, __entry->nr_reclaimed,
-		__entry->priority,
+		__entry->nr_dirty, __entry->nr_writeback,
+		__entry->nr_congested, __entry->nr_immediate,
+		__entry->nr_activate, __entry->nr_ref_keep,
+		__entry->nr_unmap_fail, __entry->priority,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
diff -puN mm/vmscan.c~mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint
+++ a/mm/vmscan.c
@@ -908,6 +908,9 @@ struct reclaim_stat {
 	unsigned nr_congested;
 	unsigned nr_writeback;
 	unsigned nr_immediate;
+	unsigned nr_activate;
+	unsigned nr_ref_keep;
+	unsigned nr_unmap_fail;
 };
 
 /*
@@ -929,6 +932,8 @@ static unsigned long shrink_page_list(st
 	unsigned nr_reclaimed = 0;
 	unsigned nr_writeback = 0;
 	unsigned nr_immediate = 0;
+	unsigned nr_ref_keep = 0;
+	unsigned nr_unmap_fail = 0;
 
 	cond_resched();
 
@@ -1067,6 +1072,7 @@ static unsigned long shrink_page_list(st
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
 		case PAGEREF_KEEP:
+			nr_ref_keep++;
 			goto keep_locked;
 		case PAGEREF_RECLAIM:
 		case PAGEREF_RECLAIM_CLEAN:
@@ -1104,6 +1110,7 @@ static unsigned long shrink_page_list(st
 				(ttu_flags | TTU_BATCH_FLUSH | TTU_LZFREE) :
 				(ttu_flags | TTU_BATCH_FLUSH))) {
 			case SWAP_FAIL:
+				nr_unmap_fail++;
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
@@ -1276,6 +1283,9 @@ keep:
 		stat->nr_unqueued_dirty = nr_unqueued_dirty;
 		stat->nr_writeback = nr_writeback;
 		stat->nr_immediate = nr_immediate;
+		stat->nr_activate = pgactivate;
+		stat->nr_ref_keep = nr_ref_keep;
+		stat->nr_unmap_fail = nr_unmap_fail;
 	}
 	return nr_reclaimed;
 }
@@ -1825,6 +1835,10 @@ shrink_inactive_list(unsigned long nr_to
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed,
+			stat.nr_dirty,  stat.nr_writeback,
+			stat.nr_congested, stat.nr_immediate,
+			stat.nr_activate, stat.nr_ref_keep,
+			stat.nr_unmap_fail,
 			sc->priority, file);
 	return nr_reclaimed;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-fix-remote-numa-hits-statistics.patch
mm-get-rid-of-__gfp_other_node.patch
mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

