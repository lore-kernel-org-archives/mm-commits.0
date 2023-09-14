Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA453EEAA5D
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbjINSSj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjINSSi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:18:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81411FD7
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:18:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86512C433C8;
        Thu, 14 Sep 2023 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694715514;
        bh=eTu79z6yKfNn8NDEIpqOxIs6c4NlGjUnXrcuiHJVtV8=;
        h=Date:To:From:Subject:From;
        b=0wxf5c6YdlT6rMWDOXQqOsqRFP0et38Qv24Tft8LqCLSfOQ5bqI8Q0hgcPFTerUZA
         oEYyOx07a8IgrmnovSNdAvOGv6zRPb2kDUorOqG2lDKpjHStpMotP43e7BR+sBH/dj
         1csYpU/WaQWVKiUYjfQCCXbdjZfOPKu6ZSIh6dMA=
Date:   Thu, 14 Sep 2023 11:18:33 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        hughd@google.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-isolate_unmapped.patch added to mm-unstable branch
Message-Id: <20230914181834.86512C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: remove ISOLATE_UNMAPPED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-remove-isolate_unmapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-isolate_unmapped.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1714,8 +1714,7 @@ move:
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

trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-remove-isolate_unmapped.patch

