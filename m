From: akpm@linux-foundation.org
Subject: + memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch added to -mm tree
Date: Wed, 09 Feb 2011 13:35:29 -0800
Message-ID: <201102092135.p19LZTDi023541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab1BIVfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 16:35:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: unify charge/uncharge quantities to units of pages
has been added to the -mm tree.  Its filename is
     memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch

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
Subject: memcg: unify charge/uncharge quantities to units of pages
From: Johannes Weiner <hannes@cmpxchg.org>

There is no clear pattern when we pass a page count and when we pass a
byte count that is a multiple of PAGE_SIZE.

We never charge or uncharge subpage quantities, so convert it all to page
counts.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  117 +++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 63 deletions(-)

diff -puN mm/memcontrol.c~memcg-unify-charge-uncharge-quantities-to-units-of-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-unify-charge-uncharge-quantities-to-units-of-pages
+++ a/mm/memcontrol.c
@@ -1092,16 +1092,16 @@ unsigned long mem_cgroup_isolate_pages(u
  * @mem: the memory cgroup
  *
  * Returns the maximum amount of memory @mem can be charged with, in
- * bytes.
+ * pages.
  */
-static unsigned long long mem_cgroup_margin(struct mem_cgroup *mem)
+static unsigned long mem_cgroup_margin(struct mem_cgroup *mem)
 {
 	unsigned long long margin;
 
 	margin = res_counter_margin(&mem->res);
 	if (do_swap_account)
 		margin = min(margin, res_counter_margin(&mem->memsw));
-	return margin;
+	return margin >> PAGE_SHIFT;
 }
 
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
@@ -1637,7 +1637,7 @@ EXPORT_SYMBOL(mem_cgroup_update_page_sta
  * size of first charge trial. "32" comes from vmscan.c's magic value.
  * TODO: maybe necessary to use big numbers in big irons.
  */
-#define CHARGE_SIZE	(32 * PAGE_SIZE)
+#define CHARGE_BATCH	32U
 struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
@@ -1813,8 +1813,9 @@ enum {
 };
 
 static int __mem_cgroup_do_charge(struct mem_cgroup *mem, gfp_t gfp_mask,
-				int csize, bool oom_check)
+				  unsigned int nr_pages, bool oom_check)
 {
+	unsigned long csize = nr_pages * PAGE_SIZE;
 	struct mem_cgroup *mem_over_limit;
 	struct res_counter *fail_res;
 	unsigned long flags = 0;
@@ -1835,14 +1836,13 @@ static int __mem_cgroup_do_charge(struct
 	} else
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
 	/*
-	 * csize can be either a huge page (HPAGE_SIZE), a batch of
-	 * regular pages (CHARGE_SIZE), or a single regular page
-	 * (PAGE_SIZE).
+	 * nr_pages can be either a huge page (HPAGE_PMD_NR), a batch
+	 * of regular pages (CHARGE_BATCH), or a single regular page (1).
 	 *
 	 * Never reclaim on behalf of optional batching, retry with a
 	 * single page instead.
 	 */
-	if (csize == CHARGE_SIZE)
+	if (nr_pages == CHARGE_BATCH)
 		return CHARGE_RETRY;
 
 	if (!(gfp_mask & __GFP_WAIT))
@@ -1850,7 +1850,7 @@ static int __mem_cgroup_do_charge(struct
 
 	ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
 					      gfp_mask, flags);
-	if (mem_cgroup_margin(mem_over_limit) >= csize)
+	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		return CHARGE_RETRY;
 	/*
 	 * Even though the limit is exceeded at this point, reclaim
@@ -1861,7 +1861,7 @@ static int __mem_cgroup_do_charge(struct
 	 * unlikely to succeed so close to the limit, and we fall back
 	 * to regular pages anyway in case of failure.
 	 */
-	if (csize == PAGE_SIZE && ret)
+	if (nr_pages == 1 && ret)
 		return CHARGE_RETRY;
 
 	/*
@@ -1888,12 +1888,12 @@ static int __mem_cgroup_do_charge(struct
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
 				   gfp_t gfp_mask,
 				   struct mem_cgroup **memcg, bool oom,
-				   int page_size)
+				   unsigned int nr_pages)
 {
+	unsigned int batch = max(CHARGE_BATCH, nr_pages);
 	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *mem = NULL;
 	int ret;
-	int csize = max(CHARGE_SIZE, (unsigned long) page_size);
 
 	/*
 	 * Unlike gloval-vm's OOM-kill, we're not in memory shortage
@@ -1918,7 +1918,7 @@ again:
 		VM_BUG_ON(css_is_removed(&mem->css));
 		if (mem_cgroup_is_root(mem))
 			goto done;
-		if (page_size == PAGE_SIZE && consume_stock(mem))
+		if (nr_pages == 1 && consume_stock(mem))
 			goto done;
 		css_get(&mem->css);
 	} else {
@@ -1941,7 +1941,7 @@ again:
 			rcu_read_unlock();
 			goto done;
 		}
-		if (page_size == PAGE_SIZE && consume_stock(mem)) {
+		if (nr_pages == 1 && consume_stock(mem)) {
 			/*
 			 * It seems dagerous to access memcg without css_get().
 			 * But considering how consume_stok works, it's not
@@ -1976,13 +1976,12 @@ again:
 			nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 		}
 
-		ret = __mem_cgroup_do_charge(mem, gfp_mask, csize, oom_check);
-
+		ret = __mem_cgroup_do_charge(mem, gfp_mask, batch, oom_check);
 		switch (ret) {
 		case CHARGE_OK:
 			break;
 		case CHARGE_RETRY: /* not in OOM situation but retry */
-			csize = page_size;
+			batch = nr_pages;
 			css_put(&mem->css);
 			mem = NULL;
 			goto again;
@@ -2003,8 +2002,8 @@ again:
 		}
 	} while (ret != CHARGE_OK);
 
