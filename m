Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE978297
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846752; cv=none; b=Hj8C35Hje0eM6DP3vO10OhNDQJy6YJfhp7Z7x8mu7Xn22BpzM4qgwjb6Y0buLM8XXq6wQyfWmXyQc+4jvF3T3eCRucJ2PknzpMS+1SNKGS2atsb47jnT3ulHlFgBYScxY9D0ACg9HPTdYrFjFFZNEVc4RPQhWpHJsSbMoL8QQgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846752; c=relaxed/simple;
	bh=Min+GJdUl4CCewdObHwtLBXLFKc4ahRMbNHOc7LhY4o=;
	h=Date:To:From:Subject:Message-Id; b=TY0K6YwcTyF7KiO3u2W5UF0SFqXI4OzReNCKeQShxsJTtx+KxmI8et7YgPbhpZwun40FoQ+ft4S61e3tCfwUgdxn86VzfyWd7kz3vtYDSTydPDBm3vauWhnb8BLbYFKs6Ll7owX44qh1MICCYyYDUusu1tW5Mih1MjLVXwe7Nh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmildd71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmildd71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ECBC32782;
	Fri, 16 Aug 2024 22:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846751;
	bh=Min+GJdUl4CCewdObHwtLBXLFKc4ahRMbNHOc7LhY4o=;
	h=Date:To:From:Subject:From;
	b=dmildd71ZFAndf6AUAN5LVLSUeCRB9+QZ67Vu0R3ayK5p1XRhR2lzQxPsS20LYEcI
	 PT///N0QCCHAjhhZmxegwKAX7wtRZ4IStn2dJRVVyyyEZ7Urmty1MpkY5NHhG5Zkdt
	 4ZiYLYpTKYDdlmnAevUnN8TJIM1WWhoAAXXNOnlI=
Date: Fri, 16 Aug 2024 15:19:11 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221911.C8ECBC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix missing initial short descriptions of kernel-doc comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch

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

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch

