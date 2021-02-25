Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E830C43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C659064FBF
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhBYTRb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234274AbhBYTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:14:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56C064F37;
        Thu, 25 Feb 2021 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280304;
        bh=AGbNZ3wpC9RpwvpEs3D9egCpEvfofjc/j+Dqfkzpt6s=;
        h=Date:From:To:Subject:From;
        b=mxx3tb2aHer0zrF39jNscDbaiP0YFzN6tpfM+qrnqu71Ow4r6nSE1vRVJEgI7oM0e
         udEPpv65q45wsPZUixbfAZaI04Mzx6kT54N40oJC3Tkz4dBSuyJLkDjf3orFjB4czD
         +FhCMdsuSkEhgJWCN7Yr9MPs+AsEQ1tdAplU/99M=
Date:   Thu, 25 Feb 2021 11:11:44 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged] ramfs-support-o_tmpfile.patch removed from -mm
 tree
Message-ID: <20210225191144.UXtCMFWi1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: support O_TMPFILE
has been removed from the -mm tree.  Its filename was
     ramfs-support-o_tmpfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ramfs: support O_TMPFILE

[akpm@linux-foundation.org: update inode_operations.tmpfile]
Link: http://lkml.kernel.org/r/20190206073349.GA15311@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/ramfs/inode.c~ramfs-support-o_tmpfile
+++ a/fs/ramfs/inode.c
@@ -151,6 +151,18 @@ static int ramfs_symlink(struct user_nam
 	return error;
 }
 
+static int ramfs_tmpfile(struct user_namespace *mnt_userns,
+			 struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct inode *inode;
+
+	inode = ramfs_get_inode(dir->i_sb, dir, mode, 0);
+	if (!inode)
+		return -ENOSPC;
+	d_tmpfile(dentry, inode);
+	return 0;
+}
+
 static const struct inode_operations ramfs_dir_inode_operations = {
 	.create		= ramfs_create,
 	.lookup		= simple_lookup,
@@ -161,6 +173,7 @@ static const struct inode_operations ram
 	.rmdir		= simple_rmdir,
 	.mknod		= ramfs_mknod,
 	.rename		= simple_rename,
+	.tmpfile	= ramfs_tmpfile,
 };
 
 /*
_

Patches currently in -mm which might be from adobriyan@gmail.com are


