From: akpm@linux-foundation.org
Subject: - mm-rotate_reclaimable_page-cleanup.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:59 -0700
Message-ID: <200804282151.m3SLpxOT017632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965000AbYD1VwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: rotate_reclaimable_page() cleanup
has been removed from the -mm tree.  Its filename was
     mm-rotate_reclaimable_page-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rotate_reclaimable_page() cleanup
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up messy conditional calling of test_clear_page_writeback() from both
rotate_reclaimable_page() and end_page_writeback().

The only user of rotate_reclaimable_page() is end_page_writeback() so this is
OK.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/filemap.c         |   10 ++++++----
 mm/swap.c            |   37 ++++++++++++-------------------------
 3 files changed, 19 insertions(+), 30 deletions(-)

diff -puN include/linux/swap.h~mm-rotate_reclaimable_page-cleanup include/linux/swap.h
--- a/include/linux/swap.h~mm-rotate_reclaimable_page-cleanup
+++ a/include/linux/swap.h
@@ -177,7 +177,7 @@ extern void activate_page(struct page *)
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
-extern int rotate_reclaimable_page(struct page *page);
+extern void rotate_reclaimable_page(struct page *page);
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
diff -puN mm/filemap.c~mm-rotate_reclaimable_page-cleanup mm/filemap.c
--- a/mm/filemap.c~mm-rotate_reclaimable_page-cleanup
+++ a/mm/filemap.c
@@ -576,10 +576,12 @@ EXPORT_SYMBOL(unlock_page);
  */
 void end_page_writeback(struct page *page)
 {
-	if (!TestClearPageReclaim(page) || rotate_reclaimable_page(page)) {
-		if (!test_clear_page_writeback(page))
-			BUG();
-	}
+	if (TestClearPageReclaim(page))
+		rotate_reclaimable_page(page);
+
+	if (!test_clear_page_writeback(page))
+		BUG();
+
 	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_writeback);
 }
diff -puN mm/swap.c~mm-rotate_reclaimable_page-cleanup mm/swap.c
--- a/mm/swap.c~mm-rotate_reclaimable_page-cleanup
+++ a/mm/swap.c
@@ -132,34 +132,21 @@ static void pagevec_move_tail(struct pag
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
  * inactive list.
- *
- * Returns zero if it cleared PG_writeback.
  */
-int rotate_reclaimable_page(struct page *page)
+void  rotate_reclaimable_page(struct page *page)
 {
-	struct pagevec *pvec;
-	unsigned long flags;
-
-	if (PageLocked(page))
-		return 1;
-	if (PageDirty(page))
-		return 1;
-	if (PageActive(page))
-		return 1;
-	if (!PageLRU(page))
-		return 1;
-
-	page_cache_get(page);
-	local_irq_save(flags);
-	pvec = &__get_cpu_var(lru_rotate_pvecs);
-	if (!pagevec_add(pvec, page))
-		pagevec_move_tail(pvec);
-	local_irq_restore(flags);
-
-	if (!test_clear_page_writeback(page))
-		BUG();
+	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
+	    PageLRU(page)) {
+		struct pagevec *pvec;
+		unsigned long flags;
 
-	return 0;
+		page_cache_get(page);
+		local_irq_save(flags);
+		pvec = &__get_cpu_var(lru_rotate_pvecs);
+		if (!pagevec_add(pvec, page))
+			pagevec_move_tail(pvec);
+		local_irq_restore(flags);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-nfsd.patch
vfs-remove-lives_below_in_same_fs.patch
ecryptfs-add-missing-lock-around-notify_change.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

