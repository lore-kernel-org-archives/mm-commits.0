From: akpm@linux-foundation.org
Subject: - ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:07 -0800
Message-ID: <200803050746.m257k7DF021719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759562AbYCEHrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, bdriessen@escrypt.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: make ecryptfs_prepare_write decrypt the page
has been removed from the -mm tree.  Its filename was
     ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: make ecryptfs_prepare_write decrypt the page
From: Michael Halcrow <mhalcrow@us.ibm.com>

When the page is not up to date, ecryptfs_prepare_write() should be
acting much like ecryptfs_readpage(). This includes the painfully
obvious step of actually decrypting the page contents read from the
lower encrypted file.

Note that this patch resolves a bug in eCryptfs in 2.6.24 that one can
produce with these steps:

# mount -t ecryptfs /secret /secret
# echo "abc" > /secret/file.txt
# umount /secret
# mount -t ecryptfs /secret /secret
# echo "def" >> /secret/file.txt
# cat /secret/file.txt

Without this patch, the resulting data returned from cat is likely to
be something other than "abc\ndef\n".

(Thanks to Benedikt Driessen for reporting this.)

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Benedikt Driessen <bdriessen@escrypt.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |  102 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 26 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page
+++ a/fs/ecryptfs/mmap.c
@@ -263,52 +263,102 @@ out:
 	return 0;
 }
 
-/* This function must zero any hole we create */
+/**
+ * ecryptfs_prepare_write
+ * @file: The eCryptfs file
+ * @page: The eCryptfs page
+ * @from: The start byte from which we will write
+ * @to: The end byte to which we will write
+ *
+ * This function must zero any hole we create
+ *
+ * Returns zero on success; non-zero otherwise
+ */
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
-	int rc = 0;
 	loff_t prev_page_end_size;
+	int rc = 0;
 
 	if (!PageUptodate(page)) {
-		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
-						      PAGE_CACHE_SIZE,
-						      page->mapping->host);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attemping to read lower "
-			       "page segment; rc = [%d]\n", __FUNCTION__, rc);
-			ClearPageUptodate(page);
-			goto out;
-		} else
+		struct ecryptfs_crypt_stat *crypt_stat =
+			&ecryptfs_inode_to_private(
+				file->f_path.dentry->d_inode)->crypt_stat;
+
+		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)
+		    || (crypt_stat->flags & ECRYPTFS_NEW_FILE)) {
+			rc = ecryptfs_read_lower_page_segment(
+				page, page->index, 0, PAGE_CACHE_SIZE,
+				page->mapping->host);
+			if (rc) {
+				printk(KERN_ERR "%s: Error attemping to read "
+				       "lower page segment; rc = [%d]\n",
+				       __FUNCTION__, rc);
+				ClearPageUptodate(page);
+				goto out;
+			} else
+				SetPageUptodate(page);
+		} else if (crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
+			if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR) {
+				rc = ecryptfs_copy_up_encrypted_with_header(
+					page, crypt_stat);
+				if (rc) {
+					printk(KERN_ERR "%s: Error attempting "
+					       "to copy the encrypted content "
+					       "from the lower file whilst "
+					       "inserting the metadata from "
+					       "the xattr into the header; rc "
+					       "= [%d]\n", __FUNCTION__, rc);
+					ClearPageUptodate(page);
+					goto out;
+				}
+				SetPageUptodate(page);
+			} else {
+				rc = ecryptfs_read_lower_page_segment(
+					page, page->index, 0, PAGE_CACHE_SIZE,
+					page->mapping->host);
+				if (rc) {
+					printk(KERN_ERR "%s: Error reading "
+					       "page; rc = [%d]\n",
+					       __FUNCTION__, rc);
+					ClearPageUptodate(page);
+					goto out;
+				}
+				SetPageUptodate(page);
+			}
+		} else {
+			rc = ecryptfs_decrypt_page(page);
+			if (rc) {
+				printk(KERN_ERR "%s: Error decrypting page "
+				       "at index [%ld]; rc = [%d]\n",
+				       __FUNCTION__, page->index, rc);
+				ClearPageUptodate(page);
+				goto out;
+			}
 			SetPageUptodate(page);
+		}
 	}
-
 	prev_page_end_size = ((loff_t)page->index << PAGE_CACHE_SHIFT);
-
-	/*
-	 * If creating a page or more of holes, zero them out via truncate.
-	 * Note, this will increase i_size.
-	 */
+	/* If creating a page or more of holes, zero them out via truncate.
+	 * Note, this will increase i_size. */
 	if (page->index != 0) {
 		if (prev_page_end_size > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
 					       prev_page_end_size);
 			if (rc) {
-				printk(KERN_ERR "Error on attempt to "
+				printk(KERN_ERR "%s: Error on attempt to "
 				       "truncate to (higher) offset [%lld];"
-				       " rc = [%d]\n", prev_page_end_size, rc);
+				       " rc = [%d]\n", __FUNCTION__,
+				       prev_page_end_size, rc);
 				goto out;
 			}
 		}
 	}
-	/*
-	 * Writing to a new page, and creating a small hole from start of page?
-	 * Zero it out.
-	 */
-	if ((i_size_read(page->mapping->host) == prev_page_end_size) &&
-	    (from != 0)) {
+	/* Writing to a new page, and creating a small hole from start
+	 * of page?  Zero it out. */
+	if ((i_size_read(page->mapping->host) == prev_page_end_size)
+	    && (from != 0))
 		zero_user(page, 0, PAGE_CACHE_SIZE);
-	}
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
remove-ecryptfs_header_cache_0.patch
remove-duplicated-unlikely-in-is_err.patch

