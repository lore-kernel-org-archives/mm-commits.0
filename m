From: akpm@linux-foundation.org
Subject: [merged]
 mm-embed-the-memcg-pointer-directly-into-struct-page.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:46 -0800
Message-ID: <5489e92a.AQJNLe1cmGOyjrV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaLKS5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, iamjoonsoo.kim@lge.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, koct9i@gmail.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: embed the memcg pointer directly into struct page
has been removed from the -mm tree.  Its filename was
     mm-embed-the-memcg-pointer-directly-into-struct-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: embed the memcg pointer directly into struct page

Memory cgroups used to have 5 per-page pointers.  To allow users to
disable that amount of overhead during runtime, those pointers were
allocated in a separate array, with a translation layer between them and
struct page.

There is now only one page pointer remaining: the memcg pointer, that
indicates which cgroup the page is associated with when charged.  The
complexity of runtime allocation and the runtime translation overhead is
no longer justified to save that *potential* 0.19% of memory.  With
CONFIG_SLUB, page->mem_cgroup actually sits in the doubleword padding
after the page->private member and doesn't even increase struct page, and
then this patch actually saves space.  Remaining users that care can still
compile their kernels without CONFIG_MEMCG.

   text    data     bss     dec     hex     filename
8828345 1725264  983040 11536649 b00909  vmlinux.old
8827425 1725264  966656 11519345 afc571  vmlinux.new

[mhocko@suse.cz: update Documentation/cgroups/memory.txt]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    5 
 include/linux/memcontrol.h       |    6 
 include/linux/mm_types.h         |    5 
 include/linux/mmzone.h           |   12 -
 include/linux/page_cgroup.h      |   53 ----
 init/main.c                      |    7 
 mm/memcontrol.c                  |  124 +++--------
 mm/page_alloc.c                  |    2 
 mm/page_cgroup.c                 |  319 -----------------------------
 9 files changed, 46 insertions(+), 487 deletions(-)

diff -puN Documentation/cgroups/memory.txt~mm-embed-the-memcg-pointer-directly-into-struct-page Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/Documentation/cgroups/memory.txt
@@ -1,5 +1,10 @@
 Memory Resource Controller
 
+NOTE: This document is hopelessly outdated and it asks for a complete
+      rewrite. It still contains a useful information so we are keeping it
+      here but make sure to check the current code if you need a deeper
+      understanding.
+
 NOTE: The Memory Resource Controller has generically been referred to as the
       memory controller in this document. Do not confuse memory controller
       used here with the memory controller that is used in hardware.
diff -puN include/linux/memcontrol.h~mm-embed-the-memcg-pointer-directly-into-struct-page include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/include/linux/memcontrol.h
@@ -25,7 +25,6 @@
 #include <linux/jump_label.h>
 
 struct mem_cgroup;
-struct page_cgroup;
 struct page;
 struct mm_struct;
 struct kmem_cache;
@@ -466,8 +465,6 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
  * memcg_kmem_uncharge_pages: uncharge pages from memcg
  * @page: pointer to struct page being freed
  * @order: allocation order.
- *
- * there is no need to specify memcg here, since it is embedded in page_cgroup
  */
 static inline void
 memcg_kmem_uncharge_pages(struct page *page, int order)
@@ -484,8 +481,7 @@ memcg_kmem_uncharge_pages(struct page *p
  *
  * Needs to be called after memcg_kmem_newpage_charge, regardless of success or
  * failure of the allocation. if @page is NULL, this function will revert the
- * charges. Otherwise, it will commit the memcg given by @memcg to the
- * corresponding page_cgroup.
+ * charges. Otherwise, it will commit @page to @memcg.
  */
 static inline void
 memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
diff -puN include/linux/mm_types.h~mm-embed-the-memcg-pointer-directly-into-struct-page include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/include/linux/mm_types.h
@@ -22,6 +22,7 @@
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
 struct address_space;
+struct mem_cgroup;
 
 #define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
 #define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
@@ -167,6 +168,10 @@ struct page {
 		struct page *first_page;	/* Compound tail pages */
 	};
 
+#ifdef CONFIG_MEMCG
+	struct mem_cgroup *mem_cgroup;
+#endif
+
 	/*
 	 * On machines where all RAM is mapped into kernel address space,
 	 * we can simply calculate the virtual address. On machines with
diff -puN include/linux/mmzone.h~mm-embed-the-memcg-pointer-directly-into-struct-page include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/include/linux/mmzone.h
@@ -722,9 +722,6 @@ typedef struct pglist_data {
 	int nr_zones;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
-#ifdef CONFIG_MEMCG
-	struct page_cgroup *node_page_cgroup;
-#endif
 #endif
 #ifndef CONFIG_NO_BOOTMEM
 	struct bootmem_data *bdata;
@@ -1078,7 +1075,6 @@ static inline unsigned long early_pfn_to
 #define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
 
 struct page;
-struct page_cgroup;
 struct mem_section {
 	/*
 	 * This is, logically, a pointer to an array of struct
@@ -1096,14 +1092,6 @@ struct mem_section {
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
-#ifdef CONFIG_MEMCG
-	/*
-	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
-	 * section. (see memcontrol.h/page_cgroup.h about this.)
-	 */
-	struct page_cgroup *page_cgroup;
-	unsigned long pad;
-#endif
 	/*
 	 * WARNING: mem_section must be a power-of-2 in size for the
 	 * calculation and use of SECTION_ROOT_MASK to make sense.
diff -puN include/linux/page_cgroup.h~mm-embed-the-memcg-pointer-directly-into-struct-page include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/include/linux/page_cgroup.h
@@ -1,59 +1,6 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
-struct pglist_data;
-
-#ifdef CONFIG_MEMCG
-struct mem_cgroup;
-
-/*
- * Page Cgroup can be considered as an extended mem_map.
- * A page_cgroup page is associated with every page descriptor. The
- * page_cgroup helps us identify information about the cgroup
- * All page cgroups are allocated at boot or memory hotplug event,
- * then the page cgroup for pfn always exists.
- */
-struct page_cgroup {
-	struct mem_cgroup *mem_cgroup;
-};
-
-extern void pgdat_page_cgroup_init(struct pglist_data *pgdat);
-
-#ifdef CONFIG_SPARSEMEM
-static inline void page_cgroup_init_flatmem(void)
-{
-}
-extern void page_cgroup_init(void);
-#else
-extern void page_cgroup_init_flatmem(void);
-static inline void page_cgroup_init(void)
-{
-}
-#endif
-
-struct page_cgroup *lookup_page_cgroup(struct page *page);
-
-#else /* !CONFIG_MEMCG */
-struct page_cgroup;
-
-static inline void pgdat_page_cgroup_init(struct pglist_data *pgdat)
-{
-}
-
-static inline struct page_cgroup *lookup_page_cgroup(struct page *page)
-{
-	return NULL;
-}
-
-static inline void page_cgroup_init(void)
-{
-}
-
-static inline void page_cgroup_init_flatmem(void)
-{
-}
-#endif /* CONFIG_MEMCG */
-
 #include <linux/swap.h>
 
 #ifdef CONFIG_MEMCG_SWAP
diff -puN init/main.c~mm-embed-the-memcg-pointer-directly-into-struct-page init/main.c
--- a/init/main.c~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/init/main.c
@@ -51,7 +51,6 @@
 #include <linux/mempolicy.h>
 #include <linux/key.h>
 #include <linux/buffer_head.h>
-#include <linux/page_cgroup.h>
 #include <linux/debug_locks.h>
 #include <linux/debugobjects.h>
 #include <linux/lockdep.h>
@@ -485,11 +484,6 @@ void __init __weak thread_info_cache_ini
  */
 static void __init mm_init(void)
 {
-	/*
-	 * page_cgroup requires contiguous pages,
-	 * bigger than MAX_ORDER unless SPARSEMEM.
-	 */
-	page_cgroup_init_flatmem();
 	mem_init();
 	kmem_cache_init();
 	percpu_init_late();
@@ -627,7 +621,6 @@ asmlinkage __visible void __init start_k
 		initrd_start = 0;
 	}
 #endif
-	page_cgroup_init();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
diff -puN mm/memcontrol.c~mm-embed-the-memcg-pointer-directly-into-struct-page mm/memcontrol.c
--- a/mm/memcontrol.c~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/mm/memcontrol.c
@@ -1274,7 +1274,6 @@ struct lruvec *mem_cgroup_page_lruvec(st
 {
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
 	struct lruvec *lruvec;
 
 	if (mem_cgroup_disabled()) {
@@ -1282,8 +1281,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 		goto out;
 	}
 
-	pc = lookup_page_cgroup(page);
-	memcg = pc->mem_cgroup;
+	memcg = page->mem_cgroup;
 	/*
 	 * Swapcache readahead pages are added to the LRU - and
 	 * possibly migrated - before they are charged.
@@ -2020,16 +2018,13 @@ struct mem_cgroup *mem_cgroup_begin_page
 					      unsigned long *flags)
 {
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
 
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
 		return NULL;
-
-	pc = lookup_page_cgroup(page);
 again:
-	memcg = pc->mem_cgroup;
+	memcg = page->mem_cgroup;
 	if (unlikely(!memcg))
 		return NULL;
 
@@ -2038,7 +2033,7 @@ again:
 		return memcg;
 
 	spin_lock_irqsave(&memcg->move_lock, *flags);
-	if (memcg != pc->mem_cgroup) {
+	if (memcg != page->mem_cgroup) {
 		spin_unlock_irqrestore(&memcg->move_lock, *flags);
 		goto again;
 	}
@@ -2405,15 +2400,12 @@ static struct mem_cgroup *mem_cgroup_loo
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
 	unsigned short id;
 	swp_entry_t ent;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	pc = lookup_page_cgroup(page);
-	memcg = pc->mem_cgroup;
-
+	memcg = page->mem_cgroup;
 	if (memcg) {
 		if (!css_tryget_online(&memcg->css))
 			memcg = NULL;
@@ -2463,10 +2455,9 @@ static void unlock_page_lru(struct page
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 			  bool lrucare)
 {
-	struct page_cgroup *pc = lookup_page_cgroup(page);
 	int isolated;
 
-	VM_BUG_ON_PAGE(pc->mem_cgroup, page);
+	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 
 	/*
 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
@@ -2477,7 +2468,7 @@ static void commit_charge(struct page *p
 
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * pc->mem_cgroup at this point:
+	 * page->mem_cgroup at this point:
 	 *
 	 * - the page is uncharged
 	 *
@@ -2489,7 +2480,7 @@ static void commit_charge(struct page *p
 	 * - a page cache insertion, a swapin fault, or a migration
 	 *   have the page locked
 	 */
-	pc->mem_cgroup = memcg;
+	page->mem_cgroup = memcg;
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
@@ -2972,8 +2963,6 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
 			      int order)
 {
-	struct page_cgroup *pc;
-
 	VM_BUG_ON(mem_cgroup_is_root(memcg));
 
 	/* The page allocation failed. Revert */
@@ -2981,14 +2970,12 @@ void __memcg_kmem_commit_charge(struct p
 		memcg_uncharge_kmem(memcg, 1 << order);
 		return;
 	}
-	pc = lookup_page_cgroup(page);
-	pc->mem_cgroup = memcg;
+	page->mem_cgroup = memcg;
 }
 
 void __memcg_kmem_uncharge_pages(struct page *page, int order)
 {
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct mem_cgroup *memcg = pc->mem_cgroup;
+	struct mem_cgroup *memcg = page->mem_cgroup;
 
 	if (!memcg)
 		return;
@@ -2996,7 +2983,7 @@ void __memcg_kmem_uncharge_pages(struct
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 
 	memcg_uncharge_kmem(memcg, 1 << order);
-	pc->mem_cgroup = NULL;
+	page->mem_cgroup = NULL;
 }
 #else
 static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
@@ -3014,16 +3001,15 @@ static inline void memcg_unregister_all_
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct page_cgroup *pc = lookup_page_cgroup(head);
 	int i;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	for (i = 1; i < HPAGE_PMD_NR; i++)
-		pc[i].mem_cgroup = pc[0].mem_cgroup;
+		head[i].mem_cgroup = head->mem_cgroup;
 
-	__this_cpu_sub(pc[0].mem_cgroup->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
+	__this_cpu_sub(head->mem_cgroup->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
 		       HPAGE_PMD_NR);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -3032,7 +3018,6 @@ void mem_cgroup_split_huge_fixup(struct
  * mem_cgroup_move_account - move account of the page
  * @page: the page
  * @nr_pages: number of regular pages (>1 for huge pages)
- * @pc:	page_cgroup of the page.
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
@@ -3045,7 +3030,6 @@ void mem_cgroup_split_huge_fixup(struct
  */
 static int mem_cgroup_move_account(struct page *page,
 				   unsigned int nr_pages,
-				   struct page_cgroup *pc,
 				   struct mem_cgroup *from,
 				   struct mem_cgroup *to)
 {
@@ -3065,7 +3049,7 @@ static int mem_cgroup_move_account(struc
 		goto out;
 
 	/*
-	 * Prevent mem_cgroup_migrate() from looking at pc->mem_cgroup
+	 * Prevent mem_cgroup_migrate() from looking at page->mem_cgroup
 	 * of its source page while we change it: page migration takes
 	 * both pages off the LRU, but page cache replacement doesn't.
 	 */
@@ -3073,7 +3057,7 @@ static int mem_cgroup_move_account(struc
 		goto out;
 
 	ret = -EINVAL;
-	if (pc->mem_cgroup != from)
+	if (page->mem_cgroup != from)
 		goto out_unlock;
 
 	spin_lock_irqsave(&from->move_lock, flags);
@@ -3093,13 +3077,13 @@ static int mem_cgroup_move_account(struc
 	}
 
 	/*
-	 * It is safe to change pc->mem_cgroup here because the page
+	 * It is safe to change page->mem_cgroup here because the page
 	 * is referenced, charged, and isolated - we can't race with
 	 * uncharging, charging, migration, or LRU putback.
 	 */
 
 	/* caller should have done css_get */
-	pc->mem_cgroup = to;
+	page->mem_cgroup = to;
 	spin_unlock_irqrestore(&from->move_lock, flags);
 
 	ret = 0;
@@ -3174,36 +3158,17 @@ static inline int mem_cgroup_move_swap_a
 #endif
 
 #ifdef CONFIG_DEBUG_VM
-static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
-{
-	struct page_cgroup *pc;
-
-	pc = lookup_page_cgroup(page);
-	/*
-	 * Can be NULL while feeding pages into the page allocator for
-	 * the first time, i.e. during boot or memory hotplug;
-	 * or when mem_cgroup_disabled().
-	 */
-	if (likely(pc) && pc->mem_cgroup)
-		return pc;
-	return NULL;
-}
-
 bool mem_cgroup_bad_page_check(struct page *page)
 {
 	if (mem_cgroup_disabled())
 		return false;
 
-	return lookup_page_cgroup_used(page) != NULL;
+	return page->mem_cgroup != NULL;
 }
 
 void mem_cgroup_print_bad_page(struct page *page)
 {
-	struct page_cgroup *pc;
-
-	pc = lookup_page_cgroup_used(page);
-	if (pc)
-		pr_alert("pc:%p pc->mem_cgroup:%p\n", pc, pc->mem_cgroup);
+	pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
 }
 #endif
 
@@ -5123,7 +5088,6 @@ static enum mc_target_type get_mctgt_typ
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
 	struct page *page = NULL;
-	struct page_cgroup *pc;
 	enum mc_target_type ret = MC_TARGET_NONE;
 	swp_entry_t ent = { .val = 0 };
 
@@ -5137,13 +5101,12 @@ static enum mc_target_type get_mctgt_typ
 	if (!page && !ent.val)
 		return ret;
 	if (page) {
-		pc = lookup_page_cgroup(page);
 		/*
 		 * Do only loose check w/o serialization.
-		 * mem_cgroup_move_account() checks the pc is valid or
+		 * mem_cgroup_move_account() checks the page is valid or
 		 * not under LRU exclusion.
 		 */
-		if (pc->mem_cgroup == mc.from) {
+		if (page->mem_cgroup == mc.from) {
 			ret = MC_TARGET_PAGE;
 			if (target)
 				target->page = page;
@@ -5171,15 +5134,13 @@ static enum mc_target_type get_mctgt_typ
 		unsigned long addr, pmd_t pmd, union mc_target *target)
 {
 	struct page *page = NULL;
-	struct page_cgroup *pc;
 	enum mc_target_type ret = MC_TARGET_NONE;
 
 	page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
 	if (!move_anon())
 		return ret;
-	pc = lookup_page_cgroup(page);
-	if (pc->mem_cgroup == mc.from) {
+	if (page->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
 		if (target) {
 			get_page(page);
@@ -5378,7 +5339,6 @@ static int mem_cgroup_move_charge_pte_ra
 	enum mc_target_type target_type;
 	union mc_target target;
 	struct page *page;
-	struct page_cgroup *pc;
 
 	/*
 	 * We don't take compound_lock() here but no race with splitting thp
@@ -5399,9 +5359,8 @@ static int mem_cgroup_move_charge_pte_ra
 		if (target_type == MC_TARGET_PAGE) {
 			page = target.page;
 			if (!isolate_lru_page(page)) {
-				pc = lookup_page_cgroup(page);
 				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
-							pc, mc.from, mc.to)) {
+							     mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
 					mc.moved_charge += HPAGE_PMD_NR;
 				}
@@ -5429,9 +5388,7 @@ retry:
 			page = target.page;
 			if (isolate_lru_page(page))
 				goto put;
-			pc = lookup_page_cgroup(page);
-			if (!mem_cgroup_move_account(page, 1, pc,
-						     mc.from, mc.to)) {
+			if (!mem_cgroup_move_account(page, 1, mc.from, mc.to)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
@@ -5619,7 +5576,6 @@ static void __init enable_swap_cgroup(vo
 void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
 	unsigned short oldid;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5628,8 +5584,7 @@ void mem_cgroup_swapout(struct page *pag
 	if (!do_swap_account)
 		return;
 
-	pc = lookup_page_cgroup(page);
-	memcg = pc->mem_cgroup;
+	memcg = page->mem_cgroup;
 
 	/* Readahead page, never charged */
 	if (!memcg)
@@ -5639,7 +5594,7 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
 
-	pc->mem_cgroup = NULL;
+	page->mem_cgroup = NULL;
 
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
@@ -5706,7 +5661,6 @@ int mem_cgroup_try_charge(struct page *p
 		goto out;
 
 	if (PageSwapCache(page)) {
-		struct page_cgroup *pc = lookup_page_cgroup(page);
 		/*
 		 * Every swap fault against a single page tries to charge the
 		 * page, bail as early as possible.  shmem_unuse() encounters
@@ -5714,7 +5668,7 @@ int mem_cgroup_try_charge(struct page *p
 		 * the page lock, which serializes swap cache removal, which
 		 * in turn serializes uncharging.
 		 */
-		if (pc->mem_cgroup)
+		if (page->mem_cgroup)
 			goto out;
 	}
 
@@ -5867,7 +5821,6 @@ static void uncharge_list(struct list_he
 	next = page_list->next;
 	do {
 		unsigned int nr_pages = 1;
-		struct page_cgroup *pc;
 
 		page = list_entry(next, struct page, lru);
 		next = page->lru.next;
@@ -5875,23 +5828,22 @@ static void uncharge_list(struct list_he
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		VM_BUG_ON_PAGE(page_count(page), page);
 
-		pc = lookup_page_cgroup(page);
-		if (!pc->mem_cgroup)
+		if (!page->mem_cgroup)
 			continue;
 
 		/*
 		 * Nobody should be changing or seriously looking at
-		 * pc->mem_cgroup at this point, we have fully
+		 * page->mem_cgroup at this point, we have fully
 		 * exclusive access to the page.
 		 */
 
-		if (memcg != pc->mem_cgroup) {
+		if (memcg != page->mem_cgroup) {
 			if (memcg) {
 				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
 					       nr_huge, page);
 				pgpgout = nr_anon = nr_file = nr_huge = 0;
 			}
-			memcg = pc->mem_cgroup;
+			memcg = page->mem_cgroup;
 		}
 
 		if (PageTransHuge(page)) {
@@ -5905,7 +5857,7 @@ static void uncharge_list(struct list_he
 		else
 			nr_file += nr_pages;
 
-		pc->mem_cgroup = NULL;
+		page->mem_cgroup = NULL;
 
 		pgpgout++;
 	} while (next != page_list);
@@ -5924,14 +5876,11 @@ static void uncharge_list(struct list_he
  */
 void mem_cgroup_uncharge(struct page *page)
 {
-	struct page_cgroup *pc;
-
 	if (mem_cgroup_disabled())
 		return;
 
 	/* Don't touch page->lru of any random page, pre-check: */
-	pc = lookup_page_cgroup(page);
-	if (!pc->mem_cgroup)
+	if (!page->mem_cgroup)
 		return;
 
 	INIT_LIST_HEAD(&page->lru);
@@ -5968,7 +5917,6 @@ void mem_cgroup_migrate(struct page *old
 			bool lrucare)
 {
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
 	int isolated;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
@@ -5983,8 +5931,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	/* Page cache replacement: new page already charged? */
-	pc = lookup_page_cgroup(newpage);
-	if (pc->mem_cgroup)
+	if (newpage->mem_cgroup)
 		return;
 
 	/*
@@ -5993,15 +5940,14 @@ void mem_cgroup_migrate(struct page *old
 	 * uncharged page when the PFN walker finds a page that
 	 * reclaim just put back on the LRU but has not released yet.
 	 */
-	pc = lookup_page_cgroup(oldpage);
-	memcg = pc->mem_cgroup;
+	memcg = oldpage->mem_cgroup;
 	if (!memcg)
 		return;
 
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
 
-	pc->mem_cgroup = NULL;
+	oldpage->mem_cgroup = NULL;
 
 	if (lrucare)
 		unlock_page_lru(oldpage, isolated);
diff -puN mm/page_alloc.c~mm-embed-the-memcg-pointer-directly-into-struct-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/mm/page_alloc.c
@@ -48,7 +48,6 @@
 #include <linux/backing-dev.h>
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
-#include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
 #include <linux/compaction.h>
@@ -4853,7 +4852,6 @@ static void __paginginit free_area_init_
 #endif
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
-	pgdat_page_cgroup_init(pgdat);
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
diff -puN mm/page_cgroup.c~mm-embed-the-memcg-pointer-directly-into-struct-page mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-embed-the-memcg-pointer-directly-into-struct-page
+++ a/mm/page_cgroup.c
@@ -1,326 +1,7 @@
 #include <linux/mm.h>
-#include <linux/mmzone.h>
-#include <linux/bootmem.h>
-#include <linux/bit_spinlock.h>
 #include <linux/page_cgroup.h>
-#include <linux/hash.h>
-#include <linux/slab.h>
-#include <linux/memory.h>
 #include <linux/vmalloc.h>
-#include <linux/cgroup.h>
 #include <linux/swapops.h>
-#include <linux/kmemleak.h>
-
-static unsigned long total_usage;
-
-#if !defined(CONFIG_SPARSEMEM)
-
-
-void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
-{
-	pgdat->node_page_cgroup = NULL;
-}
-
-struct page_cgroup *lookup_page_cgroup(struct page *page)
-{
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long offset;
-	struct page_cgroup *base;
-
-	base = NODE_DATA(page_to_nid(page))->node_page_cgroup;
-#ifdef CONFIG_DEBUG_VM
-	/*
-	 * The sanity checks the page allocator does upon freeing a
-	 * page can reach here before the page_cgroup arrays are
-	 * allocated when feeding a range of pages to the allocator
-	 * for the first time during bootup or memory hotplug.
-	 */
-	if (unlikely(!base))
-		return NULL;
-#endif
-	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
-	return base + offset;
-}
-
-static int __init alloc_node_page_cgroup(int nid)
-{
-	struct page_cgroup *base;
-	unsigned long table_size;
-	unsigned long nr_pages;
-
-	nr_pages = NODE_DATA(nid)->node_spanned_pages;
-	if (!nr_pages)
-		return 0;
-
-	table_size = sizeof(struct page_cgroup) * nr_pages;
-
-	base = memblock_virt_alloc_try_nid_nopanic(
-			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
-			BOOTMEM_ALLOC_ACCESSIBLE, nid);
-	if (!base)
-		return -ENOMEM;
-	NODE_DATA(nid)->node_page_cgroup = base;
-	total_usage += table_size;
-	return 0;
-}
-
-void __init page_cgroup_init_flatmem(void)
-{
-
-	int nid, fail;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	for_each_online_node(nid)  {
-		fail = alloc_node_page_cgroup(nid);
-		if (fail)
-			goto fail;
-	}
-	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
-	" don't want memory cgroups\n");
-	return;
-fail:
-	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
-	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
-	panic("Out of memory");
-}
-
-#else /* CONFIG_FLAT_NODE_MEM_MAP */
-
-struct page_cgroup *lookup_page_cgroup(struct page *page)
-{
-	unsigned long pfn = page_to_pfn(page);
-	struct mem_section *section = __pfn_to_section(pfn);
-#ifdef CONFIG_DEBUG_VM
-	/*
-	 * The sanity checks the page allocator does upon freeing a
-	 * page can reach here before the page_cgroup arrays are
-	 * allocated when feeding a range of pages to the allocator
-	 * for the first time during bootup or memory hotplug.
-	 */
-	if (!section->page_cgroup)
-		return NULL;
-#endif
-	return section->page_cgroup + pfn;
-}
-
-static void *__meminit alloc_page_cgroup(size_t size, int nid)
-{
-	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
-	void *addr = NULL;
-
-	addr = alloc_pages_exact_nid(nid, size, flags);
-	if (addr) {
-		kmemleak_alloc(addr, size, 1, flags);
-		return addr;
-	}
-
-	if (node_state(nid, N_HIGH_MEMORY))
-		addr = vzalloc_node(size, nid);
-	else
-		addr = vzalloc(size);
-
-	return addr;
-}
-
-static int __meminit init_section_page_cgroup(unsigned long pfn, int nid)
-{
-	struct mem_section *section;
-	struct page_cgroup *base;
-	unsigned long table_size;
-
-	section = __pfn_to_section(pfn);
-
-	if (section->page_cgroup)
-		return 0;
-
-	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-	base = alloc_page_cgroup(table_size, nid);
-
-	/*
-	 * The value stored in section->page_cgroup is (base - pfn)
-	 * and it does not point to the memory block allocated above,
-	 * causing kmemleak false positives.
-	 */
-	kmemleak_not_leak(base);
-
-	if (!base) {
-		printk(KERN_ERR "page cgroup allocation failure\n");
-		return -ENOMEM;
-	}
-
-	/*
-	 * The passed "pfn" may not be aligned to SECTION.  For the calculation
-	 * we need to apply a mask.
-	 */
-	pfn &= PAGE_SECTION_MASK;
-	section->page_cgroup = base - pfn;
-	total_usage += table_size;
-	return 0;
-}
-#ifdef CONFIG_MEMORY_HOTPLUG
-static void free_page_cgroup(void *addr)
-{
-	if (is_vmalloc_addr(addr)) {
-		vfree(addr);
-	} else {
-		struct page *page = virt_to_page(addr);
-		size_t table_size =
-			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-
-		BUG_ON(PageReserved(page));
-		kmemleak_free(addr);
-		free_pages_exact(addr, table_size);
-	}
-}
-
-static void __free_page_cgroup(unsigned long pfn)
-{
-	struct mem_section *ms;
-	struct page_cgroup *base;
-
-	ms = __pfn_to_section(pfn);
-	if (!ms || !ms->page_cgroup)
-		return;
-	base = ms->page_cgroup + pfn;
-	free_page_cgroup(base);
-	ms->page_cgroup = NULL;
-}
-
-static int __meminit online_page_cgroup(unsigned long start_pfn,
-				unsigned long nr_pages,
-				int nid)
-{
-	unsigned long start, end, pfn;
-	int fail = 0;
-
-	start = SECTION_ALIGN_DOWN(start_pfn);
-	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
-
-	if (nid == -1) {
-		/*
-		 * In this case, "nid" already exists and contains valid memory.
-		 * "start_pfn" passed to us is a pfn which is an arg for
-		 * online__pages(), and start_pfn should exist.
-		 */
-		nid = pfn_to_nid(start_pfn);
-		VM_BUG_ON(!node_state(nid, N_ONLINE));
-	}
-
-	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
-		if (!pfn_present(pfn))
-			continue;
-		fail = init_section_page_cgroup(pfn, nid);
-	}
-	if (!fail)
-		return 0;
-
-	/* rollback */
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
-		__free_page_cgroup(pfn);
-
-	return -ENOMEM;
-}
-
-static int __meminit offline_page_cgroup(unsigned long start_pfn,
-				unsigned long nr_pages, int nid)
-{
-	unsigned long start, end, pfn;
-
-	start = SECTION_ALIGN_DOWN(start_pfn);
-	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
-
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
-		__free_page_cgroup(pfn);
-	return 0;
-
-}
-
-static int __meminit page_cgroup_callback(struct notifier_block *self,
-			       unsigned long action, void *arg)
-{
-	struct memory_notify *mn = arg;
-	int ret = 0;
-	switch (action) {
-	case MEM_GOING_ONLINE:
-		ret = online_page_cgroup(mn->start_pfn,
-				   mn->nr_pages, mn->status_change_nid);
-		break;
-	case MEM_OFFLINE:
-		offline_page_cgroup(mn->start_pfn,
-				mn->nr_pages, mn->status_change_nid);
-		break;
-	case MEM_CANCEL_ONLINE:
-		offline_page_cgroup(mn->start_pfn,
-				mn->nr_pages, mn->status_change_nid);
-		break;
-	case MEM_GOING_OFFLINE:
-		break;
-	case MEM_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-		break;
-	}
-
-	return notifier_from_errno(ret);
-}
-
-#endif
-
-void __init page_cgroup_init(void)
-{
-	unsigned long pfn;
-	int nid;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	for_each_node_state(nid, N_MEMORY) {
-		unsigned long start_pfn, end_pfn;
-
-		start_pfn = node_start_pfn(nid);
-		end_pfn = node_end_pfn(nid);
-		/*
-		 * start_pfn and end_pfn may not be aligned to SECTION and the
-		 * page->flags of out of node pages are not initialized.  So we
-		 * scan [start_pfn, the biggest section's pfn < end_pfn) here.
-		 */
-		for (pfn = start_pfn;
-		     pfn < end_pfn;
-                     pfn = ALIGN(pfn + 1, PAGES_PER_SECTION)) {
-
-			if (!pfn_valid(pfn))
-				continue;
-			/*
-			 * Nodes's pfns can be overlapping.
-			 * We know some arch can have a nodes layout such as
-			 * -------------pfn-------------->
-			 * N0 | N1 | N2 | N0 | N1 | N2|....
-			 */
-			if (pfn_to_nid(pfn) != nid)
-				continue;
-			if (init_section_page_cgroup(pfn, nid))
-				goto oom;
-		}
-	}
-	hotplug_memory_notifier(page_cgroup_callback, 0);
-	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you "
-			 "don't want memory cgroups\n");
-	return;
-oom:
-	printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
-	panic("Out of memory");
-}
-
-void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
-{
-	return;
-}
-
-#endif
-
 
 #ifdef CONFIG_MEMCG_SWAP
 
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

