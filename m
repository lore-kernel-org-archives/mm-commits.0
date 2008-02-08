From: akpm@linux-foundation.org
Subject: - memory-controller-make-charging-gfp-mask-aware.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:27 -0800
Message-ID: <200802080803.m188382n014095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758570AbYBHI22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     Memory controller: make charging gfp mask aware
has been removed from the -mm tree.  Its filename was
     memory-controller-make-charging-gfp-mask-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller: make charging gfp mask aware
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Nick Piggin pointed out that swap cache and page cache addition routines
could be called from non GFP_KERNEL contexts.  This patch makes the
charging routine aware of the gfp context.  Charging might fail if the
cgroup is over it's limit, in which case a suitable error is returned.

This patch was tested on a Powerpc box.  I am still looking at being able
to test the path, through which allocations happen in non GFP_KERNEL
contexts.

[kamezawa.hiroyu@jp.fujitsu.com: problem with ZONE_MOVABLE]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++++++++----
 include/linux/swap.h       |    3 ++-
 mm/filemap.c               |    2 +-
 mm/memcontrol.c            |   24 +++++++++++++++++-------
 mm/memory.c                |   10 +++++-----
 mm/migrate.c               |    2 +-
 mm/swap_state.c            |    2 +-
 mm/swapfile.c              |    2 +-
 mm/vmscan.c                |   14 +++++---------
 9 files changed, 41 insertions(+), 30 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-make-charging-gfp-mask-aware include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-make-charging-gfp-mask-aware
+++ a/include/linux/memcontrol.h
@@ -32,7 +32,8 @@ extern void mm_free_cgroup(struct mm_str
 extern void page_assign_page_cgroup(struct page *page,
 					struct page_cgroup *pc);
 extern struct page_cgroup *page_get_page_cgroup(struct page *page);
-extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm);
+extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+				gfp_t gfp_mask);
 extern void mem_cgroup_uncharge(struct page_cgroup *pc);
 extern void mem_cgroup_move_lists(struct page_cgroup *pc, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
@@ -42,7 +43,8 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
-extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm);
+extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
+					gfp_t gfp_mask);
 extern struct mem_cgroup *mm_cgroup(struct mm_struct *mm);
 
 static inline void mem_cgroup_uncharge_page(struct page *page)
@@ -70,7 +72,8 @@ static inline struct page_cgroup *page_g
 	return NULL;
 }
 
-static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm)
+static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+					gfp_t gfp_mask)
 {
 	return 0;
 }
@@ -89,7 +92,8 @@ static inline void mem_cgroup_move_lists
 }
 
 static inline int mem_cgroup_cache_charge(struct page *page,
-						struct mm_struct *mm)
+						struct mm_struct *mm,
+						gfp_t gfp_mask)
 {
 	return 0;
 }
diff -puN include/linux/swap.h~memory-controller-make-charging-gfp-mask-aware include/linux/swap.h
--- a/include/linux/swap.h~memory-controller-make-charging-gfp-mask-aware
+++ a/include/linux/swap.h
@@ -183,7 +183,8 @@ extern void swap_setup(void);
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zone **zones, int order,
 					gfp_t gfp_mask);
-extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem);
+extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
+							gfp_t gfp_mask);
 extern int __isolate_lru_page(struct page *page, int mode);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/filemap.c~memory-controller-make-charging-gfp-mask-aware mm/filemap.c
--- a/mm/filemap.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/filemap.c
@@ -464,7 +464,7 @@ int add_to_page_cache(struct page *page,
 
 	if (error == 0) {
 
-		error = mem_cgroup_cache_charge(page, current->mm);
+		error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
 		if (error)
 			goto out;
 
diff -puN mm/memcontrol.c~memory-controller-make-charging-gfp-mask-aware mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/memcontrol.c
@@ -261,7 +261,8 @@ unsigned long mem_cgroup_isolate_pages(u
  * 0 if the charge was successful
  * < 0 if the cgroup is over its limit
  */
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm)
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+				gfp_t gfp_mask)
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc, *race_pc;
@@ -293,7 +294,7 @@ retry:
 
 	unlock_page_cgroup(page);
 
-	pc = kzalloc(sizeof(struct page_cgroup), GFP_KERNEL);
+	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
 	if (pc == NULL)
 		goto err;
 
@@ -320,7 +321,14 @@ retry:
 	 * the cgroup limit.
 	 */
 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
-		if (try_to_free_mem_cgroup_pages(mem))
+		bool is_atomic = gfp_mask & GFP_ATOMIC;
+		/*
+		 * We cannot reclaim under GFP_ATOMIC, fail the charge
+		 */
+		if (is_atomic)
+			goto noreclaim;
+
+		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
 			continue;
 
 		/*
@@ -344,9 +352,10 @@ retry:
 			congestion_wait(WRITE, HZ/10);
 			continue;
 		}
-
+noreclaim:
 		css_put(&mem->css);
-		mem_cgroup_out_of_memory(mem, GFP_KERNEL);
+		if (!is_atomic)
+			mem_cgroup_out_of_memory(mem, GFP_KERNEL);
 		goto free_pc;
 	}
 
@@ -385,7 +394,8 @@ err:
 /*
  * See if the cached pages should be charged at all?
  */
-int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm)
+int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
+				gfp_t gfp_mask)
 {
 	struct mem_cgroup *mem;
 	if (!mm)
@@ -393,7 +403,7 @@ int mem_cgroup_cache_charge(struct page 
 
 	mem = rcu_dereference(mm->mem_cgroup);
 	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
-		return mem_cgroup_charge(page, mm);
+		return mem_cgroup_charge(page, mm, gfp_mask);
 	else
 		return 0;
 }
diff -puN mm/memory.c~memory-controller-make-charging-gfp-mask-aware mm/memory.c
--- a/mm/memory.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/memory.c
@@ -1147,7 +1147,7 @@ static int insert_page(struct mm_struct 
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = mem_cgroup_charge(page, mm);
+	retval = mem_cgroup_charge(page, mm, GFP_KERNEL);
 	if (retval)
 		goto out;
 
@@ -1650,7 +1650,7 @@ gotten:
 	cow_user_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_charge(new_page, mm))
+	if (mem_cgroup_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
 	/*
@@ -2052,7 +2052,7 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
-	if (mem_cgroup_charge(page, mm)) {
+	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		ret = VM_FAULT_OOM;
 		goto out;
@@ -2139,7 +2139,7 @@ static int do_anonymous_page(struct mm_s
 		goto oom;
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_charge(page, mm))
+	if (mem_cgroup_charge(page, mm, GFP_KERNEL))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -2277,7 +2277,7 @@ static int __do_fault(struct mm_struct *
 
 	}
 
-	if (mem_cgroup_charge(page, mm)) {
+	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
 		ret = VM_FAULT_OOM;
 		goto out;
 	}
diff -puN mm/migrate.c~memory-controller-make-charging-gfp-mask-aware mm/migrate.c
--- a/mm/migrate.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/migrate.c
@@ -153,7 +153,7 @@ static void remove_migration_pte(struct 
  		return;
  	}
 
-	if (mem_cgroup_charge(new, mm)) {
+	if (mem_cgroup_charge(new, mm, GFP_KERNEL)) {
 		pte_unmap(ptep);
 		return;
 	}
diff -puN mm/swap_state.c~memory-controller-make-charging-gfp-mask-aware mm/swap_state.c
--- a/mm/swap_state.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/swap_state.c
@@ -78,7 +78,7 @@ int add_to_swap_cache(struct page *page,
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 
-		error = mem_cgroup_cache_charge(page, current->mm);
+		error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
 		if (error)
 			goto out;
 
diff -puN mm/swapfile.c~memory-controller-make-charging-gfp-mask-aware mm/swapfile.c
--- a/mm/swapfile.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/swapfile.c
@@ -510,7 +510,7 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pte_t *pte,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
-	if (mem_cgroup_charge(page, vma->vm_mm))
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL))
 		return -ENOMEM;
 
 	inc_mm_counter(vma->vm_mm, anon_rss);
diff -puN mm/vmscan.c~memory-controller-make-charging-gfp-mask-aware mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-make-charging-gfp-mask-aware
+++ a/mm/vmscan.c
@@ -1337,16 +1337,11 @@ unsigned long try_to_free_pages(struct z
 
 #ifdef CONFIG_CGROUP_MEM_CONT
 
-#ifdef CONFIG_HIGHMEM
-#define ZONE_USERPAGES ZONE_HIGHMEM
-#else
-#define ZONE_USERPAGES ZONE_NORMAL
-#endif
-
-unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont)
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
+						gfp_t gfp_mask)
 {
 	struct scan_control sc = {
-		.gfp_mask = GFP_KERNEL,
+		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
@@ -1357,9 +1352,10 @@ unsigned long try_to_free_mem_cgroup_pag
 	};
 	int node;
 	struct zone **zones;
+	int target_zone = gfp_zone(GFP_HIGHUSER_MOVABLE);
 
 	for_each_online_node(node) {
-		zones = NODE_DATA(node)->node_zonelists[ZONE_USERPAGES].zones;
+		zones = NODE_DATA(node)->node_zonelists[target_zone].zones;
 		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
 			return 1;
 	}
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
getdelays-fix-gcc-warnings.patch
