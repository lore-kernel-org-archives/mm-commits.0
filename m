From: akpm@linux-foundation.org
Subject: + memcg-coalesce-charges-per-cpu.patch added to -mm tree
Date: Fri, 09 Oct 2009 00:14:44 -0700
Message-ID: <200910090714.n997Ej3F025910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933200AbZJIHPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 03:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, h-shimamoto@ct.jp.nec.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: coalesce charges per cpu
has been added to the -mm tree.  Its filename is
     memcg-coalesce-charges-per-cpu.patch

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
Subject: memcg: coalesce charges per cpu
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Coalesce access to res_counter at charging by percpu caching.  At charge,
memcg charges 64pages and remember it in percpu cache.  Because it's
cache, drain/flush is done if necessary.

This version uses public percpu area.
 2 benefits of using public percpu area.
 1. Sum of stocked charge in the system is limited to # of cpus
    not to the number of memcg. This shows better synchonization.
 2. drain code for flush/cpuhotplug is very easy (and quick)

The most important point of this patch is that we never touch res_counter
in fast path.  The res_counter is system-wide shared counter which is
modified very frequently.  We shouldn't touch it as far as we can for
avoiding false sharing.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/memcontrol.c~memcg-coalesce-charges-per-cpu mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-coalesce-charges-per-cpu
+++ a/mm/memcontrol.c
@@ -38,6 +38,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
+#include <linux/cpu.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -275,6 +276,7 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
+static void drain_all_stock_async(void);
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -1137,6 +1139,8 @@ static int mem_cgroup_hierarchical_recla
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
+			if (loop >= 1)
+				drain_all_stock_async();
 			if (loop >= 2) {
 				/*
 				 * If we have not been able to reclaim
@@ -1258,6 +1262,103 @@ done:
 	unlock_page_cgroup(pc);
 }
 
+/* size of first charge trial. "32" comes from vmscan.c's magic value */
+#define CHARGE_SIZE	(32 * PAGE_SIZE)
+struct memcg_stock_pcp {
+	struct mem_cgroup *cached;
+	int charge;
+	struct work_struct work;
+};
+static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
+static DEFINE_MUTEX(memcg_drain_mutex);
+
+static bool consume_stock(struct mem_cgroup *mem)
+{
+	struct memcg_stock_pcp *stock;
+	bool ret = true;
+
+	stock = &get_cpu_var(memcg_stock);
+	if (mem == stock->cached && stock->charge)
+		stock->charge -= PAGE_SIZE;
+	else
+		ret = false;
+	put_cpu_var(memcg_stock);
+	return ret;
+}
+
+static void drain_stock(struct memcg_stock_pcp *stock)
+{
+	struct mem_cgroup *old = stock->cached;
+
+	if (stock->charge) {
+		res_counter_uncharge(&old->res, stock->charge);
+		if (do_swap_account)
+			res_counter_uncharge(&old->memsw, stock->charge);
+	}
+	stock->cached = NULL;
+	stock->charge = 0;
+}
+
+static void drain_local_stock(struct work_struct *dummy)
+{
+	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
+	drain_stock(stock);
+	put_cpu_var(memcg_stock);
+}
+
+static void refill_stock(struct mem_cgroup *mem, int val)
+{
+	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
+
+	if (stock->cached != mem) {
+		drain_stock(stock);
+		stock->cached = mem;
+	}
+	stock->charge += val;
+	put_cpu_var(memcg_stock);
+}
+
+static void drain_all_stock_async(void)
+{
+	int cpu;
+	/* Contention means someone tries to flush. */
+	if (!mutex_trylock(&memcg_drain_mutex))
+		return;
+	for_each_online_cpu(cpu) {
+		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
+		if (work_pending(&stock->work))
+			continue;
+		INIT_WORK(&stock->work, drain_local_stock);
+		schedule_work_on(cpu, &stock->work);
+	}
+	mutex_unlock(&memcg_drain_mutex);
+	/* We don't wait for flush_work */
+}
+
+static void drain_all_stock_sync(void)
+{
+	/* called when force_empty is called */
+	mutex_lock(&memcg_drain_mutex);
+	schedule_on_each_cpu(drain_local_stock);
+	mutex_unlock(&memcg_drain_mutex);
+}
+
+static int __cpuinit memcg_stock_cpu_callback(struct notifier_block *nb,
+					unsigned long action,
+					void *hcpu)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	int cpu = (unsigned long)hcpu;
+	struct memcg_stock_pcp *stock;
+
+	if (action != CPU_DEAD)
+		return NOTIFY_OK;
+	stock = &per_cpu(memcg_stock, cpu);
+	drain_stock(stock);
+#endif
+	return NOTIFY_OK;
+}
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -1269,6 +1370,7 @@ static int __mem_cgroup_try_charge(struc
 	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct res_counter *fail_res;
+	int csize = CHARGE_SIZE;
 
 	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
 		/* Don't account this! */
@@ -1293,23 +1395,25 @@ static int __mem_cgroup_try_charge(struc
 		return 0;
 
 	VM_BUG_ON(css_is_removed(&mem->css));
+	if (mem_cgroup_is_root(mem))
+		goto done;
 
 	while (1) {
 		int ret = 0;
 		unsigned long flags = 0;
 
-		if (mem_cgroup_is_root(mem))
-			goto done;
-		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
+		if (consume_stock(mem))
+			goto charged;
+
+		ret = res_counter_charge(&mem->res, csize, &fail_res);
 		if (likely(!ret)) {
 			if (!do_swap_account)
 				break;
-			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
-							&fail_res);
+			ret = res_counter_charge(&mem->memsw, csize, &fail_res);
 			if (likely(!ret))
 				break;
 			/* mem+swap counter fails */
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			res_counter_uncharge(&mem->res, csize);
 			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									memsw);
@@ -1318,6 +1422,11 @@ static int __mem_cgroup_try_charge(struc
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									res);
 
+		/* reduce request size and retry */
+		if (csize > PAGE_SIZE) {
+			csize = PAGE_SIZE;
+			continue;
+		}
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
@@ -1347,6 +1456,9 @@ static int __mem_cgroup_try_charge(struc
 			goto nomem;
 		}
 	}
+	if (csize > PAGE_SIZE)
+		refill_stock(mem, csize - PAGE_SIZE);
+charged:
 	/*
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
 	 * if they exceeds softlimit.
@@ -2463,6 +2575,7 @@ move_account:
 			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
+		drain_all_stock_sync();
 		ret = 0;
 		for_each_node_state(node, N_HIGH_MEMORY) {
 			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
@@ -3181,6 +3294,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		root_mem_cgroup = mem;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		hotcpu_notifier(memcg_stock_cpu_callback, 0);
 
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
memcg-coalesce-uncharge-at-unmap-and-truncation.patch
memcg-coalesce-charges-per-cpu.patch

