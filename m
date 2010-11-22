From: akpm@linux-foundation.org
Subject: + mm-deactivate-invalidated-pages.patch added to -mm tree
Date: Mon, 22 Nov 2010 14:21:50 -0800
Message-ID: <201011222221.oAMMLoLQ012595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab0KVWWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 17:22:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, bgamari.foss@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com


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

By Other approach, app developer uses POSIX_FADV_DONTNEED.  But it has a
problem.  If kernel meets page is writing during invalidate_mapping_pages,
it can't work.  It is very hard for application programmer to use it. 
Because they always have to sync data before calling
fadivse(..POSIX_FADV_DONTNEED) to make sure the pages could be
discardable.  At last, they can't use deferred write of kernel so that
they could see performance loss. 
(http://insights.oetiker.ch/linux/fadvise.html)

In fact, invalidate is very big hint to reclaimer.  It means we don't use
the page any more.  So let's move the writing page into inactive list's
head.

If it is real working set, it could have a enough time to activate the
page since we always try to keep many pages in inactive list.

I reused Peter's lru_demote() with some changes.

Reported-by: Ben Gamari <bgamari.foss@gmail.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swap.c            |   61 +++++++++++++++++++++++++++++++++++++++++
 mm/truncate.c        |   11 ++++---
 3 files changed, 69 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-deactivate-invalidated-pages include/linux/swap.h
--- a/include/linux/swap.h~mm-deactivate-invalidated-pages
+++ a/include/linux/swap.h
@@ -213,6 +213,7 @@ extern void mark_page_accessed(struct pa
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
+extern void lru_deactive_page(struct page *page);
 extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
diff -puN mm/swap.c~mm-deactivate-invalidated-pages mm/swap.c
--- a/mm/swap.c~mm-deactivate-invalidated-pages
+++ a/mm/swap.c
@@ -39,6 +39,8 @@ int page_cluster;
 
 static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_deactive_pvecs);
+
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -266,6 +268,45 @@ void add_page_to_unevictable_list(struct
 	spin_unlock_irq(&zone->lru_lock);
 }
 
+static void __pagevec_lru_deactive(struct pagevec *pvec)
+{
+	int i, lru, file;
+
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
+
+		if (PageLRU(page)) {
+			if (PageActive(page)) {
+				file = page_is_file_cache(page);
+				lru = page_lru_base_type(page);
+				del_page_from_lru_list(zone, page,
+						lru + LRU_ACTIVE);
+				ClearPageActive(page);
+				ClearPageReferenced(page);
+				add_page_to_lru_list(zone, page, lru);
+				__count_vm_event(PGDEACTIVATE);
+
+				update_page_reclaim_stat(zone, page, file, 0);
+			}
+		}
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
@@ -292,8 +333,28 @@ static void drain_cpu_pagevecs(int cpu)
 		pagevec_move_tail(pvec);
 		local_irq_restore(flags);
 	}
+
+	pvec = &per_cpu(lru_deactive_pvecs, cpu);
+	if (pagevec_count(pvec))
+		__pagevec_lru_deactive(pvec);
 }
 
+/*
+ * Function used to forecefully demote a page to the head of the inactive
+ * list.
+ */
+void lru_deactive_page(struct page *page)
+{
+	if (likely(get_page_unless_zero(page))) {
+		struct pagevec *pvec = &get_cpu_var(lru_deactive_pvecs);
+
+		if (!pagevec_add(pvec, page))
+			__pagevec_lru_deactive(pvec);
+		put_cpu_var(lru_deactive_pvecs);
+	}
+}
+
+
 void lru_add_drain(void)
 {
 	drain_cpu_pagevecs(get_cpu());
diff -puN mm/truncate.c~mm-deactivate-invalidated-pages mm/truncate.c
--- a/mm/truncate.c~mm-deactivate-invalidated-pages
+++ a/mm/truncate.c
@@ -332,7 +332,8 @@ unsigned long invalidate_mapping_pages(s
 {
 	struct pagevec pvec;
 	pgoff_t next = start;
-	unsigned long ret = 0;
+	unsigned long ret;
+	unsigned long count = 0;
 	int i;
 
 	pagevec_init(&pvec, 0);
@@ -359,8 +360,10 @@ unsigned long invalidate_mapping_pages(s
 			if (lock_failed)
 				continue;
 
-			ret += invalidate_inode_page(page);
-
+			ret = invalidate_inode_page(page);
+			if (!ret)
+				lru_deactive_page(page);
+			count += ret;
 			unlock_page(page);
 			if (next > end)
 				break;
@@ -369,7 +372,7 @@ unsigned long invalidate_mapping_pages(s
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
mm-vmap-area-cache.patch
mm-find_get_pages_contig-fixlet.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-use-zalloc-rather-than-mallocmemset.patch
mm-prevent-promotion-of-page-in-madvise_dontneed-fix.patch

