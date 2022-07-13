Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B06FC43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 15:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiGMPtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiGMPtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 11:49:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83331A390
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 08:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 402FB6192C
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 15:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD2AC34114;
        Wed, 13 Jul 2022 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657727343;
        bh=rtmyDsLmnlcoDnz/oiMyf4rZdyZF/rnx/GQSGNnd+9o=;
        h=Date:To:From:Subject:From;
        b=YU43s2VZ8G3SwlBDMC59IUqxKiPvwm80FwMxE03RXF1zlggz3icYp7N2kk1FBPTaS
         Mi9+G9gwzYjPSsYPnwZF6zAyOQUQ+4iZ9tqPazNexQ7FOnOMIGTx1wcX4b46v6zlYy
         ri8/qNn5P3OySgNmj+A1hnRlKcfe3VSSGCLG7r3k=
Date:   Wed, 13 Jul 2022 08:49:02 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        hughd@google.com, tytso@mit.edu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs.patch added to mm-unstable branch
Message-Id: <20220713154903.8FD2AC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: add support for FS_IOC_[SG]ETFLAGS for tmpfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs.patch

This patch will later appear in the mm-unstable branch at
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
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: mm/shmem: add support for FS_IOC_[SG]ETFLAGS for tmpfs
Date: Wed, 13 Jul 2022 10:52:34 -0400

This allows userspace to set flags like FS_APPEND_FL, FS_IMMUTABLE_FL,
FS_NODUMP_FL, etc., like all other standard Linux file systems.

Link: https://lkml.kernel.org/r/20220713145234.2356641-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   11 ++++++
 mm/shmem.c               |   65 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 1 deletion(-)

--- a/include/linux/shmem_fs.h~mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs
+++ a/include/linux/shmem_fs.h
@@ -25,9 +25,20 @@ struct shmem_inode_info {
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	atomic_t		stop_eviction;	/* hold when working on inode */
 	struct timespec64	i_crtime;	/* file creation time */
+	unsigned int		fsflags;	/* flags for FS_IOC_[SG]ETFLAGS */
 	struct inode		vfs_inode;
 };
 
+#define SHMEM_FL_USER_VISIBLE FS_FL_USER_VISIBLE
+#define SHMEM_FL_USER_MODIFIABLE FS_FL_USER_MODIFIABLE
+#define SHMEM_FL_INHERITED FS_FL_USER_MODIFIABLE
+
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define SHMEM_REG_FLMASK (~(FS_DIRSYNC_FL | FS_TOPDIR_FL))
+
+/* Flags that are appropriate for non-directories/regular files. */
+#define SHMEM_OTHER_FLMASK (FS_NODUMP_FL | FS_NOATIME_FL)
+
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
 	struct percpu_counter used_blocks;  /* How many are allocated */
--- a/mm/shmem.c~mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs
+++ a/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/ramfs.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
+#include <linux/fileattr.h>
 #include <linux/mm.h>
 #include <linux/random.h>
 #include <linux/sched/signal.h>
@@ -1058,6 +1059,15 @@ static int shmem_getattr(struct user_nam
 		shmem_recalc_inode(inode);
 		spin_unlock_irq(&info->lock);
 	}
+	if (info->fsflags & EXT2_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (info->fsflags & EXT2_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (info->fsflags & EXT2_NODUMP_FL)
+		stat->attributes |= STATX_ATTR_NODUMP;
+	stat->attributes_mask |= (STATX_ATTR_APPEND |
+			STATX_ATTR_IMMUTABLE |
+			STATX_ATTR_NODUMP);
 	generic_fillattr(&init_user_ns, inode, stat);
 
 	if (shmem_is_huge(NULL, inode, 0))
@@ -2272,7 +2282,18 @@ static int shmem_mmap(struct file *file,
 	return 0;
 }
 
-static struct inode *shmem_get_inode(struct super_block *sb, const struct inode *dir,
+/* Mask out flags that are inappropriate for the given type of inode. */
+static unsigned shmem_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & SHMEM_REG_FLMASK;
+	else
+		return flags & SHMEM_OTHER_FLMASK;
+}
+
+static struct inode *shmem_get_inode(struct super_block *sb, struct inode *dir,
 				     umode_t mode, dev_t dev, unsigned long flags)
 {
 	struct inode *inode;
@@ -2297,6 +2318,9 @@ static struct inode *shmem_get_inode(str
 		info->seals = F_SEAL_SEAL;
 		info->flags = flags & VM_NORESERVE;
 		info->i_crtime = inode->i_mtime;
+		info->fsflags = (dir == NULL) ? 0 :
+			SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
+		info->fsflags = shmem_mask_flags(mode, info->fsflags);
 		INIT_LIST_HEAD(&info->shrinklist);
 		INIT_LIST_HEAD(&info->swaplist);
 		simple_xattrs_init(&info->xattrs);
@@ -2813,6 +2837,41 @@ out:
 	return error;
 }
 
+int shmem_fileattr_get(struct dentry *dentry, struct fileattr *fa)
+{
+	struct shmem_inode_info *info = SHMEM_I(d_inode(dentry));
+
+	fileattr_fill_flags(fa, info->fsflags & SHMEM_FL_USER_VISIBLE);
+
+	return 0;
+}
+
+
+
+int shmem_fileattr_set(struct user_namespace *mnt_userns,
+		       struct dentry *dentry, struct fileattr *fa)
+{
+	struct inode *inode = d_inode(dentry);
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	if (fileattr_has_fsx(fa))
+		return -EOPNOTSUPP;
+
+	info->fsflags = (fa->flags & ~SHMEM_FL_USER_MODIFIABLE) |
+		(fa->flags & SHMEM_FL_USER_MODIFIABLE);
+
+	inode->i_flags &= ~(S_APPEND | S_IMMUTABLE | S_NOATIME);
+	if (info->fsflags & FS_APPEND_FL)
+		inode->i_flags |= S_APPEND;
+	if (info->fsflags & FS_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+	if (info->fsflags & FS_NOATIME_FL)
+		inode->i_flags |= S_NOATIME;
+
+	inode->i_ctime = current_time(inode);
+	return 0;
+}
+
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -3825,6 +3884,8 @@ static const struct inode_operations shm
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
 	.set_acl	= simple_set_acl,
+	.fileattr_get	= shmem_fileattr_get,
+	.fileattr_set	= shmem_fileattr_set,
 #endif
 };
 
@@ -3844,6 +3905,8 @@ static const struct inode_operations shm
 #endif
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
+	.fileattr_get	= shmem_fileattr_get,
+	.fileattr_set	= shmem_fileattr_set,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
_

Patches currently in -mm which might be from tytso@mit.edu are

mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs.patch

