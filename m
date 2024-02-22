Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A143013BAD8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645193; cv=none; b=UvTvcKxhk4WqGstw4E8bvKfK4mn/uc2oAH79LaTndE1mZd6W9wN++fc/Hif9lB0dJ2EmPRXLch1rmcTJ0EeFrrrjVXaVowpR8sM0ODF6j7E1tF6q80b1VzS4dYta9bHl/yWEF8n5o2+PuNisOKDyqdOQS7/eVNqBW0fYmNX+O/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645193; c=relaxed/simple;
	bh=7SoZLxlWwRDrPy0FV7YTSO7j8zE/e86gGL+ufTqI1bY=;
	h=Date:To:From:Subject:Message-Id; b=t8jafmqUU6bfg7QIZO/0K2iTjvqtLfcmIotrS/+K2AqtvZIWNd+J/Swb5aeJP2oAF+MNnxcn6uhYN2ulGa18Hr43PhhFTapuNx6rl08ezssRlEjG09dirkIv58ro//JvxunqG8iCKfeFTWC+8jQEMlrg3Ty8b62IAjzV+NouK4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Os8OmYsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Os8OmYsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4ECC433F1;
	Thu, 22 Feb 2024 23:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645193;
	bh=7SoZLxlWwRDrPy0FV7YTSO7j8zE/e86gGL+ufTqI1bY=;
	h=Date:To:From:Subject:From;
	b=Os8OmYsy1gRvIQE3gb7Jr0uCIz+pJ2R7gKIOud9fakU2P/uyDNOf1BkL1tgba32fT
	 wn/uNU1xHcTFNTWUei9uYrsBL/oDROsr9VNED9Na2uol4yFpJutQJ4/xDPEchCbbNh
	 zlaZfgvP41Ob+3lFSuNmZNtTBdkiaPymRvswaifY=
Date: Thu, 22 Feb 2024 15:39:52 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch removed from -mm tree
Message-Id: <20240222233953.3A4ECC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: move nilfs_bmap_write call out of nilfs_write_inode_common
has been removed from the -mm tree.  Its filename was
     nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: move nilfs_bmap_write call out of nilfs_write_inode_common
Date: Mon, 22 Jan 2024 23:01:55 +0900

Before converting the disk inode management metadata file ifile, the call
to nilfs_bmap_write(), the i_device_code setting, and the zero-fill code
for inodes on the super root block are moved from
nilfs_write_inode_common() to its callers.

This cleanup simplifies the role and arguments of
nilfs_write_inode_common() and collects calls to nilfs_bmap_write() to the
log writing code.

Also, add and use a new helper nilfs_write_root_mdt_inode() to avoid code
duplication in the data export routine nilfs_segctor_fill_in_super_root()
to the super root block's buffer.

Link: https://lkml.kernel.org/r/20240122140202.6950-9-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c   |   38 ++++++++++++++-------------------
 fs/nilfs2/nilfs.h   |    3 +-
 fs/nilfs2/segment.c |   47 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 57 insertions(+), 31 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common
+++ a/fs/nilfs2/inode.c
@@ -759,8 +759,18 @@ struct inode *nilfs_iget_for_shadow(stru
 	return s_inode;
 }
 
+/**
+ * nilfs_write_inode_common - export common inode information to on-disk inode
+ * @inode:     inode object
+ * @raw_inode: on-disk inode
+ *
+ * This function writes standard information from the on-memory inode @inode
+ * to @raw_inode on ifile, cpfile or a super root block.  Since inode bmap
+ * data is not exported, nilfs_bmap_write() must be called separately during
+ * log writing.
+ */
 void nilfs_write_inode_common(struct inode *inode,
-			      struct nilfs_inode *raw_inode, int has_bmap)
+			      struct nilfs_inode *raw_inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
@@ -778,21 +788,6 @@ void nilfs_write_inode_common(struct ino
 	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
 
-	if (NILFS_ROOT_METADATA_FILE(inode->i_ino)) {
-		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
-
-		/* zero-fill unused portion in the case of super root block */
-		raw_inode->i_xattr = 0;
-		raw_inode->i_pad = 0;
-		memset((void *)raw_inode + sizeof(*raw_inode), 0,
-		       nilfs->ns_inode_size - sizeof(*raw_inode));
-	}
-
-	if (has_bmap)
-		nilfs_bmap_write(ii->i_bmap, raw_inode);
-	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
-		raw_inode->i_device_code =
-			cpu_to_le64(huge_encode_dev(inode->i_rdev));
 	/*
 	 * When extending inode, nilfs->ns_inode_size should be checked
 	 * for substitutions of appended fields.
@@ -813,12 +808,11 @@ void nilfs_update_inode(struct inode *in
 	if (flags & I_DIRTY_DATASYNC)
 		set_bit(NILFS_I_INODE_SYNC, &ii->i_state);
 
-	nilfs_write_inode_common(inode, raw_inode, 0);
-		/*
-		 * XXX: call with has_bmap = 0 is a workaround to avoid
-		 * deadlock of bmap.  This delays update of i_bmap to just
-		 * before writing.
-		 */
+	nilfs_write_inode_common(inode, raw_inode);
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
+		raw_inode->i_device_code =
+			cpu_to_le64(huge_encode_dev(inode->i_rdev));
 
 	nilfs_ifile_unmap_inode(ifile, ino, ibh);
 }
--- a/fs/nilfs2/nilfs.h~nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common
+++ a/fs/nilfs2/nilfs.h
@@ -256,7 +256,8 @@ extern struct inode *nilfs_new_inode(str
 extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern void nilfs_set_inode_flags(struct inode *);
 extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
-extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
+void nilfs_write_inode_common(struct inode *inode,
+			      struct nilfs_inode *raw_inode);
 struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 			    unsigned long ino);
 struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
--- a/fs/nilfs2/segment.c~nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common
+++ a/fs/nilfs2/segment.c
@@ -913,6 +913,7 @@ static int nilfs_segctor_fill_in_checkpo
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct buffer_head *bh_cp;
 	struct nilfs_checkpoint *raw_cp;
+	struct inode *ifile;
 	int err;
 
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
@@ -941,8 +942,10 @@ static int nilfs_segctor_fill_in_checkpo
 	else
 		nilfs_checkpoint_set_minor(raw_cp);
 
-	nilfs_write_inode_common(sci->sc_root->ifile,
-				 &raw_cp->cp_ifile_inode, 1);
+	ifile = sci->sc_root->ifile;
+	nilfs_write_inode_common(ifile, &raw_cp->cp_ifile_inode);
+	nilfs_bmap_write(NILFS_I(ifile)->i_bmap, &raw_cp->cp_ifile_inode);
+
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
 	return 0;
 
@@ -977,6 +980,33 @@ static void nilfs_segctor_fill_in_file_b
 	}
 }
 
+/**
+ * nilfs_write_root_mdt_inode - export root metadata inode information to
+ *                              the on-disk inode
+ * @inode:     inode object of the root metadata file
+ * @raw_inode: on-disk inode
+ *
+ * nilfs_write_root_mdt_inode() writes inode information and bmap data of
+ * @inode to the inode area of the metadata file allocated on the super root
+ * block created to finalize the log.  Since super root blocks are configured
+ * each time, this function zero-fills the unused area of @raw_inode.
+ */
+static void nilfs_write_root_mdt_inode(struct inode *inode,
+				       struct nilfs_inode *raw_inode)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+
+	nilfs_write_inode_common(inode, raw_inode);
+
+	/* zero-fill unused portion of raw_inode */
+	raw_inode->i_xattr = 0;
+	raw_inode->i_pad = 0;
+	memset((void *)raw_inode + sizeof(*raw_inode), 0,
+	       nilfs->ns_inode_size - sizeof(*raw_inode));
+
+	nilfs_bmap_write(NILFS_I(inode)->i_bmap, raw_inode);
+}
+
 static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs)
 {
@@ -998,12 +1028,13 @@ static void nilfs_segctor_fill_in_super_
 			      nilfs->ns_nongc_ctime : sci->sc_seg_ctime);
 	raw_sr->sr_flags = 0;
 
-	nilfs_write_inode_common(nilfs->ns_dat, (void *)raw_sr +
-				 NILFS_SR_DAT_OFFSET(isz), 1);
-	nilfs_write_inode_common(nilfs->ns_cpfile, (void *)raw_sr +
-				 NILFS_SR_CPFILE_OFFSET(isz), 1);
-	nilfs_write_inode_common(nilfs->ns_sufile, (void *)raw_sr +
-				 NILFS_SR_SUFILE_OFFSET(isz), 1);
+	nilfs_write_root_mdt_inode(nilfs->ns_dat, (void *)raw_sr +
+				   NILFS_SR_DAT_OFFSET(isz));
+	nilfs_write_root_mdt_inode(nilfs->ns_cpfile, (void *)raw_sr +
+				   NILFS_SR_CPFILE_OFFSET(isz));
+	nilfs_write_root_mdt_inode(nilfs->ns_sufile, (void *)raw_sr +
+				   NILFS_SR_SUFILE_OFFSET(isz));
+
 	memset((void *)raw_sr + srsz, 0, nilfs->ns_blocksize - srsz);
 	set_buffer_uptodate(bh_sr);
 	unlock_buffer(bh_sr);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


