From: akpm@linux-foundation.org
Subject: - mm-make-read_cache_page-synchronous.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:57 -0700
Message-ID: <200705080001.l4801v7K008808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967301AbXEHACZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: make read_cache_page synchronous
has been removed from the -mm tree.  Its filename was
     mm-make-read_cache_page-synchronous.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: make read_cache_page synchronous
From: Nick Piggin <npiggin@suse.de>

Ensure pages are uptodate after returning from read_cache_page, which allows
us to cut out most of the filesystem-internal PageUptodate calls.

I didn't have a great look down the call chains, but this appears to fixes 7
possible use-before uptodate in hfs, 2 in hfsplus, 1 in jfs, a few in
ecryptfs, 1 in jffs2, and a possible cleared data overwritten with readpage in
block2mtd.  All depending on whether the filler is async and/or can return
with a !uptodate page.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/block2mtd.c |    6 +--
 fs/afs/dir.c                    |    3 -
 fs/afs/mntpt.c                  |   11 ++----
 fs/cramfs/inode.c               |    3 +
 fs/ecryptfs/mmap.c              |   11 ------
 fs/ext2/dir.c                   |    3 -
 fs/freevxfs/vxfs_subr.c         |    3 -
 fs/minix/dir.c                  |    1 
 fs/namei.c                      |   12 -------
 fs/nfs/dir.c                    |    5 ---
 fs/nfs/symlink.c                |    6 ---
 fs/ntfs/aops.h                  |    3 -
 fs/ntfs/attrib.c                |   18 +----------
 fs/ntfs/file.c                  |    3 -
 fs/ntfs/super.c                 |   30 ++----------------
 fs/ocfs2/symlink.c              |    7 ----
 fs/partitions/check.c           |    3 -
 fs/reiserfs/xattr.c             |    4 --
 fs/sysv/dir.c                   |   10 ------
 fs/ufs/dir.c                    |    6 ---
 fs/ufs/util.c                   |    6 +--
 include/linux/pagemap.h         |   11 ++++++
 mm/filemap.c                    |   49 +++++++++++++++++++++++-------
 mm/swapfile.c                   |    3 -
 24 files changed, 71 insertions(+), 146 deletions(-)

diff -puN drivers/mtd/devices/block2mtd.c~mm-make-read_cache_page-synchronous drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~mm-make-read_cache_page-synchronous
+++ a/drivers/mtd/devices/block2mtd.c
@@ -40,13 +40,11 @@ struct block2mtd_dev {
 static LIST_HEAD(blkmtd_device_list);
 
 
-static struct page* page_read(struct address_space *mapping, int index)
+static struct page *page_read(struct address_space *mapping, int index)
 {
-	filler_t *filler = (filler_t*)mapping->a_ops->readpage;
-	return read_cache_page(mapping, index, filler, NULL);
+	return read_mapping_page(mapping, index, NULL);
 }
 
-
 /* erase a specified part of the device */
 static int _block2mtd_erase(struct block2mtd_dev *dev, loff_t to, size_t len)
 {
diff -puN fs/afs/dir.c~mm-make-read_cache_page-synchronous fs/afs/dir.c
--- a/fs/afs/dir.c~mm-make-read_cache_page-synchronous
+++ a/fs/afs/dir.c
@@ -194,10 +194,7 @@ static struct page *afs_dir_get_page(str
 
 	page = read_mapping_page(dir->i_mapping, index, &file);
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
 		if (!PageChecked(page))
 			afs_dir_check_page(dir, page);
 		if (PageError(page))
diff -puN fs/afs/mntpt.c~mm-make-read_cache_page-synchronous fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~mm-make-read_cache_page-synchronous
+++ a/fs/afs/mntpt.c
@@ -68,13 +68,11 @@ int afs_mntpt_check_symlink(struct afs_v
 	}
 
 	ret = -EIO;
-	wait_on_page_locked(page);
-	buf = kmap(page);
-	if (!PageUptodate(page))
-		goto out_free;
 	if (PageError(page))
 		goto out_free;
 
+	buf = kmap(page);
+
 	/* examine the symlink's contents */
 	size = vnode->status.size;
 	_debug("symlink to %*.*s", (int) size, (int) size, buf);
@@ -91,8 +89,8 @@ int afs_mntpt_check_symlink(struct afs_v
 
 	ret = 0;
 
-out_free:
 	kunmap(page);
+out_free:
 	page_cache_release(page);
 out:
 	_leave(" = %d", ret);
@@ -171,8 +169,7 @@ static struct vfsmount *afs_mntpt_do_aut
 	}
 
 	ret = -EIO;
-	wait_on_page_locked(page);
-	if (!PageUptodate(page) || PageError(page))
+	if (PageError(page))
 		goto error;
 
 	buf = kmap(page);
diff -puN fs/cramfs/inode.c~mm-make-read_cache_page-synchronous fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~mm-make-read_cache_page-synchronous
+++ a/fs/cramfs/inode.c
@@ -180,7 +180,8 @@ static void *cramfs_read(struct super_bl
 		struct page *page = NULL;
 
 		if (blocknr + i < devsize) {
-			page = read_mapping_page(mapping, blocknr + i, NULL);
+			page = read_mapping_page_async(mapping, blocknr + i,
+									NULL);
 			/* synchronous error? */
 			if (IS_ERR(page))
 				page = NULL;
diff -puN fs/ecryptfs/mmap.c~mm-make-read_cache_page-synchronous fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~mm-make-read_cache_page-synchronous
+++ a/fs/ecryptfs/mmap.c
@@ -46,7 +46,6 @@ struct kmem_cache *ecryptfs_lower_page_c
  */
 static struct page *ecryptfs_get1page(struct file *file, int index)
 {
-	struct page *page;
 	struct dentry *dentry;
 	struct inode *inode;
 	struct address_space *mapping;
@@ -54,14 +53,7 @@ static struct page *ecryptfs_get1page(st
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 	mapping = inode->i_mapping;
-	page = read_cache_page(mapping, index,
-			       (filler_t *)mapping->a_ops->readpage,
-			       (void *)file);
-	if (IS_ERR(page))
-		goto out;
-	wait_on_page_locked(page);
-out:
-	return page;
+	return read_mapping_page(mapping, index, (void *)file);
 }
 
 static
@@ -233,7 +225,6 @@ int ecryptfs_do_readpage(struct file *fi
 		ecryptfs_printk(KERN_ERR, "Error reading from page cache\n");
 		goto out;
 	}
-	wait_on_page_locked(lower_page);
 	page_data = kmap_atomic(page, KM_USER0);
 	lower_page_data = kmap_atomic(lower_page, KM_USER1);
 	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
diff -puN fs/ext2/dir.c~mm-make-read_cache_page-synchronous fs/ext2/dir.c
--- a/fs/ext2/dir.c~mm-make-read_cache_page-synchronous
+++ a/fs/ext2/dir.c
@@ -161,10 +161,7 @@ static struct page * ext2_get_page(struc
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page = read_mapping_page(mapping, n, NULL);
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
 		if (!PageChecked(page))
 			ext2_check_page(page);
 		if (PageError(page))
diff -puN fs/freevxfs/vxfs_subr.c~mm-make-read_cache_page-synchronous fs/freevxfs/vxfs_subr.c
--- a/fs/freevxfs/vxfs_subr.c~mm-make-read_cache_page-synchronous
+++ a/fs/freevxfs/vxfs_subr.c
@@ -74,10 +74,7 @@ vxfs_get_page(struct address_space *mapp
 	pp = read_mapping_page(mapping, n, NULL);
 
 	if (!IS_ERR(pp)) {
-		wait_on_page_locked(pp);
 		kmap(pp);
-		if (!PageUptodate(pp))
-			goto fail;
 		/** if (!PageChecked(pp)) **/
 			/** vxfs_check_page(pp); **/
 		if (PageError(pp))
diff -puN fs/minix/dir.c~mm-make-read_cache_page-synchronous fs/minix/dir.c
--- a/fs/minix/dir.c~mm-make-read_cache_page-synchronous
+++ a/fs/minix/dir.c
@@ -65,7 +65,6 @@ static struct page * dir_get_page(struct
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page = read_mapping_page(mapping, n, NULL);
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
 		if (!PageUptodate(page))
 			goto fail;
diff -puN fs/namei.c~mm-make-read_cache_page-synchronous fs/namei.c
--- a/fs/namei.c~mm-make-read_cache_page-synchronous
+++ a/fs/namei.c
@@ -2671,19 +2671,9 @@ static char *page_getlink(struct dentry 
 	struct address_space *mapping = dentry->d_inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
-		goto sync_fail;
-	wait_on_page_locked(page);
-	if (!PageUptodate(page))
-		goto async_fail;
+		return (char*)page;
 	*ppage = page;
 	return kmap(page);
-
-async_fail:
-	page_cache_release(page);
-	return ERR_PTR(-EIO);
-
-sync_fail:
-	return (char*)page;
 }
 
 int page_readlink(struct dentry *dentry, char __user *buffer, int buflen)
diff -puN fs/nfs/dir.c~mm-make-read_cache_page-synchronous fs/nfs/dir.c
--- a/fs/nfs/dir.c~mm-make-read_cache_page-synchronous
+++ a/fs/nfs/dir.c
@@ -334,8 +334,6 @@ int find_dirent_page(nfs_readdir_descrip
 		status = PTR_ERR(page);
 		goto out;
 	}
-	if (!PageUptodate(page))
-		goto read_error;
 
 	/* NOTE: Someone else may have changed the READDIRPLUS flag */
 	desc->page = page;
@@ -349,9 +347,6 @@ int find_dirent_page(nfs_readdir_descrip
  out:
 	dfprintk(DIRCACHE, "NFS: %s: returns %d\n", __FUNCTION__, status);
 	return status;
- read_error:
-	page_cache_release(page);
-	return -EIO;
 }
 
 /*
diff -puN fs/nfs/symlink.c~mm-make-read_cache_page-synchronous fs/nfs/symlink.c
--- a/fs/nfs/symlink.c~mm-make-read_cache_page-synchronous
+++ a/fs/nfs/symlink.c
@@ -61,15 +61,9 @@ static void *nfs_follow_link(struct dent
 		err = page;
 		goto read_failed;
 	}
-	if (!PageUptodate(page)) {
-		err = ERR_PTR(-EIO);
-		goto getlink_read_error;
-	}
 	nd_set_link(nd, kmap(page));
 	return page;
 
-getlink_read_error:
-	page_cache_release(page);
 read_failed:
 	nd_set_link(nd, err);
 	return NULL;
diff -puN fs/ntfs/aops.h~mm-make-read_cache_page-synchronous fs/ntfs/aops.h
--- a/fs/ntfs/aops.h~mm-make-read_cache_page-synchronous
+++ a/fs/ntfs/aops.h
@@ -89,9 +89,8 @@ static inline struct page *ntfs_map_page
 	struct page *page = read_mapping_page(mapping, index, NULL);
 
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
-		if (PageUptodate(page) && !PageError(page))
+		if (!PageError(page))
 			return page;
 		ntfs_unmap_page(page);
 		return ERR_PTR(-EIO);
diff -puN fs/ntfs/attrib.c~mm-make-read_cache_page-synchronous fs/ntfs/attrib.c
--- a/fs/ntfs/attrib.c~mm-make-read_cache_page-synchronous
+++ a/fs/ntfs/attrib.c
@@ -2532,14 +2532,7 @@ int ntfs_attr_set(ntfs_inode *ni, const 
 		page = read_mapping_page(mapping, idx, NULL);
 		if (IS_ERR(page)) {
 			ntfs_error(vol->sb, "Failed to read first partial "
-					"page (sync error, index 0x%lx).", idx);
-			return PTR_ERR(page);
-		}
-		wait_on_page_locked(page);
-		if (unlikely(!PageUptodate(page))) {
-			ntfs_error(vol->sb, "Failed to read first partial page "
-					"(async error, index 0x%lx).", idx);
-			page_cache_release(page);
+					"page (error, index 0x%lx).", idx);
 			return PTR_ERR(page);
 		}
 		/*
@@ -2602,14 +2595,7 @@ int ntfs_attr_set(ntfs_inode *ni, const 
 		page = read_mapping_page(mapping, idx, NULL);
 		if (IS_ERR(page)) {
 			ntfs_error(vol->sb, "Failed to read last partial page "
-					"(sync error, index 0x%lx).", idx);
-			return PTR_ERR(page);
-		}
-		wait_on_page_locked(page);
-		if (unlikely(!PageUptodate(page))) {
-			ntfs_error(vol->sb, "Failed to read last partial page "
-					"(async error, index 0x%lx).", idx);
-			page_cache_release(page);
+					"(error, index 0x%lx).", idx);
 			return PTR_ERR(page);
 		}
 		kaddr = kmap_atomic(page, KM_USER0);
diff -puN fs/ntfs/file.c~mm-make-read_cache_page-synchronous fs/ntfs/file.c
--- a/fs/ntfs/file.c~mm-make-read_cache_page-synchronous
+++ a/fs/ntfs/file.c
@@ -236,8 +236,7 @@ do_non_resident_extend:
 			err = PTR_ERR(page);
 			goto init_err_out;
 		}
-		wait_on_page_locked(page);
-		if (unlikely(!PageUptodate(page) || PageError(page))) {
+		if (unlikely(PageError(page))) {
 			page_cache_release(page);
 			err = -EIO;
 			goto init_err_out;
diff -puN fs/ntfs/super.c~mm-make-read_cache_page-synchronous fs/ntfs/super.c
--- a/fs/ntfs/super.c~mm-make-read_cache_page-synchronous
+++ a/fs/ntfs/super.c
@@ -2471,7 +2471,6 @@ static s64 get_nr_free_clusters(ntfs_vol
 	s64 nr_free = vol->nr_clusters;
 	u32 *kaddr;
 	struct address_space *mapping = vol->lcnbmp_ino->i_mapping;
-	filler_t *readpage = (filler_t*)mapping->a_ops->readpage;
 	struct page *page;
 	pgoff_t index, max_index;
 
@@ -2494,24 +2493,14 @@ static s64 get_nr_free_clusters(ntfs_vol
 		 * Read the page from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
 		 */
-		page = read_cache_page(mapping, index, (filler_t*)readpage,
-				NULL);
+		page = read_mapping_page(mapping, index, NULL);
 		/* Ignore pages which errored synchronously. */
 		if (IS_ERR(page)) {
-			ntfs_debug("Sync read_cache_page() error. Skipping "
+			ntfs_debug("read_mapping_page() error. Skipping "
 					"page (index 0x%lx).", index);
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		wait_on_page_locked(page);
-		/* Ignore pages which errored asynchronously. */
-		if (!PageUptodate(page)) {
-			ntfs_debug("Async read_cache_page() error. Skipping "
-					"page (index 0x%lx).", index);
-			page_cache_release(page);
-			nr_free -= PAGE_CACHE_SIZE * 8;
-			continue;
-		}
 		kaddr = (u32*)kmap_atomic(page, KM_USER0);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
@@ -2562,7 +2551,6 @@ static unsigned long __get_nr_free_mft_r
 {
 	u32 *kaddr;
 	struct address_space *mapping = vol->mftbmp_ino->i_mapping;
-	filler_t *readpage = (filler_t*)mapping->a_ops->readpage;
 	struct page *page;
 	pgoff_t index;
 
@@ -2576,21 +2564,11 @@ static unsigned long __get_nr_free_mft_r
 		 * Read the page from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
 		 */
-		page = read_cache_page(mapping, index, (filler_t*)readpage,
-				NULL);
+		page = read_mapping_page(mapping, index, NULL);
 		/* Ignore pages which errored synchronously. */
 		if (IS_ERR(page)) {
-			ntfs_debug("Sync read_cache_page() error. Skipping "
-					"page (index 0x%lx).", index);
-			nr_free -= PAGE_CACHE_SIZE * 8;
-			continue;
-		}
-		wait_on_page_locked(page);
-		/* Ignore pages which errored asynchronously. */
-		if (!PageUptodate(page)) {
-			ntfs_debug("Async read_cache_page() error. Skipping "
+			ntfs_debug("read_mapping_page() error. Skipping "
 					"page (index 0x%lx).", index);
-			page_cache_release(page);
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
diff -puN fs/ocfs2/symlink.c~mm-make-read_cache_page-synchronous fs/ocfs2/symlink.c
--- a/fs/ocfs2/symlink.c~mm-make-read_cache_page-synchronous
+++ a/fs/ocfs2/symlink.c
@@ -67,16 +67,9 @@ static char *ocfs2_page_getlink(struct d
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
 		goto sync_fail;
-	wait_on_page_locked(page);
-	if (!PageUptodate(page))
-		goto async_fail;
 	*ppage = page;
 	return kmap(page);
 
-async_fail:
-	page_cache_release(page);
-	return ERR_PTR(-EIO);
-
 sync_fail:
 	return (char*)page;
 }
diff -puN fs/partitions/check.c~mm-make-read_cache_page-synchronous fs/partitions/check.c
--- a/fs/partitions/check.c~mm-make-read_cache_page-synchronous
+++ a/fs/partitions/check.c
@@ -569,9 +569,6 @@ unsigned char *read_dev_sector(struct bl
 	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
 				 NULL);
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
-		if (!PageUptodate(page))
-			goto fail;
 		if (PageError(page))
 			goto fail;
 		p->v = page;
diff -puN fs/reiserfs/xattr.c~mm-make-read_cache_page-synchronous fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~mm-make-read_cache_page-synchronous
+++ a/fs/reiserfs/xattr.c
@@ -410,11 +410,7 @@ static struct page *reiserfs_get_page(st
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	page = read_mapping_page(mapping, n, NULL);
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
-
 		if (PageError(page))
 			goto fail;
 	}
diff -puN fs/sysv/dir.c~mm-make-read_cache_page-synchronous fs/sysv/dir.c
--- a/fs/sysv/dir.c~mm-make-read_cache_page-synchronous
+++ a/fs/sysv/dir.c
@@ -54,17 +54,9 @@ static struct page * dir_get_page(struct
 {
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
+	if (!IS_ERR(page))
 		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
-	}
 	return page;
-
-fail:
-	dir_put_page(page);
-	return ERR_PTR(-EIO);
 }
 
 static int sysv_readdir(struct file * filp, void * dirent, filldir_t filldir)
diff -puN fs/ufs/dir.c~mm-make-read_cache_page-synchronous fs/ufs/dir.c
--- a/fs/ufs/dir.c~mm-make-read_cache_page-synchronous
+++ a/fs/ufs/dir.c
@@ -180,13 +180,9 @@ fail:
 static struct page *ufs_get_page(struct inode *dir, unsigned long n)
 {
 	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_cache_page(mapping, n,
-				(filler_t*)mapping->a_ops->readpage, NULL);
+	struct page *page = read_mapping_page(mapping, n, NULL);
 	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
 		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
 		if (!PageChecked(page))
 			ufs_check_page(page);
 		if (PageError(page))
diff -puN fs/ufs/util.c~mm-make-read_cache_page-synchronous fs/ufs/util.c
--- a/fs/ufs/util.c~mm-make-read_cache_page-synchronous
+++ a/fs/ufs/util.c
@@ -251,13 +251,11 @@ struct page *ufs_get_locked_page(struct 
 
 	page = find_lock_page(mapping, index);
 	if (!page) {
-		page = read_cache_page(mapping, index,
-				       (filler_t*)mapping->a_ops->readpage,
-				       NULL);
+		page = read_mapping_page(mapping, index, NULL);
 
 		if (IS_ERR(page)) {
 			printk(KERN_ERR "ufs_change_blocknr: "
-			       "read_cache_page error: ino %lu, index: %lu\n",
+			       "read_mapping_page error: ino %lu, index: %lu\n",
 			       mapping->host->i_ino, index);
 			goto out;
 		}
diff -puN include/linux/pagemap.h~mm-make-read_cache_page-synchronous include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-make-read_cache_page-synchronous
+++ a/include/linux/pagemap.h
@@ -95,12 +95,23 @@ static inline struct page *grab_cache_pa
 
 extern struct page * grab_cache_page_nowait(struct address_space *mapping,
 				unsigned long index);
+extern struct page * read_cache_page_async(struct address_space *mapping,
+				unsigned long index, filler_t *filler,
+				void *data);
 extern struct page * read_cache_page(struct address_space *mapping,
 				unsigned long index, filler_t *filler,
 				void *data);
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
+static inline struct page *read_mapping_page_async(
+						struct address_space *mapping,
+					     unsigned long index, void *data)
+{
+	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
+	return read_cache_page_async(mapping, index, filler, data);
+}
+
 static inline struct page *read_mapping_page(struct address_space *mapping,
 					     unsigned long index, void *data)
 {
diff -puN mm/filemap.c~mm-make-read_cache_page-synchronous mm/filemap.c
--- a/mm/filemap.c~mm-make-read_cache_page-synchronous
+++ a/mm/filemap.c
@@ -1726,7 +1726,7 @@ int generic_file_readonly_mmap(struct fi
 EXPORT_SYMBOL(generic_file_mmap);
 EXPORT_SYMBOL(generic_file_readonly_mmap);
 
-static inline struct page *__read_cache_page(struct address_space *mapping,
+static struct page *__read_cache_page(struct address_space *mapping,
 				unsigned long index,
 				int (*filler)(void *,struct page*),
 				void *data)
@@ -1763,17 +1763,11 @@ repeat:
 	return page;
 }
 
-/**
- * read_cache_page - read into page cache, fill it if needed
- * @mapping:	the page's address_space
- * @index:	the page index
- * @filler:	function to perform the read
- * @data:	destination for read data
- *
- * Read into the page cache. If a page already exists,
- * and PageUptodate() is not set, try to fill the page.
+/*
+ * Same as read_cache_page, but don't wait for page to become unlocked
+ * after submitting it to the filler.
  */
-struct page *read_cache_page(struct address_space *mapping,
+struct page *read_cache_page_async(struct address_space *mapping,
 				unsigned long index,
 				int (*filler)(void *,struct page*),
 				void *data)
@@ -1805,6 +1799,39 @@ retry:
 		page = ERR_PTR(err);
 	}
  out:
+	mark_page_accessed(page);
+	return page;
+}
+EXPORT_SYMBOL(read_cache_page_async);
+
+/**
+ * read_cache_page - read into page cache, fill it if needed
+ * @mapping:	the page's address_space
+ * @index:	the page index
+ * @filler:	function to perform the read
+ * @data:	destination for read data
+ *
+ * Read into the page cache. If a page already exists, and PageUptodate() is
+ * not set, try to fill the page then wait for it to become unlocked.
+ *
+ * If the page does not get brought uptodate, return -EIO.
+ */
+struct page *read_cache_page(struct address_space *mapping,
+				unsigned long index,
+				int (*filler)(void *,struct page*),
+				void *data)
+{
+	struct page *page;
+
+	page = read_cache_page_async(mapping, index, filler, data);
+	if (IS_ERR(page))
+		goto out;
+	wait_on_page_locked(page);
+	if (!PageUptodate(page)) {
+		page_cache_release(page);
+		page = ERR_PTR(-EIO);
+	}
+ out:
 	return page;
 }
 EXPORT_SYMBOL(read_cache_page);
diff -puN mm/swapfile.c~mm-make-read_cache_page-synchronous mm/swapfile.c
--- a/mm/swapfile.c~mm-make-read_cache_page-synchronous
+++ a/mm/swapfile.c
@@ -1531,9 +1531,6 @@ asmlinkage long sys_swapon(const char __
 		error = PTR_ERR(page);
 		goto bad_swap;
 	}
-	wait_on_page_locked(page);
-	if (!PageUptodate(page))
-		goto bad_swap;
 	kmap(page);
 	swap_header = page_address(page);
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-more-rmap-checking.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
exec-fix-remove_arg_zero.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
