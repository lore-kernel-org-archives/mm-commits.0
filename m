From: akpm@linux-foundation.org
Subject: [merged]
 page_writeback-cleanup-mess-around-cancel_dirty_page.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:45 -0700
Message-ID: <552eb779.j6DiYAdxvU1Al0ed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166AbbDOTJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, jack@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page_writeback: clean up mess around cancel_dirty_page()
has been removed from the -mm tree.  Its filename was
     page_writeback-cleanup-mess-around-cancel_dirty_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: page_writeback: clean up mess around cancel_dirty_page()

This patch replaces cancel_dirty_page() with helper account_page_cleaned()
which only updates counters.  It's called from truncate_complete_page()
and from try_to_free_buffers() (hack for ext3).  Page is locked in both
cases, page-lock protects against concurrent dirtiers: see commit
2d6d7f982846 ("mm: protect set_page_dirty() from ongoing truncation").

Delete_from_page_cache() shouldn't be called for dirty pages, they must be
handled by caller (either written or truncated).  This patch treats final
dirty accounting fixup at the end of __delete_from_page_cache() as a debug
check and adds WARN_ON_ONCE() around it.  If something removes dirty pages
without proper handling that might be a bug and unwritten data might be
lost.

Hugetlbfs has no dirty pages accounting, ClearPageDirty() is enough here.

cancel_dirty_page() in nfs_wb_page_cancel() is redundant.  This is helper
for nfs_invalidate_page() and it's called only in case complete
invalidation.

The mess was started in v2.6.20 after commits 46d2277c796f ("Clean up and
make try_to_free_buffers() not race with dirty pages") and 3e67c0987d75
("truncate: clear page dirtiness before running try_to_free_buffers()")
first was reverted right in v2.6.20 in commit ecdfc9787fe5 ("Resurrect
'try_to_free_buffers()' VM hackery"), second in v2.6.25 commit
a2b345642f53 ("Fix dirty page accounting leak with ext3 data=journal").

Custom fixes were introduced between these points.  NFS in v2.6.23, commit
1b3b4a1a2deb ("NFS: Fix a write request leak in nfs_invalidate_page()"). 
Kludge in __delete_from_page_cache() in v2.6.24, commit 3a6927906f1b ("Do
dirty page accounting when removing a page from the page cache").  Since
v2.6.25 all of them are redundant.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h |    4 -
 fs/buffer.c                                                           |    4 -
 fs/hugetlbfs/inode.c                                                  |    2 
 fs/nfs/write.c                                                        |    5 -
 include/linux/mm.h                                                    |    2 
 include/linux/page-flags.h                                            |    2 
 mm/filemap.c                                                          |   15 +---
 mm/page-writeback.c                                                   |   19 +++++
 mm/truncate.c                                                         |   37 +---------
 9 files changed, 41 insertions(+), 49 deletions(-)

diff -puN drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h~page_writeback-cleanup-mess-around-cancel_dirty_page drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
--- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
@@ -55,7 +55,9 @@ truncate_complete_page(struct address_sp
 	if (PagePrivate(page))
 		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
 
-	cancel_dirty_page(page, PAGE_SIZE);
+	if (TestClearPageDirty(page))
+		account_page_cleaned(page, mapping);
+
 	ClearPageMappedToDisk(page);
 	ll_delete_from_page_cache(page);
 }
diff -puN fs/buffer.c~page_writeback-cleanup-mess-around-cancel_dirty_page fs/buffer.c
--- a/fs/buffer.c~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/fs/buffer.c
@@ -3243,8 +3243,8 @@ int try_to_free_buffers(struct page *pag
 	 * to synchronise against __set_page_dirty_buffers and prevent the
 	 * dirty bit from being lost.
 	 */
-	if (ret)
-		cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	if (ret && TestClearPageDirty(page))
+		account_page_cleaned(page, mapping);
 	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {
diff -puN fs/hugetlbfs/inode.c~page_writeback-cleanup-mess-around-cancel_dirty_page fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/fs/hugetlbfs/inode.c
@@ -319,7 +319,7 @@ static int hugetlbfs_write_end(struct fi
 
 static void truncate_huge_page(struct page *page)
 {
-	cancel_dirty_page(page, /* No IO accounting for huge pages? */0);
+	ClearPageDirty(page);
 	ClearPageUptodate(page);
 	delete_from_page_cache(page);
 }
diff -puN fs/nfs/write.c~page_writeback-cleanup-mess-around-cancel_dirty_page fs/nfs/write.c
--- a/fs/nfs/write.c~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/fs/nfs/write.c
@@ -1876,11 +1876,6 @@ int nfs_wb_page_cancel(struct inode *ino
 		 * request from the inode / page_private pointer and
 		 * release it */
 		nfs_inode_remove_request(req);
-		/*
-		 * In case nfs_inode_remove_request has marked the
-		 * page as being dirty
-		 */
-		cancel_dirty_page(page, PAGE_CACHE_SIZE);
 		nfs_unlock_and_release_request(req);
 	}
 
diff -puN include/linux/mm.h~page_writeback-cleanup-mess-around-cancel_dirty_page include/linux/mm.h
--- a/include/linux/mm.h~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/include/linux/mm.h
@@ -1294,9 +1294,11 @@ int __set_page_dirty_no_writeback(struct
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
+void account_page_cleaned(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
+
 int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 
 /* Is the vma a continuation of the stack vma above it? */
diff -puN include/linux/page-flags.h~page_writeback-cleanup-mess-around-cancel_dirty_page include/linux/page-flags.h
--- a/include/linux/page-flags.h~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/include/linux/page-flags.h
@@ -328,8 +328,6 @@ static inline void SetPageUptodate(struc
 
 CLEARPAGEFLAG(Uptodate, uptodate)
 
-extern void cancel_dirty_page(struct page *page, unsigned int account_size);
-
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
 
diff -puN mm/filemap.c~page_writeback-cleanup-mess-around-cancel_dirty_page mm/filemap.c
--- a/mm/filemap.c~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/mm/filemap.c
@@ -203,16 +203,15 @@ void __delete_from_page_cache(struct pag
 	BUG_ON(page_mapped(page));
 
 	/*
-	 * Some filesystems seem to re-dirty the page even after
-	 * the VM has canceled the dirty bit (eg ext3 journaling).
+	 * At this point page must be either written or cleaned by truncate.
+	 * Dirty page here signals a bug and loss of unwritten data.
 	 *
-	 * Fix it up by doing a final dirty accounting check after
-	 * having removed the page entirely.
+	 * This fixes dirty accounting after removing the page entirely but
+	 * leaves PageDirty set: it has no effect for truncated page and
+	 * anyway will be cleared before returning page into buddy allocator.
 	 */
-	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
-		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_bdi_stat(inode_to_bdi(mapping->host), BDI_RECLAIMABLE);
-	}
+	if (WARN_ON_ONCE(PageDirty(page)))
+		account_page_cleaned(page, mapping);
 }
 
 /**
diff -puN mm/page-writeback.c~page_writeback-cleanup-mess-around-cancel_dirty_page mm/page-writeback.c
--- a/mm/page-writeback.c~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/mm/page-writeback.c
@@ -2111,6 +2111,25 @@ void account_page_dirtied(struct page *p
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
+ * Helper function for deaccounting dirty page without writeback.
+ *
+ * Doing this should *normally* only ever be done when a page
+ * is truncated, and is not actually mapped anywhere at all. However,
+ * fs/buffer.c does this when it notices that somebody has cleaned
+ * out all the buffers on a page without actually doing it through
+ * the VM. Can you say "ext3 is horribly ugly"? Thought you could.
+ */
+void account_page_cleaned(struct page *page, struct address_space *mapping)
+{
+	if (mapping_cap_account_dirty(mapping)) {
+		dec_zone_page_state(page, NR_FILE_DIRTY);
+		dec_bdi_stat(inode_to_bdi(mapping->host), BDI_RECLAIMABLE);
+		task_io_account_cancelled_write(PAGE_CACHE_SIZE);
+	}
+}
+EXPORT_SYMBOL(account_page_cleaned);
+
+/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
diff -puN mm/truncate.c~page_writeback-cleanup-mess-around-cancel_dirty_page mm/truncate.c
--- a/mm/truncate.c~page_writeback-cleanup-mess-around-cancel_dirty_page
+++ a/mm/truncate.c
@@ -93,35 +93,6 @@ void do_invalidatepage(struct page *page
 }
 
 /*
- * This cancels just the dirty bit on the kernel page itself, it
- * does NOT actually remove dirty bits on any mmap's that may be
- * around. It also leaves the page tagged dirty, so any sync
- * activity will still find it on the dirty lists, and in particular,
- * clear_page_dirty_for_io() will still look at the dirty bits in
- * the VM.
- *
- * Doing this should *normally* only ever be done when a page
- * is truncated, and is not actually mapped anywhere at all. However,
- * fs/buffer.c does this when it notices that somebody has cleaned
- * out all the buffers on a page without actually doing it through
- * the VM. Can you say "ext3 is horribly ugly"? Tought you could.
- */
-void cancel_dirty_page(struct page *page, unsigned int account_size)
-{
-	if (TestClearPageDirty(page)) {
-		struct address_space *mapping = page->mapping;
-		if (mapping && mapping_cap_account_dirty(mapping)) {
-			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_bdi_stat(inode_to_bdi(mapping->host),
-					BDI_RECLAIMABLE);
-			if (account_size)
-				task_io_account_cancelled_write(account_size);
-		}
-	}
-}
-EXPORT_SYMBOL(cancel_dirty_page);
-
-/*
  * If truncate cannot remove the fs-private metadata from the page, the page
  * becomes orphaned.  It will be left on the LRU and may even be mapped into
  * user pagetables if we're racing with filemap_fault().
@@ -140,7 +111,13 @@ truncate_complete_page(struct address_sp
 	if (page_has_private(page))
 		do_invalidatepage(page, 0, PAGE_CACHE_SIZE);
 
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	/*
+	 * Some filesystems seem to re-dirty the page even after
+	 * the VM has canceled the dirty bit (eg ext3 journaling).
+	 * Hence dirty accounting check is placed after invalidation.
+	 */
+	if (TestClearPageDirty(page))
+		account_page_cleaned(page, mapping);
 
 	ClearPageMappedToDisk(page);
 	delete_from_page_cache(page);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

origin.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
mm-rcu-protected-get_mm_exe_file-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
linux-next.patch
prctl-avoid-using-mmap_sem-for-exe_file-serialization.patch

