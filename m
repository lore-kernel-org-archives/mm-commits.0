From: akpm@linux-foundation.org
Subject: [merged] memcg-hierarchical-stat.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:28 -0700
Message-ID: <200904061934.n36JYSqE011636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079AbZDFUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamzawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@


The patch titled
     memcg: hierarchical stat
has been removed from the -mm tree.  Its filename was
     memcg-hierarchical-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: hierarchical stat
From: KAMEZAWA Hiroyuki <kamzawa.hiroyu@jp.fujitsu.com>

Clean up memory.stat file routine and show "total" hierarchical stat.

This patch does
  - renamed get_all_zonestat to be get_local_zonestat.
  - remove old mem_cgroup_stat_desc, which is only for per-cpu stat.
  - add mcs_stat to cover both of per-cpu/per-lru stat.
  - add "total" stat of hierarchy (*)
  - add a callback system to scan all memcg under a root.
== "total" is added.
[kamezawa@localhost ~]$ cat /opt/cgroup/xxx/memory.stat
cache 0
rss 0
pgpgin 0
pgpgout 0
inactive_anon 0
active_anon 0
inactive_file 0
active_file 0
unevictable 0
hierarchical_memory_limit 50331648
hierarchical_memsw_limit 9223372036854775807
total_cache 65536
total_rss 192512
total_pgpgin 218
total_pgpgout 155
total_inactive_anon 0
total_active_anon 135168
total_inactive_file 61440
total_active_file 4096
total_unevictable 0
==
(*) maybe the user can do calc hierarchical stat by his own program
   in userland but if it can be written in clean way, it's worth to be
   shown, I think.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  160 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 119 insertions(+), 41 deletions(-)

