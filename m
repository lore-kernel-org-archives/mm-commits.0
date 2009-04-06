From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:40 -0700
Message-ID: <200904061934.n36JYekg011708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757444AbZDFTiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_calc_mapped_ratio()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_calc_mapped_ratio()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, mem_cgroup_calc_mapped_ratio() is unused at all.  it can be
removed and KAMEZAWA-san suggested it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ------
 mm/memcontrol.c            |   17 -----------------
 2 files changed, 23 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_calc_mapped_ratio-take2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_calc_mapped_ratio-take2
+++ a/include/linux/memcontrol.h
@@ -88,7 +88,6 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-extern int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem);
 extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
 
 extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
@@ -211,11 +210,6 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem)
 {
 	return 0;
diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_calc_mapped_ratio-take2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_calc_mapped_ratio-take2
+++ a/mm/memcontrol.c
@@ -508,23 +508,6 @@ int task_in_mem_cgroup(struct task_struc
 }
 
 /*
- * Calculate mapped_ratio under memory controller. This will be used in
- * vmscan.c for deteremining we have to reclaim mapped pages.
- */
-int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
-{
-	long total, rss;
-
-	/*
-	 * usage is recorded in bytes. But, here, we assume the number of
-	 * physical pages can be represented by "long" on any arch.
-	 */
-	total = (long) (mem->res.usage >> PAGE_SHIFT) + 1L;
-	rss = (long)mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
-	return (int)((rss * 100L) / total);
-}
