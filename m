Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BB254BD2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970587; cv=none; b=ji53HYp99wNvVJPQOLYIXeDVou18F0meYm9tlfqsnVF4qSYMg+tKAbuFA4p1YZjzqmieEQPaHmY4Fy30DCNKN7HynqyoyD6r35eh9GDfLeYHxJc610rDV8/l1iJfHmKehvw7tSw1wz6EBIv8akHiXbnBFwsyqazPwKm0blLbSS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970587; c=relaxed/simple;
	bh=SkX16vbLDv24oBwlvRj2zJZXonDaNiYZdV9bCaHbwK8=;
	h=Date:To:From:Subject:Message-Id; b=MidneTnjg3fHfh/hSu9CR77IlFc32eZPdygGYPSdXkSyGnPJro/BzdGOoA4tjUmv77OPFBCQU8pEhx/kTvv/soHwTZ3vR9xwVD3iq7hrfKzeWglRzDdD2DHHDGF6g1RzLgDn+C753ZS6DRM5Th+vO0Eat00vh0GbGcJ+co0JviA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2Jx9BNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2Jx9BNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075C3C43394;
	Tue, 23 Jan 2024 00:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970587;
	bh=SkX16vbLDv24oBwlvRj2zJZXonDaNiYZdV9bCaHbwK8=;
	h=Date:To:From:Subject:From;
	b=b2Jx9BNZGz+vZ+6pEHr65R6zMmqahRHltGqx2kvJwWeRe/nBcrwLutSza1dNUwSI5
	 0zpNHw7FK2v3HoECUUopk/sILgKaJhiHXjSEaC1grjZMQn0sxLGTtD/tNvC/a5lPRz
	 /I2HIUMMAqqXPFCxRjcYSkSkcGH+VoO7U1n571rs=
Date: Mon, 22 Jan 2024 16:43:04 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004307.075C3C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: localize highmem mapping for checkpoint finalization within cpfile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch

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
Subject: nilfs2: localize highmem mapping for checkpoint finalization within cpfile
Date: Mon, 22 Jan 2024 23:01:59 +0900

Move the checkpoint finalization routine to the cpfile side, and make the
page mapping local and temporary.  And use kmap_local instead of kmap to
access the checkpoint entry page when finalizing a checkpoint.

In this conversion, some of the information on the checkpoint entry being
rewritten is passed through the arguments of the newly added method
nilfs_cpfile_finalize_checkpoint().

Link: https://lkml.kernel.org/r/20240122140202.6950-13-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c  |   74 ++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.h  |    3 +
 fs/nilfs2/segment.c |   51 ++--------------------------
 3 files changed, 82 insertions(+), 46 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile
+++ a/fs/nilfs2/cpfile.c
@@ -364,6 +364,80 @@ void nilfs_cpfile_put_checkpoint(struct
 }
 
 /**
+ * nilfs_cpfile_finalize_checkpoint - fill in a checkpoint entry in cpfile
+ * @cpfile: checkpoint file inode
+ * @cno:    checkpoint number
+ * @root:   nilfs root object
+ * @blkinc: number of blocks added by this checkpoint
+ * @ctime:  checkpoint creation time
+ * @minor:  minor checkpoint flag
+ *
+ * This function completes the checkpoint entry numbered by @cno in the
+ * cpfile with the data given by the arguments @root, @blkinc, @ctime, and
+ * @minor.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
+ */
+int nilfs_cpfile_finalize_checkpoint(struct inode *cpfile, __u64 cno,
+				     struct nilfs_root *root, __u64 blkinc,
+				     time64_t ctime, bool minor)
+{
+	struct buffer_head *cp_bh;
+	struct nilfs_checkpoint *cp;
+	void *kaddr;
+	int ret;
+
+	if (WARN_ON_ONCE(cno < 1))
+		return -EIO;
+
+	down_write(&NILFS_MDT(cpfile)->mi_sem);
+	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
+	if (unlikely(ret < 0)) {
+		if (ret == -ENOENT)
+			goto error;
+		goto out_sem;
+	}
+
+	kaddr = kmap_local_page(cp_bh->b_page);
+	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
+	if (unlikely(nilfs_checkpoint_invalid(cp))) {
+		kunmap_local(kaddr);
+		brelse(cp_bh);
+		goto error;
+	}
+
+	cp->cp_snapshot_list.ssl_next = 0;
+	cp->cp_snapshot_list.ssl_prev = 0;
+	cp->cp_inodes_count = cpu_to_le64(atomic64_read(&root->inodes_count));
+	cp->cp_blocks_count = cpu_to_le64(atomic64_read(&root->blocks_count));
+	cp->cp_nblk_inc = cpu_to_le64(blkinc);
+	cp->cp_create = cpu_to_le64(ctime);
+	cp->cp_cno = cpu_to_le64(cno);
+
+	if (minor)
+		nilfs_checkpoint_set_minor(cp);
+	else
+		nilfs_checkpoint_clear_minor(cp);
+
+	nilfs_write_inode_common(root->ifile, &cp->cp_ifile_inode);
+	nilfs_bmap_write(NILFS_I(root->ifile)->i_bmap, &cp->cp_ifile_inode);
+
+	kunmap_local(kaddr);
+	brelse(cp_bh);
+out_sem:
+	up_write(&NILFS_MDT(cpfile)->mi_sem);
+	return ret;
+
+error:
+	nilfs_error(cpfile->i_sb,
+		    "checkpoint finalization failed due to metadata corruption.");
+	ret = -EIO;
+	goto out_sem;
+}
+
+/**
  * nilfs_cpfile_delete_checkpoints - delete checkpoints
  * @cpfile: inode of checkpoint file
  * @start: start checkpoint number
--- a/fs/nilfs2/cpfile.h~nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile
+++ a/fs/nilfs2/cpfile.h
@@ -21,6 +21,9 @@ int nilfs_cpfile_get_checkpoint(struct i
 				struct buffer_head **);
 int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno);
 void nilfs_cpfile_put_checkpoint(struct inode *, __u64, struct buffer_head *);
+int nilfs_cpfile_finalize_checkpoint(struct inode *cpfile, __u64 cno,
+				     struct nilfs_root *root, __u64 blkinc,
+				     time64_t ctime, bool minor);
 int nilfs_cpfile_delete_checkpoints(struct inode *, __u64, __u64);
 int nilfs_cpfile_delete_checkpoint(struct inode *, __u64);
 int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
--- a/fs/nilfs2/segment.c~nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile
+++ a/fs/nilfs2/segment.c
@@ -880,51 +880,6 @@ static void nilfs_segctor_clear_metadata
 	nilfs_mdt_clear_dirty(nilfs->ns_dat);
 }
 
-static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
-{
-	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
-	struct buffer_head *bh_cp;
-	struct nilfs_checkpoint *raw_cp;
-	struct inode *ifile;
-	int err;
-
-	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
-					  &raw_cp, &bh_cp);
-	if (unlikely(err)) {
-		if (err == -EINVAL || err == -ENOENT) {
-			nilfs_error(sci->sc_super,
-				    "checkpoint finalization failed due to metadata corruption.");
-			err = -EIO;
-		}
-		goto failed_ibh;
-	}
-	raw_cp->cp_snapshot_list.ssl_next = 0;
-	raw_cp->cp_snapshot_list.ssl_prev = 0;
-	raw_cp->cp_inodes_count =
-		cpu_to_le64(atomic64_read(&sci->sc_root->inodes_count));
-	raw_cp->cp_blocks_count =
-		cpu_to_le64(atomic64_read(&sci->sc_root->blocks_count));
-	raw_cp->cp_nblk_inc =
-		cpu_to_le64(sci->sc_nblk_inc + sci->sc_nblk_this_inc);
-	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
-	raw_cp->cp_cno = cpu_to_le64(nilfs->ns_cno);
-
-	if (test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
-		nilfs_checkpoint_clear_minor(raw_cp);
-	else
-		nilfs_checkpoint_set_minor(raw_cp);
-
-	ifile = sci->sc_root->ifile;
-	nilfs_write_inode_common(ifile, &raw_cp->cp_ifile_inode);
-	nilfs_bmap_write(NILFS_I(ifile)->i_bmap, &raw_cp->cp_ifile_inode);
-
-	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	return 0;
-
- failed_ibh:
-	return err;
-}
-
 static void nilfs_fill_in_file_bmap(struct inode *ifile,
 				    struct nilfs_inode_info *ii)
 
@@ -2103,7 +2058,11 @@ static int nilfs_segctor_do_construct(st
 
 		if (mode == SC_LSEG_SR &&
 		    nilfs_sc_cstage_get(sci) >= NILFS_ST_CPFILE) {
-			err = nilfs_segctor_fill_in_checkpoint(sci);
+			err = nilfs_cpfile_finalize_checkpoint(
+				nilfs->ns_cpfile, nilfs->ns_cno, sci->sc_root,
+				sci->sc_nblk_inc + sci->sc_nblk_this_inc,
+				sci->sc_seg_ctime,
+				!test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags));
 			if (unlikely(err))
 				goto failed_to_write;
 
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

