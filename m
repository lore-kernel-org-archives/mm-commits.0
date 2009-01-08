From: akpm@linux-foundation.org
Subject: - memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:11 -0800
Message-ID: <200901082248.n08MmBi0027557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759698AbZAHWvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: reduce size of mem_cgroup by using nr_cpu_ids
has been removed from the -mm tree.  Its filename was
     memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: reduce size of mem_cgroup by using nr_cpu_ids
From: Jan Blunck <jblunck@suse.de>

As Jan Blunck <jblunck@suse.de> pointed out, allocating per-cpu stat for
memcg to the size of NR_CPUS is not good.

This patch changes mem_cgroup's cpustat allocation not based on NR_CPUS
but based on nr_cpu_ids.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids
+++ a/mm/memcontrol.c
@@ -60,7 +60,7 @@ struct mem_cgroup_stat_cpu {
 } ____cacheline_aligned_in_smp;
 
 struct mem_cgroup_stat {
-	struct mem_cgroup_stat_cpu cpustat[NR_CPUS];
+	struct mem_cgroup_stat_cpu cpustat[0];
 };
 
 /*
@@ -129,11 +129,10 @@ struct mem_cgroup {
 
 	int	prev_priority;	/* for recording reclaim priority */
 	/*
-	 * statistics.
+	 * statistics. This must be placed at the end of memcg.
 	 */
 	struct mem_cgroup_stat stat;
 };
-static struct mem_cgroup init_mem_cgroup;
 
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
@@ -1293,23 +1292,30 @@ static void free_mem_cgroup_per_zone_inf
 	kfree(mem->info.nodeinfo[node]);
 }
 
+static int mem_cgroup_size(void)
+{
+	int cpustat_size = nr_cpu_ids * sizeof(struct mem_cgroup_stat_cpu);
+	return sizeof(struct mem_cgroup) + cpustat_size;
+}
+
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *mem;
+	int size = mem_cgroup_size();
 
-	if (sizeof(*mem) < PAGE_SIZE)
-		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
+	if (size < PAGE_SIZE)
+		mem = kmalloc(size, GFP_KERNEL);
 	else
-		mem = vmalloc(sizeof(*mem));
+		mem = vmalloc(size);
 
 	if (mem)
-		memset(mem, 0, sizeof(*mem));
+		memset(mem, 0, size);
 	return mem;
 }
 
 static void mem_cgroup_free(struct mem_cgroup *mem)
 {
-	if (sizeof(*mem) < PAGE_SIZE)
+	if (mem_cgroup_size() < PAGE_SIZE)
 		kfree(mem);
 	else
 		vfree(mem);
@@ -1322,13 +1328,9 @@ mem_cgroup_create(struct cgroup_subsys *
 	struct mem_cgroup *mem;
 	int node;
 
-	if (unlikely((cont->parent) == NULL)) {
-		mem = &init_mem_cgroup;
-	} else {
-		mem = mem_cgroup_alloc();
-		if (!mem)
-			return ERR_PTR(-ENOMEM);
-	}
+	mem = mem_cgroup_alloc();
+	if (!mem)
+		return ERR_PTR(-ENOMEM);
 
 	res_counter_init(&mem->res);
 
@@ -1340,8 +1342,7 @@ mem_cgroup_create(struct cgroup_subsys *
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
-	if (cont->parent != NULL)
-		mem_cgroup_free(mem);
+	mem_cgroup_free(mem);
 	return ERR_PTR(-ENOMEM);
 }
 
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch

