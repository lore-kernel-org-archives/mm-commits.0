From: akpm@linux-foundation.org
Subject: + thp-memcg-compound.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:15 -0800
Message-ID: <201012152357.oBFNvFNV013581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842Ab0LPACA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 19:02:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: memcg compound
has been added to the -mm tree.  Its filename is
     thp-memcg-compound.patch

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
@@ -1941,7 +1947,7 @@ again:
 			rcu_read_unlock();
 			goto done;
 		}
-		if (consume_stock(mem)) {
+		if (page_size == PAGE_SIZE && consume_stock(mem)) {
 			/*
 			 * It seems dagerous to access memcg without css_get().
 			 * But considering how consume_stok works, it's not
@@ -1982,7 +1988,7 @@ again:
 		case CHARGE_OK:
 			break;
 		case CHARGE_RETRY: /* not in OOM situation but retry */
-			csize = PAGE_SIZE;
+			csize = page_size;
 			css_put(&mem->css);
 			mem = NULL;
 			goto again;
@@ -2003,8 +2009,8 @@ again:
 		}
 	} while (ret != CHARGE_OK);
 
-	if (csize > PAGE_SIZE)
-		refill_stock(mem, csize - PAGE_SIZE);
+	if (csize > page_size)
+		refill_stock(mem, csize - page_size);
 	css_put(&mem->css);
 done:
 	*memcg = mem;
@@ -2032,9 +2038,10 @@ static void __mem_cgroup_cancel_charge(s
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
@@ -2090,8 +2097,9 @@ struct mem_cgroup *try_get_mem_cgroup_fr
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
@@ -2100,7 +2108,7 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem);
+		mem_cgroup_cancel_charge(mem, page_size);
 		return;
 	}
 
@@ -2174,7 +2182,7 @@ static void __mem_cgroup_move_account(st
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from);
+		mem_cgroup_cancel_charge(from, PAGE_SIZE);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2235,13 +2243,14 @@ static int mem_cgroup_move_parent(struct
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
@@ -2262,6 +2271,10 @@ static int mem_cgroup_charge_common(stru
 	struct mem_cgroup *mem = NULL;
 	struct page_cgroup *pc;
 	int ret;
+	int page_size = PAGE_SIZE;
+
+	if (PageTransHuge(page))
+		page_size <<= compound_order(page);
 
 	pc = lookup_page_cgroup(page);
 	/* can happen at boot */
@@ -2269,11 +2282,11 @@ static int mem_cgroup_charge_common(stru
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
 
@@ -2282,8 +2295,6 @@ int mem_cgroup_newpage_charge(struct pag
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	if (PageCompound(page))
-		return 0;
 	/*
 	 * If already mapped, we don't have to account.
 	 * If page cache, page->mapping has address_space.
@@ -2389,13 +2400,13 @@ int mem_cgroup_try_charge_swapin(struct 
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
@@ -2411,7 +2422,7 @@ __mem_cgroup_commit_charge_swapin(struct
 	cgroup_exclude_rmdir(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, pc, ctype);
+	__mem_cgroup_commit_charge(ptr, pc, ctype, PAGE_SIZE);
 	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
@@ -2460,11 +2471,12 @@ void mem_cgroup_cancel_charge_swapin(str
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
@@ -2491,6 +2503,9 @@ __do_uncharge(struct mem_cgroup *mem, co
 	if (!batch->do_batch || test_thread_flag(TIF_MEMDIE))
 		goto direct_uncharge;
 
+	if (page_size != PAGE_SIZE)
+		goto direct_uncharge;
+
 	/*
 	 * In typical case, batch->memcg == mem. This means we can
 	 * merge a series of uncharges to an uncharge of res_counter.
@@ -2504,9 +2519,9 @@ __do_uncharge(struct mem_cgroup *mem, co
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
@@ -2520,6 +2535,7 @@ __mem_cgroup_uncharge_common(struct page
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
+	int page_size = PAGE_SIZE;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2527,6 +2543,9 @@ __mem_cgroup_uncharge_common(struct page
 	if (PageSwapCache(page))
 		return NULL;
 
+	if (PageTransHuge(page))
+		page_size <<= compound_order(page);
+
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2580,7 +2599,7 @@ __mem_cgroup_uncharge_common(struct page
 		mem_cgroup_get(mem);
 	}
 	if (!mem_cgroup_is_root(mem))
-		__do_uncharge(mem, ctype);
+		__do_uncharge(mem, ctype, page_size);
 
 	return mem;
 
@@ -2775,6 +2794,7 @@ int mem_cgroup_prepare_migration(struct 
 	enum charge_type ctype;
 	int ret = 0;
 
+	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
 		return 0;
 
@@ -2824,7 +2844,7 @@ int mem_cgroup_prepare_migration(struct 
 		return 0;
 
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false);
+	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false, PAGE_SIZE);
 	css_put(&mem->css);/* drop extra refcnt */
 	if (ret || *ptr == NULL) {
 		if (PageAnon(page)) {
@@ -2851,7 +2871,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(mem, pc, ctype);
+	__mem_cgroup_commit_charge(mem, pc, ctype, PAGE_SIZE);
 	return ret;
 }
 
@@ -4462,7 +4482,8 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
+					      PAGE_SIZE);
 		if (ret || !mem)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return -ENOMEM;
@@ -4624,6 +4645,7 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
+	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		if (is_target_pte_for_mc(vma, addr, *pte, NULL))
@@ -4790,6 +4812,7 @@ static int mem_cgroup_move_charge_pte_ra
 	spinlock_t *ptl;
 
 retry:
+	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

