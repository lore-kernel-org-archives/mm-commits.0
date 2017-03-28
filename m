From: akpm@linux-foundation.org
Subject: + mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch added to -mm tree
Date: Tue, 28 Mar 2017 15:14:07 -0700
Message-ID: <58dae02f.TULdmT5yMERKxLIk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44132 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755138AbdC1WOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 18:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: support to charge/uncharge multiple swap entries
has been added to the -mm tree.  Its filename is
     mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, memcg: support to charge/uncharge multiple swap entries

Make it possible to charge or uncharge a set of continuous swap entries in
the swap cgroup.  The number of swap entries is specified via an added
parameter.

This will be used for the THP (Transparent Huge Page) swap support.  Where
a swap cluster backing a THP may be allocated and freed as a whole.  So a
set of (HPAGE_PMD_NR) continuous swap entries backing one THP need to be
charged or uncharged together.  This will batch the cgroup operations for
the THP swap too.

Link: http://lkml.kernel.org/r/20170328053209.25876-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h        |   12 ++++---
 include/linux/swap_cgroup.h |    6 ++-
 mm/memcontrol.c             |   57 +++++++++++++++++++---------------
 mm/shmem.c                  |    2 -
 mm/swap_cgroup.c            |   40 +++++++++++++++++------
 mm/swap_state.c             |    2 -
 mm/swapfile.c               |    2 -
 7 files changed, 77 insertions(+), 44 deletions(-)

diff -puN include/linux/swap.h~mm-memcg-support-to-charge-uncharge-multiple-swap-entries include/linux/swap.h
--- a/include/linux/swap.h~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/include/linux/swap.h
@@ -550,8 +550,10 @@ static inline int mem_cgroup_swappiness(
 
 #ifdef CONFIG_MEMCG_SWAP
 extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
-extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
-extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
+extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry,
+				      unsigned int nr_entries);
+extern void mem_cgroup_uncharge_swap(swp_entry_t entry,
+				     unsigned int nr_entries);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct page *page);
 #else
@@ -560,12 +562,14 @@ static inline void mem_cgroup_swapout(st
 }
 
 static inline int mem_cgroup_try_charge_swap(struct page *page,
-					     swp_entry_t entry)
+					     swp_entry_t entry,
+					     unsigned int nr_entries)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
+static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
+					    unsigned int nr_entries)
 {
 }
 
diff -puN include/linux/swap_cgroup.h~mm-memcg-support-to-charge-uncharge-multiple-swap-entries include/linux/swap_cgroup.h
--- a/include/linux/swap_cgroup.h~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/include/linux/swap_cgroup.h
@@ -7,7 +7,8 @@
 
 extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new);
-extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
+extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
+					 unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
 extern void swap_cgroup_swapoff(int type);
@@ -15,7 +16,8 @@ extern void swap_cgroup_swapoff(int type
 #else
 
 static inline
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
+				  unsigned int nr_ents)
 {
 	return 0;
 }
diff -puN mm/memcontrol.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/mm/memcontrol.c
@@ -2393,10 +2393,9 @@ void mem_cgroup_split_huge_fixup(struct
 
 #ifdef CONFIG_MEMCG_SWAP
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
-					 bool charge)
+				       int nr_entries)
 {
-	int val = (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
+	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], nr_entries);
 }
 
 /**
@@ -2422,8 +2421,8 @@ static int mem_cgroup_move_swap_account(
 	new_id = mem_cgroup_id(to);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
-		mem_cgroup_swap_statistics(from, false);
-		mem_cgroup_swap_statistics(to, true);
+		mem_cgroup_swap_statistics(from, -1);
+		mem_cgroup_swap_statistics(to, 1);
 		return 0;
 	}
 	return -EINVAL;
@@ -5451,7 +5450,7 @@ void mem_cgroup_commit_charge(struct pag
 		 * let's not wait for it.  The page already received a
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
-		mem_cgroup_uncharge_swap(entry);
+		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
 }
 
@@ -5879,9 +5878,9 @@ void mem_cgroup_swapout(struct page *pag
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
 	swap_memcg = mem_cgroup_id_get_online(memcg);
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(swap_memcg));
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(swap_memcg), 1);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(swap_memcg, true);
+	mem_cgroup_swap_statistics(swap_memcg, 1);
 
 	page->mem_cgroup = NULL;
 
@@ -5908,16 +5907,19 @@ void mem_cgroup_swapout(struct page *pag
 		css_put(&memcg->css);
 }
 
-/*
- * mem_cgroup_try_charge_swap - try charging a swap entry
+/**
+ * mem_cgroup_try_charge_swap - try charging a set of swap entries
  * @page: page being added to swap
- * @entry: swap entry to charge
+ * @entry: the first swap entry to charge
+ * @nr_entries: the number of swap entries to charge
  *
- * Try to charge @entry to the memcg that @page belongs to.
+ * Try to charge @nr_entries swap entries starting from @entry to the
+ * memcg that @page belongs to.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
+int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry,
+			       unsigned int nr_entries)
 {
 	struct mem_cgroup *memcg;
 	struct page_counter *counter;
@@ -5935,25 +5937,29 @@ int mem_cgroup_try_charge_swap(struct pa
 	memcg = mem_cgroup_id_get_online(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, 1, &counter)) {
+	    !page_counter_try_charge(&memcg->swap, nr_entries, &counter)) {
 		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
 	}
 
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
+	if (nr_entries > 1)
+		mem_cgroup_id_get_many(memcg, nr_entries - 1);
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg), nr_entries);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(memcg, true);
+	mem_cgroup_swap_statistics(memcg, nr_entries);
 
 	return 0;
 }
 
 /**
- * mem_cgroup_uncharge_swap - uncharge a swap entry
- * @entry: swap entry to uncharge
+ * mem_cgroup_uncharge_swap - uncharge a set of swap entries
+ * @entry: the first swap entry to uncharge
+ * @nr_entries: the number of swap entries to uncharge
  *
- * Drop the swap charge associated with @entry.
+ * Drop the swap charge associated with @nr_entries swap entries
+ * starting from @entry.
  */
-void mem_cgroup_uncharge_swap(swp_entry_t entry)
+void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_entries)
 {
 	struct mem_cgroup *memcg;
 	unsigned short id;
@@ -5961,18 +5967,19 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	if (!do_swap_account)
 		return;
 
-	id = swap_cgroup_record(entry, 0);
+	id = swap_cgroup_record(entry, 0, nr_entries);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-				page_counter_uncharge(&memcg->swap, 1);
+				page_counter_uncharge(&memcg->swap, nr_entries);
 			else
-				page_counter_uncharge(&memcg->memsw, 1);
+				page_counter_uncharge(&memcg->memsw,
+						      nr_entries);
 		}
-		mem_cgroup_swap_statistics(memcg, false);
-		mem_cgroup_id_put(memcg);
+		mem_cgroup_swap_statistics(memcg, -nr_entries);
+		mem_cgroup_id_put_many(memcg, nr_entries);
 	}
 	rcu_read_unlock();
 }
diff -puN mm/shmem.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries mm/shmem.c
--- a/mm/shmem.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/mm/shmem.c
@@ -1294,7 +1294,7 @@ static int shmem_writepage(struct page *
 	if (!swap.val)
 		goto redirty;
 
-	if (mem_cgroup_try_charge_swap(page, swap))
+	if (mem_cgroup_try_charge_swap(page, swap, 1))
 		goto free_swap;
 
 	/*
diff -puN mm/swap_cgroup.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries mm/swap_cgroup.c
--- a/mm/swap_cgroup.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/mm/swap_cgroup.c
@@ -58,21 +58,27 @@ not_enough_page:
 	return -ENOMEM;
 }
 
+static struct swap_cgroup *__lookup_swap_cgroup(struct swap_cgroup_ctrl *ctrl,
+						pgoff_t offset)
+{
+	struct page *mappage;
+	struct swap_cgroup *sc;
+
+	mappage = ctrl->map[offset / SC_PER_PAGE];
+	sc = page_address(mappage);
+	return sc + offset % SC_PER_PAGE;
+}
+
 static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
 					struct swap_cgroup_ctrl **ctrlp)
 {
 	pgoff_t offset = swp_offset(ent);
 	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
-	struct swap_cgroup *sc;
 
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
 	if (ctrlp)
 		*ctrlp = ctrl;
-
-	mappage = ctrl->map[offset / SC_PER_PAGE];
-	sc = page_address(mappage);
-	return sc + offset % SC_PER_PAGE;
+	return __lookup_swap_cgroup(ctrl, offset);
 }
 
 /**
@@ -105,25 +111,39 @@ unsigned short swap_cgroup_cmpxchg(swp_e
 }
 
 /**
- * swap_cgroup_record - record mem_cgroup for this swp_entry.
- * @ent: swap entry to be recorded into
+ * swap_cgroup_record - record mem_cgroup for a set of swap entries
+ * @ent: the first swap entry to be recorded into
  * @id: mem_cgroup to be recorded
+ * @nr_ents: number of swap entries to be recorded
  *
  * Returns old value at success, 0 at failure.
  * (Of course, old value can be 0.)
  */
-unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
+				  unsigned int nr_ents)
 {
 	struct swap_cgroup_ctrl *ctrl;
 	struct swap_cgroup *sc;
 	unsigned short old;
 	unsigned long flags;
+	pgoff_t offset = swp_offset(ent);
+	pgoff_t end = offset + nr_ents;
 
 	sc = lookup_swap_cgroup(ent, &ctrl);
 
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old = sc->id;
-	sc->id = id;
+	for (;;) {
+		VM_BUG_ON(sc->id != old);
+		sc->id = id;
+		offset++;
+		if (offset == end)
+			break;
+		if (offset % SC_PER_PAGE)
+			sc++;
+		else
+			sc = __lookup_swap_cgroup(ctrl, offset);
+	}
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 
 	return old;
diff -puN mm/swap_state.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries mm/swap_state.c
--- a/mm/swap_state.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/mm/swap_state.c
@@ -182,7 +182,7 @@ int add_to_swap(struct page *page, struc
 	if (!entry.val)
 		return 0;
 
-	if (mem_cgroup_try_charge_swap(page, entry)) {
+	if (mem_cgroup_try_charge_swap(page, entry, 1)) {
 		swapcache_free(entry);
 		return 0;
 	}
diff -puN mm/swapfile.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries mm/swapfile.c
--- a/mm/swapfile.c~mm-memcg-support-to-charge-uncharge-multiple-swap-entries
+++ a/mm/swapfile.c
@@ -1012,7 +1012,7 @@ static void swap_entry_free(struct swap_
 	dec_cluster_info_page(p, p->cluster_info, offset);
 	unlock_cluster(ci);
 
-	mem_cgroup_uncharge_swap(entry);
+	mem_cgroup_uncharge_swap(entry, 1);
 	if (offset < p->lowest_bit)
 		p->lowest_bit = offset;
 	if (offset > p->highest_bit) {
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64.patch
mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch
mm-thp-swap-add-swap-cluster-allocate-free-functions.patch
mm-thp-swap-add-get_huge_swap_page.patch
mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch
mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
mm-thp-add-can_split_huge_page.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

