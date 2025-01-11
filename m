Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC1513B29F
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736562250; cv=none; b=fyVIGBjbLiDhX4okugufsx77ZZh4IE5sPPH8uODgNTctY6iWyEg58lcHWSG7aBpvOwsKDs2WEEiYr+YfEe6JTGgmzVlljAElnb/4/iyLCgUc+Ue0+71qNVDVQAnGVU1uDdLENad7ldy9WbtchfxsI+zXAsOb5NF4pazGZKONH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736562250; c=relaxed/simple;
	bh=HYsVePGFVWEs9LpQXEBtny5i6N2k8Wpc0IccdyOgDGo=;
	h=Date:To:From:Subject:Message-Id; b=qMz4ulHhH1hxjB4D/C0l0Wdb+GyDr92sWpypwPa0A4tIPV1mWZ2mOAbtS/qreTL8okr2HpzHzV4SVKfF1K9jMjGa1F+tkc4UCaesRYEGCjm4uqvmbVMXyKuQJ6ZYBWYyCVXR6ltL8a5Q0uQtigaNtqnz7O+0V+4YoENCdAM0Nh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f2u3E6Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f2u3E6Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C56C4CED6;
	Sat, 11 Jan 2025 02:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736562250;
	bh=HYsVePGFVWEs9LpQXEBtny5i6N2k8Wpc0IccdyOgDGo=;
	h=Date:To:From:Subject:From;
	b=f2u3E6XmOIMH1FS0Zz9zrPfI6T8neYlRSrjlUB8qtsgZPxpyB0QnehEvu7w4RzzG1
	 lXD3/TnTsyHFVkvfJ5ruX+n4v++e8dtan1//w6g310gDUEXo0l3VZHWTudrUDjvVOL
	 a+NXWvtcYeyINLIlsgLORljITm/ktUpbetsUake0=
Date: Fri, 10 Jan 2025 18:24:09 -0800
To: mm-commits@vger.kernel.org,gissf1@gmail.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-revise-the-return-value-description-style-for-consistency.patch added to mm-nonmm-unstable branch
Message-Id: <20250111022409.E1C56C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: revise the return value description style for consistency.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-revise-the-return-value-description-style-for-consistency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-revise-the-return-value-description-style-for-consistency.patch

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
Subject: nilfs2: revise the return value description style for consistency.
Date: Fri, 10 Jan 2025 10:01:50 +0900

Also for comments that do not cause kernel-doc warnings (those that list
multiple error codes), revise the return value description style to match
Brian G.'s suggestion of "..., or one of the following negative error
codes on failure:".

Link: https://lkml.kernel.org/r/CAAq45aNh1qV8P6XgDhKeNstT=PvcPUaCXsAF-f9rvmzznsZL5A@mail.gmail.com
Link: https://lkml.kernel.org/r/20250110010530.21872-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: "Brian G ." <gissf1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c  |    3 ++-
 fs/nilfs2/cpfile.c  |   16 ++++++++++------
 fs/nilfs2/dat.c     |    3 ++-
 fs/nilfs2/ifile.c   |    3 ++-
 fs/nilfs2/ioctl.c   |    3 ++-
 fs/nilfs2/segment.c |    6 ++++--
 fs/nilfs2/sufile.c  |    2 +-
 7 files changed, 23 insertions(+), 13 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/btnode.c
@@ -201,7 +201,8 @@ void nilfs_btnode_delete(struct buffer_h
  * Note that the current implementation does not support folio sizes larger
  * than the page size.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EIO	- I/O error (metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
  */
--- a/fs/nilfs2/cpfile.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/cpfile.c
@@ -236,7 +236,8 @@ static inline int nilfs_cpfile_delete_ch
  * stores it to the inode file given by @ifile and the nilfs root object
  * given by @root.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid checkpoint.
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
@@ -304,7 +305,8 @@ out_sem:
  * In either case, the buffer of the block containing the checkpoint entry
  * and the cpfile inode are made dirty for inclusion in the write log.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-EROFS	- Read only filesystem
@@ -373,7 +375,8 @@ out_sem:
  * cpfile with the data given by the arguments @root, @blkinc, @ctime, and
  * @minor.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
  */
@@ -712,7 +715,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
  * number to continue searching.
  *
  * Return: Count of checkpoint info items stored in the output buffer on
- * success, or the following negative error code on failure.
+ * success, or one of the following negative error codes on failure:
  * * %-EINVAL	- Invalid checkpoint mode.
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
@@ -737,7 +740,8 @@ ssize_t nilfs_cpfile_get_cpinfo(struct i
  * @cpfile: checkpoint file inode
  * @cno:    checkpoint number to delete
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EBUSY	- Checkpoint in use (snapshot specified).
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOENT	- No valid checkpoint found.
@@ -1005,7 +1009,7 @@ static int nilfs_cpfile_clear_snapshot(s
  * @cno:    checkpoint number
  *
  * Return: 1 if the checkpoint specified by @cno is a snapshot, 0 if not, or
- * the following negative error code on failure.
+ * one of the following negative error codes on failure:
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOENT	- No such checkpoint.
  * * %-ENOMEM	- Insufficient memory available.
--- a/fs/nilfs2/dat.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/dat.c
@@ -276,7 +276,8 @@ void nilfs_dat_abort_update(struct inode
  * @dat:      DAT file inode
  * @vblocknr: virtual block number
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid DAT entry (internal code).
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
--- a/fs/nilfs2/ifile.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/ifile.c
@@ -172,7 +172,8 @@ int nilfs_ifile_count_free_inodes(struct
  * @cno: number of checkpoint entry to read
  * @inode_size: size of an inode
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid checkpoint.
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
--- a/fs/nilfs2/ioctl.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/ioctl.c
@@ -1268,7 +1268,8 @@ static int nilfs_ioctl_get_fslabel(struc
  * @filp: file object
  * @argp: pointer to userspace memory that contains the volume name
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EFAULT	- Error copying input data.
  * * %-EINVAL	- Label length exceeds record size in superblock.
  * * %-EIO	- I/O error.
--- a/fs/nilfs2/segment.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/segment.c
@@ -1122,7 +1122,8 @@ static int nilfs_segctor_scan_file_dsync
  * a super root block containing this sufile change is complete, and it can
  * be canceled with nilfs_sufile_cancel_freev() until then.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid segment number.
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
@@ -2834,7 +2835,8 @@ static void nilfs_segctor_destroy(struct
  * This allocates a log writer object, initializes it, and starts the
  * log writer.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINTR	- Log writer thread creation failed due to interruption.
  * * %-ENOMEM	- Insufficient memory available.
  */
--- a/fs/nilfs2/sufile.c~nilfs2-revise-the-return-value-description-style-for-consistency
+++ a/fs/nilfs2/sufile.c
@@ -850,7 +850,7 @@ out:
  * @nsi:    size of suinfo array
  *
  * Return: Count of segment usage info items stored in the output buffer on
- * success, or the following negative error code on failure.
+ * success, or one of the following negative error codes on failure:
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
  */
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-do-not-force-clear-folio-if-buffer-is-referenced.patch
nilfs2-protect-access-to-buffers-with-no-active-references.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-ioctl-functions.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-bmap-functions.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-sufile.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-metadata-files.patch
nilfs2-correct-return-value-kernel-doc-descriptions-for-the-rest.patch
nilfs2-add-missing-return-value-kernel-doc-descriptions.patch
nilfs2-revise-the-return-value-description-style-for-consistency.patch

