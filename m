From: akpm@linux-foundation.org
Subject: + mm-rotate_reclaimable_page-cleanup.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:52:03 -0700
Message-ID: <200803180452.m2I4q3PA014908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbYCREwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mm: rotate_reclaimable_page() cleanup
has been added to the -mm tree.  Its filename is
     mm-rotate_reclaimable_page-cleanup.patch

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

mm-rotate_reclaimable_page-cleanup.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
vfs-remove-lives_below_in_same_fs.patch
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
mm-bdi-export-bdi_writeout_inc.patch
mm-add-nr_writeback_temp-counter.patch
mm-allow-not-updating-bdi-stats-in-end_page_writeback.patch
fuse-support-writable-mmap.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

