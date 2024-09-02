Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A101A14F132
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248827; cv=none; b=PxWtpcEESWOTp3PRdrGBbZCM4zs4w4moIuwxR8wsqXPjJha7/Ey0ZAgaP/TxbpbRWLBIDj1Y4v7oncvFmf3coMbdVC3Clhb1aWYzomOtgkCDx4FkG82rXSoCsIKLPI5NWW+xfw2V0ayf1hXBlOdL+U2qh6owLURq7tOm0JLpCPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248827; c=relaxed/simple;
	bh=fV46Q3GVJyxTZAfJZqr7A+4rySQ4AEH1d9s86EWajnw=;
	h=Date:To:From:Subject:Message-Id; b=Q+mqffcONU+E4UjQM328ZVQSs5MiVKaFcEngyEapaaO9YNoK2TjOfzSYvVKXa4hxD2LzQynDOABJXlZLVK/6qx4I96M4pSireo01/N3jOfBbVb3pwkdYtUdDp+abhUC8+/PwK4+uMJwz547XMXROKI57A93X5cbpWpnR+Eu8VtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cK54tKdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cK54tKdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7732DC4CEC2;
	Mon,  2 Sep 2024 03:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248827;
	bh=fV46Q3GVJyxTZAfJZqr7A+4rySQ4AEH1d9s86EWajnw=;
	h=Date:To:From:Subject:From;
	b=cK54tKdEp8lQ60qgyAi20hYhlsQ/uK9kpF+FO6/NKBPEXsSV8aYbvVQlEfijjzqtB
	 WwUUw/YyHHFfkEL9YiDLG/d+Vp8fAfujExw69q4tfYOKyXzOZhLNisdRXbW2dR9LwC
	 uDZ2iHSvpcF6yoEKwQ6z39kc/G1pEi2ZpKm5WCxA=
Date: Sun, 01 Sep 2024 20:47:06 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch removed from -mm tree
Message-Id: <20240902034707.7732DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix missing initial short descriptions of kernel-doc comments
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix missing initial short descriptions of kernel-doc comments
Date: Fri, 16 Aug 2024 16:43:19 +0900

Update some kernel-doc comments that are missing the initial short
description and fix the following warnings output by the kernel-doc
script:

 fs/nilfs2/bmap.c:353: warning: missing initial short description on line:
  * nilfs_bmap_lookup_dirty_buffers -
 fs/nilfs2/cpfile.c:708: warning: missing initial short description on line:
  * nilfs_cpfile_delete_checkpoint -
 fs/nilfs2/cpfile.c:972: warning: missing initial short description on line:
  * nilfs_cpfile_is_snapshot -
 fs/nilfs2/dat.c:275: warning: missing initial short description on line:
  * nilfs_dat_mark_dirty -
 fs/nilfs2/sufile.c:844: warning: missing initial short description on line:
  * nilfs_sufile_get_suinfo -

Link: https://lkml.kernel.org/r/20240816074319.3253-9-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c   |    2 +-
 fs/nilfs2/cpfile.c |   32 ++++++++++++++++----------------
 fs/nilfs2/dat.c    |   17 +++++++----------
 fs/nilfs2/sufile.c |   20 ++++++++------------
 4 files changed, 32 insertions(+), 39 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments
+++ a/fs/nilfs2/bmap.c
@@ -349,7 +349,7 @@ int nilfs_bmap_propagate(struct nilfs_bm
 }
 
 /**
- * nilfs_bmap_lookup_dirty_buffers -
+ * nilfs_bmap_lookup_dirty_buffers - collect dirty block buffers
  * @bmap: bmap
  * @listp: pointer to buffer head list
  */
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments
+++ a/fs/nilfs2/cpfile.c
@@ -704,9 +704,15 @@ ssize_t nilfs_cpfile_get_cpinfo(struct i
 }
 
 /**
- * nilfs_cpfile_delete_checkpoint -
- * @cpfile:
- * @cno:
+ * nilfs_cpfile_delete_checkpoint - delete a checkpoint
+ * @cpfile: checkpoint file inode
+ * @cno:    checkpoint number to delete
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EBUSY	- Checkpoint in use (snapshot specified).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No valid checkpoint found.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 {
@@ -968,21 +974,15 @@ static int nilfs_cpfile_clear_snapshot(s
 }
 
 /**
- * nilfs_cpfile_is_snapshot -
+ * nilfs_cpfile_is_snapshot - determine if checkpoint is a snapshot
  * @cpfile: inode of checkpoint file
- * @cno: checkpoint number
- *
- * Description:
- *
- * Return Value: On success, 1 is returned if the checkpoint specified by
- * @cno is a snapshot, or 0 if not. On error, one of the following negative
- * error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * @cno:    checkpoint number
  *
- * %-ENOENT - No such checkpoint.
+ * Return: 1 if the checkpoint specified by @cno is a snapshot, 0 if not, or
+ * the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No such checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 {
--- a/fs/nilfs2/dat.c~nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments
+++ a/fs/nilfs2/dat.c
@@ -271,18 +271,15 @@ void nilfs_dat_abort_update(struct inode
 }
 
 /**
- * nilfs_dat_mark_dirty -
- * @dat: DAT file inode
+ * nilfs_dat_mark_dirty - mark the DAT block buffer containing the specified
+ *                        virtual block address entry as dirty
+ * @dat:      DAT file inode
  * @vblocknr: virtual block number
  *
- * Description:
- *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid DAT entry (internal code).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
 {
--- a/fs/nilfs2/sufile.c~nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments
+++ a/fs/nilfs2/sufile.c
@@ -840,21 +840,17 @@ out:
 }
 
 /**
- * nilfs_sufile_get_suinfo -
+ * nilfs_sufile_get_suinfo - get segment usage information
  * @sufile: inode of segment usage file
  * @segnum: segment number to start looking
- * @buf: array of suinfo
- * @sisz: byte size of suinfo
- * @nsi: size of suinfo array
+ * @buf:    array of suinfo
+ * @sisz:   byte size of suinfo
+ * @nsi:    size of suinfo array
  *
- * Description:
- *
- * Return Value: On success, 0 is returned and .... On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: Count of segment usage info items stored in the output buffer on
+ * success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 				unsigned int sisz, size_t nsi)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


