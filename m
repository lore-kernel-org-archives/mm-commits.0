From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate.patch added to -mm tree
Date: Fri, 27 Jun 2014 12:39:07 -0700
Message-ID: <53adc85b.TipWZVKsaLYvyT9A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:57871 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaF0TjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 15:39:08 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1246222obb.4
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 12:39:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slaoub@gmail.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm:vmscan: update the trace-vmscan-postprocess.pl for event vmscan/mm_vmscan_lru_isolate
has been added to the -mm tree.  Its filename is
     mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: mm:vmscan: update the trace-vmscan-postprocess.pl for event vmscan/mm_vmscan_lru_isolate

When using trace-vmscan-postprocess.pl for checking the file/anon rate of
scanning, we can find that it can not be performed.  At the same time, the
following message will be reported.

WARNING: Format not as expected for event vmscan/mm_vmscan_lru_isolate
'file' != 'contig_taken' Fewer fields than expected in format at
./trace-vmscan-postprocess.pl line 171, <FORMAT> line 76.

In trace-vmscan-postprocess.pl, (contig_taken, contig_dirty, and
contig_failed) are be associated respectively to (nr_lumpy_taken,
nr_lumpy_dirty, and nr_lumpy_failed) for lumpy reclaim.  Via c53919adc045b
("mm: vmscan: remove lumpy reclaim"), lumpy reclaim had already been
removed by Mel, but the update for trace-vmscan-postprocess.pl was missed.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   14 +---------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -47,7 +47,6 @@ use constant HIGH_KSWAPD_REWAKEUP		=> 21
 use constant HIGH_NR_SCANNED			=> 22;
 use constant HIGH_NR_TAKEN			=> 23;
 use constant HIGH_NR_RECLAIMED			=> 24;
-use constant HIGH_NR_CONTIG_DIRTY		=> 25;
 
 my %perprocesspid;
 my %perprocess;
@@ -105,7 +104,7 @@ my $regex_direct_end_default = 'nr_recla
 my $regex_kswapd_wake_default = 'nid=([0-9]*) order=([0-9]*)';
 my $regex_kswapd_sleep_default = 'nid=([0-9]*)';
 my $regex_wakeup_kswapd_default = 'nid=([0-9]*) zid=([0-9]*) order=([0-9]*)';
-my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_taken=([0-9]*) contig_taken=([0-9]*) contig_dirty=([0-9]*) contig_failed=([0-9]*)';
+my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_taken=([0-9]*) file=([0-9]*)';
 my $regex_lru_shrink_inactive_default = 'nid=([0-9]*) zid=([0-9]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)';
 my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_rotated=([0-9]*) priority=([0-9]*)';
 my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) flags=([A-Z_|]*)';
@@ -200,7 +199,7 @@ $regex_lru_isolate = generate_traceevent
 			$regex_lru_isolate_default,
 			"isolate_mode", "order",
 			"nr_requested", "nr_scanned", "nr_taken",
-			"contig_taken", "contig_dirty", "contig_failed");
+			"file");
 $regex_lru_shrink_inactive = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_shrink_inactive",
 			$regex_lru_shrink_inactive_default,
@@ -375,7 +374,6 @@ EVENT_PROCESS:
 			}
 			my $isolate_mode = $1;
 			my $nr_scanned = $4;
-			my $nr_contig_dirty = $7;
 
 			# To closer match vmstat scanning statistics, only count isolate_both
 			# and isolate_inactive as scanning. isolate_active is rotation
@@ -385,7 +383,6 @@ EVENT_PROCESS:
 			if ($isolate_mode != 2) {
 				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
 			}
-			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
 		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
 			$details = $6;
 			if ($details !~ /$regex_lru_shrink_inactive/o) {
@@ -539,13 +536,6 @@ sub dump_stats {
 				}
 			}
 		}
-		if ($stats{$process_pid}->{HIGH_NR_CONTIG_DIRTY}) {
-			print "      ";
-			my $count = $stats{$process_pid}->{HIGH_NR_CONTIG_DIRTY};
-			if ($count != 0) {
-				print "contig-dirty=$count ";
-			}
-		}
 
 		print "\n";
 	}
_

Patches currently in -mm which might be from slaoub@gmail.com are

checkpatch-check-git-commit-descriptions.patch
mm-vmscan-update-the-trace-vmscan-postprocesspl-for-event-vmscan-mm_vmscan_lru_isolate.patch
hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch

