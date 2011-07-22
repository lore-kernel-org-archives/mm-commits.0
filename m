From: akpm@linux-foundation.org
Subject: + memcg-add-memoryvmscan_stat.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:31:05 -0700
Message-ID: <201107222231.p6MMV5Nk018893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab1GVWbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, abrestic@google.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg: add memory.vmscan_stat
has been added to the -mm tree.  Its filename is
     memcg-add-memoryvmscan_stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add memory.vmscan_stat
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

The commit log of 0ae5e89 ("memcg: count the soft_limit reclaim in...")
says it adds scanning stats to memory.stat file.  But it doesn't because
we considered we needed to make a concensus for such new APIs.

This patch is a trial to add memory.scan_stat. This shows
  - the number of scanned pages(total, anon, file)
  - the number of rotated pages(total, anon, file)
  - the number of freed pages(total, anon, file)
  - the number of elaplsed time (including sleep/pause time)

  for both of direct/soft reclaim.

The biggest difference with oringinal Ying's one is that this file
can be reset by some write, as

  # echo 0 ...../memory.scan_stat

Example of output is here. This is a result after make -j 6 kernel
under 300M limit.

[kamezawa@bluextal ~]$ cat /cgroup/memory/A/memory.scan_stat
[kamezawa@bluextal ~]$ cat /cgroup/memory/A/memory.vmscan_stat
scanned_pages_by_limit 9471864
scanned_anon_pages_by_limit 6640629
scanned_file_pages_by_limit 2831235
rotated_pages_by_limit 4243974
rotated_anon_pages_by_limit 3971968
rotated_file_pages_by_limit 272006
freed_pages_by_limit 2318492
freed_anon_pages_by_limit 962052
freed_file_pages_by_limit 1356440
elapsed_ns_by_limit 351386416101
scanned_pages_by_system 0
scanned_anon_pages_by_system 0
scanned_file_pages_by_system 0
rotated_pages_by_system 0
rotated_anon_pages_by_system 0
rotated_file_pages_by_system 0
freed_pages_by_system 0
freed_anon_pages_by_system 0
freed_file_pages_by_system 0
elapsed_ns_by_system 0
scanned_pages_by_limit_under_hierarchy 9471864
scanned_anon_pages_by_limit_under_hierarchy 6640629
scanned_file_pages_by_limit_under_hierarchy 2831235
rotated_pages_by_limit_under_hierarchy 4243974
rotated_anon_pages_by_limit_under_hierarchy 3971968
rotated_file_pages_by_limit_under_hierarchy 272006
freed_pages_by_limit_under_hierarchy 2318492
freed_anon_pages_by_limit_under_hierarchy 962052
freed_file_pages_by_limit_under_hierarchy 1356440
elapsed_ns_by_limit_under_hierarchy 351386416101
scanned_pages_by_system_under_hierarchy 0
scanned_anon_pages_by_system_under_hierarchy 0
scanned_file_pages_by_system_under_hierarchy 0
rotated_pages_by_system_under_hierarchy 0
rotated_anon_pages_by_system_under_hierarchy 0
rotated_file_pages_by_system_under_hierarchy 0
freed_pages_by_system_under_hierarchy 0
freed_anon_pages_by_system_under_hierarchy 0
freed_file_pages_by_system_under_hierarchy 0
elapsed_ns_by_system_under_hierarchy 0

total_xxxx is for hierarchy management.

This will be useful for further memcg developments and need to be
developped before we do some complicated rework on LRU/softlimit
management.

This patch adds a new struct memcg_scanrecord into scan_control struct.
sc->nr_scanned at el is not designed for exporting information. For example,
nr_scanned is reset frequentrly and incremented +2 at scanning mapped pages.

To avoid complexity, I added a new param in scan_control which is for
exporting scanning score.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Andrew Bresticker <abrestic@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   85 ++++++++++++++
 include/linux/memcontrol.h       |   19 +++
 include/linux/swap.h             |    6 -
 mm/memcontrol.c                  |  172 +++++++++++++++++++++++++++--
 mm/vmscan.c                      |   39 +++++-
 5 files changed, 303 insertions(+), 18 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-memoryvmscan_stat Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-memoryvmscan_stat
+++ a/Documentation/cgroups/memory.txt
@@ -380,7 +380,7 @@ will be charged as a new owner of it.
 
 5.2 stat file
 
-memory.stat file includes following statistics
+5.2.1 memory.stat file includes following statistics
 
 # per-memory cgroup local status
 cache		- # of bytes of page cache memory.
@@ -438,6 +438,89 @@ Note:
 	 file_mapped is accounted only when the memory cgroup is owner of page
 	 cache.)
 
+5.2.2 memory.vmscan_stat
+
+memory.vmscan_stat includes statistics information for memory scanning and
+freeing, reclaiming. The statistics shows memory scanning information since
+memory cgroup creation and can be reset to 0 by writing 0 as
+
+ #echo 0 > ../memory.vmscan_stat
+
+This file contains following statistics.
+
+[param]_[file_or_anon]_pages_by_[reason]_[under_heararchy]
+[param]_elapsed_ns_by_[reason]_[under_hierarchy]
+
+For example,
+
+  scanned_file_pages_by_limit indicates the number of scanned
+  file pages at vmscan.
+
+Now, 3 parameters are supported
+
+  scanned - the number of pages scanned by vmscan
+  rotated - the number of pages activated at vmscan
+  freed   - the number of pages freed by vmscan
+
+If "rotated" is high against scanned/freed, the memcg seems busy.
+
+Now, 2 reason are supported
+
+  limit - the memory cgroup's limit
+  system - global memory pressure + softlimit
+           (global memory pressure not under softlimit is not handled now)
+
+When under_hierarchy is added in the tail, the number indicates the
+total memcg scan of its children and itself.
+
+elapsed_ns is a elapsed time in nanosecond. This may include sleep time
+and not indicates CPU usage. So, please take this as just showing
+latency.
+
+Here is an example.
+
+# cat /cgroup/memory/A/memory.vmscan_stat
+scanned_pages_by_limit 9471864
+scanned_anon_pages_by_limit 6640629
+scanned_file_pages_by_limit 2831235
+rotated_pages_by_limit 4243974
+rotated_anon_pages_by_limit 3971968
+rotated_file_pages_by_limit 272006
+freed_pages_by_limit 2318492
+freed_anon_pages_by_limit 962052
+freed_file_pages_by_limit 1356440
+elapsed_ns_by_limit 351386416101
+scanned_pages_by_system 0
+scanned_anon_pages_by_system 0
+scanned_file_pages_by_system 0
+rotated_pages_by_system 0
+rotated_anon_pages_by_system 0
+rotated_file_pages_by_system 0
+freed_pages_by_system 0
+freed_anon_pages_by_system 0
+freed_file_pages_by_system 0
+elapsed_ns_by_system 0
+scanned_pages_by_limit_under_hierarchy 9471864
+scanned_anon_pages_by_limit_under_hierarchy 6640629
+scanned_file_pages_by_limit_under_hierarchy 2831235
+rotated_pages_by_limit_under_hierarchy 4243974
+rotated_anon_pages_by_limit_under_hierarchy 3971968
+rotated_file_pages_by_limit_under_hierarchy 272006
+freed_pages_by_limit_under_hierarchy 2318492
+freed_anon_pages_by_limit_under_hierarchy 962052
+freed_file_pages_by_limit_under_hierarchy 1356440
+elapsed_ns_by_limit_under_hierarchy 351386416101
+scanned_pages_by_system_under_hierarchy 0
+scanned_anon_pages_by_system_under_hierarchy 0
+scanned_file_pages_by_system_under_hierarchy 0
+rotated_pages_by_system_under_hierarchy 0
+rotated_anon_pages_by_system_under_hierarchy 0
+rotated_file_pages_by_system_under_hierarchy 0
+freed_pages_by_system_under_hierarchy 0
+freed_anon_pages_by_system_under_hierarchy 0
+freed_file_pages_by_system_under_hierarchy 0
+elapsed_ns_by_system_under_hierarchy 0
+
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
diff -puN include/linux/memcontrol.h~memcg-add-memoryvmscan_stat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-memoryvmscan_stat
+++ a/include/linux/memcontrol.h
@@ -39,6 +39,16 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active, int file);
 
+struct memcg_scanrecord {
+	struct mem_cgroup *mem; /* scanend memory cgroup */
+	struct mem_cgroup *root; /* scan target hierarchy root */
+	int context;		/* scanning context (see memcontrol.c) */
+	unsigned long nr_scanned[2]; /* the number of scanned pages */
+	unsigned long nr_rotated[2]; /* the number of rotated pages */
+	unsigned long nr_freed[2]; /* the number of freed pages */
+	unsigned long elapsed; /* nsec of time elapsed while scanning */
+};
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
@@ -117,6 +127,15 @@ mem_cgroup_get_reclaim_stat_from_page(st
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
 
+extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
+						  gfp_t gfp_mask, bool noswap,
+						  struct memcg_scanrecord *rec);
+extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
+						gfp_t gfp_mask, bool noswap,
+						struct zone *zone,
+						struct memcg_scanrecord *rec,
+						unsigned long *nr_scanned);
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
diff -puN include/linux/swap.h~memcg-add-memoryvmscan_stat include/linux/swap.h
--- a/include/linux/swap.h~memcg-add-memoryvmscan_stat
+++ a/include/linux/swap.h
@@ -253,12 +253,6 @@ static inline void lru_cache_add_file(st
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
-						  gfp_t gfp_mask, bool noswap);
-extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap,
-						struct zone *zone,
-						unsigned long *nr_scanned);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/memcontrol.c~memcg-add-memoryvmscan_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memoryvmscan_stat
+++ a/mm/memcontrol.c
@@ -204,6 +204,50 @@ struct mem_cgroup_eventfd_list {
 static void mem_cgroup_threshold(struct mem_cgroup *mem);
 static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
 
+enum {
+	SCAN_BY_LIMIT,
+	SCAN_BY_SYSTEM,
+	NR_SCAN_CONTEXT,
+	SCAN_BY_SHRINK,	/* not recorded now */
+};
+
+enum {
+	SCAN,
+	SCAN_ANON,
+	SCAN_FILE,
+	ROTATE,
+	ROTATE_ANON,
+	ROTATE_FILE,
+	FREED,
+	FREED_ANON,
+	FREED_FILE,
+	ELAPSED,
+	NR_SCANSTATS,
+};
+
+struct scanstat {
+	spinlock_t	lock;
+	unsigned long	stats[NR_SCAN_CONTEXT][NR_SCANSTATS];
+	unsigned long	rootstats[NR_SCAN_CONTEXT][NR_SCANSTATS];
+};
+
+const char *scanstat_string[NR_SCANSTATS] = {
+	"scanned_pages",
+	"scanned_anon_pages",
+	"scanned_file_pages",
+	"rotated_pages",
+	"rotated_anon_pages",
+	"rotated_file_pages",
+	"freed_pages",
+	"freed_anon_pages",
+	"freed_file_pages",
+	"elapsed_ns",
+};
+#define SCANSTAT_WORD_LIMIT	"_by_limit"
+#define SCANSTAT_WORD_SYSTEM	"_by_system"
+#define SCANSTAT_WORD_HIERARCHY	"_under_hierarchy"
+
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -269,7 +313,8 @@ struct mem_cgroup {
 
 	/* For oom notifier event fd */
 	struct list_head oom_notify;
-
+	/* For recording LRU-scan statistics */
+	struct scanstat scanstat;
 	/*
 	 * Should we move charges of a task when a task is moved into this
 	 * mem_cgroup ? And what type of charges should we move ?
@@ -1622,6 +1667,44 @@ bool mem_cgroup_reclaimable(struct mem_c
 }
 #endif
 
+static void __mem_cgroup_record_scanstat(unsigned long *stats,
+			   struct memcg_scanrecord *rec)
+{
+
+	stats[SCAN] += rec->nr_scanned[0] + rec->nr_scanned[1];
+	stats[SCAN_ANON] += rec->nr_scanned[0];
+	stats[SCAN_FILE] += rec->nr_scanned[1];
+
+	stats[ROTATE] += rec->nr_rotated[0] + rec->nr_rotated[1];
+	stats[ROTATE_ANON] += rec->nr_rotated[0];
+	stats[ROTATE_FILE] += rec->nr_rotated[1];
+
+	stats[FREED] += rec->nr_freed[0] + rec->nr_freed[1];
+	stats[FREED_ANON] += rec->nr_freed[0];
+	stats[FREED_FILE] += rec->nr_freed[1];
+
+	stats[ELAPSED] += rec->elapsed;
+}
+
+static void mem_cgroup_record_scanstat(struct memcg_scanrecord *rec)
+{
+	struct mem_cgroup *mem;
+	int context = rec->context;
+
+	if (context >= NR_SCAN_CONTEXT)
+		return;
+
+	mem = rec->mem;
+	spin_lock(&mem->scanstat.lock);
+	__mem_cgroup_record_scanstat(mem->scanstat.stats[context], rec);
+	spin_unlock(&mem->scanstat.lock);
+
+	mem = rec->root;
+	spin_lock(&mem->scanstat.lock);
+	__mem_cgroup_record_scanstat(mem->scanstat.rootstats[context], rec);
+	spin_unlock(&mem->scanstat.lock);
+}
+
 /*
  * Scan the hierarchy if needed to reclaim memory. We remember the last child
  * we reclaimed from, so that we don't end up penalizing one child extensively
@@ -1646,8 +1729,9 @@ static int mem_cgroup_hierarchical_recla
 	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
 	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
+	struct memcg_scanrecord rec;
 	unsigned long excess;
-	unsigned long nr_scanned;
+	unsigned long scanned;
 
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
@@ -1655,6 +1739,15 @@ static int mem_cgroup_hierarchical_recla
 	if (!check_soft && root_mem->memsw_is_minimum)
 		noswap = true;
 
+	if (shrink)
+		rec.context = SCAN_BY_SHRINK;
+	else if (check_soft)
+		rec.context = SCAN_BY_SYSTEM;
+	else
+		rec.context = SCAN_BY_LIMIT;
+
+	rec.root = root_mem;
+
 	while (1) {
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
@@ -1695,14 +1788,23 @@ static int mem_cgroup_hierarchical_recla
 			css_put(&victim->css);
 			continue;
 		}
+		rec.mem = victim;
+		rec.nr_scanned[0] = 0;
+		rec.nr_scanned[1] = 0;
+		rec.nr_rotated[0] = 0;
+		rec.nr_rotated[1] = 0;
+		rec.nr_freed[0] = 0;
+		rec.nr_freed[1] = 0;
+		rec.elapsed = 0;
 		/* we use swappiness of local cgroup */
 		if (check_soft) {
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, zone, &nr_scanned);
-			*total_scanned += nr_scanned;
+				noswap, zone, &rec, &scanned);
+			*total_scanned += scanned;
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
-						noswap);
+						noswap, &rec);
+		mem_cgroup_record_scanstat(&rec);
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -3742,14 +3844,18 @@ try_to_free:
 	/* try to free all pages in this cgroup */
 	shrink = 1;
 	while (nr_retries && mem->res.usage > 0) {
+		struct memcg_scanrecord rec;
 		int progress;
 
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			goto out;
 		}
+		rec.context = SCAN_BY_SHRINK;
+		rec.mem = mem;
+		rec.root = mem;
 		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
-						false);
+						false, &rec);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -4593,6 +4699,54 @@ static int mem_control_numa_stat_open(st
 }
 #endif /* CONFIG_NUMA */
 
+static int mem_cgroup_vmscan_stat_read(struct cgroup *cgrp,
+				struct cftype *cft,
+				struct cgroup_map_cb *cb)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
+	char string[64];
+	int i;
+
+	for (i = 0; i < NR_SCANSTATS; i++) {
+		strcpy(string, scanstat_string[i]);
+		strcat(string, SCANSTAT_WORD_LIMIT);
+		cb->fill(cb, string,  mem->scanstat.stats[SCAN_BY_LIMIT][i]);
+	}
+
+	for (i = 0; i < NR_SCANSTATS; i++) {
+		strcpy(string, scanstat_string[i]);
+		strcat(string, SCANSTAT_WORD_SYSTEM);
+		cb->fill(cb, string,  mem->scanstat.stats[SCAN_BY_SYSTEM][i]);
+	}
+
+	for (i = 0; i < NR_SCANSTATS; i++) {
+		strcpy(string, scanstat_string[i]);
+		strcat(string, SCANSTAT_WORD_LIMIT);
+		strcat(string, SCANSTAT_WORD_HIERARCHY);
+		cb->fill(cb, string,  mem->scanstat.rootstats[SCAN_BY_LIMIT][i]);
+	}
+	for (i = 0; i < NR_SCANSTATS; i++) {
+		strcpy(string, scanstat_string[i]);
+		strcat(string, SCANSTAT_WORD_SYSTEM);
+		strcat(string, SCANSTAT_WORD_HIERARCHY);
+		cb->fill(cb, string,  mem->scanstat.rootstats[SCAN_BY_SYSTEM][i]);
+	}
+	return 0;
+}
+
+static int mem_cgroup_reset_vmscan_stat(struct cgroup *cgrp,
+				unsigned int event)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
+
+	spin_lock(&mem->scanstat.lock);
+	memset(&mem->scanstat.stats, 0, sizeof(mem->scanstat.stats));
+	memset(&mem->scanstat.rootstats, 0, sizeof(mem->scanstat.rootstats));
+	spin_unlock(&mem->scanstat.lock);
+	return 0;
+}
+
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -4663,6 +4817,11 @@ static struct cftype mem_cgroup_files[] 
 		.mode = S_IRUGO,
 	},
 #endif
+	{
+		.name = "vmscan_stat",
+		.read_map = mem_cgroup_vmscan_stat_read,
+		.trigger = mem_cgroup_reset_vmscan_stat,
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
@@ -4926,6 +5085,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
+	spin_lock_init(&mem->scanstat.lock);
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
diff -puN mm/vmscan.c~memcg-add-memoryvmscan_stat mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-memoryvmscan_stat
+++ a/mm/vmscan.c
@@ -105,6 +105,7 @@ struct scan_control {
 
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
+	struct memcg_scanrecord *memcg_record;
 
 	/*
 	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
@@ -1348,6 +1349,8 @@ putback_lru_pages(struct zone *zone, str
 			int file = is_file_lru(lru);
 			int numpages = hpage_nr_pages(page);
 			reclaim_stat->recent_rotated[file] += numpages;
+			if (!scanning_global_lru(sc))
+				sc->memcg_record->nr_rotated[file] += numpages;
 		}
 		if (!pagevec_add(&pvec, page)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1391,6 +1394,10 @@ static noinline_for_stack void update_is
 
 	reclaim_stat->recent_scanned[0] += *nr_anon;
 	reclaim_stat->recent_scanned[1] += *nr_file;
+	if (!scanning_global_lru(sc)) {
+		sc->memcg_record->nr_scanned[0] += *nr_anon;
+		sc->memcg_record->nr_scanned[1] += *nr_file;
+	}
 }
 
 /*
@@ -1504,6 +1511,9 @@ shrink_inactive_list(unsigned long nr_to
 		nr_reclaimed += shrink_page_list(&page_list, zone, sc);
 	}
 
+	if (!scanning_global_lru(sc))
+		sc->memcg_record->nr_freed[file] += nr_reclaimed;
+
 	local_irq_disable();
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
@@ -1603,6 +1613,8 @@ static void shrink_active_list(unsigned 
 	}
 
 	reclaim_stat->recent_scanned[file] += nr_taken;
+	if (!scanning_global_lru(sc))
+		sc->memcg_record->nr_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
@@ -1654,6 +1666,8 @@ static void shrink_active_list(unsigned 
 	 * get_scan_ratio.
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
+	if (!scanning_global_lru(sc))
+		sc->memcg_record->nr_rotated[file] += nr_rotated;
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);
@@ -2254,9 +2268,10 @@ unsigned long try_to_free_pages(struct z
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap,
-						struct zone *zone,
-						unsigned long *nr_scanned)
+					gfp_t gfp_mask, bool noswap,
+					struct zone *zone,
+					struct memcg_scanrecord *rec,
+					unsigned long *scanned)
 {
 	struct scan_control sc = {
 		.nr_scanned = 0,
@@ -2266,7 +2281,9 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_swap = !noswap,
 		.order = 0,
 		.mem_cgroup = mem,
+		.memcg_record = rec,
 	};
+	unsigned long start, end;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -2275,6 +2292,7 @@ unsigned long mem_cgroup_shrink_node_zon
 						      sc.may_writepage,
 						      sc.gfp_mask);
 
+	start = sched_clock();
 	/*
 	 * NOTE: Although we can get the priority field, using it
 	 * here is not a good idea, since it limits the pages we can scan.
@@ -2283,19 +2301,25 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * the priority and make it zero.
 	 */
 	shrink_zone(0, zone, &sc);
+	end = sched_clock();
+
+	if (rec)
+		rec->elapsed += end - start;
+	*scanned = sc.nr_scanned;
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
-	*nr_scanned = sc.nr_scanned;
 	return sc.nr_reclaimed;
 }
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 					   gfp_t gfp_mask,
-					   bool noswap)
+					   bool noswap,
+					   struct memcg_scanrecord *rec)
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
+	unsigned long start, end;
 	int nid;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
@@ -2304,6 +2328,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.order = 0,
 		.mem_cgroup = mem_cont,
+		.memcg_record = rec,
 		.nodemask = NULL, /* we don't care the placement */
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
@@ -2312,6 +2337,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.gfp_mask = sc.gfp_mask,
 	};
 
+	start = sched_clock();
 	/*
 	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
 	 * take care of from where we get pages. So the node where we start the
@@ -2326,6 +2352,9 @@ unsigned long try_to_free_mem_cgroup_pag
 					    sc.gfp_mask);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
+	end = sched_clock();
+	if (rec)
+		rec->elapsed += end - start;
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-mempolicyc-make-copy_from_user-provably-correct.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
oom-make-deprecated-use-of-oom_adj-more-verbose.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
memcg-fix-vmscan-count-in-small-memcgs.patch
memcg-add-memoryvmscan_stat.patch
memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch
memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch
memcg-add-mem_cgroup_same_or_subtree-helper.patch
memcg-get-rid-of-percpu_charge_mutex-lock.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch

