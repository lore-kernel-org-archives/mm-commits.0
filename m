From: akpm@linux-foundation.org
Subject: + mm-allow-not-updating-bdi-stats-in-end_page_writeback.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:08:52 -0700
Message-ID: <200803180508.m2I58q65015473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbYCRFJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mm: allow not updating BDI stats in end_page_writeback()
has been added to the -mm tree.  Its filename is
     mm-allow-not-updating-bdi-stats-in-end_page_writeback.patch

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
Subject: mm: allow not updating BDI stats in end_page_writeback()
From: Miklos Szeredi <mszeredi@suse.cz>

Fuse's writepage will need to clear page writeback separately from updating
the per BDI counters.

This patch renames end_page_writeback() to __end_page_writeback() and adds a
boolean parameter to indicate if the per BDI stats need to be updated.

Regular callers get an inline end_page_writeback() without the boolean
parameter.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 include/linux/pagemap.h    |    7 ++++++-
 mm/filemap.c               |    7 ++++---
 mm/page-writeback.c        |    4 ++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/page-flags.h~mm-allow-not-updating-bdi-stats-in-end_page_writeback include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-allow-not-updating-bdi-stats-in-end_page_writeback
+++ a/include/linux/page-flags.h
@@ -300,7 +300,7 @@ struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
 
-int test_clear_page_writeback(struct page *page);
+int test_clear_page_writeback(struct page *page, bool bdi_stats);
 int test_set_page_writeback(struct page *page);
 
 static inline void set_page_writeback(struct page *page)
diff -puN include/linux/pagemap.h~mm-allow-not-updating-bdi-stats-in-end_page_writeback include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-allow-not-updating-bdi-stats-in-end_page_writeback
+++ a/include/linux/pagemap.h
@@ -223,7 +223,12 @@ static inline void wait_on_page_writebac
 		wait_on_page_bit(page, PG_writeback);
 }
 
-extern void end_page_writeback(struct page *page);
+extern void __end_page_writeback(struct page *page, bool bdi_stats);
+
+static inline void end_page_writeback(struct page *page)
+{
+	__end_page_writeback(page, true);
+}
 
 /*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
diff -puN mm/filemap.c~mm-allow-not-updating-bdi-stats-in-end_page_writeback mm/filemap.c
--- a/mm/filemap.c~mm-allow-not-updating-bdi-stats-in-end_page_writeback
+++ a/mm/filemap.c
@@ -573,19 +573,20 @@ EXPORT_SYMBOL(unlock_page);
 /**
  * end_page_writeback - end writeback against a page
  * @page: the page
+ * @bdi_stats: update the per-bdi writeback counter
  */
-void end_page_writeback(struct page *page)
+void __end_page_writeback(struct page *page, bool bdi_stats)
 {
 	if (TestClearPageReclaim(page))
 		rotate_reclaimable_page(page);
 
-	if (!test_clear_page_writeback(page))
+	if (!test_clear_page_writeback(page, bdi_stats))
 		BUG();
 
 	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_writeback);
 }
-EXPORT_SYMBOL(end_page_writeback);
+EXPORT_SYMBOL(__end_page_writeback);
 
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
diff -puN mm/page-writeback.c~mm-allow-not-updating-bdi-stats-in-end_page_writeback mm/page-writeback.c
--- a/mm/page-writeback.c~mm-allow-not-updating-bdi-stats-in-end_page_writeback
+++ a/mm/page-writeback.c
@@ -1242,7 +1242,7 @@ int clear_page_dirty_for_io(struct page 
 }
 EXPORT_SYMBOL(clear_page_dirty_for_io);
 
-int test_clear_page_writeback(struct page *page)
+int test_clear_page_writeback(struct page *page, bool bdi_stats)
 {
 	struct address_space *mapping = page_mapping(page);
 	int ret;
@@ -1257,7 +1257,7 @@ int test_clear_page_writeback(struct pag
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
-			if (bdi_cap_writeback_dirty(bdi)) {
+			if (bdi_stats && bdi_cap_writeback_dirty(bdi)) {
 				__dec_bdi_stat(bdi, BDI_WRITEBACK);
 				__bdi_writeout_inc(bdi);
 			}
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

