From: akpm@linux-foundation.org
Subject: [merged] memcg-add-memorynumastat-api-for-numa-statistics.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:18 -0700
Message-ID: <201105271956.p4RJuNPi017550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1E0UOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: add memory.numastat api for numa statistics
has been removed from the -mm tree.  Its filename was
     memcg-add-memorynumastat-api-for-numa-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add memory.numastat api for numa statistics
From: Ying Han <yinghan@google.com>

The new API exports numa_maps per-memcg basis.  This is a piece of useful
information where it exports per-memcg page distribution across real numa
nodes.

One of the usecases is evaluating application performance by combining
this information w/ the cpu allocation to the application.

The output of the memory.numastat tries to follow w/ simiar format of
numa_maps like:

total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
anon=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...

And we have per-node:
total = file + anon + unevictable

$ cat /dev/cgroup/memory/memory.numa_stat
total=250020 N0=87620 N1=52367 N2=45298 N3=64735
file=225232 N0=83402 N1=46160 N2=40522 N3=55148
anon=21053 N0=3424 N1=6207 N2=4776 N3=6646
unevictable=3735 N0=794 N1=0 N2=0 N3=2941

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  155 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-memorynumastat-api-for-numa-statistics mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memorynumastat-api-for-numa-statistics
+++ a/mm/memcontrol.c
@@ -1089,6 +1089,93 @@ unsigned long mem_cgroup_zone_nr_lru_pag
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
+#ifdef CONFIG_NUMA
+static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
+							int nid)
+{
+	unsigned long ret;
+
+	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_FILE) +
+		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_FILE);
+
+	return ret;
+}
+
+static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
+{
+	u64 total = 0;
+	int nid;
+
+	for_each_node_state(nid, N_HIGH_MEMORY)
+		total += mem_cgroup_node_nr_file_lru_pages(memcg, nid);
+
+	return total;
+}
+
+static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
+							int nid)
+{
+	unsigned long ret;
+
+	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
+		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
+
+	return ret;
+}
+
+static unsigned long mem_cgroup_nr_anon_lru_pages(struct mem_cgroup *memcg)
+{
+	u64 total = 0;
+	int nid;
+
+	for_each_node_state(nid, N_HIGH_MEMORY)
+		total += mem_cgroup_node_nr_anon_lru_pages(memcg, nid);
+
+	return total;
+}
+
+static unsigned long
+mem_cgroup_node_nr_unevictable_lru_pages(struct mem_cgroup *memcg, int nid)
+{
+	return mem_cgroup_get_zonestat_node(memcg, nid, LRU_UNEVICTABLE);
+}
+
+static unsigned long
+mem_cgroup_nr_unevictable_lru_pages(struct mem_cgroup *memcg)
+{
+	u64 total = 0;
+	int nid;
+
+	for_each_node_state(nid, N_HIGH_MEMORY)
+		total += mem_cgroup_node_nr_unevictable_lru_pages(memcg, nid);
+
+	return total;
+}
+
+static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+							int nid)
+{
+	enum lru_list l;
+	u64 total = 0;
+
+	for_each_lru(l)
+		total += mem_cgroup_get_zonestat_node(memcg, nid, l);
+
+	return total;
+}
+
+static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg)
+{
+	u64 total = 0;
+	int nid;
+
+	for_each_node_state(nid, N_HIGH_MEMORY)
+		total += mem_cgroup_node_nr_lru_pages(memcg, nid);
+
+	return total;
+}
+#endif /* CONFIG_NUMA */
+
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone)
 {
@@ -3944,6 +4031,51 @@ mem_cgroup_get_total_stat(struct mem_cgr
 		mem_cgroup_get_local_stat(iter, s);
 }
 
+#ifdef CONFIG_NUMA
+static int mem_control_numa_stat_show(struct seq_file *m, void *arg)
+{
+	int nid;
+	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
+	unsigned long node_nr;
+	struct cgroup *cont = m->private;
+	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
+
+	total_nr = mem_cgroup_nr_lru_pages(mem_cont);
+	seq_printf(m, "total=%lu", total_nr);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		node_nr = mem_cgroup_node_nr_lru_pages(mem_cont, nid);
+		seq_printf(m, " N%d=%lu", nid, node_nr);
+	}
+	seq_putc(m, '\n');
+
+	file_nr = mem_cgroup_nr_file_lru_pages(mem_cont);
+	seq_printf(m, "file=%lu", file_nr);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		node_nr = mem_cgroup_node_nr_file_lru_pages(mem_cont, nid);
+		seq_printf(m, " N%d=%lu", nid, node_nr);
+	}
+	seq_putc(m, '\n');
+
+	anon_nr = mem_cgroup_nr_anon_lru_pages(mem_cont);
+	seq_printf(m, "anon=%lu", anon_nr);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		node_nr = mem_cgroup_node_nr_anon_lru_pages(mem_cont, nid);
+		seq_printf(m, " N%d=%lu", nid, node_nr);
+	}
+	seq_putc(m, '\n');
+
+	unevictable_nr = mem_cgroup_nr_unevictable_lru_pages(mem_cont);
+	seq_printf(m, "unevictable=%lu", unevictable_nr);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		node_nr = mem_cgroup_node_nr_unevictable_lru_pages(mem_cont,
+									nid);
+		seq_printf(m, " N%d=%lu", nid, node_nr);
+	}
+	seq_putc(m, '\n');
+	return 0;
+}
+#endif /* CONFIG_NUMA */
+
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct cgroup_map_cb *cb)
 {
@@ -3954,6 +4086,7 @@ static int mem_control_stat_show(struct 
 	memset(&mystat, 0, sizeof(mystat));
 	mem_cgroup_get_local_stat(mem_cont, &mystat);
 
+
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
 			continue;
@@ -4377,6 +4510,22 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
+static const struct file_operations mem_control_numa_stat_file_operations = {
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int mem_control_numa_stat_open(struct inode *unused, struct file *file)
+{
+	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
+
+	file->f_op = &mem_control_numa_stat_file_operations;
+	return single_open(file, mem_control_numa_stat_show, cont);
+}
+#endif /* CONFIG_NUMA */
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -4440,6 +4589,12 @@ static struct cftype mem_cgroup_files[] 
 		.unregister_event = mem_cgroup_oom_unregister_event,
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
+#ifdef CONFIG_NUMA
+	{
+		.name = "numa_stat",
+		.open = mem_control_numa_stat_open,
+	},
+#endif
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch

