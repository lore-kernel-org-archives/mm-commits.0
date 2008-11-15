From: akpm@linux-foundation.org
Subject: + memcg-handle-swap-caches.patch added to -mm tree
Date: Fri, 14 Nov 2008 17:06:30 -0800
Message-ID: <200811150106.mAF16UQt006547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYKOBGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 20:06:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     memcg: handle swap caches
has been added to the -mm tree.  Its filename is
     memcg-handle-swap-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: handle swap caches
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

SwapCache support for memory resource controller (memcg)

Before mem+swap controller, memcg itself should handle SwapCache in proper
way.  This is cut-out from it.

In current memcg, SwapCache is just leaked and the user can create tons of
SwapCache.  This is a leak of account and should be handled.

SwapCache accounting is done as following.

  charge (anon)
	- charged when it's mapped.
	  (because of readahead, charge at add_to_swap_cache() is not sane)
  uncharge (anon)
	- uncharged when it's dropped from swapcache and fully unmapped.
	  means it's not uncharged at unmap.
	  Note: delete from swap cache at swap-in is done after rmap information
	        is established.
  charge (shmem)
	- charged at swap-in. this prevents charge at add_to_page_cache().

  uncharge (shmem)
	- uncharged when it's dropped from swapcache and not on shmem's
	  radix-tree.

  at migration, check against 'old page' is modified to handle shmem.

Comparing to the old version discussed (and caused troubles), we have
advantages of
  - PCG_USED bit.
  - simple migrating handling.

So, situation is much easier than several months ago, maybe.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |    5 +
 include/linux/swap.h                 |   16 +++++
 mm/memcontrol.c                      |   67 ++++++++++++++++++++++---
 mm/shmem.c                           |   18 +++++-
 mm/swap_state.c                      |    1 
 5 files changed, 99 insertions(+), 8 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-handle-swap-caches Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-handle-swap-caches
+++ a/Documentation/controllers/memory.txt
@@ -137,6 +137,11 @@ behind this approach is that a cgroup th
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
+Exception: When you do swapoff and make swapped-out pages of shmem(tmpfs) to
+be backed into memory in force, charges for pages are accounted against the
+caller of swapoff rather than the users of shmem.
+
+
 2.4 Reclaim
 
 Each cgroup maintains a per cgroup LRU that consists of an active
diff -puN include/linux/swap.h~memcg-handle-swap-caches include/linux/swap.h
--- a/include/linux/swap.h~memcg-handle-swap-caches
+++ a/include/linux/swap.h
@@ -335,6 +335,22 @@ static inline void disable_swap_token(vo
 	put_swap_token(swap_token_mm);
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+extern int mem_cgroup_cache_charge_swapin(struct page *page,
+				struct mm_struct *mm, gfp_t mask, bool locked);
+extern void mem_cgroup_uncharge_swapcache(struct page *page);
+#else
+static inline
+int mem_cgroup_cache_charge_swapin(struct page *page,
+				struct mm_struct *mm, gfp_t mask, bool locked)
+{
+	return 0;
+}
+static inline void mem_cgroup_uncharge_swapcache(struct page *page)
+{
+}
+#endif
+
 #else /* CONFIG_SWAP */
 
 #define total_swap_pages			0
diff -puN mm/memcontrol.c~memcg-handle-swap-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-handle-swap-caches
+++ a/mm/memcontrol.c
@@ -21,6 +21,7 @@
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
 #include <linux/backing-dev.h>
@@ -139,6 +140,7 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
 	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
+	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
 	NR_CHARGE_TYPE,
 };
 
@@ -780,6 +782,33 @@ int mem_cgroup_cache_charge(struct page 
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
 }
 
