From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:05:39 -0700
Message-ID: <53e3dc13.da6E22iWMLcHeZxV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:39033 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaHGUFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:40 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so879910igi.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slaoub@gmail.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: trace-vmscan-postprocess.pl: report the number of file/anon pages respectively
has been removed from the -mm tree.  Its filename was
     mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: mm: trace-vmscan-postprocess.pl: report the number of file/anon pages respectively

Until now, the reporting from trace-vmscan-postprocess.pl is not very
useful because we cannot directly use this script for checking the
file/anon ratio of scanning.  This patch aims to report respectively the
number of file/anon pages which were scanned/reclaimed by kswapd or
direct-reclaim.  Sample output is usually something like the following.

Summary
Direct reclaims:     			8823
Direct reclaim pages scanned:		2438797
Direct reclaim file pages scanned:	1315200
Direct reclaim anon pages scanned:	1123597
Direct reclaim pages reclaimed:		446139
Direct reclaim file pages reclaimed:	378668
Direct reclaim anon pages reclaimed:	67471
Direct reclaim write file sync I/O:	0
Direct reclaim write anon sync I/O:	0
Direct reclaim write file async I/O:	0
Direct reclaim write anon async I/O:	4240
Wake kswapd requests:			122310
Time stalled direct reclaim: 		13.78 seconds

Kswapd wakeups:				25817
Kswapd pages scanned:			170779115
Kswapd file pages scanned:		162725123
Kswapd anon pages scanned:		8053992
Kswapd pages reclaimed:			129065738
Kswapd file pages reclaimed:		128500930
Kswapd anon pages reclaimed:		564808
Kswapd reclaim write file sync I/O:	0
Kswapd reclaim write anon sync I/O:	0
Kswapd reclaim write file async I/O:	36
Kswapd reclaim write anon async I/O:	730730
Time kswapd awake:			1015.50 seconds

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   53 ++++++++++
 1 file changed, 53 insertions(+)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-report-the-number-of-file-anon-pages-respectively Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-report-the-number-of-file-anon-pages-respectively
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -47,6 +47,10 @@ use constant HIGH_KSWAPD_REWAKEUP		=> 21
 use constant HIGH_NR_SCANNED			=> 22;
 use constant HIGH_NR_TAKEN			=> 23;
 use constant HIGH_NR_RECLAIMED			=> 24;
+use constant HIGH_NR_FILE_SCANNED		=> 25;
+use constant HIGH_NR_ANON_SCANNED		=> 26;
+use constant HIGH_NR_FILE_RECLAIMED		=> 27;
+use constant HIGH_NR_ANON_RECLAIMED		=> 28;
 
 my %perprocesspid;
 my %perprocess;
@@ -56,14 +60,18 @@ my $opt_read_procstat;
 
 my $total_wakeup_kswapd;
 my ($total_direct_reclaim, $total_direct_nr_scanned);
+my ($total_direct_nr_file_scanned, $total_direct_nr_anon_scanned);
 my ($total_direct_latency, $total_kswapd_latency);
 my ($total_direct_nr_reclaimed);
+my ($total_direct_nr_file_reclaimed, $total_direct_nr_anon_reclaimed);
 my ($total_direct_writepage_file_sync, $total_direct_writepage_file_async);
 my ($total_direct_writepage_anon_sync, $total_direct_writepage_anon_async);
 my ($total_kswapd_nr_scanned, $total_kswapd_wake);
+my ($total_kswapd_nr_file_scanned, $total_kswapd_nr_anon_scanned);
 my ($total_kswapd_writepage_file_sync, $total_kswapd_writepage_file_async);
 my ($total_kswapd_writepage_anon_sync, $total_kswapd_writepage_anon_async);
 my ($total_kswapd_nr_reclaimed);
+my ($total_kswapd_nr_file_reclaimed, $total_kswapd_nr_anon_reclaimed);
 
 # Catch sigint and exit on request
 my $sigint_report = 0;
@@ -374,6 +382,7 @@ EVENT_PROCESS:
 			}
 			my $isolate_mode = $1;
 			my $nr_scanned = $4;
+			my $file = $6;
 
 			# To closer match vmstat scanning statistics, only count isolate_both
 			# and isolate_inactive as scanning. isolate_active is rotation
