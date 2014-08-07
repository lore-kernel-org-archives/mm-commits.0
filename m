From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:37 -0700
Message-ID: <53e3dbd5.whIFC8wGzDL9ZEPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46736 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:38 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so612808qaq.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove ordering between pc->mem_cgroup and PageCgroupUsed
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove ordering between pc->mem_cgroup and PageCgroupUsed

There is a write barrier between setting pc->mem_cgroup and
PageCgroupUsed, which was added to allow LRU operations to lookup the
memcg LRU list of a page without acquiring the page_cgroup lock.

But ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new rule"),
pages are ensured to be off-LRU while charging, so nobody else is changing
LRU state while pc->mem_cgroup is being written, and there are no read
barriers anymore.

Remove the unnecessary write barrier.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused
+++ a/mm/memcontrol.c
@@ -2795,14 +2795,6 @@ static void __mem_cgroup_commit_charge(s
 	}
 
 	pc->mem_cgroup = memcg;
-	/*
-	 * We access a page_cgroup asynchronously without lock_page_cgroup().
-	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
-	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
-	 * before USED bit, we need memory barrier here.
-	 * See mem_cgroup_add_lru_list(), etc.
-	 */
-	smp_wmb();
 	SetPageCgroupUsed(pc);
 
 	if (lrucare) {
@@ -3483,7 +3475,6 @@ void mem_cgroup_split_huge_fixup(struct
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
 		pc->mem_cgroup = memcg;
-		smp_wmb();/* see __commit_charge() */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

