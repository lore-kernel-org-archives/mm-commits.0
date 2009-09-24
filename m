From: akpm@linux-foundation.org
Subject: [merged] memcg-improve-resource-counter-scalability.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:34:55 -0700
Message-ID: <200909241934.n8OJYtnq031788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbZIXTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, pr


The patch titled
     memcg: improve resource counter scalability
has been removed from the -mm tree.  Its filename was
     memcg-improve-resource-counter-scalability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: improve resource counter scalability
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Reduce the resource counter overhead (mostly spinlock) associated with the
root cgroup.  This is a part of the several patches to reduce mem cgroup
overhead.  I had posted other approaches earlier (including using percpu
counters).  Those patches will be a natural addition and will be added
iteratively on top of these.

The patch stops resource counter accounting for the root cgroup.  The data
for display is derived from the statisitcs we maintain via
mem_cgroup_charge_statistics (which is more scalable).  What happens today
is that, we do double accounting, once using res_counter_charge() and once
using memory_cgroup_charge_statistics().  For the root, since we don't
implement limits any more, we don't need to track every charge via
res_counter_charge() and check for limit being exceeded and reclaim.

The main mem->res usage_in_bytes can be derived by summing the cache and
rss usage data from memory statistics (MEM_CGROUP_STAT_RSS and
MEM_CGROUP_STAT_CACHE).  However, for memsw->res usage_in_bytes, we need
additional data about swapped out memory.  This patch adds a
MEM_CGROUP_STAT_SWAPOUT and uses that along with MEM_CGROUP_STAT_RSS and
MEM_CGROUP_STAT_CACHE to derive the memsw data.  This data is computed
recursively when hierarchy is enabled.

The tests results I see on a 24 way show that

1. The lock contention disappears from /proc/lock_stats
2. The results of the test are comparable to running with
   cgroup_disable=memory.

Here is a sample of my program runs

Without Patch

 Performance counter stats for '/home/balbir/parallel_pagefault':

 7192804.124144  task-clock-msecs         #     23.937 CPUs
         424691  context-switches         #      0.000 M/sec
            267  CPU-migrations           #      0.000 M/sec
       28498113  page-faults              #      0.004 M/sec
  5826093739340  cycles                   #    809.989 M/sec
   408883496292  instructions             #      0.070 IPC
     7057079452  cache-references         #      0.981 M/sec
     3036086243  cache-misses             #      0.422 M/sec

  300.485365680  seconds time elapsed

With cgroup_disable=memory

 Performance counter stats for '/home/balbir/parallel_pagefault':

 7182183.546587  task-clock-msecs         #     23.915 CPUs
         425458  context-switches         #      0.000 M/sec
            203  CPU-migrations           #      0.000 M/sec
       92545093  page-faults              #      0.013 M/sec
  6034363609986  cycles                   #    840.185 M/sec
   437204346785  instructions             #      0.072 IPC
     6636073192  cache-references         #      0.924 M/sec
     2358117732  cache-misses             #      0.328 M/sec

  300.320905827  seconds time elapsed

With this patch applied

 Performance counter stats for '/home/balbir/parallel_pagefault':

 7191619.223977  task-clock-msecs         #     23.955 CPUs
         422579  context-switches         #      0.000 M/sec
             88  CPU-migrations           #      0.000 M/sec
       91946060  page-faults              #      0.013 M/sec
  5957054385619  cycles                   #    828.333 M/sec
  1058117350365  instructions             #      0.178 IPC
     9161776218  cache-references         #      1.274 M/sec
     1920494280  cache-misses             #      0.267 M/sec

  300.218764862  seconds time elapsed

Data from Prarit (kernel compile with make -j64 on a 64
CPU/32G machine)

For a single run

Without patch

real 27m8.988s
user 87m24.916s
sys 382m6.037s

With patch

real    4m18.607s
user    84m58.943s
sys     50m52.682s

With config turned off

real    4m54.972s
user    90m13.456s
sys     50m19.711s

NOTE: The data looks counterintuitive due to the increased performance
with the patch, even over the config being turned off. We probably need
more runs, but so far all testing has shown that the patches definitely
help.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  121 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 100 insertions(+), 21 deletions(-)

diff -puN mm/memcontrol.c~memcg-improve-resource-counter-scalability mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-improve-resource-counter-scalability
+++ a/mm/memcontrol.c
@@ -70,6 +70,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
+	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -478,11 +479,24 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
+					 bool charge)
+{
+	int val = (charge) ? 1 : -1;
+	struct mem_cgroup_stat *stat = &mem->stat;
+	struct mem_cgroup_stat_cpu *cpustat;
+	int cpu = get_cpu();
+
+	cpustat = &stat->cpustat[cpu];
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SWAPOUT, val);
+	put_cpu();
+}
+
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
 					 bool charge)
 {
-	int val = (charge)? 1 : -1;
+	int val = (charge) ? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
 	struct mem_cgroup_stat_cpu *cpustat;
 	int cpu = get_cpu();
@@ -1285,9 +1299,11 @@ static int __mem_cgroup_try_charge(struc
 	VM_BUG_ON(css_is_removed(&mem->css));
 
 	while (1) {
-		int ret;
+		int ret = 0;
 		unsigned long flags = 0;
 
+		if (mem_cgroup_is_root(mem))
+			goto done;
 		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
 						&soft_fail_res);
 		if (likely(!ret)) {
@@ -1347,6 +1363,7 @@ static int __mem_cgroup_try_charge(struc
 		if (mem_cgroup_soft_limit_check(mem_over_soft_limit))
 			mem_cgroup_update_tree(mem_over_soft_limit, page);
 	}
+done:
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -1419,9 +1436,12 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
-		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+		if (!mem_cgroup_is_root(mem)) {
+			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+			if (do_swap_account)
+				res_counter_uncharge(&mem->memsw, PAGE_SIZE,
+							NULL);
+		}
 		css_put(&mem->css);
 		return;
 	}
@@ -1498,7 +1518,8 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out;
 
-	res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(from))
+		res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
 	mem_cgroup_charge_statistics(from, pc, false);
 
 	page = pc->page;
@@ -1517,7 +1538,7 @@ static int mem_cgroup_move_account(struc
 						1);
 	}
 
-	if (do_swap_account)
+	if (do_swap_account && !mem_cgroup_is_root(from))
 		res_counter_uncharge(&from->memsw, PAGE_SIZE, NULL);
 	css_put(&from->css);
 
@@ -1588,9 +1609,11 @@ uncharge:
 	/* drop extra refcnt by try_charge() */
 	css_put(&parent->css);
 	/* uncharge if move fails */
-	res_counter_uncharge(&parent->res, PAGE_SIZE, NULL);
-	if (do_swap_account)
-		res_counter_uncharge(&parent->memsw, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(parent)) {
+		res_counter_uncharge(&parent->res, PAGE_SIZE, NULL);
+		if (do_swap_account)
+			res_counter_uncharge(&parent->memsw, PAGE_SIZE, NULL);
+	}
 	return ret;
 }
 
@@ -1779,7 +1802,10 @@ __mem_cgroup_commit_charge_swapin(struct
 			 * This recorded memcg can be obsolete one. So, avoid
 			 * calling css_tryget
 			 */
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+			if (!mem_cgroup_is_root(memcg))
+				res_counter_uncharge(&memcg->memsw, PAGE_SIZE,
+							NULL);
+			mem_cgroup_swap_statistics(memcg, false);
 			mem_cgroup_put(memcg);
 		}
 		rcu_read_unlock();
@@ -1804,9 +1830,11 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
-	if (do_swap_account)
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(mem)) {
+		res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+		if (do_swap_account)
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	}
 	css_put(&mem->css);
 }
 
@@ -1859,9 +1887,14 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
-	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(mem)) {
+		res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
+		if (do_swap_account &&
+				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	}
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
+		mem_cgroup_swap_statistics(mem, true);
 	mem_cgroup_charge_statistics(mem, pc, false);
 
 	ClearPageCgroupUsed(pc);
@@ -1952,7 +1985,9 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		 * We uncharge this because swap is freed.
 		 * This memcg can be obsolete one. We avoid calling css_tryget
 		 */
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+		if (!mem_cgroup_is_root(memcg))
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+		mem_cgroup_swap_statistics(memcg, false);
 		mem_cgroup_put(memcg);
 	}
 	rcu_read_unlock();
@@ -2464,20 +2499,64 @@ static int mem_cgroup_hierarchy_write(st
 	return retval;
 }
 
+struct mem_cgroup_idx_data {
+	s64 val;
+	enum mem_cgroup_stat_index idx;
+};
+
+static int
+mem_cgroup_get_idx_stat(struct mem_cgroup *mem, void *data)
+{
+	struct mem_cgroup_idx_data *d = data;
+	d->val += mem_cgroup_read_stat(&mem->stat, d->idx);
+	return 0;
+}
+
+static void
+mem_cgroup_get_recursive_idx_stat(struct mem_cgroup *mem,
+				enum mem_cgroup_stat_index idx, s64 *val)
+{
+	struct mem_cgroup_idx_data d;
+	d.idx = idx;
+	d.val = 0;
+	mem_cgroup_walk_tree(mem, &d, mem_cgroup_get_idx_stat);
+	*val = d.val;
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	u64 val = 0;
+	u64 idx_val, val;
 	int type, name;
 
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 	switch (type) {
 	case _MEM:
-		val = res_counter_read_u64(&mem->res, name);
+		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_CACHE, &idx_val);
+			val = idx_val;
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_RSS, &idx_val);
+			val += idx_val;
+			val <<= PAGE_SHIFT;
+		} else
+			val = res_counter_read_u64(&mem->res, name);
 		break;
 	case _MEMSWAP:
-		val = res_counter_read_u64(&mem->memsw, name);
+		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_CACHE, &idx_val);
+			val = idx_val;
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_RSS, &idx_val);
+			val += idx_val;
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+			val <<= PAGE_SHIFT;
+		} else
+			val = res_counter_read_u64(&mem->memsw, name);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch

