Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EA4EEAA60
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbjINSSg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjINSSg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:18:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511AE1FD5
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:18:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5324C433C7;
        Thu, 14 Sep 2023 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694715512;
        bh=PA+josdgRU3z+DNLrKpCY4KcZAxRUSBGDAiRXJZkgrY=;
        h=Date:To:From:Subject:From;
        b=lwXDWEye8ETsUXBtacnx9H5h5gGKTcsBOHhqXPOgLmBK22G1Hng81svg9XUlD45HO
         CDVEgNuh6qdKzYXFVzIM6tcVELj3QSK7M9yOenJbFXIjFfQIJC3QqLRGsekN53pujm
         06U9Qe+qb+tE5qMYy4jiJATm9ue8AXjyZyJ5apo0=
Date:   Thu, 14 Sep 2023 11:18:31 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        hughd@google.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + trace-vmscan-postprocess-sync-with-tracepoints-updates.patch added to mm-unstable branch
Message-Id: <20230914181831.E5324C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: trace-vmscan-postprocess: sync with tracepoints updates
has been added to the -mm mm-unstable branch.  Its filename is
     trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

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
Subject: trace-vmscan-postprocess: sync with tracepoints updates
Date: Thu, 14 Sep 2023 15:16:38 +0200

The script has fallen behind tracepoint changes for a while, fix it up.

Most changes are mechanical (renames, removal of tracepoint parameters
that are not used by the script).  More notable change involves
mm_vmscan_lru_isolate which is relying on the isolate_mode to determine if
the inactive list is being scanned.  However the parameter currently only
indicates ISOLATE_UNMAPPED.  We can use the lru parameter instead to
determine which list is scanned, and stop checking isolate_mode.

Link: https://lkml.kernel.org/r/20230914131637.12204-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   38 ++++------
 1 file changed, 16 insertions(+), 22 deletions(-)

--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~trace-vmscan-postprocess-sync-with-tracepoints-updates
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -107,14 +107,14 @@ GetOptions(
 );
 
 # Defaults for dynamically discovered regex's
-my $regex_direct_begin_default = 'order=([0-9]*) may_writepage=([0-9]*) gfp_flags=([A-Z_|]*)';
+my $regex_direct_begin_default = 'order=([0-9]*) gfp_flags=([A-Z_|]*)';
 my $regex_direct_end_default = 'nr_reclaimed=([0-9]*)';
 my $regex_kswapd_wake_default = 'nid=([0-9]*) order=([0-9]*)';
 my $regex_kswapd_sleep_default = 'nid=([0-9]*)';
-my $regex_wakeup_kswapd_default = 'nid=([0-9]*) zid=([0-9]*) order=([0-9]*) gfp_flags=([A-Z_|]*)';
-my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) classzone_idx=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_skipped=([0-9]*) nr_taken=([0-9]*) lru=([a-z_]*)';
+my $regex_wakeup_kswapd_default = 'nid=([0-9]*) order=([0-9]*) gfp_flags=([A-Z_|]*)';
+my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) classzone=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_skipped=([0-9]*) nr_taken=([0-9]*) lru=([a-z_]*)';
 my $regex_lru_shrink_inactive_default = 'nid=([0-9]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) nr_dirty=([0-9]*) nr_writeback=([0-9]*) nr_congested=([0-9]*) nr_immediate=([0-9]*) nr_activate_anon=([0-9]*) nr_activate_file=([0-9]*) nr_ref_keep=([0-9]*) nr_unmap_fail=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)';
-my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_rotated=([0-9]*) priority=([0-9]*)';
+my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_taken=([0-9]*) nr_active=([0-9]*) nr_deactivated=([0-9]*) nr_referenced=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)' ;
 my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) flags=([A-Z_|]*)';
 
 # Dyanically discovered regex
@@ -184,8 +184,7 @@ sub generate_traceevent_regex {
 $regex_direct_begin = generate_traceevent_regex(
 			"vmscan/mm_vmscan_direct_reclaim_begin",
 			$regex_direct_begin_default,
-			"order", "may_writepage",
-			"gfp_flags");
+			"order", "gfp_flags");
 $regex_direct_end = generate_traceevent_regex(
 			"vmscan/mm_vmscan_direct_reclaim_end",
 			$regex_direct_end_default,
@@ -201,11 +200,11 @@ $regex_kswapd_sleep = generate_traceeven
 $regex_wakeup_kswapd = generate_traceevent_regex(
 			"vmscan/mm_vmscan_wakeup_kswapd",
 			$regex_wakeup_kswapd_default,
-			"nid", "zid", "order", "gfp_flags");
+			"nid", "order", "gfp_flags");
 $regex_lru_isolate = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_isolate",
 			$regex_lru_isolate_default,
-			"isolate_mode", "classzone_idx", "order",
+			"isolate_mode", classzone", "order",
 			"nr_requested", "nr_scanned", "nr_skipped", "nr_taken",
 			"lru");
 $regex_lru_shrink_inactive = generate_traceevent_regex(
@@ -218,11 +217,10 @@ $regex_lru_shrink_inactive = generate_tr
 $regex_lru_shrink_active = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_shrink_active",
 			$regex_lru_shrink_active_default,
-			"nid", "zid",
-			"lru",
-			"nr_scanned", "nr_rotated", "priority");
+			"nid", "nr_taken", "nr_active", "nr_deactivated", "nr_referenced",
+			"priority", "flags");
 $regex_writepage = generate_traceevent_regex(
-			"vmscan/mm_vmscan_writepage",
+			"vmscan/mm_vmscan_write_folio",
 			$regex_writepage_default,
 			"page", "pfn", "flags");
 
@@ -371,7 +369,7 @@ EVENT_PROCESS:
 				print "         $regex_wakeup_kswapd\n";
 				next;
 			}
-			my $order = $3;
+			my $order = $2;
 			$perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD_PERORDER}[$order]++;
 		} elsif ($tracepoint eq "mm_vmscan_lru_isolate") {
 			$details = $6;
@@ -381,18 +379,14 @@ EVENT_PROCESS:
 				print "         $regex_lru_isolate/o\n";
 				next;
 			}
-			my $isolate_mode = $1;
 			my $nr_scanned = $5;
-			my $file = $8;
+			my $lru = $8;
 
-			# To closer match vmstat scanning statistics, only count isolate_both
-			# and isolate_inactive as scanning. isolate_active is rotation
-			# isolate_inactive == 1
-			# isolate_active   == 2
-			# isolate_both     == 3
-			if ($isolate_mode != 2) {
+			# To closer match vmstat scanning statistics, only count
+			# inactive lru as scanning
+			if ($lru =~ /inactive_/) {
 				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
-				if ($file =~ /_file/) {
+				if ($lru =~ /_file/) {
 					$perprocesspid{$process_pid}->{HIGH_NR_FILE_SCANNED} += $nr_scanned;
 				} else {
 					$perprocesspid{$process_pid}->{HIGH_NR_ANON_SCANNED} += $nr_scanned;
_

Patches currently in -mm which might be from vbabka@suse.cz are

trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-remove-isolate_unmapped.patch

