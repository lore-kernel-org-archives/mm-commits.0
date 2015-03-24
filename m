From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-remove-usages-of-access_once.patch removed
 from -mm tree
Date: Tue, 24 Mar 2015 15:44:38 -0700
Message-ID: <5511e8d6.0/lFfRrEtHbkJBz2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbbCXWoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:44:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.low2@hp.com, borntraeger@de.ibm.com, dave@stgolabs.net, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     From: Jason Low <jason.low2@hp.com>
has been removed from the -mm tree.  Its filename was
     mm-remove-usages-of-access_once.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: Remove usages of ACCESS_ONCE
From: Jason Low <jason.low2@hp.com>

Commit 38c5ce936a08 ("mm/gup: Replace ACCESS_ONCE with READ_ONCE")
converted ACCESS_ONCE usage in gup_pmd_range() to READ_ONCE, since
ACCESS_ONCE doesn't work reliably on non-scalar types.

This patch removes the rest of the usages of ACCESS_ONCE, and uses
READ_ONCE for the read accesses.  This also makes things cleaner, instead
of using separate/multiple sets of APIs.

Signed-off-by: Jason Low <jason.low2@hp.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c         |    4 ++--
 mm/huge_memory.c |    4 ++--
 mm/internal.h    |    4 ++--
 mm/ksm.c         |   10 +++++-----
 mm/memcontrol.c  |   18 +++++++++---------
 mm/memory.c      |    2 +-
 mm/mmap.c        |    8 ++++----
 mm/page_alloc.c  |    6 +++---
 mm/rmap.c        |    6 +++---
 mm/slub.c        |    4 ++--
 mm/swap_state.c  |    2 +-
 mm/swapfile.c    |    2 +-
 12 files changed, 35 insertions(+), 35 deletions(-)

diff -puN mm/gup.c~mm-remove-usages-of-access_once mm/gup.c
--- a/mm/gup.c~mm-remove-usages-of-access_once
+++ a/mm/gup.c
@@ -1019,7 +1019,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 		 *
 		 * for an example see gup_get_pte in arch/x86/mm/gup.c
 		 */
-		pte_t pte = ACCESS_ONCE(*ptep);
+		pte_t pte = READ_ONCE(*ptep);
 		struct page *page;
 
 		/*
@@ -1309,7 +1309,7 @@ int __get_user_pages_fast(unsigned long
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
-		pgd_t pgd = ACCESS_ONCE(*pgdp);
+		pgd_t pgd = READ_ONCE(*pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff -puN mm/huge_memory.c~mm-remove-usages-of-access_once mm/huge_memory.c
--- a/mm/huge_memory.c~mm-remove-usages-of-access_once
+++ a/mm/huge_memory.c
@@ -183,7 +183,7 @@ static struct page *get_huge_zero_page(v
 	struct page *zero_page;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return ACCESS_ONCE(huge_zero_page);
+		return READ_ONCE(huge_zero_page);
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
@@ -202,7 +202,7 @@ retry:
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
 	preempt_enable();
-	return ACCESS_ONCE(huge_zero_page);
+	return READ_ONCE(huge_zero_page);
 }
 
 static void put_huge_zero_page(void)
diff -puN mm/internal.h~mm-remove-usages-of-access_once mm/internal.h
--- a/mm/internal.h~mm-remove-usages-of-access_once
+++ a/mm/internal.h
@@ -224,13 +224,13 @@ static inline unsigned long page_order(s
  * PageBuddy() should be checked first by the caller to minimize race window,
  * and invalid values must be handled gracefully.
  *
- * ACCESS_ONCE is used so that if the caller assigns the result into a local
+ * READ_ONCE is used so that if the caller assigns the result into a local
  * variable and e.g. tests it for valid range before using, the compiler cannot
  * decide to remove the variable and inline the page_private(page) multiple
  * times, potentially observing different values in the tests and the actual
  * use of the result.
  */
-#define page_order_unsafe(page)		ACCESS_ONCE(page_private(page))
+#define page_order_unsafe(page)		READ_ONCE(page_private(page))
 
 static inline bool is_cow_mapping(vm_flags_t flags)
 {
diff -puN mm/ksm.c~mm-remove-usages-of-access_once mm/ksm.c
--- a/mm/ksm.c~mm-remove-usages-of-access_once
+++ a/mm/ksm.c
@@ -542,7 +542,7 @@ static struct page *get_ksm_page(struct
 	expected_mapping = (void *)stable_node +
 				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 again:
-	kpfn = ACCESS_ONCE(stable_node->kpfn);
+	kpfn = READ_ONCE(stable_node->kpfn);
 	page = pfn_to_page(kpfn);
 
 	/*
@@ -551,7 +551,7 @@ again:
 	 * but on Alpha we need to be more careful.
 	 */
 	smp_read_barrier_depends();
-	if (ACCESS_ONCE(page->mapping) != expected_mapping)
+	if (READ_ONCE(page->mapping) != expected_mapping)
 		goto stale;
 
 	/*
@@ -577,14 +577,14 @@ again:
 		cpu_relax();
 	}
 
-	if (ACCESS_ONCE(page->mapping) != expected_mapping) {
+	if (READ_ONCE(page->mapping) != expected_mapping) {
 		put_page(page);
 		goto stale;
 	}
 
 	if (lock_it) {
 		lock_page(page);
-		if (ACCESS_ONCE(page->mapping) != expected_mapping) {
+		if (READ_ONCE(page->mapping) != expected_mapping) {
 			unlock_page(page);
 			put_page(page);
 			goto stale;
@@ -600,7 +600,7 @@ stale:
 	 * before checking whether node->kpfn has been changed.
 	 */
 	smp_rmb();
-	if (ACCESS_ONCE(stable_node->kpfn) != kpfn)
+	if (READ_ONCE(stable_node->kpfn) != kpfn)
 		goto again;
 	remove_node_from_stable_tree(stable_node);
 	return NULL;
diff -puN mm/memcontrol.c~mm-remove-usages-of-access_once mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-usages-of-access_once
+++ a/mm/memcontrol.c
@@ -674,7 +674,7 @@ static void mem_cgroup_remove_exceeded(s
 static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
 {
 	unsigned long nr_pages = page_counter_read(&memcg->memory);
-	unsigned long soft_limit = ACCESS_ONCE(memcg->soft_limit);
+	unsigned long soft_limit = READ_ONCE(memcg->soft_limit);
 	unsigned long excess = 0;
 
 	if (nr_pages > soft_limit)
@@ -1042,7 +1042,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			goto out_unlock;
 
 		do {
-			pos = ACCESS_ONCE(iter->position);
+			pos = READ_ONCE(iter->position);
 			/*
 			 * A racing update may change the position and
 			 * put the last reference, hence css_tryget(),
@@ -1359,13 +1359,13 @@ static unsigned long mem_cgroup_margin(s
 	unsigned long limit;
 
 	count = page_counter_read(&memcg->memory);
-	limit = ACCESS_ONCE(memcg->memory.limit);
+	limit = READ_ONCE(memcg->memory.limit);
 	if (count < limit)
 		margin = limit - count;
 
 	if (do_swap_account) {
 		count = page_counter_read(&memcg->memsw);
-		limit = ACCESS_ONCE(memcg->memsw.limit);
+		limit = READ_ONCE(memcg->memsw.limit);
 		if (count <= limit)
 			margin = min(margin, limit - count);
 	}
@@ -2637,7 +2637,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 		return cachep;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
-	kmemcg_id = ACCESS_ONCE(memcg->kmemcg_id);
+	kmemcg_id = READ_ONCE(memcg->kmemcg_id);
 	if (kmemcg_id < 0)
 		goto out;
 
@@ -5007,7 +5007,7 @@ static int mem_cgroup_can_attach(struct
 	 * tunable will only affect upcoming migrations, not the current one.
 	 * So we need to save it, and keep it going.
 	 */
-	move_flags = ACCESS_ONCE(memcg->move_charge_at_immigrate);
+	move_flags = READ_ONCE(memcg->move_charge_at_immigrate);
 	if (move_flags) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
@@ -5241,7 +5241,7 @@ static u64 memory_current_read(struct cg
 static int memory_low_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-	unsigned long low = ACCESS_ONCE(memcg->low);
+	unsigned long low = READ_ONCE(memcg->low);
 
 	if (low == PAGE_COUNTER_MAX)
 		seq_puts(m, "max\n");
@@ -5271,7 +5271,7 @@ static ssize_t memory_low_write(struct k
 static int memory_high_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-	unsigned long high = ACCESS_ONCE(memcg->high);
+	unsigned long high = READ_ONCE(memcg->high);
 
 	if (high == PAGE_COUNTER_MAX)
 		seq_puts(m, "max\n");
@@ -5301,7 +5301,7 @@ static ssize_t memory_high_write(struct
 static int memory_max_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
+	unsigned long max = READ_ONCE(memcg->memory.limit);
 
 	if (max == PAGE_COUNTER_MAX)
 		seq_puts(m, "max\n");
diff -puN mm/memory.c~mm-remove-usages-of-access_once mm/memory.c
--- a/mm/memory.c~mm-remove-usages-of-access_once
+++ a/mm/memory.c
@@ -2845,7 +2845,7 @@ static void do_fault_around(struct vm_ar
 	struct vm_fault vmf;
 	int off;
 
-	nr_pages = ACCESS_ONCE(fault_around_bytes) >> PAGE_SHIFT;
+	nr_pages = READ_ONCE(fault_around_bytes) >> PAGE_SHIFT;
 	mask = ~(nr_pages * PAGE_SIZE - 1) & PAGE_MASK;
 
 	start_addr = max(address & mask, vma->vm_start);
diff -puN mm/mmap.c~mm-remove-usages-of-access_once mm/mmap.c
--- a/mm/mmap.c~mm-remove-usages-of-access_once
+++ a/mm/mmap.c
@@ -1133,7 +1133,7 @@ static int anon_vma_compatible(struct vm
  * by another page fault trying to merge _that_. But that's ok: if it
  * is being set up, that automatically means that it will be a singleton
  * acceptable for merging, so we can do all of this optimistically. But
- * we do that ACCESS_ONCE() to make sure that we never re-load the pointer.
+ * we do that READ_ONCE() to make sure that we never re-load the pointer.
  *
  * IOW: that the "list_is_singular()" test on the anon_vma_chain only
  * matters for the 'stable anon_vma' case (ie the thing we want to avoid
@@ -1147,7 +1147,7 @@ static int anon_vma_compatible(struct vm
 static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old, struct vm_area_struct *a, struct vm_area_struct *b)
 {
 	if (anon_vma_compatible(a, b)) {
-		struct anon_vma *anon_vma = ACCESS_ONCE(old->anon_vma);
+		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
 
 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
 			return anon_vma;
@@ -2100,7 +2100,7 @@ static int acct_stack_growth(struct vm_a
 	actual_size = size;
 	if (size && (vma->vm_flags & (VM_GROWSUP | VM_GROWSDOWN)))
 		actual_size -= PAGE_SIZE;
-	if (actual_size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur))
+	if (actual_size > READ_ONCE(rlim[RLIMIT_STACK].rlim_cur))
 		return -ENOMEM;
 
 	/* mlock limit tests */
@@ -2108,7 +2108,7 @@ static int acct_stack_growth(struct vm_a
 		unsigned long locked;
 		unsigned long limit;
 		locked = mm->locked_vm + grow;
-		limit = ACCESS_ONCE(rlim[RLIMIT_MEMLOCK].rlim_cur);
+		limit = READ_ONCE(rlim[RLIMIT_MEMLOCK].rlim_cur);
 		limit >>= PAGE_SHIFT;
 		if (locked > limit && !capable(CAP_IPC_LOCK))
 			return -ENOMEM;
diff -puN mm/page_alloc.c~mm-remove-usages-of-access_once mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-usages-of-access_once
+++ a/mm/page_alloc.c
@@ -1378,7 +1378,7 @@ void drain_zone_pages(struct zone *zone,
 	int to_drain, batch;
 
 	local_irq_save(flags);
-	batch = ACCESS_ONCE(pcp->batch);
+	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
 		free_pcppages_bulk(zone, to_drain, pcp);
@@ -1577,7 +1577,7 @@ void free_hot_cold_page(struct page *pag
 		list_add_tail(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
-		unsigned long batch = ACCESS_ONCE(pcp->batch);
+		unsigned long batch = READ_ONCE(pcp->batch);
 		free_pcppages_bulk(zone, batch, pcp);
 		pcp->count -= batch;
 	}
@@ -6214,7 +6214,7 @@ void set_pfnblock_flags_mask(struct page
 	mask <<= (BITS_PER_LONG - bitidx - 1);
 	flags <<= (BITS_PER_LONG - bitidx - 1);
 
-	word = ACCESS_ONCE(bitmap[word_bitidx]);
+	word = READ_ONCE(bitmap[word_bitidx]);
 	for (;;) {
 		old_word = cmpxchg(&bitmap[word_bitidx], word, (word & ~mask) | flags);
 		if (word == old_word)
diff -puN mm/rmap.c~mm-remove-usages-of-access_once mm/rmap.c
--- a/mm/rmap.c~mm-remove-usages-of-access_once
+++ a/mm/rmap.c
@@ -456,7 +456,7 @@ struct anon_vma *page_get_anon_vma(struc
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
+	anon_mapping = (unsigned long)READ_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
 	if (!page_mapped(page))
@@ -500,14 +500,14 @@ struct anon_vma *page_lock_anon_vma_read
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
+	anon_mapping = (unsigned long)READ_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
 	if (!page_mapped(page))
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	root_anon_vma = ACCESS_ONCE(anon_vma->root);
+	root_anon_vma = READ_ONCE(anon_vma->root);
 	if (down_read_trylock(&root_anon_vma->rwsem)) {
 		/*
 		 * If the page is still mapped, then this anon_vma is still
diff -puN mm/slub.c~mm-remove-usages-of-access_once mm/slub.c
--- a/mm/slub.c~mm-remove-usages-of-access_once
+++ a/mm/slub.c
@@ -4279,7 +4279,7 @@ static ssize_t show_slab_objects(struct
 			int node;
 			struct page *page;
 
-			page = ACCESS_ONCE(c->page);
+			page = READ_ONCE(c->page);
 			if (!page)
 				continue;
 
@@ -4294,7 +4294,7 @@ static ssize_t show_slab_objects(struct
 			total += x;
 			nodes[node] += x;
 
-			page = ACCESS_ONCE(c->partial);
+			page = READ_ONCE(c->partial);
 			if (page) {
 				node = page_to_nid(page);
 				if (flags & SO_TOTAL)
diff -puN mm/swap_state.c~mm-remove-usages-of-access_once mm/swap_state.c
--- a/mm/swap_state.c~mm-remove-usages-of-access_once
+++ a/mm/swap_state.c
@@ -390,7 +390,7 @@ static unsigned long swapin_nr_pages(uns
 	unsigned int pages, max_pages, last_ra;
 	static atomic_t last_readahead_pages;
 
-	max_pages = 1 << ACCESS_ONCE(page_cluster);
+	max_pages = 1 << READ_ONCE(page_cluster);
 	if (max_pages <= 1)
 		return 1;
 
diff -puN mm/swapfile.c~mm-remove-usages-of-access_once mm/swapfile.c
--- a/mm/swapfile.c~mm-remove-usages-of-access_once
+++ a/mm/swapfile.c
@@ -1312,7 +1312,7 @@ static unsigned int find_next_to_unuse(s
 			else
 				continue;
 		}
-		count = ACCESS_ONCE(si->swap_map[i]);
+		count = READ_ONCE(si->swap_map[i]);
 		if (count && swap_count(count) != SWAP_MAP_BAD)
 			break;
 	}
_

Patches currently in -mm which might be from jason.low2@hp.com are

linux-next.patch

