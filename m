Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF88C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 22:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiGRWxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Jul 2022 18:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiGRWxY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2022 18:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4871932ECC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 15:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D15386155C
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 22:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EBAC341C0;
        Mon, 18 Jul 2022 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658184802;
        bh=VlU0b5DEzQjVcJL5xvMN/WoLOLRJrEst0Xws6/XhReg=;
        h=Date:To:From:Subject:From;
        b=z63f2Xc1Cfz2xsGuy3cyVztMYVS8TvZVqShhrwkkpAZzlyhmOhy92NjCnIsxNUT+K
         LehlEDfuqKTger2n6OL75I+WpeC0NQ9acpa3Ulm3kPGAwrZJ20xemAzKDoQoTBCGeb
         qVDqmbWQxSWDC7PbX2eSecEIFILCTREtwczv+7vw=
Date:   Mon, 18 Jul 2022 15:53:21 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu, sfr@canb.auug.org.au,
        hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20220718225322.04EBAC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix
Date: Mon Jul 18 03:51:33 PM PDT 2022

fix CONFIG_TMPFS_XATTR=n warnings

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   67 +++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

--- a/mm/shmem.c~mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix
+++ a/mm/shmem.c
@@ -2837,39 +2837,6 @@ out:
 	return error;
 }
 
-static int shmem_fileattr_get(struct dentry *dentry, struct fileattr *fa)
-{
-	struct shmem_inode_info *info = SHMEM_I(d_inode(dentry));
-
-	fileattr_fill_flags(fa, info->fsflags & SHMEM_FL_USER_VISIBLE);
-
-	return 0;
-}
-
-static int shmem_fileattr_set(struct user_namespace *mnt_userns,
-			      struct dentry *dentry, struct fileattr *fa)
-{
-	struct inode *inode = d_inode(dentry);
-	struct shmem_inode_info *info = SHMEM_I(inode);
-
-	if (fileattr_has_fsx(fa))
-		return -EOPNOTSUPP;
-
-	info->fsflags = (info->fsflags & ~SHMEM_FL_USER_MODIFIABLE) |
-		(fa->flags & SHMEM_FL_USER_MODIFIABLE);
-
-	inode->i_flags &= ~(S_APPEND | S_IMMUTABLE | S_NOATIME);
-	if (info->fsflags & FS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	if (info->fsflags & FS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	if (info->fsflags & FS_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
-
-	inode->i_ctime = current_time(inode);
-	return 0;
-}
-
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -3195,6 +3162,40 @@ static const char *shmem_get_link(struct
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch

