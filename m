Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3244140367
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645198; cv=none; b=oxxfHE7eBNAZU5AQ+epKGgXdER+b9IFgexU8l8VdU8MbTAO0otMZsaZovhFTgIH9fzoKguSB6vcnfXVXvW+mNo+YrCeio3OEsVQ3UR9Sm/KiTDmm8R0hqrDFNXldGEsoqYgdNYeL8Pfl1tUARC+cCaQD7sH9v9AeQyLSVhCa1mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645198; c=relaxed/simple;
	bh=5pZSHyGY5DgPMIk/j3vmWlUk6Rp6iMEWnr0A5cKWGwQ=;
	h=Date:To:From:Subject:Message-Id; b=CtfbnBwE7qHzm4eSrj1BApGEWXIRDoM7iSBl8HBBso6uJIIWjsUHEizDL5eig2We+wlRz8Cyo19+VrVt65B97hqgzAnnkvoQnS3jHiB8OQoo9qEfv/R47yX91SZI0AYCgyczZygNchgZgvZKL6ZoL/L9efgU7oKQsjgGjSGO2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mV+7Fp79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mV+7Fp79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FA5C43390;
	Thu, 22 Feb 2024 23:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645197;
	bh=5pZSHyGY5DgPMIk/j3vmWlUk6Rp6iMEWnr0A5cKWGwQ=;
	h=Date:To:From:Subject:From;
	b=mV+7Fp79VuVf21ATGpZmB2zKnUzOhFKjh1uzIAzK91mMGJNxYNSLgCT1xBeKC+BU6
	 46aUAK1msXcY79o3sY9a64ZkOg7L50s0TK6ihTvH5XCFwy6lIlgCyYexalLotiBlt+
	 unNn1jXMT1dQgqRvjGtNZraemtCfpJbPeLhO6SQw=
Date: Thu, 22 Feb 2024 15:39:56 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch removed from -mm tree
Message-Id: <20240222233957.77FA5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: localize highmem mapping for checkpoint reading within cpfile
has been removed from the -mm tree.  Its filename was
     nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: localize highmem mapping for checkpoint reading within cpfile
Date: Mon, 22 Jan 2024 23:02:00 +0900

Move the code for reading from a checkpoint entry that is performed in
nilfs_attach_checkpoint() to the cpfile side, and make the page mapping
local and temporary.  And use kmap_local instead of kmap to access the
checkpoint entry page.

In order to load the ifile inode information included in the checkpoint
entry within the inode lock section of nilfs_ifile_read(), the newly added
checkpoint reading method nilfs_cpfile_read_checkpoint() is called
indirectly via nilfs_ifile_read() instead of from
nilfs_attach_checkpoint().

Link: https://lkml.kernel.org/r/20240122140202.6950-14-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   68 +++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.h |    2 +
 fs/nilfs2/ifile.c  |   17 ++++++----
 fs/nilfs2/ifile.h  |    3 -
 fs/nilfs2/super.c  |   31 +++----------------
 5 files changed, 87 insertions(+), 34 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile
+++ a/fs/nilfs2/cpfile.c
@@ -187,6 +187,74 @@ static inline int nilfs_cpfile_delete_ch
 }
 
 /**
+ * nilfs_cpfile_read_checkpoint - read a checkpoint entry in cpfile
+ * @cpfile: checkpoint file inode
+ * @cno:    number of checkpoint entry to read
+ * @root:   nilfs root object
+ * @ifile:  ifile's inode to read and attach to @root
+ *
+ * This function imports checkpoint information from the checkpoint file and
+ * stores it to the inode file given by @ifile and the nilfs root object
+ * given by @root.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
+ */
+int nilfs_cpfile_read_checkpoint(struct inode *cpfile, __u64 cno,
+				 struct nilfs_root *root, struct inode *ifile)
+{
+	struct buffer_head *cp_bh;
+	struct nilfs_checkpoint *cp;
+	void *kaddr;
+	int ret;
+
+	if (cno < 1 || cno > nilfs_mdt_cno(cpfile))
+		return -EINVAL;
+
+	down_read(&NILFS_MDT(cpfile)->mi_sem);
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
+	if (unlikely(ret < 0)) {
+		if (ret == -ENOENT)
+			ret = -EINVAL;
+		goto out_sem;
+	}
+
+	kaddr = kmap_local_page(cp_bh->b_page);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	if (nilfs_checkpoint_invalid(cp)) {
+		ret = -EINVAL;
+		goto put_cp;
+	}
+
+	ret = nilfs_read_inode_common(ifile, &cp->cp_ifile_inode);
+	if (unlikely(ret)) {
+		/*
+		 * Since this inode is on a checkpoint entry, treat errors
+		 * as metadata corruption.
+		 */
+		nilfs_err(cpfile->i_sb,
+			  "ifile inode (checkpoint number=%llu) corrupted",
+			  (unsigned long long)cno);
+		ret = -EIO;
+		goto put_cp;
+	}
+
+	/* Configure the nilfs root object */
+	atomic64_set(&root->inodes_count, le64_to_cpu(cp->cp_inodes_count));
+	atomic64_set(&root->blocks_count, le64_to_cpu(cp->cp_blocks_count));
+	root->ifile = ifile;
+
+put_cp:
+	kunmap_local(kaddr);
+	brelse(cp_bh);
+out_sem:
+	up_read(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_cpfile_get_checkpoint - get a checkpoint
  * @cpfile: inode of checkpoint file
  * @cno: checkpoint number
--- a/fs/nilfs2/cpfile.h~nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile
+++ a/fs/nilfs2/cpfile.h
@@ -19,6 +19,8 @@
 int nilfs_cpfile_get_checkpoint(struct inode *, __u64, int,
 				struct nilfs_checkpoint **,
 				struct buffer_head **);
+int nilfs_cpfile_read_checkpoint(struct inode *cpfile, __u64 cno,
+				 struct nilfs_root *root, struct inode *ifile);
 int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno);
 void nilfs_cpfile_put_checkpoint(struct inode *, __u64, struct buffer_head *);
 int nilfs_cpfile_finalize_checkpoint(struct inode *cpfile, __u64 cno,
--- a/fs/nilfs2/ifile.c~nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile
+++ a/fs/nilfs2/ifile.c
@@ -15,6 +15,7 @@
 #include "mdt.h"
 #include "alloc.h"
 #include "ifile.h"
+#include "cpfile.h"
 
 /**
  * struct nilfs_ifile_info - on-memory private data of ifile
@@ -173,14 +174,18 @@ int nilfs_ifile_count_free_inodes(struct
  * nilfs_ifile_read - read or get ifile inode
  * @sb: super block instance
  * @root: root object
+ * @cno: number of checkpoint entry to read
  * @inode_size: size of an inode
- * @raw_inode: on-disk ifile inode
- * @inodep: buffer to store the inode
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
  */
 int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
-		     size_t inode_size, struct nilfs_inode *raw_inode,
-		     struct inode **inodep)
+		     __u64 cno, size_t inode_size)
 {
+	struct the_nilfs *nilfs;
 	struct inode *ifile;
 	int err;
 
@@ -201,13 +206,13 @@ int nilfs_ifile_read(struct super_block
 
 	nilfs_palloc_setup_cache(ifile, &NILFS_IFILE_I(ifile)->palloc_cache);
 
-	err = nilfs_read_inode_common(ifile, raw_inode);
+	nilfs = sb->s_fs_info;
+	err = nilfs_cpfile_read_checkpoint(nilfs->ns_cpfile, cno, root, ifile);
 	if (err)
 		goto failed;
 
 	unlock_new_inode(ifile);
  out:
-	*inodep = ifile;
 	return 0;
  failed:
 	iget_failed(ifile);
--- a/fs/nilfs2/ifile.h~nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile
+++ a/fs/nilfs2/ifile.h
@@ -38,7 +38,6 @@ int nilfs_ifile_get_inode_block(struct i
 int nilfs_ifile_count_free_inodes(struct inode *, u64 *, u64 *);
 
 int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
-		     size_t inode_size, struct nilfs_inode *raw_inode,
-		     struct inode **inodep);
+		     __u64 cno, size_t inode_size);
 
 #endif	/* _NILFS_IFILE_H */
--- a/fs/nilfs2/super.c~nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile
+++ a/fs/nilfs2/super.c
@@ -544,8 +544,6 @@ int nilfs_attach_checkpoint(struct super
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_root *root;
-	struct nilfs_checkpoint *raw_cp;
-	struct buffer_head *bh_cp;
 	int err = -ENOMEM;
 
 	root = nilfs_find_or_create_root(
@@ -557,38 +555,19 @@ int nilfs_attach_checkpoint(struct super
 		goto reuse; /* already attached checkpoint */
 
 	down_read(&nilfs->ns_segctor_sem);
-	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
-					  &bh_cp);
+	err = nilfs_ifile_read(sb, root, cno, nilfs->ns_inode_size);
 	up_read(&nilfs->ns_segctor_sem);
-	if (unlikely(err)) {
-		if (err == -ENOENT || err == -EINVAL) {
-			nilfs_err(sb,
-				  "Invalid checkpoint (checkpoint number=%llu)",
-				  (unsigned long long)cno);
-			err = -EINVAL;
-		}
+	if (unlikely(err))
 		goto failed;
-	}
-
-	err = nilfs_ifile_read(sb, root, nilfs->ns_inode_size,
-			       &raw_cp->cp_ifile_inode, &root->ifile);
-	if (err)
-		goto failed_bh;
-
-	atomic64_set(&root->inodes_count,
-			le64_to_cpu(raw_cp->cp_inodes_count));
-	atomic64_set(&root->blocks_count,
-			le64_to_cpu(raw_cp->cp_blocks_count));
-
-	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
 
  reuse:
 	*rootp = root;
 	return 0;
 
- failed_bh:
-	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
  failed:
+	if (err == -EINVAL)
+		nilfs_err(sb, "Invalid checkpoint (checkpoint number=%llu)",
+			  (unsigned long long)cno);
 	nilfs_put_root(root);
 
 	return err;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


