From: akpm@linux-foundation.org
Subject: + trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
 added to -mm tree
Date: Thu, 05 Jan 2017 15:46:38 -0800
Message-ID: <586edade.zUSVjWyjZIyXOlAU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162125AbdAEXpU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:45:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: trace-vmscan-postprocess: sync with tracepoints updates
has been added to the -mm tree.  Its filename is
     trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

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
Subject: trace-vmscan-postprocess: sync with tracepoints updates

Both mm_vmscan_lru_shrink_active and mm_vmscan_lru_isolate have changed
so the script needs to be update to reflect those changes

Link: http://lkml.kernel.org/r/20170105151737.GU21618@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   26 +++++-----
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~trace-vmscan-postprocess-sync-with-tracepoints-updates Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~trace-vmscan-postprocess-sync-with-tracepoints-updates
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -112,8 +112,8 @@ my $regex_direct_end_default = 'nr_recla
 my $regex_kswapd_wake_default = 'nid=([0-9]*) order=([0-9]*)';
 my $regex_kswapd_sleep_default = 'nid=([0-9]*)';
 my $regex_wakeup_kswapd_default = 'nid=([0-9]*) zid=([0-9]*) order=([0-9]*)';
-my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_taken=([0-9]*) file=([0-9]*)';
-my $regex_lru_shrink_inactive_default = 'nid=([0-9]*) zid=([0-9]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)';
+my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) classzone_idx=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_skipped=([0-9]*) nr_taken=([0-9]*) lru=([a-z_]*)';
+my $regex_lru_shrink_inactive_default = 'nid=([0-9]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) nr_dirty=([0-9]*) nr_writeback=([0-9]*) nr_congested=([0-9]*) nr_immediate=([0-9]*) nr_activate=([0-9]*) nr_ref_keep=([0-9]*) nr_unmap_fail=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)';
 my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_rotated=([0-9]*) priority=([0-9]*)';
 my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) flags=([A-Z_|]*)';
 
@@ -205,15 +205,15 @@ $regex_wakeup_kswapd = generate_traceeve
 $regex_lru_isolate = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_isolate",
 			$regex_lru_isolate_default,
-			"isolate_mode", "order",
-			"nr_requested", "nr_scanned", "nr_taken",
-			"file");
+			"isolate_mode", "classzone_idx", "order",
+			"nr_requested", "nr_scanned", "nr_skipped", "nr_taken",
+			"lru");
 $regex_lru_shrink_inactive = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_shrink_inactive",
 			$regex_lru_shrink_inactive_default,
-			"nid", "zid",
-			"nr_scanned", "nr_reclaimed", "priority",
-			"flags");
+			"nid", "nr_scanned", "nr_reclaimed", "nr_dirty", "nr_writeback",
+			"nr_congested", "nr_immediate", "nr_activate", "nr_ref_keep",
+			"nr_unmap_fail", "priority", "flags");
 $regex_lru_shrink_active = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_shrink_active",
 			$regex_lru_shrink_active_default,
@@ -381,8 +381,8 @@ EVENT_PROCESS:
 				next;
 			}
 			my $isolate_mode = $1;
-			my $nr_scanned = $4;
-			my $file = $6;
+			my $nr_scanned = $5;
+			my $file = $8;
 
 			# To closer match vmstat scanning statistics, only count isolate_both
 			# and isolate_inactive as scanning. isolate_active is rotation
@@ -391,7 +391,7 @@ EVENT_PROCESS:
 			# isolate_both     == 3
 			if ($isolate_mode != 2) {
 				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
-				if ($file == 1) {
+				if ($file =~ /_file/) {
 					$perprocesspid{$process_pid}->{HIGH_NR_FILE_SCANNED} += $nr_scanned;
 				} else {
 					$perprocesspid{$process_pid}->{HIGH_NR_ANON_SCANNED} += $nr_scanned;
@@ -406,8 +406,8 @@ EVENT_PROCESS:
 				next;
 			}
 
-			my $nr_reclaimed = $4;
-			my $flags = $6;
+			my $nr_reclaimed = $3;
+			my $flags = $12;
 			my $file = 0;
 			if ($flags =~ /RECLAIM_WB_FILE/) {
 				$file = 1;
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

