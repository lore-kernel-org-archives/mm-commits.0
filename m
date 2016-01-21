From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-add-sock-to-cgroup2-memorystat.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:30:09 -0800
Message-ID: <56a16a01.KslDEM242wBO1n8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add "sock" to cgroup2 memory.stat
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: add "sock" to cgroup2 memory.stat

Provide statistics on how much of a cgroup's memory footprint is made up
of socket buffers from network connections owned by the group.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++++-
 mm/memcontrol.c            |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-add-sock-to-cgroup2-memorystat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-add-sock-to-cgroup2-memorystat
+++ a/include/linux/memcontrol.h
@@ -50,6 +50,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
+	/* default hierarchy stats */
+	MEMCG_SOCK,
+	MEMCG_NR_STAT,
 };
 
 struct mem_cgroup_reclaim_cookie {
@@ -87,7 +90,7 @@ enum mem_cgroup_events_target {
 
 #ifdef CONFIG_MEMCG
 struct mem_cgroup_stat_cpu {
-	long count[MEM_CGROUP_STAT_NSTATS];
+	long count[MEMCG_NR_STAT];
 	unsigned long events[MEMCG_NR_EVENTS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
diff -puN mm/memcontrol.c~mm-memcontrol-add-sock-to-cgroup2-memorystat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-add-sock-to-cgroup2-memorystat
+++ a/mm/memcontrol.c
@@ -5128,6 +5128,8 @@ static int memory_stat_show(struct seq_f
 		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
 	seq_printf(m, "file %llu\n",
 		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+	seq_printf(m, "sock %llu\n",
+		   (u64)tree_stat(memcg, MEMCG_SOCK) * PAGE_SIZE);
 
 	seq_printf(m, "file_mapped %llu\n",
 		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) *
@@ -5631,6 +5633,8 @@ bool mem_cgroup_charge_skmem(struct mem_
 	if (in_softirq())
 		gfp_mask = GFP_NOWAIT;
 
+	this_cpu_add(memcg->stat->count[MEMCG_SOCK], nr_pages);
+
 	if (try_charge(memcg, gfp_mask, nr_pages) == 0)
 		return true;
 
@@ -5650,6 +5654,8 @@ void mem_cgroup_uncharge_skmem(struct me
 		return;
 	}
 
+	this_cpu_sub(memcg->stat->count[MEMCG_SOCK], nr_pages);
+
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	css_put_many(&memcg->css, nr_pages);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

