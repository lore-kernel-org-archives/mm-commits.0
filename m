From: akpm@linux-foundation.org
Subject: [to-be-updated] fat-additions-to-support-fat_fallocate-v6.patch
 removed from -mm tree
Date: Thu, 10 Oct 2013 14:59:26 -0700
Message-ID: <5257233e.DfvO/uFNBsIHiSit%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JJV71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:59:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ravi.n1@samsung.com, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-additions-to-support-fat_fallocate-v6.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,ravi.n1@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:59:26 -0700


The patch titled
     Subject: fat: additions to support fat_fallocate
has been removed from the -mm tree.  Its filename was
     fat-additions-to-support-fat_fallocate-v6.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: additions to support fat_fallocate

v6: In v3 of the patch we released the allocated clutsers in
fat_file_release on the basis of d_count. Moving this from fat_file_release
to fat_evict_inode and on the basis of i_count , so that allocated
clusters are released at the last refrence of the inode when inode
evicts from memory .

In case of direct IO , writting in fallocated area fall back to
buffered write.

Support for fibmap is also added for fallocated region
by modifying fat_bmap to map cluster in case of read request
for a block in fallocated region.

v5: change to avoid compilation warning:
  fs/fat/inode.c: In function 'fat_zero_falloc_area':
>> fs/fat/inode.c:169:11: warning: comparison of distinct pointer
types lacks a cast [enabled by default]

v4: Rework based on review comments.
Add check in fat_setattr to release fallocated blocks on a truncate

v3: Release preallocated blocks at file release.

With FALLOC_FL_KEEP_SIZE, there is no way to distinguish if the
mismatch between i_size and no. of clusters allocated is a consequence
of fallocate or just plain corruption. When a non fallocate aware (old)
linux fat driver tries to write to such a file, it throws an error.Also,
fsck detects this as inconsistency and truncates the prealloc'd blocks.

To avoid this, as suggested by OGAWA, remove changes that make fallocate
persistent across mounts and restrict lifetime of blocks from
fallocate(2) to file release.

v2: On an area preallocated with FALLOC_FL_KEEP_SIZE, when a seek was
done to an offset beyond i_size, the old (garbage) data was exposed as
we did not zero out the area at allocation time. Added
fat_zero_falloc_area() to fix this.

v1: Reworked an earlier patch of the same name
(https://lkml.org/lkml/2007/12/22/130) to fix some bugs:
i) Preallocated space was not persistent and was lost on remount. Fixed
it.
ii) Did not zero out allocated clusters when FALLOC_FL_KEEP_SIZE was set,
thereby speeding up preallocation time.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Ravishankar N <ravi.n1@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |   16 +++++++++++++---
 fs/fat/file.c  |   25 ++-----------------------
 fs/fat/inode.c |   38 ++++++++++++++++++++++++++++----------
 3 files changed, 43 insertions(+), 36 deletions(-)

diff -puN fs/fat/cache.c~fat-additions-to-support-fat_fallocate-v6 fs/fat/cache.c
--- a/fs/fat/cache.c~fat-additions-to-support-fat_fallocate-v6
+++ a/fs/fat/cache.c
@@ -312,6 +312,7 @@ int fat_bmap(struct inode *inode, sector
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
 	int cluster, offset;
+	loff_t i_size = i_size_read(inode);
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -323,11 +324,19 @@ int fat_bmap(struct inode *inode, sector
 		return 0;
 	}
 
-	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	last_block = (i_size + (blocksize - 1)) >> blocksize_bits;
 	if (sector >= last_block) {
-		if (!create)
-			return 0;
+		if (!create) {
+			/*
+ 			 * to map cluster in case of read request
+			 * for a block in fallocated region
+ 			 */
+  			if (MSDOS_I(inode)->mmu_private >
+				round_up(i_size, sb->s_blocksize))
+				goto out_map_cluster;
 
+			return 0;
+		}
 		/*
 		 * ->mmu_private can access on only allocation path.
 		 * (caller must hold ->i_mutex)
@@ -338,6 +347,7 @@ int fat_bmap(struct inode *inode, sector
 			return 0;
 	}
 
+out_map_cluster:
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
 	cluster = fat_bmap_cluster(inode, cluster);
diff -puN fs/fat/file.c~fat-additions-to-support-fat_fallocate-v6 fs/fat/file.c
--- a/fs/fat/file.c~fat-additions-to-support-fat_fallocate-v6
+++ a/fs/fat/file.c
@@ -151,22 +151,6 @@ static long fat_generic_compat_ioctl(str
 
 static int fat_file_release(struct inode *inode, struct file *filp)
 {
-
-	struct super_block *sb = inode->i_sb;
-	loff_t mmu_private_ideal;
-
-	/*
-	 * Release unwritten fallocated blocks on file release.
-	 * Do this only when the last open file descriptor is closed.
-	 */
-	mutex_lock(&inode->i_mutex);
-	mmu_private_ideal = round_up(inode->i_size, sb->s_blocksize);
-
-	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
-	    d_count(filp->f_dentry) == 1)
-		fat_truncate_blocks(inode, inode->i_size);
-	mutex_unlock(&inode->i_mutex);
-
 	if ((filp->f_mode & FMODE_WRITE) &&
 	     MSDOS_SB(inode->i_sb)->options.flush) {
 		fat_flush_inodes(inode->i_sb, inode, NULL);
@@ -245,8 +229,7 @@ out:
  * operation, which gets called from sys_fallocate system call. User
  * space requests len bytes at offset. If FALLOC_FL_KEEP_SIZE is set
  * we just allocate clusters without zeroing them out. Otherwise we
- * allocate and zero out clusters via an expanding truncate. The
- * allocated clusters are freed in fat_file_release().
+ * allocate and zero out clusters via an expanding truncate.
  */
 static long fat_fallocate(struct file *file, int mode,
 				loff_t offset, loff_t len)
@@ -488,9 +471,6 @@ int fat_setattr(struct dentry *dentry, s
 	struct inode *inode = dentry->d_inode;
 	unsigned int ia_valid;
 	int error;
-	loff_t mmu_private_ideal;
-
-	mmu_private_ideal = round_up(inode->i_size, dentry->d_sb->s_blocksize);
 
 	/* Check for setting the inode time. */
 	ia_valid = attr->ia_valid;
@@ -516,8 +496,7 @@ int fat_setattr(struct dentry *dentry, s
 	if (attr->ia_valid & ATTR_SIZE) {
 		inode_dio_wait(inode);
 
-		if (attr->ia_size > inode->i_size &&
-		    MSDOS_I(inode)->mmu_private <= mmu_private_ideal) {
+		if (attr->ia_size > inode->i_size) {
 			error = fat_cont_expand(inode, attr->ia_size);
 			if (error || attr->ia_valid == ATTR_SIZE)
 				goto out;
diff -puN fs/fat/inode.c~fat-additions-to-support-fat_fallocate-v6 fs/fat/inode.c
--- a/fs/fat/inode.c~fat-additions-to-support-fat_fallocate-v6
+++ a/fs/fat/inode.c
@@ -171,15 +171,15 @@ static int fat_zero_falloc_area(struct f
 		bytes = min(bytes, count);
 
 		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
-					AOP_FLAG_UNINTERRUPTIBLE,
-					&page, &fsdata);
+				AOP_FLAG_UNINTERRUPTIBLE,
+				&page, &fsdata);
 		if (err)
 			break;
 
 		zero_user(page, offset, bytes);
 
 		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
-					page, fsdata);
+				page, fsdata);
 		if (err < 0)
 			break;
 		curpos += bytes;
@@ -195,15 +195,12 @@ static int fat_write_begin(struct file *
 			struct page **pagep, void **fsdata)
 {
 	int err;
-	loff_t mmu_private_ideal, mmu_private_actual;
-	loff_t size;
 	struct inode *inode = mapping->host;
 	struct super_block *sb = inode->i_sb;
+	loff_t i_size = i_size_read(inode);
 
-	size = i_size_read(inode);
-	mmu_private_actual = MSDOS_I(inode)->mmu_private;
-	mmu_private_ideal = round_up(size, sb->s_blocksize);
-	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
+	if (MSDOS_I(inode)->mmu_private > round_up(i_size, sb->s_blocksize)
+			&& pos > i_size) {
 		err = fat_zero_falloc_area(file, mapping, pos);
 		if (err) {
 			fat_msg(sb, KERN_ERR,
@@ -215,7 +212,7 @@ static int fat_write_begin(struct file *
 	*pagep = NULL;
 	err = cont_write_begin(file, mapping, pos, len, flags,
 				pagep, fsdata, fat_get_block,
-				&MSDOS_I(mapping->host)->mmu_private);
+				&MSDOS_I(inode)->mmu_private);
 	if (err < 0)
 		fat_write_failed(mapping, pos + len);
 	return err;
@@ -260,6 +257,14 @@ static ssize_t fat_direct_IO(int rw, str
 		loff_t size = offset + iov_length(iov, nr_segs);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
+		/*
+ 		 * In case of writing in fallocated region, return 0 and
+ 		 * fallback to buffered write.
+ 		 */
+		if (MSDOS_I(inode)->mmu_private >
+			round_up(i_size_read(inode), inode->i_sb->s_blocksize))
+			return 0;
+
 	}
 
 	/*
@@ -544,6 +549,19 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 
 static void fat_evict_inode(struct inode *inode)
 {
+
+	struct super_block *sb = inode->i_sb;
+
+	/*
+	 * Release unwritten fallocated blocks on file release.
+	 * Do this only when the inode evict and i_count becomes 0.
+	 */
+	mutex_lock(&inode->i_mutex);
+	if (round_up(inode->i_size, sb->s_blocksize) <
+	    MSDOS_I(inode)->mmu_private && atomic_read(&inode->i_count) == 0)
+		fat_truncate_blocks(inode, inode->i_size);
+	mutex_unlock(&inode->i_mutex);
+
 	truncate_inode_pages(&inode->i_data, 0);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch

