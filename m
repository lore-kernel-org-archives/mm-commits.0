From: akpm@linux-foundation.org
Subject: [merged] mm-fix-a-vmscan-warning.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:33 -0700
Message-ID: <201108261903.p7QJ3H2b005669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab1HZTDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix a vmscan warning
has been removed from the -mm tree.  Its filename was
     mm-fix-a-vmscan-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix a vmscan warning
From: Shaohua Li <shaohua.li@intel.com>

I get below warnning:
BUG: using smp_processor_id() in preemptible [00000000] code: bash/746
caller is native_sched_clock+0x37/0x6e
Pid: 746, comm: bash Tainted: G        W   3.0.0+ #254
Call Trace:
 [<ffffffff813435c6>] debug_smp_processor_id+0xc2/0xdc
 [<ffffffff8104158d>] native_sched_clock+0x37/0x6e
 [<ffffffff81116219>] try_to_free_mem_cgroup_pages+0x7d/0x270
 [<ffffffff8114f1f8>] mem_cgroup_force_empty+0x24b/0x27a
 [<ffffffff8114ff21>] ? sys_close+0x38/0x138
 [<ffffffff8114ff21>] ? sys_close+0x38/0x138
 [<ffffffff8114f257>] mem_cgroup_force_empty_write+0x17/0x19
 [<ffffffff810c72fb>] cgroup_file_write+0xa8/0xba
 [<ffffffff811522d2>] vfs_write+0xb3/0x138
 [<ffffffff8115241a>] sys_write+0x4a/0x71
 [<ffffffff8114ffd9>] ? sys_close+0xf0/0x138
 [<ffffffff8176deab>] system_call_fastpath+0x16/0x1b

sched_clock() can't be used with preempt enabled.  And we don't need fast
approach to get clock here, so let's use ktime API.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-fix-a-vmscan-warning mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-a-vmscan-warning
+++ a/mm/vmscan.c
@@ -2283,7 +2283,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.mem_cgroup = mem,
 		.memcg_record = rec,
 	};
-	unsigned long start, end;
+	ktime_t start, end;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -2292,7 +2292,7 @@ unsigned long mem_cgroup_shrink_node_zon
 						      sc.may_writepage,
 						      sc.gfp_mask);
 
-	start = sched_clock();
+	start = ktime_get();
 	/*
 	 * NOTE: Although we can get the priority field, using it
 	 * here is not a good idea, since it limits the pages we can scan.
@@ -2301,10 +2301,10 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * the priority and make it zero.
 	 */
 	shrink_zone(0, zone, &sc);
-	end = sched_clock();
+	end = ktime_get();
 
 	if (rec)
-		rec->elapsed += end - start;
+		rec->elapsed += ktime_to_ns(ktime_sub(end, start));
 	*scanned = sc.nr_scanned;
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
@@ -2319,7 +2319,7 @@ unsigned long try_to_free_mem_cgroup_pag
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
-	unsigned long start, end;
+	ktime_t start, end;
 	int nid;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
@@ -2337,7 +2337,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.gfp_mask = sc.gfp_mask,
 	};
 
-	start = sched_clock();
+	start = ktime_get();
 	/*
 	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
 	 * take care of from where we get pages. So the node where we start the
@@ -2352,9 +2352,9 @@ unsigned long try_to_free_mem_cgroup_pag
 					    sc.gfp_mask);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
-	end = sched_clock();
+	end = ktime_get();
 	if (rec)
-		rec->elapsed += end - start;
+		rec->elapsed += ktime_to_ns(ktime_sub(end, start));
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
vmscan-add-block-plug-for-page-reclaim.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