-	if (csize > page_size)
-		refill_stock(mem, (csize - page_size) >> PAGE_SHIFT);
+	if (batch > nr_pages)
+		refill_stock(mem, batch - nr_pages);
 	css_put(&mem->css);
 done:
 	*memcg = mem;
@@ -2085,10 +2084,8 @@ static void __mem_cgroup_commit_charge(s
 				       struct page *page,
 				       struct page_cgroup *pc,
 				       enum charge_type ctype,
-				       int page_size)
+				       unsigned int nr_pages)
 {
-	int nr_pages = page_size >> PAGE_SHIFT;
-
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
@@ -2181,11 +2178,11 @@ void mem_cgroup_split_huge_fixup(struct 
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  * @uncharge: whether we should call uncharge and css_put against @from.
- * @charge_size: number of bytes to charge (regular or huge page)
+ * @nr_pages: number of regular pages (>1 for huge pages)
  *
  * The caller must confirm following.
  * - page is not on LRU (isolate_page() is useful.)
- * - compound_lock is held when charge_size > PAGE_SIZE
+ * - compound_lock is held when nr_pages > 1
  *
  * This function doesn't do "charge" nor css_get to new cgroup. It should be
  * done by a caller(__mem_cgroup_try_charge would be usefull). If @uncharge is
@@ -2194,9 +2191,8 @@ void mem_cgroup_split_huge_fixup(struct 
  */
 static int mem_cgroup_move_account(struct page *page, struct page_cgroup *pc,
 				   struct mem_cgroup *from, struct mem_cgroup *to,
-				   bool uncharge, int charge_size)
+				   bool uncharge, unsigned int nr_pages)
 {
-	int nr_pages = charge_size >> PAGE_SHIFT;
 	unsigned long flags;
 	int ret;
 
@@ -2209,7 +2205,7 @@ static int mem_cgroup_move_account(struc
 	 * hold it.
 	 */
 	ret = -EBUSY;
-	if (charge_size > PAGE_SIZE && !PageTransHuge(page))
+	if (nr_pages > 1 && !PageTransHuge(page))
 		goto out;
 
 	lock_page_cgroup(pc);
@@ -2267,7 +2263,7 @@ static int mem_cgroup_move_parent(struct
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
-	int page_size = PAGE_SIZE;
+	unsigned int nr_pages;
 	unsigned long flags;
 	int ret;
 
@@ -2281,23 +2277,21 @@ static int mem_cgroup_move_parent(struct
 	if (isolate_lru_page(page))
 		goto put;
 
-	if (PageTransHuge(page))
-		page_size = HPAGE_SIZE;
+	nr_pages = hpage_nr_pages(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask,
-				&parent, false, page_size);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, nr_pages);
 	if (ret || !parent)
 		goto put_back;
 
-	if (page_size > PAGE_SIZE)
+	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(page, pc, child, parent, true, page_size);
+	ret = mem_cgroup_move_account(page, pc, child, parent, true, nr_pages);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, page_size >> PAGE_SHIFT);
+		mem_cgroup_cancel_charge(parent, nr_pages);
 
-	if (page_size > PAGE_SIZE)
+	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
 put_back:
 	putback_lru_page(page);
@@ -2317,13 +2311,13 @@ static int mem_cgroup_charge_common(stru
 				gfp_t gfp_mask, enum charge_type ctype)
 {
 	struct mem_cgroup *mem = NULL;
-	int page_size = PAGE_SIZE;
+	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
 	bool oom = true;
 	int ret;
 
 	if (PageTransHuge(page)) {
-		page_size <<= compound_order(page);
+		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
 		/*
 		 * Never OOM-kill a process for a huge page.  The
@@ -2335,11 +2329,11 @@ static int mem_cgroup_charge_common(stru
 	pc = lookup_page_cgroup(page);
 	BUG_ON(!pc); /* XXX: remove this and move pc lookup into commit */
 
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, nr_pages);
 	if (ret || !mem)
 		return ret;
 
-	__mem_cgroup_commit_charge(mem, page, pc, ctype, page_size);
+	__mem_cgroup_commit_charge(mem, page, pc, ctype, nr_pages);
 	return 0;
 }
 
@@ -2455,13 +2449,13 @@ int mem_cgroup_try_charge_swapin(struct 
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true, PAGE_SIZE);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true, 1);
 	css_put(&mem->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, ptr, true, PAGE_SIZE);
+	return __mem_cgroup_try_charge(mm, mask, ptr, true, 1);
 }
 
 static void
@@ -2477,7 +2471,7 @@ __mem_cgroup_commit_charge_swapin(struct
 	cgroup_exclude_rmdir(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, page, pc, ctype, PAGE_SIZE);
+	__mem_cgroup_commit_charge(ptr, page, pc, ctype, 1);
 	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
@@ -2531,10 +2525,11 @@ void mem_cgroup_cancel_charge_swapin(str
 
 static void
 __do_uncharge(struct mem_cgroup *mem, const enum charge_type ctype,
-	      int page_size)
+	      unsigned int nr_pages)
 {
 	struct memcg_batch_info *batch = NULL;
 	bool uncharge_memsw = true;
+
 	/* If swapout, usage of swap doesn't decrease */
 	if (!do_swap_account || ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		uncharge_memsw = false;
@@ -2558,7 +2553,7 @@ __do_uncharge(struct mem_cgroup *mem, co
 	if (!batch->do_batch || test_thread_flag(TIF_MEMDIE))
 		goto direct_uncharge;
 
-	if (page_size != PAGE_SIZE)
+	if (nr_pages > 1)
 		goto direct_uncharge;
 
 	/*
@@ -2574,9 +2569,9 @@ __do_uncharge(struct mem_cgroup *mem, co
 		batch->memsw_nr_pages++;
 	return;
 direct_uncharge:
-	res_counter_uncharge(&mem->res, page_size);
+	res_counter_uncharge(&mem->res, nr_pages * PAGE_SIZE);
 	if (uncharge_memsw)
-		res_counter_uncharge(&mem->memsw, page_size);
+		res_counter_uncharge(&mem->memsw, nr_pages * PAGE_SIZE);
 	if (unlikely(batch->memcg != mem))
 		memcg_oom_recover(mem);
 	return;
@@ -2588,10 +2583,9 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
-	int count;
-	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
-	int page_size = PAGE_SIZE;
+	unsigned int nr_pages = 1;
+	struct page_cgroup *pc;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2600,11 +2594,9 @@ __mem_cgroup_uncharge_common(struct page
 		return NULL;
 
 	if (PageTransHuge(page)) {
-		page_size <<= compound_order(page);
+		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
 	}
-
-	count = page_size >> PAGE_SHIFT;
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2637,7 +2629,7 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -count);
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -2658,7 +2650,7 @@ __mem_cgroup_uncharge_common(struct page
 		mem_cgroup_get(mem);
 	}
 	if (!mem_cgroup_is_root(mem))
-		__do_uncharge(mem, ctype, page_size);
+		__do_uncharge(mem, ctype, nr_pages);
 
 	return mem;
 
@@ -2850,8 +2842,8 @@ static inline int mem_cgroup_move_swap_a
 int mem_cgroup_prepare_migration(struct page *page,
 	struct page *newpage, struct mem_cgroup **ptr, gfp_t gfp_mask)
 {
-	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
+	struct page_cgroup *pc;
 	enum charge_type ctype;
 	int ret = 0;
 
@@ -2907,7 +2899,7 @@ int mem_cgroup_prepare_migration(struct 
 		return 0;
 
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, ptr, false, PAGE_SIZE);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, ptr, false, 1);
 	css_put(&mem->css);/* drop extra refcnt */
 	if (ret || *ptr == NULL) {
 		if (PageAnon(page)) {
@@ -2934,7 +2926,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(mem, page, pc, ctype, PAGE_SIZE);
+	__mem_cgroup_commit_charge(mem, page, pc, ctype, 1);
 	return ret;
 }
 
@@ -4591,8 +4583,7 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
-					      PAGE_SIZE);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false, 1);
 		if (ret || !mem)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return -ENOMEM;
@@ -4937,8 +4928,8 @@ retry:
 			if (isolate_lru_page(page))
 				goto put;
 			pc = lookup_page_cgroup(page);
-			if (!mem_cgroup_move_account(page, pc,
-					mc.from, mc.to, false, PAGE_SIZE)) {
+			if (!mem_cgroup_move_account(page, pc, mc.from,
+						     mc.to, false, 1)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

