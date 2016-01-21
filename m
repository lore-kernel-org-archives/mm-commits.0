From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-charge-swap-to-cgroup2.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 15:29:51 -0800
Message-ID: <56a169ef.assA6lpFdeg+rMVB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbcAUX3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: charge swap to cgroup2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-charge-swap-to-cgroup2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: charge swap to cgroup2

This patchset introduces swap accounting to cgroup2.



This patch (of 7):

In the legacy hierarchy we charge memsw, which is dubious, because:

 - memsw.limit must be >= memory.limit, so it is impossible to limit
   swap usage less than memory usage. Taking into account the fact that
   the primary limiting mechanism in the unified hierarchy is
   memory.high while memory.limit is either left unset or set to a very
   large value, moving memsw.limit knob to the unified hierarchy would
   effectively make it impossible to limit swap usage according to the
   user preference.

 - memsw.usage != memory.usage + swap.usage, because a page occupying
   both swap entry and a swap cache page is charged only once to memsw
   counter. As a result, it is possible to effectively eat up to
   memory.limit of memory pages *and* memsw.limit of swap entries, which
   looks unexpected.

That said, we should provide a different swap limiting mechanism for
cgroup2.

This patch adds mem_cgroup->swap counter, which charges the actual number
of swap entries used by a cgroup.  It is only charged in the unified
hierarchy, while the legacy hierarchy memsw logic is left intact.

The swap usage can be monitored using new memory.swap.current file and
limited using memory.swap.max.

Note, to charge swap resource properly in the unified hierarchy, we have
to make swap_entry_free uncharge swap only when ->usage reaches zero, not
just ->count, i.e.  when all references to a swap entry, including the one
taken by swap cache, are gone.  This is necessary, because otherwise
swap-in could result in uncharging swap even if the page is still in swap
cache and hence still occupies a swap entry.  At the same time, this
shouldn't break memsw counter logic, where a page is never charged twice
for using both memory and swap, because in case of legacy hierarchy we
uncharge swap on commit (see mem_cgroup_commit_charge).

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 include/linux/swap.h       |    6 +
 mm/memcontrol.c            |  118 ++++++++++++++++++++++++++++++++---
 mm/shmem.c                 |    4 +
 mm/swap_state.c            |    5 +
 mm/swapfile.c              |    4 -
 6 files changed, 128 insertions(+), 10 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-charge-swap-to-cgroup2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-charge-swap-to-cgroup2
+++ a/include/linux/memcontrol.h
@@ -163,6 +163,7 @@ struct mem_cgroup {
 
 	/* Accounted resources */
 	struct page_counter memory;
+	struct page_counter swap;
 
 	/* Legacy consumer-oriented counters */
 	struct page_counter memsw;
diff -puN include/linux/swap.h~mm-memcontrol-charge-swap-to-cgroup2 include/linux/swap.h
--- a/include/linux/swap.h~mm-memcontrol-charge-swap-to-cgroup2
+++ a/include/linux/swap.h
@@ -368,11 +368,17 @@ static inline int mem_cgroup_swappiness(
 #endif
 #ifdef CONFIG_MEMCG_SWAP
 extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
+extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
 extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
 #else
 static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
 }
+static inline int mem_cgroup_try_charge_swap(struct page *page,
+					     swp_entry_t entry)
+{
+	return 0;
+}
 static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
 {
 }
diff -puN mm/memcontrol.c~mm-memcontrol-charge-swap-to-cgroup2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-charge-swap-to-cgroup2
+++ a/mm/memcontrol.c
@@ -1220,7 +1220,7 @@ void mem_cgroup_print_oom_info(struct me
 		pr_cont(":");
 
 		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-			if (i == MEM_CGROUP_STAT_SWAP && !do_memsw_account())
+			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 				continue;
 			pr_cont(" %s:%luKB", mem_cgroup_stat_names[i],
 				K(mem_cgroup_read_stat(iter, i)));
@@ -1259,9 +1259,12 @@ static unsigned long mem_cgroup_get_limi
 	limit = memcg->memory.limit;
 	if (mem_cgroup_swappiness(memcg)) {
 		unsigned long memsw_limit;
+		unsigned long swap_limit;
 
 		memsw_limit = memcg->memsw.limit;
-		limit = min(limit + total_swap_pages, memsw_limit);
+		swap_limit = memcg->swap.limit;
+		swap_limit = min(swap_limit, (unsigned long)total_swap_pages);
+		limit = min(limit + swap_limit, memsw_limit);
 	}
 	return limit;
 }
@@ -4201,11 +4204,13 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent && parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
 		page_counter_init(&memcg->memory, &parent->memory);
+		page_counter_init(&memcg->swap, &parent->swap);
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
 		page_counter_init(&memcg->memory, NULL);
+		page_counter_init(&memcg->swap, NULL);
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 		page_counter_init(&memcg->tcpmem, NULL);
@@ -5224,7 +5229,7 @@ int mem_cgroup_try_charge(struct page *p
 		if (page->mem_cgroup)
 			goto out;
 
-		if (do_memsw_account()) {
+		if (do_swap_account) {
 			swp_entry_t ent = { .val = page_private(page), };
 			unsigned short id = lookup_swap_cgroup_id(ent);
 
@@ -5677,26 +5682,66 @@ void mem_cgroup_swapout(struct page *pag
 	memcg_check_events(memcg, page);
 }
 
+/*
+ * mem_cgroup_try_charge_swap - try charging a swap entry
+ * @page: page being added to swap
+ * @entry: swap entry to charge
+ *
+ * Try to charge @entry to the memcg that @page belongs to.
+ *
+ * Returns 0 on success, -ENOMEM on failure.
+ */
+int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
+{
+	struct mem_cgroup *memcg;
+	struct page_counter *counter;
+	unsigned short oldid;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) || !do_swap_account)
+		return 0;
+
+	memcg = page->mem_cgroup;
+
+	/* Readahead page, never charged */
+	if (!memcg)
+		return 0;
+
+	if (!mem_cgroup_is_root(memcg) &&
+	    !page_counter_try_charge(&memcg->swap, 1, &counter))
+		return -ENOMEM;
+
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
+	VM_BUG_ON_PAGE(oldid, page);
+	mem_cgroup_swap_statistics(memcg, true);
+
+	css_get(&memcg->css);
+	return 0;
+}
+
 /**
  * mem_cgroup_uncharge_swap - uncharge a swap entry
  * @entry: swap entry to uncharge
  *
- * Drop the memsw charge associated with @entry.
+ * Drop the swap charge associated with @entry.
  */
 void mem_cgroup_uncharge_swap(swp_entry_t entry)
 {
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (!do_memsw_account())
+	if (!do_swap_account)
 		return;
 
 	id = swap_cgroup_record(entry, 0);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg))
-			page_counter_uncharge(&memcg->memsw, 1);
+		if (!mem_cgroup_is_root(memcg)) {
+			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+				page_counter_uncharge(&memcg->swap, 1);
+			else
+				page_counter_uncharge(&memcg->memsw, 1);
+		}
 		mem_cgroup_swap_statistics(memcg, false);
 		css_put(&memcg->css);
 	}
