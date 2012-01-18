From: akpm@linux-foundation.org
Subject: + shm_unlock-fix-unevictable-pages-stranded-after-swap.patch added to -mm tree
Date: Wed, 18 Jan 2012 14:40:21 -0800
Message-ID: <20120118224022.09BF1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62784 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2ARWkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 17:40:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, stable@vger.kernel.org, walken@google.com


The patch titled
     Subject: SHM_UNLOCK: fix Unevictable pages stranded after swap
has been added to the -mm tree.  Its filename is
     shm_unlock-fix-unevictable-pages-stranded-after-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: SHM_UNLOCK: fix Unevictable pages stranded after swap

Commit cc39c6a9bbde ("mm: account skipped entries to avoid looping in
find_get_pages") correctly fixed an infinite loop; but left a problem that
find_get_pages() on shmem would return 0 (appearing to callers to mean end
of tree) when it meets a run of nr_pages swap entries.

The only uses of find_get_pages() on shmem are via pagevec_lookup(),
called from invalidate_mapping_pages(), and from shmctl SHM_UNLOCK's
scan_mapping_unevictable_pages().  The first is already commented, and not
worth worrying about; but the second can leave pages on the Unevictable
list after an unusual sequence of swapping and locking.

Fix that by using shmem_find_get_pages_and_swap() (then ignoring the swap)
instead of pagevec_lookup().

But I don't want to contaminate vmscan.c with shmem internals, nor shmem.c
with LRU locking.  So move scan_mapping_unevictable_pages() into shmem.c,
renaming it shmem_unlock_mapping(); and rename
check_move_unevictable_page() to check_move_unevictable_pages(), looping
down an array of pages, oftentimes under the same lock.

Leave out the "rotate unevictable list" block: that's a leftover from when
this was used for /proc/sys/vm/scan_unevictable_pages, whose flawed
handling involved looking at pages at tail of LRU.

Was there significance to the sequence first ClearPageUnevictable, then
test page_evictable, then SetPageUnevictable here?  I think not, we're
under LRU lock, and have no barriers between those.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: <stable@vger.kernel.org> [back to 3.1 but will need respins]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 
 include/linux/swap.h     |    2 
 ipc/shm.c                |    2 
 mm/shmem.c               |   46 +++++++++++--
 mm/vmscan.c              |  128 +++++++++++--------------------------
 5 files changed, 83 insertions(+), 96 deletions(-)

diff -puN include/linux/shmem_fs.h~shm_unlock-fix-unevictable-pages-stranded-after-swap include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~shm_unlock-fix-unevictable-pages-stranded-after-swap
+++ a/include/linux/shmem_fs.h
@@ -48,6 +48,7 @@ extern struct file *shmem_file_setup(con
 					loff_t size, unsigned long flags);
 extern int shmem_zero_setup(struct vm_area_struct *);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern void shmem_unlock_mapping(struct address_space *mapping);
 extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
diff -puN include/linux/swap.h~shm_unlock-fix-unevictable-pages-stranded-after-swap include/linux/swap.h
--- a/include/linux/swap.h~shm_unlock-fix-unevictable-pages-stranded-after-swap
+++ a/include/linux/swap.h
@@ -273,7 +273,7 @@ static inline int zone_reclaim(struct zo
 #endif
 
 extern int page_evictable(struct page *page, struct vm_area_struct *vma);
-extern void scan_mapping_unevictable_pages(struct address_space *);
+extern void check_move_unevictable_pages(struct page **, int nr_pages);
 
 extern unsigned long scan_unevictable_pages;
 extern int scan_unevictable_handler(struct ctl_table *, int,
diff -puN ipc/shm.c~shm_unlock-fix-unevictable-pages-stranded-after-swap ipc/shm.c
--- a/ipc/shm.c~shm_unlock-fix-unevictable-pages-stranded-after-swap
+++ a/ipc/shm.c
@@ -916,7 +916,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 		shp->mlock_user = NULL;
 		get_file(shm_file);
 		shm_unlock(shp);
-		scan_mapping_unevictable_pages(shm_file->f_mapping);
+		shmem_unlock_mapping(shm_file->f_mapping);
 		fput(shm_file);
 		goto out;
 	}
diff -puN mm/shmem.c~shm_unlock-fix-unevictable-pages-stranded-after-swap mm/shmem.c
--- a/mm/shmem.c~shm_unlock-fix-unevictable-pages-stranded-after-swap
+++ a/mm/shmem.c
@@ -379,7 +379,7 @@ static int shmem_free_swap(struct addres
 /*
  * Pagevec may contain swap entries, so shuffle up pages before releasing.
  */
-static void shmem_pagevec_release(struct pagevec *pvec)
+static void shmem_deswap_pagevec(struct pagevec *pvec)
 {
 	int i, j;
 
@@ -389,7 +389,36 @@ static void shmem_pagevec_release(struct
 			pvec->pages[j++] = page;
 	}
 	pvec->nr = j;
-	pagevec_release(pvec);
+}
+
+/*
+ * SysV IPC SHM_UNLOCK restore Unevictable pages to their evictable lists.
+ */
+void shmem_unlock_mapping(struct address_space *mapping)
+{
+	struct pagevec pvec;
+	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t index = 0;
+
+	pagevec_init(&pvec, 0);
+	/*
+	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
+	 */
+	while (!mapping_unevictable(mapping)) {
+		/*
+		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
+		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
+		 */
+		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
+					PAGEVEC_SIZE, pvec.pages, indices);
+		if (!pvec.nr)
+			break;
+		index = indices[pvec.nr - 1] + 1;
+		shmem_deswap_pagevec(&pvec);
+		check_move_unevictable_pages(pvec.pages, pvec.nr);
+		pagevec_release(&pvec);
+		cond_resched();
+	}
 }
 
 /*
@@ -440,7 +469,8 @@ void shmem_truncate_range(struct inode *
 			}
 			unlock_page(page);
 		}
-		shmem_pagevec_release(&pvec);
+		shmem_deswap_pagevec(&pvec);
+		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
 		index++;
@@ -470,7 +500,8 @@ void shmem_truncate_range(struct inode *
 			continue;
 		}
 		if (index == start && indices[0] > end) {
-			shmem_pagevec_release(&pvec);
+			shmem_deswap_pagevec(&pvec);
+			pagevec_release(&pvec);
 			break;
 		}
 		mem_cgroup_uncharge_start();
@@ -494,7 +525,8 @@ void shmem_truncate_range(struct inode *
 			}
 			unlock_page(page);
 		}
-		shmem_pagevec_release(&pvec);
+		shmem_deswap_pagevec(&pvec);
+		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		index++;
 	}
@@ -2438,6 +2470,10 @@ int shmem_lock(struct file *file, int lo
 	return 0;
 }
 
+void shmem_unlock_mapping(struct address_space *mapping)
+{
+}
+
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 {
 	truncate_inode_pages_range(inode->i_mapping, lstart, lend);
diff -puN mm/vmscan.c~shm_unlock-fix-unevictable-pages-stranded-after-swap mm/vmscan.c
--- a/mm/vmscan.c~shm_unlock-fix-unevictable-pages-stranded-after-swap
+++ a/mm/vmscan.c
@@ -26,7 +26,6 @@
 #include <linux/buffer_head.h>	/* for try_to_release_page(),
 					buffer_heads_over_limit */
 #include <linux/mm_inline.h>
-#include <linux/pagevec.h>
 #include <linux/backing-dev.h>
 #include <linux/rmap.h>
 #include <linux/topology.h>
@@ -661,7 +660,7 @@ redo:
 		 * When racing with an mlock or AS_UNEVICTABLE clearing
 		 * (page is unlocked) make sure that if the other thread
 		 * does not observe our setting of PG_lru and fails
-		 * isolation/check_move_unevictable_page,
+		 * isolation/check_move_unevictable_pages,
 		 * we see PG_mlocked/AS_UNEVICTABLE cleared below and move
 		 * the page back to the evictable list.
 		 *
@@ -3501,107 +3500,58 @@ int page_evictable(struct page *page, st
 
 #ifdef CONFIG_SHMEM
 /**
- * check_move_unevictable_page - check page for evictability and move to appropriate zone lru list
- * @page: page to check evictability and move to appropriate lru list
- * @zone: zone page is in
+ * check_move_unevictable_pages - check pages for evictability and move to appropriate zone lru list
+ * @pages:	array of pages to check
+ * @nr_pages:	number of pages to check
  *
- * Checks a page for evictability and moves the page to the appropriate
- * zone lru list.
- *
- * Restrictions: zone->lru_lock must be held, page must be on LRU and must
- * have PageUnevictable set.
+ * Checks pages for evictability and moves them to the appropriate lru list.
  *
  * This function is only used for SysV IPC SHM_UNLOCK.
  */
-static void check_move_unevictable_page(struct page *page, struct zone *zone)
+void check_move_unevictable_pages(struct page **pages, int nr_pages)
 {
 	struct lruvec *lruvec;
+	struct zone *zone = NULL;
+	int pgscanned = 0;
+	int pgrescued = 0;
+	int i;
 
-	VM_BUG_ON(PageActive(page));
-retry:
-	ClearPageUnevictable(page);
-	if (page_evictable(page, NULL)) {
-		enum lru_list l = page_lru_base_type(page);
-
-		__dec_zone_state(zone, NR_UNEVICTABLE);
-		lruvec = mem_cgroup_lru_move_lists(zone, page,
-						   LRU_UNEVICTABLE, l);
-		list_move(&page->lru, &lruvec->lists[l]);
-		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
-		__count_vm_event(UNEVICTABLE_PGRESCUED);
-	} else {
-		/*
-		 * rotate unevictable list
-		 */
-		SetPageUnevictable(page);
-		lruvec = mem_cgroup_lru_move_lists(zone, page, LRU_UNEVICTABLE,
-						   LRU_UNEVICTABLE);
-		list_move(&page->lru, &lruvec->lists[LRU_UNEVICTABLE]);
-		if (page_evictable(page, NULL))
-			goto retry;
-	}
-}
-
-/**
- * scan_mapping_unevictable_pages - scan an address space for evictable pages
- * @mapping: struct address_space to scan for evictable pages
- *
- * Scan all pages in mapping.  Check unevictable pages for
- * evictability and move them to the appropriate zone lru list.
- *
- * This function is only used for SysV IPC SHM_UNLOCK.
- */
-void scan_mapping_unevictable_pages(struct address_space *mapping)
-{
-	pgoff_t next = 0;
-	pgoff_t end   = (i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1) >>
-			 PAGE_CACHE_SHIFT;
-	struct zone *zone;
-	struct pagevec pvec;
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pages[i];
+		struct zone *pagezone;
+
+		pgscanned++;
+		pagezone = page_zone(page);
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock_irq(&zone->lru_lock);
+		}
 
-	if (mapping->nrpages == 0)
-		return;
+		if (!PageLRU(page) || !PageUnevictable(page))
+			continue;
 
-	pagevec_init(&pvec, 0);
-	while (next < end &&
-		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
-		int i;
-		int pg_scanned = 0;
-
-		zone = NULL;
-
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
-			pgoff_t page_index = page->index;
-			struct zone *pagezone = page_zone(page);
-
-			pg_scanned++;
-			if (page_index > next)
-				next = page_index;
-			next++;
-
-			if (pagezone != zone) {
-				if (zone)
-					spin_unlock_irq(&zone->lru_lock);
-				zone = pagezone;
-				spin_lock_irq(&zone->lru_lock);
-			}
+		if (page_evictable(page, NULL)) {
+			enum lru_list lru = page_lru_base_type(page);
 
-			if (PageLRU(page) && PageUnevictable(page))
-				check_move_unevictable_page(page, zone);
+			VM_BUG_ON(PageActive(page));
+			ClearPageUnevictable(page);
+			__dec_zone_state(zone, NR_UNEVICTABLE);
+			lruvec = mem_cgroup_lru_move_lists(zone, page,
+						LRU_UNEVICTABLE, lru);
+			list_move(&page->lru, &lruvec->lists[lru]);
+			__inc_zone_state(zone, NR_INACTIVE_ANON + lru);
+			pgrescued++;
 		}
-		if (zone)
-			spin_unlock_irq(&zone->lru_lock);
-		pagevec_release(&pvec);
+	}
 
-		count_vm_events(UNEVICTABLE_PGSCANNED, pg_scanned);
-		cond_resched();
+	if (zone) {
+		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
+		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
+		spin_unlock_irq(&zone->lru_lock);
 	}
 }
-#else
-void scan_mapping_unevictable_pages(struct address_space *mapping)
-{
-}
 #endif /* CONFIG_SHMEM */
 
 static void warn_scan_unevictable_pages(void)
_
Subject: Subject: SHM_UNLOCK: fix Unevictable pages stranded after swap

Patches currently in -mm which might be from hughd@google.com are

origin.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
shm_unlock-fix-long-unpreemptible-section.patch
shm_unlock-fix-unevictable-pages-stranded-after-swap.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
prio_tree-debugging-patch.patch

