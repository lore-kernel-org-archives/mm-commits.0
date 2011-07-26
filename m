From: akpm@linux-foundation.org
Subject: [merged] tmpfs-remove_shmem_readpage.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:47 -0700
Message-ID: <201107260752.p6Q7qos1003169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160Ab1GZHxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: remove_shmem_readpage
has been removed from the -mm tree.  Its filename was
     tmpfs-remove_shmem_readpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: remove_shmem_readpage
From: Hugh Dickins <hughd@google.com>

Remove that pernicious shmem_readpage() at last: the things we needed it
for (splice, loop, sendfile, i915 GEM) are now fully taken care of by
shmem_file_splice_read() and shmem_read_mapping_page_gfp().

This removal clears the way for a simpler shmem_getpage_gfp(), since page
is never passed in; but leave most of that cleanup until after.

sys_readahead() and sys_fadvise(POSIX_FADV_WILLNEED) will now EINVAL,
instead of unexpectedly trying to read ahead on tmpfs: if that proves to
be an issue for someone, then we can either arrange for them to return
success instead, or try to implement async readahead on tmpfs.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff -puN mm/shmem.c~tmpfs-remove_shmem_readpage mm/shmem.c
--- a/mm/shmem.c~tmpfs-remove_shmem_readpage
+++ a/mm/shmem.c
@@ -1246,7 +1246,7 @@ static int shmem_getpage_gfp(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
-	struct page *filepage = *pagep;
+	struct page *filepage;
 	struct page *swappage;
 	struct page *prealloc_page = NULL;
 	swp_entry_t *entry;
@@ -1255,18 +1255,8 @@ static int shmem_getpage_gfp(struct inod
 
 	if (idx >= SHMEM_MAX_INDEX)
 		return -EFBIG;
-
-	/*
-	 * Normally, filepage is NULL on entry, and either found
-	 * uptodate immediately, or allocated and zeroed, or read
-	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_readpage (required for splice) passes in a locked
-	 * filepage, which may be found not uptodate by other callers
-	 * too, and may need to be copied from the swappage read in.
-	 */
 repeat:
-	if (!filepage)
-		filepage = find_lock_page(mapping, idx);
+	filepage = find_lock_page(mapping, idx);
 	if (filepage && PageUptodate(filepage))
 		goto done;
 	if (!filepage) {
@@ -1513,8 +1503,7 @@ nospace:
 	 * Perhaps the page was brought in from swap between find_lock_page
 	 * and taking info->lock?  We allow for that at add_to_page_cache_lru,
 	 * but must also avoid reporting a spurious ENOSPC while working on a
-	 * full tmpfs.  (When filepage has been passed in to shmem_getpage, it
-	 * is already in page cache, which prevents this race from occurring.)
+	 * full tmpfs.
 	 */
 	if (!filepage) {
 		struct page *page = find_get_page(mapping, idx);
@@ -1527,7 +1516,7 @@ nospace:
 	spin_unlock(&info->lock);
 	error = -ENOSPC;
 failed:
-	if (*pagep != filepage) {
+	if (filepage) {
 		unlock_page(filepage);
 		page_cache_release(filepage);
 	}
@@ -1673,19 +1662,6 @@ static struct inode *shmem_get_inode(str
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_symlink_inline_operations;
 
-/*
- * Normally tmpfs avoids the use of shmem_readpage and shmem_write_begin;
- * but providing them allows a tmpfs file to be used for splice, sendfile, and
- * below the loop driver, in the generic fashion that many filesystems support.
- */
-static int shmem_readpage(struct file *file, struct page *page)
-{
-	struct inode *inode = page->mapping->host;
-	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
-	unlock_page(page);
-	return error;
-}
-
 static int
 shmem_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
@@ -1693,7 +1669,6 @@ shmem_write_begin(struct file *file, str
 {
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	*pagep = NULL;
 	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
 }
 
@@ -1893,7 +1868,6 @@ static ssize_t shmem_file_splice_read(st
 	error = 0;
 
 	while (spd.nr_pages < nr_pages) {
-		page = NULL;
 		error = shmem_getpage(inode, index, &page, SGP_CACHE, NULL);
 		if (error)
 			break;
@@ -1916,7 +1890,6 @@ static ssize_t shmem_file_splice_read(st
 		page = spd.pages[page_nr];
 
 		if (!PageUptodate(page) || page->mapping != mapping) {
-			page = NULL;
 			error = shmem_getpage(inode, index, &page,
 							SGP_CACHE, NULL);
 			if (error)
@@ -2125,7 +2098,7 @@ static int shmem_symlink(struct inode *d
 	int error;
 	int len;
 	struct inode *inode;
-	struct page *page = NULL;
+	struct page *page;
 	char *kaddr;
 	struct shmem_inode_info *info;
 
@@ -2803,7 +2776,6 @@ static const struct address_space_operat
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
-	.readpage	= shmem_readpage,
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
@@ -3175,7 +3147,7 @@ struct page *shmem_read_mapping_page_gfp
 {
 #ifdef CONFIG_SHMEM
 	struct inode *inode = mapping->host;
-	struct page *page = NULL;
+	struct page *page;
 	int error;
 
 	BUG_ON(mapping->a_ops != &shmem_aops);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
slub-partly-fix-freeze-in-__slab_free.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
panic-panic=-1-for-immediate-reboot.patch
panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch
prio_tree-debugging-patch.patch

