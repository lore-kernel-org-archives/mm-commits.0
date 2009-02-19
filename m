From: akpm@linux-foundation.org
Subject: [merged] mm-task-dirty-accounting-fix.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:37 -0800
Message-ID: <200902191916.n1JJGbh1016268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbZBSTQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     mm: task dirty accounting fix
has been removed from the -mm tree.  Its filename was
     mm-task-dirty-accounting-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: task dirty accounting fix
From: Nick Piggin <npiggin@suse.de>

YAMAMOTO-san noticed that task_dirty_inc doesn't seem to be called properly for
cases where set_page_dirty is not used to dirty a page (eg. mark_buffer_dirty).

Additionally, there is some inconsistency about when task_dirty_inc is
called.  It is used for dirty balancing, however it even gets called for
__set_page_dirty_no_writeback.

So rather than increment it in a set_page_dirty wrapper, move it down to
exactly where the dirty page accounting stats are incremented.

Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |    1 +
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   13 +++----------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/buffer.c~mm-task-dirty-accounting-fix fs/buffer.c
--- a/fs/buffer.c~mm-task-dirty-accounting-fix
+++ a/fs/buffer.c
@@ -777,6 +777,7 @@ static int __set_page_dirty(struct page 
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
 			__inc_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
+			task_dirty_inc(current);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
diff -puN include/linux/mm.h~mm-task-dirty-accounting-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-task-dirty-accounting-fix
+++ a/include/linux/mm.h
@@ -1159,6 +1159,7 @@ extern int filemap_fault(struct vm_area_
 
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
+void task_dirty_inc(struct task_struct *tsk);
 
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
diff -puN mm/page-writeback.c~mm-task-dirty-accounting-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-task-dirty-accounting-fix
+++ a/mm/page-writeback.c
@@ -240,7 +240,7 @@ void bdi_writeout_inc(struct backing_dev
 }
 EXPORT_SYMBOL_GPL(bdi_writeout_inc);
 
-static inline void task_dirty_inc(struct task_struct *tsk)
+void task_dirty_inc(struct task_struct *tsk)
 {
 	prop_inc_single(&vm_dirties, &tsk->dirties);
 }
@@ -1229,6 +1229,7 @@ int __set_page_dirty_nobuffers(struct pa
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
 				__inc_bdi_stat(mapping->backing_dev_info,
 						BDI_RECLAIMABLE);
+				task_dirty_inc(current);
 				task_io_account_write(PAGE_CACHE_SIZE);
 			}
 			radix_tree_tag_set(&mapping->page_tree,
@@ -1261,7 +1262,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage
  * If the mapping doesn't provide a set_page_dirty a_op, then
  * just fall through and assume that it wants buffer_heads.
  */
-static int __set_page_dirty(struct page *page)
+int set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -1279,14 +1280,6 @@ static int __set_page_dirty(struct page 
 	}
 	return 0;
 }
-
-int set_page_dirty(struct page *page)
-{
-	int ret = __set_page_dirty(page);
-	if (ret)
-		task_dirty_inc(current);
-	return ret;
-}
 EXPORT_SYMBOL(set_page_dirty);
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mm-vmap-fix-overflow.patch
mm-vmap-fix-overflow-update.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
vfs-add-set_page_dirty_notag.patch
vfs-add-set_page_dirty_notag-checkpatch-fixes.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

