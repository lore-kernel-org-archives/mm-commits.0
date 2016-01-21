From: akpm@linux-foundation.org
Subject: [merged]
 mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 15:30:01 -0800
Message-ID: <56a169f9.+ZZNubYRCVH+FpL+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUXaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free swap cache aggressively if memcg swap is full
has been removed from the -mm tree.  Its filename was
     mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: free swap cache aggressively if memcg swap is full

Swap cache pages are freed aggressively if swap is nearly full (>50%
currently), because otherwise we are likely to stop scanning anonymous
when we near the swap limit even if there is plenty of freeable swap cache
pages.  We should follow the same trend in case of memory cgroup, which
has its own swap limit.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memcontrol.c      |   22 ++++++++++++++++++++++
 mm/memory.c          |    3 ++-
 mm/swapfile.c        |    2 +-
 mm/vmscan.c          |    2 +-
 5 files changed, 32 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~mm-free-swap-cache-aggressively-if-memcg-swap-is-full include/linux/swap.h
--- a/include/linux/swap.h~mm-free-swap-cache-aggressively-if-memcg-swap-is-full
+++ a/include/linux/swap.h
@@ -552,6 +552,7 @@ extern void mem_cgroup_swapout(struct pa
 extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
 extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+extern bool mem_cgroup_swap_full(struct page *page);
 #else
 static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
@@ -571,6 +572,11 @@ static inline long mem_cgroup_get_nr_swa
 {
 	return get_nr_swap_pages();
 }
+
+static inline bool mem_cgroup_swap_full(struct page *page)
+{
+	return vm_swap_full();
+}
 #endif
 
 #endif /* __KERNEL__*/
diff -puN mm/memcontrol.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full mm/memcontrol.c
--- a/mm/memcontrol.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full
+++ a/mm/memcontrol.c
@@ -5761,6 +5761,28 @@ long mem_cgroup_get_nr_swap_pages(struct
 	return nr_swap_pages;
 }
 
+bool mem_cgroup_swap_full(struct page *page)
+{
+	struct mem_cgroup *memcg;
+
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+
+	if (vm_swap_full())
+		return true;
+	if (!do_swap_account || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return false;
+
+	memcg = page->mem_cgroup;
+	if (!memcg)
+		return false;
+
+	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
+		if (page_counter_read(&memcg->swap) * 2 >= memcg->swap.limit)
+			return true;
+
+	return false;
+}
+
 /* for remember boot option*/
 #ifdef CONFIG_MEMCG_SWAP_ENABLED
 static int really_do_swap_account __initdata = 1;
diff -puN mm/memory.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full mm/memory.c
--- a/mm/memory.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full
+++ a/mm/memory.c
@@ -2582,7 +2582,8 @@ static int do_swap_page(struct mm_struct
 	}
 
 	swap_free(entry);
-	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
+	if (mem_cgroup_swap_full(page) ||
+	    (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
 	if (page != swapcache) {
diff -puN mm/swapfile.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full mm/swapfile.c
--- a/mm/swapfile.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full
+++ a/mm/swapfile.c
@@ -1006,7 +1006,7 @@ int free_swap_and_cache(swp_entry_t entr
 		 * Also recheck PageSwapCache now page is locked (above).
 		 */
 		if (PageSwapCache(page) && !PageWriteback(page) &&
-				(!page_mapped(page) || vm_swap_full())) {
+		    (!page_mapped(page) || mem_cgroup_swap_full(page))) {
 			delete_from_swap_cache(page);
 			SetPageDirty(page);
 		}
diff -puN mm/vmscan.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full mm/vmscan.c
--- a/mm/vmscan.c~mm-free-swap-cache-aggressively-if-memcg-swap-is-full
+++ a/mm/vmscan.c
@@ -1214,7 +1214,7 @@ cull_mlocked:
 
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
-		if (PageSwapCache(page) && vm_swap_full())
+		if (PageSwapCache(page) && mem_cgroup_swap_full(page))
 			try_to_free_swap(page);
 		VM_BUG_ON_PAGE(PageActive(page), page);
 		SetPageActive(page);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


