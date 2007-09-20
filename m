From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-unused-functions-and-kmem_cache.patch added to -mm tree
Date: Wed, 19 Sep 2007 22:51:41 -0700
Message-ID: <200709200551.l8K5pfeO030776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbXITFvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 01:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: remove unused functions and kmem_cache
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-unused-functions-and-kmem_cache.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: remove unused functions and kmem_cache
From: Michael Halcrow <mhalcrow@us.ibm.com>

The switch to read_write.c routines and the persistent file make a number of
functions unnecessary.  This patch removes them.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |  150 --------------
 fs/ecryptfs/ecryptfs_kernel.h |   21 --
 fs/ecryptfs/file.c            |   28 --
 fs/ecryptfs/main.c            |    5 
 fs/ecryptfs/mmap.c            |  336 --------------------------------
 5 files changed, 1 insertion(+), 539 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-remove-unused-functions-and-kmem_cache fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-remove-unused-functions-and-kmem_cache
+++ a/fs/ecryptfs/crypto.c
@@ -353,119 +353,6 @@ out:
 	return rc;
 }
 
-static void
-ecryptfs_extent_to_lwr_pg_idx_and_offset(unsigned long *lower_page_idx,
-					 int *byte_offset,
-					 struct ecryptfs_crypt_stat *crypt_stat,
-					 unsigned long extent_num)
-{
-	unsigned long lower_extent_num;
-	int extents_occupied_by_headers_at_front;
-	int bytes_occupied_by_headers_at_front;
-	int extent_offset;
-	int extents_per_page;
-
-	bytes_occupied_by_headers_at_front =
-		(crypt_stat->extent_size
-		 * crypt_stat->num_header_extents_at_front);
-	extents_occupied_by_headers_at_front =
-		( bytes_occupied_by_headers_at_front
-		  / crypt_stat->extent_size );
-	lower_extent_num = extents_occupied_by_headers_at_front + extent_num;
-	extents_per_page = PAGE_CACHE_SIZE / crypt_stat->extent_size;
-	(*lower_page_idx) = lower_extent_num / extents_per_page;
-	extent_offset = lower_extent_num % extents_per_page;
-	(*byte_offset) = extent_offset * crypt_stat->extent_size;
-	ecryptfs_printk(KERN_DEBUG, " * crypt_stat->extent_size = "
-			"[%d]\n", crypt_stat->extent_size);
-	ecryptfs_printk(KERN_DEBUG, " * crypt_stat->"
-			"num_header_extents_at_front = [%d]\n",
-			crypt_stat->num_header_extents_at_front);
-	ecryptfs_printk(KERN_DEBUG, " * extents_occupied_by_headers_at_"
-			"front = [%d]\n", extents_occupied_by_headers_at_front);
-	ecryptfs_printk(KERN_DEBUG, " * lower_extent_num = [0x%.16x]\n",
-			lower_extent_num);
-	ecryptfs_printk(KERN_DEBUG, " * extents_per_page = [%d]\n",
-			extents_per_page);
-	ecryptfs_printk(KERN_DEBUG, " * (*lower_page_idx) = [0x%.16x]\n",
-			(*lower_page_idx));
-	ecryptfs_printk(KERN_DEBUG, " * extent_offset = [%d]\n",
-			extent_offset);
-	ecryptfs_printk(KERN_DEBUG, " * (*byte_offset) = [%d]\n",
-			(*byte_offset));
-}
-
-static int ecryptfs_write_out_page(struct ecryptfs_page_crypt_context *ctx,
-				   struct page *lower_page,
-				   struct inode *lower_inode,
-				   int byte_offset_in_page, int bytes_to_write)
-{
-	int rc = 0;
-
-	if (ctx->mode == ECRYPTFS_PREPARE_COMMIT_MODE) {
-		rc = ecryptfs_commit_lower_page(lower_page, lower_inode,
-						ctx->param.lower_file,
-						byte_offset_in_page,
-						bytes_to_write);
-		if (rc) {
-			ecryptfs_printk(KERN_ERR, "Error calling lower "
-					"commit; rc = [%d]\n", rc);
-			goto out;
-		}
-	} else {
-		rc = ecryptfs_writepage_and_release_lower_page(lower_page,
-							       lower_inode,
-							       ctx->param.wbc);
-		if (rc) {
-			ecryptfs_printk(KERN_ERR, "Error calling lower "
-					"writepage(); rc = [%d]\n", rc);
-			goto out;
-		}
-	}
-out:
-	return rc;
-}
-
-static int ecryptfs_read_in_page(struct ecryptfs_page_crypt_context *ctx,
-				 struct page **lower_page,
-				 struct inode *lower_inode,
-				 unsigned long lower_page_idx,
-				 int byte_offset_in_page)
-{
-	int rc = 0;
-
-	if (ctx->mode == ECRYPTFS_PREPARE_COMMIT_MODE) {
-		/* TODO: Limit this to only the data extents that are
-		 * needed */
-		rc = ecryptfs_get_lower_page(lower_page, lower_inode,
-					     ctx->param.lower_file,
-					     lower_page_idx,
-					     byte_offset_in_page,
-					     (PAGE_CACHE_SIZE
-					      - byte_offset_in_page));
-		if (rc) {
-			ecryptfs_printk(
-				KERN_ERR, "Error attempting to grab, map, "
-				"and prepare_write lower page with index "
-				"[0x%.16x]; rc = [%d]\n", lower_page_idx, rc);
-			goto out;
-		}
-	} else {
-		*lower_page = grab_cache_page(lower_inode->i_mapping,
-					      lower_page_idx);
-		if (!(*lower_page)) {
-			rc = -EINVAL;
-			ecryptfs_printk(
-				KERN_ERR, "Error attempting to grab and map "
-				"lower page with index [0x%.16x]; rc = [%d]\n",
-				lower_page_idx, rc);
-			goto out;
-		}
-	}
-out:
-	return rc;
-}
-
 /**
  * ecryptfs_lower_offset_for_extent
  *
@@ -1305,43 +1192,6 @@ int ecryptfs_cipher_code_to_string(char 
 	return rc;
 }
 
-/**
- * ecryptfs_read_header_region
- * @data: The virtual address to write header region data into
- * @dentry: The lower dentry
- * @mnt: The lower VFS mount
- *
- * Returns zero on success; non-zero otherwise
- */
-static int ecryptfs_read_header_region(char *data, struct dentry *dentry,
-				       struct vfsmount *mnt)
-{
-	struct file *lower_file;
-	mm_segment_t oldfs;
-	int rc;
-
-	rc = ecryptfs_open_lower_file(&lower_file, dentry, mnt, O_RDONLY);
-	if (rc) {
-		printk(KERN_ERR
-		       "Error opening lower_file to read header region\n");
-		goto out;
-	}
-	lower_file->f_pos = 0;
-	oldfs = get_fs();
-	set_fs(get_ds());
-	rc = lower_file->f_op->read(lower_file, (char __user *)data,
-			      ECRYPTFS_DEFAULT_EXTENT_SIZE, &lower_file->f_pos);
-	set_fs(oldfs);
-	rc = ecryptfs_close_lower_file(lower_file);
-	if (rc) {
-		printk(KERN_ERR "Error closing lower_file\n");
-		goto out;
-	}
-	rc = 0;
-out:
-	return rc;
-}
-
 int ecryptfs_read_and_validate_header_region(char *data,
 					     struct inode *ecryptfs_inode)
 {
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-unused-functions-and-kmem_cache fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-unused-functions-and-kmem_cache
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -552,22 +552,7 @@ void ecryptfs_destroy_crypt_stat(struct 
 void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
-int ecryptfs_write_inode_size_to_metadata(struct inode *ecryptefs_inode);
-int ecryptfs_get_lower_page(struct page **lower_page, struct inode *lower_inode,
-			    struct file *lower_file,
-			    unsigned long lower_page_index, int byte_offset,
-			    int region_bytes);
-int
-ecryptfs_commit_lower_page(struct page *lower_page, struct inode *lower_inode,
-			   struct file *lower_file, int byte_offset,
-			   int region_size);
-int ecryptfs_copy_page_to_lower(struct page *page, struct inode *lower_inode,
-				struct file *lower_file);
-int ecryptfs_do_readpage(struct file *file, struct page *page,
-			 pgoff_t lower_page_index);
-int ecryptfs_writepage_and_release_lower_page(struct page *lower_page,
-					      struct inode *lower_inode,
-					      struct writeback_control *wbc);
+int ecryptfs_write_inode_size_to_metadata(struct inode *ecryptfs_inode);
 int ecryptfs_encrypt_page(struct page *page);
 int ecryptfs_decrypt_page(struct page *page);
 int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry);
@@ -591,10 +576,6 @@ int ecryptfs_truncate(struct dentry *den
 int ecryptfs_inode_test(struct inode *inode, void *candidate_lower_inode);
 int ecryptfs_inode_set(struct inode *inode, void *lower_inode);
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode);
-int ecryptfs_open_lower_file(struct file **lower_file,
-			     struct dentry *lower_dentry,
-			     struct vfsmount *lower_mnt, int flags);
-int ecryptfs_close_lower_file(struct file *lower_file);
 ssize_t ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 			  size_t size);
 ssize_t
diff -puN fs/ecryptfs/file.c~ecryptfs-remove-unused-functions-and-kmem_cache fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-remove-unused-functions-and-kmem_cache
+++ a/fs/ecryptfs/file.c
@@ -141,34 +141,6 @@ retry:
 
 struct kmem_cache *ecryptfs_file_info_cache;
 
-int ecryptfs_open_lower_file(struct file **lower_file,
-			     struct dentry *lower_dentry,
-			     struct vfsmount *lower_mnt, int flags)
-{
-	int rc = 0;
-
-	flags |= O_LARGEFILE;
-	dget(lower_dentry);
-	mntget(lower_mnt);
-	*lower_file = dentry_open(lower_dentry, lower_mnt, flags);
-	if (IS_ERR(*lower_file)) {
-		printk(KERN_ERR "Error opening lower file for lower_dentry "
-		       "[0x%p], lower_mnt [0x%p], and flags [0x%x]\n",
-		       lower_dentry, lower_mnt, flags);
-		rc = PTR_ERR(*lower_file);
-		*lower_file = NULL;
-		goto out;
-	}
-out:
-	return rc;
-}
-
-int ecryptfs_close_lower_file(struct file *lower_file)
-{
-	fput(lower_file);
-	return 0;
-}
-
 /**
  * ecryptfs_open
  * @inode: inode speciying file to open
diff -puN fs/ecryptfs/main.c~ecryptfs-remove-unused-functions-and-kmem_cache fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-remove-unused-functions-and-kmem_cache
+++ a/fs/ecryptfs/main.c
@@ -670,11 +670,6 @@ static struct ecryptfs_cache_info {
 		.size = PAGE_CACHE_SIZE,
 	},
 	{
-		.cache = &ecryptfs_lower_page_cache,
-		.name = "ecryptfs_lower_page_cache",
-		.size = PAGE_CACHE_SIZE,
-	},
-	{
 		.cache = &ecryptfs_key_record_cache,
 		.name = "ecryptfs_key_record_cache",
 		.size = sizeof(struct ecryptfs_key_record),
diff -puN fs/ecryptfs/mmap.c~ecryptfs-remove-unused-functions-and-kmem_cache fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-remove-unused-functions-and-kmem_cache
+++ a/fs/ecryptfs/mmap.c
@@ -57,113 +57,6 @@ struct page *ecryptfs_get1page(struct fi
 }
 
 /**
- * ecryptfs_fill_zeros
- * @file: The ecryptfs file
- * @new_length: The new length of the data in the underlying file;
- *              everything between the prior end of the file and the
- *              new end of the file will be filled with zero's.
- *              new_length must be greater than  current length
- *
- * Function for handling lseek-ing past the end of the file.
- *
- * This function does not support shrinking, only growing a file.
- *
- * Returns zero on success; non-zero otherwise.
- */
-int ecryptfs_fill_zeros(struct file *file, loff_t new_length)
-{
-	int rc = 0;
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
-	pgoff_t old_end_page_index = 0;
-	pgoff_t index = old_end_page_index;
-	int old_end_pos_in_page = -1;
-	pgoff_t new_end_page_index;
-	int new_end_pos_in_page;
-	loff_t cur_length = i_size_read(inode);
-
-	if (cur_length != 0) {
-		index = old_end_page_index =
-		    ((cur_length - 1) >> PAGE_CACHE_SHIFT);
-		old_end_pos_in_page = ((cur_length - 1) & ~PAGE_CACHE_MASK);
-	}
-	new_end_page_index = ((new_length - 1) >> PAGE_CACHE_SHIFT);
-	new_end_pos_in_page = ((new_length - 1) & ~PAGE_CACHE_MASK);
-	ecryptfs_printk(KERN_DEBUG, "old_end_page_index = [0x%.16x]; "
-			"old_end_pos_in_page = [%d]; "
-			"new_end_page_index = [0x%.16x]; "
-			"new_end_pos_in_page = [%d]\n",
-			old_end_page_index, old_end_pos_in_page,
-			new_end_page_index, new_end_pos_in_page);
-	if (old_end_page_index == new_end_page_index) {
-		/* Start and end are in the same page; we just need to
-		 * set a portion of the existing page to zero's */
-		rc = ecryptfs_write_zeros(file, index,
-					  (old_end_pos_in_page + 1),
-					  (new_end_pos_in_page
-					   - old_end_pos_in_page));
-		if (rc)
-			ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros("
-					"file=[%p], "
-					"index=[0x%.16x], "
-					"old_end_pos_in_page=[d], "
-					"(PAGE_CACHE_SIZE - new_end_pos_in_page"
-					"=[%d]"
-					")=[d]) returned [%d]\n", file, index,
-					old_end_pos_in_page,
-					new_end_pos_in_page,
-					(PAGE_CACHE_SIZE - new_end_pos_in_page),
-					rc);
-		goto out;
-	}
-	/* Fill the remainder of the previous last page with zeros */
-	rc = ecryptfs_write_zeros(file, index, (old_end_pos_in_page + 1),
-			 ((PAGE_CACHE_SIZE - 1) - old_end_pos_in_page));
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros(file=[%p], "
-				"index=[0x%.16x], old_end_pos_in_page=[d], "
-				"(PAGE_CACHE_SIZE - old_end_pos_in_page)=[d]) "
-				"returned [%d]\n", file, index,
-				old_end_pos_in_page,
-				(PAGE_CACHE_SIZE - old_end_pos_in_page), rc);
-		goto out;
-	}
-	index++;
-	while (index < new_end_page_index) {
-		/* Fill all intermediate pages with zeros */
-		rc = ecryptfs_write_zeros(file, index, 0, PAGE_CACHE_SIZE);
-		if (rc) {
-			ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros("
-					"file=[%p], "
-					"index=[0x%.16x], "
-					"old_end_pos_in_page=[d], "
-					"(PAGE_CACHE_SIZE - new_end_pos_in_page"
-					"=[%d]"
-					")=[d]) returned [%d]\n", file, index,
-					old_end_pos_in_page,
-					new_end_pos_in_page,
-					(PAGE_CACHE_SIZE - new_end_pos_in_page),
-					rc);
-			goto out;
-		}
-		index++;
-	}
-	/* Fill the portion at the beginning of the last new page with
-	 * zero's */
-	rc = ecryptfs_write_zeros(file, index, 0, (new_end_pos_in_page + 1));
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros(file="
-				"[%p], index=[0x%.16x], 0, "
-				"new_end_pos_in_page=[%d]"
-				"returned [%d]\n", file, index,
-				new_end_pos_in_page, rc);
-		goto out;
-	}
-out:
-	return rc;
-}
-
-/**
  * ecryptfs_writepage
  * @page: Page that is locked before this call is made
  *
@@ -187,58 +80,6 @@ out:
 }
 
 /**
- * Reads the data from the lower file file at index lower_page_index
- * and copies that data into page.
- *
- * @param page	Page to fill
- * @param lower_page_index Index of the page in the lower file to get
- */
-int ecryptfs_do_readpage(struct file *file, struct page *page,
-			 pgoff_t lower_page_index)
-{
-	int rc;
-	struct dentry *dentry;
-	struct file *lower_file;
-	struct dentry *lower_dentry;
-	struct inode *inode;
-	struct inode *lower_inode;
-	char *page_data;
-	struct page *lower_page = NULL;
-	char *lower_page_data;
-	const struct address_space_operations *lower_a_ops;
-
-	dentry = file->f_path.dentry;
-	lower_file = ecryptfs_file_to_lower(file);
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	inode = dentry->d_inode;
-	lower_inode = ecryptfs_inode_to_lower(inode);
-	lower_a_ops = lower_inode->i_mapping->a_ops;
-	lower_page = read_cache_page(lower_inode->i_mapping, lower_page_index,
-				     (filler_t *)lower_a_ops->readpage,
-				     (void *)lower_file);
-	if (IS_ERR(lower_page)) {
-		rc = PTR_ERR(lower_page);
-		lower_page = NULL;
-		ecryptfs_printk(KERN_ERR, "Error reading from page cache\n");
-		goto out;
-	}
-	page_data = kmap_atomic(page, KM_USER0);
-	lower_page_data = kmap_atomic(lower_page, KM_USER1);
-	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
-	kunmap_atomic(lower_page_data, KM_USER1);
-	kunmap_atomic(page_data, KM_USER0);
-	flush_dcache_page(page);
-	rc = 0;
-out:
-	if (likely(lower_page))
-		page_cache_release(lower_page);
-	if (rc == 0)
-		SetPageUptodate(page);
-	else
-		ClearPageUptodate(page);
-	return rc;
-}
-/**
  *   Header Extent:
  *     Octets 0-7:        Unencrypted file size (big-endian)
  *     Octets 8-15:       eCryptfs special marker
@@ -415,27 +256,6 @@ out:
 	return 0;
 }
 
-/**
- * eCryptfs does not currently support holes. When writing after a
- * seek past the end of the file, eCryptfs fills in 0's through to the
- * current location. The code to fill in the 0's to all the
- * intermediate pages calls ecryptfs_prepare_write_no_truncate().
- */
-static int
-ecryptfs_prepare_write_no_truncate(struct file *file, struct page *page,
-				   unsigned from, unsigned to)
-{
-	int rc = 0;
-
-	if (from == 0 && to == PAGE_CACHE_SIZE)
-		goto out;	/* If we are writing a full page, it will be
-				   up to date. */
-	if (!PageUptodate(page))
-		rc = ecryptfs_do_readpage(file, page, page->index);
-out:
-	return rc;
-}
-
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
@@ -469,30 +289,6 @@ out:
 	return rc;
 }
 
-int ecryptfs_writepage_and_release_lower_page(struct page *lower_page,
-					      struct inode *lower_inode,
-					      struct writeback_control *wbc)
-{
-	int rc = 0;
-
-	rc = lower_inode->i_mapping->a_ops->writepage(lower_page, wbc);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error calling lower writepage(); "
-				"rc = [%d]\n", rc);
-		goto out;
-	}
-	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
-	page_cache_release(lower_page);
-out:
-	return rc;
-}
-
-static void ecryptfs_release_lower_page(struct page *lower_page)
-{
-	unlock_page(lower_page);
-	page_cache_release(lower_page);
-}
-
 /**
  * ecryptfs_write_inode_size_to_header
  *
@@ -579,90 +375,6 @@ int ecryptfs_write_inode_size_to_metadat
 		return ecryptfs_write_inode_size_to_header(ecryptfs_inode);
 }
 
-int ecryptfs_get_lower_page(struct page **lower_page, struct inode *lower_inode,
-			    struct file *lower_file,
-			    unsigned long lower_page_index, int byte_offset,
-			    int region_bytes)
-{
-	int rc = 0;
-
-	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
-	if (!(*lower_page)) {
-		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "Error attempting to grab "
-				"lower page with index [0x%.16x]\n",
-				lower_page_index);
-		goto out;
-	}
-	rc = lower_inode->i_mapping->a_ops->prepare_write(lower_file,
-							  (*lower_page),
-							  byte_offset,
-							  region_bytes);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "prepare_write for "
-			"lower_page_index = [0x%.16x] failed; rc = "
-			"[%d]\n", lower_page_index, rc);
-		ecryptfs_release_lower_page(*lower_page);
-		(*lower_page) = NULL;
-	}
-out:
-	return rc;
-}
-
-/**
- * ecryptfs_commit_lower_page
- *
- * Returns zero on success; non-zero on error
- */
-int
-ecryptfs_commit_lower_page(struct page *lower_page, struct inode *lower_inode,
-			   struct file *lower_file, int byte_offset,
-			   int region_size)
-{
-	int rc = 0;
-
-	rc = lower_inode->i_mapping->a_ops->commit_write(
-		lower_file, lower_page, byte_offset, region_size);
-	if (rc < 0) {
-		ecryptfs_printk(KERN_ERR,
-				"Error committing write; rc = [%d]\n", rc);
-	} else
-		rc = 0;
-	ecryptfs_release_lower_page(lower_page);
-	return rc;
-}
-
-/**
- * ecryptfs_copy_page_to_lower
- *
- * Used for plaintext pass-through; no page index interpolation
- * required.
- */
-int ecryptfs_copy_page_to_lower(struct page *page, struct inode *lower_inode,
-				struct file *lower_file)
-{
-	int rc = 0;
-	struct page *lower_page;
-
-	rc = ecryptfs_get_lower_page(&lower_page, lower_inode, lower_file,
-				     page->index, 0, PAGE_CACHE_SIZE);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error attempting to get page "
-				"at index [0x%.16x]\n", page->index);
-		goto out;
-	}
-	/* TODO: aops */
-	memcpy((char *)page_address(lower_page), page_address(page),
-	       PAGE_CACHE_SIZE);
-	rc = ecryptfs_commit_lower_page(lower_page, lower_inode, lower_file,
-					0, PAGE_CACHE_SIZE);
-	if (rc)
-		ecryptfs_printk(KERN_ERR, "Error attempting to commit page "
-				"at index [0x%.16x]\n", page->index);
-out:
-	return rc;
-}
-
 /**
  * ecryptfs_commit_write
  * @file: The eCryptfs file object
@@ -720,54 +432,6 @@ out:
 	return rc;
 }
 
-/**
- * ecryptfs_write_zeros
- * @file: The ecryptfs file
- * @index: The index in which we are writing
- * @start: The position after the last block of data
- * @num_zeros: The number of zeros to write
- *
- * Write a specified number of zero's to a page.
- *
- * (start + num_zeros) must be less than or equal to PAGE_CACHE_SIZE
- */
-int
-ecryptfs_write_zeros(struct file *file, pgoff_t index, int start, int num_zeros)
-{
-	int rc = 0;
-	struct page *tmp_page;
-
-	tmp_page = ecryptfs_get1page(file, index);
-	if (IS_ERR(tmp_page)) {
-		ecryptfs_printk(KERN_ERR, "Error getting page at index "
-				"[0x%.16x]\n", index);
-		rc = PTR_ERR(tmp_page);
-		goto out;
-	}
-	rc = ecryptfs_prepare_write_no_truncate(file, tmp_page, start,
-						(start + num_zeros));
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error preparing to write zero's "
-				"to page at index [0x%.16x]\n",
-				index);
-		page_cache_release(tmp_page);
-		goto out;
-	}
-	zero_user_page(tmp_page, start, num_zeros, KM_USER0);
-	rc = ecryptfs_commit_write(file, tmp_page, start, start + num_zeros);
-	if (rc < 0) {
-		ecryptfs_printk(KERN_ERR, "Error attempting to write zero's "
-				"to remainder of page at index [0x%.16x]\n",
-				index);
-		page_cache_release(tmp_page);
-		goto out;
-	}
-	rc = 0;
-	page_cache_release(tmp_page);
-out:
-	return rc;
-}
-
 static sector_t ecryptfs_bmap(struct address_space *mapping, sector_t block)
 {
 	int rc = 0;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
ecryptfs-use-generic_file_splice_read.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-assignments-in-if-statements.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
