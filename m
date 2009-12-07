From: akpm@linux-foundation.org
Subject: + memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch added to -mm tree
Date: Mon, 07 Dec 2009 15:10:22 -0800
Message-ID: <200912072310.nB7NAMMx020499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935663AbZLGXKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 18:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: code clean, remove unused variable in mem_cgroup_resize_limit()
has been added to the -mm tree.  Its filename is
     memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: code clean, remove unused variable in mem_cgroup_resize_limit()
From: Bob Liu <lliubbo@gmail.com>

Variable `progress' isn't used in mem_cgroup_resize_limit() any more. 
Remove it.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
@@ -2355,7 +2354,7 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		progress = mem_cgroup_hierarchical_reclaim(memcg, NULL,
+		mem_cgroup_hierarchical_reclaim(memcg, NULL,
 						GFP_KERNEL,
 						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch

