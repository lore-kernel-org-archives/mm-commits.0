Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157B778297
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 22:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846741; cv=none; b=Q6D71JxirIa1DxlJOSES+v/ILimTnCEqOBoj7cgCaxCdQggI0aKBonUWmvOn8rNL7wuEn6yJL26dLJ8Dz2L0DIuSXPd3SdS0gksdkvrxQsVc3z2EPKMwYQlPjchsPId59NNvOFUCD/1tCLgjaU1KXsawa/77NbPOl2tvM6DUbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846741; c=relaxed/simple;
	bh=WYx71Z0A2O6BlixezG/25wiwglbsTymYrb0nLLvflvk=;
	h=Date:To:From:Subject:Message-Id; b=b6NeSRI4v+COBL/Vxn6qIaVaLX4oCLIpHrBmQEhq8Lw7ArO18lPekYPh3cifTqI9rGgvNDs7S6iTUaqEAo/tkFviWl3xh653DN6mZcH5CLcZW5ZM4DkszKd6OB++AKuYjkhZwdkgMLohAsselIwguytAl9qxNSGXhwvUNcYSF5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yg962RD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yg962RD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763CAC32782;
	Fri, 16 Aug 2024 22:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723846740;
	bh=WYx71Z0A2O6BlixezG/25wiwglbsTymYrb0nLLvflvk=;
	h=Date:To:From:Subject:From;
	b=Yg962RD9UYGuOOvS13W7lXseCSyRLmpbcYbO5uL619q3KR82KZoA5N2ZMxrGZBK8x
	 vwuibkxoaXo9eZ5Ho6crtI2T0HgijLv7C8pboxHVAtzq0o1xUNWQXJPk/NqeyyqpuH
	 bbG9zypGhhgP8/blaMq7Upx7vAyNAHUcUQhjziLc=
Date: Fri, 16 Aug 2024 15:18:59 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch added to mm-nonmm-unstable branch
Message-Id: <20240816221900.763CAC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add missing argument descriptions for ioctl-related helpers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch

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
Subject: nilfs2: add missing argument descriptions for ioctl-related helpers
Date: Fri, 16 Aug 2024 16:43:13 +0900

Add missing argument descriptions and return value information to the
kernel-doc comments for ioctl helper functions, and eliminate the
following warnings output by the kernel-doc script:

 fs/nilfs2/ioctl.c:120: warning: Function parameter or struct member
  'dentry' not described in 'nilfs_fileattr_get'
 fs/nilfs2/ioctl.c:120: warning: Function parameter or struct member 'fa'
  not described in 'nilfs_fileattr_get'
 fs/nilfs2/ioctl.c:133: warning: Function parameter or struct member 'idmap'
  not described in 'nilfs_fileattr_set'
 fs/nilfs2/ioctl.c:133: warning: Function parameter or struct member
  'dentry' not described in 'nilfs_fileattr_set'
 fs/nilfs2/ioctl.c:133: warning: Function parameter or struct member 'fa'
  not described in 'nilfs_fileattr_set'
 fs/nilfs2/ioctl.c:164: warning: Function parameter or struct member 'inode'
  not described in 'nilfs_ioctl_getversion'
 fs/nilfs2/ioctl.c:164: warning: Function parameter or struct member 'argp'
  not described in 'nilfs_ioctl_getversion'

Link: https://lkml.kernel.org/r/20240816074319.3253-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/ioctl.c~nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers
+++ a/fs/nilfs2/ioctl.c
@@ -115,7 +115,11 @@ static int nilfs_ioctl_wrap_copy(struct
 }
 
 /**
- * nilfs_fileattr_get - ioctl to support lsattr
+ * nilfs_fileattr_get - retrieve miscellaneous file attributes
+ * @dentry: the object to retrieve from
+ * @fa:     fileattr pointer
+ *
+ * Return: always 0 as success.
  */
 int nilfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
@@ -127,7 +131,12 @@ int nilfs_fileattr_get(struct dentry *de
 }
 
 /**
- * nilfs_fileattr_set - ioctl to support chattr
+ * nilfs_fileattr_set - change miscellaneous file attributes
+ * @idmap:  idmap of the mount
+ * @dentry: the object to change
+ * @fa:     fileattr pointer
+ *
+ * Return: 0 on success, or a negative error code on failure.
  */
 int nilfs_fileattr_set(struct mnt_idmap *idmap,
 		       struct dentry *dentry, struct fileattr *fa)
@@ -160,6 +169,10 @@ int nilfs_fileattr_set(struct mnt_idmap
 
 /**
  * nilfs_ioctl_getversion - get info about a file's version (generation number)
+ * @inode: inode object
+ * @argp:  userspace memory where the generation number of @inode is stored
+ *
+ * Return: 0 on success, or %-EFAULT on error.
  */
 static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
 {
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

