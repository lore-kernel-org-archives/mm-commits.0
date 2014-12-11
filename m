From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:08 -0800
Message-ID: <5489e904.FOHkqiTZrnk4VVa6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbaLKS5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove unnecessary PCG_USED pc->mem_cgroup valid flag
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove unnecessary PCG_USED pc->mem_cgroup valid flag

pc->mem_cgroup had to be left intact after uncharge for the final LRU
removal, and !PCG_USED indicated whether the page was uncharged.  But
since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") pages are
uncharged after the final LRU removal.  Uncharge can simply clear the
pointer and the PCG_USED/PageCgroupUsed sites can test that instead.

Because this is the last page_cgroup flag, this patch reduces the memcg
per-page overhead to a single pointer.

[akpm@linux-foundation.org: remove unneeded initialization of `memcg', per Michal]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   10 ---
 mm/memcontrol.c             |  107 +++++++++++++---------------------
 2 files changed, 41 insertions(+), 76 deletions(-)

diff -puN include/linux/page_cgroup.h~mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag
+++ a/include/linux/page_cgroup.h
@@ -1,11 +1,6 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
-enum {
-	/* flags for mem_cgroup */
-	PCG_USED = 0x01,	/* This page is charged to a memcg */
-};
-
 struct pglist_data;
 
 #ifdef CONFIG_MEMCG
@@ -19,7 +14,6 @@ struct mem_cgroup;
  * then the page cgroup for pfn always exists.
  */
 struct page_cgroup {
-	unsigned long flags;
 	struct mem_cgroup *mem_cgroup;
 };
 
@@ -39,10 +33,6 @@ static inline void page_cgroup_init(void
 
 struct page_cgroup *lookup_page_cgroup(struct page *page);
 
-static inline int PageCgroupUsed(struct page_cgroup *pc)
-{
-	return !!(pc->flags & PCG_USED);
-}
 #else /* !CONFIG_MEMCG */
 struct page_cgroup;
 
diff -puN mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag
+++ a/mm/memcontrol.c
@@ -1284,14 +1284,12 @@ struct lruvec *mem_cgroup_page_lruvec(st
 
 	pc = lookup_page_cgroup(page);
 	memcg = pc->mem_cgroup;
-
 	/*
 	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.  Ensure
-	 * pc->mem_cgroup is sane.
+	 * possibly migrated - before they are charged.
 	 */
-	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
-		pc->mem_cgroup = memcg = root_mem_cgroup;
+	if (!memcg)
+		memcg = root_mem_cgroup;
 
 	mz = mem_cgroup_page_zoneinfo(memcg, page);
 	lruvec = &mz->lruvec;
@@ -2151,7 +2149,7 @@ struct mem_cgroup *mem_cgroup_begin_page
 	pc = lookup_page_cgroup(page);
 again:
 	memcg = pc->mem_cgroup;
-	if (unlikely(!memcg || !PageCgroupUsed(pc)))
+	if (unlikely(!memcg))
 		return NULL;
 
 	*locked = false;
@@ -2159,7 +2157,7 @@ again:
 		return memcg;
 
 	move_lock_mem_cgroup(memcg, flags);
-	if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
+	if (memcg != pc->mem_cgroup) {
 		move_unlock_mem_cgroup(memcg, flags);
 		goto again;
 	}
@@ -2525,7 +2523,7 @@ static struct mem_cgroup *mem_cgroup_loo
  */
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
-	struct mem_cgroup *memcg = NULL;
+	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
 	unsigned short id;
 	swp_entry_t ent;
@@ -2533,9 +2531,10 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	pc = lookup_page_cgroup(page);
-	if (PageCgroupUsed(pc)) {
-		memcg = pc->mem_cgroup;
-		if (memcg && !css_tryget_online(&memcg->css))
+	memcg = pc->mem_cgroup;
+
+	if (memcg) {
+		if (!css_tryget_online(&memcg->css))
 			memcg = NULL;
 	} else if (PageSwapCache(page)) {
 		ent.val = page_private(page);
@@ -2586,7 +2585,7 @@ static void commit_charge(struct page *p
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	int isolated;
 
-	VM_BUG_ON_PAGE(PageCgroupUsed(pc), page);
+	VM_BUG_ON_PAGE(pc->mem_cgroup, page);
 	/*
 	 * we don't need page_cgroup_lock about tail pages, becase they are not
 	 * accessed by any other context at this point.
@@ -2601,7 +2600,7 @@ static void commit_charge(struct page *p
 
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * pc->mem_cgroup and pc->flags at this point:
+	 * pc->mem_cgroup at this point:
 	 *
 	 * - the page is uncharged
 	 *
@@ -2614,7 +2613,6 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED;
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
@@ -3126,37 +3124,22 @@ void __memcg_kmem_commit_charge(struct p
 		memcg_uncharge_kmem(memcg, 1 << order);
 		return;
 	}
-	/*
-	 * The page is freshly allocated and not visible to any
-	 * outside callers yet.  Set up pc non-atomically.
-	 */
 	pc = lookup_page_cgroup(page);
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED;
 }
 
 void __memcg_kmem_uncharge_pages(struct page *page, int order)
 {
-	struct mem_cgroup *memcg = NULL;
-	struct page_cgroup *pc;
-
-
-	pc = lookup_page_cgroup(page);
-	if (!PageCgroupUsed(pc))
-		return;
-
-	memcg = pc->mem_cgroup;
-	pc->flags = 0;
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+	struct mem_cgroup *memcg = pc->mem_cgroup;
 
-	/*
-	 * We trust that only if there is a memcg associated with the page, it
-	 * is a valid allocation
-	 */
 	if (!memcg)
 		return;
 
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
+
 	memcg_uncharge_kmem(memcg, 1 << order);
+	pc->mem_cgroup = NULL;
 }
 #else
 static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
@@ -3174,23 +3157,16 @@ static inline void memcg_unregister_all_
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct page_cgroup *head_pc;
-	struct page_cgroup *pc;
-	struct mem_cgroup *memcg;
+	struct page_cgroup *pc = lookup_page_cgroup(head);
 	int i;
 
 	if (mem_cgroup_disabled())
 		return;
 
-	head_pc = lookup_page_cgroup(head);
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		pc[i].mem_cgroup = pc[0].mem_cgroup;
 
-	memcg = head_pc->mem_cgroup;
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
-		pc = head_pc + i;
-		pc->mem_cgroup = memcg;
-		pc->flags = head_pc->flags;
-	}
-	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
+	__this_cpu_sub(pc[0].mem_cgroup->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
 		       HPAGE_PMD_NR);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -3240,7 +3216,7 @@ static int mem_cgroup_move_account(struc
 		goto out;
 
 	ret = -EINVAL;
-	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
+	if (pc->mem_cgroup != from)
 		goto out_unlock;
 
 	move_lock_mem_cgroup(from, &flags);
@@ -3350,7 +3326,7 @@ static struct page_cgroup *lookup_page_c
 	 * the first time, i.e. during boot or memory hotplug;
 	 * or when mem_cgroup_disabled().
 	 */
-	if (likely(pc) && PageCgroupUsed(pc))
+	if (likely(pc) && pc->mem_cgroup)
 		return pc;
 	return NULL;
 }
@@ -3368,10 +3344,8 @@ void mem_cgroup_print_bad_page(struct pa
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup_used(page);
-	if (pc) {
-		pr_alert("pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
-			 pc, pc->flags, pc->mem_cgroup);
-	}
+	if (pc)
+		pr_alert("pc:%p pc->mem_cgroup:%p\n", pc, pc->mem_cgroup);
 }
 #endif
 
@@ -5308,7 +5282,7 @@ static enum mc_target_type get_mctgt_typ
 		 * mem_cgroup_move_account() checks the pc is valid or
 		 * not under LRU exclusion.
 		 */
-		if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
+		if (pc->mem_cgroup == mc.from) {
 			ret = MC_TARGET_PAGE;
 			if (target)
 				target->page = page;
@@ -5344,7 +5318,7 @@ static enum mc_target_type get_mctgt_typ
 	if (!move_anon())
 		return ret;
 	pc = lookup_page_cgroup(page);
-	if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
+	if (pc->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
 		if (target) {
 			get_page(page);
@@ -5788,18 +5762,17 @@ void mem_cgroup_swapout(struct page *pag
 		return;
 
 	pc = lookup_page_cgroup(page);
+	memcg = pc->mem_cgroup;
 
 	/* Readahead page, never charged */
-	if (!PageCgroupUsed(pc))
+	if (!memcg)
 		return;
 
-	memcg = pc->mem_cgroup;
-
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
 
-	pc->flags = 0;
+	pc->mem_cgroup = NULL;
 
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
@@ -5874,7 +5847,7 @@ int mem_cgroup_try_charge(struct page *p
 		 * the page lock, which serializes swap cache removal, which
 		 * in turn serializes uncharging.
 		 */
-		if (PageCgroupUsed(pc))
+		if (pc->mem_cgroup)
 			goto out;
 	}
 
@@ -6036,13 +6009,13 @@ static void uncharge_list(struct list_he
 		VM_BUG_ON_PAGE(page_count(page), page);
 
 		pc = lookup_page_cgroup(page);
-		if (!PageCgroupUsed(pc))
+		if (!pc->mem_cgroup)
 			continue;
 
 		/*
 		 * Nobody should be changing or seriously looking at
-		 * pc->mem_cgroup and pc->flags at this point, we have
-		 * fully exclusive access to the page.
+		 * pc->mem_cgroup at this point, we have fully
+		 * exclusive access to the page.
 		 */
 
 		if (memcg != pc->mem_cgroup) {
@@ -6065,7 +6038,7 @@ static void uncharge_list(struct list_he
 		else
 			nr_file += nr_pages;
 
-		pc->flags = 0;
+		pc->mem_cgroup = NULL;
 
 		pgpgout++;
 	} while (next != page_list);
@@ -6091,7 +6064,7 @@ void mem_cgroup_uncharge(struct page *pa
 
 	/* Don't touch page->lru of any random page, pre-check: */
 	pc = lookup_page_cgroup(page);
-	if (!PageCgroupUsed(pc))
+	if (!pc->mem_cgroup)
 		return;
 
 	INIT_LIST_HEAD(&page->lru);
@@ -6127,6 +6100,7 @@ void mem_cgroup_uncharge_list(struct lis
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 			bool lrucare)
 {
+	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
 	int isolated;
 
@@ -6143,7 +6117,7 @@ void mem_cgroup_migrate(struct page *old
 
 	/* Page cache replacement: new page already charged? */
 	pc = lookup_page_cgroup(newpage);
-	if (PageCgroupUsed(pc))
+	if (pc->mem_cgroup)
 		return;
 
 	/*
@@ -6153,18 +6127,19 @@ void mem_cgroup_migrate(struct page *old
 	 * reclaim just put back on the LRU but has not released yet.
 	 */
 	pc = lookup_page_cgroup(oldpage);
-	if (!PageCgroupUsed(pc))
+	memcg = pc->mem_cgroup;
+	if (!memcg)
 		return;
 
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
 
-	pc->flags = 0;
+	pc->mem_cgroup = NULL;
 
 	if (lrucare)
 		unlock_page_lru(oldpage, isolated);
 
-	commit_charge(newpage, pc->mem_cgroup, lrucare);
+	commit_charge(newpage, memcg, lrucare);
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

