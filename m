From: akpm@linux-foundation.org
Subject: [to-be-updated] vfs-add-set_page_dirty_notag.patch removed from -mm tree
Date: Thu, 19 Feb 2009 13:15:35 -0800
Message-ID: <200902192115.n1JLFajC023479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757990AbZBSVQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, a.p.zijlstra@chello.nl, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     vfs: add set_page_dirty_notag()
has been removed from the -mm tree.  Its filename was
     vfs-add-set_page_dirty_notag.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add set_page_dirty_notag()
From: Edward Shishkin <edward.shishkin@gmail.com>

In accordance with reiser4 transactional model every dirty page should be
"captured" by some atom.  However, outside reiser4 context dirty page can
not be captured in some cases, as it is accompanied with specific work
(jnode creation, etc).  Reiser4 recognizes such "anonymous" pages (i.e. 
pages that were dirtied outside of reiser4) by the tag
PAGECACHE_TAG_DIRTY.  Pages dirtied inside reiser4 context are not tagged
at all: we don't need this.  Indeed, once page is dirtied and captured, it
is attached to a jnode (a special header to keep a track of transactions).

reiser4_set_page_dirty_internal() was the internal reiser4 function that
set dirty bit without tagging the page.  Having such internal function led
to real problems (incorrect task io accounting, etc.  because of not
updating this internal "friend").

Solution:

The following patch adds a core library function that sets a dirty bit
without tagging the page.  It should be modified simultaneously with its
"friends": __set_page_dirty_nobuffers, __set_page_dirty.

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN include/linux/mm.h~vfs-add-set_page_dirty_notag include/linux/mm.h
--- a/include/linux/mm.h~vfs-add-set_page_dirty_notag
+++ a/include/linux/mm.h
@@ -841,6 +841,7 @@ int redirty_page_for_writepage(struct wr
 				struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
+int set_page_dirty_notag(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
diff -puN mm/page-writeback.c~vfs-add-set_page_dirty_notag mm/page-writeback.c
--- a/mm/page-writeback.c~vfs-add-set_page_dirty_notag
+++ a/mm/page-writeback.c
@@ -1247,6 +1247,42 @@ int __set_page_dirty_nobuffers(struct pa
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
+ * set_page_dirty_notag() -- similar to __set_page_dirty_nobuffers()
+ * except it doesn't tag the page dirty in the page-cache radix tree.
+ * This means that the address space using this cannot use the regular
+ * filemap ->writepages() helpers and must provide its own means of
+ * tracking and finding non-tagged dirty pages.
+ *
+ * NOTE: furthermore, this version also doesn't handle truncate races.
+ */
+int set_page_dirty_notag(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	if (!TestSetPageDirty(page)) {
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		if (mapping_cap_account_dirty(mapping)) {
+		        /*
+			 * The accounting functions rely on
+			 * being atomic wrt interrupts.
+			 */
+		        unsigned long flags;
+			local_irq_save(flags);
+			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			__inc_bdi_stat(mapping->backing_dev_info,
+				       BDI_RECLAIMABLE);
+			task_dirty_inc(current);
+			task_io_account_write(PAGE_CACHE_SIZE);
+			local_irq_restore(flags);
+		}
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(set_page_dirty_notag);
+
+/*
  * When a writepage implementation decides that it doesn't want to write this
  * page for some reason, it should redirty the locked page via
  * redirty_page_for_writepage() and it should then unlock the page and return 0
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-add-use-account_page_dirtied.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-add-set_page_dirty_notag.patch
vfs-add-set_page_dirty_notag-checkpatch-fixes.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch

