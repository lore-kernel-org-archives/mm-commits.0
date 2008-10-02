From: akpm@linux-foundation.org
Subject: + ecryptfs-convert-to-use-new-aops.patch added to -mm tree
Date: Thu, 02 Oct 2008 16:38:34 -0700
Message-ID: <200810022338.m92NcY9Y000326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbYJBXja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 19:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, mhalcrow@us.ibm.com, npiggin@suse.de


The patch titled
     ecryptfs: convert to use new aops
has been added to the -mm tree.  Its filename is
     ecryptfs-convert-to-use-new-aops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: convert to use new aops
From: Badari Pulavarty <pbadari@us.ibm.com>

Convert ecryptfs to use write_begin/write_end

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   71 +++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-convert-to-use-new-aops fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-convert-to-use-new-aops
+++ a/fs/ecryptfs/mmap.c
@@ -265,9 +265,9 @@ out:
 }
 
 /**
- * ecryptfs_prepare_write
+ * ecryptfs_write_begin
  * @file: The eCryptfs file
- * @page: The eCryptfs page
+ * @mapping: The eCryptfs object
  * @from: The start byte from which we will write
  * @to: The end byte to which we will write
  *
@@ -275,12 +275,21 @@ out:
  *
  * Returns zero on success; non-zero otherwise
  */
-static int ecryptfs_prepare_write(struct file *file, struct page *page,
-				  unsigned from, unsigned to)
+static int ecryptfs_write_begin(struct file *file,
+			struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	struct page *page;
 	loff_t prev_page_end_size;
 	int rc = 0;
 
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
 	if (!PageUptodate(page)) {
 		struct ecryptfs_crypt_stat *crypt_stat =
 			&ecryptfs_inode_to_private(
@@ -289,8 +298,7 @@ static int ecryptfs_prepare_write(struct
 		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)
 		    || (crypt_stat->flags & ECRYPTFS_NEW_FILE)) {
 			rc = ecryptfs_read_lower_page_segment(
-				page, page->index, 0, PAGE_CACHE_SIZE,
-				page->mapping->host);
+				page, index, 0, PAGE_CACHE_SIZE, mapping->host);
 			if (rc) {
 				printk(KERN_ERR "%s: Error attemping to read "
 				       "lower page segment; rc = [%d]\n",
@@ -316,8 +324,8 @@ static int ecryptfs_prepare_write(struct
 				SetPageUptodate(page);
 			} else {
 				rc = ecryptfs_read_lower_page_segment(
-					page, page->index, 0, PAGE_CACHE_SIZE,
-					page->mapping->host);
+					page, index, 0, PAGE_CACHE_SIZE,
+					mapping->host);
 				if (rc) {
 					printk(KERN_ERR "%s: Error reading "
 					       "page; rc = [%d]\n",
@@ -339,10 +347,10 @@ static int ecryptfs_prepare_write(struct
 			SetPageUptodate(page);
 		}
 	}
-	prev_page_end_size = ((loff_t)page->index << PAGE_CACHE_SHIFT);
+	prev_page_end_size = ((loff_t)index << PAGE_CACHE_SHIFT);
 	/* If creating a page or more of holes, zero them out via truncate.
 	 * Note, this will increase i_size. */
-	if (page->index != 0) {
+	if (index != 0) {
 		if (prev_page_end_size > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
 					       prev_page_end_size);
@@ -357,8 +365,8 @@ static int ecryptfs_prepare_write(struct
 	}
 	/* Writing to a new page, and creating a small hole from start
 	 * of page?  Zero it out. */
-	if ((i_size_read(page->mapping->host) == prev_page_end_size)
-	    && (from != 0))
+	if ((i_size_read(mapping->host) == prev_page_end_size)
+	    && (pos != 0))
 		zero_user(page, 0, PAGE_CACHE_SIZE);
 out:
 	return rc;
@@ -445,21 +453,25 @@ int ecryptfs_write_inode_size_to_metadat
 }
 
 /**
- * ecryptfs_commit_write
+ * ecryptfs_write_end
  * @file: The eCryptfs file object
+ * @mapping: The eCryptfs object
+ * @pos, len: Ignored (we rotate the page IV on each write)
  * @page: The eCryptfs page
- * @from: Ignored (we rotate the page IV on each write)
- * @to: Ignored
  *
  * This is where we encrypt the data and pass the encrypted data to
  * the lower filesystem.  In OpenPGP-compatible mode, we operate on
  * entire underlying packets.
  */
-static int ecryptfs_commit_write(struct file *file, struct page *page,
-				 unsigned from, unsigned to)
+static int ecryptfs_write_end(struct file *file,
+			struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	loff_t pos;
-	struct inode *ecryptfs_inode = page->mapping->host;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned to = from + copied;
+	struct inode *ecryptfs_inode = mapping->host;
 	struct ecryptfs_crypt_stat *crypt_stat =
 		&ecryptfs_inode_to_private(file->f_path.dentry->d_inode)->crypt_stat;
 	int rc;
@@ -471,25 +483,22 @@ static int ecryptfs_commit_write(struct 
 	} else
 		ecryptfs_printk(KERN_DEBUG, "Not a new file\n");
 	ecryptfs_printk(KERN_DEBUG, "Calling fill_zeros_to_end_of_page"
-			"(page w/ index = [0x%.16x], to = [%d])\n", page->index,
-			to);
+			"(page w/ index = [0x%.16x], to = [%d])\n", index, to);
 	/* Fills in zeros if 'to' goes beyond inode size */
 	rc = fill_zeros_to_end_of_page(page, to);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error attempting to fill "
-				"zeros in page with index = [0x%.16x]\n",
-				page->index);
+			"zeros in page with index = [0x%.16x]\n", index);
 		goto out;
 	}
 	rc = ecryptfs_encrypt_page(page);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error encrypting page (upper "
-				"index [0x%.16x])\n", page->index);
+				"index [0x%.16x])\n", index);
 		goto out;
 	}
-	pos = (((loff_t)page->index) << PAGE_CACHE_SHIFT) + to;
-	if (pos > i_size_read(ecryptfs_inode)) {
-		i_size_write(ecryptfs_inode, pos);
+	if (pos + copied > i_size_read(ecryptfs_inode)) {
+		i_size_write(ecryptfs_inode, pos + copied);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
 				"[0x%.16x]\n", i_size_read(ecryptfs_inode));
 	}
@@ -497,7 +506,11 @@ static int ecryptfs_commit_write(struct 
 	if (rc)
 		printk(KERN_ERR "Error writing inode size to metadata; "
 		       "rc = [%d]\n", rc);
+	else
+		rc = copied;
 out:
+	unlock_page(page);
+	page_cache_release(page);
 	return rc;
 }
 
@@ -518,7 +531,7 @@ static sector_t ecryptfs_bmap(struct add
 struct address_space_operations ecryptfs_aops = {
 	.writepage = ecryptfs_writepage,
 	.readpage = ecryptfs_readpage,
-	.prepare_write = ecryptfs_prepare_write,
-	.commit_write = ecryptfs_commit_write,
+	.write_begin = ecryptfs_write_begin,
+	.write_end = ecryptfs_write_end,
 	.bmap = ecryptfs_bmap,
 };
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

git-cifs.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
ecryptfs-convert-to-use-new-aops.patch

