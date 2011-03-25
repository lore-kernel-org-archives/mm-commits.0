From: akpm@linux-foundation.org
Subject: [merged] memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:51 -0700
Message-ID: <201103250724.p2P7OjgW025954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933773Ab1CYHYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: charged pages always have valid per-memcg zone info
has been removed from the -mm tree.  Its filename was
     memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: charged pages always have valid per-memcg zone info
From: Johannes Weiner <hannes@cmpxchg.org>

page_cgroup_zoneinfo() will never return NULL for a charged page, remove
the check for it in mem_cgroup_get_reclaim_stat_from_page().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-charged-pages-always-have-valid-per-memcg-zone-info mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-charged-pages-always-have-valid-per-memcg-zone-info
+++ a/mm/memcontrol.c
@@ -1043,9 +1043,6 @@ mem_cgroup_get_reclaim_stat_from_page(st
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	if (!mz)
-		return NULL;
