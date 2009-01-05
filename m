From: akpm@linux-foundation.org
Subject: - fs-symlink-write_begin-allocation-context-fix.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:40:54 -0800
Message-ID: <200901050640.n056esNX004990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZAEGlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, kosaki.motohiro@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs: symlink write_begin allocation context fix
has been removed from the -mm tree.  Its filename was
     fs-symlink-write_begin-allocation-context-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: symlink write_begin allocation context fix
From: Nick Piggin <npiggin@suse.de>

With the write_begin/write_end aops, page_symlink was broken because it
could no longer pass a GFP_NOFS type mask into the point where the
allocations happened.  They are done in write_begin, which would always
assume that the filesystem can be entered from reclaim.  This bug could
cause filesystem deadlocks.

The funny thing with having a gfp_t mask there is that it doesn't really
allow the caller to arbitrarily tinker with the context in which it can be
called.  It couldn't ever be GFP_ATOMIC, for example, because it needs to
take the page lock.  The only thing any callers care about is __GFP_FS
anyway, so turn that into a single flag.

Add a new flag for write_begin, AOP_FLAG_NOFS.  Filesystems can now act on
this flag in their write_begin function.  Change __grab_cache_page to
accept a nofs argument as well, to honour that flag (while we're there,
change the name to grab_cache_page_write_begin which is more instructive
and does away with random leading underscores).

This is really a more flexible way to go in the end anyway -- if a
filesystem happens to want any extra allocations aside from the pagecache
ones in ints write_begin function, it may now use GFP_KERNEL (rather than
GFP_NOFS) for common case allocations (eg.  ocfs2_alloc_write_ctxt, for a
random example).

[kosaki.motohiro@jp.fujitsu.com: fix ubifs]
[kosaki.motohiro@jp.fujitsu.com: fix fuse]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c          |    2 +-
 fs/afs/write.c          |    2 +-
 fs/buffer.c             |    6 ++++--
 fs/cifs/file.c          |    3 ++-
 fs/ecryptfs/mmap.c      |    3 ++-
 fs/ext3/inode.c         |    3 ++-
 fs/ext3/namei.c         |    3 +--
 fs/ext4/inode.c         |    6 ++++--
 fs/ext4/namei.c         |    3 +--
 fs/fuse/file.c          |    5 +++--
 fs/gfs2/ops_address.c   |    3 ++-
 fs/hostfs/hostfs_kern.c |    3 ++-
 fs/jffs2/file.c         |    3 ++-
 fs/libfs.c              |    3 ++-
 fs/namei.c              |   13 +++++++++----
 fs/nfs/file.c           |    3 ++-
 fs/reiserfs/inode.c     |    3 ++-
 fs/smbfs/file.c         |    3 ++-
 fs/ubifs/file.c         |   11 +++++++----
 include/linux/fs.h      |    5 ++++-
 include/linux/pagemap.h |    3 ++-
 mm/filemap.c            |   13 +++++++++----
 22 files changed, 66 insertions(+), 36 deletions(-)

diff -puN fs/affs/file.c~fs-symlink-write_begin-allocation-context-fix fs/affs/file.c
--- a/fs/affs/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/affs/file.c
@@ -628,7 +628,7 @@ static int affs_write_begin_ofs(struct f
 	}
 
 	index = pos >> PAGE_CACHE_SHIFT;
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index, flags&AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
diff -puN fs/afs/write.c~fs-symlink-write_begin-allocation-context-fix fs/afs/write.c
--- a/fs/afs/write.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/afs/write.c
@@ -144,7 +144,7 @@ int afs_write_begin(struct file *file, s
 	candidate->state = AFS_WBACK_PENDING;
 	init_waitqueue_head(&candidate->waitq);
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index, flags&AOP_FLAG_NOFS);
 	if (!page) {
 		kfree(candidate);
 		return -ENOMEM;
diff -puN fs/buffer.c~fs-symlink-write_begin-allocation-context-fix fs/buffer.c
--- a/fs/buffer.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/buffer.c
@@ -1996,7 +1996,8 @@ int block_write_begin(struct file *file,
 	page = *pagep;
 	if (page == NULL) {
 		ownpage = 1;
-		page = __grab_cache_page(mapping, index);
+		page = grab_cache_page_write_begin(mapping, index,
+						flags & AOP_FLAG_NOFS);
 		if (!page) {
 			status = -ENOMEM;
 			goto out;
@@ -2502,7 +2503,8 @@ int nobh_write_begin(struct file *file, 
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
diff -puN fs/cifs/file.c~fs-symlink-write_begin-allocation-context-fix fs/cifs/file.c
--- a/fs/cifs/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/cifs/file.c
@@ -2074,7 +2074,8 @@ static int cifs_write_begin(struct file 
 
 	cFYI(1, ("write_begin from %lld len %d", (long long)pos, len));
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+			flags & AOP_FLAG_NOFS);
 	if (!page) {
 		rc = -ENOMEM;
 		goto out;
diff -puN fs/ecryptfs/mmap.c~fs-symlink-write_begin-allocation-context-fix fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/ecryptfs/mmap.c
@@ -288,7 +288,8 @@ static int ecryptfs_write_begin(struct f
 	loff_t prev_page_end_size;
 	int rc = 0;
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
diff -puN fs/ext3/inode.c~fs-symlink-write_begin-allocation-context-fix fs/ext3/inode.c
--- a/fs/ext3/inode.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/ext3/inode.c
@@ -1161,7 +1161,8 @@ static int ext3_write_begin(struct file 
 	to = from + len;
 
 retry:
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
diff -puN fs/ext3/namei.c~fs-symlink-write_begin-allocation-context-fix fs/ext3/namei.c
--- a/fs/ext3/namei.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/ext3/namei.c
@@ -2175,8 +2175,7 @@ retry:
 		 * We have a transaction open.  All is sweetness.  It also sets
 		 * i_size in generic_commit_write().
 		 */
-		err = __page_symlink(inode, symname, l,
-				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+		err = __page_symlink(inode, symname, l, 1);
 		if (err) {
 			drop_nlink(inode);
 			unlock_new_inode(inode);
diff -puN fs/ext4/inode.c~fs-symlink-write_begin-allocation-context-fix fs/ext4/inode.c
--- a/fs/ext4/inode.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/ext4/inode.c
@@ -1346,7 +1346,8 @@ retry:
 		goto out;
 	}
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page) {
 		ext4_journal_stop(handle);
 		ret = -ENOMEM;
@@ -2550,7 +2551,8 @@ retry:
 		goto out;
 	}
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page) {
 		ext4_journal_stop(handle);
 		ret = -ENOMEM;
diff -puN fs/ext4/namei.c~fs-symlink-write_begin-allocation-context-fix fs/ext4/namei.c
--- a/fs/ext4/namei.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/ext4/namei.c
@@ -2212,8 +2212,7 @@ retry:
 		 * We have a transaction open.  All is sweetness.  It also sets
 		 * i_size in generic_commit_write().
 		 */
-		err = __page_symlink(inode, symname, l,
-				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+		err = __page_symlink(inode, symname, l, 1);
 		if (err) {
 			clear_nlink(inode);
 			unlock_new_inode(inode);
diff -puN fs/fuse/file.c~fs-symlink-write_begin-allocation-context-fix fs/fuse/file.c
--- a/fs/fuse/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/fuse/file.c
@@ -646,7 +646,8 @@ static int fuse_write_begin(struct file 
 {
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 
-	*pagep = __grab_cache_page(mapping, index);
+	*pagep = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!*pagep)
 		return -ENOMEM;
 	return 0;
@@ -779,7 +780,7 @@ static ssize_t fuse_fill_write_pages(str
 			break;
 
 		err = -ENOMEM;
-		page = __grab_cache_page(mapping, index);
+		page = grab_cache_page_write_begin(mapping, index, 0);
 		if (!page)
 			break;
 
diff -puN fs/gfs2/ops_address.c~fs-symlink-write_begin-allocation-context-fix fs/gfs2/ops_address.c
--- a/fs/gfs2/ops_address.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/gfs2/ops_address.c
@@ -675,7 +675,8 @@ static int gfs2_write_begin(struct file 
 		goto out_trans_fail;
 
 	error = -ENOMEM;
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	*pagep = page;
 	if (unlikely(!page))
 		goto out_endtrans;
diff -puN fs/hostfs/hostfs_kern.c~fs-symlink-write_begin-allocation-context-fix fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/hostfs/hostfs_kern.c
@@ -501,7 +501,8 @@ int hostfs_write_begin(struct file *file
 {
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 
-	*pagep = __grab_cache_page(mapping, index);
+	*pagep = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!*pagep)
 		return -ENOMEM;
 	return 0;
diff -puN fs/jffs2/file.c~fs-symlink-write_begin-allocation-context-fix fs/jffs2/file.c
--- a/fs/jffs2/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/jffs2/file.c
@@ -132,7 +132,8 @@ static int jffs2_write_begin(struct file
 	uint32_t pageofs = index << PAGE_CACHE_SHIFT;
 	int ret = 0;
 
-	pg = __grab_cache_page(mapping, index);
+	pg = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!pg)
 		return -ENOMEM;
 	*pagep = pg;
diff -puN fs/libfs.c~fs-symlink-write_begin-allocation-context-fix fs/libfs.c
--- a/fs/libfs.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/libfs.c
@@ -360,7 +360,8 @@ int simple_write_begin(struct file *file
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 
diff -puN fs/namei.c~fs-symlink-write_begin-allocation-context-fix fs/namei.c
--- a/fs/namei.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/namei.c
@@ -2817,18 +2817,23 @@ void page_put_link(struct dentry *dentry
 	}
 }
 
-int __page_symlink(struct inode *inode, const char *symname, int len,
-		gfp_t gfp_mask)
+/*
+ * The nofs argument instructs pagecache_write_begin to pass AOP_FLAG_NOFS
+ */
+int __page_symlink(struct inode *inode, const char *symname, int len, int nofs)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
 	void *fsdata;
 	int err;
 	char *kaddr;
+	unsigned int flags = AOP_FLAG_UNINTERRUPTIBLE;
+	if (nofs)
+		flags |= AOP_FLAG_NOFS;
 
 retry:
 	err = pagecache_write_begin(NULL, mapping, 0, len-1,
-				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+				flags, &page, &fsdata);
 	if (err)
 		goto fail;
 
@@ -2852,7 +2857,7 @@ fail:
 int page_symlink(struct inode *inode, const char *symname, int len)
 {
 	return __page_symlink(inode, symname, len,
-			mapping_gfp_mask(inode->i_mapping));
+			!(mapping_gfp_mask(inode->i_mapping) & __GFP_FS));
 }
 
 const struct inode_operations page_symlink_inode_operations = {
diff -puN fs/nfs/file.c~fs-symlink-write_begin-allocation-context-fix fs/nfs/file.c
--- a/fs/nfs/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/nfs/file.c
@@ -354,7 +354,8 @@ static int nfs_write_begin(struct file *
 		file->f_path.dentry->d_name.name,
 		mapping->host->i_ino, len, (long long) pos);
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
diff -puN fs/reiserfs/inode.c~fs-symlink-write_begin-allocation-context-fix fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/reiserfs/inode.c
@@ -2561,7 +2561,8 @@ static int reiserfs_write_begin(struct f
 	}
 
 	index = pos >> PAGE_CACHE_SHIFT;
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
diff -puN fs/smbfs/file.c~fs-symlink-write_begin-allocation-context-fix fs/smbfs/file.c
--- a/fs/smbfs/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/smbfs/file.c
@@ -297,7 +297,8 @@ static int smb_write_begin(struct file *
 			struct page **pagep, void **fsdata)
 {
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	*pagep = __grab_cache_page(mapping, index);
+	*pagep = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (!*pagep)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ubifs/file.c~fs-symlink-write_begin-allocation-context-fix fs/ubifs/file.c
--- a/fs/ubifs/file.c~fs-symlink-write_begin-allocation-context-fix
+++ a/fs/ubifs/file.c
@@ -219,7 +219,8 @@ static void release_existing_page_budget
 }
 
 static int write_begin_slow(struct address_space *mapping,
-			    loff_t pos, unsigned len, struct page **pagep)
+			    loff_t pos, unsigned len, struct page **pagep,
+			    unsigned flags)
 {
 	struct inode *inode = mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
@@ -247,7 +248,8 @@ static int write_begin_slow(struct addre
 	if (unlikely(err))
 		return err;
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (unlikely(!page)) {
 		ubifs_release_budget(c, &req);
 		return -ENOMEM;
@@ -438,7 +440,8 @@ static int ubifs_write_begin(struct file
 		return -EROFS;
 
 	/* Try out the fast-path part first */
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					flags & AOP_FLAG_NOFS);
 	if (unlikely(!page))
 		return -ENOMEM;
 
@@ -483,7 +486,7 @@ static int ubifs_write_begin(struct file
 		unlock_page(page);
 		page_cache_release(page);
 
-		return write_begin_slow(mapping, pos, len, pagep);
+		return write_begin_slow(mapping, pos, len, pagep, flags);
 	}
 
 	/*
diff -puN include/linux/fs.h~fs-symlink-write_begin-allocation-context-fix include/linux/fs.h
--- a/include/linux/fs.h~fs-symlink-write_begin-allocation-context-fix
+++ a/include/linux/fs.h
@@ -423,6 +423,9 @@ enum positive_aop_returns {
 
 #define AOP_FLAG_UNINTERRUPTIBLE	0x0001 /* will not do a short write */
 #define AOP_FLAG_CONT_EXPAND		0x0002 /* called from cont_expand */
+#define AOP_FLAG_NOFS			0x0004 /* used by filesystem to direct
+						* helper code (eg buffer layer)
+						* to clear GFP_FS from alloc */
 
 /*
  * oh the beauties of C type declarations.
@@ -2035,7 +2038,7 @@ extern int page_readlink(struct dentry *
 extern void *page_follow_link_light(struct dentry *, struct nameidata *);
 extern void page_put_link(struct dentry *, struct nameidata *, void *);
 extern int __page_symlink(struct inode *inode, const char *symname, int len,
-		gfp_t gfp_mask);
+		int nofs);
 extern int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
diff -puN include/linux/pagemap.h~fs-symlink-write_begin-allocation-context-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~fs-symlink-write_begin-allocation-context-fix
+++ a/include/linux/pagemap.h
@@ -241,7 +241,8 @@ unsigned find_get_pages_contig(struct ad
 unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 			int tag, unsigned int nr_pages, struct page **pages);
 
-struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index);
+struct page *grab_cache_page_write_begin(struct address_space *mapping,
+			pgoff_t index, int nofs);
 
 /*
  * Returns locked page at given index in given cache, creating it if needed.
diff -puN mm/filemap.c~fs-symlink-write_begin-allocation-context-fix mm/filemap.c
--- a/mm/filemap.c~fs-symlink-write_begin-allocation-context-fix
+++ a/mm/filemap.c
@@ -2140,19 +2140,24 @@ EXPORT_SYMBOL(generic_file_direct_write)
  * Find or create a page at the given pagecache position. Return the locked
  * page. This function is specifically for buffered writes.
  */
-struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index)
+struct page *grab_cache_page_write_begin(struct address_space *mapping,
+					pgoff_t index, int nofs)
 {
 	int status;
 	struct page *page;
+	gfp_t gfp_notmask = 0;
+	if (nofs)
+		gfp_notmask = __GFP_FS;
 repeat:
 	page = find_lock_page(mapping, index);
 	if (likely(page))
 		return page;
 
-	page = page_cache_alloc(mapping);
+	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
 	if (!page)
 		return NULL;
-	status = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+	status = add_to_page_cache_lru(page, mapping, index,
+						GFP_KERNEL & ~gfp_notmask);
 	if (unlikely(status)) {
 		page_cache_release(page);
 		if (status == -EEXIST)
@@ -2161,7 +2166,7 @@ repeat:
 	}
 	return page;
 }
-EXPORT_SYMBOL(__grab_cache_page);
+EXPORT_SYMBOL(grab_cache_page_write_begin);
 
 static ssize_t generic_perform_write(struct file *file,
 				struct iov_iter *i, loff_t pos)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-direct-io-starvation-improvement.patch
fs-remove-wb_sync_hold.patch
fs-sync_sb_inodes-fix.patch
fs-sys_sync-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-pagecache-gfp-flags-fix.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

