From: akpm@linux-foundation.org
Subject: + vmscan-shm_locked-pages-are-non-reclaimable.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:41 -0700
Message-ID: <200806090618.m596IfOO006637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019AbYFIGTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: SHM_LOCKED pages are non-reclaimable
has been added to the -mm tree.  Its filename is
     vmscan-shm_locked-pages-are-non-reclaimable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: SHM_LOCKED pages are non-reclaimable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>


Against:  2.6.26-rc2-mm1

While working with Nick Piggin's mlock patches, I noticed that
shmem segments locked via shmctl(SHM_LOCKED) were not being handled.
SHM_LOCKed pages work like ramdisk pages--the writeback function
just redirties the page so that it can't be reclaimed.  Deal with
these using the same approach as for ram disk pages.

Use the AS_NORECLAIM flag to mark address_space of SHM_LOCKed
shared memory regions as non-reclaimable.  Then these pages
will be culled off the normal LRU lists during vmscan.

Add new wrapper function to clear the mapping's noreclaim state
when/if shared memory segment is munlocked.

Add 'scan_mapping_noreclaim_page()' to mm/vmscan.c to scan all
pages in the shmem segment's mapping [struct address_space] for
reclaimability now that they're no longer locked.  If so, move
them to the appropriate zone lru list.  Note that
scan_mapping_noreclaim_page() must be able to sleep on page_lock(),
so we can't call it holding the shmem info spinlock nor the shmid
spinlock.  So, we pass the mapping [address_space] back to shmctl()
on SHM_UNLOCK for rescuing any nonreclaimable pages after dropping
the spinlocks.  Once we drop the shmid lock, the backing shmem file
can be deleted if the calling task doesn't have the shm area
attached.  To handle this, we take an extra reference on the file
before dropping the shmid lock and drop the reference after scanning
the mapping's noreclaim pages.

Changes depend on [CONFIG_]NORECLAIM_LRU.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    9 ++-
 include/linux/pagemap.h |   12 +++-
 include/linux/swap.h    |    4 +
 ipc/shm.c               |   20 +++++++-
 mm/shmem.c              |   10 ++--
 mm/vmscan.c             |   93 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 136 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~shm_locked-pages-are-non-reclaimable include/linux/mm.h
--- a/include/linux/mm.h~shm_locked-pages-are-non-reclaimable
+++ a/include/linux/mm.h
@@ -702,12 +702,13 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern struct address_space *shmem_lock(struct file *file, int lock,
+					struct user_struct *user);
 #else
-static inline int shmem_lock(struct file *file, int lock,
-			     struct user_struct *user)
+static inline struct address_space *shmem_lock(struct file *file, int lock,
+					struct user_struct *user)
 {
-	return 0;
+	return NULL;
 }
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
diff -puN include/linux/pagemap.h~shm_locked-pages-are-non-reclaimable include/linux/pagemap.h
--- a/include/linux/pagemap.h~shm_locked-pages-are-non-reclaimable
+++ a/include/linux/pagemap.h
@@ -39,14 +39,20 @@ static inline void mapping_set_noreclaim
 	set_bit(AS_NORECLAIM, &mapping->flags);
 }
 
+static inline void mapping_clear_noreclaim(struct address_space *mapping)
+{
+	clear_bit(AS_NORECLAIM, &mapping->flags);
+}
+
 static inline int mapping_non_reclaimable(struct address_space *mapping)
 {
-	if (mapping && (mapping->flags & AS_NORECLAIM))
-		return 1;
-	return 0;
+	if (likely(mapping))
+		return test_bit(AS_NORECLAIM, &mapping->flags);
+	return !!mapping;
 }
 #else
 static inline void mapping_set_noreclaim(struct address_space *mapping) { }
