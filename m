From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:03 -0800
Message-ID: <5489e8ff.MIlctAskRDhGZ8I/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbaLKS5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove unnecessary PCG_MEMSW memory+swap charge flag
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove unnecessary PCG_MEMSW memory+swap charge flag

Now that mem_cgroup_swapout() fully uncharges the page, every page that is
still in use when reaching mem_cgroup_uncharge() is known to carry both
the memory and the memory+swap charge.  Simplify the uncharge path and
remove the PCG_MEMSW page flag accordingly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    1 -
 mm/memcontrol.c             |   34 ++++++++++++----------------------
 2 files changed, 12 insertions(+), 23 deletions(-)

diff -puN include/linux/page_cgroup.h~mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag
+++ a/include/linux/page_cgroup.h
@@ -5,7 +5,6 @@ enum {
 	/* flags for mem_cgroup */
 	PCG_USED = 0x01,	/* This page is charged to a memcg */
 	PCG_MEM = 0x02,		/* This page holds a memory charge */
-	PCG_MEMSW = 0x04,	/* This page holds a memory+swap charge */
 };
 
 struct pglist_data;
diff -puN mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag
+++ a/mm/memcontrol.c
@@ -2614,7 +2614,7 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED | PCG_MEM | (do_swap_account ? PCG_MEMSW : 0);
+	pc->flags = PCG_USED | PCG_MEM;
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
@@ -5793,7 +5793,6 @@ void mem_cgroup_swapout(struct page *pag
 	if (!PageCgroupUsed(pc))
 		return;
 
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEMSW), page);
 	memcg = pc->mem_cgroup;
 
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
@@ -5989,17 +5988,16 @@ void mem_cgroup_cancel_charge(struct pag
 }
 
 static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_mem, unsigned long nr_memsw,
 			   unsigned long nr_anon, unsigned long nr_file,
 			   unsigned long nr_huge, struct page *dummy_page)
 {
+	unsigned long nr_pages = nr_anon + nr_file;
 	unsigned long flags;
 
 	if (!mem_cgroup_is_root(memcg)) {
-		if (nr_mem)
-			page_counter_uncharge(&memcg->memory, nr_mem);
-		if (nr_memsw)
-			page_counter_uncharge(&memcg->memsw, nr_memsw);
+		page_counter_uncharge(&memcg->memory, nr_pages);
+		if (do_swap_account)
+			page_counter_uncharge(&memcg->memsw, nr_pages);
 		memcg_oom_recover(memcg);
 	}
 
@@ -6008,23 +6006,21 @@ static void uncharge_batch(struct mem_cg
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_CACHE], nr_file);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE], nr_huge);
 	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT], pgpgout);
-	__this_cpu_add(memcg->stat->nr_page_events, nr_anon + nr_file);
+	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
 	memcg_check_events(memcg, dummy_page);
 	local_irq_restore(flags);
 
 	if (!mem_cgroup_is_root(memcg))
-		css_put_many(&memcg->css, max(nr_mem, nr_memsw));
+		css_put_many(&memcg->css, nr_pages);
 }
 
 static void uncharge_list(struct list_head *page_list)
 {
 	struct mem_cgroup *memcg = NULL;
-	unsigned long nr_memsw = 0;
 	unsigned long nr_anon = 0;
 	unsigned long nr_file = 0;
 	unsigned long nr_huge = 0;
 	unsigned long pgpgout = 0;
-	unsigned long nr_mem = 0;
 	struct list_head *next;
 	struct page *page;
 
@@ -6051,10 +6047,9 @@ static void uncharge_list(struct list_he
 
 		if (memcg != pc->mem_cgroup) {
 			if (memcg) {
-				uncharge_batch(memcg, pgpgout, nr_mem, nr_memsw,
-					       nr_anon, nr_file, nr_huge, page);
-				pgpgout = nr_mem = nr_memsw = 0;
-				nr_anon = nr_file = nr_huge = 0;
+				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
+					       nr_huge, page);
+				pgpgout = nr_anon = nr_file = nr_huge = 0;
 			}
 			memcg = pc->mem_cgroup;
 		}
@@ -6070,18 +6065,14 @@ static void uncharge_list(struct list_he
 		else
 			nr_file += nr_pages;
 
-		if (pc->flags & PCG_MEM)
-			nr_mem += nr_pages;
-		if (pc->flags & PCG_MEMSW)
-			nr_memsw += nr_pages;
 		pc->flags = 0;
 
 		pgpgout++;
 	} while (next != page_list);
 
 	if (memcg)
-		uncharge_batch(memcg, pgpgout, nr_mem, nr_memsw,
-			       nr_anon, nr_file, nr_huge, page);
+		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
+			       nr_huge, page);
 }
 
 /**
@@ -6166,7 +6157,6 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
-	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

