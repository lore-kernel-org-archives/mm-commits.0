From: akpm@linux-foundation.org
Subject: + mm-deactivate-invalidated-pages.patch added to -mm tree
Date: Wed, 23 Feb 2011 15:46:45 -0800
Message-ID: <201102232346.p1NNkjpd030721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab1BWXsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 18:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, bgamari.foss@gmail.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com


The patch titled
     mm: deactivate invalidated pages
has been added to the -mm tree.  Its filename is
     mm-deactivate-invalidated-pages.patch

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
Subject: mm: deactivate invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>

Recently, there are reported problem about thrashing. 
(http://marc.info/?l=rsync&m=128885034930933&w=2) It happens by backup
workloads(ex, nightly rsync).  That's because the workload makes just
use-once pages and touches pages twice.  It promotes the page into active
list so that it results in working set page eviction.

Some app developer want to support POSIX_FADV_NOREUSE.  But other OSes
don't support it, either. 
(http://marc.info/?l=linux-mm&m=128928979512086&w=2)

By other approach, app developers use POSIX_FADV_DONTNEED.  But it has a
problem.  If kernel meets page is writing during invalidate_mapping_pages,
it can't work.  It makes for application programmer to use it since they
always have to sync data before calling fadivse(..POSIX_FADV_DONTNEED) to
make sure the pages could be discardable.  At last, they can't use
deferred write of kernel so that they could see performance loss. 
(http://insights.oetiker.ch/linux/fadvise.html)

In fact, invalidation is very big hint to reclaimer.  It means we don't
use the page any more.  So let's move the writing page into inactive
list's head if we can't truncate it right now.

Why I move page to head of lru on this patch, Dirty/Writeback page would
be flushed sooner or later.  It can prevent writeout of pageout which is
less effective than flusher's writeout.

Originally, I reused lru_demote of Peter with some change so added his
Signed-off-by.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: Ben Gamari <bgamari.foss@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swap.c            |   78 +++++++++++++++++++++++++++++++++++++++++
 mm/truncate.c        |   17 ++++++--
 3 files changed, 91 insertions(+), 5 deletions(-)

diff -puN include/linux/swap.h~mm-deactivate-invalidated-pages include/linux/swap.h
--- a/include/linux/swap.h~mm-deactivate-invalidated-pages
+++ a/include/linux/swap.h
@@ -215,6 +215,7 @@ extern void mark_page_accessed(struct pa
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
+extern void deactivate_page(struct page *page);
 extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
diff -puN mm/swap.c~mm-deactivate-invalidated-pages mm/swap.c
--- a/mm/swap.c~mm-deactivate-invalidated-pages
+++ a/mm/swap.c
@@ -39,6 +39,7 @@ int page_cluster;
 
 static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -347,6 +348,60 @@ void add_page_to_unevictable_list(struct
 }
 
 /*
+ * If the page can not be invalidated, it is moved to the
+ * inactive list to speed up its reclaim.  It is moved to the
+ * head of the list, rather than the tail, to give the flusher
+ * threads some time to write it out, as this is much more
+ * effective than the single-page writeout from reclaim.
+ */
+static void lru_deactivate(struct page *page, struct zone *zone)
+{
+	int lru, file;
+
+	if (!PageLRU(page) || !PageActive(page))
+		return;
+
+	/* Some processes are using the page */
+	if (page_mapped(page))
+		return;
+
+	file = page_is_file_cache(page);
+	lru = page_lru_base_type(page);
+	del_page_from_lru_list(zone, page, lru + LRU_ACTIVE);
+	ClearPageActive(page);
+	ClearPageReferenced(page);
+	add_page_to_lru_list(zone, page, lru);
+	__count_vm_event(PGDEACTIVATE);
+
+	update_page_reclaim_stat(zone, page, file, 0);
+}
+
+static void ____pagevec_lru_deactivate(struct pagevec *pvec)
+{
+	int i;
+	struct zone *zone = NULL;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock_irq(&zone->lru_lock);
+		}
+		lru_deactivate(page, zone);
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
+
+/*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
  * disabled; or "cpu" is being hot-unplugged, and is already dead.
@@ -372,6 +427,29 @@ static void drain_cpu_pagevecs(int cpu)
 		pagevec_move_tail(pvec);
 		local_irq_restore(flags);
 	}
+
+	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
+	if (pagevec_count(pvec))
+		____pagevec_lru_deactivate(pvec);
+}
+
+/**
+ * deactivate_page - forcefully deactivate a page
+ * @page: page to deactivate
+ *
+ * This function hints the VM that @page is a good reclaim candidate,
+ * for example if its invalidation fails due to the page being dirty
+ * or under writeback.
+ */
+void deactivate_page(struct page *page)
+{
+	if (likely(get_page_unless_zero(page))) {
+		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
+
+		if (!pagevec_add(pvec, page))
+			____pagevec_lru_deactivate(pvec);
+		put_cpu_var(lru_deactivate_pvecs);
+	}
 }
 
 void lru_add_drain(void)
diff -puN mm/truncate.c~mm-deactivate-invalidated-pages mm/truncate.c
--- a/mm/truncate.c~mm-deactivate-invalidated-pages
+++ a/mm/truncate.c
@@ -327,11 +327,12 @@ EXPORT_SYMBOL(truncate_inode_pages);
  * pagetables.
  */
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
-				       pgoff_t start, pgoff_t end)
+		pgoff_t start, pgoff_t end)
 {
 	struct pagevec pvec;
 	pgoff_t next = start;
-	unsigned long ret = 0;
+	unsigned long ret;
+	unsigned long count = 0;
 	int i;
 
 	pagevec_init(&pvec, 0);
@@ -358,9 +359,15 @@ unsigned long invalidate_mapping_pages(s
 			if (lock_failed)
 				continue;
 
-			ret += invalidate_inode_page(page);
-
+			ret = invalidate_inode_page(page);
 			unlock_page(page);
+			/*
+			 * Invalidation is a hint that the page is no longer
+			 * of interest and try to speed up its reclaim.
+			 */
+			if (!ret)
+				deactivate_page(page);
+			count += ret;
 			if (next > end)
 				break;
 		}
@@ -368,7 +375,7 @@ unsigned long invalidate_mapping_pages(s
 		mem_cgroup_uncharge_end();
 		cond_resched();
 	}
-	return ret;
+	return count;
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
mm-grab-rcu-read-lock-in-move_pages.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch
mm-fix-dubious-code-in-__count_immobile_pages.patch
mm-vmap-area-cache.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch

