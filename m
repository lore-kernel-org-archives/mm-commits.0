From: akpm@linux-foundation.org
Subject: [folded] memory-controller-soft-limit-organize-cgroups-v9-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:30:26 -0700
Message-ID: <200909232230.n8NMURFi019092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbZIWWag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, balbir@linux.vnet.ibm.com, jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory controller: soft limit organize cgroups v9 fix
has been removed from the -mm tree.  Its filename was
     memory-controller-soft-limit-organize-cgroups-v9-fix.patch

This patch was dropped because it was folded into memory-controller-soft-limit-organize-cgroups-v9.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory controller: soft limit organize cgroups v9 fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_PREEMPT=y mmotm fails to boot:
Kernel panic - not syncing: No init found; after lots of scheduling
while atomics, starting from when async_thread does sd_probe_async.

mem_cgroup_soft_limit_check() was doing an unbalanced get_cpu(): don't
get_cpu if we won't need it, and put_cpu if we did get_cpu.

And fix the silliness of passing it an "over_soft_limit" argument
that just tells it to return false when false.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v9-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v9-fix
+++ a/mm/memcontrol.c
@@ -334,23 +334,21 @@ mem_cgroup_remove_exceeded(struct mem_cg
 	spin_unlock(&mctz->lock);
 }
 
-static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem,
-					bool over_soft_limit)
+static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
 {
 	bool ret = false;
-	int cpu = get_cpu();
+	int cpu;
 	s64 val;
 	struct mem_cgroup_stat_cpu *cpustat;
 
-	if (!over_soft_limit)
-		return ret;
-
+	cpu = get_cpu();
 	cpustat = &mem->stat.cpustat[cpu];
 	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
 	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
 		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
 		ret = true;
 	}
+	put_cpu();
 	return ret;
 }
 
@@ -1231,7 +1229,7 @@ static int __mem_cgroup_try_charge(struc
 	if (soft_fail_res) {
 		mem_over_soft_limit =
 			mem_cgroup_from_res_counter(soft_fail_res, res);
-		if (mem_cgroup_soft_limit_check(mem_over_soft_limit, true))
+		if (mem_cgroup_soft_limit_check(mem_over_soft_limit))
 			mem_cgroup_update_tree(mem_over_soft_limit, page);
 	}
 	return 0;
@@ -1762,7 +1760,7 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
-	if (mem_cgroup_soft_limit_check(mem, soft_limit_excess))
+	if (soft_limit_excess && mem_cgroup_soft_limit_check(mem))
 		mem_cgroup_update_tree(mem, page);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
ksm-change-default-values-to-better-fit-into-mainline-kernel.patch
hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch

