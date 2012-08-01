From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-mem_control_xxx-to-memcg_xxx.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:07 -0700
Message-ID: <20120801201408.1D5D85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63956 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:10 -0400
Received: by weyr1 with SMTP id r1so344127wey.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rename mem_control_xxx to memcg_xxx
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_control_xxx-to-memcg_xxx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: memcg: rename mem_control_xxx to memcg_xxx

Replace memory_cgroup_xxx() with memcg_xxx()

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-rename-mem_control_xxx-to-memcg_xxx mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-mem_control_xxx-to-memcg_xxx
+++ a/mm/memcontrol.c
@@ -4006,7 +4006,7 @@ static int mem_cgroup_move_charge_write(
 #endif
 
 #ifdef CONFIG_NUMA
-static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
 {
 	int nid;
@@ -4065,7 +4065,7 @@ static inline void mem_cgroup_lru_names_
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 }
 
-static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
@@ -4579,7 +4579,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "stat",
-		.read_seq_string = mem_control_stat_show,
+		.read_seq_string = memcg_stat_show,
 	},
 	{
 		.name = "force_empty",
@@ -4611,7 +4611,7 @@ static struct cftype mem_cgroup_files[] 
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.read_seq_string = mem_control_numa_stat_show,
+		.read_seq_string = memcg_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_MEMCG_SWAP
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch

