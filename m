From: akpm@linux-foundation.org
Subject: + mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
 added to -mm tree
Date: Thu, 17 Dec 2015 13:59:55 -0800
Message-ID: <5673305b.H+lEanpifhYIX0Jx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbLQV74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 16:59:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free swap cache aggressively if memcg swap is full
has been added to the -mm tree.  Its filename is
     mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -553,6 +553,7 @@ extern void mem_cgroup_swapout(struct pa
 extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
 extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+extern bool mem_cgroup_swap_full(struct page *page);
 #else
 static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
@@ -572,6 +573,11 @@ static inline long mem_cgroup_get_nr_swa
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
@@ -5746,6 +5746,28 @@ long mem_cgroup_get_nr_swap_pages(struct
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
@@ -2584,7 +2584,8 @@ int do_swap_page(struct mm_struct *mm, s
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

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