@@ -5720,6 +5765,63 @@ static int __init enable_swap_account(ch
 }
 __setup("swapaccount=", enable_swap_account);
 
+static u64 swap_current_read(struct cgroup_subsys_state *css,
+			     struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)page_counter_read(&memcg->swap) * PAGE_SIZE;
+}
+
+static int swap_max_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	unsigned long max = READ_ONCE(memcg->swap.limit);
+
+	if (max == PAGE_COUNTER_MAX)
+		seq_puts(m, "max\n");
+	else
+		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
+
+	return 0;
+}
+
+static ssize_t swap_max_write(struct kernfs_open_file *of,
+			      char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long max;
+	int err;
+
+	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "max", &max);
+	if (err)
+		return err;
+
+	mutex_lock(&memcg_limit_mutex);
+	err = page_counter_limit(&memcg->swap, max);
+	mutex_unlock(&memcg_limit_mutex);
+	if (err)
+		return err;
+
+	return nbytes;
+}
+
+static struct cftype swap_files[] = {
+	{
+		.name = "swap.current",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = swap_current_read,
+	},
+	{
+		.name = "swap.max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_max_show,
+		.write = swap_max_write,
+	},
+	{ }	/* terminate */
+};
+
 static struct cftype memsw_cgroup_files[] = {
 	{
 		.name = "memsw.usage_in_bytes",
@@ -5751,6 +5853,8 @@ static int __init mem_cgroup_swap_init(v
 {
 	if (!mem_cgroup_disabled() && really_do_swap_account) {
 		do_swap_account = 1;
+		WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys,
+					       swap_files));
 		WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys,
 						  memsw_cgroup_files));
 	}
diff -puN mm/shmem.c~mm-memcontrol-charge-swap-to-cgroup2 mm/shmem.c
--- a/mm/shmem.c~mm-memcontrol-charge-swap-to-cgroup2
+++ a/mm/shmem.c
@@ -912,6 +912,9 @@ static int shmem_writepage(struct page *
 	if (!swap.val)
 		goto redirty;
 
+	if (mem_cgroup_try_charge_swap(page, swap))
+		goto free_swap;
+
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
 	 * if it's not already there.  Do it now before the page is
@@ -940,6 +943,7 @@ static int shmem_writepage(struct page *
 	}
 
 	mutex_unlock(&shmem_swaplist_mutex);
+free_swap:
 	swapcache_free(swap);
 redirty:
 	set_page_dirty(page);
diff -puN mm/swap_state.c~mm-memcontrol-charge-swap-to-cgroup2 mm/swap_state.c
--- a/mm/swap_state.c~mm-memcontrol-charge-swap-to-cgroup2
+++ a/mm/swap_state.c
@@ -170,6 +170,11 @@ int add_to_swap(struct page *page, struc
 	if (!entry.val)
 		return 0;
 
+	if (mem_cgroup_try_charge_swap(page, entry)) {
+		swapcache_free(entry);
+		return 0;
+	}
+
 	if (unlikely(PageTransHuge(page)))
 		if (unlikely(split_huge_page_to_list(page, list))) {
 			swapcache_free(entry);
diff -puN mm/swapfile.c~mm-memcontrol-charge-swap-to-cgroup2 mm/swapfile.c
--- a/mm/swapfile.c~mm-memcontrol-charge-swap-to-cgroup2
+++ a/mm/swapfile.c
@@ -785,14 +785,12 @@ static unsigned char swap_entry_free(str
 			count--;
 	}
 
-	if (!count)
-		mem_cgroup_uncharge_swap(entry);
