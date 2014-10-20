From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
 added to -mm tree
Date: Mon, 20 Oct 2014 14:59:55 -0700
Message-ID: <544585db.8K4zq7ITBcdEPDQM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaJTV7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove unnecessary PCG_MEMSW memory+swap charge flag
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch

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
Subject: mm: memcontrol: remove unnecessary PCG_MEMSW memory+swap charge flag

Now that mem_cgroup_swapout() fully uncharges the page, every page that is
still in use when reaching mem_cgroup_uncharge() is known to carry both
the memory and the memory+swap charge.  Simplify the uncharge path and
remove the PCG_MEMSW page flag accordingly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
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
@@ -2606,7 +2606,7 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED | PCG_MEM | (do_swap_account ? PCG_MEMSW : 0);
+	pc->flags = PCG_USED | PCG_MEM;
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
@@ -5785,7 +5785,6 @@ void mem_cgroup_swapout(struct page *pag
 	if (!PageCgroupUsed(pc))
 		return;
 
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEMSW), page);
 	memcg = pc->mem_cgroup;
 
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
@@ -5980,17 +5979,16 @@ void mem_cgroup_cancel_charge(struct pag
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
 
@@ -5999,23 +5997,21 @@ static void uncharge_batch(struct mem_cg
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
 
@@ -6042,10 +6038,9 @@ static void uncharge_list(struct list_he
 
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
@@ -6061,18 +6056,14 @@ static void uncharge_list(struct list_he
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
@@ -6157,7 +6148,6 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
-	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
debugging-keep-track-of-page-owners.patch

