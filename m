Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E9314A611
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723761469; cv=none; b=LZ35hZF7k9pDJr8F5n/EH7jOzY1tFrA880QWQJXBZOvOjnijQpdCUqpPYVd8Vi+mtp8Y+RbV9qIUDB4OrnrPa7OaC80Rdvu3RuBPqv5hhZtcuUv6oAeLHLlxYk5PDx6gQMLE0j5I0s9p7ViStgMcTI5kaxnUCwrhyRqHyGJaIxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723761469; c=relaxed/simple;
	bh=cF5ntOus9/dsMq+PXzg+BP/Dl/h7wZ7lJJlulb0QKTw=;
	h=Date:To:From:Subject:Message-Id; b=KVEu6ttKKwGnza8fa6xts88DDb4Utew+T8mJJR7sKtiMe9R7KPslNo4hz6MoVjqmNCu0ukNyGoVwfgs2MnZZtwfUGIMGkT8wEw9PWfjIKb3s0KfaZD5nr7yJ8Off3pNyV8cdHy9py6FfOG0MIgVPUyFYz3SYA2AB1NMKDuv4kb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WtsVAUeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WtsVAUeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E2BC32786;
	Thu, 15 Aug 2024 22:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723761468;
	bh=cF5ntOus9/dsMq+PXzg+BP/Dl/h7wZ7lJJlulb0QKTw=;
	h=Date:To:From:Subject:From;
	b=WtsVAUeq8e2QKwM2o3OVxELExfVdM9cYIHpputlZgeUc1VhN0GzJl3nucHmvougwK
	 xBgV/fqBtTLh0bGADrcseiEefgCskJqh2Dr/MqwXmYqu3N6KbB8bTTxdIVnu+oOsbl
	 TuulZ6Ruf67BghNeONc1SXn2/sLNnuyCUQpICIng=
Date: Thu, 15 Aug 2024 15:37:47 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-support-for-fs_ioc_setfslabel.patch added to mm-nonmm-unstable branch
Message-Id: <20240815223748.62E2BC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add support for FS_IOC_SETFSLABEL
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-support-for-fs_ioc_setfslabel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-support-for-fs_ioc_setfslabel.patch

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
Subject: nilfs2: add support for FS_IOC_SETFSLABEL
Date: Thu, 15 Aug 2024 16:44:08 +0900

Implement support for FS_IOC_SETFSLABEL ioctl to write filesystem label.

Link: https://lkml.kernel.org/r/20240815074408.5550-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   65 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/fs/nilfs2/ioctl.c~nilfs2-add-support-for-fs_ioc_setfslabel
+++ a/fs/nilfs2/ioctl.c
@@ -1290,6 +1290,68 @@ static int nilfs_ioctl_get_fslabel(struc
 	return 0;
 }
 
+/**
+ * nilfs_ioctl_set_fslabel - set the volume name of the file system
+ * @sb:   super block instance
+ * @filp: file object
+ * @argp: pointer to userspace memory that contains the volume name
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Error copying input data.
+ * * %-EINVAL	- Label length exceeds record size in superblock.
+ * * %-EIO	- I/O error.
+ * * %-EPERM	- Operation not permitted (insufficient permissions).
+ * * %-EROFS	- Read only file system.
+ */
+static int nilfs_ioctl_set_fslabel(struct super_block *sb, struct file *filp,
+				   void __user *argp)
+{
+	char label[NILFS_MAX_VOLUME_NAME + 1];
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct nilfs_super_block **sbp;
+	size_t len;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	if (copy_from_user(label, argp, NILFS_MAX_VOLUME_NAME + 1)) {
+		ret = -EFAULT;
+		goto out_drop_write;
+	}
+
+	len = strnlen(label, NILFS_MAX_VOLUME_NAME + 1);
+	if (len > NILFS_MAX_VOLUME_NAME) {
+		nilfs_err(sb, "unable to set label with more than %zu bytes",
+			  NILFS_MAX_VOLUME_NAME);
+		ret = -EINVAL;
+		goto out_drop_write;
+	}
+
+	down_write(&nilfs->ns_sem);
+	sbp = nilfs_prepare_super(sb, false);
+	if (unlikely(!sbp)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	strtomem_pad(sbp[0]->s_volume_name, label, 0);
+	if (sbp[1])
+		strtomem_pad(sbp[1]->s_volume_name, label, 0);
+
+	ret = nilfs_commit_super(sb, NILFS_SB_COMMIT_ALL);
+
+out_unlock:
+	up_write(&nilfs->ns_sem);
+out_drop_write:
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1334,6 +1396,8 @@ long nilfs_ioctl(struct file *filp, unsi
 		return nilfs_ioctl_trim_fs(inode, argp);
 	case FS_IOC_GETFSLABEL:
 		return nilfs_ioctl_get_fslabel(inode->i_sb, argp);
+	case FS_IOC_SETFSLABEL:
+		return nilfs_ioctl_set_fslabel(inode->i_sb, filp, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -1361,6 +1425,7 @@ long nilfs_compat_ioctl(struct file *fil
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 	case FITRIM:
 	case FS_IOC_GETFSLABEL:
+	case FS_IOC_SETFSLABEL:
 		break;
 	default:
 		return -ENOIOCTLCMD;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch

