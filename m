From: akpm@linux-foundation.org
Subject: + ecryptfs-delay-writing-0s-after-llseek-until-write.patch added to -mm tree
Date: Mon, 21 May 2007 21:06:12 -0700
Message-ID: <200705220406.l4M46BAf026970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953AbXEVEHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 00:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: delay writing 0's after llseek until write
has been added to the -mm tree.  Its filename is
     ecryptfs-delay-writing-0s-after-llseek-until-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: delay writing 0's after llseek until write
From: Michael Halcrow <mhalcrow@us.ibm.com>

Delay writing 0's out in eCryptfs after a seek past the end of the file
until data is actually written.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |   59 -------------------------------------------
 fs/ecryptfs/mmap.c |   38 +++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 61 deletions(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-delay-writing-0s-after-llseek-until-write fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-delay-writing-0s-after-llseek-until-write
+++ a/fs/ecryptfs/file.c
@@ -33,63 +33,6 @@
 #include "ecryptfs_kernel.h"
 
 /**
- * ecryptfs_llseek
- * @file: File we are seeking in
- * @offset: The offset to seek to
- * @origin: 2 - offset from i_size; 1 - offset from f_pos
- *
- * Returns the position we have seeked to, or negative on error
- */
-static loff_t ecryptfs_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t rv;
-	loff_t new_end_pos;
-	int rc;
-	int expanding_file = 0;
-	struct inode *inode = file->f_mapping->host;
-
-	/* If our offset is past the end of our file, we're going to
-	 * need to grow it so we have a valid length of 0's */
-	new_end_pos = offset;
-	switch (origin) {
-	case 2:
-		new_end_pos += i_size_read(inode);
-		expanding_file = 1;
-		break;
-	case 1:
-		new_end_pos += file->f_pos;
-		if (new_end_pos > i_size_read(inode)) {
-			ecryptfs_printk(KERN_DEBUG, "new_end_pos(=[0x%.16x]) "
-					"> i_size_read(inode)(=[0x%.16x])\n",
-					new_end_pos, i_size_read(inode));
-			expanding_file = 1;
-		}
-		break;
-	default:
-		if (new_end_pos > i_size_read(inode)) {
-			ecryptfs_printk(KERN_DEBUG, "new_end_pos(=[0x%.16x]) "
-					"> i_size_read(inode)(=[0x%.16x])\n",
-					new_end_pos, i_size_read(inode));
-			expanding_file = 1;
-		}
-	}
-	ecryptfs_printk(KERN_DEBUG, "new_end_pos = [0x%.16x]\n", new_end_pos);
-	if (expanding_file) {
-		rc = ecryptfs_truncate(file->f_path.dentry, new_end_pos);
-		if (rc) {
-			rv = rc;
-			ecryptfs_printk(KERN_ERR, "Error on attempt to "
-					"truncate to (higher) offset [0x%.16x];"
-					" rc = [%d]\n", new_end_pos, rc);
-			goto out;
-		}
-	}
-	rv = generic_file_llseek(file, offset, origin);
-out:
-	return rv;
-}
-
-/**
  * ecryptfs_read_update_atime
  *
  * generic_file_read updates the atime of upper layer inode.  But, it
@@ -425,7 +368,7 @@ const struct file_operations ecryptfs_di
 };
 
 const struct file_operations ecryptfs_main_fops = {
-	.llseek = ecryptfs_llseek,
+	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = ecryptfs_read_update_atime,
 	.write = do_sync_write,
diff -puN fs/ecryptfs/mmap.c~ecryptfs-delay-writing-0s-after-llseek-until-write fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-delay-writing-0s-after-llseek-until-write
+++ a/fs/ecryptfs/mmap.c
@@ -376,9 +376,31 @@ out:
 	return 0;
 }
 
+/**
+ * eCryptfs does not currently support holes. When writing after a
+ * seek past the end of the file, eCryptfs fills in 0's through to the
+ * current location. The code to fill in the 0's to all the
+ * intermediate pages calls ecryptfs_prepare_write_no_truncate().
+ */
+static int
+ecryptfs_prepare_write_no_truncate(struct file *file, struct page *page,
+				   unsigned from, unsigned to)
+{
+	int rc = 0;
+
+	if (from == 0 && to == PAGE_CACHE_SIZE)
+		goto out;	/* If we are writing a full page, it will be
+				   up to date. */
+	if (!PageUptodate(page))
+		rc = ecryptfs_do_readpage(file, page, page->index);
+out:
+	return rc;
+}
+
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
+	loff_t pos;
 	int rc = 0;
 
 	if (from == 0 && to == PAGE_CACHE_SIZE)
@@ -386,6 +408,16 @@ static int ecryptfs_prepare_write(struct
 				   up to date. */
 	if (!PageUptodate(page))
 		rc = ecryptfs_do_readpage(file, page, page->index);
+	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	if (pos > i_size_read(page->mapping->host)) {
+		rc = ecryptfs_truncate(file->f_path.dentry, pos);
+		if (rc) {
+			printk(KERN_ERR "Error on attempt to "
+			       "truncate to (higher) offset [%lld];"
+			       " rc = [%d]\n", pos, rc);
+			goto out;
+		}
+	}
 out:
 	return rc;
 }
@@ -744,10 +776,10 @@ int write_zeros(struct file *file, pgoff
 		rc = PTR_ERR(tmp_page);
 		goto out;
 	}
-	rc = ecryptfs_prepare_write(file, tmp_page, start, start + num_zeros);
-	if (rc) {
+	if ((rc = ecryptfs_prepare_write_no_truncate(file, tmp_page, start,
+						     (start + num_zeros)))) {
 		ecryptfs_printk(KERN_ERR, "Error preparing to write zero's "
-				"to remainder of page at index [0x%.16x]\n",
+				"to page at index [0x%.16x]\n",
 				index);
 		page_cache_release(tmp_page);
 		goto out;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
ecryptfs-delay-writing-0s-after-llseek-until-write.patch
couple-fixes-to-fs-ecryptfs-inodec.patch
