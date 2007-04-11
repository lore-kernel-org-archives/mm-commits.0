From: akpm@linux-foundation.org
Subject: + ecryptfs-use-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:17:28 -0700
Message-ID: <200704110617.l3B6HSp6030104@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32993 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbXDKGRe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     ecryptfs: use zero_user_page
has been added to the -mm tree.  Its filename is
     ecryptfs-use-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
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

cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
affs-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
ext3-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
reiserfs-use-zero_user_page.patch
xfs-use-zero_user_page.patch
fs-deprecate-memclear_highpage_flush.patch
reiser4-use-zero_user_page.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
