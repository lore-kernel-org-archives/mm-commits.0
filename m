From: akpm@linux-foundation.org
Subject: [merged] vfs-add-use-account_page_dirtied.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:39 -0700
Message-ID: <200904011834.n31IYdd3007248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760340AbZDAShO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vfs: add/use account_page_dirtied()
has been removed from the -mm tree.  Its filename was
     vfs-add-use-account_page_dirtied.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add/use account_page_dirtied()
From: Edward Shishkin <edward.shishkin@gmail.com>

Add a helper function account_page_dirtied().  Use that from two
callsites.  reiser4 adds a function which adds a third callsite.

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |    9 +--------
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   22 +++++++++++++++-------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff -puN fs/buffer.c~vfs-add-use-account_page_dirtied fs/buffer.c
--- a/fs/buffer.c~vfs-add-use-account_page_dirtied
+++ a/fs/buffer.c
@@ -621,14 +621,7 @@ static void __set_page_dirty(struct page
 	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
-
-		if (mapping_cap_account_dirty(mapping)) {
-			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
-			task_dirty_inc(current);
-			task_io_account_write(PAGE_CACHE_SIZE);
-		}
+		account_page_dirtied(page, mapping);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
diff -puN include/linux/mm.h~vfs-add-use-account_page_dirtied include/linux/mm.h
--- a/include/linux/mm.h~vfs-add-use-account_page_dirtied
+++ a/include/linux/mm.h
@@ -836,6 +836,7 @@ int __set_page_dirty_nobuffers(struct pa
 int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
+void account_page_dirtied(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff -puN mm/page-writeback.c~vfs-add-use-account_page_dirtied mm/page-writeback.c
--- a/mm/page-writeback.c~vfs-add-use-account_page_dirtied
+++ a/mm/page-writeback.c
@@ -1198,6 +1198,20 @@ int __set_page_dirty_no_writeback(struct
 }
 
 /*
+ * Helper function for set_page_dirty family.
+ * NOTE: This relies on being atomic wrt interrupts.
+ */
+void account_page_dirtied(struct page *page, struct address_space *mapping)
+{
+	if (mapping_cap_account_dirty(mapping)) {
+		__inc_zone_page_state(page, NR_FILE_DIRTY);
+		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+		task_dirty_inc(current);
+		task_io_account_write(PAGE_CACHE_SIZE);
+	}
+}
+
+/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
@@ -1226,13 +1240,7 @@ int __set_page_dirty_nobuffers(struct pa
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
-			if (mapping_cap_account_dirty(mapping)) {
-				__inc_zone_page_state(page, NR_FILE_DIRTY);
-				__inc_bdi_stat(mapping->backing_dev_info,
-						BDI_RECLAIMABLE);
-				task_dirty_inc(current);
-				task_io_account_write(PAGE_CACHE_SIZE);
-			}
+			account_page_dirtied(page, mapping);
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch

