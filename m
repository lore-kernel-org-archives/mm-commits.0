From: akpm@linux-foundation.org
Subject: [merged] shm_unlock-fix-long-unpreemptible-section.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:51 -0800
Message-ID: <20120123202152.5291A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:50949 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2AWUV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:56 -0500
Received: by faaa19 with SMTP id a19so124250faa.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: SHM_UNLOCK: fix long unpreemptible section
has been removed from the -mm tree.  Its filename was
     shm_unlock-fix-long-unpreemptible-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: SHM_UNLOCK: fix long unpreemptible section

scan_mapping_unevictable_pages() is used to make SysV SHM_LOCKed pages
evictable again once the shared memory is unlocked.  It does this with
pagevec_lookup()s across the whole object (which might occupy most of
memory), and takes 300ms to unlock 7GB here.  A cond_resched() every
PAGEVEC_SIZE pages would be good.

However, KOSAKI-san points out that this is called under shmem.c's
info->lock, and it's also under shm.c's shm_lock(), both spinlocks.  There
is no strong reason for that: we need to take these pages off the
unevictable list soonish, but those locks are not required for it.

So move the call to scan_mapping_unevictable_pages() from shmem.c's unlock
handling up to shm.c's unlock handling.  Remove the recently added
barrier, not needed now we have spin_unlock() before the scan.

Use get_file(), with subsequent fput(), to make sure we have a reference
to mapping throughout scan_mapping_unevictable_pages(): that's something
that was previously guaranteed by the shm_lock().

Remove shmctl's lru_add_drain_all(): we don't fault in pages at SHM_LOCK
time, and we lazily discover them to be Unevictable later, so it serves no
purpose for SHM_LOCK; and serves no purpose for SHM_UNLOCK, since pages
still on pagevec are not marked Unevictable.

The original code avoided redundant rescans by checking VM_LOCKED flag at
its level: now avoid them by checking shp's SHM_LOCKED.

The original code called scan_mapping_unevictable_pages() on a locked area
at shm_destroy() time: perhaps we once had accounting cross-checks which
required that, but not now, so skip the overhead and just let inode
eviction deal with them.

Put check_move_unevictable_page() and scan_mapping_unevictable_pages()
under CONFIG_SHMEM (with stub for the TINY case when ramfs is used), more
as comment than to save space; comment them used for SHM_UNLOCK.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c   |   37 ++++++++++++++++++++++---------------
 mm/shmem.c  |    7 -------
 mm/vmscan.c |   12 +++++++++++-
 3 files changed, 33 insertions(+), 23 deletions(-)

diff -puN ipc/shm.c~shm_unlock-fix-long-unpreemptible-section ipc/shm.c
--- a/ipc/shm.c~shm_unlock-fix-long-unpreemptible-section
+++ a/ipc/shm.c
@@ -870,9 +870,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
-		struct file *uninitialized_var(shm_file);
-
-		lru_add_drain_all();  /* drain pagevecs to lru lists */
+		struct file *shm_file;
 
 		shp = shm_lock_check(ns, shmid);
 		if (IS_ERR(shp)) {
@@ -895,22 +893,31 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
 			goto out_unlock;
-		
-		if(cmd==SHM_LOCK) {
+
+		shm_file = shp->shm_file;
+		if (is_file_hugepages(shm_file))
+			goto out_unlock;
+
+		if (cmd == SHM_LOCK) {
 			struct user_struct *user = current_user();
-			if (!is_file_hugepages(shp->shm_file)) {
-				err = shmem_lock(shp->shm_file, 1, user);
-				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
-					shp->shm_perm.mode |= SHM_LOCKED;
-					shp->mlock_user = user;
-				}
+			err = shmem_lock(shm_file, 1, user);
+			if (!err && !(shp->shm_perm.mode & SHM_LOCKED)) {
+				shp->shm_perm.mode |= SHM_LOCKED;
+				shp->mlock_user = user;
 			}
-		} else if (!is_file_hugepages(shp->shm_file)) {
-			shmem_lock(shp->shm_file, 0, shp->mlock_user);
-			shp->shm_perm.mode &= ~SHM_LOCKED;
-			shp->mlock_user = NULL;
+			goto out_unlock;
 		}
+
+		/* SHM_UNLOCK */
+		if (!(shp->shm_perm.mode & SHM_LOCKED))
+			goto out_unlock;
+		shmem_lock(shm_file, 0, shp->mlock_user);
+		shp->shm_perm.mode &= ~SHM_LOCKED;
+		shp->mlock_user = NULL;
+		get_file(shm_file);
 		shm_unlock(shp);
+		scan_mapping_unevictable_pages(shm_file->f_mapping);
+		fput(shm_file);
 		goto out;
 	}
 	case IPC_RMID:
diff -puN mm/shmem.c~shm_unlock-fix-long-unpreemptible-section mm/shmem.c
--- a/mm/shmem.c~shm_unlock-fix-long-unpreemptible-section
+++ a/mm/shmem.c
@@ -1068,13 +1068,6 @@ int shmem_lock(struct file *file, int lo
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
 		mapping_clear_unevictable(file->f_mapping);
-		/*
-		 * Ensure that a racing putback_lru_page() can see
-		 * the pages of this mapping are evictable when we
-		 * skip them due to !PageLRU during the scan.
-		 */
-		smp_mb__after_clear_bit();
-		scan_mapping_unevictable_pages(file->f_mapping);
 	}
 	retval = 0;
 
diff -puN mm/vmscan.c~shm_unlock-fix-long-unpreemptible-section mm/vmscan.c
--- a/mm/vmscan.c~shm_unlock-fix-long-unpreemptible-section
+++ a/mm/vmscan.c
@@ -3499,6 +3499,7 @@ int page_evictable(struct page *page, st
 	return 1;
 }
 
+#ifdef CONFIG_SHMEM
 /**
  * check_move_unevictable_page - check page for evictability and move to appropriate zone lru list
  * @page: page to check evictability and move to appropriate lru list
@@ -3509,6 +3510,8 @@ int page_evictable(struct page *page, st
  *
  * Restrictions: zone->lru_lock must be held, page must be on LRU and must
  * have PageUnevictable set.
+ *
+ * This function is only used for SysV IPC SHM_UNLOCK.
  */
 static void check_move_unevictable_page(struct page *page, struct zone *zone)
 {
@@ -3545,6 +3548,8 @@ retry:
  *
  * Scan all pages in mapping.  Check unevictable pages for
  * evictability and move them to the appropriate zone lru list.
+ *
+ * This function is only used for SysV IPC SHM_UNLOCK.
  */
 void scan_mapping_unevictable_pages(struct address_space *mapping)
 {
@@ -3590,9 +3595,14 @@ void scan_mapping_unevictable_pages(stru
 		pagevec_release(&pvec);
 
 		count_vm_events(UNEVICTABLE_PGSCANNED, pg_scanned);
+		cond_resched();
 	}
-
 }
+#else
+void scan_mapping_unevictable_pages(struct address_space *mapping)
+{
+}
+#endif /* CONFIG_SHMEM */
 
 static void warn_scan_unevictable_pages(void)
 {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-add-rss-counters-consistency-check.patch
mm-postpone-migrated-page-mapping-reset.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
prio_tree-debugging-patch.patch

