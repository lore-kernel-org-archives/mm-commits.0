From: akpm@linux-foundation.org
Subject: [merged] memcontrol-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:11 -0800
Message-ID: <20121214232812.2BCDB200086@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47661 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2LNX2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:15 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so208696eei.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     memcontrol-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: memcontrol: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |   18 +++++++++---------
 mm/page_cgroup.c |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcontrol-use-n_memory-instead-n_high_memory mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-use-n_memory-instead-n_high_memory
+++ a/mm/memcontrol.c
@@ -800,7 +800,7 @@ static unsigned long mem_cgroup_nr_lru_p
 	int nid;
 	u64 total = 0;
 
-	for_each_node_state(nid, N_HIGH_MEMORY)
+	for_each_node_state(nid, N_MEMORY)
 		total += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
 	return total;
 }
@@ -1644,9 +1644,9 @@ static void mem_cgroup_may_update_nodema
 		return;
 
 	/* make a nodemask where this memcg uses memory from */
-	memcg->scan_nodes = node_states[N_HIGH_MEMORY];
+	memcg->scan_nodes = node_states[N_MEMORY];
 
-	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
+	for_each_node_mask(nid, node_states[N_MEMORY]) {
 
 		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
 			node_clear(nid, memcg->scan_nodes);
@@ -1717,7 +1717,7 @@ static bool mem_cgroup_reclaimable(struc
 	/*
 	 * Check rest of nodes.
 	 */
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		if (node_isset(nid, memcg->scan_nodes))
 			continue;
 		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
@@ -3776,7 +3776,7 @@ static void mem_cgroup_reparent_charges(
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
 		mem_cgroup_start_move(memcg);
-		for_each_node_state(node, N_HIGH_MEMORY) {
+		for_each_node_state(node, N_MEMORY) {
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				enum lru_list lru;
 				for_each_lru(lru) {
@@ -4122,7 +4122,7 @@ static int memcg_numa_stat_show(struct c
 
 	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
 	seq_printf(m, "total=%lu", total_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
@@ -4130,7 +4130,7 @@ static int memcg_numa_stat_show(struct c
 
 	file_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
 	seq_printf(m, "file=%lu", file_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_FILE);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
@@ -4139,7 +4139,7 @@ static int memcg_numa_stat_show(struct c
 
 	anon_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
 	seq_printf(m, "anon=%lu", anon_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_ANON);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
@@ -4148,7 +4148,7 @@ static int memcg_numa_stat_show(struct c
 
 	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
 	seq_printf(m, "unevictable=%lu", unevictable_nr);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				BIT(LRU_UNEVICTABLE));
 		seq_printf(m, " N%d=%lu", nid, node_nr);
diff -puN mm/page_cgroup.c~memcontrol-use-n_memory-instead-n_high_memory mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcontrol-use-n_memory-instead-n_high_memory
+++ a/mm/page_cgroup.c
@@ -274,7 +274,7 @@ void __init page_cgroup_init(void)
 	if (mem_cgroup_disabled())
 		return;
 
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
 		start_pfn = node_start_pfn(nid);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

