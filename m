Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3426114D6F9
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248817; cv=none; b=URjaXQr1aKWnnyUOR9ptT1o8rJAj1R8ixfjWdQB2g5wzfuezTf1VgCIDV9MjEVqzOFM9QY5DuaqjXoWIhfXwOSXkuRVIY2BlSrGTHdynaAdJQVaa1v1Ti6YyRKdzgmbeDxoupHhZyqbs9RgGgL2WdtnS/d8qLltclvIyaNACqaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248817; c=relaxed/simple;
	bh=XbQYnlz5dFwepwfpLMa/13i2QNmxqET/r37QXvNY2JY=;
	h=Date:To:From:Subject:Message-Id; b=jb7+YCFLo0pQCFM7CXNAWrBKK3aNPg1BLB03L8e05R7njO9OqKOAWTpq6qlZsJW5dnb10/URZdTYwgXIjpBMH/0YEEt7Rg66IPiM/AtWFh7UPL2yTj4LRHFWNrEwlhAFAtssvspXNxMKQwr3YY3ZTbY7YvsVaN9gVsryzqwcMK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lMm8I4Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lMm8I4Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4CFC4CEC2;
	Mon,  2 Sep 2024 03:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248817;
	bh=XbQYnlz5dFwepwfpLMa/13i2QNmxqET/r37QXvNY2JY=;
	h=Date:To:From:Subject:From;
	b=lMm8I4Kf2oTWb1qE5mypfiI0S3TcgAsunvazTLw0ArPCvSAz6N6GFE/Z5KnF/3gwE
	 yEuIsVfFTt6OaJ8y2VkQm+HQyRG9ksHvHYEcsSz6f5MGEPlAV0bugLaL7WWEgQQqHh
	 2rjilUx2tq6KWL0E9Lv0OaEJoFZ5FSKnl4hPyGao=
Date: Sun, 01 Sep 2024 20:46:56 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-support-for-fs_ioc_getfslabel.patch removed from -mm tree
Message-Id: <20240902034657.0D4CFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add support for FS_IOC_GETFSLABEL
has been removed from the -mm tree.  Its filename was
     nilfs2-add-support-for-fs_ioc_getfslabel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: add support for FS_IOC_GETFSLABEL
Date: Thu, 15 Aug 2024 16:44:07 +0900

Implement support for FS_IOC_GETFSLABEL ioctl to read filesystem label.

Link: https://lkml.kernel.org/r/20240815074408.5550-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   27 +++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h |   12 ++++++++++++
 2 files changed, 39 insertions(+)

--- a/fs/nilfs2/ioctl.c~nilfs2-add-support-for-fs_ioc_getfslabel
+++ a/fs/nilfs2/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/mount.h>	/* mnt_want_write_file(), mnt_drop_write_file() */
 #include <linux/buffer_head.h>
 #include <linux/fileattr.h>
+#include <linux/string.h>
 #include "nilfs.h"
 #include "segment.h"
 #include "bmap.h"
@@ -1266,6 +1267,29 @@ out:
 	return ret;
 }
 
+/**
+ * nilfs_ioctl_get_fslabel - get the volume name of the file system
+ * @sb:   super block instance
+ * @argp: pointer to userspace memory where the volume name should be stored
+ *
+ * Return: 0 on success, %-EFAULT if copying to userspace memory fails.
+ */
+static int nilfs_ioctl_get_fslabel(struct super_block *sb, void __user *argp)
+{
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	char label[NILFS_MAX_VOLUME_NAME + 1];
+
+	BUILD_BUG_ON(NILFS_MAX_VOLUME_NAME >= FSLABEL_MAX);
+
+	down_read(&nilfs->ns_sem);
+	memtostr_pad(label, nilfs->ns_sbp[0]->s_volume_name);
+	up_read(&nilfs->ns_sem);
+
+	if (copy_to_user(argp, label, sizeof(label)))
+		return -EFAULT;
+	return 0;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1308,6 +1332,8 @@ long nilfs_ioctl(struct file *filp, unsi
 		return nilfs_ioctl_set_alloc_range(inode, argp);
 	case FITRIM:
 		return nilfs_ioctl_trim_fs(inode, argp);
+	case FS_IOC_GETFSLABEL:
+		return nilfs_ioctl_get_fslabel(inode->i_sb, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -1334,6 +1360,7 @@ long nilfs_compat_ioctl(struct file *fil
 	case NILFS_IOCTL_RESIZE:
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 	case FITRIM:
+	case FS_IOC_GETFSLABEL:
 		break;
 	default:
 		return -ENOIOCTLCMD;
--- a/fs/nilfs2/nilfs.h~nilfs2-add-support-for-fs_ioc_getfslabel
+++ a/fs/nilfs2/nilfs.h
@@ -103,6 +103,18 @@ enum {
 	NILFS_SB_COMMIT_ALL	/* Commit both super blocks */
 };
 
+/**
+ * define NILFS_MAX_VOLUME_NAME - maximum number of characters (bytes) in a
+ *                                file system volume name
+ *
+ * Defined by the size of the volume name field in the on-disk superblocks.
+ * This volume name does not include the terminating NULL byte if the string
+ * length matches the field size, so use (NILFS_MAX_VOLUME_NAME + 1) for the
+ * size of the buffer that requires a NULL byte termination.
+ */
+#define NILFS_MAX_VOLUME_NAME  \
+	sizeof_field(struct nilfs_super_block, s_volume_name)
+
 /*
  * Macros to check inode numbers
  */
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