@@ -382,6 +391,11 @@ EVENT_PROCESS:
 			# isolate_both     == 3
 			if ($isolate_mode != 2) {
 				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
+				if ($file == 1) {
+					$perprocesspid{$process_pid}->{HIGH_NR_FILE_SCANNED} += $nr_scanned;
+				} else {
+					$perprocesspid{$process_pid}->{HIGH_NR_ANON_SCANNED} += $nr_scanned;
+				}
 			}
 		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
 			$details = $6;
@@ -391,8 +405,19 @@ EVENT_PROCESS:
 				print "         $regex_lru_shrink_inactive/o\n";
 				next;
 			}
+
 			my $nr_reclaimed = $4;
+			my $flags = $6;
+			my $file = 0;
+			if ($flags =~ /RECLAIM_WB_FILE/) {
+				$file = 1;
+			}
 			$perprocesspid{$process_pid}->{HIGH_NR_RECLAIMED} += $nr_reclaimed;
+			if ($file) {
+				$perprocesspid{$process_pid}->{HIGH_NR_FILE_RECLAIMED} += $nr_reclaimed;
+			} else {
+				$perprocesspid{$process_pid}->{HIGH_NR_ANON_RECLAIMED} += $nr_reclaimed;
+			}
 		} elsif ($tracepoint eq "mm_vmscan_writepage") {
 			$details = $6;
 			if ($details !~ /$regex_writepage/o) {
@@ -493,7 +518,11 @@ sub dump_stats {
 		$total_direct_reclaim += $stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN};
 		$total_wakeup_kswapd += $stats{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD};
 		$total_direct_nr_scanned += $stats{$process_pid}->{HIGH_NR_SCANNED};
+		$total_direct_nr_file_scanned += $stats{$process_pid}->{HIGH_NR_FILE_SCANNED};
+		$total_direct_nr_anon_scanned += $stats{$process_pid}->{HIGH_NR_ANON_SCANNED};
 		$total_direct_nr_reclaimed += $stats{$process_pid}->{HIGH_NR_RECLAIMED};
+		$total_direct_nr_file_reclaimed += $stats{$process_pid}->{HIGH_NR_FILE_RECLAIMED};
+		$total_direct_nr_anon_reclaimed += $stats{$process_pid}->{HIGH_NR_ANON_RECLAIMED};
 		$total_direct_writepage_file_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
 		$total_direct_writepage_anon_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
 		$total_direct_writepage_file_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
@@ -513,7 +542,11 @@ sub dump_stats {
 			$stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN},
 			$stats{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD},
 			$stats{$process_pid}->{HIGH_NR_SCANNED},
+			$stats{$process_pid}->{HIGH_NR_FILE_SCANNED},
+			$stats{$process_pid}->{HIGH_NR_ANON_SCANNED},
 			$stats{$process_pid}->{HIGH_NR_RECLAIMED},
+			$stats{$process_pid}->{HIGH_NR_FILE_RECLAIMED},
+			$stats{$process_pid}->{HIGH_NR_ANON_RECLAIMED},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC},
 			$this_reclaim_delay / 1000);
@@ -552,7 +585,11 @@ sub dump_stats {
 
 		$total_kswapd_wake += $stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE};
 		$total_kswapd_nr_scanned += $stats{$process_pid}->{HIGH_NR_SCANNED};
+		$total_kswapd_nr_file_scanned += $stats{$process_pid}->{HIGH_NR_FILE_SCANNED};
+		$total_kswapd_nr_anon_scanned += $stats{$process_pid}->{HIGH_NR_ANON_SCANNED};
 		$total_kswapd_nr_reclaimed += $stats{$process_pid}->{HIGH_NR_RECLAIMED};
+		$total_kswapd_nr_file_reclaimed += $stats{$process_pid}->{HIGH_NR_FILE_RECLAIMED};
+		$total_kswapd_nr_anon_reclaimed += $stats{$process_pid}->{HIGH_NR_ANON_RECLAIMED};
 		$total_kswapd_writepage_file_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
 		$total_kswapd_writepage_anon_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
 		$total_kswapd_writepage_file_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
@@ -563,7 +600,11 @@ sub dump_stats {
 			$stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE},
 			$stats{$process_pid}->{HIGH_KSWAPD_REWAKEUP},
 			$stats{$process_pid}->{HIGH_NR_SCANNED},
+			$stats{$process_pid}->{HIGH_NR_FILE_SCANNED},
+			$stats{$process_pid}->{HIGH_NR_ANON_SCANNED},
 			$stats{$process_pid}->{HIGH_NR_RECLAIMED},
+			$stats{$process_pid}->{HIGH_NR_FILE_RECLAIMED},
+			$stats{$process_pid}->{HIGH_NR_ANON_RECLAIMED},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC});
 
@@ -594,7 +635,11 @@ sub dump_stats {
 	print "\nSummary\n";
 	print "Direct reclaims:     			$total_direct_reclaim\n";
 	print "Direct reclaim pages scanned:		$total_direct_nr_scanned\n";
+	print "Direct reclaim file pages scanned:	$total_direct_nr_file_scanned\n";
+	print "Direct reclaim anon pages scanned:	$total_direct_nr_anon_scanned\n";
 	print "Direct reclaim pages reclaimed:		$total_direct_nr_reclaimed\n";
+	print "Direct reclaim file pages reclaimed:	$total_direct_nr_file_reclaimed\n";
+	print "Direct reclaim anon pages reclaimed:	$total_direct_nr_anon_reclaimed\n";
 	print "Direct reclaim write file sync I/O:	$total_direct_writepage_file_sync\n";
 	print "Direct reclaim write anon sync I/O:	$total_direct_writepage_anon_sync\n";
 	print "Direct reclaim write file async I/O:	$total_direct_writepage_file_async\n";
@@ -604,7 +649,11 @@ sub dump_stats {
 	print "\n";
 	print "Kswapd wakeups:				$total_kswapd_wake\n";
 	print "Kswapd pages scanned:			$total_kswapd_nr_scanned\n";
+	print "Kswapd file pages scanned:		$total_kswapd_nr_file_scanned\n";
+	print "Kswapd anon pages scanned:		$total_kswapd_nr_anon_scanned\n";
 	print "Kswapd pages reclaimed:			$total_kswapd_nr_reclaimed\n";
+	print "Kswapd file pages reclaimed:		$total_kswapd_nr_file_reclaimed\n";
+	print "Kswapd anon pages reclaimed:		$total_kswapd_nr_anon_reclaimed\n";
 	print "Kswapd reclaim write file sync I/O:	$total_kswapd_writepage_file_sync\n";
 	print "Kswapd reclaim write anon sync I/O:	$total_kswapd_writepage_anon_sync\n";
 	print "Kswapd reclaim write file async I/O:	$total_kswapd_writepage_file_async\n";
@@ -629,7 +678,11 @@ sub aggregate_perprocesspid() {
 		$perprocess{$process}->{MM_VMSCAN_WAKEUP_KSWAPD} += $perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD};
 		$perprocess{$process}->{HIGH_KSWAPD_REWAKEUP} += $perprocesspid{$process_pid}->{HIGH_KSWAPD_REWAKEUP};
 		$perprocess{$process}->{HIGH_NR_SCANNED} += $perprocesspid{$process_pid}->{HIGH_NR_SCANNED};
+		$perprocess{$process}->{HIGH_NR_FILE_SCANNED} += $perprocesspid{$process_pid}->{HIGH_NR_FILE_SCANNED};
+		$perprocess{$process}->{HIGH_NR_ANON_SCANNED} += $perprocesspid{$process_pid}->{HIGH_NR_ANON_SCANNED};
 		$perprocess{$process}->{HIGH_NR_RECLAIMED} += $perprocesspid{$process_pid}->{HIGH_NR_RECLAIMED};
+		$perprocess{$process}->{HIGH_NR_FILE_RECLAIMED} += $perprocesspid{$process_pid}->{HIGH_NR_FILE_RECLAIMED};
+		$perprocess{$process}->{HIGH_NR_ANON_RECLAIMED} += $perprocesspid{$process_pid}->{HIGH_NR_ANON_RECLAIMED};
 		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
 		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
 		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
_

Patches currently in -mm which might be from slaoub@gmail.com are

origin.patch

