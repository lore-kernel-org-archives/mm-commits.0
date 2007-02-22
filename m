From: akpm@linux-foundation.org
Subject: + ecryptfs-resolve-lower-page-unlocking-problem.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:30:01 -0800
Message-ID: <200702220230.l1M2U1Vn001822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34075 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXBVCaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: resolve lower page unlocking problem
has been added to the -mm tree.  Its filename is
     ecryptfs-resolve-lower-page-unlocking-problem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: resolve lower page unlocking problem
From: Michael Halcrow <mhalcrow@us.ibm.com>

eCryptfs lower file handling code has several issues:
  - Retval from prepare_write()/commit_write() wasn't checked to equality
    to AOP_TRUNCATED_PAGE.
  - In some places page wasn't unmapped and unlocked after error.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-resolve-lower-page-unlocking-problem fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-resolve-lower-page-unlocking-problem
+++ a/fs/ecryptfs/mmap.c
@@ -422,9 +422,11 @@ out:
 	return rc;
 }
 
-static void ecryptfs_release_lower_page(struct page *lower_page)
+static
+void ecryptfs_release_lower_page(struct page *lower_page, int page_locked)
 {
-	unlock_page(lower_page);
+	if (page_locked)
+		unlock_page(lower_page);
 	page_cache_release(lower_page);
 }
 
@@ -454,6 +456,13 @@ static int ecryptfs_write_inode_size_to_
 	}
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
+	if (rc) {
+		if (rc == AOP_TRUNCATED_PAGE)
+			ecryptfs_release_lower_page(header_page, 0);
+		else
+			ecryptfs_release_lower_page(header_page, 1);
+		goto out;
+	}
 	file_size = (u64)i_size_read(inode);
 	ecryptfs_printk(KERN_DEBUG, "Writing size: [0x%.16x]\n", file_size);
 	file_size = cpu_to_be64(file_size);
@@ -465,7 +474,10 @@ static int ecryptfs_write_inode_size_to_
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
 				"write\n");
-	ecryptfs_release_lower_page(header_page);
+	if (rc == AOP_TRUNCATED_PAGE)
+		ecryptfs_release_lower_page(header_page, 0);
+	else
+		ecryptfs_release_lower_page(header_page, 1);
 	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty_sync(inode);
 out:
@@ -572,7 +584,10 @@ int ecryptfs_get_lower_page(struct page 
 	}
 out:
 	if (rc && (*lower_page)) {
-		ecryptfs_release_lower_page(*lower_page);
+		if (rc == AOP_TRUNCATED_PAGE)
+			ecryptfs_release_lower_page(*lower_page, 0);
+		else
+			ecryptfs_release_lower_page(*lower_page, 1);
 		(*lower_page) = NULL;
 	}
 	return rc;
@@ -588,16 +603,19 @@ ecryptfs_commit_lower_page(struct page *
 			   struct file *lower_file, int byte_offset,
 			   int region_size)
 {
+	int page_locked = 1;
 	int rc = 0;
 
 	rc = lower_inode->i_mapping->a_ops->commit_write(
 		lower_file, lower_page, byte_offset, region_size);
+	if (rc == AOP_TRUNCATED_PAGE)
+		page_locked = 0;
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR,
 				"Error committing write; rc = [%d]\n", rc);
 	} else
 		rc = 0;
-	ecryptfs_release_lower_page(lower_page);
+	ecryptfs_release_lower_page(lower_page, page_locked);
 	return rc;
 }
 
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-resolve-lower-page-unlocking-problem.patch
git-unionfs.patch
