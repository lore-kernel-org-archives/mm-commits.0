Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F70AC61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjKXTRJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbjKXTRJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:17:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A699C30F2
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:17:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B27C433C9;
        Fri, 24 Nov 2023 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700853435;
        bh=6azo6O/TqzQGSffGWlwVsePHxoNVoH9vPhUaCZab5/M=;
        h=Date:To:From:Subject:From;
        b=RqzFZ8+a1gC5BYHy3xkTl0+7C43yspQg/4k8jPZ5QWT8qh2kXpwuZhfiJ3j3YrWzD
         e+LGJ4i2MYlseE7Gh6VBNm4MJYS6a4h5yGUtOFeVS/39NM1gi5T6xPXaCNwlfWktvr
         TWDijjoa6R5f8U6SPfkdX0uSTymAAeScAS1KzKS8=
Date:   Fri, 24 Nov 2023 11:17:14 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        rostedt@goodmis.org, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@suse.com, mhiramat@kernel.org,
        hannes@cmpxchg.org, ddrokosov@salutedevices.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch added to mm-unstable branch
Message-Id: <20231124191715.43B27C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: introduce new event to trace shrink_memcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
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

mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints.patch
mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch

