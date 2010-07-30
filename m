From: akpm@linux-foundation.org
Subject: + vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:48:25 -0700
Message-ID: <201007302148.o6ULmPrG002437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149Ab0G3Vtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: tracing: Update post-processing script to distinguish between anon and file IO from page reclaim
has been added to the -mm tree.  Its filename is
     vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch

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
Subject: vmscan: tracing: Update post-processing script to distinguish between anon and file IO from page reclaim
From: Mel Gorman <mel@csn.ul.ie>

It is useful to distinguish between IO for anon and file pages.  This
patch updates
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
so the post-processing script can handle the additional information.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   94 ++++++----
 1 file changed, 63 insertions(+), 31 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -21,9 +21,12 @@ use constant MM_VMSCAN_KSWAPD_SLEEP		=> 
 use constant MM_VMSCAN_LRU_SHRINK_ACTIVE	=> 5;
 use constant MM_VMSCAN_LRU_SHRINK_INACTIVE	=> 6;
 use constant MM_VMSCAN_LRU_ISOLATE		=> 7;
-use constant MM_VMSCAN_WRITEPAGE_SYNC		=> 8;
-use constant MM_VMSCAN_WRITEPAGE_ASYNC		=> 9;
-use constant EVENT_UNKNOWN			=> 10;
+use constant MM_VMSCAN_WRITEPAGE_FILE_SYNC	=> 8;
+use constant MM_VMSCAN_WRITEPAGE_ANON_SYNC	=> 9;
+use constant MM_VMSCAN_WRITEPAGE_FILE_ASYNC	=> 10;
+use constant MM_VMSCAN_WRITEPAGE_ANON_ASYNC	=> 11;
+use constant MM_VMSCAN_WRITEPAGE_ASYNC		=> 12;
+use constant EVENT_UNKNOWN			=> 13;
 
 # Per-order events
 use constant MM_VMSCAN_DIRECT_RECLAIM_BEGIN_PERORDER => 11;
@@ -55,9 +58,11 @@ my $opt_read_procstat;
 my $total_wakeup_kswapd;
 my ($total_direct_reclaim, $total_direct_nr_scanned);
 my ($total_direct_latency, $total_kswapd_latency);
-my ($total_direct_writepage_sync, $total_direct_writepage_async);
+my ($total_direct_writepage_file_sync, $total_direct_writepage_file_async);
+my ($total_direct_writepage_anon_sync, $total_direct_writepage_anon_async);
 my ($total_kswapd_nr_scanned, $total_kswapd_wake);
-my ($total_kswapd_writepage_sync, $total_kswapd_writepage_async);
+my ($total_kswapd_writepage_file_sync, $total_kswapd_writepage_file_async);
+my ($total_kswapd_writepage_anon_sync, $total_kswapd_writepage_anon_async);
 
 # Catch sigint and exit on request
 my $sigint_report = 0;
@@ -101,7 +106,7 @@ my $regex_wakeup_kswapd_default = 'nid=(
 my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_taken=([0-9]*) contig_taken=([0-9]*) contig_dirty=([0-9]*) contig_failed=([0-9]*)';
 my $regex_lru_shrink_inactive_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) priority=([0-9]*)';
 my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_rotated=([0-9]*) priority=([0-9]*)';
-my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) sync_io=([0-9]*)';
+my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) flags=([A-Z_|]*)';
 
 # Dyanically discovered regex
 my $regex_direct_begin;
@@ -209,7 +214,7 @@ $regex_lru_shrink_active = generate_trac
 $regex_writepage = generate_traceevent_regex(
 			"vmscan/mm_vmscan_writepage",
 			$regex_writepage_default,
-			"page", "pfn", "sync_io");
+			"page", "pfn", "flags");
 
 sub read_statline($) {
 	my $pid = $_[0];
@@ -379,11 +384,27 @@ EVENT_PROCESS:
 				next;
 			}
 
-			my $sync_io = $3;
+			my $flags = $3;
+			my $file = 0;
+			my $sync_io = 0;
+			if ($flags =~ /RECLAIM_WB_FILE/) {
+				$file = 1;
+			}
+			if ($flags =~ /RECLAIM_WB_SYNC/) {
+				$sync_io = 1;
+			}
 			if ($sync_io) {
-				$perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_SYNC}++;
+				if ($file) {
+					$perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC}++;
+				} else {
+					$perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC}++;
+				}
 			} else {
-				$perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ASYNC}++;
+				if ($file) {
+					$perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC}++;
+				} else {
+					$perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC}++;
+				}
 			}
 		} else {
 			$perprocesspid{$process_pid}->{EVENT_UNKNOWN}++;
@@ -454,8 +475,11 @@ sub dump_stats {
 		$total_direct_reclaim += $stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN};
 		$total_wakeup_kswapd += $stats{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD};
 		$total_direct_nr_scanned += $stats{$process_pid}->{HIGH_NR_SCANNED};
-		$total_direct_writepage_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_SYNC};
-		$total_direct_writepage_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ASYNC};
+		$total_direct_writepage_file_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
+		$total_direct_writepage_anon_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
+		$total_direct_writepage_file_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
+
+		$total_direct_writepage_anon_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC};
 
 		my $index = 0;
 		my $this_reclaim_delay = 0;
@@ -470,8 +494,8 @@ sub dump_stats {
 			$stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN},
 			$stats{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD},
 			$stats{$process_pid}->{HIGH_NR_SCANNED},
-			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_SYNC},
-			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ASYNC},
+			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC},
+			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC},
 			$this_reclaim_delay / 1000);
 
 		if ($stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN}) {
@@ -515,16 +539,18 @@ sub dump_stats {
 
 		$total_kswapd_wake += $stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE};
 		$total_kswapd_nr_scanned += $stats{$process_pid}->{HIGH_NR_SCANNED};
-		$total_kswapd_writepage_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_SYNC};
-		$total_kswapd_writepage_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ASYNC};
+		$total_kswapd_writepage_file_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
+		$total_kswapd_writepage_anon_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
+		$total_kswapd_writepage_file_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
+		$total_kswapd_writepage_anon_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC};
 
 		printf("%-" . $max_strlen . "s %8d %10d   %8u   %8i %8u",
 			$process_pid,
 			$stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE},
 			$stats{$process_pid}->{HIGH_KSWAPD_REWAKEUP},
 			$stats{$process_pid}->{HIGH_NR_SCANNED},
-			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_SYNC},
-			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ASYNC});
+			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC},
+			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC});
 
 		if ($stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE}) {
 			print "      ";
@@ -551,18 +577,22 @@ sub dump_stats {
 	$total_direct_latency /= 1000;
 	$total_kswapd_latency /= 1000;
 	print "\nSummary\n";
-	print "Direct reclaims:     		$total_direct_reclaim\n";
-	print "Direct reclaim pages scanned:	$total_direct_nr_scanned\n";
-	print "Direct reclaim write sync I/O:	$total_direct_writepage_sync\n";
-	print "Direct reclaim write async I/O:	$total_direct_writepage_async\n";
-	print "Wake kswapd requests:		$total_wakeup_kswapd\n";
-	printf "Time stalled direct reclaim: 	%-1.2f ms\n", $total_direct_latency;
+	print "Direct reclaims:     			$total_direct_reclaim\n";
+	print "Direct reclaim pages scanned:		$total_direct_nr_scanned\n";
+	print "Direct reclaim write file sync I/O:	$total_direct_writepage_file_sync\n";
+	print "Direct reclaim write anon sync I/O:	$total_direct_writepage_anon_sync\n";
+	print "Direct reclaim write file async I/O:	$total_direct_writepage_file_async\n";
+	print "Direct reclaim write anon async I/O:	$total_direct_writepage_anon_async\n";
+	print "Wake kswapd requests:			$total_wakeup_kswapd\n";
+	printf "Time stalled direct reclaim: 		%-1.2f ms\n", $total_direct_latency;
 	print "\n";
-	print "Kswapd wakeups:			$total_kswapd_wake\n";
-	print "Kswapd pages scanned:		$total_kswapd_nr_scanned\n";
-	print "Kswapd reclaim write sync I/O:	$total_kswapd_writepage_sync\n";
-	print "Kswapd reclaim write async I/O:	$total_kswapd_writepage_async\n";
-	printf "Time kswapd awake:		%-1.2f ms\n", $total_kswapd_latency;
+	print "Kswapd wakeups:				$total_kswapd_wake\n";
+	print "Kswapd pages scanned:			$total_kswapd_nr_scanned\n";
+	print "Kswapd reclaim write file sync I/O:	$total_kswapd_writepage_file_sync\n";
+	print "Kswapd reclaim write anon sync I/O:	$total_kswapd_writepage_anon_sync\n";
+	print "Kswapd reclaim write file async I/O:	$total_kswapd_writepage_file_async\n";
+	print "Kswapd reclaim write anon async I/O:	$total_kswapd_writepage_anon_async\n";
+	printf "Time kswapd awake:			%-1.2f ms\n", $total_kswapd_latency;
 }
 
 sub aggregate_perprocesspid() {
@@ -582,8 +612,10 @@ sub aggregate_perprocesspid() {
 		$perprocess{$process}->{MM_VMSCAN_WAKEUP_KSWAPD} += $perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD};
 		$perprocess{$process}->{HIGH_KSWAPD_REWAKEUP} += $perprocesspid{$process_pid}->{HIGH_KSWAPD_REWAKEUP};
 		$perprocess{$process}->{HIGH_NR_SCANNED} += $perprocesspid{$process_pid}->{HIGH_NR_SCANNED};
-		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_SYNC};
-		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_ASYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ASYNC};
+		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
+		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
+		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
+		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC};
 
 		for (my $order = 0; $order < 20; $order++) {
 			$perprocess{$process}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN_PERORDER}[$order] += $perprocesspid{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN_PERORDER}[$order];
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
vmscan-avoid-subtraction-of-unsigned-types.patch
vmscan-convert-direct-reclaim-tracepoint-to-define_trace.patch
memcg-vmscan-add-memcg-reclaim-tracepoint.patch
vmscan-convert-mm_vmscan_lru_isolate-to-define_event.patch
memcg-add-mm_vmscan_memcg_isolate-tracepoint.patch
memcg-scnr_to_reclaim-should-be-initialized.patch
memcg-kill-unnecessary-initialization-in-mem_cgroup_shrink_node_zone.patch
memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch
memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch
memcg-convert-to-use-zone_to_nid-from-bare-zone-zone_pgdat-node_id.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

