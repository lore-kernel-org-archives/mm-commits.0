From: akpm@linux-foundation.org
Subject: - ecryptfs-use-zero_user_page.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:37 -0700
Message-ID: <200705180706.l4I76axP010193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761986AbXERHIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: use zero_user_page
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-use-zero_user_page fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-use-zero_user_page
+++ a/fs/ecryptfs/mmap.c
@@ -364,18 +364,14 @@ static int fill_zeros_to_end_of_page(str
 {
 	struct inode *inode = page->mapping->host;
 	int end_byte_in_page;
-	char *page_virt;
 
 	if ((i_size_read(inode) / PAGE_CACHE_SIZE) != page->index)
 		goto out;
 	end_byte_in_page = i_size_read(inode) % PAGE_CACHE_SIZE;
 	if (to > end_byte_in_page)
 		end_byte_in_page = to;
-	page_virt = kmap_atomic(page, KM_USER0);
-	memset((page_virt + end_byte_in_page), 0,
-	       (PAGE_CACHE_SIZE - end_byte_in_page));
-	kunmap_atomic(page_virt, KM_USER0);
-	flush_dcache_page(page);
+	zero_user_page(page, end_byte_in_page,
+		PAGE_CACHE_SIZE - end_byte_in_page, KM_USER0);
 out:
 	return 0;
 }
@@ -740,7 +736,6 @@ int write_zeros(struct file *file, pgoff
 {
 	int rc = 0;
 	struct page *tmp_page;
-	char *tmp_page_virt;
 
 	tmp_page = ecryptfs_get1page(file, index);
 	if (IS_ERR(tmp_page)) {
@@ -757,10 +752,7 @@ int write_zeros(struct file *file, pgoff
 		page_cache_release(tmp_page);
 		goto out;
 	}
-	tmp_page_virt = kmap_atomic(tmp_page, KM_USER0);
-	memset(((char *)tmp_page_virt + start), 0, num_zeros);
-	kunmap_atomic(tmp_page_virt, KM_USER0);
-	flush_dcache_page(tmp_page);
+	zero_user_page(tmp_page, start, num_zeros, KM_USER0);
 	rc = ecryptfs_commit_write(file, tmp_page, start, start + num_zeros);
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to write zero's "
_

Patches currently in -mm which might be from nate.diller@gmail.com are

origin.patch
cifs-use-simple_prepare_write-to-zero-page-data.patch
git-gfs2-nmw.patch
git-nfs.patch
xfs-use-zero_user_page.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch
