From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch added to -mm tree
Date: Tue, 08 Dec 2015 14:52:05 -0800
Message-ID: <56675f15.TAKVC93dePU+spxc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbLHWwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not account memory+swap on unified hierarchy
has been added to the -mm tree.  Its filename is
     mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1175,7 +1181,7 @@ static unsigned long mem_cgroup_margin(s
 	if (count < limit)
 		margin = limit - count;
 
-	if (do_swap_account) {
+	if (do_memsw_account()) {
 		count = page_counter_read(&memcg->memsw);
 		limit = READ_ONCE(memcg->memsw.limit);
 		if (count <= limit)
@@ -1278,7 +1284,7 @@ void mem_cgroup_print_oom_info(struct me
 		pr_cont(":");
 
 		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+			if (i == MEM_CGROUP_STAT_SWAP && !do_memsw_account())
 				continue;
 			pr_cont(" %s:%luKB", mem_cgroup_stat_names[i],
 				K(mem_cgroup_read_stat(iter, i)));
@@ -1901,7 +1907,7 @@ static void drain_stock(struct memcg_sto
 
 	if (stock->nr_pages) {
 		page_counter_uncharge(&old->memory, stock->nr_pages);
-		if (do_swap_account)
+		if (do_memsw_account())
 			page_counter_uncharge(&old->memsw, stock->nr_pages);
 		css_put_many(&old->css, stock->nr_pages);
 		stock->nr_pages = 0;
@@ -2031,11 +2037,11 @@ retry:
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
@@ -2122,7 +2128,7 @@ force:
 	 * temporarily by force charging it.
 	 */
 	page_counter_charge(&memcg->memory, nr_pages);
-	if (do_swap_account)
+	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 	css_get_many(&memcg->css, nr_pages);
 
@@ -2159,7 +2165,7 @@ static void cancel_charge(struct mem_cgr
 		return;
 
 	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_swap_account)
+	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 
 	css_put_many(&memcg->css, nr_pages);
@@ -2445,7 +2451,7 @@ void __memcg_kmem_uncharge(struct page *
 
 	page_counter_uncharge(&memcg->kmem, nr_pages);
 	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_swap_account)
+	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 
 	page->mem_cgroup = NULL;
@@ -3160,7 +3166,7 @@ static int memcg_stat_show(struct seq_fi
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "%s %lu\n", mem_cgroup_stat_names[i],
 			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
@@ -3182,14 +3188,14 @@ static int memcg_stat_show(struct seq_fi
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
@@ -3320,7 +3326,7 @@ static void mem_cgroup_threshold(struct
 {
 	while (memcg) {
 		__mem_cgroup_threshold(memcg, false);
-		if (do_swap_account)
+		if (do_memsw_account())
 			__mem_cgroup_threshold(memcg, true);
 
 		memcg = parent_mem_cgroup(memcg);
@@ -4466,7 +4472,7 @@ static struct page *mc_handle_swap_pte(s
 	 * we call find_get_page() with swapper_space directly.
 	 */
 	page = find_get_page(swap_address_space(ent), ent.val);
-	if (do_swap_account)
+	if (do_memsw_account())
 		entry->val = ent.val;
 
 	return page;
@@ -4501,7 +4507,7 @@ static struct page *mc_handle_file_pte(s
 		page = find_get_entry(mapping, pgoff);
 		if (radix_tree_exceptional_entry(page)) {
 			swp_entry_t swp = radix_to_swp_entry(page);
-			if (do_swap_account)
+			if (do_memsw_account())
 				*entry = swp;
 			page = find_get_page(swap_address_space(swp), swp.val);
 		}
@@ -5292,7 +5298,7 @@ int mem_cgroup_try_charge(struct page *p
 		if (page->mem_cgroup)
 			goto out;
 
-		if (do_swap_account) {
+		if (do_memsw_account()) {
 			swp_entry_t ent = { .val = page_private(page), };
 			unsigned short id = lookup_swap_cgroup_id(ent);
 
@@ -5366,7 +5372,7 @@ void mem_cgroup_commit_charge(struct pag
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (do_swap_account && PageSwapCache(page)) {
+	if (do_memsw_account() && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
@@ -5415,7 +5421,7 @@ static void uncharge_batch(struct mem_cg
 
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_uncharge(&memcg->memory, nr_pages);
-		if (do_swap_account)
+		if (do_memsw_account())
 			page_counter_uncharge(&memcg->memsw, nr_pages);
 		memcg_oom_recover(memcg);
 	}
@@ -5623,7 +5629,7 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
-	if (!do_swap_account)
+	if (!do_memsw_account())
 		return;
 
 	memcg = page->mem_cgroup;
@@ -5663,7 +5669,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (!do_swap_account)
+	if (!do_memsw_account())
 		return;
 
 	id = swap_cgroup_record(entry, 0);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch

