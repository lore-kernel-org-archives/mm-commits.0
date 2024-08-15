Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68F514A611
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723761467; cv=none; b=UCQZrAKjh1w2wYa5v8fbvdxb+Vzmb/+SYoF39U4LBF+amHGuIwnVS+AbizZ6fy17orRnYqNRH9qF1LMmVYfLCQJlAVOQJWjW7BisQh6KwRMs3rsuSDuBCz7IqfIileEJKwJ0XfmeIF4JaoVp9wBfZ8RPGg2Mq92biWEJ33TwvKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723761467; c=relaxed/simple;
	bh=tqmq3n/lni0vkeM2IrzoYk/5JhzEzGHz1I59/BQDOgk=;
	h=Date:To:From:Subject:Message-Id; b=A9eWLIAiMhhGdUb/PutjyjPtom+4EfOIXP5PnKFfDtYZZ8EUKuZ1SMH2SF3wSnFY0WaDDkoAqiHxM8Ca3rnGRc5VBQeZIbc+mTORMXrbdDJuqg/ikEBsiwky4V+/FwuxE7EI+t1ze3WlbHV6DfsUfZjtgX4KF0BNwWHqhtH+Nz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oz5hskTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oz5hskTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA12C32786;
	Thu, 15 Aug 2024 22:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723761467;
	bh=tqmq3n/lni0vkeM2IrzoYk/5JhzEzGHz1I59/BQDOgk=;
	h=Date:To:From:Subject:From;
	b=Oz5hskThvTQLwV0NSm6w+ErYFvRya9mNIo5R2BJDGXlQwAlcg9D5mZUA6IfxU4giJ
	 on3UZu9fHZUelzT7mPgirokPz9JK28yfV7L1GG2v8RXHMWg+afhn08ET4fM5TtkCpf
	 KgJDjyB6Z7O7Qex+GU61fmErE2xijAwsPxaPDu9U=
Date: Thu, 15 Aug 2024 15:37:46 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-support-for-fs_ioc_getfslabel.patch added to mm-nonmm-unstable branch
Message-Id: <20240815223747.0DA12C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add support for FS_IOC_GETFSLABEL
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-support-for-fs_ioc_getfslabel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-support-for-fs_ioc_getfslabel.patch

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

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch

