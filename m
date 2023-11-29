Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B95C10DAA
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 17:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjK2Rw3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 12:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjK2Rw2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 12:52:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087E6B9
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 09:52:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA91C433C8;
        Wed, 29 Nov 2023 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701280352;
        bh=PrFDVNhDb+DOiwbwmKOS/zYtBKmFon1Ms8jC7f7x9Zg=;
        h=Date:To:From:Subject:From;
        b=Z/UKGTZ2aWJCfQ0SifUFI3yD6/SR/nASmPOXZKZxym0NIsP326yFpaMIillUVUVIY
         5JC5+iBH9CZOeTZRcgNIOXdO1lkuu6/aJz85TFtq7mwRpLc7vuqEDWwSkSw+H0JOxz
         enW3AsXq4nuR+j9RBvxjVhbeU9JCLwRCG+Zz0vvs=
Date:   Wed, 29 Nov 2023 09:52:31 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        rostedt@goodmis.org, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@suse.com, mhiramat@kernel.org,
        hannes@cmpxchg.org, ddrokosov@salutedevices.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints.patch removed from -mm tree
Message-Id: <20231129175232.8EA91C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: print out cgroup ino in the memcg tracepoints
has been removed from the -mm tree.  Its filename was
     mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: mm: memcg: print out cgroup ino in the memcg tracepoints
Date: Thu, 23 Nov 2023 22:39:36 +0300

Patch series "mm: memcg: improve vmscan tracepoints", v3.

The motivation behind this commit is to enhance the traceability and
understanding of memcg events.  By integrating the function cgroup_ino()
into the existing memcg tracepoints, this patch series introduces a new
tracepoint template for the begin() and end() events.  It utilizes a new
entry field ino to store the cgroup ino, enabling developers to easily
identify the cgroup associated with a specific memcg tracepoint event. 

Additionally, this patch series introduces new shrink_memcg tracepoints to
facilitate non-direct memcg reclaim tracing and debugging.  


This patch (of 2):

Sometimes, it becomes necessary to determine the memcg tracepoint event
that has occurred.  This is particularly relevant in scenarios involving a
large cgroup hierarchy, where users may wish to trace the process of
reclamation within a specific cgroup(s) by applying a filter.

The function cgroup_ino() is a useful tool for this purpose.  To integrate
cgroup_ino() into the existing memcg tracepoints, this patch introduces a
new tracepoint template for the begin() and end() events.

Link: https://lkml.kernel.org/r/20231123193937.11628-1-ddrokosov@salutedevices.com
Link: https://lkml.kernel.org/r/20231123193937.11628-2-ddrokosov@salutedevices.com
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

 include/trace/events/vmscan.h |   73 ++++++++++++++++++++++++++------
 mm/vmscan.c                   |   10 ++--
 2 files changed, 66 insertions(+), 17 deletions(-)

--- a/include/trace/events/vmscan.h~mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -141,19 +141,45 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_be
 );
 
 #ifdef CONFIG_MEMCG
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+DECLARE_EVENT_CLASS(mm_vmscan_memcg_reclaim_begin_template,
 
-	TP_ARGS(order, gfp_flags)
+	TP_PROTO(int order, gfp_t gfp_flags, const struct mem_cgroup *memcg),
+
+	TP_ARGS(order, gfp_flags, memcg),
+
+	TP_STRUCT__entry(
+		__field(int, order)
+		__field(unsigned long, gfp_flags)
+		__field(ino_t, ino)
+	),
+
+	TP_fast_assign(
+		__entry->order = order;
+		__entry->gfp_flags = (__force unsigned long)gfp_flags;
+		__entry->ino = cgroup_ino(memcg->css.cgroup);
+	),
+
+	TP_printk("order=%d gfp_flags=%s memcg=%ld",
+		__entry->order,
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->ino)
 );
 
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(int order, gfp_t gfp_flags, const struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(order, gfp_flags, memcg)
 );
+
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
+
+	TP_PROTO(int order, gfp_t gfp_flags, const struct mem_cgroup *memcg),
+
+	TP_ARGS(order, gfp_flags, memcg)
+);
+
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -181,19 +207,42 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_en
 );
 
 #ifdef CONFIG_MEMCG
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+DECLARE_EVENT_CLASS(mm_vmscan_memcg_reclaim_end_template,
 
-	TP_ARGS(nr_reclaimed)
+	TP_PROTO(unsigned long nr_reclaimed, const struct mem_cgroup *memcg),
+
+	TP_ARGS(nr_reclaimed, memcg),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, nr_reclaimed)
+		__field(ino_t, ino)
+	),
+
+	TP_fast_assign(
+		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->ino = cgroup_ino(memcg->css.cgroup);
+	),
+
+	TP_printk("nr_reclaimed=%lu memcg=%ld",
+		__entry->nr_reclaimed,
+		__entry->ino)
 );
 
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, const struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
+
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
+
+	TP_PROTO(unsigned long nr_reclaimed, const struct mem_cgroup *memcg),
+
+	TP_ARGS(nr_reclaimed, memcg)
+);
+
 #endif /* CONFIG_MEMCG */
 
 TRACE_EVENT(mm_shrink_slab_start,
--- a/mm/vmscan.c~mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints
+++ a/mm/vmscan.c
@@ -6415,8 +6415,8 @@ unsigned long mem_cgroup_shrink_node(str
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.gfp_mask);
+	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order, sc.gfp_mask,
+						      memcg);
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -6427,7 +6427,7 @@ unsigned long mem_cgroup_shrink_node(str
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -6461,13 +6461,13 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, memcg);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
_

Patches currently in -mm which might be from ddrokosov@salutedevices.com are

mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch
samples-introduce-new-samples-subdir-for-cgroup.patch
samples-cgroup-introduce-memcg-memoryevents-listener.patch
mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

