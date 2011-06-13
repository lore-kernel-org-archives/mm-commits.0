From: akpm@linux-foundation.org
Subject: + memcg-fix-percpu-cached-charge-draining-frequency.patch added to -mm tree
Date: Mon, 13 Jun 2011 14:23:50 -0700
Message-ID: <201106132123.p5DLNplj022733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab1FMVYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 17:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix percpu cached charge draining frequency
has been added to the -mm tree.  Its filename is
     memcg-fix-percpu-cached-charge-draining-frequency.patch

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
Subject: memcg: fix percpu cached charge draining frequency
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For performance, memory cgroup caches some "charge" from res_counter into
per cpu cache.  This works well but because it's cache, it needs to be
flushed in some cases.  Typical cases are

  1. when someone hit limit.

  2. when rmdir() is called and need to charges to be 0.

But "1" has problem.

Recently, with large SMP machines, we see many kworker runs because of
flushing memcg's cache.  Bad things in implementation are that even if a
cpu contains a cache for memcg not related to a memcg which hits limit,
drain code is called.

This patch does
	A) check percpu cache contains a useful data or not.
	B) check other asynchronous percpu draining doesn't run.
	C) don't call local cpu callback.
	D) don't call at softlimit reclaim.

(*)This patch avoid changing the calling condition with hard-limit.

When I run "cat 1Gfile > /dev/null" under 300M limit memcg,

[Before]
13767 kamezawa  20   0 98.6m  424  416 D 10.0  0.0   0:00.61 cat
   58 root      20   0     0    0    0 S  0.6  0.0   0:00.09 kworker/2:1
   60 root      20   0     0    0    0 S  0.6  0.0   0:00.08 kworker/4:1
    4 root      20   0     0    0    0 S  0.3  0.0   0:00.02 kworker/0:0
   57 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/1:1
   61 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/5:1
   62 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/6:1
   63 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/7:1

[After]
 2676 root      20   0 98.6m  416  416 D  9.3  0.0   0:00.87 cat
 2626 kamezawa  20   0 15192 1312  920 R  0.3  0.0   0:00.28 top
    1 root      20   0 19384 1496 1204 S  0.0  0.0   0:00.66 init
    2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd
    3 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/0
    4 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/0:0

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   61 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-percpu-cached-charge-draining-frequency mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-percpu-cached-charge-draining-frequency
+++ a/mm/memcontrol.c
@@ -359,7 +359,7 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
-static void drain_all_stock_async(void);
+static void drain_all_stock_async(struct mem_cgroup *mem);
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -1670,8 +1670,8 @@ static int mem_cgroup_hierarchical_recla
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (loop >= 1)
-				drain_all_stock_async();
+			if (!check_soft && loop >= 1)
+				drain_all_stock_async(root_mem);
 			if (loop >= 2) {
 				/*
 				 * If we have not been able to reclaim
@@ -1934,9 +1934,11 @@ struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 	struct work_struct work;
+	unsigned long flags;
+#define FLUSHING_CACHED_CHARGE	(0)
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
-static atomic_t memcg_drain_count;
+DEFINE_MUTEX(percpu_charge_mutex);
 
 /*
  * Try to consume stocked charge on this cpu. If success, one page is consumed
@@ -1984,6 +1986,7 @@ static void drain_local_stock(struct wor
 {
 	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
 	drain_stock(stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 }
 
 /*
@@ -2008,26 +2011,50 @@ static void refill_stock(struct mem_cgro
  * expects some charges will be back to res_counter later but cannot wait for
  * it.
  */
-static void drain_all_stock_async(void)
+static void drain_all_stock_async(struct mem_cgroup *root_mem)
 {
-	int cpu;
-	/* This function is for scheduling "drain" in asynchronous way.
-	 * The result of "drain" is not directly handled by callers. Then,
-	 * if someone is calling drain, we don't have to call drain more.
-	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
-	 * there is a race. We just do loose check here.
+	int cpu, curcpu;
+	/*
+	 * If someone calls draining, avoid adding more kworker runs.
 	 */
-	if (atomic_read(&memcg_drain_count))
+	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
 	/* Notify other cpus that system-wide "drain" is running */
-	atomic_inc(&memcg_drain_count);
 	get_online_cpus();
+
+	/*
+	 * get a hint for avoiding draining charges on the current cpu,
+	 * which must be exhausted by our charging. But this is not
+	 * required to be a precise check, We use raw_smp_processor_id()
+	 * instead of getcpu()/putcpu().
+	 */
+	curcpu = raw_smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		schedule_work_on(cpu, &stock->work);
+		struct mem_cgroup *mem;
+
+		if (cpu == curcpu)
+			continue;
+
+		mem = stock->cached;
+		if (!mem)
+			continue;
+		if (mem != root_mem) {
+			if (!root_mem->use_hierarchy)
+				continue;
+			/* check whether "mem" is under tree of "root_mem" */
+			rcu_read_lock();
+			if (!css_is_ancestor(&mem->css, &root_mem->css)) {
+				rcu_read_unlock();
+				continue;
+			}
+			rcu_read_unlock();
+		}
+		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+			schedule_work_on(cpu, &stock->work);
 	}
  	put_online_cpus();
-	atomic_dec(&memcg_drain_count);
+	mutex_unlock(&percpu_charge_mutex);
 	/* We don't wait for flush_work */
 }
 
@@ -2035,9 +2062,9 @@ static void drain_all_stock_async(void)
 static void drain_all_stock_sync(void)
 {
 	/* called when force_empty is called */
-	atomic_inc(&memcg_drain_count);
+	mutex_lock(&percpu_charge_mutex);
 	schedule_on_each_cpu(drain_local_stock);
-	atomic_dec(&memcg_drain_count);
+	mutex_unlock(&percpu_charge_mutex);
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

