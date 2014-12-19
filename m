From: akpm@linux-foundation.org
Subject: [to-be-updated] fat-add-fat_fallocate-operation.patch removed
 from -mm tree
Date: Fri, 19 Dec 2014 15:29:11 -0800
Message-ID: <5494b4c7.rMWt61+KS871uQAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLSX3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 18:29:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add fat_fallocate operation
has been removed from the -mm tree.  Its filename was
     fat-add-fat_fallocate-operation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: add fat_fallocate operation

Implement preallocation via the fallocate syscall on VFAT partitions. 
This patch is based on an earlier patch of the same name which had some
issues detailed below and did not get accepted.  Refer
https://lkml.org/lkml/2007/12/22/130.

a) The preallocated space was not persistent when the
   FALLOC_FL_KEEP_SIZE flag was set.  It will deallocate cluster at evict
   time.

b) There was no need to zero out the clusters when the flag was set
   Instead of doing an expanding truncate, just allocate clusters and add
   them to the fat chain.  This reduces preallocation time.

Compatibility with windows:

There are no issues when FALLOC_FL_KEEP_SIZE is not set because it just
does an expanding truncate.  Thus reading from the preallocated area on
windows returns null until data is written to it.

When a file with preallocated area using the FALLOC_FL_KEEP_SIZE was
written to on windows, the windows driver freed-up the preallocated
clusters and allocated new clusters for the new data.  The freed up
clusters gets reflected in the free space available for the partition
which can be seen from the Volume properties.

The windows chkdsk tool also does not report any errors on a disk
containing files with preallocated space.

And there is also no issue using linux fat fsck.  because discard
preallocated clusters at repair time.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 
 fs/fat/file.c  |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/inode.c |   25 ++++++++++++++++++
 3 files changed, 87 insertions(+), 1 deletion(-)

diff -puN fs/fat/fat.h~fat-add-fat_fallocate-operation fs/fat/fat.h
--- a/fs/fat/fat.h~fat-add-fat_fallocate-operation
+++ a/fs/fat/fat.h
@@ -387,6 +387,7 @@ static inline unsigned long fat_dir_hash
 {
 	return hash_32(logstart, FAT_HASH_BITS);
 }
+extern int fat_add_cluster(struct inode *inode);
 
 /* fat/misc.c */
 extern __printf(3, 4) __cold
diff -puN fs/fat/file.c~fat-add-fat_fallocate-operation fs/fat/file.c
--- a/fs/fat/file.c~fat-add-fat_fallocate-operation
+++ a/fs/fat/file.c
@@ -17,8 +17,12 @@
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 #include "fat.h"
 
+static long fat_fallocate(struct file *file, int mode,
+			  loff_t offset, loff_t len);
+
 static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
 {
 	u32 attr;
@@ -182,6 +186,7 @@ const struct file_operations fat_file_op
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate	= fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -220,6 +225,63 @@ out:
 	return err;
 }
 
+/*
+ * Preallocate space for a file. This implements fat's fallocate file
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset. If FALLOC_FL_KEEP_SIZE is set
+ * we just allocate clusters without zeroing them out. Otherwise we
+ * allocate and zero out clusters via an expanding truncate.
+ */
+static long fat_fallocate(struct file *file, int mode,
+			  loff_t offset, loff_t len)
+{
+	int nr_cluster; /* Number of clusters to be allocated */
+	loff_t mm_bytes; /* Number of bytes to be allocated for file */
+	loff_t ondisksize; /* block aligned on-disk size in bytes*/
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int err = 0;
+
+	/* No support for hole punch or other fallocate flags. */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	/* No support for dir */
+	if (!S_ISREG(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&inode->i_mutex);
+	if (mode & FALLOC_FL_KEEP_SIZE) {
+		ondisksize = inode->i_blocks << 9;
+		if ((offset + len) <= ondisksize)
+			goto error;
+
+		/* First compute the number of clusters to be allocated */
+		mm_bytes = offset + len - ondisksize;
+		nr_cluster = (mm_bytes + (sbi->cluster_size - 1)) >>
+			sbi->cluster_bits;
+
+		/* Start the allocation.We are not zeroing out the clusters */
+		while (nr_cluster-- > 0) {
+			err = fat_add_cluster(inode);
+			if (err)
+				goto error;
+		}
+	} else {
+		err = inode_newsize_ok(inode, (offset + len));
+		if (err)
+			goto error;
+
+		/* This is just an expanding truncate */
+		err = fat_cont_expand(inode, (offset + len));
+	}
+
+error:
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
 /* Free all clusters after the skip'th cluster. */
 static int fat_free(struct inode *inode, int skip)
 {
diff -puN fs/fat/inode.c~fat-add-fat_fallocate-operation fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-fat_fallocate-operation
+++ a/fs/fat/inode.c
@@ -101,7 +101,7 @@ static struct fat_floppy_defaults {
 },
 };
 
-static int fat_add_cluster(struct inode *inode)
+int fat_add_cluster(struct inode *inode)
 {
 	int err, cluster;
 
@@ -562,12 +562,35 @@ out:
 
 EXPORT_SYMBOL_GPL(fat_build_inode);
 
+static int __fat_write_inode(struct inode *inode, int wait);
 static void fat_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
+	} else {
+		/* Release unwritten fallocated blocks on inode eviction. */
+		if ((inode->i_blocks << 9) >
+		    round_up(MSDOS_I(inode)->mmu_private,
+				inode->i_sb->s_blocksize)) {
+			int err;
+
+			fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
+			/* Fallocate results in updating the i_start/iogstart
+			 * for the zero byte file. So, make it return to
+			 * original state during evict and commit it to avoid
+			 * any corruption on the next access to the cluster
+			 * chain for the file.
+			 */
+			err = __fat_write_inode(inode, inode_needs_sync(inode));
+			if (err) {
+				fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
+				"update on disk inode for unused fallocated "
+				"blocks, inode could be corrupted. Please run "
+				"fsck");
+			}
+		}
 	}
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

