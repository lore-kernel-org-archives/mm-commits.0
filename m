From: akpm@linux-foundation.org
Subject: [merged] mm-shrinker-add-nid-to-tracepoint-output.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:51:10 -0700
Message-ID: <5390ca2e.q2QiWe2BRPQz7GF0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaFETvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khlebnikov@openvz.org, david@fromorbit.com, dave.hansen@linux.intel.com

Subject: [merged] mm-shrinker-add-nid-to-tracepoint-output.patch removed from -mm tree
To: dave.hansen@linux.intel.com,david@fromorbit.com,khlebnikov@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:10 -0700


The patch titled
     Subject: mm: shrinker: add nid to tracepoint output
has been removed from the -mm tree.  Its filename was
     mm-shrinker-add-nid-to-tracepoint-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: shrinker: add nid to tracepoint output

Now that we are doing NUMA-aware shrinking, and can have
shrinkers running in parallel, or working on individual nodes, it
seems like we should also be sticking the node in the output.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dave Chinner <david@fromorbit.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   15 +++++++++++----
 mm/vmscan.c                   |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-shrinker-add-nid-to-tracepoint-output include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-shrinker-add-nid-to-tracepoint-output
+++ a/include/trace/events/vmscan.h
@@ -191,6 +191,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
 		__field(void *, shrink)
+		__field(int, nid)
 		__field(long, nr_objects_to_shrink)
 		__field(gfp_t, gfp_flags)
 		__field(unsigned long, pgs_scanned)
@@ -203,6 +204,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 	TP_fast_assign(
 		__entry->shr = shr;
 		__entry->shrink = shr->scan_objects;
+		__entry->nid = sc->nid;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = sc->gfp_mask;
 		__entry->pgs_scanned = pgs_scanned;
@@ -212,9 +214,10 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->total_scan = total_scan;
 	),
 
-	TP_printk("%pF %p: objects to shrink %ld gfp_flags %s pgs_scanned %ld lru_pgs %ld cache items %ld delta %lld total_scan %ld",
+	TP_printk("%pF %p: nid: %d objects to shrink %ld gfp_flags %s pgs_scanned %ld lru_pgs %ld cache items %ld delta %lld total_scan %ld",
 		__entry->shrink,
 		__entry->shr,
+		__entry->nid,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->pgs_scanned,
@@ -225,13 +228,15 @@ TRACE_EVENT(mm_shrink_slab_start,
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
-	TP_PROTO(struct shrinker *shr, int shrinker_retval,
+	TP_PROTO(struct shrinker *shr, int nid, int shrinker_retval,
 		long unused_scan_cnt, long new_scan_cnt, long total_scan),
 
-	TP_ARGS(shr, shrinker_retval, unused_scan_cnt, new_scan_cnt, total_scan),
+	TP_ARGS(shr, nid, shrinker_retval, unused_scan_cnt, new_scan_cnt,
+		total_scan),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
+		__field(int, nid)
 		__field(void *, shrink)
 		__field(long, unused_scan)
 		__field(long, new_scan)
@@ -241,6 +246,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 
 	TP_fast_assign(
 		__entry->shr = shr;
+		__entry->nid = nid;
 		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
@@ -248,9 +254,10 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->total_scan = total_scan;
 	),
 
-	TP_printk("%pF %p: unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pF %p: nid: %d unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
 		__entry->shrink,
 		__entry->shr,
+		__entry->nid,
 		__entry->unused_scan,
 		__entry->new_scan,
 		__entry->total_scan,
diff -puN mm/vmscan.c~mm-shrinker-add-nid-to-tracepoint-output mm/vmscan.c
--- a/mm/vmscan.c~mm-shrinker-add-nid-to-tracepoint-output
+++ a/mm/vmscan.c
@@ -324,7 +324,7 @@ shrink_slab_node(struct shrink_control *
 	else
 		new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
 
-	trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, nid, freed, nr, new_nr, total_scan);
 	return freed;
 }
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