+#ifdef CONFIG_SWAP
+int mem_cgroup_cache_charge_swapin(struct page *page,
+			struct mm_struct *mm, gfp_t mask, bool locked)
+{
+	int ret = 0;
+
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+	if (unlikely(!mm))
+		mm = &init_mm;
+	if (!locked)
+		lock_page(page);
+	/*
+	 * If not locked, the page can be dropped from SwapCache until
+	 * we reach here.
+	 */
+	if (PageSwapCache(page)) {
+		ret = mem_cgroup_charge_common(page, mm, mask,
+				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
+	}
+	if (!locked)
+		unlock_page(page);
+
+	return ret;
+}
+#endif
+
 void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 {
 	struct page_cgroup *pc;
@@ -817,6 +846,9 @@ __mem_cgroup_uncharge_common(struct page
 	if (mem_cgroup_subsys.disabled)
 		return;
 
+	if (PageSwapCache(page))
+		return;
+
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -825,12 +857,26 @@ __mem_cgroup_uncharge_common(struct page
 		return;
 
 	lock_page_cgroup(pc);
-	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED && page_mapped(page))
-	     || !PageCgroupUsed(pc)) {
-		/* This happens at race in zap_pte_range() and do_swap_page()*/
-		unlock_page_cgroup(pc);
-		return;
+
+	if (!PageCgroupUsed(pc))
+		goto unlock_out;
+
+	switch (ctype) {
+	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		if (page_mapped(page))
+			goto unlock_out;
+		break;
+	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
+		if (!PageAnon(page)) {	/* Shared memory */
+			if (page->mapping && !page_is_file_cache(page))
+				goto unlock_out;
+		} else if (page_mapped(page)) /* Anon */
+				goto unlock_out;
+		break;
+	default:
+		break;
 	}
+
 	ClearPageCgroupUsed(pc);
 	mem = pc->mem_cgroup;
 
@@ -844,6 +890,10 @@ __mem_cgroup_uncharge_common(struct page
 	css_put(&mem->css);
 
 	return;
+
+unlock_out:
+	unlock_page_cgroup(pc);
+	return;
 }
 
 void mem_cgroup_uncharge_page(struct page *page)
@@ -863,6 +913,11 @@ void mem_cgroup_uncharge_cache_page(stru
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
 
+void mem_cgroup_uncharge_swapcache(struct page *page)
+{
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
+}
+
 /*
  * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
  * page belongs to.
@@ -920,7 +975,7 @@ void mem_cgroup_end_migration(struct mem
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
 	/* unused page is not on radix-tree now. */
-	if (unused && ctype != MEM_CGROUP_CHARGE_TYPE_MAPPED)
+	if (unused)
 		__mem_cgroup_uncharge_common(unused, ctype);
 
 	pc = lookup_page_cgroup(target);
diff -puN mm/shmem.c~memcg-handle-swap-caches mm/shmem.c
--- a/mm/shmem.c~memcg-handle-swap-caches
+++ a/mm/shmem.c
@@ -920,8 +920,12 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	/* Charge page using GFP_HIGHUSER_MOVABLE while we can wait */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_HIGHUSER_MOVABLE);
+	/*
+	 * Charge page using GFP_HIGHUSER_MOVABLE while we can wait.
+	 * charged back to the user(not to caller) when swap account is used.
+	 */
+	error = mem_cgroup_cache_charge_swapin(page,
+			current->mm, GFP_HIGHUSER_MOVABLE, true);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1258,6 +1262,16 @@ repeat:
 				goto repeat;
 			}
 			wait_on_page_locked(swappage);
+			/*
+			 * We want to avoid charge at add_to_page_cache().
+			 * charge against this swap cache here.
+			 */
+			if (mem_cgroup_cache_charge_swapin(swappage,
+						current->mm, gfp, false)) {
+				page_cache_release(swappage);
+				error = -ENOMEM;
+				goto failed;
+			}
 			page_cache_release(swappage);
 			goto repeat;
 		}
diff -puN mm/swap_state.c~memcg-handle-swap-caches mm/swap_state.c
--- a/mm/swap_state.c~memcg-handle-swap-caches
+++ a/mm/swap_state.c
@@ -119,6 +119,7 @@ void __delete_from_swap_cache(struct pag
 	total_swapcache_pages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
+	mem_cgroup_uncharge_swapcache(page);
 }
 
 /**
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
migration-fix-writepage-error.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-memory-hotplug-fix-for-notifier-callback.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-swap-cgroup-for-remembering-usage-fix.patch
memcg-memswap-controller-core.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch

