Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785FFC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 00:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiG3A4O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3A4O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 20:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E1880498
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 17:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F06D961723
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 00:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52881C433C1;
        Sat, 30 Jul 2022 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659142572;
        bh=QEn/DBxbhEfswJQrr4toVOToe2bjXoDJ3OOMv8t1EF0=;
        h=Date:To:From:Subject:From;
        b=pTJRr8pDRweoqMpxs2sxF0klrZXlrdwsvSvV64XQc71qK9Twpod6xYPlm97Pwkfrg
         7RW/SMkKrhQbd1LTrktUe7e2iH+Zc9It43tDosI7pD66PKPx2lRie1cHYCLKdngofi
         xT9MgeGzCq+uFheGk6GLdAqI/jT05KrKMIp35G2o=
Date:   Fri, 29 Jul 2022 17:56:11 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu, sfr@canb.auug.org.au,
        hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch removed from -mm tree
Message-Id: <20220730005612.52881C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-fs_ioc_etflags-in-tmpfs-fix.patch

This patch was dropped because it was folded into mm-shmem-support-fs_ioc_etflags-in-tmpfs.patch

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

mm-shmem-support-fs_ioc_etflags-in-tmpfs.patch

