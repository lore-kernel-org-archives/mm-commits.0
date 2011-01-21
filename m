From: akpm@linux-foundation.org
Subject: [merged] memcg-modify-accounting-function-for-supporting-thp-better.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:38 -0800
Message-ID: <201101212031.p0LKVcZ1031633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab1AUUcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: modify accounting function for supporting THP better
has been removed from the -mm tree.  Its filename was
     memcg-modify-accounting-function-for-supporting-thp-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: modify accounting function for supporting THP better
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_charge_statisics() was designed for charging a page but now, we
have transparent hugepage.  To fix problems (in following patch) it's
required to change the function to get the number of pages as its
arguments.

The new function gets following as argument.
  - type of page rather than 'pc'
  - size of page which is accounted.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~memcg-modify-accounting-function-for-supporting-thp-better mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-modify-accounting-function-for-supporting-thp-better
+++ a/mm/memcontrol.c
@@ -600,23 +600,22 @@ static void mem_cgroup_swap_statistics(s
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
-					 struct page_cgroup *pc,
-					 bool charge)
+					 bool file, int nr_pages)
 {
-	int val = (charge) ? 1 : -1;
-
 	preempt_disable();
 
-	if (PageCgroupCache(pc))
-		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], val);
+	if (file)
+		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
 	else
-		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], val);
+		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
 
-	if (charge)
+	/* pagein of a big page is an event. So, ignore page size */
+	if (nr_pages > 0)
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
 	else
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
-	__this_cpu_inc(mem->stat->count[MEM_CGROUP_EVENTS]);
+
+	__this_cpu_add(mem->stat->count[MEM_CGROUP_EVENTS], nr_pages);
 
 	preempt_enable();
 }
@@ -2115,7 +2114,7 @@ static void ____mem_cgroup_commit_charge
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, pc, true);
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), 1);
 }
 
 static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
@@ -2186,14 +2185,14 @@ static void __mem_cgroup_move_account(st
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, pc, false);
+	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -1);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
 		mem_cgroup_cancel_charge(from, PAGE_SIZE);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, pc, true);
+	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), 1);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2597,7 +2596,7 @@ __mem_cgroup_uncharge_common(struct page
 	}
 
 	for (i = 0; i < count; i++)
-		mem_cgroup_charge_statistics(mem, pc + i, false);
+		mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -1);
 
 	ClearPageCgroupUsed(pc);
 	/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch

