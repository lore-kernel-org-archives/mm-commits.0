From: akpm@linux-foundation.org
Subject: - ecryptfs-handles-aop_truncated_page-better.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:45 -0800
Message-ID: <200703052355.l25NtjQp005206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306AbXCEX7B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: handle AOP_TRUNCATED_PAGE better
has been removed from the -mm tree.  Its filename was
     ecryptfs-handles-aop_truncated_page-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: handle AOP_TRUNCATED_PAGE better
From: Dmitriy Monakhov <dmonakhov@openvz.org>

- In fact we don't have to fail if AOP_TRUNCATED_PAGE was returned from
  prepare_write or commit_write. It is beter to retry attempt where it
  is possible.

- Rearange ecryptfs_get_lower_page() error handling logic, make it more clean.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-handles-aop_truncated_page-better fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-handles-aop_truncated_page-better
+++ a/fs/ecryptfs/mmap.c
@@ -446,6 +446,7 @@ static int ecryptfs_write_inode_size_to_
 	const struct address_space_operations *lower_a_ops;
 	u64 file_size;
 
+retry:
 	header_page = grab_cache_page(lower_inode->i_mapping, 0);
 	if (!header_page) {
 		ecryptfs_printk(KERN_ERR, "grab_cache_page for "
@@ -456,9 +457,10 @@ static int ecryptfs_write_inode_size_to_
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
@@ -473,9 +475,10 @@ static int ecryptfs_write_inode_size_to_
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
@@ -565,6 +568,7 @@ int ecryptfs_get_lower_page(struct page 
 {
 	int rc = 0;
 
+retry:
 	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
 	if (!(*lower_page)) {
 		rc = -EINVAL;
@@ -578,18 +582,18 @@ int ecryptfs_get_lower_page(struct page 
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

origin.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
