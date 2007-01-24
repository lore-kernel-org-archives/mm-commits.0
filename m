From: akpm@osdl.org
Subject: + ecryptfs-convert-f_op-write-to-vfs_write.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:05:43 -0800
Message-ID: <200701240805.l0O85h7w012318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57350 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbXAXIPO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:15:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: convert f_op->write() to vfs_write()
has been added to the -mm tree.  Its filename is
     ecryptfs-convert-f_op-write-to-vfs_write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: convert f_op->write() to vfs_write()
From: Michael Halcrow <mhalcrow@us.ibm.com>

sys_write() takes a local copy of f_pos and writes that back
into the struct file. It does this so that two concurrent write()
callers don't make a mess of f_pos, and of the file contents.

ecryptfs should be calling vfs_write().  That way we also get the fsnotify
notifications, which ecryptfs presently appears to have subverted.

Convert direct calls to f_op->write() into calls to vfs_write().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/crypto.c |   27 ++++++++++++++++++++++-----
 fs/ecryptfs/inode.c  |    2 +-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-convert-f_op-write-to-vfs_write fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-convert-f_op-write-to-vfs_write
+++ a/fs/ecryptfs/crypto.c
@@ -1346,24 +1346,41 @@ int ecryptfs_write_metadata_to_contents(
 	mm_segment_t oldfs;
 	int current_header_page;
 	int header_pages;
+	ssize_t size;
+	int rc = 0;
 
 	lower_file->f_pos = 0;
 	oldfs = get_fs();
 	set_fs(get_ds());
-	lower_file->f_op->write(lower_file, (char __user *)page_virt,
-				PAGE_CACHE_SIZE, &lower_file->f_pos);
+	size = vfs_write(lower_file, (char __user *)page_virt, PAGE_CACHE_SIZE,
+			 &lower_file->f_pos);
+	if (size < 0) {
+		rc = (int)size;
+		printk(KERN_ERR "Error attempting to write lower page; "
+		       "rc = [%d]\n", rc);
+		set_fs(oldfs);
+		goto out;
+	}
 	header_pages = ((crypt_stat->header_extent_size
 			 * crypt_stat->num_header_extents_at_front)
 			/ PAGE_CACHE_SIZE);
 	memset(page_virt, 0, PAGE_CACHE_SIZE);
 	current_header_page = 1;
 	while (current_header_page < header_pages) {
-		lower_file->f_op->write(lower_file, (char __user *)page_virt,
-					PAGE_CACHE_SIZE, &lower_file->f_pos);
+		size = vfs_write(lower_file, (char __user *)page_virt,
+				 PAGE_CACHE_SIZE, &lower_file->f_pos);
+		if (size < 0) {
+			rc = (int)size;
+			printk(KERN_ERR "Error attempting to write lower page; "
+			       "rc = [%d]\n", rc);
+			set_fs(oldfs);
+			goto out;
+		}
 		current_header_page++;
 	}
 	set_fs(oldfs);
-	return 0;
+out:
+	return rc;
 }
 
 int ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
diff -puN fs/ecryptfs/inode.c~ecryptfs-convert-f_op-write-to-vfs_write fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-convert-f_op-write-to-vfs_write
+++ a/fs/ecryptfs/inode.c
@@ -201,7 +201,7 @@ static int ecryptfs_initialize_file(stru
 			lower_dentry->d_name.name);
 	inode = ecryptfs_dentry->d_inode;
 	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
-	lower_flags = ((O_CREAT | O_WRONLY | O_TRUNC) & O_ACCMODE) | O_RDWR;
+	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
 #if BITS_PER_LONG != 32
 	lower_flags |= O_LARGEFILE;
 #endif
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
