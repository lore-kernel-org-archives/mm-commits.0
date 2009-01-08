From: akpm@linux-foundation.org
Subject: - memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:41 -0800
Message-ID: <200901082249.n08MnfBL028934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbZAHW6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: change try_to_free_pages to hierarchical_reclaim
has been removed from the -mm tree.  Its filename was
     memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: change try_to_free_pages to hierarchical_reclaim
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_hierarchicl_reclaim() works properly even when !use_hierarchy
now (by memcg-hierarchy-avoid-unnecessary-reclaim.patch), so, instead of
try_to_free_mem_cgroup_pages(), it should be used in many cases.

The only exception is force_empty.  The group has no children in this
case.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-change-try_to_free_pages-to-hierarchical_reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-try_to_free_pages-to-hierarchical_reclaim
+++ a/mm/memcontrol.c
@@ -1430,8 +1430,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 	rcu_read_unlock();
 
 	do {
-		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true,
-							get_swappiness(mem));
+		progress = mem_cgroup_hierarchical_reclaim(mem, gfp_mask, true);
 		progress += mem_cgroup_check_under_limit(mem);
 	} while (!progress && --retry);
 
@@ -1475,10 +1474,8 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		progress = try_to_free_mem_cgroup_pages(memcg,
-							GFP_KERNEL,
-							false,
-							get_swappiness(memcg));
+		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
+							   false);
   		if (!progress)			retry_count--;
 	}
 
@@ -1519,8 +1516,7 @@ int mem_cgroup_resize_memsw_limit(struct
 			break;
 
 		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
-		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true,
-					     get_swappiness(memcg));
+		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		if (curusage >= oldusage)
 			retry_count--;
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

