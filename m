From: akpm@linux-foundation.org
Subject: [merged] thp-memcg-compound.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:32 -0800
Message-ID: <201101142250.p0EMoMLU005404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884Ab1ANWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: memcg compound
has been removed from the -mm tree.  Its filename was
     thp-memcg-compound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: memcg compound
From: Andrea Arcangeli <aarcange@redhat.com>

Teach memcg to charge/uncharge compound pages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   83 +++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 30 deletions(-)

diff -puN mm/memcontrol.c~thp-memcg-compound mm/memcontrol.c
--- a/mm/memcontrol.c~thp-memcg-compound
+++ a/mm/memcontrol.c
@@ -1027,6 +1027,10 @@ mem_cgroup_get_reclaim_stat_from_page(st
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
+	int page_size = PAGE_SIZE;
+
+	if (PageTransHuge(page))
+		page_size <<= compound_order(page);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1887,12 +1891,14 @@ static int __mem_cgroup_do_charge(struct
  * oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
-		gfp_t gfp_mask, struct mem_cgroup **memcg, bool oom)
+				   gfp_t gfp_mask,
+				   struct mem_cgroup **memcg, bool oom,
+				   int page_size)
 {
 	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *mem = NULL;
 	int ret;
-	int csize = CHARGE_SIZE;
+	int csize = max(CHARGE_SIZE, (unsigned long) page_size);
 
 	/*
 	 * Unlike gloval-vm's OOM-kill, we're not in memory shortage
@@ -1917,7 +1923,7 @@ again:
 		VM_BUG_ON(css_is_removed(&mem->css));
 		if (mem_cgroup_is_root(mem))
 			goto done;
-		if (consume_stock(mem))
+		if (page_size == PAGE_SIZE && consume_stock(mem))
 			goto done;
 		css_get(&mem->css);
 	} else {
@@ -1940,7 +1946,7 @@ again:
 			rcu_read_unlock();
 			goto done;
 		}
-		if (consume_stock(mem)) {
+		if (page_size == PAGE_SIZE && consume_stock(mem)) {
 			/*
 			 * It seems dagerous to access memcg without css_get().
 			 * But considering how consume_stok works, it's not
@@ -1981,7 +1987,7 @@ again:
 		case CHARGE_OK:
 			break;
 		case CHARGE_RETRY: /* not in OOM situation but retry */
-			csize = PAGE_SIZE;
+			csize = page_size;
 			css_put(&mem->css);
 			mem = NULL;
 			goto again;
@@ -2002,8 +2008,8 @@ again:
 		}
 	} while (ret != CHARGE_OK);
 
-	if (csize > PAGE_SIZE)
-		refill_stock(mem, csize - PAGE_SIZE);
+	if (csize > page_size)
+		refill_stock(mem, csize - page_size);
 	css_put(&mem->css);
 done:
 	*memcg = mem;
@@ -2031,9 +2037,10 @@ static void __mem_cgroup_cancel_charge(s
 	}
 }
 
-static void mem_cgroup_cancel_charge(struct mem_cgroup *mem)
+static void mem_cgroup_cancel_charge(struct mem_cgroup *mem,
+				     int page_size)
 {
-	__mem_cgroup_cancel_charge(mem, 1);
+	__mem_cgroup_cancel_charge(mem, page_size >> PAGE_SHIFT);
 }
 
 /*
@@ -2089,8 +2096,9 @@ struct mem_cgroup *try_get_mem_cgroup_fr
  */
 
 static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
-				     struct page_cgroup *pc,
-				     enum charge_type ctype)
+				       struct page_cgroup *pc,
+				       enum charge_type ctype,
+				       int page_size)
 {
 	/* try_charge() can return NULL to *memcg, taking care of it. */
 	if (!mem)
@@ -2099,7 +2107,7 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem);
+		mem_cgroup_cancel_charge(mem, page_size);
 		return;
 	}
 
@@ -2173,7 +2181,7 @@ static void __mem_cgroup_move_account(st
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from);
+		mem_cgroup_cancel_charge(from, PAGE_SIZE);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2234,13 +2242,14 @@ static int mem_cgroup_move_parent(struct
 		goto put;
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false,
+				      PAGE_SIZE);
 	if (ret || !parent)
 		goto put_back;
 
 	ret = mem_cgroup_move_account(pc, child, parent, true);
 	if (ret)
-		mem_cgroup_cancel_charge(parent);
+		mem_cgroup_cancel_charge(parent, PAGE_SIZE);
 put_back:
 	putback_lru_page(page);
 put:
@@ -2261,6 +2270,10 @@ static int mem_cgroup_charge_common(stru
 	struct mem_cgroup *mem = NULL;
 	struct page_cgroup *pc;
 	int ret;
+	int page_size = PAGE_SIZE;
+
+	if (PageTransHuge(page))
+		page_size <<= compound_order(page);
 
 	pc = lookup_page_cgroup(page);
 	/* can happen at boot */
@@ -2268,11 +2281,11 @@ static int mem_cgroup_charge_common(stru
 		return 0;
 	prefetchw(pc);
 
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page_size);
 	if (ret || !mem)
 		return ret;
 
-	__mem_cgroup_commit_charge(mem, pc, ctype);
+	__mem_cgroup_commit_charge(mem, pc, ctype, page_size);
 	return 0;
 }
 
@@ -2281,8 +2294,6 @@ int mem_cgroup_newpage_charge(struct pag
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	if (PageCompound(page))
-		return 0;
 	/*
 	 * If already mapped, we don't have to account.
 	 * If page cache, page->mapping has address_space.
@@ -2388,13 +2399,13 @@ int mem_cgroup_try_charge_swapin(struct 
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true, PAGE_SIZE);
 	css_put(&mem->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, ptr, true);
+	return __mem_cgroup_try_charge(mm, mask, ptr, true, PAGE_SIZE);
 }
 
 static void
@@ -2410,7 +2421,7 @@ __mem_cgroup_commit_charge_swapin(struct
 	cgroup_exclude_rmdir(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, pc, ctype);
+	__mem_cgroup_commit_charge(ptr, pc, ctype, PAGE_SIZE);
 	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
@@ -2459,11 +2470,12 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	mem_cgroup_cancel_charge(mem);
+	mem_cgroup_cancel_charge(mem, PAGE_SIZE);
 }
 
 static void
-__do_uncharge(struct mem_cgroup *mem, const enum charge_type ctype)
+__do_uncharge(struct mem_cgroup *mem, const enum charge_type ctype,
+	      int page_size)
 {
 	struct memcg_batch_info *batch = NULL;
 	bool uncharge_memsw = true;
@@ -2490,6 +2502,9 @@ __do_uncharge(struct mem_cgroup *mem, co
 	if (!batch->do_batch || test_thread_flag(TIF_MEMDIE))
 		goto direct_uncharge;
 
+	if (page_size != PAGE_SIZE)
+		goto direct_uncharge;
+
 	/*
 	 * In typical case, batch->memcg == mem. This means we can
 	 * merge a series of uncharges to an uncharge of res_counter.
@@ -2503,9 +2518,9 @@ __do_uncharge(struct mem_cgroup *mem, co
 		batch->memsw_bytes += PAGE_SIZE;
 	return;
 direct_uncharge:
-	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	res_counter_uncharge(&mem->res, page_size);
 	if (uncharge_memsw)
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+		res_counter_uncharge(&mem->memsw, page_size);
 	if (unlikely(batch->memcg != mem))
 		memcg_oom_recover(mem);
 	return;
@@ -2519,6 +2534,7 @@ __mem_cgroup_uncharge_common(struct page
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
+	int page_size = PAGE_SIZE;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2526,6 +2542,9 @@ __mem_cgroup_uncharge_common(struct page
 	if (PageSwapCache(page))
 		return NULL;
 
+	if (PageTransHuge(page))
+		page_size <<= compound_order(page);
+
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2579,7 +2598,7 @@ __mem_cgroup_uncharge_common(struct page
 		mem_cgroup_get(mem);
 	}
 	if (!mem_cgroup_is_root(mem))
-		__do_uncharge(mem, ctype);
+		__do_uncharge(mem, ctype, page_size);
 
 	return mem;
 
@@ -2774,6 +2793,7 @@ int mem_cgroup_prepare_migration(struct 
 	enum charge_type ctype;
 	int ret = 0;
 
+	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
 		return 0;
 
@@ -2823,7 +2843,7 @@ int mem_cgroup_prepare_migration(struct 
 		return 0;
 
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false);
+	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false, PAGE_SIZE);
 	css_put(&mem->css);/* drop extra refcnt */
 	if (ret || *ptr == NULL) {
 		if (PageAnon(page)) {
@@ -2850,7 +2870,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(mem, pc, ctype);
+	__mem_cgroup_commit_charge(mem, pc, ctype, PAGE_SIZE);
 	return ret;
 }
 
@@ -4461,7 +4481,8 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
+					      PAGE_SIZE);
 		if (ret || !mem)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return -ENOMEM;
@@ -4623,6 +4644,7 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
+	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		if (is_target_pte_for_mc(vma, addr, *pte, NULL))
@@ -4789,6 +4811,7 @@ static int mem_cgroup_move_charge_pte_ra
 	spinlock_t *ptl;
 
 retry:
+	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

