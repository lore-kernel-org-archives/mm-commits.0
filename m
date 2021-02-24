Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC10BC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A454E64F08
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhBXUCP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235120AbhBXUCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56CC264F20;
        Wed, 24 Feb 2021 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196852;
        bh=BG36qJtyKsDqyW3kruv9FcwEBVvj/yyLc2TZ80f2/7Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xYNu2gUAXGavgLOrj7KZ/TWpJyWBlmjMjlm/5rTor+aa7QD9C2QrozZBZN1EFSy2X
         2+SMttSq5sYX9BBG/Kw0u+/+2Y0FVKuJoQAUlR/KnBbC5P8A/haSDaamIKO2coTAu+
         FBS0QHohgY9mgFatyg5MDWX2vCuBmpln//fhD5LA=
Date:   Wed, 24 Feb 2021 12:00:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 013/173] ramfs: support O_TMPFILE
Message-ID: <20210224200051.MRGrUqyzj%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
