Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD2954BD2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970591; cv=none; b=X6kusOBQBuoKHKqqA63hU8oG9byJYwLY3jHiZIfCJM+BkQRzWBaM+oDv2tdO03q7mAfO4UnzPfo7e2NOIgqsL7j4f75WvDmV/ioc0cUY7fXKKKododesdK+y/ZrqowI0+KWH8x+r40GIHPXIFpGDXPpJEaTmw0uNcpRkOvapN3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970591; c=relaxed/simple;
	bh=ZE7TmUN4AtRjPe/T4p/4J83ZmWTyqgPdYMnirVWN0jA=;
	h=Date:To:From:Subject:Message-Id; b=ZPk4hrdOgQeDu5Aa0va/578z0Vk0bBh5musIsQ9M31ujA1HtDqDFZPGL90n9EAXR9Xya8holIMAFycheHatSOaSNHoeArIGCBC29fDzh1JnlbHj5x6eAAe1wFCeFdyQY7e4aS3L2YMvHUP4DX+jabxGplc4CRmLmdvMmoID5Kkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AGXe4d0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AGXe4d0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23ECC433F1;
	Tue, 23 Jan 2024 00:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970591;
	bh=ZE7TmUN4AtRjPe/T4p/4J83ZmWTyqgPdYMnirVWN0jA=;
	h=Date:To:From:Subject:From;
	b=AGXe4d0jrrMOqhiY73b+tD4wjevoKcHAWq+C3ey8NlqILKKo9ugS1P2b2KrdCt5oU
	 iaTBsQ1sgSGPM8NsSRRBKGqEgIK1P6L1t2f79TGJMmzJBPltawJRNgmcwO2K+auDwq
	 7KXimY3lS3Vq6XwuKd3DDammgc2EwpDwmy/0JCP8=
Date: Mon, 22 Jan 2024 16:43:07 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004310.A23ECC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: localize highmem mapping for checkpoint creation within cpfile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch

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
Subject: nilfs2: localize highmem mapping for checkpoint creation within cpfile
Date: Mon, 22 Jan 2024 23:01:58 +0900

In order to convert kmap() used in cpfile to kmap_local, first move the
checkpoint creation routine, which is one of the places where kmap is
used, to the cpfile side and make the page mapping local and temporary. 
And use kmap_local instead of kmap to access the checkpoint entry page
(and header block page) when generating a checkpoint.

Link: https://lkml.kernel.org/r/20240122140202.6950-12-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c  |   74 ++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.h  |    1 
 fs/nilfs2/segment.c |   31 +----------------
 3 files changed, 77 insertions(+), 29 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile
+++ a/fs/nilfs2/cpfile.c
@@ -273,6 +273,80 @@ int nilfs_cpfile_get_checkpoint(struct i
 }
 
 /**
+ * nilfs_cpfile_create_checkpoint - create a checkpoint entry on cpfile
+ * @cpfile: checkpoint file inode
+ * @cno:    number of checkpoint to set up
+ *
+ * This function creates a checkpoint with the number specified by @cno on
+ * cpfile.  If the specified checkpoint entry already exists due to a past
+ * failure, it will be reused without returning an error.
+ * In either case, the buffer of the block containing the checkpoint entry
+ * and the cpfile inode are made dirty for inclusion in the write log.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-EROFS	- Read only filesystem
+ */
+int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno)
+{
+	struct buffer_head *header_bh, *cp_bh;
+	struct nilfs_cpfile_header *header;
+	struct nilfs_checkpoint *cp;
+	void *kaddr;
+	int ret;
+
+	if (WARN_ON_ONCE(cno < 1))
+		return -EIO;
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
+	if (unlikely(ret < 0)) {
+		if (ret == -ENOENT) {
+			nilfs_error(cpfile->i_sb,
+				    "checkpoint creation failed due to metadata corruption.");
+			ret = -EIO;
+		}
+		goto out_sem;
+	}
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 1, &cp_bh);
+	if (unlikely(ret < 0))
+		goto out_header;
+
+	kaddr = kmap_local_page(cp_bh->b_page);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	if (nilfs_checkpoint_invalid(cp)) {
+		/* a newly-created checkpoint */
+		nilfs_checkpoint_clear_invalid(cp);
+		if (!nilfs_cpfile_is_in_first(cpfile, cno))
+			nilfs_cpfile_block_add_valid_checkpoints(cpfile, cp_bh,
+								 kaddr, 1);
+		kunmap_local(kaddr);
+
+		kaddr = kmap_local_page(header_bh->b_page);
+		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
+						       kaddr);
+		le64_add_cpu(&header->ch_ncheckpoints, 1);
+		kunmap_local(kaddr);
+		mark_buffer_dirty(header_bh);
+	} else {
+		kunmap_local(kaddr);
+	}
+
+	/* Force the buffer and the inode to become dirty */
+	mark_buffer_dirty(cp_bh);
+	brelse(cp_bh);
+	nilfs_mdt_mark_dirty(cpfile);
+
+out_header:
+	brelse(header_bh);
+
+out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_cpfile_put_checkpoint - put a checkpoint
  * @cpfile: inode of checkpoint file
  * @cno: checkpoint number
--- a/fs/nilfs2/cpfile.h~nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile
+++ a/fs/nilfs2/cpfile.h
@@ -19,6 +19,7 @@
 int nilfs_cpfile_get_checkpoint(struct inode *, __u64, int,
 				struct nilfs_checkpoint **,
 				struct buffer_head **);
+int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno);
 void nilfs_cpfile_put_checkpoint(struct inode *, __u64, struct buffer_head *);
 int nilfs_cpfile_delete_checkpoints(struct inode *, __u64, __u64);
 int nilfs_cpfile_delete_checkpoint(struct inode *, __u64);
--- a/fs/nilfs2/segment.c~nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile
+++ a/fs/nilfs2/segment.c
@@ -880,34 +880,6 @@ static void nilfs_segctor_clear_metadata
 	nilfs_mdt_clear_dirty(nilfs->ns_dat);
 }
 
-static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
-{
-	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
-	struct buffer_head *bh_cp;
-	struct nilfs_checkpoint *raw_cp;
-	int err;
-
-	/* XXX: this interface will be changed */
-	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 1,
-					  &raw_cp, &bh_cp);
-	if (likely(!err)) {
-		/*
-		 * The following code is duplicated with cpfile.  But, it is
-		 * needed to collect the checkpoint even if it was not newly
-		 * created.
-		 */
-		mark_buffer_dirty(bh_cp);
-		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
-		nilfs_cpfile_put_checkpoint(
-			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else if (err == -EINVAL || err == -ENOENT) {
-		nilfs_error(sci->sc_super,
-			    "checkpoint creation failed due to metadata corruption.");
-		err = -EIO;
-	}
-	return err;
-}
-
 static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 {
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
@@ -1261,7 +1233,8 @@ static int nilfs_segctor_collect_blocks(
 			break;
 		nilfs_sc_cstage_inc(sci);
 		/* Creating a checkpoint */
-		err = nilfs_segctor_create_checkpoint(sci);
+		err = nilfs_cpfile_create_checkpoint(nilfs->ns_cpfile,
+						     nilfs->ns_cno);
 		if (unlikely(err))
 			break;
 		fallthrough;
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

