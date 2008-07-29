From: akpm@linux-foundation.org
Subject: - mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:02:03 -0700
Message-ID: <200807290002.m6T024hR003010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbYG2ACN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mlock-mlocked-pages-are-unevictable: fix truncate race and sevaral comments
has been removed from the -mm tree.  Its filename was
     mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch

This patch was dropped because it was folded into mlock-mlocked-pages-are-unevictable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-mlocked-pages-are-unevictable: fix truncate race and sevaral comments
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This patch is part of putback_lru_page() rework.  several comment fix and
one bugfix contained.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/mlock.c~mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments mm/mlock.c
--- a/mm/mlock.c~mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments
+++ a/mm/mlock.c
@@ -54,7 +54,11 @@ EXPORT_SYMBOL(can_do_mlock);
  */
 void __clear_page_mlock(struct page *page)
 {
-	VM_BUG_ON(!PageLocked(page));	/* for LRU isolate/putback */
+	VM_BUG_ON(!PageLocked(page));
+
+	if (!page->mapping) {	/* truncated ? */
+		return;
+	}
 
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
@@ -138,7 +142,9 @@ static int __mlock_vma_pages_range(struc
 
 		/*
 		 * get_user_pages makes pages present if we are
-		 * setting mlock.
+		 * setting mlock. and this extra reference count will
+		 * disable migration of this page.  However, page may
+		 * still be truncated out from under us.
 		 */
 		ret = get_user_pages(current, mm, addr,
 				min_t(int, nr_pages, ARRAY_SIZE(pages)),
@@ -166,11 +172,12 @@ static int __mlock_vma_pages_range(struc
 		for (i = 0; i < ret; i++) {
 			struct page *page = pages[i];
 
+			lock_page(page);
 			/*
-			 * page might be truncated or migrated out from under
-			 * us.  Check after acquiring page lock.
+			 * Because we lock page here and migration is blocked
+			 * by the elevated reference, we need only check for
+			 * page truncation (file-cache only).
 			 */
-			lock_page(page);
 			if (page->mapping)
 				mlock_vma_page(page);
 			unlock_page(page);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
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

