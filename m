From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-null-check-from-lookup_page_cgroup-result.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:37 -0700
Message-ID: <201103250724.p2P7OVRS025866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab1CYHYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: remove NULL check from lookup_page_cgroup() result
has been removed from the -mm tree.  Its filename was
     memcg-remove-null-check-from-lookup_page_cgroup-result.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove NULL check from lookup_page_cgroup() result
From: Johannes Weiner <hannes@cmpxchg.org>

The page_cgroup array is set up before even fork is initialized.  I
seriously doubt that this code executes before the array is alloc'd.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-null-check-from-lookup_page_cgroup-result mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-null-check-from-lookup_page_cgroup-result
+++ a/mm/memcontrol.c
@@ -2369,10 +2369,7 @@ static int mem_cgroup_charge_common(stru
 	}
 
 	pc = lookup_page_cgroup(page);
-	/* can happen at boot */
-	if (unlikely(!pc))
-		return 0;
-	prefetchw(pc);
+	BUG_ON(!pc); /* XXX: remove this and move pc lookup into commit */
 
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
 	if (ret || !mem)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

