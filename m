From: akpm@linux-foundation.org
Subject: + fs-remove-some-aop_truncated_page.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:30:27 -0700
Message-ID: <200706282230.l5SMURXJ002992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759668AbXF1Wau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, mark.fasheh@oracle.com, mhalcrow@us.ibm.com, swhiteho@redhat.com


The patch titled
     fs: remove some AOP_TRUNCATED_PAGE
has been added to the -mm tree.  Its filename is
     fs-remove-some-aop_truncated_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: remove some AOP_TRUNCATED_PAGE
From: Nick Piggin <npiggin@suse.de>

prepare/commit_write no longer returns AOP_TRUNCATED_PAGE since OCFS2 and
GFS2 were converted to the new aops, so we can make some simplifications
for that.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    6 ----
 fs/ecryptfs/mmap.c                |   39 +++++++---------------------
 include/linux/fs.h                |    2 -
 mm/filemap.c                      |   16 ++---------
 4 files changed, 16 insertions(+), 47 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~fs-remove-some-aop_truncated_page Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~fs-remove-some-aop_truncated_page
+++ a/Documentation/filesystems/vfs.txt
@@ -617,11 +617,7 @@ struct address_space_operations {
   	any basic-blocks on storage, then those blocks should be
   	pre-read (if they haven't been read already) so that the
   	updated blocks can be written out properly.
-	The page will be locked.  If prepare_write wants to unlock the
-  	page it, like readpage, may do so and return
-  	AOP_TRUNCATED_PAGE.
-	In this case the prepare_write will be retried one the lock is
-  	regained.
+	The page will be locked.
 
 	Note: the page _must not_ be marked uptodate in this function
 	(or anywhere else) unless it actually is uptodate right now. As
diff -puN fs/ecryptfs/mmap.c~fs-remove-some-aop_truncated_page fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~fs-remove-some-aop_truncated_page
+++ a/fs/ecryptfs/mmap.c
@@ -447,11 +447,9 @@ out:
 	return rc;
 }
 
-static
-void ecryptfs_release_lower_page(struct page *lower_page, int page_locked)
+static void ecryptfs_release_lower_page(struct page *lower_page)
 {
-	if (page_locked)
-		unlock_page(lower_page);
+	unlock_page(lower_page);
 	page_cache_release(lower_page);
 }
 
@@ -472,7 +470,6 @@ static int ecryptfs_write_inode_size_to_
 	const struct address_space_operations *lower_a_ops;
 	u64 file_size;
 
-retry:
 	header_page = grab_cache_page(lower_inode->i_mapping, 0);
 	if (!header_page) {
 		ecryptfs_printk(KERN_ERR, "grab_cache_page for "
@@ -483,11 +480,7 @@ retry:
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
 	if (rc) {
-		if (rc == AOP_TRUNCATED_PAGE) {
-			ecryptfs_release_lower_page(header_page, 0);
-			goto retry;
-		} else
-			ecryptfs_release_lower_page(header_page, 1);
+		ecryptfs_release_lower_page(header_page);
 		goto out;
 	}
 	file_size = (u64)i_size_read(inode);
@@ -501,11 +494,7 @@ retry:
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
 				"write\n");
-	if (rc == AOP_TRUNCATED_PAGE) {
-		ecryptfs_release_lower_page(header_page, 0);
-		goto retry;
-	} else
-		ecryptfs_release_lower_page(header_page, 1);
+	ecryptfs_release_lower_page(header_page);
 	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty_sync(inode);
 out:
@@ -608,16 +597,11 @@ retry:
 							  byte_offset,
 							  region_bytes);
 	if (rc) {
-		if (rc == AOP_TRUNCATED_PAGE) {
-			ecryptfs_release_lower_page(*lower_page, 0);
-			goto retry;
-		} else {
-			ecryptfs_printk(KERN_ERR, "prepare_write for "
-				"lower_page_index = [0x%.16x] failed; rc = "
-				"[%d]\n", lower_page_index, rc);
-			ecryptfs_release_lower_page(*lower_page, 1);
-			(*lower_page) = NULL;
-		}
+		ecryptfs_printk(KERN_ERR, "prepare_write for "
+			"lower_page_index = [0x%.16x] failed; rc = "
+			"[%d]\n", lower_page_index, rc);
+		ecryptfs_release_lower_page(*lower_page);
+		(*lower_page) = NULL;
 	}
 out:
 	return rc;
@@ -633,19 +617,16 @@ ecryptfs_commit_lower_page(struct page *
 			   struct file *lower_file, int byte_offset,
 			   int region_size)
 {
-	int page_locked = 1;
 	int rc = 0;
 
 	rc = lower_inode->i_mapping->a_ops->commit_write(
 		lower_file, lower_page, byte_offset, region_size);
-	if (rc == AOP_TRUNCATED_PAGE)
-		page_locked = 0;
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR,
 				"Error committing write; rc = [%d]\n", rc);
 	} else
 		rc = 0;
