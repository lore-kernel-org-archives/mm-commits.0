From: akpm@linux-foundation.org
Subject: - memcg-memswap-controller-core.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:26 -0800
Message-ID: <200901082248.n08MmQ7C027779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240AbZAHWtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: mem+swap controller core
has been removed from the -mm tree.  Its filename was
     memcg-memswap-controller-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: mem+swap controller core
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch implements per cgroup limit for usage of memory+swap.  However
there are SwapCache, double counting of swap-cache and swap-entry is
avoided.

Mem+Swap controller works as following.
  - memory usage is limited by memory.limit_in_bytes.
  - memory + swap usage is limited by memory.memsw_limit_in_bytes.

This has following benefits.
  - A user can limit total resource usage of mem+swap.

    Without this, because memory resource controller doesn't take care of
    usage of swap, a process can exhaust all the swap (by memory leak.)
    We can avoid this case.

    And Swap is shared resource but it cannot be reclaimed (goes back to memory)
    until it's used. This characteristic can be trouble when the memory
    is divided into some parts by cpuset or memcg.
    Assume group A and group B.
    After some application executes, the system can be..

    Group A -- very large free memory space but occupy 99% of swap.
    Group B -- under memory shortage but cannot use swap...it's nearly full.

    Ability to set appropriate swap limit for each group is required.

Maybe someone wonder "why not swap but mem+swap ?"

  - The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
    to move account from memory to swap...there is no change in usage of
    mem+swap.

    In other words, when we want to limit the usage of swap without affecting
    global LRU, mem+swap limit is better than just limiting swap.

Accounting target information is stored in swap_cgroup which is
per swap entry record.

Charge is done as following.
  map
    - charge  page and memsw.

  unmap
    - uncharge page/memsw if not SwapCache.

  swap-out (__delete_from_swap_cache)
    - uncharge page
    - record mem_cgroup information to swap_cgroup.

  swap-in (do_swap_page)
    - charged as page and memsw.
      record in swap_cgroup is cleared.
      memsw accounting is decremented.

  swap-free (swap_free())
    - if swap entry is freed, memsw is uncharged by PAGE_SIZE.

There are people work under never-swap environments and consider swap as
something bad. For such people, this mem+swap controller extension is just an
overhead.  This overhead is avoided by config or boot option.
(see Kconfig. detail is not in this patch.)

TODO:
 - maybe more optimization can be don in swap-in path. (but not very safe.)
   But we just do simple accounting at this stage.

[nishimura@mxp.nes.nec.co.jp: make resize limit hold mutex]
[hugh@veritas.com: memswap controller core swapcache fixes]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   29 +
 include/linux/memcontrol.h           |   11 
 include/linux/swap.h                 |   14 
 mm/memcontrol.c                      |  402 ++++++++++++++++++++++---
 mm/memory.c                          |   18 -
 mm/swap_state.c                      |    5 
 mm/swapfile.c                        |   11 
 mm/vmscan.c                          |    6 
 8 files changed, 441 insertions(+), 55 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-memswap-controller-core Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-memswap-controller-core
+++ a/Documentation/controllers/memory.txt
@@ -137,12 +137,32 @@ behind this approach is that a cgroup th
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
-Exception: When you do swapoff and make swapped-out pages of shmem(tmpfs) to
+Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used..
+When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
 
 
-2.4 Reclaim
+2.4 Swap Extension (CONFIG_CGROUP_MEM_RES_CTLR_SWAP)
+Swap Extension allows you to record charge for swap. A swapped-in page is
+charged back to original page allocator if possible.
+
+When swap is accounted, following files are added.
+ - memory.memsw.usage_in_bytes.
+ - memory.memsw.limit_in_bytes.
+
+usage of mem+swap is limited by memsw.limit_in_bytes.
+
+Note: why 'mem+swap' rather than swap.
+The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
+to move account from memory to swap...there is no change in usage of
+mem+swap.
+
+In other words, when we want to limit the usage of swap without affecting
+global LRU, mem+swap limit is better than just limiting swap from OS point
+of view.
+
+2.5 Reclaim
 
 Each cgroup maintains a per cgroup LRU that consists of an active
 and inactive list. When a cgroup goes over its limit, we first try
@@ -246,6 +266,11 @@ Such charges are freed(at default) or mo
 both of RSS and CACHES are moved to parent.
 If both of them are busy, rmdir() returns -EBUSY. See 5.1 Also.
 
+Charges recorded in swap information is not updated at removal of cgroup.
+Recorded information is discarded and a cgroup which uses swap (swapcache)
+will be charged as a new owner of it.
+
+
 5. Misc. interfaces.
 
 5.1 force_empty
diff -puN include/linux/memcontrol.h~memcg-memswap-controller-core include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-memswap-controller-core
+++ a/include/linux/memcontrol.h
@@ -32,6 +32,8 @@ extern int mem_cgroup_newpage_charge(str
 /* for swap handling */
 extern int mem_cgroup_try_charge(struct mm_struct *mm,
 		gfp_t gfp_mask, struct mem_cgroup **ptr);
+extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
+		struct page *page, gfp_t mask, struct mem_cgroup **ptr);
 extern void mem_cgroup_commit_charge_swapin(struct page *page,
 					struct mem_cgroup *ptr);
 extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr);
@@ -80,7 +82,6 @@ extern long mem_cgroup_calc_reclaim(stru
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
-
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -97,7 +98,13 @@ static inline int mem_cgroup_cache_charg
 }
 
 static inline int mem_cgroup_try_charge(struct mm_struct *mm,
-				gfp_t gfp_mask, struct mem_cgroup **ptr)
+			gfp_t gfp_mask, struct mem_cgroup **ptr)
+{
+	return 0;
+}
+
+static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
+		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
 	return 0;
 }
diff -puN include/linux/swap.h~memcg-memswap-controller-core include/linux/swap.h
--- a/include/linux/swap.h~memcg-memswap-controller-core
+++ a/include/linux/swap.h
@@ -214,7 +214,7 @@ static inline void lru_cache_add_active_
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
-							gfp_t gfp_mask);
+						gfp_t gfp_mask, bool noswap);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
@@ -336,7 +336,7 @@ static inline void disable_swap_token(vo
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern int mem_cgroup_cache_charge_swapin(struct page *page,
 				struct mm_struct *mm, gfp_t mask, bool locked);
-extern void mem_cgroup_uncharge_swapcache(struct page *page);
+extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
 #else
 static inline
 int mem_cgroup_cache_charge_swapin(struct page *page,
@@ -344,7 +344,15 @@ int mem_cgroup_cache_charge_swapin(struc
 {
 	return 0;
 }
-static inline void mem_cgroup_uncharge_swapcache(struct page *page)
+static inline void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+{
+}
+#endif
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
+#else
+static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
 {
 }
 #endif
diff -puN mm/memcontrol.c~memcg-memswap-controller-core mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memswap-controller-core
+++ a/mm/memcontrol.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/spinlock.h>
@@ -132,12 +133,18 @@ struct mem_cgroup {
 	 */
 	struct res_counter res;
 	/*
+	 * the counter to account for mem+swap usage.
+	 */
+	struct res_counter memsw;
+	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
 	 */
 	struct mem_cgroup_lru_info info;
 
 	int	prev_priority;	/* for recording reclaim priority */
+	int		obsolete;
+	atomic_t	refcnt;
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -167,6 +174,17 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 	0, /* FORCE */
 };
 
+
+/* for encoding cft->private value on file */
+#define _MEM			(0)
+#define _MEMSWAP		(1)
+#define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
+#define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
+#define MEMFILE_ATTR(val)	((val) & 0xffff)
+
+static void mem_cgroup_get(struct mem_cgroup *mem);
+static void mem_cgroup_put(struct mem_cgroup *mem);
+
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
  */
@@ -485,7 +503,8 @@ unsigned long mem_cgroup_isolate_pages(u
  * oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
-			gfp_t gfp_mask, struct mem_cgroup **memcg, bool oom)
+			gfp_t gfp_mask, struct mem_cgroup **memcg,
+			bool oom)
 {
 	struct mem_cgroup *mem;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
@@ -513,12 +532,25 @@ static int __mem_cgroup_try_charge(struc
 		css_get(&mem->css);
 	}
 
-
-	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE))) {
+	while (1) {
+		int ret;
+		bool noswap = false;
+
+		ret = res_counter_charge(&mem->res, PAGE_SIZE);
+		if (likely(!ret)) {
+			if (!do_swap_account)
+				break;
+			ret = res_counter_charge(&mem->memsw, PAGE_SIZE);
+			if (likely(!ret))
+				break;
+			/* mem+swap counter fails */
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			noswap = true;
+		}
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
+		if (try_to_free_mem_cgroup_pages(mem, gfp_mask, noswap))
 			continue;
 
 		/*
@@ -527,8 +559,13 @@ static int __mem_cgroup_try_charge(struc
 		 * moved to swap cache or just unmapped from the cgroup.
 		 * Check the limit again to see if the reclaim reduced the
 		 * current usage of the cgroup before giving up
+		 *
 		 */
-		if (res_counter_check_under_limit(&mem->res))
+		if (!do_swap_account &&
+			res_counter_check_under_limit(&mem->res))
+			continue;
+		if (do_swap_account &&
+			res_counter_check_under_limit(&mem->memsw))
 			continue;
 
 		if (!nr_retries--) {
@@ -582,6 +619,8 @@ static void __mem_cgroup_commit_charge(s
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		if (do_swap_account)
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 		css_put(&mem->css);
 		return;
 	}
@@ -646,6 +685,8 @@ static int mem_cgroup_move_account(struc
 		__mem_cgroup_remove_list(from_mz, pc);
 		css_put(&from->css);
 		res_counter_uncharge(&from->res, PAGE_SIZE);
+		if (do_swap_account)
+			res_counter_uncharge(&from->memsw, PAGE_SIZE);
 		pc->mem_cgroup = to;
 		css_get(&to->css);
 		__mem_cgroup_add_list(to_mz, pc, false);
@@ -692,8 +733,11 @@ static int mem_cgroup_move_parent(struct
 	/* drop extra refcnt */
 	css_put(&parent->css);
 	/* uncharge if move fails */
-	if (ret)
+	if (ret) {
 		res_counter_uncharge(&parent->res, PAGE_SIZE);
+		if (do_swap_account)
+			res_counter_uncharge(&parent->memsw, PAGE_SIZE);
+	}
 
 	return ret;
 }
@@ -791,7 +835,42 @@ int mem_cgroup_cache_charge(struct page 
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
 }
 
+int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
+				 struct page *page,
+				 gfp_t mask, struct mem_cgroup **ptr)
+{
+	struct mem_cgroup *mem;
+	swp_entry_t     ent;
+
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
+	if (!do_swap_account)
+		goto charge_cur_mm;
+
+	/*
+	 * A racing thread's fault, or swapoff, may have already updated
+	 * the pte, and even removed page from swap cache: return success
+	 * to go on to do_swap_page()'s pte_same() test, which should fail.
+	 */
+	if (!PageSwapCache(page))
+		return 0;
+
+	ent.val = page_private(page);
+
+	mem = lookup_swap_cgroup(ent);
+	if (!mem || mem->obsolete)
+		goto charge_cur_mm;
+	*ptr = mem;
+	return __mem_cgroup_try_charge(NULL, mask, ptr, true);
+charge_cur_mm:
+	if (unlikely(!mm))
+		mm = &init_mm;
+	return __mem_cgroup_try_charge(mm, mask, ptr, true);
+}
+
 #ifdef CONFIG_SWAP
+
 int mem_cgroup_cache_charge_swapin(struct page *page,
 			struct mm_struct *mm, gfp_t mask, bool locked)
 {
@@ -808,8 +887,28 @@ int mem_cgroup_cache_charge_swapin(struc
 	 * we reach here.
 	 */
 	if (PageSwapCache(page)) {
+		struct mem_cgroup *mem = NULL;
+		swp_entry_t ent;
+
+		ent.val = page_private(page);
+		if (do_swap_account) {
+			mem = lookup_swap_cgroup(ent);
+			if (mem && mem->obsolete)
+				mem = NULL;
+			if (mem)
+				mm = NULL;
+		}
 		ret = mem_cgroup_charge_common(page, mm, mask,
-				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
+				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+
+		if (!ret && do_swap_account) {
+			/* avoid double counting */
+			mem = swap_cgroup_record(ent, NULL);
+			if (mem) {
+				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+				mem_cgroup_put(mem);
+			}
+		}
 	}
 	if (!locked)
 		unlock_page(page);
@@ -828,6 +927,23 @@ void mem_cgroup_commit_charge_swapin(str
 		return;
 	pc = lookup_page_cgroup(page);
 	__mem_cgroup_commit_charge(ptr, pc, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	/*
+	 * Now swap is on-memory. This means this page may be
+	 * counted both as mem and swap....double count.
+	 * Fix it by uncharging from memsw. This SwapCache is stable
+	 * because we're still under lock_page().
+	 */
+	if (do_swap_account) {
+		swp_entry_t ent = {.val = page_private(page)};
+		struct mem_cgroup *memcg;
+		memcg = swap_cgroup_record(ent, NULL);
+		if (memcg) {
+			/* If memcg is obsolete, memcg can be != ptr */
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+			mem_cgroup_put(memcg);
+		}
+
+	}
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
@@ -837,6 +953,8 @@ void mem_cgroup_cancel_charge_swapin(str
 	if (!mem)
 		return;
 	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	if (do_swap_account)
+		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 	css_put(&mem->css);
 }
 
@@ -844,29 +962,31 @@ void mem_cgroup_cancel_charge_swapin(str
 /*
  * uncharge if !page_mapped(page)
  */
-static void
+static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
 	struct page_cgroup *pc;
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
 	if (mem_cgroup_subsys.disabled)
-		return;
+		return NULL;
 
 	if (PageSwapCache(page))
-		return;
+		return NULL;
 
 	/*
 	 * Check if our page_cgroup is valid
 	 */
 	pc = lookup_page_cgroup(page);
 	if (unlikely(!pc || !PageCgroupUsed(pc)))
-		return;
+		return NULL;
 
 	lock_page_cgroup(pc);
 
+	mem = pc->mem_cgroup;
+
 	if (!PageCgroupUsed(pc))
 		goto unlock_out;
 
@@ -886,8 +1006,11 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
+	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
+		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+
 	ClearPageCgroupUsed(pc);
-	mem = pc->mem_cgroup;
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
@@ -895,14 +1018,13 @@ __mem_cgroup_uncharge_common(struct page
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 	unlock_page_cgroup(pc);
 
-	res_counter_uncharge(&mem->res, PAGE_SIZE);
 	css_put(&mem->css);
 
-	return;
+	return mem;
 
 unlock_out:
 	unlock_page_cgroup(pc);
-	return;
+	return NULL;
 }
 
 void mem_cgroup_uncharge_page(struct page *page)
@@ -922,11 +1044,43 @@ void mem_cgroup_uncharge_cache_page(stru
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
 
-void mem_cgroup_uncharge_swapcache(struct page *page)
+/*
+ * called from __delete_from_swap_cache() and drop "page" account.
+ * memcg information is recorded to swap_cgroup of "ent"
+ */
+void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
 {
-	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
+	struct mem_cgroup *memcg;
+
+	memcg = __mem_cgroup_uncharge_common(page,
+					MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
+	/* record memcg information */
+	if (do_swap_account && memcg) {
+		swap_cgroup_record(ent, memcg);
+		mem_cgroup_get(memcg);
+	}
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+/*
+ * called from swap_entry_free(). remove record in swap_cgroup and
+ * uncharge "memsw" account.
+ */
+void mem_cgroup_uncharge_swap(swp_entry_t ent)
+{
+	struct mem_cgroup *memcg;
+
+	if (!do_swap_account)
+		return;
+
+	memcg = swap_cgroup_record(ent, NULL);
+	if (memcg) {
+		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		mem_cgroup_put(memcg);
+	}
+}
+#endif
+
 /*
  * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
  * page belongs to.
@@ -1034,7 +1188,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 	rcu_read_unlock();
 
 	do {
-		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
+		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true);
 		progress += res_counter_check_under_limit(&mem->res);
 	} while (!progress && --retry);
 
@@ -1044,26 +1198,84 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
+static DEFINE_MUTEX(set_limit_mutex);
+
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
-				   unsigned long long val)
+				unsigned long long val)
 {
 
 	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
 	int progress;
+	u64 memswlimit;
 	int ret = 0;
 
-	while (res_counter_set_limit(&memcg->res, val)) {
+	while (retry_count) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
-		if (!retry_count) {
-			ret = -EBUSY;
+		/*
+		 * Rather than hide all in some function, I do this in
+		 * open coded manner. You see what this really does.
+		 * We have to guarantee mem->res.limit < mem->memsw.limit.
+		 */
+		mutex_lock(&set_limit_mutex);
+		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+		if (memswlimit < val) {
+			ret = -EINVAL;
+			mutex_unlock(&set_limit_mutex);
 			break;
 		}
+		ret = res_counter_set_limit(&memcg->res, val);
+		mutex_unlock(&set_limit_mutex);
+
+		if (!ret)
+			break;
+
 		progress = try_to_free_mem_cgroup_pages(memcg,
-				GFP_HIGHUSER_MOVABLE);
-		if (!progress)
+				GFP_HIGHUSER_MOVABLE, false);
+  		if (!progress)			retry_count--;
+	}
+	return ret;
+}
+
+int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
+				unsigned long long val)
+{
+	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
+	u64 memlimit, oldusage, curusage;
+	int ret;
+
+	if (!do_swap_account)
+		return -EINVAL;
+
+	while (retry_count) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+		/*
+		 * Rather than hide all in some function, I do this in
+		 * open coded manner. You see what this really does.
+		 * We have to guarantee mem->res.limit < mem->memsw.limit.
+		 */
+		mutex_lock(&set_limit_mutex);
+		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+		if (memlimit > val) {
+			ret = -EINVAL;
+			mutex_unlock(&set_limit_mutex);
+			break;
+		}
+		ret = res_counter_set_limit(&memcg->memsw, val);
+		mutex_unlock(&set_limit_mutex);
+
+		if (!ret)
+			break;
+
+		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		try_to_free_mem_cgroup_pages(memcg, GFP_HIGHUSER_MOVABLE, true);
+		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		if (curusage >= oldusage)
 			retry_count--;
 	}
 	return ret;
@@ -1193,7 +1405,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem,
-						  GFP_HIGHUSER_MOVABLE);
+						  GFP_HIGHUSER_MOVABLE, false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -1216,8 +1428,25 @@ int mem_cgroup_force_empty_write(struct 
 
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
-	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
-				    cft->private);
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	u64 val = 0;
+	int type, name;
+
+	type = MEMFILE_TYPE(cft->private);
+	name = MEMFILE_ATTR(cft->private);
+	switch (type) {
+	case _MEM:
+		val = res_counter_read_u64(&mem->res, name);
+		break;
+	case _MEMSWAP:
+		if (do_swap_account)
+			val = res_counter_read_u64(&mem->memsw, name);
+		break;
+	default:
+		BUG();
+		break;
+	}
+	return val;
 }
 /*
  * The user of this function is...
@@ -1227,15 +1456,22 @@ static int mem_cgroup_write(struct cgrou
 			    const char *buffer)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	int type, name;
 	unsigned long long val;
 	int ret;
 
-	switch (cft->private) {
+	type = MEMFILE_TYPE(cft->private);
+	name = MEMFILE_ATTR(cft->private);
+	switch (name) {
 	case RES_LIMIT:
 		/* This function does all necessary parse...reuse it */
 		ret = res_counter_memparse_write_strategy(buffer, &val);
-		if (!ret)
+		if (ret)
+			break;
+		if (type == _MEM)
 			ret = mem_cgroup_resize_limit(memcg, val);
+		else
+			ret = mem_cgroup_resize_memsw_limit(memcg, val);
 		break;
 	default:
 		ret = -EINVAL; /* should be BUG() ? */
@@ -1247,14 +1483,23 @@ static int mem_cgroup_write(struct cgrou
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
+	int type, name;
 
 	mem = mem_cgroup_from_cont(cont);
-	switch (event) {
+	type = MEMFILE_TYPE(event);
+	name = MEMFILE_ATTR(event);
+	switch (name) {
 	case RES_MAX_USAGE:
-		res_counter_reset_max(&mem->res);
+		if (type == _MEM)
+			res_counter_reset_max(&mem->res);
+		else
+			res_counter_reset_max(&mem->memsw);
 		break;
 	case RES_FAILCNT:
-		res_counter_reset_failcnt(&mem->res);
+		if (type == _MEM)
+			res_counter_reset_failcnt(&mem->res);
+		else
+			res_counter_reset_failcnt(&mem->memsw);
 		break;
 	}
 	return 0;
@@ -1315,24 +1560,24 @@ static int mem_control_stat_show(struct 
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
-		.private = RES_USAGE,
+		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "max_usage_in_bytes",
-		.private = RES_MAX_USAGE,
+		.private = MEMFILE_PRIVATE(_MEM, RES_MAX_USAGE),
 		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "limit_in_bytes",
-		.private = RES_LIMIT,
+		.private = MEMFILE_PRIVATE(_MEM, RES_LIMIT),
 		.write_string = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "failcnt",
-		.private = RES_FAILCNT,
+		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
 		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
@@ -1346,6 +1591,47 @@ static struct cftype mem_cgroup_files[] 
 	},
 };
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static struct cftype memsw_cgroup_files[] = {
+	{
+		.name = "memsw.usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
+		.read_u64 = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.max_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
+		.trigger = mem_cgroup_reset,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.failcnt",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
+		.trigger = mem_cgroup_reset,
+		.read_u64 = mem_cgroup_read,
+	},
+};
+
+static int register_memsw_files(struct cgroup *cont, struct cgroup_subsys *ss)
+{
+	if (!do_swap_account)
+		return 0;
+	return cgroup_add_files(cont, ss, memsw_cgroup_files,
+				ARRAY_SIZE(memsw_cgroup_files));
+};
+#else
+static int register_memsw_files(struct cgroup *cont, struct cgroup_subsys *ss)
+{
+	return 0;
+}
+#endif
+
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -1404,14 +1690,44 @@ static struct mem_cgroup *mem_cgroup_all
 	return mem;
 }
 
+/*
+ * At destroying mem_cgroup, references from swap_cgroup can remain.
+ * (scanning all at force_empty is too costly...)
+ *
+ * Instead of clearing all references at force_empty, we remember
+ * the number of reference from swap_cgroup and free mem_cgroup when
+ * it goes down to 0.
+ *
+ * When mem_cgroup is destroyed, mem->obsolete will be set to 0 and
+ * entry which points to this memcg will be ignore at swapin.
+ *
+ * Removal of cgroup itself succeeds regardless of refs from swap.
+ */
+
 static void mem_cgroup_free(struct mem_cgroup *mem)
 {
+	if (atomic_read(&mem->refcnt) > 0)
+		return;
 	if (mem_cgroup_size() < PAGE_SIZE)
 		kfree(mem);
 	else
 		vfree(mem);
 }
 
+static void mem_cgroup_get(struct mem_cgroup *mem)
+{
+	atomic_inc(&mem->refcnt);
+}
+
+static void mem_cgroup_put(struct mem_cgroup *mem)
+{
+	if (atomic_dec_and_test(&mem->refcnt)) {
+		if (!mem->obsolete)
+			return;
+		mem_cgroup_free(mem);
+	}
+}
+
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static void __init enable_swap_cgroup(void)
@@ -1436,6 +1752,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		return ERR_PTR(-ENOMEM);
 
 	res_counter_init(&mem->res);
+	res_counter_init(&mem->memsw);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
@@ -1456,6 +1773,7 @@ static void mem_cgroup_pre_destroy(struc
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	mem->obsolete = 1;
 	mem_cgroup_force_empty(mem, false);
 }
 
@@ -1474,8 +1792,14 @@ static void mem_cgroup_destroy(struct cg
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	return cgroup_add_files(cont, ss, mem_cgroup_files,
-					ARRAY_SIZE(mem_cgroup_files));
+	int ret;
+
+	ret = cgroup_add_files(cont, ss, mem_cgroup_files,
+				ARRAY_SIZE(mem_cgroup_files));
+
+	if (!ret)
+		ret = register_memsw_files(cont, ss);
+	return ret;
 }
 
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
diff -puN mm/memory.c~memcg-memswap-controller-core mm/memory.c
--- a/mm/memory.c~memcg-memswap-controller-core
+++ a/mm/memory.c
@@ -2431,7 +2431,8 @@ static int do_swap_page(struct mm_struct
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
-	if (mem_cgroup_try_charge(mm, GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
+	if (mem_cgroup_try_charge_swapin(mm, page,
+				GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
 		ret = VM_FAULT_OOM;
 		unlock_page(page);
 		goto out;
@@ -2449,8 +2450,20 @@ static int do_swap_page(struct mm_struct
 		goto out_nomap;
 	}
 
-	/* The page isn't present yet, go ahead with the fault. */
+	/*
+	 * The page isn't present yet, go ahead with the fault.
+	 *
+	 * Be careful about the sequence of operations here.
+	 * To get its accounting right, reuse_swap_page() must be called
+	 * while the page is counted on swap but not yet in mapcount i.e.
+	 * before page_add_anon_rmap() and swap_free(); try_to_free_swap()
+	 * must be called after the swap_free(), or it will never succeed.
+	 * And mem_cgroup_commit_charge_swapin(), which uses the swp_entry
+	 * in page->private, must be called before reuse_swap_page(),
+	 * which may delete_from_swap_cache().
+	 */
 
+	mem_cgroup_commit_charge_swapin(page, ptr);
 	inc_mm_counter(mm, anon_rss);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if (write_access && reuse_swap_page(page)) {
@@ -2461,7 +2474,6 @@ static int do_swap_page(struct mm_struct
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
-	mem_cgroup_commit_charge_swapin(page, ptr);
 
 	swap_free(entry);
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
diff -puN mm/swap_state.c~memcg-memswap-controller-core mm/swap_state.c
--- a/mm/swap_state.c~memcg-memswap-controller-core
+++ a/mm/swap_state.c
@@ -17,6 +17,7 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
+#include <linux/page_cgroup.h>
 
 #include <asm/pgtable.h>
 
@@ -108,6 +109,8 @@ int add_to_swap_cache(struct page *page,
  */
 void __delete_from_swap_cache(struct page *page)
 {
+	swp_entry_t ent = {.val = page_private(page)};
+
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageSwapCache(page));
 	VM_BUG_ON(PageWriteback(page));
@@ -118,7 +121,7 @@ void __delete_from_swap_cache(struct pag
 	total_swapcache_pages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
-	mem_cgroup_uncharge_swapcache(page);
+	mem_cgroup_uncharge_swapcache(page, ent);
 }
 
 /**
diff -puN mm/swapfile.c~memcg-memswap-controller-core mm/swapfile.c
--- a/mm/swapfile.c~memcg-memswap-controller-core
+++ a/mm/swapfile.c
@@ -471,8 +471,9 @@ out:
 	return NULL;
 }
 
-static int swap_entry_free(struct swap_info_struct *p, unsigned long offset)
+static int swap_entry_free(struct swap_info_struct *p, swp_entry_t ent)
 {
+	unsigned long offset = swp_offset(ent);
 	int count = p->swap_map[offset];
 
 	if (count < SWAP_MAP_MAX) {
@@ -487,6 +488,7 @@ static int swap_entry_free(struct swap_i
 				swap_list.next = p - swap_info;
 			nr_swap_pages++;
 			p->inuse_pages--;
+			mem_cgroup_uncharge_swap(ent);
 		}
 	}
 	return count;
@@ -502,7 +504,7 @@ void swap_free(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, swp_offset(entry));
+		swap_entry_free(p, entry);
 		spin_unlock(&swap_lock);
 	}
 }
@@ -582,7 +584,7 @@ int free_swap_and_cache(swp_entry_t entr
 
 	p = swap_info_get(entry);
 	if (p) {
-		if (swap_entry_free(p, swp_offset(entry)) == 1) {
+		if (swap_entry_free(p, entry) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
 			if (page && !trylock_page(page)) {
 				page_cache_release(page);
@@ -696,7 +698,8 @@ static int unuse_pte(struct vm_area_stru
 	pte_t *pte;
 	int ret = 1;
 
-	if (mem_cgroup_try_charge(vma->vm_mm, GFP_HIGHUSER_MOVABLE, &ptr))
+	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
+					GFP_HIGHUSER_MOVABLE, &ptr))
 		ret = -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
diff -puN mm/vmscan.c~memcg-memswap-controller-core mm/vmscan.c
--- a/mm/vmscan.c~memcg-memswap-controller-core
+++ a/mm/vmscan.c
@@ -1661,7 +1661,8 @@ unsigned long try_to_free_pages(struct z
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
-						gfp_t gfp_mask)
+						gfp_t gfp_mask,
+					   bool noswap)
 {
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
@@ -1674,6 +1675,9 @@ unsigned long try_to_free_mem_cgroup_pag
 	};
 	struct zonelist *zonelist;
 
+	if (noswap)
+		sc.may_swap = 0;
+
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

