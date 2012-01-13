From: akpm@linux-foundation.org
Subject: [merged] vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:47 -0800
Message-ID: <20120113203448.7967520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:47686 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2AMUev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:51 -0500
Received: by wgbdt14 with SMTP id dt14so106230wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan/trace: Add 'file' info to trace_mm_vmscan_lru_isolate()
has been removed from the -mm tree.  Its filename was
     vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: vmscan/trace: Add 'file' info to trace_mm_vmscan_lru_isolate()

In trace_mm_vmscan_lru_isolate(), we don't output 'file' information to
the trace event and it is a bit inconvenient for the user to get the real
information(like pasted below).  mm_vmscan_lru_isolate: isolate_mode=2
order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0
contig_dirty=0 contig_failed=0

'active' can be obtained by analyzing mode(Thanks go to Minchan and Mel),
So this patch adds 'file' to the trace event and it now looks like:
mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32
nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
file=0

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   22 ++++++++++++++--------
 mm/vmscan.c                   |    2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN include/trace/events/vmscan.h~vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate
+++ a/include/trace/events/vmscan.h
@@ -266,9 +266,10 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		isolate_mode_t isolate_mode),
+		isolate_mode_t isolate_mode,
+		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode),
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode, file),
 
 	TP_STRUCT__entry(
 		__field(int, order)
@@ -279,6 +280,7 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__field(unsigned long, nr_lumpy_dirty)
 		__field(unsigned long, nr_lumpy_failed)
 		__field(isolate_mode_t, isolate_mode)
+		__field(int, file)
 	),
 
 	TP_fast_assign(
@@ -290,9 +292,10 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__entry->nr_lumpy_dirty = nr_lumpy_dirty;
 		__entry->nr_lumpy_failed = nr_lumpy_failed;
 		__entry->isolate_mode = isolate_mode;
+		__entry->file = file;
 	),
 
-	TP_printk("isolate_mode=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu contig_taken=%lu contig_dirty=%lu contig_failed=%lu",
+	TP_printk("isolate_mode=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu contig_taken=%lu contig_dirty=%lu contig_failed=%lu file=%d",
 		__entry->isolate_mode,
 		__entry->order,
 		__entry->nr_requested,
@@ -300,7 +303,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__entry->nr_taken,
 		__entry->nr_lumpy_taken,
 		__entry->nr_lumpy_dirty,
-		__entry->nr_lumpy_failed)
+		__entry->nr_lumpy_failed,
+		__entry->file)
 );
 
 DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
@@ -312,9 +316,10 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		isolate_mode_t isolate_mode),
+		isolate_mode_t isolate_mode,
+		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode, file)
 
 );
 
@@ -327,9 +332,10 @@ DEFINE_EVENT(mm_vmscan_lru_isolate_templ
 		unsigned long nr_lumpy_taken,
 		unsigned long nr_lumpy_dirty,
 		unsigned long nr_lumpy_failed,
-		isolate_mode_t isolate_mode),
+		isolate_mode_t isolate_mode,
+		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode)
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode, file)
 
 );
 
diff -puN mm/vmscan.c~vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate mm/vmscan.c
--- a/mm/vmscan.c~vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate
+++ a/mm/vmscan.c
@@ -1234,7 +1234,7 @@ static unsigned long isolate_lru_pages(u
 			nr_to_scan, scan,
 			nr_taken,
 			nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed,
-			mode);
+			mode, file);
 	return nr_taken;
 }
 
_

Patches currently in -mm which might be from boyu.mt@taobao.com are

origin.patch

