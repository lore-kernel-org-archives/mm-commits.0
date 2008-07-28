From: akpm@linux-foundation.org
Subject: - unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:53:26 -0700
Message-ID: <200807282353.m6SNrQOf002620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbYG1Xx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     unevictable-lru-infrastructure: kill unnecessary lock_page() in vmscan.c
has been removed from the -mm tree.  Its filename was
     unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable-lru-infrastructure: kill unnecessary lock_page() in vmscan.c
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Old version putback_lru_page need() page lock held.  but current one
doesn't.

So, several lock_page() can be removeed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff -puN mm/vmscan.c~unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc
+++ a/mm/vmscan.c
@@ -545,22 +545,6 @@ void putback_lru_page(struct page *page)
 
 
 /*
- * Cull page that shrink_*_list() has detected to be unevictable
- * under page lock to close races with other tasks that might be making
- * the page evictable.  Avoid stranding an evictable page on the
- * unevictable list.
- */
-static void cull_unevictable_page(struct page *page)
-{
-	get_page(page);
-	lock_page(page);
-	putback_lru_page(page);
-	unlock_page(page);
-	put_page(page);
-}
-
-
-/*
  * shrink_page_list() returns the number of reclaimed pages
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
@@ -1119,7 +1103,7 @@ static unsigned long shrink_inactive_lis
 			list_del(&page->lru);
 			if (unlikely(!page_evictable(page, NULL))) {
 				spin_unlock_irq(&zone->lru_lock);
-				cull_unevictable_page(page);
+				putback_lru_page(page);
 				spin_lock_irq(&zone->lru_lock);
 				continue;
 			}
@@ -1223,7 +1207,7 @@ static void shrink_active_list(unsigned 
 		list_del(&page->lru);
 
 		if (unlikely(!page_evictable(page, NULL))) {
-			cull_unevictable_page(page);
+			putback_lru_page(page);
 			continue;
 		}
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
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