+static inline void mapping_clear_noreclaim(struct address_space *mapping) { }
 static inline int mapping_non_reclaimable(struct address_space *mapping)
 {
 	return 0;
diff -puN include/linux/swap.h~shm_locked-pages-are-non-reclaimable include/linux/swap.h
--- a/include/linux/swap.h~shm_locked-pages-are-non-reclaimable
+++ a/include/linux/swap.h
@@ -232,12 +232,16 @@ static inline int zone_reclaim(struct zo
 
 #ifdef CONFIG_NORECLAIM_LRU
 extern int page_reclaimable(struct page *page, struct vm_area_struct *vma);
+extern void scan_mapping_noreclaim_pages(struct address_space *);
 #else
 static inline int page_reclaimable(struct page *page,
 						struct vm_area_struct *vma)
 {
 	return 1;
 }
+static inline void scan_mapping_noreclaim_pages(struct address_space *mapping)
+{
+}
 #endif
 
 extern int kswapd_run(int nid);
diff -puN ipc/shm.c~shm_locked-pages-are-non-reclaimable ipc/shm.c
--- a/ipc/shm.c~shm_locked-pages-are-non-reclaimable
+++ a/ipc/shm.c
@@ -736,6 +736,11 @@ asmlinkage long sys_shmctl(int shmid, in
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
+		struct address_space *mapping = NULL;
+		struct file *uninitialized_var(shm_file);
+
+		lru_add_drain_all();  /* drain pagevecs to lru lists */
+
 		shp = shm_lock_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
@@ -763,18 +768,29 @@ asmlinkage long sys_shmctl(int shmid, in
 		if(cmd==SHM_LOCK) {
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
-				err = shmem_lock(shp->shm_file, 1, user);
+				mapping = shmem_lock(shp->shm_file, 1, user);
+				if (IS_ERR(mapping))
+					err = PTR_ERR(mapping);
+				mapping = NULL;
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}
 			}
 		} else if (!is_file_hugepages(shp->shm_file)) {
-			shmem_lock(shp->shm_file, 0, shp->mlock_user);
+			mapping = shmem_lock(shp->shm_file, 0, shp->mlock_user);
 			shp->shm_perm.mode &= ~SHM_LOCKED;
 			shp->mlock_user = NULL;
+			if (mapping) {
+				shm_file = shp->shm_file;
+				get_file(shm_file);	/* hold across unlock */
+			}
 		}
 		shm_unlock(shp);
+		if (mapping) {
+			scan_mapping_noreclaim_pages(mapping);
+			fput(shm_file);
+		}
 		goto out;
 	}
 	case IPC_RMID:
diff -puN mm/shmem.c~shm_locked-pages-are-non-reclaimable mm/shmem.c
--- a/mm/shmem.c~shm_locked-pages-are-non-reclaimable
+++ a/mm/shmem.c
@@ -1473,23 +1473,27 @@ static struct mempolicy *shmem_get_polic
 }
 #endif
 
-int shmem_lock(struct file *file, int lock, struct user_struct *user)
+struct address_space *shmem_lock(struct file *file, int lock,
+				 struct user_struct *user)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	int retval = -ENOMEM;
+	struct address_space *retval = ERR_PTR(-ENOMEM);
 
 	spin_lock(&info->lock);
 	if (lock && !(info->flags & VM_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
 		info->flags |= VM_LOCKED;
+		mapping_set_noreclaim(file->f_mapping);
+		retval = NULL;
 	}
 	if (!lock && (info->flags & VM_LOCKED) && user) {
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
+		mapping_clear_noreclaim(file->f_mapping);
+		retval = file->f_mapping;
 	}
-	retval = 0;
 out_nomem:
 	spin_unlock(&info->lock);
 	return retval;
diff -puN mm/vmscan.c~shm_locked-pages-are-non-reclaimable mm/vmscan.c
--- a/mm/vmscan.c~shm_locked-pages-are-non-reclaimable
+++ a/mm/vmscan.c
@@ -2345,4 +2345,97 @@ int page_reclaimable(struct page *page, 
 
 	return 1;
 }
+
+/**
+ * check_move_noreclaim_page - check page for reclaimability and move to appropriate zone lru list
+ * @page: page to check reclaimability and move to appropriate lru list
+ * @zone: zone page is in
+ *
+ * Checks a page for reclaimability and moves the page to the appropriate
+ * zone lru list.
+ *
+ * Restrictions: zone->lru_lock must be held, page must be on LRU and must
+ * have PageNoreclaim set.
+ */
+static void check_move_noreclaim_page(struct page *page, struct zone *zone)
+{
+
+	ClearPageNoreclaim(page); /* for page_reclaimable() */
+	if (page_reclaimable(page, NULL)) {
+		enum lru_list l = LRU_INACTIVE_ANON + page_file_cache(page);
+		__dec_zone_state(zone, NR_NORECLAIM);
+		list_move(&page->lru, &zone->list[l]);
+		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+	} else {
+		/*
+		 * rotate noreclaim list
+		 */
+		SetPageNoreclaim(page);
+		list_move(&page->lru, &zone->list[LRU_NORECLAIM]);
+	}
+}
+
+/**
+ * scan_mapping_noreclaim_pages - scan an address space for reclaimable pages
+ * @mapping: struct address_space to scan for reclaimable pages
+ *
+ * Scan all pages in mapping.  Check non-reclaimable pages for
+ * reclaimability and move them to the appropriate zone lru list.
+ */
+void scan_mapping_noreclaim_pages(struct address_space *mapping)
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
+
+		zone = NULL;
+
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+			pgoff_t page_index = page->index;
+			struct zone *pagezone = page_zone(page);
+
+			if (page_index > next)
+				next = page_index;
+			next++;
+
+			if (TestSetPageLocked(page)) {
+				/*
+				 * OK, let's do it the hard way...
+				 */
+				if (zone)
+					spin_unlock_irq(&zone->lru_lock);
+				zone = NULL;
+				lock_page(page);
+			}
+
+			if (pagezone != zone) {
+				if (zone)
+					spin_unlock_irq(&zone->lru_lock);
+				zone = pagezone;
+				spin_lock_irq(&zone->lru_lock);
+			}
+
+			if (PageLRU(page) && PageNoreclaim(page))
+				check_move_noreclaim_page(page, zone);
+
+			unlock_page(page);
+
+		}
+		if (zone)
+			spin_unlock_irq(&zone->lru_lock);
+		pagevec_release(&pvec);
+	}
+
+}
 #endif
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-free-swap-space-on-swap-in-activation.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch

