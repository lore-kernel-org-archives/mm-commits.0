From: akpm@linux-foundation.org
Subject: + ecryptfs-handles-aop_truncated_page-better.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:00:39 -0800
Message-ID: <200702272100.l1RL0hi1028479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52045 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXB0VAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:00:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: handle AOP_TRUNCATED_PAGE better
has been added to the -mm tree.  Its filename is
     ecryptfs-handles-aop_truncated_page-better.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: handle AOP_TRUNCATED_PAGE better
From: Dmitriy Monakhov <dmonakhov@openvz.org>

- In fact we don't have to fail if AOP_TRUNCATED_PAGE was returned from
  prepare_write or commit_write. It is beter to retry attempt where it
  is possible.

- Rearange ecryptfs_get_lower_page() error handling logic, make it more clean.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-handles-aop_truncated_page-better fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-handles-aop_truncated_page-better
+++ a/fs/ecryptfs/mmap.c
@@ -437,6 +437,7 @@ static int ecryptfs_write_inode_size_to_
 	const struct address_space_operations *lower_a_ops;
 	u64 file_size;
 
+retry:
 	header_page = grab_cache_page(lower_inode->i_mapping, 0);
 	if (!header_page) {
 		ecryptfs_printk(KERN_ERR, "grab_cache_page for "
@@ -447,9 +448,10 @@ static int ecryptfs_write_inode_size_to_
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
 	if (rc) {
-		if (rc == AOP_TRUNCATED_PAGE)
+		if (rc == AOP_TRUNCATED_PAGE) {
 			ecryptfs_release_lower_page(header_page, 0);
-		else
+			goto retry;
+		} else
 			ecryptfs_release_lower_page(header_page, 1);
 		goto out;
 	}
@@ -464,9 +466,10 @@ static int ecryptfs_write_inode_size_to_
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
 				"write\n");
-	if (rc == AOP_TRUNCATED_PAGE)
+	if (rc == AOP_TRUNCATED_PAGE) {
 		ecryptfs_release_lower_page(header_page, 0);
-	else
+		goto retry;
+	} else
 		ecryptfs_release_lower_page(header_page, 1);
 	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty_sync(inode);
@@ -555,6 +558,7 @@ int ecryptfs_get_lower_page(struct page 
 {
 	int rc = 0;
 
+retry:
 	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
 	if (!(*lower_page)) {
 		rc = -EINVAL;
@@ -568,18 +572,18 @@ int ecryptfs_get_lower_page(struct page 
 							  byte_offset,
 							  region_bytes);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "prepare_write for "
+		if (rc == AOP_TRUNCATED_PAGE) {
+			ecryptfs_release_lower_page(*lower_page, 0);
+			goto retry;
+		} else {
+			ecryptfs_printk(KERN_ERR, "prepare_write for "
 				"lower_page_index = [0x%.16x] failed; rc = "
 				"[%d]\n", lower_page_index, rc);
-	}
-out:
-	if (rc && (*lower_page)) {
-		if (rc == AOP_TRUNCATED_PAGE)
-			ecryptfs_release_lower_page(*lower_page, 0);
-		else
 			ecryptfs_release_lower_page(*lower_page, 1);
-		(*lower_page) = NULL;
+			(*lower_page) = NULL;
+		}
 	}
+out:
 	return rc;
 }
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

ecryptfs-set-o_largefile-when-opening-lower-file.patch
ecryptfs-remove-unnecessary-flush_dcache_page.patch
ecryptfs-no-path_release-after-path_lookup-error.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ecryptfs-handles-aop_truncated_page-better.patch
