From: akpm@linux-foundation.org
Subject: [merged] memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:57 -0700
Message-ID: <201103250724.p2P7OpKX025965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933852Ab1CYHZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: convert per-cpu stock from bytes to page granularity
has been removed from the -mm tree.  Its filename was
     memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: convert per-cpu stock from bytes to page granularity
From: Johannes Weiner <hannes@cmpxchg.org>

We never keep subpage quantities in the per-cpu stock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-convert-per-cpu-stock-from-bytes-to-page-granularity mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-convert-per-cpu-stock-from-bytes-to-page-granularity
+++ a/mm/memcontrol.c
@@ -1650,14 +1650,14 @@ EXPORT_SYMBOL(mem_cgroup_update_page_sta
 #define CHARGE_SIZE	(32 * PAGE_SIZE)
 struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
-	int charge;
+	unsigned int nr_pages;
 	struct work_struct work;
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
 static atomic_t memcg_drain_count;
 
 /*
- * Try to consume stocked charge on this cpu. If success, PAGE_SIZE is consumed
+ * Try to consume stocked charge on this cpu. If success, one page is consumed
  * from local stock and true is returned. If the stock is 0 or charges from a
  * cgroup which is not current target, returns false. This stock will be
  * refilled.
@@ -1668,8 +1668,8 @@ static bool consume_stock(struct mem_cgr
 	bool ret = true;
 
 	stock = &get_cpu_var(memcg_stock);
-	if (mem == stock->cached && stock->charge)
-		stock->charge -= PAGE_SIZE;
+	if (mem == stock->cached && stock->nr_pages)
+		stock->nr_pages--;
 	else /* need to call res_counter_charge */
 		ret = false;
 	put_cpu_var(memcg_stock);
@@ -1683,13 +1683,15 @@ static void drain_stock(struct memcg_sto
 {
 	struct mem_cgroup *old = stock->cached;
 
-	if (stock->charge) {
-		res_counter_uncharge(&old->res, stock->charge);
+	if (stock->nr_pages) {
+		unsigned long bytes = stock->nr_pages * PAGE_SIZE;
+
+		res_counter_uncharge(&old->res, bytes);
 		if (do_swap_account)
-			res_counter_uncharge(&old->memsw, stock->charge);
+			res_counter_uncharge(&old->memsw, bytes);
+		stock->nr_pages = 0;
 	}
 	stock->cached = NULL;
-	stock->charge = 0;
 }
 
 /*
@@ -1706,7 +1708,7 @@ static void drain_local_stock(struct wor
  * Cache charges(val) which is from res_counter, to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
  */
-static void refill_stock(struct mem_cgroup *mem, int val)
+static void refill_stock(struct mem_cgroup *mem, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
 
@@ -1714,7 +1716,7 @@ static void refill_stock(struct mem_cgro
 		drain_stock(stock);
 		stock->cached = mem;
 	}
-	stock->charge += val;
+	stock->nr_pages += nr_pages;
 	put_cpu_var(memcg_stock);
 }
 
@@ -2012,7 +2014,7 @@ again:
 	} while (ret != CHARGE_OK);
 
 	if (csize > page_size)
-		refill_stock(mem, csize - page_size);
+		refill_stock(mem, (csize - page_size) >> PAGE_SHIFT);
 	css_put(&mem->css);
 done:
 	*memcg = mem;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

