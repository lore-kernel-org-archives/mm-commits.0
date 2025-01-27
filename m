Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB9E82866
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738019999; cv=none; b=MgNyA+XylyohUOM8reMZ9dz9oS1Ede6II4F7COlgFKJb9BSNzkELIY4aex9pIkx/DGVcYR294BPwaTb37Uu7vggu7w4UUesevCKADWWiE+WTjQLXxrAK9J4+0L4cgV2xQ7tA+sytq+JHO4L8AG64zslN7UP55Sb/rrgS+YWRTB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738019999; c=relaxed/simple;
	bh=eVmiwxvWnvUktEC7bdjNHQq4WqB9r5IdWjp0ZyDjWzc=;
	h=Date:To:From:Subject:Message-Id; b=AeId+EraNYSYLp31eBYjfYfJxB5lCQ0ciNnFBLkOwwiAk5g/H6mPcd8kqoZwXbn/0rBPniRvP8S6BCu6H2p/WQ+yJ85cuqSWskBI9wZNLI+asRJ+bcu6Kwacp8B5Y3pCAY+YZQ4Hj5caJ/JApX76VhEg9/vbH5Zj27rHIoJoYbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFhwMw0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFhwMw0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2ECC4CED2;
	Mon, 27 Jan 2025 23:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738019999;
	bh=eVmiwxvWnvUktEC7bdjNHQq4WqB9r5IdWjp0ZyDjWzc=;
	h=Date:To:From:Subject:From;
	b=iFhwMw0ZpXpQuiR3B20Nj+JNZLYKNjnzSMwM7loMeHcO5DUnOfxqmazBV58tirnCg
	 VZDTYRa/4/EUg6dpDotAYoF4jIziV8+q/4IBBW/mb2r23IJIHotEXDRFgFoC0Rmg5B
	 5AawQ/YIpleS/MfYDEMwmG1vg5jcBZkIpKk3SWFw=
Date: Mon, 27 Jan 2025 15:19:58 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch added to mm-unstable branch
Message-Id: <20250127231959.1B2ECC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: move memsw charge callbacks to v1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: move memsw charge callbacks to v1
Date: Fri, 24 Jan 2025 00:41:32 -0500

The interweaving of two entirely different swap accounting strategies has
been one of the more confusing parts of the memcg code.  Split out the v1
code to clarify the implementation and a handful of callsites, and to
avoid building the v1 bits when !CONFIG_MEMCG_V1.

   text	  data	   bss	   dec	   hex	filename
  39253	  6446	  4160	 49859	  c2c3	mm/memcontrol.o.old
  38877	  6382	  4160	 49419	  c10b	mm/memcontrol.o

Link: https://lkml.kernel.org/r/20250124054132.45643-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +++-
 include/linux/swap.h       |    5 -
 mm/huge_memory.c           |    2 
 mm/memcontrol-v1.c         |   89 ++++++++++++++++++++++++
 mm/memcontrol-v1.h         |    6 -
 mm/memcontrol.c            |  127 ++++-------------------------------
 mm/memory.c                |    2 
 mm/shmem.c                 |    2 
 mm/swap_state.c            |    2 
 mm/vmscan.c                |    2 
 10 files changed, 125 insertions(+), 129 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/include/linux/memcontrol.h
@@ -649,8 +649,6 @@ int mem_cgroup_charge_hugetlb(struct fol
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 
-void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
-
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -1165,10 +1163,6 @@ static inline int mem_cgroup_swapin_char
 	return 0;
 }
 
-static inline void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr)
-{
-}
-
 static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
@@ -1848,6 +1842,9 @@ static inline void mem_cgroup_exit_user_
 	current->in_user_fault = 0;
 }
 
+void memcg1_swapout(struct folio *folio, swp_entry_t entry);
+void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
+
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1875,6 +1872,14 @@ static inline void mem_cgroup_exit_user_
 {
 }
 
+static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
+{
+}
+
+static inline void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
+{
+}
+
 #endif /* CONFIG_MEMCG_V1 */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/include/linux/swap.h~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/include/linux/swap.h
@@ -659,7 +659,6 @@ static inline void folio_throttle_swapra
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
 int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 		swp_entry_t entry)