diff -puN mm/memcontrol.c~memcg-hierarchical-stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-hierarchical-stat
+++ a/mm/memcontrol.c
@@ -256,7 +256,7 @@ page_cgroup_zoneinfo(struct page_cgroup 
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
 
-static unsigned long mem_cgroup_get_all_zonestat(struct mem_cgroup *mem,
+static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
 					enum lru_list idx)
 {
 	int nid, zid;
@@ -317,6 +317,42 @@ static bool mem_cgroup_is_obsolete(struc
 	return css_is_removed(&mem->css);
 }
 
+
+/*
+ * Call callback function against all cgroup under hierarchy tree.
+ */
+static int mem_cgroup_walk_tree(struct mem_cgroup *root, void *data,
+			  int (*func)(struct mem_cgroup *, void *))
+{
+	int found, ret, nextid;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *mem;
+
+	if (!root->use_hierarchy)
+		return (*func)(root, data);
+
+	nextid = 1;
+	do {
+		ret = 0;
+		mem = NULL;
+
+		rcu_read_lock();
+		css = css_get_next(&mem_cgroup_subsys, nextid, &root->css,
+				   &found);
+		if (css && css_tryget(css))
+			mem = container_of(css, struct mem_cgroup, css);
+		rcu_read_unlock();
+
+		if (mem) {
+			ret = (*func)(mem, data);
+			css_put(&mem->css);
+		}
+		nextid = found + 1;
+	} while (!ret && css);
+
+	return ret;
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -510,8 +546,8 @@ static int calc_inactive_ratio(struct me
 	unsigned long gb;
 	unsigned long inactive_ratio;
 
-	inactive = mem_cgroup_get_all_zonestat(memcg, LRU_INACTIVE_ANON);
-	active = mem_cgroup_get_all_zonestat(memcg, LRU_ACTIVE_ANON);
+	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_ANON);
+	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_ANON);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -1838,54 +1874,90 @@ static int mem_cgroup_reset(struct cgrou
 	return 0;
 }
 
-static const struct mem_cgroup_stat_desc {
-	const char *msg;
-	u64 unit;
-} mem_cgroup_stat_desc[] = {
-	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
-	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
-	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
-	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
+
+/* For read statistics */
+enum {
+	MCS_CACHE,
+	MCS_RSS,
+	MCS_PGPGIN,
+	MCS_PGPGOUT,
+	MCS_INACTIVE_ANON,
+	MCS_ACTIVE_ANON,
+	MCS_INACTIVE_FILE,
+	MCS_ACTIVE_FILE,
+	MCS_UNEVICTABLE,
+	NR_MCS_STAT,
+};
+
+struct mcs_total_stat {
+	s64 stat[NR_MCS_STAT];
+};
+
+struct {
+	char *local_name;
+	char *total_name;
+} memcg_stat_strings[NR_MCS_STAT] = {
+	{"cache", "total_cache"},
+	{"rss", "total_rss"},
+	{"pgpgin", "total_pgpgin"},
+	{"pgpgout", "total_pgpgout"},
+	{"inactive_anon", "total_inactive_anon"},
+	{"active_anon", "total_active_anon"},
+	{"inactive_file", "total_inactive_file"},
+	{"active_file", "total_active_file"},
+	{"unevictable", "total_unevictable"}
 };
 
+
+static int mem_cgroup_get_local_stat(struct mem_cgroup *mem, void *data)
+{
+	struct mcs_total_stat *s = data;
+	s64 val;
+
+	/* per cpu stat */
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_CACHE);
+	s->stat[MCS_CACHE] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
+	s->stat[MCS_RSS] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
+	s->stat[MCS_PGPGIN] += val;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
+	s->stat[MCS_PGPGOUT] += val;
+
+	/* per zone stat */
+	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
+	s->stat[MCS_INACTIVE_ANON] += val * PAGE_SIZE;
+	val = mem_cgroup_get_local_zonestat(mem, LRU_ACTIVE_ANON);
+	s->stat[MCS_ACTIVE_ANON] += val * PAGE_SIZE;
+	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_FILE);
+	s->stat[MCS_INACTIVE_FILE] += val * PAGE_SIZE;
+	val = mem_cgroup_get_local_zonestat(mem, LRU_ACTIVE_FILE);
+	s->stat[MCS_ACTIVE_FILE] += val * PAGE_SIZE;
+	val = mem_cgroup_get_local_zonestat(mem, LRU_UNEVICTABLE);
+	s->stat[MCS_UNEVICTABLE] += val * PAGE_SIZE;
+	return 0;
+}
+
+static void
+mem_cgroup_get_total_stat(struct mem_cgroup *mem, struct mcs_total_stat *s)
+{
+	mem_cgroup_walk_tree(mem, s, mem_cgroup_get_local_stat);
+}
+
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct cgroup_map_cb *cb)
 {
 	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
-	struct mem_cgroup_stat *stat = &mem_cont->stat;
+	struct mcs_total_stat mystat;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(stat->cpustat[0].count); i++) {
-		s64 val;
+	memset(&mystat, 0, sizeof(mystat));
+	mem_cgroup_get_local_stat(mem_cont, &mystat);
 
-		val = mem_cgroup_read_stat(stat, i);
-		val *= mem_cgroup_stat_desc[i].unit;
-		cb->fill(cb, mem_cgroup_stat_desc[i].msg, val);
-	}
-	/* showing # of active pages */
-	{
-		unsigned long active_anon, inactive_anon;
-		unsigned long active_file, inactive_file;
-		unsigned long unevictable;
-
-		inactive_anon = mem_cgroup_get_all_zonestat(mem_cont,
-						LRU_INACTIVE_ANON);
-		active_anon = mem_cgroup_get_all_zonestat(mem_cont,
-						LRU_ACTIVE_ANON);
-		inactive_file = mem_cgroup_get_all_zonestat(mem_cont,
-						LRU_INACTIVE_FILE);
-		active_file = mem_cgroup_get_all_zonestat(mem_cont,
-						LRU_ACTIVE_FILE);
-		unevictable = mem_cgroup_get_all_zonestat(mem_cont,
-							LRU_UNEVICTABLE);
-
-		cb->fill(cb, "active_anon", (active_anon) * PAGE_SIZE);
-		cb->fill(cb, "inactive_anon", (inactive_anon) * PAGE_SIZE);
-		cb->fill(cb, "active_file", (active_file) * PAGE_SIZE);
-		cb->fill(cb, "inactive_file", (inactive_file) * PAGE_SIZE);
-		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
+	for (i = 0; i < NR_MCS_STAT; i++)
+		cb->fill(cb, memcg_stat_strings[i].local_name, mystat.stat[i]);
 
-	}
+	/* Hierarchical information */
 	{
 		unsigned long long limit, memsw_limit;
 		memcg_get_hierarchical_limit(mem_cont, &limit, &memsw_limit);
@@ -1894,6 +1966,12 @@ static int mem_control_stat_show(struct 
 			cb->fill(cb, "hierarchical_memsw_limit", memsw_limit);
 	}
 
+	memset(&mystat, 0, sizeof(mystat));
+	mem_cgroup_get_total_stat(mem_cont, &mystat);
+	for (i = 0; i < NR_MCS_STAT; i++)
+		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
+
+
 #ifdef CONFIG_DEBUG_VM
 	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
 
_

Patches currently in -mm which might be from kamzawa.hiroyu@jp.fujitsu.com are

origin.patch

