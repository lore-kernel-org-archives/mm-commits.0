Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E245854BD2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970595; cv=none; b=GsY//Gt4xVaWFiz8AaW3i1aMZ/kkRNXJu1Lfgl4/LHbgUlglnSq7RckBi+x6M1W2I2lGlc9GllL7H1swTCEkFxRI34Qgvl/3KyF2kD6iUlvld+XN7Bghi9o5un9f78jyv1bCVNPjEHQ2x9yjNHtlffRPWUQfdiXmsWRil/svXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970595; c=relaxed/simple;
	bh=JbIlB6sRZX3W5YBnZU+L+9Xx/i16yVper4JZ0BovtN0=;
	h=Date:To:From:Subject:Message-Id; b=SfnDqtJ1tB0eoxHRsWkUg+BdfS6pX+Mz+gOsq71TTO63Ga4dHh/02khFOLJLqLptvb5CSt/VpRpspwgSyCOYtEiAHR7+Pmx1LLL94/fvoSXj4vDvGxyy5hTW0fhHu6YAHTaWwu7xQezE1HZtF62S8mxNuY+ca+y5CELhF53834I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B34Sa8yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B34Sa8yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B197C433C7;
	Tue, 23 Jan 2024 00:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970594;
	bh=JbIlB6sRZX3W5YBnZU+L+9Xx/i16yVper4JZ0BovtN0=;
	h=Date:To:From:Subject:From;
	b=B34Sa8ypPN5zYm2qWwY0IcfQGqmV1YTc+87lCdEuEaUgAGd3CD6gDnrt0nGY42Ah4
	 +th1mhP3S5Iruwvla1GyQqdIJKrCPnuaj/Oep+zUlUDuVwBYvu6BggRRCNLJoquIZL
	 8PqL04T4XImsy7SN35SrcS4k573bb6TBvN0asl08=
Date: Mon, 22 Jan 2024 16:43:11 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004314.4B197C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: localize highmem mapping for checkpoint reading within cpfile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-convert-recovery-logic-to-use-kmap_local.patch
nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

