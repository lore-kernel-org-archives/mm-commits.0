Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A59115383E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248818; cv=none; b=saWM+h9vOjUMRlqi6yNWUetWk8meLGYjyogUx2sXPJ01A/Sgny5ZEaRQbDyMnVEZa4J9LiZ2sbA5zbSmPX3EEdbOkq6G3mK6sXkHi0UedmfATJz19t8pCqVCbACDWXyP987G6Rm4Kz1xJ/GdDYL73gvy8ixi/JT+RQ4x5mdvjK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248818; c=relaxed/simple;
	bh=ZQwsagqO/Ofrg+2GyzmUCXmU6dfWOIdUm+Val7AVDXY=;
	h=Date:To:From:Subject:Message-Id; b=Bc8QQDrGPbJDydo6WFGZJl1CWtYz61g6NGlDrKnk8N+pT/AVX70ibscZs/FILFMxT13lnFbghwH5ck+bC0SK3ZXB/AI7DmiR6+hiS7AuJfDBTfH7Sdu5tlytkPEi4wn4p25DSaFVn/wv6fi0cYoKBKemYjDjmLxZtD5FqfuCmU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HqJ7z5lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HqJ7z5lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E682C4CEC2;
	Mon,  2 Sep 2024 03:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248818;
	bh=ZQwsagqO/Ofrg+2GyzmUCXmU6dfWOIdUm+Val7AVDXY=;
	h=Date:To:From:Subject:From;
	b=HqJ7z5luwknewUzmDxNHcwOr9xSrBQreUuHgRXLYX8yREPclmCLs49w8L/ocONbwp
	 fMzTf892+UQ4Zczp/XNmmOnrU7kGqRc3P3Aje110lZg3eOYnP/k8TC3ci4DYBHQwmk
	 7BQDChniNF7WMNZeBpsa15c2bYlAyOBvWqQucyDE=
Date: Sun, 01 Sep 2024 20:46:57 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-support-for-fs_ioc_setfslabel.patch removed from -mm tree
Message-Id: <20240902034658.0E682C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add support for FS_IOC_SETFSLABEL
has been removed from the -mm tree.  Its filename was
     nilfs2-add-support-for-fs_ioc_setfslabel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


