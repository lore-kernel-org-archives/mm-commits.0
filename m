From: akpm@linux-foundation.org
Subject: - ecryptfs-clean-up-page-flag-handling.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:12 -0700
Message-ID: <200710162041.l9GKfCgK015768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935920AbXJPVHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: clean up page flag handling
has been removed from the -mm tree.  Its filename was
     ecryptfs-clean-up-page-flag-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: clean up page flag handling
From: Michael Halcrow <mhalcrow@us.ibm.com>

The functions that eventually call down to ecryptfs_read_lower(),
ecryptfs_decrypt_page(), and ecryptfs_copy_up_encrypted_with_header()
should have the responsibility of managing the page Uptodate
status. This patch gets rid of some of the ugliness that resulted from
trying to push some of the page flag setting too far down the stack.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   12 ++++--------
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 fs/ecryptfs/mmap.c            |   28 +++++++++++++++++++++-------
 fs/ecryptfs/read_write.c      |   30 +++++++++++++-----------------
 4 files changed, 39 insertions(+), 33 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-clean-up-page-flag-handling fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-clean-up-page-flag-handling
+++ a/fs/ecryptfs/crypto.c
@@ -605,14 +605,14 @@ int ecryptfs_decrypt_page(struct page *p
 			printk(KERN_ERR "%s: Error attempting to copy "
 			       "page at index [%ld]\n", __FUNCTION__,
 			       page->index);
-		goto out_clear_uptodate;
+		goto out;
 	}
 	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
 	if (!enc_extent_virt) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
 				"encrypted extent\n");
-		goto out_clear_uptodate;
+		goto out;
 	}
 	enc_extent_page = virt_to_page(enc_extent_virt);
 	for (extent_offset = 0;
@@ -631,21 +631,17 @@ int ecryptfs_decrypt_page(struct page *p
 			ecryptfs_printk(KERN_ERR, "Error attempting "
 					"to read lower page; rc = [%d]"
 					"\n", rc);
-			goto out_clear_uptodate;
+			goto out;
 		}
 		rc = ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page,
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
 			       "rc = [%d]\n", __FUNCTION__, rc);
-			goto out_clear_uptodate;
+			goto out;
 		}
 		extent_offset++;
 	}
-	SetPageUptodate(page);
-	goto out;
-out_clear_uptodate:
-	ClearPageUptodate(page);
 out:
 	kfree(enc_extent_virt);
 	return rc;
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-clean-up-page-flag-handling fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-clean-up-page-flag-handling
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -648,6 +648,6 @@ int ecryptfs_read_lower_page_segment(str
 				     struct inode *ecryptfs_inode);
 int ecryptfs_read(char *data, loff_t offset, size_t size,
 		  struct file *ecryptfs_file);
-struct page *ecryptfs_get1page(struct file *file, loff_t index);
+struct page *ecryptfs_get_locked_page(struct file *file, loff_t index);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN fs/ecryptfs/mmap.c~ecryptfs-clean-up-page-flag-handling fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-clean-up-page-flag-handling
+++ a/fs/ecryptfs/mmap.c
@@ -37,23 +37,27 @@
 struct kmem_cache *ecryptfs_lower_page_cache;
 
 /**
- * ecryptfs_get1page
+ * ecryptfs_get_locked_page
  *
  * Get one page from cache or lower f/s, return error otherwise.
  *
- * Returns unlocked and up-to-date page (if ok), with increased
+ * Returns locked and up-to-date page (if ok), with increased
  * refcnt.
  */
-struct page *ecryptfs_get1page(struct file *file, loff_t index)
+struct page *ecryptfs_get_locked_page(struct file *file, loff_t index)
 {
 	struct dentry *dentry;
 	struct inode *inode;
 	struct address_space *mapping;
+	struct page *page;
 
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 	mapping = inode->i_mapping;
-	return read_mapping_page(mapping, index, (void *)file);
+	page = read_mapping_page(mapping, index, (void *)file);
+	if (!IS_ERR(page))
+		lock_page(page);
+	return page;
 }
 
 /**
@@ -146,12 +150,10 @@ ecryptfs_copy_up_encrypted_with_header(s
 			kunmap_atomic(page_virt, KM_USER0);
 			flush_dcache_page(page);
 			if (rc) {
-				ClearPageUptodate(page);
 				printk(KERN_ERR "%s: Error reading xattr "
 				       "region; rc = [%d]\n", __FUNCTION__, rc);
 				goto out;
 			}
-			SetPageUptodate(page);
 		} else {
 			/* This is an encrypted data extent */
 			loff_t lower_offset =
@@ -232,6 +234,10 @@ static int ecryptfs_readpage(struct file
 		}
 	}
 out:
+	if (rc)
+		ClearPageUptodate(page);
+	else
+		SetPageUptodate(page);
 	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
 			page->index);
 	unlock_page(page);
@@ -265,10 +271,18 @@ static int ecryptfs_prepare_write(struct
 	if (from == 0 && to == PAGE_CACHE_SIZE)
 		goto out;	/* If we are writing a full page, it will be
 				   up to date. */
-	if (!PageUptodate(page))
+	if (!PageUptodate(page)) {
 		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
 						      PAGE_CACHE_SIZE,
 						      page->mapping->host);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attemping to read lower "
+			       "page segment; rc = [%d]\n", __FUNCTION__, rc);
+			ClearPageUptodate(page);
+			goto out;
+		} else
+			SetPageUptodate(page);
+	}
 	if (page->index != 0) {
 		loff_t end_of_prev_pg_pos =
 			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
diff -puN fs/ecryptfs/read_write.c~ecryptfs-clean-up-page-flag-handling fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~ecryptfs-clean-up-page-flag-handling
+++ a/fs/ecryptfs/read_write.c
@@ -142,8 +142,8 @@ int ecryptfs_write(struct file *ecryptfs
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;
 		}
-		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
-						  ecryptfs_page_idx);
+		ecryptfs_page = ecryptfs_get_locked_page(ecryptfs_file,
+							 ecryptfs_page_idx);
 		if (IS_ERR(ecryptfs_page)) {
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
@@ -161,6 +161,7 @@ int ecryptfs_write(struct file *ecryptfs
 				printk(KERN_ERR "%s: Error decrypting "
 				       "page; rc = [%d]\n",
 				       __FUNCTION__, rc);
+				ClearPageUptodate(ecryptfs_page);
 				page_cache_release(ecryptfs_page);
 				goto out;
 			}
@@ -180,14 +181,15 @@ int ecryptfs_write(struct file *ecryptfs
 		}
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
 		flush_dcache_page(ecryptfs_page);
+		SetPageUptodate(ecryptfs_page);
+		unlock_page(ecryptfs_page);
 		rc = ecryptfs_encrypt_page(ecryptfs_page);
+		page_cache_release(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
-			page_cache_release(ecryptfs_page);
 			goto out;
 		}
-		page_cache_release(ecryptfs_page);
 		pos += num_bytes;
 	}
 	if ((offset + size) > ecryptfs_file_size) {
@@ -225,7 +227,6 @@ int ecryptfs_read_lower(char *data, loff
 		ecryptfs_inode_to_private(ecryptfs_inode);
 	ssize_t octets_read;
 	mm_segment_t fs_save;
-	size_t i;
 	int rc = 0;
 
 	mutex_lock(&inode_info->lower_file_mutex);
@@ -242,16 +243,6 @@ int ecryptfs_read_lower(char *data, loff
 		rc = -EINVAL;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
-	for (i = 0; i < size; i += PAGE_CACHE_SIZE) {
-		struct page *data_page;
-
-		data_page = virt_to_page(data + i);
-		flush_dcache_page(data_page);
-		if (rc)
-			ClearPageUptodate(data_page);
-		else
-			SetPageUptodate(data_page);
-	}
 	return rc;
 }
 
@@ -283,6 +274,7 @@ int ecryptfs_read_lower_page_segment(str
 	virt = kmap(page_for_ecryptfs);
 	rc = ecryptfs_read_lower(virt, offset, size, ecryptfs_inode);
 	kunmap(page_for_ecryptfs);
+	flush_dcache_page(page_for_ecryptfs);
 	return rc;
 }
 
@@ -331,8 +323,8 @@ int ecryptfs_read(char *data, loff_t off
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
-		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
-						  ecryptfs_page_idx);
+		ecryptfs_page = ecryptfs_get_locked_page(ecryptfs_file,
+							 ecryptfs_page_idx);
 		if (IS_ERR(ecryptfs_page)) {
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
@@ -345,6 +337,7 @@ int ecryptfs_read(char *data, loff_t off
 		if (rc) {
 			printk(KERN_ERR "%s: Error decrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			ClearPageUptodate(ecryptfs_page);
 			page_cache_release(ecryptfs_page);
 			goto out;
 		}
@@ -353,6 +346,9 @@ int ecryptfs_read(char *data, loff_t off
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
 		       num_bytes);
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		flush_dcache_page(ecryptfs_page);
+		SetPageUptodate(ecryptfs_page);
+		unlock_page(ecryptfs_page);
 		page_cache_release(ecryptfs_page);
 		pos += num_bytes;
 		data_offset += num_bytes;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