-	ecryptfs_release_lower_page(lower_page, page_locked);
+	ecryptfs_release_lower_page(lower_page);
 	return rc;
 }
 
diff -puN include/linux/fs.h~fs-remove-some-aop_truncated_page include/linux/fs.h
--- a/include/linux/fs.h~fs-remove-some-aop_truncated_page
+++ a/include/linux/fs.h
@@ -378,7 +378,7 @@ struct iattr {
  *  			trying again.  The aop will be taking reasonable
  *  			precautions not to livelock.  If the caller held a page
  *  			reference, it should drop it before retrying.  Returned
- *  			by readpage(), prepare_write(), and commit_write().
+ *  			by readpage().
  *
  * address_space_operation functions return these large constants to indicate
  * special semantics to the caller.  These are much larger than the bytes in a
diff -puN mm/filemap.c~fs-remove-some-aop_truncated_page mm/filemap.c
--- a/mm/filemap.c~fs-remove-some-aop_truncated_page
+++ a/mm/filemap.c
@@ -1938,13 +1938,10 @@ again:
 
 		ret = aops->prepare_write(file, page, offset, offset+len);
 		if (ret) {
-			if (ret != AOP_TRUNCATED_PAGE)
-				unlock_page(page);
+			unlock_page(page);
 			page_cache_release(page);
 			if (pos + len > inode->i_size)
 				vmtruncate(inode, inode->i_size);
-			if (ret == AOP_TRUNCATED_PAGE)
-				goto again;
 		}
 		return ret;
 	}
@@ -1969,7 +1966,6 @@ int pagecache_write_end(struct file *fil
 		ret = aops->commit_write(file, page, offset, offset+len);
 		unlock_page(page);
 		page_cache_release(page);
-		BUG_ON(ret == AOP_TRUNCATED_PAGE); /* can't deal with */
 
 		if (ret < 0) {
 			if (pos + len > inode->i_size)
@@ -2180,7 +2176,7 @@ static ssize_t generic_perform_write_2co
 		flush_dcache_page(page);
 
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
-		if (unlikely(status < 0 || status == AOP_TRUNCATED_PAGE))
+		if (unlikely(status < 0))
 			goto fs_write_aop_error;
 		if (unlikely(status > 0)) /* filesystem did partial write */
 			copied = min_t(size_t, copied, status);
@@ -2200,8 +2196,7 @@ static ssize_t generic_perform_write_2co
 		continue;
 
 fs_write_aop_error:
-		if (status != AOP_TRUNCATED_PAGE)
-			unlock_page(page);
+		unlock_page(page);
 		page_cache_release(page);
 		if (src_page)
 			page_cache_release(src_page);
@@ -2213,10 +2208,7 @@ fs_write_aop_error:
 		 */
 		if (pos + bytes > inode->i_size)
 			vmtruncate(inode, inode->i_size);
-		if (status == AOP_TRUNCATED_PAGE)
-			continue;
-		else
-			break;
+		break;
 	} while (iov_iter_count(i));
 
 	return written ? written : status;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fix-read-truncate-race.patch
fs-remove-some-aop_truncated_page.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
