From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:20:27 -0700
Message-ID: <20200604172027.tccitzuCc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbgFDRU3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@kernel.org, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: make swap tracking an integral part of memory control
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: make swap tracking an integral part of memory control

Without swap page tracking, users that are otherwise memory controlled can
easily escape their containment and allocate significant amounts of memory
that they're not being charged for.  That's because swap does readahead,
but without the cgroup records of who owned the page at swapout, readahead
pages don't get charged until somebody actually faults them into their
page table and we can identify an owner task.  This can be maliciously
exploited with MADV_WILLNEED, which triggers arbitrary readahead
allocations without charging the pages.

Make swap swap page tracking an integral part of memcg and remove the
Kconfig options.  In the first place, it was only made configurable to
allow users to save some memory.  But the overhead of tracking cgroup
ownership per swap page is minimal - 2 byte per page, or 512k per 1G of
swap, or 0.04%.  Saving that at the expense of broken containment
semantics is not something we should present as a coequal option.

The swapaccount=0 boot option will continue to exist, and it will
eliminate the page_counter overhead and hide the swap control files, but
it won't disable swap slot ownership tracking.

This patch makes sure we always have the cgroup records at swapin time;
the next patch will fix the actual bug by charging readahead swap pages at
swapin time rather than at fault time.

v2: fix double swap charge bug in cgroup1/cgroup2 code gating

[hannes@cmpxchg.org: fix crash with cgroup_disable=memory]
  Link: http://lkml.kernel.org/r/20200521215855.GB815153@cmpxchg.org
Link: http://lkml.kernel.org/r/20200508183105.225460-16-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Debugged-by: Hugh Dickins <hughd@google.com>
Debugged-by: Michal Hocko <mhocko@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |   17 --------------
 mm/memcontrol.c  |   53 +++++++++++++++++++--------------------------
 mm/swap_cgroup.c |    6 -----
 3 files changed, 24 insertions(+), 52 deletions(-)

--- a/init/Kconfig~mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control
+++ a/init/Kconfig
@@ -819,24 +819,9 @@ config MEMCG
 	  Provides control over the memory footprint of tasks in a cgroup.
 
 config MEMCG_SWAP
-	bool "Swap controller"
+	bool
 	depends on MEMCG && SWAP
-	help
-	  Provides control over the swap space consumed by tasks in a cgroup.
-
-config MEMCG_SWAP_ENABLED
-	bool "Swap controller enabled by default"
-	depends on MEMCG_SWAP
 	default y
-	help
-	  Memory Resource Controller Swap Extension comes with its price in
-	  a bigger memory consumption. General purpose distribution kernels
-	  which want to enable the feature but keep it disabled by default
-	  and let the user enable it by swapaccount=1 boot command line
-	  parameter should have this option unselected.
-	  For those who want to have the feature enabled by default should
-	  select this option (if, for some reason, they need to disable it
-	  then swapaccount=0 does the trick).
 
 config MEMCG_KMEM
 	bool
--- a/mm/memcontrol.c~mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control
+++ a/mm/memcontrol.c
@@ -83,14 +83,10 @@ static bool cgroup_memory_nokmem;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-#ifdef CONFIG_MEMCG_SWAP_ENABLED
 bool cgroup_memory_noswap __read_mostly;
 #else
-bool cgroup_memory_noswap __read_mostly = 1;
-#endif /* CONFIG_MEMCG_SWAP_ENABLED */
-#else
 #define cgroup_memory_noswap		1
-#endif /* CONFIG_MEMCG_SWAP */
+#endif
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
@@ -5360,8 +5356,7 @@ static struct page *mc_handle_swap_pte(s
 	 * we call find_get_page() with swapper_space directly.
 	 */
 	page = find_get_page(swap_address_space(ent), swp_offset(ent));
-	if (do_memsw_account())
-		entry->val = ent.val;
+	entry->val = ent.val;
 
 	return page;
 }
@@ -5395,8 +5390,7 @@ static struct page *mc_handle_file_pte(s
 		page = find_get_entry(mapping, pgoff);
 		if (xa_is_value(page)) {
 			swp_entry_t swp = radix_to_swp_entry(page);
-			if (do_memsw_account())
-				*entry = swp;
+			*entry = swp;
 			page = find_get_page(swap_address_space(swp),
 					     swp_offset(swp));
 		}
@@ -6529,6 +6523,9 @@ int mem_cgroup_charge(struct page *page,
 		goto out;
 
 	if (PageSwapCache(page)) {
+		swp_entry_t ent = { .val = page_private(page), };
+		unsigned short id;
+
 		/*
 		 * Every swap fault against a single page tries to charge the
 		 * page, bail as early as possible.  shmem_unuse() encounters
@@ -6540,17 +6537,12 @@ int mem_cgroup_charge(struct page *page,
 		if (compound_head(page)->mem_cgroup)
 			goto out;
 
-		if (!cgroup_memory_noswap) {
-			swp_entry_t ent = { .val = page_private(page), };
-			unsigned short id;
-
-			id = lookup_swap_cgroup_id(ent);
-			rcu_read_lock();
-			memcg = mem_cgroup_from_id(id);
-			if (memcg && !css_tryget_online(&memcg->css))
-				memcg = NULL;
-			rcu_read_unlock();
-		}
+		id = lookup_swap_cgroup_id(ent);
+		rcu_read_lock();
+		memcg = mem_cgroup_from_id(id);
+		if (memcg && !css_tryget_online(&memcg->css))
+			memcg = NULL;
+		rcu_read_unlock();
 	}
 
 	if (!memcg)
@@ -6567,7 +6559,7 @@ int mem_cgroup_charge(struct page *page,
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (do_memsw_account() && PageSwapCache(page)) {
+	if (PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
@@ -6952,7 +6944,7 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
-	if (!do_memsw_account())
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
 	memcg = page->mem_cgroup;
@@ -6981,7 +6973,7 @@ void mem_cgroup_swapout(struct page *pag
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
+	if (!cgroup_memory_noswap && memcg != swap_memcg) {
 		if (!mem_cgroup_is_root(swap_memcg))
 			page_counter_charge(&swap_memcg->memsw, nr_entries);
 		page_counter_uncharge(&memcg->memsw, nr_entries);
@@ -7017,7 +7009,7 @@ int mem_cgroup_try_charge_swap(struct pa
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) || cgroup_memory_noswap)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
 	memcg = page->mem_cgroup;
@@ -7033,7 +7025,7 @@ int mem_cgroup_try_charge_swap(struct pa
 
 	memcg = mem_cgroup_id_get_online(memcg);
 
-	if (!mem_cgroup_is_root(memcg) &&
+	if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -7061,14 +7053,11 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (cgroup_memory_noswap)
-		return;
-
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
+		if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 				page_counter_uncharge(&memcg->swap, nr_pages);
 			else
@@ -7253,7 +7242,11 @@ static struct cftype memsw_files[] = {
 
 static int __init mem_cgroup_swap_init(void)
 {
-	if (mem_cgroup_disabled() || cgroup_memory_noswap)
+	/* No memory control -> no swap control */
+	if (mem_cgroup_disabled())
+		cgroup_memory_noswap = true;
+
+	if (cgroup_memory_noswap)
 		return 0;
 
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
--- a/mm/swap_cgroup.c~mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control
+++ a/mm/swap_cgroup.c
@@ -171,9 +171,6 @@ int swap_cgroup_swapon(int type, unsigne
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
-	if (cgroup_memory_noswap)
-		return 0;
-
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
@@ -209,9 +206,6 @@ void swap_cgroup_swapoff(int type)
 	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
-	if (cgroup_memory_noswap)
-		return;
