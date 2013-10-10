From: akpm@linux-foundation.org
Subject: [to-be-updated] fat-additions-to-support-fat_fallocate.patch
 removed from -mm tree
Date: Thu, 10 Oct 2013 14:59:24 -0700
Message-ID: <5257233c.ZoIaz95jrdMHYLtc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JJV7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ravi.n1@samsung.com, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-additions-to-support-fat_fallocate.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,ravi.n1@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:59:24 -0700


The patch titled
     Subject: fat: additions to support fat_fallocate
has been removed from the -mm tree.  Its filename was
     fat-additions-to-support-fat_fallocate.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: additions to support fat_fallocate

Implement preallocation via the fallocate syscall on VFAT partitions.

With FALLOC_FL_KEEP_SIZE, there is no way to distinguish if the mismatch
between i_size and no.  of clusters allocated is a consequence of
fallocate or just plain corruption.  When a non fallocate aware (old)
linux fat driver tries to write to such a file, it throws an error.Also,
fsck detects this as inconsistency and truncates the prealloc'd blocks.

To avoid this, as suggested by OGAWA, remove changes that make fallocate
persistent across mounts and restrict lifetime of blocks from fallocate(2)
to file release.

[akpm@linux-foundation.org: fix min() warning]
[akpm@linux-foundation.org: use the new d_count()]
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c  |  108 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fat/inode.c |   54 +++++++++++++++++++++++
 2 files changed, 161 insertions(+), 1 deletion(-)

diff -puN fs/fat/file.c~fat-additions-to-support-fat_fallocate fs/fat/file.c
--- a/fs/fat/file.c~fat-additions-to-support-fat_fallocate
+++ a/fs/fat/file.c
@@ -17,8 +17,11 @@
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 #include "fat.h"
 
+static long fat_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len);
 static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
 {
 	u32 attr;
@@ -148,6 +151,22 @@ static long fat_generic_compat_ioctl(str
 
 static int fat_file_release(struct inode *inode, struct file *filp)
 {
+
+	struct super_block *sb = inode->i_sb;
+	loff_t mmu_private_ideal;
+
+	/*
+	 * Release unwritten fallocated blocks on file release.
+	 * Do this only when the last open file descriptor is closed.
+	 */
+	mutex_lock(&inode->i_mutex);
+	mmu_private_ideal = round_up(inode->i_size, sb->s_blocksize);
+
+	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
+	    d_count(filp->f_dentry) == 1)
+		fat_truncate_blocks(inode, inode->i_size);
+	mutex_unlock(&inode->i_mutex);
+
 	if ((filp->f_mode & FMODE_WRITE) &&
 	     MSDOS_SB(inode->i_sb)->options.flush) {
 		fat_flush_inodes(inode->i_sb, inode, NULL);
@@ -182,6 +201,7 @@ const struct file_operations fat_file_op
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate      = fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -220,6 +240,88 @@ out:
 	return err;
 }
 
+/*
+ * Preallocate space for a file. This implements fat's fallocate file
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset. If FALLOC_FL_KEEP_SIZE is set
+ * we just allocate clusters without zeroing them out. Otherwise we
+ * allocate and zero out clusters via an expanding truncate. The
+ * allocated clusters are freed in fat_file_release().
+ */
+static long fat_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len)
+{
+	int cluster, fclus, dclus;
+	int nr_cluster; /* Number of clusters to be allocated */
+	loff_t nr_bytes; /* Number of bytes to be allocated*/
+	loff_t free_bytes; /* Unused bytes in the last cluster of file*/
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int err = 0;
+
+	/* No support for hole punch or other fallocate flags. */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&inode->i_mutex);
+	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
+		fat_msg(sb, KERN_ERR,
+			"fat_fallocate(): Blocks already allocated");
+		err = -EINVAL;
+		goto error;
+	}
+
+	if (mode & FALLOC_FL_KEEP_SIZE) {
+		/* First compute the number of clusters to be allocated */
+		if (inode->i_size > 0) {
+			err = fat_get_cluster(inode, FAT_ENT_EOF,
+					      &fclus, &dclus);
+			if (err < 0) {
+				fat_msg(sb, KERN_ERR,
+					"fat_fallocate(): fat_get_cluster() error");
+				goto error;
+			}
+			free_bytes = ((fclus + 1) << sbi->cluster_bits) -
+				     inode->i_size;
+			nr_bytes = offset + len - inode->i_size - free_bytes;
+			MSDOS_I(inode)->mmu_private = (fclus + 1) <<
+						      sbi->cluster_bits;
+		} else
+			nr_bytes = offset + len - inode->i_size;
+
+		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
+			     sbi->cluster_bits;
+
+		/* Start the allocation.We are not zeroing out the clusters */
+		while (nr_cluster-- > 0) {
+			err = fat_alloc_clusters(inode, &cluster, 1);
+			if (err) {
+				fat_msg(sb, KERN_ERR,
+					"fat_fallocate(): fat_alloc_clusters() error");
+				goto error;
+			}
+			err = fat_chain_add(inode, cluster, 1);
+			if (err) {
+				fat_free_clusters(inode, cluster);
+				goto error;
+			}
+			MSDOS_I(inode)->mmu_private += sbi->cluster_size;
+		}
+	} else {
+		/* This is just an expanding truncate */
+		err = fat_cont_expand(inode, (offset + len));
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+				"fat_fallocate(): fat_cont_expand() error");
+		}
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
@@ -386,6 +488,9 @@ int fat_setattr(struct dentry *dentry, s
 	struct inode *inode = dentry->d_inode;
 	unsigned int ia_valid;
 	int error;
+	loff_t mmu_private_ideal;
+
+	mmu_private_ideal = round_up(inode->i_size, dentry->d_sb->s_blocksize);
 
 	/* Check for setting the inode time. */
 	ia_valid = attr->ia_valid;
@@ -411,7 +516,8 @@ int fat_setattr(struct dentry *dentry, s
 	if (attr->ia_valid & ATTR_SIZE) {
 		inode_dio_wait(inode);
 
-		if (attr->ia_size > inode->i_size) {
+		if (attr->ia_size > inode->i_size &&
+		    MSDOS_I(inode)->mmu_private <= mmu_private_ideal) {
 			error = fat_cont_expand(inode, attr->ia_size);
 			if (error || attr->ia_valid == ATTR_SIZE)
 				goto out;
diff -puN fs/fat/inode.c~fat-additions-to-support-fat_fallocate fs/fat/inode.c
--- a/fs/fat/inode.c~fat-additions-to-support-fat_fallocate
+++ a/fs/fat/inode.c
@@ -152,11 +152,65 @@ static void fat_write_failed(struct addr
 	}
 }
 
+static int fat_zero_falloc_area(struct file *file,
+				struct address_space *mapping, loff_t pos)
+{
+	struct page *page;
+	struct inode *inode = mapping->host;
+	loff_t curpos = i_size_read(inode);
+	size_t count = pos - curpos;
+	int err;
+
+	do {
+		unsigned offset;
+		size_t bytes;
+		void *fsdata;
+
+		offset = (curpos & (PAGE_CACHE_SIZE - 1));
+		bytes = PAGE_CACHE_SIZE - offset;
+		bytes = min(bytes, count);
+
+		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
+					AOP_FLAG_UNINTERRUPTIBLE,
+					&page, &fsdata);
+		if (err)
+			break;
+
+		zero_user(page, offset, bytes);
+
+		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
+					page, fsdata);
+		if (err < 0)
+			break;
+		curpos += bytes;
+		count -= bytes;
+		err = 0;
+	} while (count);
+
+	return err;
+}
+
 static int fat_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
 	int err;
+	loff_t mmu_private_ideal, mmu_private_actual;
+	loff_t size;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+
+	size = i_size_read(inode);
+	mmu_private_actual = MSDOS_I(inode)->mmu_private;
+	mmu_private_ideal = round_up(size, sb->s_blocksize);
+	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
+		err = fat_zero_falloc_area(file, mapping, pos);
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+				"Error (%d) zeroing fallocated area", err);
+			return err;
+		}
+	}
 
 	*pagep = NULL;
 	err = cont_write_begin(file, mapping, pos, len, flags,
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-additions-to-support-fat_fallocate-v6.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch

