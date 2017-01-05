From: akpm@linux-foundation.org
Subject: + mm-vmscan-add-active-list-aging-tracepoint-update.patch added
 to -mm tree
Date: Thu, 05 Jan 2017 15:46:26 -0800
Message-ID: <586edad2.VcAZ6Ia8PzqrQFBo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162118AbdAEXpJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:45:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-add-active-list-aging-tracepoint-update
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-active-list-aging-tracepoint-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-active-list-aging-tracepoint-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-active-list-aging-tracepoint-update.patch

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
Subject: mm-vmscan-add-active-list-aging-tracepoint-update

Our reclaim process has several tracepoints to tell us more about how
things are progressing. We are, however, missing a tracepoint to track
active list aging. Introduce mm_vmscan_lru_shrink_active which reports
the number of
	- nr_taken is number of isolated pages from the active list
	- nr_referenced pages which tells us that we are hitting referenced
	  pages which are deactivated. If this is a large part of the
	  reported nr_deactivated pages then we might be hitting into
	  the active list too early because they might be still part of
	  the working set. This might help to debug performance issues.
	- nr_active pages which tells us how many pages are kept on the
	  active list - mostly exec file backed pages. A high number can
	  indicate that we might be trashing on executables.

Link: http://lkml.kernel.org/r/20170104135244.GJ25453@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-add-active-list-aging-tracepoint-update include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-add-active-list-aging-tracepoint-update
+++ a/include/trace/events/vmscan.h
@@ -366,15 +366,15 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
-		unsigned long nr_activate, unsigned long nr_deactivated,
+		unsigned long nr_active, unsigned long nr_deactivated,
 		unsigned long nr_referenced, int priority, int file),
 
-	TP_ARGS(nid, nr_taken, nr_activate, nr_deactivated, nr_referenced, priority, file),
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
 		__field(unsigned long, nr_taken)
-		__field(unsigned long, nr_activate)
+		__field(unsigned long, nr_active)
 		__field(unsigned long, nr_deactivated)
 		__field(unsigned long, nr_referenced)
 		__field(int, priority)
@@ -384,17 +384,17 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 	TP_fast_assign(
 		__entry->nid = nid;
 		__entry->nr_taken = nr_taken;
-		__entry->nr_activate = nr_activate;
+		__entry->nr_active = nr_active;
 		__entry->nr_deactivated = nr_deactivated;
 		__entry->nr_referenced = nr_referenced;
 		__entry->priority = priority;
 		__entry->reclaim_flags = trace_shrink_flags(file);
 	),
 
-	TP_printk("nid=%d nr_taken=%ld nr_activated=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d flags=%s",
+	TP_printk("nid=%d nr_taken=%ld nr_active=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d flags=%s",
 		__entry->nid,
 		__entry->nr_taken,
-		__entry->nr_activate, __entry->nr_deactivated, __entry->nr_referenced,
+		__entry->nr_active, __entry->nr_deactivated, __entry->nr_referenced,
 		__entry->priority,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
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

