Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7068913B582
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248821; cv=none; b=D7uy0G2DXNfUmO+0MmmU/q77oF+fqTlvQil18+zRp0BdtMRqpg2L8NoZkBKJ5hH9p4EYEGKUfXRRtSqj0XZr9qwTe1mHqdsEfUC//V6i9b8rfHrAAo7oaIjVceJQbtY/LTwg9VNIpJ6t1A5eLUYNC8dnQlqThuofT9VA3X1Waww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248821; c=relaxed/simple;
	bh=bXwg+kSwSOmnb+DVs84fuBVzIrmrFHHT8u1PQjk5npA=;
	h=Date:To:From:Subject:Message-Id; b=MD8t3Mc52qSMzJ7Hjru9jvhWXiAQgUc6EeWdqRwlR80i2FVB33jqALKXdG218Stgrs0g0o7X0bP9yVFw7fHLbmwzU2LLg4NZwGx1ThFa8XvqBLyYFS2v60eGf5Drpt/MyshvtO399TwFAhQR0MCJZWz880E/K52Un1jLLSEuwXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VXGpDw0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VXGpDw0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40858C4CEC2;
	Mon,  2 Sep 2024 03:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248821;
	bh=bXwg+kSwSOmnb+DVs84fuBVzIrmrFHHT8u1PQjk5npA=;
	h=Date:To:From:Subject:From;
	b=VXGpDw0lu+ZCG2Hkw9Er0xLcl9KGior4rLHt2EyZCBsf8xMMLo7o+/S/73sQ+Saop
	 O8ATAaJCnLTUr8dfnOMmirQ/csC7xpF9uNQTGmcw0xg6Uip87iDrdJjr01Pyxv2NuI
	 AlMkFXCppEG+618o791Xj+3blYh+XQLr8YkAhqYI=
Date: Sun, 01 Sep 2024 20:47:00 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch removed from -mm tree
Message-Id: <20240902034701.40858C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add missing argument descriptions for ioctl-related helpers
has been removed from the -mm tree.  Its filename was
     nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


