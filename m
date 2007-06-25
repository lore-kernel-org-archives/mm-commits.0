From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-write-zeros-behavior.patch added to -mm tree
Date: Mon, 25 Jun 2007 11:15:56 -0700
Message-ID: <200706251815.l5PIFvTm007613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbXFYSQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 14:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix write zeros behavior
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-write-zeros-behavior.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix write zeros behavior
From: Michael Halcrow <mhalcrow@us.ibm.com>

This patch fixes the processes involved in wiping regions of the data during
truncate and write events, fixing a kernel hang in 2.6.22-rc4 while assuring
that zero values are written out to the appropriate locations during events in
which the i_size will change.

The range passed to ecryptfs_truncate() from ecryptfs_prepare_write() includes
the page that is the object of ecryptfs_prepare_write().  This leads to a
kernel hang as read_cache_page() is executed on the same page in the
ecryptfs_truncate() execution path.  This patch remedies this by limiting the
range passed to ecryptfs_truncate() so as to exclude the page that is the
object of ecryptfs_prepare_write(); it also adds code to
ecryptfs_prepare_write() to zero out the region of its own page when writing
past the i_size position.  This patch also modifies ecryptfs_truncate() so
that when a file is truncated to a smaller size, eCryptfs will zero out the
contents of the new last page from the new size through to the end of the last
page.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    2 +
 fs/ecryptfs/inode.c           |   19 +++++++++++
 fs/ecryptfs/mmap.c            |   53 +++++++++++++++++---------------
 3 files changed, 50 insertions(+), 24 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-fix-write-zeros-behavior fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-fix-write-zeros-behavior
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -580,5 +580,7 @@ void
 ecryptfs_write_header_metadata(char *virt,
 			       struct ecryptfs_crypt_stat *crypt_stat,
 			       size_t *written);
+int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
+			 int num_zeros);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN fs/ecryptfs/inode.c~ecryptfs-fix-write-zeros-behavior fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-fix-write-zeros-behavior
+++ a/fs/ecryptfs/inode.c
@@ -800,6 +800,25 @@ int ecryptfs_truncate(struct dentry *den
 			goto out_fput;
 		}
 	} else { /* new_length < i_size_read(inode) */
+		pgoff_t index = 0;
+		int end_pos_in_page = -1;
+
+		if (new_length != 0) {
+			index = ((new_length - 1) >> PAGE_CACHE_SHIFT);
+			end_pos_in_page = ((new_length - 1) & ~PAGE_CACHE_MASK);
+		}
+		if (end_pos_in_page != (PAGE_CACHE_SIZE - 1)) {
+			if ((rc = ecryptfs_write_zeros(&fake_ecryptfs_file,
+						       index,
+						       (end_pos_in_page + 1),
+						       ((PAGE_CACHE_SIZE - 1)
+							- end_pos_in_page)))) {
+				printk(KERN_ERR "Error attempting to zero out "
+				       "the remainder of the end page on "
+				       "reducing truncate; rc = [%d]\n", rc);
+				goto out_fput;
+			}
+		}
 		vmtruncate(inode, new_length);
 		rc = ecryptfs_write_inode_size_to_metadata(
 			lower_file, lower_dentry->d_inode, inode, dentry,
diff -puN fs/ecryptfs/mmap.c~ecryptfs-fix-write-zeros-behavior fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-fix-write-zeros-behavior
+++ a/fs/ecryptfs/mmap.c
@@ -56,9 +56,6 @@ static struct page *ecryptfs_get1page(st
 	return read_mapping_page(mapping, index, (void *)file);
 }
 
-static
-int write_zeros(struct file *file, pgoff_t index, int start, int num_zeros);
-
 /**
  * ecryptfs_fill_zeros
  * @file: The ecryptfs file
@@ -101,10 +98,13 @@ int ecryptfs_fill_zeros(struct file *fil
 	if (old_end_page_index == new_end_page_index) {
 		/* Start and end are in the same page; we just need to
 		 * set a portion of the existing page to zero's */
-		rc = write_zeros(file, index, (old_end_pos_in_page + 1),
-				 (new_end_pos_in_page - old_end_pos_in_page));
+		rc = ecryptfs_write_zeros(file, index,
+					  (old_end_pos_in_page + 1),
+					  (new_end_pos_in_page
+					   - old_end_pos_in_page));
 		if (rc)
-			ecryptfs_printk(KERN_ERR, "write_zeros(file=[%p], "
+			ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros("
+					"file=[%p], "
 					"index=[0x%.16x], "
 					"old_end_pos_in_page=[d], "
 					"(PAGE_CACHE_SIZE - new_end_pos_in_page"
@@ -117,10 +117,10 @@ int ecryptfs_fill_zeros(struct file *fil
 		goto out;
 	}
 	/* Fill the remainder of the previous last page with zeros */
-	rc = write_zeros(file, index, (old_end_pos_in_page + 1),
+	rc = ecryptfs_write_zeros(file, index, (old_end_pos_in_page + 1),
 			 ((PAGE_CACHE_SIZE - 1) - old_end_pos_in_page));
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "write_zeros(file=[%p], "
+		ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros(file=[%p], "
 				"index=[0x%.16x], old_end_pos_in_page=[d], "
 				"(PAGE_CACHE_SIZE - old_end_pos_in_page)=[d]) "
 				"returned [%d]\n", file, index,
@@ -131,9 +131,10 @@ int ecryptfs_fill_zeros(struct file *fil
 	index++;
 	while (index < new_end_page_index) {
 		/* Fill all intermediate pages with zeros */
-		rc = write_zeros(file, index, 0, PAGE_CACHE_SIZE);
+		rc = ecryptfs_write_zeros(file, index, 0, PAGE_CACHE_SIZE);
 		if (rc) {
-			ecryptfs_printk(KERN_ERR, "write_zeros(file=[%p], "
+			ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros("
+					"file=[%p], "
 					"index=[0x%.16x], "
 					"old_end_pos_in_page=[d], "
 					"(PAGE_CACHE_SIZE - new_end_pos_in_page"
@@ -149,9 +150,9 @@ int ecryptfs_fill_zeros(struct file *fil
 	}
 	/* Fill the portion at the beginning of the last new page with
 	 * zero's */
-	rc = write_zeros(file, index, 0, (new_end_pos_in_page + 1));
+	rc = ecryptfs_write_zeros(file, index, 0, (new_end_pos_in_page + 1));
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "write_zeros(file="
+		ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros(file="
 				"[%p], index=[0x%.16x], 0, "
 				"new_end_pos_in_page=[%d]"
 				"returned [%d]\n", file, index,
@@ -400,7 +401,6 @@ out:
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
-	loff_t pos;
 	int rc = 0;
 
 	if (from == 0 && to == PAGE_CACHE_SIZE)
@@ -408,14 +408,19 @@ static int ecryptfs_prepare_write(struct
 				   up to date. */
 	if (!PageUptodate(page))
 		rc = ecryptfs_do_readpage(file, page, page->index);
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-	if (pos > i_size_read(page->mapping->host)) {
-		rc = ecryptfs_truncate(file->f_path.dentry, pos);
-		if (rc) {
-			printk(KERN_ERR "Error on attempt to "
-			       "truncate to (higher) offset [%lld];"
-			       " rc = [%d]\n", pos, rc);
-			goto out;
+	if (page->index != 0) {
+		loff_t end_of_prev_pg_pos =
+			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
+
+		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
+			rc = ecryptfs_truncate(file->f_path.dentry,
+					       end_of_prev_pg_pos);
+			if (rc) {
+				printk(KERN_ERR "Error on attempt to "
+				       "truncate to (higher) offset [%lld];"
+				       " rc = [%d]\n", end_of_prev_pg_pos, rc);
+				goto out;
+			}
 		}
 	}
 out:
@@ -753,7 +758,7 @@ out:
 }
 
 /**
- * write_zeros
+ * ecryptfs_write_zeros
  * @file: The ecryptfs file
  * @index: The index in which we are writing
  * @start: The position after the last block of data
@@ -763,8 +768,8 @@ out:
  *
  * (start + num_zeros) must be less than or equal to PAGE_CACHE_SIZE
  */
-static
-int write_zeros(struct file *file, pgoff_t index, int start, int num_zeros)
+int
+ecryptfs_write_zeros(struct file *file, pgoff_t index, int start, int num_zeros)
 {
 	int rc = 0;
 	struct page *tmp_page;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-fix-write-zeros-behavior.patch
ecryptfs-initialize-crypt_stat-in-setattr.patch
ecryptfs-zero-out-last-page-for-llseek-write.patch
git-unionfs.patch
couple-fixes-to-fs-ecryptfs-inodec.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
