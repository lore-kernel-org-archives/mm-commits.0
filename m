From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:20:10 -0700
Message-ID: <20200604172010.AuX0MiWWo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbgFDRUM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters

Memcg maintains private MEMCG_CACHE and NR_SHMEM counters.  This
divergence from the generic VM accounting means unnecessary code overhead,
and creates a dependency for memcg that page->mapping is set up at the
time of charging, so that page types can be told apart.

Convert the generic accounting sites to mod_lruvec_page_state and friends
to maintain the per-cgroup vmstat counters of NR_FILE_PAGES and NR_SHMEM. 
The page is already locked in these places, so page->mem_cgroup is stable;
we only need minimal tweaks of two mem_cgroup_migrate() calls to ensure
it's set up in time.

Then replace MEMCG_CACHE with NR_FILE_PAGES and delete the private
NR_SHMEM accounting sites.

Link: http://lkml.kernel.org/r/20200508183105.225460-10-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 mm/filemap.c               |   17 +++++++++--------
 mm/khugepaged.c            |   16 +++++++++++-----
 mm/memcontrol.c            |   28 +++++++++++-----------------
 mm/migrate.c               |   15 +++++++++++----
 mm/shmem.c                 |   14 +++++++-------
 6 files changed, 50 insertions(+), 43 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters
+++ a/include/linux/memcontrol.h
@@ -29,8 +29,7 @@ struct kmem_cache;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
-	MEMCG_CACHE = NR_VM_NODE_STAT_ITEMS,
-	MEMCG_RSS,
+	MEMCG_RSS = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_RSS_HUGE,
 	MEMCG_SWAP,
 	MEMCG_SOCK,
--- a/mm/filemap.c~mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters
+++ a/mm/filemap.c
@@ -199,9 +199,9 @@ static void unaccount_page_cache_page(st
 
 	nr = hpage_nr_pages(page);
 
-	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	__mod_lruvec_page_state(page, NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page)) {
-		__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
+		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
 		if (PageTransHuge(page))
 			__dec_node_page_state(page, NR_SHMEM_THPS);
 	} else if (PageTransHuge(page)) {
@@ -802,21 +802,22 @@ int replace_page_cache_page(struct page
 	new->mapping = mapping;
 	new->index = offset;
 
+	mem_cgroup_migrate(old, new);
+
 	xas_lock_irqsave(&xas, flags);
 	xas_store(&xas, new);
 
 	old->mapping = NULL;
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!PageHuge(old))
-		__dec_node_page_state(old, NR_FILE_PAGES);
+		__dec_lruvec_page_state(old, NR_FILE_PAGES);
 	if (!PageHuge(new))
-		__inc_node_page_state(new, NR_FILE_PAGES);
+		__inc_lruvec_page_state(new, NR_FILE_PAGES);
 	if (PageSwapBacked(old))
-		__dec_node_page_state(old, NR_SHMEM);
+		__dec_lruvec_page_state(old, NR_SHMEM);
 	if (PageSwapBacked(new))
-		__inc_node_page_state(new, NR_SHMEM);
+		__inc_lruvec_page_state(new, NR_SHMEM);
 	xas_unlock_irqrestore(&xas, flags);
-	mem_cgroup_migrate(old, new);
 	if (freepage)
 		freepage(old);
 	put_page(old);
@@ -867,7 +868,7 @@ static int __add_to_page_cache_locked(st
 
 		/* hugetlb pages do not participate in page cache accounting */
 		if (!huge)
-			__inc_node_page_state(page, NR_FILE_PAGES);
+			__inc_lruvec_page_state(page, NR_FILE_PAGES);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp_mask & GFP_RECLAIM_MASK));
--- a/mm/khugepaged.c~mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters
+++ a/mm/khugepaged.c
@@ -1844,12 +1844,18 @@ out_unlock:
 	}
 
 	if (nr_none) {
-		struct zone *zone = page_zone(new_page);
-
-		__mod_node_page_state(zone->zone_pgdat, NR_FILE_PAGES, nr_none);
+		struct lruvec *lruvec;
+		/*
+		 * XXX: We have started try_charge and pinned the
+		 * memcg, but the page isn't committed yet so we
+		 * cannot use mod_lruvec_page_state(). This hackery
+		 * will be cleaned up when remove the page->mapping
+		 * dependency from memcg and fully charge above.
+		 */
+		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(new_page));
+		__mod_lruvec_state(lruvec, NR_FILE_PAGES, nr_none);
 		if (is_shmem)
-			__mod_node_page_state(zone->zone_pgdat,
-					      NR_SHMEM, nr_none);
+			__mod_lruvec_state(lruvec, NR_SHMEM, nr_none);
 	}
 
 xa_locked:
--- a/mm/memcontrol.c~mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters
+++ a/mm/memcontrol.c
@@ -842,11 +842,6 @@ static void mem_cgroup_charge_statistics
 	 */
 	if (PageAnon(page))
 		__mod_memcg_state(memcg, MEMCG_RSS, nr_pages);
