Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424E254BD2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970602; cv=none; b=GbDIj8wVxtfKQ0zJMxZDBYIvH2JbgiOhi+PUUpXDtA476w3Hr9yAnalGgwXRyK5PjKJ3upC1p8kLx8rHyKzqRPQWrhNnze+tSUaEIVavHerpBbwEF3TCdGTWsYgE6fkBu03YFqHljpeHahW9mk28XhO3SBndZqrHvDhyu37xYxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970602; c=relaxed/simple;
	bh=6I7EvE4mfSf7WxkdtNn4XDeAFGrbFFRIqTSdCbKUzEY=;
	h=Date:To:From:Subject:Message-Id; b=HkRqnk2EfrEdAEwATgTTE/FvjpuPEcGvzPYi/1OhGbpHd+TPGBETsj3P+Fd6Ly2VFsz3kTjp0liqUJPN/edvBg4f23TqR0Bjs+zE9BBWTzP4ToRAVdopNHHa4+oIUskYzfqB1Q276nM006UZVHpNPQXZEFkbmsClYC1auPZFWvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tNGv1Mqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tNGv1Mqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFD1C43390;
	Tue, 23 Jan 2024 00:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970602;
	bh=6I7EvE4mfSf7WxkdtNn4XDeAFGrbFFRIqTSdCbKUzEY=;
	h=Date:To:From:Subject:From;
	b=tNGv1MqflpJ4J4r3x0LtyhVBzYQkwu6fVhEHC+qFxD/7qIB45GCqBZ/eq4H5QFMlX
	 G3ZTGfE0iMRndpFiOj+IGld4elKrEuOp6UKQ7uZo1dZ8h4DChg4sSW3otFkpHewF8A
	 /lHcqjpZ31DqmFTuZbGUbE/YWpwCO8g+74+cMreg=
Date: Mon, 22 Jan 2024 16:43:18 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004321.9AFD1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: remove nilfs_cpfile_{get,put}_checkpoint()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch

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
Subject: nilfs2: remove nilfs_cpfile_{get,put}_checkpoint()
Date: Mon, 22 Jan 2024 23:02:01 +0900

All calls to nilfs_cpfile_get_checkpoint() and
nilfs_cpfile_put_checkpoint() that call kmap() and kunmap() separately are
now gone, so remove these methods.

Link: https://lkml.kernel.org/r/20240122140202.6950-15-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |  103 -------------------------------------------
 fs/nilfs2/cpfile.h |    4 -
 2 files changed, 107 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-remove-nilfs_cpfile_getput_checkpoint
+++ a/fs/nilfs2/cpfile.c
@@ -255,92 +255,6 @@ out_sem:
 }
 
 /**
- * nilfs_cpfile_get_checkpoint - get a checkpoint
- * @cpfile: inode of checkpoint file
- * @cno: checkpoint number
- * @create: create flag
- * @cpp: pointer to a checkpoint
- * @bhp: pointer to a buffer head
- *
- * Description: nilfs_cpfile_get_checkpoint() acquires the checkpoint
- * specified by @cno. A new checkpoint will be created if @cno is the current
- * checkpoint number and @create is nonzero.
- *
- * Return Value: On success, 0 is returned, and the checkpoint and the
- * buffer head of the buffer on which the checkpoint is located are stored in
- * the place pointed by @cpp and @bhp, respectively. On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - No such checkpoint.
- *
- * %-EINVAL - invalid checkpoint.
- */
-int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
-				__u64 cno,
-				int create,
-				struct nilfs_checkpoint **cpp,
-				struct buffer_head **bhp)
-{
-	struct buffer_head *header_bh, *cp_bh;
-	struct nilfs_cpfile_header *header;
-	struct nilfs_checkpoint *cp;
-	void *kaddr;
-	int ret;
-
-	if (unlikely(cno < 1 || cno > nilfs_mdt_cno(cpfile) ||
-		     (cno < nilfs_mdt_cno(cpfile) && create)))
-		return -EINVAL;
-
-	down_write(&NILFS_MDT(cpfile)->mi_sem);
-
-	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
-	if (ret < 0)
-		goto out_sem;
-	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, create, &cp_bh);
-	if (ret < 0)
-		goto out_header;
-	kaddr = kmap(cp_bh->b_page);
-	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
-	if (nilfs_checkpoint_invalid(cp)) {
-		if (!create) {
-			kunmap(cp_bh->b_page);
-			brelse(cp_bh);
-			ret = -ENOENT;
-			goto out_header;
-		}
-		/* a newly-created checkpoint */
-		nilfs_checkpoint_clear_invalid(cp);
-		if (!nilfs_cpfile_is_in_first(cpfile, cno))
-			nilfs_cpfile_block_add_valid_checkpoints(cpfile, cp_bh,
-								 kaddr, 1);
-		mark_buffer_dirty(cp_bh);
-
-		kaddr = kmap_atomic(header_bh->b_page);
-		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
-						       kaddr);
-		le64_add_cpu(&header->ch_ncheckpoints, 1);
-		kunmap_atomic(kaddr);
-		mark_buffer_dirty(header_bh);
-		nilfs_mdt_mark_dirty(cpfile);
-	}
-
-	if (cpp != NULL)
-		*cpp = cp;
-	*bhp = cp_bh;
-
- out_header:
-	brelse(header_bh);
-
- out_sem:
-	up_write(&NILFS_MDT(cpfile)->mi_sem);
-	return ret;
-}
-
-/**
  * nilfs_cpfile_create_checkpoint - create a checkpoint entry on cpfile
  * @cpfile: checkpoint file inode
  * @cno:    number of checkpoint to set up
@@ -415,23 +329,6 @@ out_sem:
 }
 
 /**
- * nilfs_cpfile_put_checkpoint - put a checkpoint
- * @cpfile: inode of checkpoint file
- * @cno: checkpoint number
- * @bh: buffer head
- *
- * Description: nilfs_cpfile_put_checkpoint() releases the checkpoint
- * specified by @cno. @bh must be the buffer head which has been returned by
- * a previous call to nilfs_cpfile_get_checkpoint() with @cno.
- */
-void nilfs_cpfile_put_checkpoint(struct inode *cpfile, __u64 cno,
-				 struct buffer_head *bh)
-{
-	kunmap(bh->b_page);
-	brelse(bh);
-}
-
-/**
  * nilfs_cpfile_finalize_checkpoint - fill in a checkpoint entry in cpfile
  * @cpfile: checkpoint file inode
  * @cno:    checkpoint number
--- a/fs/nilfs2/cpfile.h~nilfs2-remove-nilfs_cpfile_getput_checkpoint
+++ a/fs/nilfs2/cpfile.h
@@ -16,13 +16,9 @@
 #include <linux/nilfs2_ondisk.h>	/* nilfs_inode, nilfs_checkpoint */
 
 
-int nilfs_cpfile_get_checkpoint(struct inode *, __u64, int,
-				struct nilfs_checkpoint **,
-				struct buffer_head **);
 int nilfs_cpfile_read_checkpoint(struct inode *cpfile, __u64 cno,
 				 struct nilfs_root *root, struct inode *ifile);
 int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno);
-void nilfs_cpfile_put_checkpoint(struct inode *, __u64, struct buffer_head *);
 int nilfs_cpfile_finalize_checkpoint(struct inode *cpfile, __u64 cno,
 				     struct nilfs_root *root, __u64 blkinc,
 				     time64_t ctime, bool minor);
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

