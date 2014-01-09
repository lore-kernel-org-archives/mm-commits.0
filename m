From: akpm@linux-foundation.org
Subject: +
 documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex.patch added to -mm tree
Date: Wed, 08 Jan 2014 16:01:53 -0800
Message-ID: <52cde6f1.hGN8YETIBwNtOyBk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbaAIABy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 19:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, vinayakm.list@gmail.com

Subject: + documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex.patch added to -mm tree
To: vinayakm.list@gmail.com,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 16:01:53 -0800


The patch titled
     Subject: Documentation/trace/postprocess/trace-vmscan-postprocess.pl: fix the traceevent regex
has been added to the -mm tree.  Its filename is
     documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vinayak Menon <vinayakm.list@gmail.com>
Subject: Documentation/trace/postprocess/trace-vmscan-postprocess.pl: fix the traceevent regex

When irq, preempt and lockdep fields are printed (field 3 in the e.g. 
below) in the trace output, the script fails.

An e.g. entry.
kswapd0-610   [000] ...1   158.112152: mm_vmscan_kswapd_wake: nid=0 order=0

Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   18 +++++-----
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -123,7 +123,7 @@ my $regex_writepage;
 
 # Static regex used. Specified like this for readability and for use with /o
 #                      (process_pid)     (cpus      )   ( time  )   (tpoint    ) (details)
-my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
+my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])(\s*[dX.][Nnp.][Hhs.][0-9a-fA-F.]*|)\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
 my $regex_statname = '[-0-9]*\s\((.*)\).*';
 my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';
 
@@ -270,8 +270,8 @@ EVENT_PROCESS:
 	while ($traceevent = <STDIN>) {
 		if ($traceevent =~ /$regex_traceevent/o) {
 			$process_pid = $1;
-			$timestamp = $3;
-			$tracepoint = $4;
+			$timestamp = $4;
+			$tracepoint = $5;
 
 			$process_pid =~ /(.*)-([0-9]*)$/;
 			my $process = $1;
@@ -299,7 +299,7 @@ EVENT_PROCESS:
 			$perprocesspid{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN}++;
 			$perprocesspid{$process_pid}->{STATE_DIRECT_BEGIN} = $timestamp;
 
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_direct_begin/o) {
 				print "WARNING: Failed to parse mm_vmscan_direct_reclaim_begin as expected\n";
 				print "         $details\n";
@@ -322,7 +322,7 @@ EVENT_PROCESS:
 				$perprocesspid{$process_pid}->{HIGH_DIRECT_RECLAIM_LATENCY}[$index] = "$order-$latency";
 			}
 		} elsif ($tracepoint eq "mm_vmscan_kswapd_wake") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_kswapd_wake/o) {
 				print "WARNING: Failed to parse mm_vmscan_kswapd_wake as expected\n";
 				print "         $details\n";
@@ -356,7 +356,7 @@ EVENT_PROCESS:
 		} elsif ($tracepoint eq "mm_vmscan_wakeup_kswapd") {
 			$perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD}++;
 
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_wakeup_kswapd/o) {
 				print "WARNING: Failed to parse mm_vmscan_wakeup_kswapd as expected\n";
 				print "         $details\n";
@@ -366,7 +366,7 @@ EVENT_PROCESS:
 			my $order = $3;
 			$perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD_PERORDER}[$order]++;
 		} elsif ($tracepoint eq "mm_vmscan_lru_isolate") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_lru_isolate/o) {
 				print "WARNING: Failed to parse mm_vmscan_lru_isolate as expected\n";
 				print "         $details\n";
@@ -387,7 +387,7 @@ EVENT_PROCESS:
 			}
 			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
 		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_lru_shrink_inactive/o) {
 				print "WARNING: Failed to parse mm_vmscan_lru_shrink_inactive as expected\n";
 				print "         $details\n";
@@ -397,7 +397,7 @@ EVENT_PROCESS:
 			my $nr_reclaimed = $4;
 			$perprocesspid{$process_pid}->{HIGH_NR_RECLAIMED} += $nr_reclaimed;
 		} elsif ($tracepoint eq "mm_vmscan_writepage") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_writepage/o) {
 				print "WARNING: Failed to parse mm_vmscan_writepage as expected\n";
 				print "         $details\n";
_

Patches currently in -mm which might be from vinayakm.list@gmail.com are

documentation-trace-postprocess-trace-vmscan-postprocesspl-fix-the-traceevent-regex.patch

