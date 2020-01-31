From: akpm@linux-foundation.org
Subject: [-]
 mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints.patch removed
 from -mm tree
Date: Thu, 30 Jan 2020 20:24:27 -0800
Message-ID: <20200131042427.gXjcyEh1p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgAaEYa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Jan 2020 23:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, shaoyafang@didiglobal.com


The patch titled
     Subject: mm/vmscan: expose cgroup_ino for memcg reclaim tracepoints
has been removed from the -mm tree.  Its filename was
     mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints.patch

This patch was dropped because lack of interest

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/vmscan: expose cgroup_ino for memcg reclaim tracepoints

We can use the exposed cgroup_ino to trace specified cgroup.

For example,
step 1, get the inode of the specified cgroup
	$ ls -di /tmp/cgroupv2/foo
step 2, set this inode into tracepoint filter to trace this cgroup only
	(assume the inode is 11)
	$ cd /sys/kernel/debug/tracing/events/vmscan/
	$ echo 'cgroup_ino == 11' > mm_vmscan_memcg_reclaim_begin/filter
	$ echo 'cgroup_ino == 11' > mm_vmscan_memcg_reclaim_end/filter

The reason I made this change is to trace a specific container.

Sometimes there're lots of containers on one host.  Some of them are
not important at all, so we don't care whether them are under memory
pressure.  While some of them are important, so we want't to know if
these containers are doing memcg reclaim and how long this relaim
takes.

Without this change, we don't know the memcg reclaim happend in which
container.

Link: http://lkml.kernel.org/r/1557649528-11676-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <shaoyafang@didiglobal.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   71 ++++++++++++++++++++++++++------
 mm/vmscan.c                   |   18 +++++---
 2 files changed, 72 insertions(+), 17 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -127,18 +127,43 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_be
 );
 
 #ifdef CONFIG_MEMCG
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
+DECLARE_EVENT_CLASS(mm_vmscan_memcg_reclaim_begin_template,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(unsigned int cgroup_ino, int order, gfp_t gfp_flags),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(cgroup_ino, order, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cgroup_ino)
+		__field(int, order)
+		__field(gfp_t, gfp_flags)
+	),
+
+	TP_fast_assign(
+		__entry->cgroup_ino	= cgroup_ino;
+		__entry->order		= order;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("cgroup_ino=%u order=%d gfp_flags=%s",
+		__entry->cgroup_ino, __entry->order,
+		show_gfp_flags(__entry->gfp_flags))
 );
 
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_begin_template,
+	     mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(unsigned int cgroup_ino, int order, gfp_t gfp_flags),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(cgroup_ino, order, gfp_flags)
+);
+
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_begin_template,
+	     mm_vmscan_memcg_softlimit_reclaim_begin,
+
+	TP_PROTO(unsigned int cgroup_ino, int order, gfp_t gfp_flags),
+
+	TP_ARGS(cgroup_ino, order, gfp_flags)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -167,18 +192,40 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_en
 );
 
 #ifdef CONFIG_MEMCG
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
+DECLARE_EVENT_CLASS(mm_vmscan_memcg_reclaim_end_template,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned int cgroup_ino, unsigned long nr_reclaimed),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(cgroup_ino, nr_reclaimed),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, cgroup_ino)
+		__field(unsigned long, nr_reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->cgroup_ino	= cgroup_ino;
+		__entry->nr_reclaimed	= nr_reclaimed;
+	),
+
+	TP_printk("cgroup_ino=%u nr_reclaimed=%lu",
+		__entry->cgroup_ino, __entry->nr_reclaimed)
 );
 
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_end_template,
+	     mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned int cgroup_ino, unsigned long nr_reclaimed),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(cgroup_ino, nr_reclaimed)
+);
+
+DEFINE_EVENT(mm_vmscan_memcg_reclaim_end_template,
+	     mm_vmscan_memcg_softlimit_reclaim_end,
+
+	TP_PROTO(unsigned int cgroup_ino, unsigned long nr_reclaimed),
+
+	TP_ARGS(cgroup_ino, nr_reclaimed)
 );
 #endif /* CONFIG_MEMCG */
 
--- a/mm/vmscan.c~mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints
+++ a/mm/vmscan.c
@@ -3316,8 +3316,10 @@ unsigned long mem_cgroup_shrink_node(str
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.gfp_mask);
+	trace_mm_vmscan_memcg_softlimit_reclaim_begin(
+					cgroup_ino(memcg->css.cgroup),
+					sc.order,
+					sc.gfp_mask);
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -3328,7 +3330,9 @@ unsigned long mem_cgroup_shrink_node(str
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(
+					cgroup_ino(memcg->css.cgroup),
+					sc.nr_reclaimed);
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -3363,7 +3367,9 @@ unsigned long try_to_free_mem_cgroup_pag
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
 
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(
+				cgroup_ino(memcg->css.cgroup),
+				0, sc.gfp_mask);
 
 	psi_memstall_enter(&pflags);
 	noreclaim_flag = memalloc_noreclaim_save();
@@ -3373,7 +3379,9 @@ unsigned long try_to_free_mem_cgroup_pag
 	memalloc_noreclaim_restore(noreclaim_flag);
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(
+				cgroup_ino(memcg->css.cgroup),
+				nr_reclaimed);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are
