From: akpm@linux-foundation.org
Subject: - unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:53:34 -0700
Message-ID: <200807282353.m6SNrYMP002624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbYG1XyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     unevictable-lru-infrastructure: revert migration change of unevictable lru infrastructure
has been removed from the -mm tree.  Its filename was
     unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable-lru-infrastructure: revert migration change of unevictable lru infrastructure
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Unevictable LRU Infrastructure patch changed several migration code
because Old version putback_lru_page() had needed to page lock.

It has little performance regression and isn't necessary now.  So,
reverting is better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff -puN mm/migrate.c~unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure mm/migrate.c
--- a/mm/migrate.c~unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure
+++ a/mm/migrate.c
@@ -67,11 +67,7 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
-		get_page(page);
-		lock_page(page);
 		putback_lru_page(page);
-		unlock_page(page);
-		put_page(page);
 		count++;
 	}
 	return count;
@@ -566,8 +562,6 @@ static int move_to_new_page(struct page 
 	struct address_space *mapping;
 	int rc;
 
-	get_page(newpage); /* for prevent page release under lock_page() */
-
 	/*
 	 * Block others from accessing the page when we get around to
 	 * establishing additional references. We are the only one
@@ -600,12 +594,10 @@ static int move_to_new_page(struct page 
 
 	if (!rc) {
 		remove_migration_ptes(page, newpage);
-		putback_lru_page(newpage);
 	} else
 		newpage->mapping = NULL;
 
 	unlock_page(newpage);
-	put_page(newpage);
 
 	return rc;
 }
@@ -628,16 +620,13 @@ static int unmap_and_move(new_page_t get
 
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
-		get_page(page);
-		goto end_migration;
+		goto move_newpage;
 	}
 
-	get_page(page);
-
 	charge = mem_cgroup_prepare_migration(page, newpage);
 	if (charge == -ENOMEM) {
 		rc = -ENOMEM;
-		goto end_migration;
+		goto move_newpage;
 	}
 	/* prepare cgroup just returns 0 or -ENOMEM */
 	BUG_ON(charge);
@@ -645,7 +634,7 @@ static int unmap_and_move(new_page_t get
 	rc = -EAGAIN;
 	if (TestSetPageLocked(page)) {
 		if (!force)
-			goto end_migration;
+			goto move_newpage;
 		lock_page(page);
 	}
 
@@ -706,6 +695,7 @@ rcu_unlock:
 		rcu_read_unlock();
 
 unlock:
+	unlock_page(page);
 
 	if (rc != -EAGAIN) {
  		/*
@@ -718,22 +708,16 @@ unlock:
 		putback_lru_page(page);
 	}
 
-	unlock_page(page);
-
-end_migration:
-	put_page(page);
-
+move_newpage:
 	if (!charge)
 		mem_cgroup_end_migration(newpage);
 
-	if (!newpage->mapping) {
-		/*
-		 * Migration failed or was never attempted.
-		 * Free the newpage.
-		 */
-		VM_BUG_ON(page_count(newpage) != 1);
-		put_page(newpage);
-	}
+	/*
+	 * Move the new page to the LRU. If migration was not successful
+	 * then this will free the page.
+	 */
+	putback_lru_page(newpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
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
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