-	else {
-		__mod_memcg_state(memcg, MEMCG_CACHE, nr_pages);
-		if (PageSwapBacked(page))
-			__mod_memcg_state(memcg, NR_SHMEM, nr_pages);
-	}
 
 	if (abs(nr_pages) > 1) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -1392,7 +1387,7 @@ static char *memory_stat_format(struct m
 		       (u64)memcg_page_state(memcg, MEMCG_RSS) *
 		       PAGE_SIZE);
 	seq_buf_printf(&s, "file %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_CACHE) *
+		       (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
 		       PAGE_SIZE);
 	seq_buf_printf(&s, "kernel_stack %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) *
@@ -3357,7 +3352,7 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		val = memcg_page_state(memcg, MEMCG_CACHE) +
+		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, MEMCG_RSS);
 		if (swap)
 			val += memcg_page_state(memcg, MEMCG_SWAP);
@@ -3828,7 +3823,7 @@ static int memcg_numa_stat_show(struct s
 #endif /* CONFIG_NUMA */
 
 static const unsigned int memcg1_stats[] = {
-	MEMCG_CACHE,
+	NR_FILE_PAGES,
 	MEMCG_RSS,
 	MEMCG_RSS_HUGE,
 	NR_SHMEM,
@@ -5461,6 +5456,14 @@ static int mem_cgroup_move_account(struc
 	lock_page_memcg(page);
 
 	if (!PageAnon(page)) {
+		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_FILE_PAGES, nr_pages);
+
+		if (PageSwapBacked(page)) {
+			__mod_lruvec_state(from_vec, NR_SHMEM, -nr_pages);
+			__mod_lruvec_state(to_vec, NR_SHMEM, nr_pages);
+		}
+
 		if (page_mapped(page)) {
 			__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
@@ -6673,10 +6676,8 @@ struct uncharge_gather {
 	unsigned long nr_pages;
 	unsigned long pgpgout;
 	unsigned long nr_anon;
-	unsigned long nr_file;
 	unsigned long nr_kmem;
 	unsigned long nr_huge;
-	unsigned long nr_shmem;
 	struct page *dummy_page;
 };
 
@@ -6700,9 +6701,7 @@ static void uncharge_batch(const struct
 
 	local_irq_save(flags);
 	__mod_memcg_state(ug->memcg, MEMCG_RSS, -ug->nr_anon);
-	__mod_memcg_state(ug->memcg, MEMCG_CACHE, -ug->nr_file);
 	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
-	__mod_memcg_state(ug->memcg, NR_SHMEM, -ug->nr_shmem);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
@@ -6743,11 +6742,6 @@ static void uncharge_page(struct page *p
 			ug->nr_huge += nr_pages;
 		if (PageAnon(page))
 			ug->nr_anon += nr_pages;
-		else {
-			ug->nr_file += nr_pages;
-			if (PageSwapBacked(page))
-				ug->nr_shmem += nr_pages;
-		}
 		ug->pgpgout++;
 	} else {
 		ug->nr_kmem += nr_pages;
--- a/mm/migrate.c~mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters
+++ a/mm/migrate.c
@@ -490,11 +490,18 @@ int migrate_page_move_mapping(struct add
 	 * are mapped to swap space.
 	 */
 	if (newzone != oldzone) {
-		__dec_node_state(oldzone->zone_pgdat, NR_FILE_PAGES);
-		__inc_node_state(newzone->zone_pgdat, NR_FILE_PAGES);
+		struct lruvec *old_lruvec, *new_lruvec;
+		struct mem_cgroup *memcg;
+
+		memcg = page_memcg(page);
+		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
+		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
+
+		__dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
+		__inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
 		if (PageSwapBacked(page) && !PageSwapCache(page)) {
-			__dec_node_state(oldzone->zone_pgdat, NR_SHMEM);
-			__inc_node_state(newzone->zone_pgdat, NR_SHMEM);
+			__dec_lruvec_state(old_lruvec, NR_SHMEM);
+			__inc_lruvec_state(new_lruvec, NR_SHMEM);
 		}
 		if (dirty && mapping_cap_account_dirty(mapping)) {
 			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
--- a/mm/shmem.c~mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters
+++ a/mm/shmem.c
@@ -653,8 +653,8 @@ next:
 			__inc_node_page_state(page, NR_SHMEM_THPS);
 		}
 		mapping->nrpages += nr;
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
-		__mod_node_page_state(page_pgdat(page), NR_SHMEM, nr);
+		__mod_lruvec_page_state(page, NR_FILE_PAGES, nr);
+		__mod_lruvec_page_state(page, NR_SHMEM, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -685,8 +685,8 @@ static void shmem_delete_from_page_cache
 	error = shmem_replace_entry(mapping, page->index, page, radswap);
 	page->mapping = NULL;
 	mapping->nrpages--;
-	__dec_node_page_state(page, NR_FILE_PAGES);
-	__dec_node_page_state(page, NR_SHMEM);
+	__dec_lruvec_page_state(page, NR_FILE_PAGES);
+	__dec_lruvec_page_state(page, NR_SHMEM);
 	xa_unlock_irq(&mapping->i_pages);
 	put_page(page);
 	BUG_ON(error);
@@ -1593,8 +1593,9 @@ static int shmem_replace_page(struct pag
 	xa_lock_irq(&swap_mapping->i_pages);
 	error = shmem_replace_entry(swap_mapping, swap_index, oldpage, newpage);
 	if (!error) {
-		__inc_node_page_state(newpage, NR_FILE_PAGES);
-		__dec_node_page_state(oldpage, NR_FILE_PAGES);
+		mem_cgroup_migrate(oldpage, newpage);
+		__inc_lruvec_page_state(newpage, NR_FILE_PAGES);
+		__dec_lruvec_page_state(oldpage, NR_FILE_PAGES);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
@@ -1606,7 +1607,6 @@ static int shmem_replace_page(struct pag
 		 */
 		oldpage = newpage;
 	} else {
-		mem_cgroup_migrate(oldpage, newpage);
 		lru_cache_add_anon(newpage);
 		*pagep = newpage;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
