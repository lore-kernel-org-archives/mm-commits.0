From: akpm@linux-foundation.org
Subject: [merged] memcg-make-oom-less-frequently.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:32 -0800
Message-ID: <200901161917.n0GJHW0A026107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936981AbZAPTSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: make oom less frequently
has been removed from the -mm tree.  Its filename was
     memcg-make-oom-less-frequently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make oom less frequently
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

In previous implementation, mem_cgroup_try_charge checked the return
value of mem_cgroup_try_to_free_pages, and just retried if some pages
had been reclaimed.
But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
only checks whether the usage is less than the limit.

This patch tries to change the behavior as before to cause oom less
frequently.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-oom-less-frequently mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-oom-less-frequently
+++ a/mm/memcontrol.c
@@ -773,10 +773,10 @@ static int mem_cgroup_hierarchical_recla
 	 * but there might be left over accounting, even after children
 	 * have left.
 	 */
-	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
+	ret += try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
 					   get_swappiness(root_mem));
 	if (mem_cgroup_check_under_limit(root_mem))
-		return 0;
+		return 1;	/* indicate reclaim has succeeded */
 	if (!root_mem->use_hierarchy)
 		return ret;
 
@@ -787,10 +787,10 @@ static int mem_cgroup_hierarchical_recla
 			next_mem = mem_cgroup_get_next_node(root_mem);
 			continue;
 		}
-		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
+		ret += try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
 						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
-			return 0;
+			return 1;	/* indicate reclaim has succeeded */
 		next_mem = mem_cgroup_get_next_node(root_mem);
 	}
 	return ret;
@@ -875,6 +875,8 @@ static int __mem_cgroup_try_charge(struc
 
 		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
 							noswap);
+		if (ret)
+			continue;
 
 		/*
 		 * try_to_free_mem_cgroup_pages() might not give us a full
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-get-put-parents-at-create-free.patch

