Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE065C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 17:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjK2Rw3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 12:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjK2Rw2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 12:52:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A7ECA
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 09:52:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25D8C433C9;
        Wed, 29 Nov 2023 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701280353;
        bh=YOIaRSyjfhDGgdqf1LK2n3/BNr3kvrIT7eT9FgT2S58=;
        h=Date:To:From:Subject:From;
        b=XIkm5Hu/vIL57oj7OvEJ8A0wp8aMVd+02hoDeiRPbRVU0ayvy5r33bXpCn152nhzh
         wJadqtKhDepVf7o/owa/UHRECmWy8c/0NpVcvDROeXY493ER5CCYz6/OQtVo1wuecY
         gsWpIi34/4Cf0I1S4STPfHF31Zi75Iy66FxpxLBg=
Date:   Wed, 29 Nov 2023 09:52:33 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        rostedt@goodmis.org, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@suse.com, mhiramat@kernel.org,
        hannes@cmpxchg.org, ddrokosov@salutedevices.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch removed from -mm tree
Message-Id: <20231129175233.C25D8C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: introduce new event to trace shrink_memcg
has been removed from the -mm tree.  Its filename was
     mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: mm: memcg: introduce new event to trace shrink_memcg
Date: Thu, 23 Nov 2023 22:39:37 +0300

The shrink_memcg flow plays a crucial role in memcg reclamation. 
Currently, it is not possible to trace this point from non-direct reclaim
paths.  However, direct reclaim has its own tracepoint, so there is no
issue there.  In certain cases, when debugging memcg pressure, developers
may need to identify all potential requests for memcg reclamation
including kswapd().  The patchset introduces the tracepoints
mm_vmscan_memcg_shrink_{begin|end}() to address this problem.

Example of output in the kswapd context (non-direct reclaim):
    kswapd0-39      [001] .....   240.356378: mm_vmscan_memcg_shrink_begin: order=0 gfp_flags=GFP_KERNEL memcg=16
    kswapd0-39      [001] .....   240.356396: mm_vmscan_memcg_shrink_end: nr_reclaimed=0 memcg=16
    kswapd0-39      [001] .....   240.356420: mm_vmscan_memcg_shrink_begin: order=0 gfp_flags=GFP_KERNEL memcg=16
    kswapd0-39      [001] .....   240.356454: mm_vmscan_memcg_shrink_end: nr_reclaimed=1 memcg=16
    kswapd0-39      [001] .....   240.356479: mm_vmscan_memcg_shrink_begin: order=0 gfp_flags=GFP_KERNEL memcg=16
    kswapd0-39      [001] .....   240.356506: mm_vmscan_memcg_shrink_end: nr_reclaimed=4 memcg=16
    kswapd0-39      [001] .....   240.356525: mm_vmscan_memcg_shrink_begin: order=0 gfp_flags=GFP_KERNEL memcg=16
    kswapd0-39      [001] .....   240.356593: mm_vmscan_memcg_shrink_end: nr_reclaimed=11 memcg=16
    kswapd0-39      [001] .....   240.356614: mm_vmscan_memcg_shrink_begin: order=0 gfp_flags=GFP_KERNEL memcg=16
    kswapd0-39      [001] .....   240.356738: mm_vmscan_memcg_shrink_end: nr_reclaimed=25 memcg=16
    kswapd0-39      [001] .....   240.356790: mm_vmscan_memcg_shrink_begin: order=0 gfp_flags=GFP_KERNEL memcg=16
    kswapd0-39      [001] .....   240.357125: mm_vmscan_memcg_shrink_end: nr_reclaimed=53 memcg=16

Link: https://lkml.kernel.org/r/20231123193937.11628-3-ddrokosov@salutedevices.com
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   22 ++++++++++++++++++++++
 mm/vmscan.c                   |    7 +++++++
 2 files changed, 29 insertions(+)

--- a/include/trace/events/vmscan.h~mm-memcg-introduce-new-event-to-trace-shrink_memcg
+++ a/include/trace/events/vmscan.h
@@ -180,6 +180,17 @@ DEFINE_EVENT(mm_vmscan_memcg_reclaim_beg
 	TP_ARGS(order, gfp_flags, memcg)
 );
 
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_begin_template, mm_vmscan_memcg_shrink_begin,
+
+	TP_PROTO(int order, gfp_t gfp_flags, const struct mem_cgroup *memcg),
+
+	TP_ARGS(order, gfp_flags, memcg)
+);
+
+#else
+
+#define trace_mm_vmscan_memcg_shrink_begin(...)
+
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -243,6 +254,17 @@ DEFINE_EVENT(mm_vmscan_memcg_reclaim_end
 	TP_ARGS(nr_reclaimed, memcg)
 );
 
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_end_template, mm_vmscan_memcg_shrink_end,
+
+	TP_PROTO(unsigned long nr_reclaimed, const struct mem_cgroup *memcg),
+
+	TP_ARGS(nr_reclaimed, memcg)
+);
+
+#else
+
+#define trace_mm_vmscan_memcg_shrink_end(...)
+
 #endif /* CONFIG_MEMCG */
 
 TRACE_EVENT(mm_shrink_slab_start,
--- a/mm/vmscan.c~mm-memcg-introduce-new-event-to-trace-shrink_memcg
+++ a/mm/vmscan.c
@@ -5788,6 +5788,10 @@ static void shrink_node_memcgs(pg_data_t
 		 */
 		cond_resched();
 
+		trace_mm_vmscan_memcg_shrink_begin(sc->order,
+						   sc->gfp_mask,
+						   memcg);
+
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
 		if (mem_cgroup_below_min(target_memcg, memcg)) {
@@ -5818,6 +5822,9 @@ static void shrink_node_memcgs(pg_data_t
 		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
 			    sc->priority);
 
+		trace_mm_vmscan_memcg_shrink_end(sc->nr_reclaimed - reclaimed,
+						 memcg);
+
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
 			vmpressure(sc->gfp_mask, memcg, false,
_

Patches currently in -mm which might be from ddrokosov@salutedevices.com are

samples-introduce-new-samples-subdir-for-cgroup.patch
samples-cgroup-introduce-memcg-memoryevents-listener.patch
mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

