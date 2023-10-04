Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F85FE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244858AbjJDUW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244944AbjJDUW3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41C4173B
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378BDC433C7;
        Wed,  4 Oct 2023 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450903;
        bh=cJMQavWUG2WBRE1mztWS9xOI8Ss9JmztjQzfpImPlnI=;
        h=Date:To:From:Subject:From;
        b=bHxavLsaDnMP9AZbi7j08K6vwgHXFuJw+5Ne21/DCqPPPHXyHQuDks732AvocbS7K
         /uooJ1JLuHRO8Ab2d6prxu7y0HXQTeUSg3k5++aikqanxLHB+DG0ReMtgjnXVSQtvA
         LwTJuX3W0uFOgHLPf9MgsQr/A0KXB/r2ZYH2bGm0=
Date:   Wed, 04 Oct 2023 13:21:41 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        hughd@google.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-isolate_unmapped.patch removed from -mm tree
Message-Id: <20231004202143.378BDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, vmscan: remove ISOLATE_UNMAPPED
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-isolate_unmapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, vmscan: remove ISOLATE_UNMAPPED
Date: Thu, 14 Sep 2023 15:16:39 +0200

This isolate_mode_t flag is effectively unused since 89f6c88a6ab4 ("mm:
__isolate_lru_page_prepare() in isolate_migratepages_block()") as
sc->may_unmap is now checked directly (and only node_reclaim has a mode
that sets it to 0).  The last remaining place is mm_vmscan_lru_isolate
tracepoint for the isolate_mode parameter.  That one was mainly used to
indicate the active/inactive mode, which the trace-vmscan-postprocess.pl
script consumed, but that got silently broken.  After fixing the script by
the previous patch, it does not need the isolate_mode anymore.  So just
remove the parameter and with that the whole ISOLATE_UNMAPPED flag.

Link: https://lkml.kernel.org/r/20230914131637.12204-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |    8 ++++----
 include/linux/mmzone.h                                      |    2 --
 include/trace/events/vmscan.h                               |    8 ++------
 mm/vmscan.c                                                 |    3 +--
 4 files changed, 7 insertions(+), 14 deletions(-)

--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-remove-isolate_unmapped
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -112,7 +112,7 @@ my $regex_direct_end_default = 'nr_recla
 my $regex_kswapd_wake_default = 'nid=([0-9]*) order=([0-9]*)';
 my $regex_kswapd_sleep_default = 'nid=([0-9]*)';
 my $regex_wakeup_kswapd_default = 'nid=([0-9]*) order=([0-9]*) gfp_flags=([A-Z_|]*)';
-my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) classzone=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_skipped=([0-9]*) nr_taken=([0-9]*) lru=([a-z_]*)';
+my $regex_lru_isolate_default = 'classzone=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_skipped=([0-9]*) nr_taken=([0-9]*) lru=([a-z_]*)';
 my $regex_lru_shrink_inactive_default = 'nid=([0-9]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) nr_dirty=([0-9]*) nr_writeback=([0-9]*) nr_congested=([0-9]*) nr_immediate=([0-9]*) nr_activate_anon=([0-9]*) nr_activate_file=([0-9]*) nr_ref_keep=([0-9]*) nr_unmap_fail=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)';
 my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_taken=([0-9]*) nr_active=([0-9]*) nr_deactivated=([0-9]*) nr_referenced=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)' ;
 my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) flags=([A-Z_|]*)';
@@ -204,7 +204,7 @@ $regex_wakeup_kswapd = generate_traceeve
 $regex_lru_isolate = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_isolate",
 			$regex_lru_isolate_default,
-			"isolate_mode", classzone", "order",
+			"classzone", "order",
 			"nr_requested", "nr_scanned", "nr_skipped", "nr_taken",
 			"lru");
 $regex_lru_shrink_inactive = generate_traceevent_regex(
@@ -379,8 +379,8 @@ EVENT_PROCESS:
 				print "         $regex_lru_isolate/o\n";
 				next;
 			}
-			my $nr_scanned = $5;
-			my $lru = $8;
+			my $nr_scanned = $4;
+			my $lru = $7;
 
 			# To closer match vmstat scanning statistics, only count
 			# inactive lru as scanning
--- a/include/linux/mmzone.h~mm-vmscan-remove-isolate_unmapped
+++ a/include/linux/mmzone.h
@@ -639,8 +639,6 @@ struct lruvec {
 #endif
 };
 
-/* Isolate unmapped pages */
-#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
 #define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x4)
 /* Isolate unevictable pages */
--- a/include/trace/events/vmscan.h~mm-vmscan-remove-isolate_unmapped
+++ a/include/trace/events/vmscan.h
@@ -285,10 +285,9 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		unsigned long nr_scanned,
 		unsigned long nr_skipped,
 		unsigned long nr_taken,
-		isolate_mode_t isolate_mode,
 		int lru),
 
-	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, isolate_mode, lru),
+	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
 
 	TP_STRUCT__entry(
 		__field(int, highest_zoneidx)
@@ -297,7 +296,6 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
-		__field(unsigned int, isolate_mode)
 		__field(int, lru)
 	),
 
@@ -308,7 +306,6 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
-		__entry->isolate_mode = (__force unsigned int)isolate_mode;
 		__entry->lru = lru;
 	),
 
@@ -316,8 +313,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 	 * classzone is previous name of the highest_zoneidx.
 	 * Reason not to change it is the ABI requirement of the tracepoint.
 	 */
-	TP_printk("isolate_mode=%d classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_skipped=%lu nr_taken=%lu lru=%s",
-		__entry->isolate_mode,
+	TP_printk("classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_skipped=%lu nr_taken=%lu lru=%s",
 		__entry->highest_zoneidx,
 		__entry->order,
 		__entry->nr_requested,
--- a/mm/vmscan.c~mm-vmscan-remove-isolate_unmapped
+++ a/mm/vmscan.c
@@ -1689,8 +1689,7 @@ move:
 	}
 	*nr_scanned = total_scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				    total_scan, skipped, nr_taken,
-				    sc->may_unmap ? 0 : ISOLATE_UNMAPPED, lru);
+				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are


