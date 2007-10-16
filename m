From: akpm@linux-foundation.org
Subject: - fs-remove-some-aop_truncated_page.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:37 -0700
Message-ID: <200710162033.l9GKXbPT014811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965451AbXJPVzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mark.fasheh@oracle.com, mhalcrow@us.ibm.com, michal.k.k.piotrowski@gmail.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs: remove some AOP_TRUNCATED_PAGE
has been removed from the -mm tree.  Its filename was
     fs-remove-some-aop_truncated_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: remove some AOP_TRUNCATED_PAGE
From: Nick Piggin <npiggin@suse.de>

prepare/commit_write no longer returns AOP_TRUNCATED_PAGE since OCFS2 and
GFS2 were converted to the new aops, so we can make some simplifications
for that.

[michal.k.k.piotrowski@gmail.com: fix warning]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    6 ----
 fs/ecryptfs/mmap.c                |   40 +++++++---------------------
 include/linux/fs.h                |    2 -
 mm/filemap.c                      |   16 ++---------
 4 files changed, 16 insertions(+), 48 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~fs-remove-some-aop_truncated_page Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~fs-remove-some-aop_truncated_page
+++ a/Documentation/filesystems/vfs.txt
@@ -621,11 +621,7 @@ struct address_space_operations {
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
@@ -446,11 +446,9 @@ out:
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
 
@@ -471,7 +469,6 @@ static int ecryptfs_write_inode_size_to_
 	const struct address_space_operations *lower_a_ops;
 	u64 file_size;
 
-retry:
 	header_page = grab_cache_page(lower_inode->i_mapping, 0);
 	if (!header_page) {
 		ecryptfs_printk(KERN_ERR, "grab_cache_page for "
@@ -482,11 +479,7 @@ retry:
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
@@ -500,11 +493,7 @@ retry:
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
@@ -593,7 +582,6 @@ int ecryptfs_get_lower_page(struct page 
 {
 	int rc = 0;
 
-retry:
 	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
 	if (!(*lower_page)) {
 		rc = -EINVAL;
@@ -607,16 +595,11 @@ retry:
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
@@ -632,19 +615,16 @@ ecryptfs_commit_lower_page(struct page *
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
@@ -381,7 +381,7 @@ struct iattr {
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
@@ -1898,13 +1898,10 @@ again:
 
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
@@ -1931,7 +1928,6 @@ int pagecache_write_end(struct file *fil
 		unlock_page(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
-		BUG_ON(ret == AOP_TRUNCATED_PAGE); /* can't deal with */
 
 		if (ret < 0) {
 			if (pos + len > inode->i_size)
@@ -2142,7 +2138,7 @@ static ssize_t generic_perform_write_2co
 		flush_dcache_page(page);
 
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
-		if (unlikely(status < 0 || status == AOP_TRUNCATED_PAGE))
+		if (unlikely(status < 0))
 			goto fs_write_aop_error;
 		if (unlikely(status > 0)) /* filesystem did partial write */
 			copied = min_t(size_t, copied, status);
@@ -2162,8 +2158,7 @@ static ssize_t generic_perform_write_2co
 		continue;
 
 fs_write_aop_error:
-		if (status != AOP_TRUNCATED_PAGE)
-			unlock_page(page);
+		unlock_page(page);
 		page_cache_release(page);
 		if (src_page)
 			page_cache_release(src_page);
@@ -2175,10 +2170,7 @@ fs_write_aop_error:
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

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
