From: akpm@linux-foundation.org
Subject: - shm_locked-pages-are-unevictable.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:59 -0700
Message-ID: <200810202032.m9KKWxWG010520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbYJTUjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     SHM_LOCKED pages are unevictable
has been removed from the -mm tree.  Its filename was
     shm_locked-pages-are-unevictable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SHM_LOCKED pages are unevictable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Shmem segments locked into memory via shmctl(SHM_LOCKED) should not be
kept on the normal LRU, since scanning them is a waste of time and might
throw off kswapd's balancing algorithms.  Place them on the unevictable
LRU list instead.

Use the AS_UNEVICTABLE flag to mark address_space of SHM_LOCKed shared
memory regions as unevictable.  Then these pages will be culled off the
normal LRU lists during vmscan.

Add new wrapper function to clear the mapping's unevictable state when/if
shared memory segment is munlocked.

Add 'scan_mapping_unevictable_page()' to mm/vmscan.c to scan all pages in
the shmem segment's mapping [struct address_space] for evictability now
that they're no longer locked.  If so, move them to the appropriate zone
lru list.

Changes depend on [CONFIG_]UNEVICTABLE_LRU.

[kosaki.motohiro@jp.fujitsu.com: revert shm change]
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    4 -
 include/linux/pagemap.h |   12 +++--
 include/linux/swap.h    |    4 +
 ipc/shm.c               |    4 +
 mm/shmem.c              |    4 +
 mm/vmscan.c             |   89 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 112 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~shm_locked-pages-are-unevictable include/linux/mm.h
--- a/include/linux/mm.h~shm_locked-pages-are-unevictable
+++ a/include/linux/mm.h
@@ -700,10 +700,10 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
 static inline int shmem_lock(struct file *file, int lock,
-			     struct user_struct *user)
+			    struct user_struct *user)
 {
 	return 0;
 }
diff -puN include/linux/pagemap.h~shm_locked-pages-are-unevictable include/linux/pagemap.h
--- a/include/linux/pagemap.h~shm_locked-pages-are-unevictable
+++ a/include/linux/pagemap.h
@@ -40,14 +40,20 @@ static inline void mapping_set_unevictab
 	set_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
+static inline void mapping_clear_unevictable(struct address_space *mapping)
+{
+	clear_bit(AS_UNEVICTABLE, &mapping->flags);
+}
+
 static inline int mapping_unevictable(struct address_space *mapping)
 {
-	if (mapping && (mapping->flags & AS_UNEVICTABLE))
-		return 1;
-	return 0;
+	if (likely(mapping))
+		return test_bit(AS_UNEVICTABLE, &mapping->flags);
+	return !!mapping;
 }
 #else
 static inline void mapping_set_unevictable(struct address_space *mapping) { }
+static inline void mapping_clear_unevictable(struct address_space *mapping) { }
 static inline int mapping_unevictable(struct address_space *mapping)
 {
 	return 0;
diff -puN include/linux/swap.h~shm_locked-pages-are-unevictable include/linux/swap.h
--- a/include/linux/swap.h~shm_locked-pages-are-unevictable
+++ a/include/linux/swap.h
@@ -232,12 +232,16 @@ static inline int zone_reclaim(struct zo
 
 #ifdef CONFIG_UNEVICTABLE_LRU
 extern int page_evictable(struct page *page, struct vm_area_struct *vma);
+extern void scan_mapping_unevictable_pages(struct address_space *);
 #else
 static inline int page_evictable(struct page *page,
 						struct vm_area_struct *vma)
 {
 	return 1;
 }
+static inline void scan_mapping_unevictable_pages(struct address_space *mapping)
+{
+}
 #endif
 
 extern int kswapd_run(int nid);
diff -puN ipc/shm.c~shm_locked-pages-are-unevictable ipc/shm.c
--- a/ipc/shm.c~shm_locked-pages-are-unevictable
+++ a/ipc/shm.c
@@ -737,6 +737,10 @@ asmlinkage long sys_shmctl(int shmid, in
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
+		struct file *uninitialized_var(shm_file);
+
+		lru_add_drain_all();  /* drain pagevecs to lru lists */
+
 		shp = shm_lock_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
diff -puN mm/shmem.c~shm_locked-pages-are-unevictable mm/shmem.c
--- a/mm/shmem.c~shm_locked-pages-are-unevictable
+++ a/mm/shmem.c
@@ -1477,12 +1477,16 @@ int shmem_lock(struct file *file, int lo
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
 		info->flags |= VM_LOCKED;
+		mapping_set_unevictable(file->f_mapping);
 	}
 	if (!lock && (info->flags & VM_LOCKED) && user) {
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
+		mapping_clear_unevictable(file->f_mapping);
+		scan_mapping_unevictable_pages(file->f_mapping);
 	}
 	retval = 0;
+
 out_nomem:
 	spin_unlock(&info->lock);
 	return retval;
diff -puN mm/vmscan.c~shm_locked-pages-are-unevictable mm/vmscan.c
--- a/mm/vmscan.c~shm_locked-pages-are-unevictable
+++ a/mm/vmscan.c
@@ -2346,4 +2346,93 @@ int page_evictable(struct page *page, st
 
 	return 1;
 }
+
+/**
+ * check_move_unevictable_page - check page for evictability and move to appropriate zone lru list
+ * @page: page to check evictability and move to appropriate lru list
+ * @zone: zone page is in
+ *
+ * Checks a page for evictability and moves the page to the appropriate
+ * zone lru list.
+ *
+ * Restrictions: zone->lru_lock must be held, page must be on LRU and must
+ * have PageUnevictable set.
+ */
+static void check_move_unevictable_page(struct page *page, struct zone *zone)
+{
+	VM_BUG_ON(PageActive(page));
+
+retry:
+	ClearPageUnevictable(page);
+	if (page_evictable(page, NULL)) {
+		enum lru_list l = LRU_INACTIVE_ANON + page_is_file_cache(page);
+		__dec_zone_state(zone, NR_UNEVICTABLE);
+		list_move(&page->lru, &zone->lru[l].list);
+		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(UNEVICTABLE_PGRESCUED);
+	} else {
+		/*
+		 * rotate unevictable list
+		 */
+		SetPageUnevictable(page);
+		list_move(&page->lru, &zone->lru[LRU_UNEVICTABLE].list);
+		if (page_evictable(page, NULL))
+			goto retry;
+	}
+}
+
+/**
+ * scan_mapping_unevictable_pages - scan an address space for evictable pages
+ * @mapping: struct address_space to scan for evictable pages
+ *
+ * Scan all pages in mapping.  Check unevictable pages for
+ * evictability and move them to the appropriate zone lru list.
+ */
+void scan_mapping_unevictable_pages(struct address_space *mapping)
+{
+	pgoff_t next = 0;
+	pgoff_t end   = (i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1) >>
+			 PAGE_CACHE_SHIFT;
+	struct zone *zone;
+	struct pagevec pvec;
+
+	if (mapping->nrpages == 0)
+		return;
+
+	pagevec_init(&pvec, 0);
+	while (next < end &&
+		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+		int i;
+		int pg_scanned = 0;
+
+		zone = NULL;
+
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+			pgoff_t page_index = page->index;
+			struct zone *pagezone = page_zone(page);
+
+			pg_scanned++;
+			if (page_index > next)
+				next = page_index;
+			next++;
+
+			if (pagezone != zone) {
+				if (zone)
+					spin_unlock_irq(&zone->lru_lock);
+				zone = pagezone;
+				spin_lock_irq(&zone->lru_lock);
+			}
+
+			if (PageLRU(page) && PageUnevictable(page))
+				check_move_unevictable_page(page, zone);
+		}
+		if (zone)
+			spin_unlock_irq(&zone->lru_lock);
+		pagevec_release(&pvec);
+
+		count_vm_events(UNEVICTABLE_PGSCANNED, pg_scanned);
+	}
+
+}
 #endif
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch

