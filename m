From: akpm@linux-foundation.org
Subject: - memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:14:37 -0800
Message-ID: <200901072314.n07NEble031973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763514AbZAGXPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:15:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d-nishimura@mtf.biglobe.ne.jp, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.j


The patch titled
     memcg: fix for hierarchical reclaim
has been removed from the -mm tree.  Its filename was
     memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch

This patch was dropped because it was folded into memory-cgroup-hierarchical-reclaim-v4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix for hierarchical reclaim
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>

mem_cgroup_from_res_counter should handle both mem->res and mem->memsw.

When exceeding memory.memsw.limit_in_bytes, fail_res points to
mem_cgroup.memsw, not to mem_cgroup.res.  So,
mem_cgroup_hierarchical_reclaim() would be called with invalid mem_cgroup.

This bug leads to NULL pointer dereference BUG at mem_cgroup_calc_reclaim.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim
+++ a/mm/memcontrol.c
@@ -468,11 +468,8 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
-static struct mem_cgroup *
-mem_cgroup_from_res_counter(struct res_counter *counter)
-{
-	return container_of(counter, struct mem_cgroup, res);
-}
+#define mem_cgroup_from_res_counter(counter, member)	\
+	container_of(counter, struct mem_cgroup, member)
 
 /*
  * This routine finds the DFS walk successor. This routine should be
@@ -664,18 +661,16 @@ static int __mem_cgroup_try_charge(struc
 			/* mem+swap counter fails */
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			noswap = true;
-		}
+			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
+									memsw);
+		} else
+			/* mem counter fails */
+			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
+									res);
+
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		/*
-		 * Is one of our ancestors over their limit?
-		 */
-		if (fail_res)
-			mem_over_limit = mem_cgroup_from_res_counter(fail_res);
-		else
-			mem_over_limit = mem;
