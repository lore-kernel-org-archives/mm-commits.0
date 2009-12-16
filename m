From: akpm@linux-foundation.org
Subject: [merged] memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:51 -0800
Message-ID: <200912162037.nBGKbpsW013380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964812AbZLPUiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: code clean, remove unused variable in mem_cgroup_resize_limit()
has been removed from the -mm tree.  Its filename was
     memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: code clean, remove unused variable in mem_cgroup_resize_limit()
From: Bob Liu <lliubbo@gmail.com>

Variable `progress' isn't used in mem_cgroup_resize_limit() any more. 
Remove it.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit
+++ a/mm/memcontrol.c
@@ -2311,7 +2311,6 @@ static int mem_cgroup_resize_limit(struc
 				unsigned long long val)
 {
 	int retry_count;
-	int progress;
 	u64 memswlimit;
 	int ret = 0;
 	int children = mem_cgroup_count_children(memcg);
@@ -2355,8 +2354,7 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		progress = mem_cgroup_hierarchical_reclaim(memcg, NULL,
-						GFP_KERNEL,
+		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
 						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

