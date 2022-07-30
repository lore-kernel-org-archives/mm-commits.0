Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4B8C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239707AbiG3BIz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CF182FA1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15AC7B82A26
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C619EC433B5;
        Sat, 30 Jul 2022 01:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143306;
        bh=IjhK3rWg1vyUOL5eSYBthUMVJU427VHFGJeIrLaxU1s=;
        h=Date:To:From:Subject:From;
        b=kBJ/vYQUZDjXH9OGSt7nddRFeiw6+eBnsJtXwVL25jXVsrSdDETZKwqMmL3LTAuS1
         RsvkrXRVeLmBHeZOTtxYhPZwOgfRm0V3TSM5K9mx18k15jStG/BsiLKu8d5TzPZN0c
         59M/W/Q9UfRrnbsyST0wZ1l+R2Nj+VS7w45HKOV0=
Date:   Fri, 29 Jul 2022 18:08:26 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, tytso@mit.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-support-fs_ioc_etflags-in-tmpfs.patch removed from -mm tree
Message-Id: <20220730010826.C619EC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: support FS_IOC_[SG]ETFLAGS in tmpfs
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-fs_ioc_etflags-in-tmpfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: mm/shmem: support FS_IOC_[SG]ETFLAGS in tmpfs
Date: Thu, 14 Jul 2022 21:59:12 -0400

This allows userspace to set flags like FS_APPEND_FL, FS_IMMUTABLE_FL,
FS_NODUMP_FL, etc., like all other standard Linux file systems.

[akpm@linux-foundation.org: fix CONFIG_TMPFS_XATTR=n warnings]
Link: https://lkml.kernel.org/r/20220715015912.2560575-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   11 ++++++
 mm/shmem.c               |   64 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

--- a/include/linux/shmem_fs.h~mm-shmem-support-fs_ioc_etflags-in-tmpfs
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
--- a/mm/shmem.c~mm-shmem-support-fs_ioc_etflags-in-tmpfs
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
+	if (info->fsflags & FS_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (info->fsflags & FS_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (info->fsflags & FS_NODUMP_FL)
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
@@ -3138,6 +3162,40 @@ static const char *shmem_get_link(struct
 }
 
 #ifdef CONFIG_TMPFS_XATTR
+
+static int shmem_fileattr_get(struct dentry *dentry, struct fileattr *fa)
+{
+	struct shmem_inode_info *info = SHMEM_I(d_inode(dentry));
+
+	fileattr_fill_flags(fa, info->fsflags & SHMEM_FL_USER_VISIBLE);
+
+	return 0;
+}
+
+static int shmem_fileattr_set(struct user_namespace *mnt_userns,
+			      struct dentry *dentry, struct fileattr *fa)
+{
+	struct inode *inode = d_inode(dentry);
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	if (fileattr_has_fsx(fa))
+		return -EOPNOTSUPP;
+
+	info->fsflags = (info->fsflags & ~SHMEM_FL_USER_MODIFIABLE) |
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
 /*
  * Superblocks without xattr inode operations may get some security.* xattr
  * support from the LSM "for free". As soon as we have any other xattrs
@@ -3828,6 +3886,8 @@ static const struct inode_operations shm
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
 	.set_acl	= simple_set_acl,
+	.fileattr_get	= shmem_fileattr_get,
+	.fileattr_set	= shmem_fileattr_set,
 #endif
 };
 
@@ -3847,6 +3907,8 @@ static const struct inode_operations shm
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


