From: akpm@linux-foundation.org
Subject: + memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:43:53 -0800
Message-ID: <200811242143.mAOLhr7Z001857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbYKXVon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d-nishimura@mtf.biglobe.ne.jp, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: fix for hierarchical reclaim
has been added to the -mm tree.  Its filename is
     memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch

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
Subject: memcg: fix for hierarchical reclaim
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>

mem_cgroup_from_res_counter should handle both mem->res and mem->memsw. 
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
