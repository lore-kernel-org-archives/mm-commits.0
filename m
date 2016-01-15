From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:34:42 -0800
Message-ID: <56997402.dHOewAFweva1BtqT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbcAOWep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not account memory+swap on unified hierarchy
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: do not account memory+swap on unified hierarchy

The unified hierarchy memory controller doesn't expose the memory+swap
counter to userspace, but its accounting is hardcoded in all charge paths
right now, including the per-cpu charge cache ("the stock").

To avoid adding yet more pointless memory+swap accounting with the socket
memory support in unified hierarchy, disable the counter altogether when
in unified hierarchy mode.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy
+++ a/mm/memcontrol.c
@@ -87,6 +87,12 @@ int do_swap_account __read_mostly;
 #define do_swap_account		0
 #endif
 
+/* Whether legacy memory+swap accounting is active */
+static bool do_memsw_account(void)
+{
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && do_swap_account;
+}
+
 static const char * const mem_cgroup_stat_names[] = {
 	"cache",
 	"rss",
@@ -1199,7 +1205,7 @@ static unsigned long mem_cgroup_margin(s
 	if (count < limit)
 		margin = limit - count;
 
-	if (do_swap_account) {
+	if (do_memsw_account()) {
 		count = page_counter_read(&memcg->memsw);
 		limit = READ_ONCE(memcg->memsw.limit);
 		if (count <= limit)
@@ -1302,7 +1308,7 @@ void mem_cgroup_print_oom_info(struct me
 		pr_cont(":");
 
 		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+			if (i == MEM_CGROUP_STAT_SWAP && !do_memsw_account())
 				continue;
 			pr_cont(" %s:%luKB", mem_cgroup_stat_names[i],
 				K(mem_cgroup_read_stat(iter, i)));
@@ -1925,7 +1931,7 @@ static void drain_stock(struct memcg_sto
 
 	if (stock->nr_pages) {
 		page_counter_uncharge(&old->memory, stock->nr_pages);
-		if (do_swap_account)
+		if (do_memsw_account())
 			page_counter_uncharge(&old->memsw, stock->nr_pages);
 		css_put_many(&old->css, stock->nr_pages);
 		stock->nr_pages = 0;
@@ -2055,11 +2061,11 @@ retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
-	if (!do_swap_account ||
+	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
 			goto done_restock;
-		if (do_swap_account)
+		if (do_memsw_account())
 			page_counter_uncharge(&memcg->memsw, batch);
 		mem_over_limit = mem_cgroup_from_counter(counter, memory);
 	} else {
@@ -2146,7 +2152,7 @@ force:
 	 * temporarily by force charging it.
 	 */
 	page_counter_charge(&memcg->memory, nr_pages);
-	if (do_swap_account)
+	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 	css_get_many(&memcg->css, nr_pages);
 
@@ -2183,7 +2189,7 @@ static void cancel_charge(struct mem_cgr
 		return;
 
 	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_swap_account)
+	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 
 	css_put_many(&memcg->css, nr_pages);
@@ -2469,7 +2475,7 @@ void __memcg_kmem_uncharge(struct page *
 
 	page_counter_uncharge(&memcg->kmem, nr_pages);
 	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_swap_account)
+	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 
 	page->mem_cgroup = NULL;
@@ -3184,7 +3190,7 @@ static int memcg_stat_show(struct seq_fi
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "%s %lu\n", mem_cgroup_stat_names[i],
 			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
@@ -3206,14 +3212,14 @@ static int memcg_stat_show(struct seq_fi
 	}
 	seq_printf(m, "hierarchical_memory_limit %llu\n",
 		   (u64)memory * PAGE_SIZE);
-	if (do_swap_account)
+	if (do_memsw_account())
 		seq_printf(m, "hierarchical_memsw_limit %llu\n",
 			   (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		unsigned long long val = 0;
 
-		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_memsw_account())
 			continue;
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
@@ -3344,7 +3350,7 @@ static void mem_cgroup_threshold(struct
 {
 	while (memcg) {
 		__mem_cgroup_threshold(memcg, false);
-		if (do_swap_account)
+		if (do_memsw_account())
 			__mem_cgroup_threshold(memcg, true);
 
 		memcg = parent_mem_cgroup(memcg);
@@ -4497,7 +4503,7 @@ static struct page *mc_handle_swap_pte(s
 	 * we call find_get_page() with swapper_space directly.
 	 */
 	page = find_get_page(swap_address_space(ent), ent.val);
-	if (do_swap_account)
+	if (do_memsw_account())
 		entry->val = ent.val;
 
 	return page;
@@ -4532,7 +4538,7 @@ static struct page *mc_handle_file_pte(s
 		page = find_get_entry(mapping, pgoff);
 		if (radix_tree_exceptional_entry(page)) {
 			swp_entry_t swp = radix_to_swp_entry(page);
-			if (do_swap_account)
+			if (do_memsw_account())
 				*entry = swp;
 			page = find_get_page(swap_address_space(swp), swp.val);
 		}
@@ -5325,7 +5331,7 @@ int mem_cgroup_try_charge(struct page *p
 		if (page->mem_cgroup)
 			goto out;
 
-		if (do_swap_account) {
+		if (do_memsw_account()) {
 			swp_entry_t ent = { .val = page_private(page), };
 			unsigned short id = lookup_swap_cgroup_id(ent);
 
@@ -5399,7 +5405,7 @@ void mem_cgroup_commit_charge(struct pag
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (do_swap_account && PageSwapCache(page)) {
+	if (do_memsw_account() && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
@@ -5448,7 +5454,7 @@ static void uncharge_batch(struct mem_cg
 
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_uncharge(&memcg->memory, nr_pages);
-		if (do_swap_account)
+		if (do_memsw_account())
 			page_counter_uncharge(&memcg->memsw, nr_pages);
 		memcg_oom_recover(memcg);
 	}
@@ -5656,7 +5662,7 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
-	if (!do_swap_account)
+	if (!do_memsw_account())
 		return;
 
 	memcg = page->mem_cgroup;
@@ -5696,7 +5702,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (!do_swap_account)
+	if (!do_memsw_account())
 		return;
 
 	id = swap_cgroup_record(entry, 0);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