@@ -680,10 +679,6 @@ static inline void mem_cgroup_uncharge_s
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
-{
-}
-
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 					     swp_entry_t entry)
 {
--- a/mm/huge_memory.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/huge_memory.c
@@ -3740,7 +3740,7 @@ void deferred_split_folio(struct folio *
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
-	 * queue. Nowadays that is fully prevented by mem_cgroup_swapout();
+	 * queue. Nowadays that is fully prevented by memcg1_swapout();
 	 * but if page reclaim is already handling the same folio, it is
 	 * unnecessary to handle it again in the shrinker, so excluding
 	 * swapcache here may still be a useful optimization.
--- a/mm/memcontrol.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/memcontrol.c
@@ -3401,6 +3401,24 @@ static inline void mem_cgroup_id_put(str
 	mem_cgroup_id_put_many(memcg, 1);
 }
 
+struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
+{
+	while (!refcount_inc_not_zero(&memcg->id.ref)) {
+		/*
+		 * The root cgroup cannot be destroyed, so it's refcount must
+		 * always be >= 1.
+		 */
+		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
+			VM_BUG_ON(1);
+			break;
+		}
+		memcg = parent_mem_cgroup(memcg);
+		if (!memcg)
+			memcg = root_mem_cgroup;
+	}
+	return memcg;
+}
+
 /**
  * mem_cgroup_from_id - look up a memcg from a memcg id
  * @id: the memcg id to look up
@@ -4585,40 +4603,6 @@ int mem_cgroup_swapin_charge_folio(struc
 	return ret;
 }
 
-/*
- * mem_cgroup_swapin_uncharge_swap - uncharge swap slot
- * @entry: the first swap entry for which the pages are charged
- * @nr_pages: number of pages which will be uncharged
- *
- * Call this function after successfully adding the charged page to swapcache.
- *
- * Note: This function assumes the page for which swap slot is being uncharged
- * is order 0 page.
- */
-void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
-{
-	/*
-	 * Cgroup1's unified memory+swap counter has been charged with the
-	 * new swapcache page, finish the transfer by uncharging the swap
-	 * slot. The swap slot would also get uncharged when it dies, but
-	 * it can stick around indefinitely and we'd count the page twice
-	 * the entire time.
-	 *
-	 * Cgroup2 has separate resource counters for memory and swap,
-	 * so this is a non-issue here. Memory and swap charge lifetimes
-	 * correspond 1:1 to page and swap slot lifetimes: we charge the
-	 * page to memory here, and uncharge swap when the slot is freed.
-	 */
-	if (do_memsw_account()) {
-		/*
-		 * The swap entry might not get freed for a long time,
-		 * let's not wait for it.  The page already received a
-		 * memory+swap charge, drop the swap entry duplicate.
-		 */
-		mem_cgroup_uncharge_swap(entry, nr_pages);
-	}
-}
-
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
 	unsigned long nr_memory;
@@ -4944,81 +4928,6 @@ static int __init mem_cgroup_init(void)
 subsys_initcall(mem_cgroup_init);
 
 #ifdef CONFIG_SWAP
-static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
-{
-	while (!refcount_inc_not_zero(&memcg->id.ref)) {
-		/*
-		 * The root cgroup cannot be destroyed, so it's refcount must
-		 * always be >= 1.
-		 */
-		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
-			VM_BUG_ON(1);
-			break;
-		}
-		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
-	}
-	return memcg;
-}
-
-/**
- * mem_cgroup_swapout - transfer a memsw charge to swap
- * @folio: folio whose memsw charge to transfer
- * @entry: swap entry to move the charge to
- *
- * Transfer the memsw charge of @folio to @entry.
- */
-void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
-{
-	struct mem_cgroup *memcg, *swap_memcg;
-	unsigned int nr_entries;
-
-	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
-	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
-
-	if (mem_cgroup_disabled())
-		return;
-
-	if (!do_memsw_account())
-		return;
-
-	memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
-		return;
-
-	/*
-	 * In case the memcg owning these pages has been offlined and doesn't
-	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
-	 */
-	swap_memcg = mem_cgroup_id_get_online(memcg);
-	nr_entries = folio_nr_pages(folio);
-	/* Get references for the tail pages, too */
-	if (nr_entries > 1)
-		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
-	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
-
-	swap_cgroup_record(folio, entry);
-
-	folio_unqueue_deferred_split(folio);
-	folio->memcg_data = 0;
-
-	if (!mem_cgroup_is_root(memcg))
-		page_counter_uncharge(&memcg->memory, nr_entries);
-
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
-	}
-
-	memcg1_swapout(folio, memcg);
-	css_put(&memcg->css);
-}
-
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
--- a/mm/memcontrol-v1.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/memcontrol-v1.c
@@ -568,8 +568,59 @@ void memcg1_commit_charge(struct folio *
 	local_irq_restore(flags);
 }
 
-void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg)
+/**
+ * memcg1_swapout - transfer a memsw charge to swap
+ * @folio: folio whose memsw charge to transfer
+ * @entry: swap entry to move the charge to
+ *
+ * Transfer the memsw charge of @folio to @entry.
+ */
+void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 {
+	struct mem_cgroup *memcg, *swap_memcg;
+	unsigned int nr_entries;
+
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!do_memsw_account())
+		return;
+
+	memcg = folio_memcg(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
+	if (!memcg)
+		return;
+
+	/*
+	 * In case the memcg owning these pages has been offlined and doesn't
+	 * have an ID allocated to it anymore, charge the closest online
+	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 */
+	swap_memcg = mem_cgroup_id_get_online(memcg);
+	nr_entries = folio_nr_pages(folio);
+	/* Get references for the tail pages, too */
+	if (nr_entries > 1)
+		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
+	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
+
+	swap_cgroup_record(folio, entry);
+
+	folio_unqueue_deferred_split(folio);
+	folio->memcg_data = 0;
+
+	if (!mem_cgroup_is_root(memcg))
+		page_counter_uncharge(&memcg->memory, nr_entries);
+
+	if (memcg != swap_memcg) {
+		if (!mem_cgroup_is_root(swap_memcg))
+			page_counter_charge(&swap_memcg->memsw, nr_entries);
+		page_counter_uncharge(&memcg->memsw, nr_entries);
+	}
+
 	/*
 	 * Interrupts should be disabled here because the caller holds the
 	 * i_pages lock which is taken with interrupts-off. It is
@@ -581,6 +632,42 @@ void memcg1_swapout(struct folio *folio,
 	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
 	preempt_enable_nested();
 	memcg1_check_events(memcg, folio_nid(folio));
+
+	css_put(&memcg->css);
+}
+
+/*
+ * memcg1_swapin - uncharge swap slot
+ * @entry: the first swap entry for which the pages are charged
+ * @nr_pages: number of pages which will be uncharged
+ *
+ * Call this function after successfully adding the charged page to swapcache.
+ *
+ * Note: This function assumes the page for which swap slot is being uncharged
+ * is order 0 page.
+ */
+void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
+{
+	/*
+	 * Cgroup1's unified memory+swap counter has been charged with the
+	 * new swapcache page, finish the transfer by uncharging the swap
+	 * slot. The swap slot would also get uncharged when it dies, but
+	 * it can stick around indefinitely and we'd count the page twice
+	 * the entire time.
+	 *
+	 * Cgroup2 has separate resource counters for memory and swap,
+	 * so this is a non-issue here. Memory and swap charge lifetimes
+	 * correspond 1:1 to page and swap slot lifetimes: we charge the
+	 * page to memory here, and uncharge swap when the slot is freed.
+	 */
+	if (do_memsw_account()) {
+		/*
+		 * The swap entry might not get freed for a long time,
+		 * let's not wait for it.  The page already received a
+		 * memory+swap charge, drop the swap entry duplicate.
+		 */
+		mem_cgroup_uncharge_swap(entry, nr_pages);
+	}
 }
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
--- a/mm/memcontrol-v1.h~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/memcontrol-v1.h
@@ -63,6 +63,9 @@ unsigned long memcg_events(struct mem_cg
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
+void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
+struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -96,7 +99,6 @@ void memcg1_oom_finish(struct mem_cgroup
 void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
-void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg);
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid);
 
@@ -134,8 +136,6 @@ static inline void memcg1_oom_recover(st
 static inline void memcg1_commit_charge(struct folio *folio,
 					struct mem_cgroup *memcg) {}
 
-static inline void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg) {}
-
 static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
 					 unsigned long pgpgout,
 					 unsigned long nr_memory, int nid) {}
--- a/mm/memory.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/memory.c
@@ -4396,7 +4396,7 @@ vm_fault_t do_swap_page(struct vm_fault
 				}
 				need_clear_cache = true;
 
-				mem_cgroup_swapin_uncharge_swap(entry, nr_pages);
+				memcg1_swapin(entry, nr_pages);
 
 				shadow = get_shadow_from_swap_cache(entry);
 				if (shadow)
--- a/mm/shmem.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/shmem.c
@@ -2017,7 +2017,7 @@ static struct folio *shmem_swap_alloc_fo
 	__folio_set_swapbacked(new);
 	new->swap = entry;
 
-	mem_cgroup_swapin_uncharge_swap(entry, nr_pages);
+	memcg1_swapin(entry, nr_pages);
 	shadow = get_shadow_from_swap_cache(entry);
 	if (shadow)
 		workingset_refault(new, shadow);
--- a/mm/swap_state.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/swap_state.c
@@ -521,7 +521,7 @@ struct folio *__read_swap_cache_async(sw
 	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
-	mem_cgroup_swapin_uncharge_swap(entry, 1);
+	memcg1_swapin(entry, 1);
 
 	if (shadow)
 		workingset_refault(new_folio, shadow);
--- a/mm/vmscan.c~mm-memcontrol-move-memsw-charge-callbacks-to-v1
+++ a/mm/vmscan.c
@@ -769,7 +769,7 @@ static int __remove_mapping(struct addre
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
 		__delete_from_swap_cache(folio, swap, shadow);
-		mem_cgroup_swapout(folio, swap);
+		memcg1_swapout(folio, swap);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_folio(folio, swap);
 	} else {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch

