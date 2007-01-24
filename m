From: akpm@osdl.org
Subject: + ecryptfs-add-flush_dcache_page-calls.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:05:48 -0800
Message-ID: <200701240805.l0O85mPq012329@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57075 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201AbXAXIGC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:06:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: add flush_dcache_page() calls
has been added to the -mm tree.  Its filename is
     ecryptfs-add-flush_dcache_page-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: add flush_dcache_page() calls
From: Michael Halcrow <mhalcrow@us.ibm.com>

Call flush_dcache_page() after modifying a pagecache by hand.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/mmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-add-flush_dcache_page-calls fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-add-flush_dcache_page-calls
+++ a/fs/ecryptfs/mmap.c
@@ -238,7 +238,9 @@ int ecryptfs_do_readpage(struct file *fi
 	lower_page_data = kmap_atomic(lower_page, KM_USER1);
 	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
 	kunmap_atomic(lower_page_data, KM_USER1);
+	flush_dcache_page(lower_page);
 	kunmap_atomic(page_data, KM_USER0);
+	flush_dcache_page(page);
 	rc = 0;
 out:
 	if (likely(lower_page))
@@ -322,6 +324,7 @@ static int ecryptfs_readpage(struct file
 					set_header_info(page_virt, crypt_stat);
 				}
 				kunmap_atomic(page_virt, KM_USER0);
+				flush_dcache_page(page);
 				if (rc) {
 					printk(KERN_ERR "Error reading xattr "
 					       "region\n");
@@ -382,6 +385,7 @@ static int fill_zeros_to_end_of_page(str
 	memset((page_virt + end_byte_in_page), 0,
 	       (PAGE_CACHE_SIZE - end_byte_in_page));
 	kunmap_atomic(page_virt, KM_USER0);
+	flush_dcache_page(page);
 out:
 	return 0;
 }
@@ -456,6 +460,7 @@ static int ecryptfs_write_inode_size_to_
 	header_virt = kmap_atomic(header_page, KM_USER0);
 	memcpy(header_virt, &file_size, sizeof(u64));
 	kunmap_atomic(header_virt, KM_USER0);
+	flush_dcache_page(header_page);
 	rc = lower_a_ops->commit_write(lower_file, header_page, 0, 8);
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
@@ -742,6 +747,7 @@ int write_zeros(struct file *file, pgoff
 	tmp_page_virt = kmap_atomic(tmp_page, KM_USER0);
 	memset(((char *)tmp_page_virt + start), 0, num_zeros);
 	kunmap_atomic(tmp_page_virt, KM_USER0);
+	flush_dcache_page(tmp_page);
 	rc = ecryptfs_commit_write(file, tmp_page, start, start + num_zeros);
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to write zero's "
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-transport-mechanism-fix.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-xattr-flags-and-mount-options.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-encrypted-passthrough.patch
ecryptfs-convert-f_op-write-to-vfs_write.patch
ecryptfs-convert-kmap-to-kmap_atomic.patch
ecryptfs-open-code-flag-checking-and-manipulation.patch
ecryptfs-add-flush_dcache_page-calls.patch
ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
