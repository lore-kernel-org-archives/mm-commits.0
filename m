From: akpm@linux-foundation.org
Subject: + shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch added to -mm tree
Date: Mon, 14 Jul 2008 14:34:22 -0700
Message-ID: <200807142134.m6ELYMwN028637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbYGNVew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 17:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     shm_locked-pages-are-unevictable: revert shm change of shm_locked pages are unevictable patch
has been added to the -mm tree.  Its filename is
     shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch

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
Subject: shm_locked-pages-are-unevictable: revert shm change of shm_locked pages are unevictable patch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

shm_locked-pages-are-unevictable.patch changed several shmem code because
that putback_lru_page() had needed page lock.

It has little performance degression and isn't necessary now.  So,
reverting is better.

Fixup to handle changes to putback_lru_page() change.  Add retry to loop
check_move_unevictable_page().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ++++-----
 ipc/shm.c          |   16 ++--------------
 mm/shmem.c         |   10 +++++-----
 mm/vmscan.c        |   19 +++++--------------
 4 files changed, 16 insertions(+), 38 deletions(-)

diff -puN include/linux/mm.h~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch include/linux/mm.h
--- a/include/linux/mm.h~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch
+++ a/include/linux/mm.h
@@ -705,13 +705,12 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-extern struct address_space *shmem_lock(struct file *file, int lock,
-					struct user_struct *user);
+extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
-static inline struct address_space *shmem_lock(struct file *file, int lock,
-					struct user_struct *user)
+static inline int shmem_lock(struct file *file, int lock,
+			    struct user_struct *user)
 {
-	return NULL;
+	return 0;
 }
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
diff -puN ipc/shm.c~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch ipc/shm.c
--- a/ipc/shm.c~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch
+++ a/ipc/shm.c
@@ -737,7 +737,6 @@ asmlinkage long sys_shmctl(int shmid, in
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
-		struct address_space *mapping = NULL;
 		struct file *uninitialized_var(shm_file);
 
 		lru_add_drain_all();  /* drain pagevecs to lru lists */
@@ -769,29 +768,18 @@ asmlinkage long sys_shmctl(int shmid, in
 		if(cmd==SHM_LOCK) {
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
-				mapping = shmem_lock(shp->shm_file, 1, user);
-				if (IS_ERR(mapping))
-					err = PTR_ERR(mapping);
-				mapping = NULL;
+				err = shmem_lock(shp->shm_file, 1, user);
 				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}
 			}
 		} else if (!is_file_hugepages(shp->shm_file)) {
-			mapping = shmem_lock(shp->shm_file, 0, shp->mlock_user);
+			shmem_lock(shp->shm_file, 0, shp->mlock_user);
 			shp->shm_perm.mode &= ~SHM_LOCKED;
 			shp->mlock_user = NULL;
-			if (mapping) {
-				shm_file = shp->shm_file;
-				get_file(shm_file);	/* hold across unlock */
-			}
 		}
 		shm_unlock(shp);
-		if (mapping) {
-			scan_mapping_unevictable_pages(mapping);
-			fput(shm_file);
-		}
 		goto out;
 	}
 	case IPC_RMID:
diff -puN mm/shmem.c~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch mm/shmem.c
--- a/mm/shmem.c~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch
+++ a/mm/shmem.c
@@ -1468,12 +1468,11 @@ static struct mempolicy *shmem_get_polic
 }
 #endif
 
-struct address_space *shmem_lock(struct file *file, int lock,
-				 struct user_struct *user)
+int shmem_lock(struct file *file, int lock, struct user_struct *user)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct address_space *retval = ERR_PTR(-ENOMEM);
+	int retval = -ENOMEM;
 
 	spin_lock(&info->lock);
 	if (lock && !(info->flags & VM_LOCKED)) {
@@ -1481,14 +1480,15 @@ struct address_space *shmem_lock(struct 
 			goto out_nomem;
 		info->flags |= VM_LOCKED;
 		mapping_set_unevictable(file->f_mapping);
-		retval = NULL;
 	}
 	if (!lock && (info->flags & VM_LOCKED) && user) {
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
 		mapping_clear_unevictable(file->f_mapping);
-		retval = file->f_mapping;
+		scan_mapping_unevictable_pages(file->f_mapping);
 	}
+	retval = 0;
+
 out_nomem:
 	spin_unlock(&info->lock);
 	return retval;
diff -puN mm/vmscan.c~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch mm/vmscan.c
--- a/mm/vmscan.c~shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch
+++ a/mm/vmscan.c
@@ -2391,8 +2391,10 @@ int page_evictable(struct page *page, st
  */
 static void check_move_unevictable_page(struct page *page, struct zone *zone)
 {
+	VM_BUG_ON(PageActive(page));
 
-	ClearPageUnevictable(page); /* for page_evictable() */
+retry:
+	ClearPageUnevictable(page);
 	if (page_evictable(page, NULL)) {
 		enum lru_list l = LRU_INACTIVE_ANON + page_is_file_cache(page);
 		__dec_zone_state(zone, NR_UNEVICTABLE);
@@ -2404,6 +2406,8 @@ static void check_move_unevictable_page(
 		 */
 		SetPageUnevictable(page);
 		list_move(&page->lru, &zone->lru[LRU_UNEVICTABLE].list);
+		if (page_evictable(page, NULL))
+			goto retry;
 	}
 }
 
@@ -2441,16 +2445,6 @@ void scan_mapping_unevictable_pages(stru
 				next = page_index;
 			next++;
 
-			if (TestSetPageLocked(page)) {
-				/*
-				 * OK, let's do it the hard way...
-				 */
-				if (zone)
-					spin_unlock_irq(&zone->lru_lock);
-				zone = NULL;
-				lock_page(page);
-			}
-
 			if (pagezone != zone) {
 				if (zone)
 					spin_unlock_irq(&zone->lru_lock);
@@ -2460,9 +2454,6 @@ void scan_mapping_unevictable_pages(stru
 
 			if (PageLRU(page) && PageUnevictable(page))
 				check_move_unevictable_page(page, zone);
-
-			unlock_page(page);
-
 		}
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscam-kill-unused-lru-functions.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

