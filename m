Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED10C7EE2A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjESVkD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjESVkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA78101
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:40:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22AEE643FF
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773E6C433D2;
        Fri, 19 May 2023 21:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532400;
        bh=cgrR3APA/gyNyvxO36kKuMrnHK7pZrYW2Nphjt6MSgM=;
        h=Date:To:From:Subject:From;
        b=ml/BENW9ESYBhGTsL5OQUAtr7RF+HZH7e8Mn5LgyHEGbCZn8IuRPW8Wxj6IeBWPTH
         tg5q/jLllgp8C9AbORfaMLEGYxeNIS0OYYR/ZWPlOxRnY3n9mYeWgyvNB2dN05yXVc
         F0l4Bt5pZ7/plAhyuL+43wIP3/XD+PyOKrSEX+i0=
Date:   Fri, 19 May 2023 14:39:59 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch added to mm-unstable branch
Message-Id: <20230519214000.773E6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: remove unnecessary is_via_compact_memory() checks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: remove unnecessary is_via_compact_memory() checks
Date: Fri, 19 May 2023 14:39:58 +0200

Remove from all paths not reachable via /proc/sys/vm/compact_memory.

Link: https://lkml.kernel.org/r/20230519123959.77335-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +----------
 mm/vmscan.c     |    8 +-------
 2 files changed, 2 insertions(+), 17 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unnecessary-is_via_compact_memory-checks
+++ a/mm/compaction.c
@@ -2303,9 +2303,6 @@ bool compaction_zonelist_suitable(struct
 		unsigned long available;
 		unsigned long watermark;
 
-		if (is_via_compact_memory(order))
-			return true;
-
 		/* Allocation can already succeed, nothing to do */
 		watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (zone_watermark_ok(zone, order, watermark,
@@ -2871,9 +2868,6 @@ static bool kcompactd_node_suitable(pg_d
 		if (!populated_zone(zone))
 			continue;
 
-		if (is_via_compact_memory(pgdat->kcompactd_max_order))
-			return true;
-
 		/* Allocation can already succeed, check other zones */
 		if (zone_watermark_ok(zone, pgdat->kcompactd_max_order,
 				      min_wmark_pages(zone),
@@ -2918,9 +2912,6 @@ static void kcompactd_do_work(pg_data_t
 		if (compaction_deferred(zone, cc.order))
 			continue;
 
-		if (is_via_compact_memory(cc.order))
-			goto compact;
-
 		/* Allocation can already succeed, nothing to do */
 		if (zone_watermark_ok(zone, cc.order,
 				      min_wmark_pages(zone), zoneid, 0))
@@ -2929,7 +2920,7 @@ static void kcompactd_do_work(pg_data_t
 		if (compaction_suitable(zone, cc.order,
 					zoneid) != COMPACT_CONTINUE)
 			continue;
-compact:
+
 		if (kthread_should_stop())
 			return;
 
--- a/mm/vmscan.c~mm-compaction-remove-unnecessary-is_via_compact_memory-checks
+++ a/mm/vmscan.c
@@ -6399,9 +6399,6 @@ static inline bool should_continue_recla
 		if (!managed_zone(zone))
 			continue;
 
-		if (sc->order == -1) /* is_via_compact_memory() */
-			return false;
-
 		/* Allocation can already succeed, nothing to do */
 		if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
 				      sc->reclaim_idx, 0))
@@ -6598,9 +6595,6 @@ static inline bool compaction_ready(stru
 {
 	unsigned long watermark;
 
-	if (sc->order == -1) /* is_via_compact_memory() */
-		goto suitable;
-
 	/* Allocation can already succeed, nothing to do */
 	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
 			      sc->reclaim_idx, 0))
@@ -6610,7 +6604,7 @@ static inline bool compaction_ready(stru
 	if (compaction_suitable(zone, sc->order,
 				sc->reclaim_idx) == COMPACT_SKIPPED)
 		return false;
-suitable:
+
 	/*
 	 * Compaction is already possible, but it takes time to run and there
 	 * are potentially other callers using the pages just freed. So proceed
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

