From: akpm@linux-foundation.org
Subject: [merged] memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:29 -0700
Message-ID: <201103250724.p2P7ONPn025854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933863Ab1CYHYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: soft limit reclaim should end at limit not below
has been removed from the -mm tree.  Its filename was
     memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: soft limit reclaim should end at limit not below
From: Johannes Weiner <hannes@cmpxchg.org>

Soft limit reclaim continues until the usage is below the current soft
limit, but the documented semantics are actually that soft limit reclaim
will push usage back until the soft limits are met again.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    4 ++--
 mm/memcontrol.c             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/res_counter.h~memcg-soft-limit-reclaim-should-end-at-limit-not-below include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-soft-limit-reclaim-should-end-at-limit-not-below
+++ a/include/linux/res_counter.h
@@ -139,7 +139,7 @@ static inline bool res_counter_limit_che
 
 static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
 {
-	if (cnt->usage < cnt->soft_limit)
+	if (cnt->usage <= cnt->soft_limit)
 		return true;
 
 	return false;
@@ -202,7 +202,7 @@ static inline bool res_counter_check_mar
 	return ret;
 }
 
-static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
+static inline bool res_counter_check_within_soft_limit(struct res_counter *cnt)
 {
 	bool ret;
 	unsigned long flags;
diff -puN mm/memcontrol.c~memcg-soft-limit-reclaim-should-end-at-limit-not-below mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-soft-limit-reclaim-should-end-at-limit-not-below
+++ a/mm/memcontrol.c
@@ -1477,7 +1477,7 @@ static int mem_cgroup_hierarchical_recla
 			return ret;
 		total += ret;
 		if (check_soft) {
-			if (res_counter_check_under_soft_limit(&root_mem->res))
+			if (res_counter_check_within_soft_limit(&root_mem->res))
 				return total;
 		} else if (mem_cgroup_check_under_limit(root_mem))
 			return 1 + total;
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

