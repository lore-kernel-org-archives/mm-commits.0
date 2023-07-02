Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8790EB64DD
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 18:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjGBSmV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 14:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjGBSmU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 14:42:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDF6C1
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 11:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E768460C7B
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 18:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472D8C433C8;
        Sun,  2 Jul 2023 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688323338;
        bh=/Fe648AzNmLpaLiXbymUpMyXr13GGEvSZopKzeBPH88=;
        h=Date:To:From:Subject:From;
        b=omS8dLsX7WjPw2JSSGwUAiAGnnjPovjQUl2d3gWW54YbW1m0X9gQGnsJnNZnSy83n
         QGXSNHajfieX6ugz6LAhSb6CwQ9vS5LoLQkIJQBDg6YBEBezRxIMfqKm/cBAjgCKZL
         cKhggrasxmX6OIKo2W5/eKfyl4gHzHptSzkv4DEc=
Date:   Sun, 02 Jul 2023 11:42:17 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        jlayton@kernel.org, hughd@google.com, hch@lst.de,
        brauner@kernel.org, chuck.lever@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-stable-directory-offsets.patch added to mm-unstable branch
Message-Id: <20230702184218.472D8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: stable directory offsets
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-stable-directory-offsets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-stable-directory-offsets.patch

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
From: Chuck Lever <chuck.lever@oracle.com>
Subject: shmem: stable directory offsets
Date: Fri, 30 Jun 2023 13:49:03 -0400

The current cursor-based directory offset mechanism doesn't work when a
tmpfs filesystem is exported via NFS.  This is because NFS clients do not
open directories.  Each server-side READDIR operation has to open the
directory, read it, then close it.  The cursor state for that directory,
being associated strictly with the opened struct file, is thus discarded
after each NFS READDIR operation.

Directory offsets are cached not only by NFS clients, but also by user
space libraries on those clients.  Essentially there is no way to
invalidate those caches when directory offsets have changed on an NFS
server after the offset-to-dentry mapping changes.  Thus the whole
application stack depends on unchanging directory offsets.

The solution we've come up with is to make the directory offset for each
file in a tmpfs filesystem stable for the life of the directory entry it
represents.

shmem_readdir() and shmem_dir_llseek() now use an xarray to map each
directory offset (an loff_t integer) to the memory address of a struct
dentry.

Link: https://lkml.kernel.org/r/168814734331.530310.3911190551060453102.stgit@manet.1015granger.net
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 
 mm/shmem.c               |   47 +++++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 7 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-stable-directory-offsets
+++ a/include/linux/shmem_fs.h
@@ -27,6 +27,7 @@ struct shmem_inode_info {
 	atomic_t		stop_eviction;	/* hold when working on inode */
 	struct timespec64	i_crtime;	/* file creation time */
 	unsigned int		fsflags;	/* flags for FS_IOC_[SG]ETFLAGS */
+	struct offset_ctx	dir_offsets;	/* stable entry offsets */
 	struct inode		vfs_inode;
 };
 
--- a/mm/shmem.c~shmem-stable-directory-offsets
+++ a/mm/shmem.c
@@ -2372,6 +2372,11 @@ static void shmem_set_inode_flags(struct
 #define shmem_initxattrs NULL
 #endif
 
+static struct offset_ctx *shmem_get_offset_ctx(struct inode *inode)
+{
+	return &SHMEM_I(inode)->dir_offsets;
+}
+
 static struct inode *shmem_get_inode(struct mnt_idmap *idmap, struct super_block *sb,
 				     struct inode *dir, umode_t mode, dev_t dev,
 				     unsigned long flags)
@@ -2427,7 +2432,8 @@ static struct inode *shmem_get_inode(str
 			/* Some things misbehave if size == 0 on a directory */
 			inode->i_size = 2 * BOGO_DIRENT_SIZE;
 			inode->i_op = &shmem_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
+			inode->i_fop = &simple_offset_dir_operations;
+			simple_offset_init(shmem_get_offset_ctx(inode));
 			break;
 		case S_IFLNK:
 			/*
@@ -3099,7 +3105,10 @@ shmem_mknod(struct mnt_idmap *idmap, str
 		if (error && error != -EOPNOTSUPP)
 			goto out_iput;
 
-		error = 0;
+		error = simple_offset_add(shmem_get_offset_ctx(dir), dentry);
+		if (error)
+			goto out_iput;
+
 		dir->i_size += BOGO_DIRENT_SIZE;
 		dir->i_ctime = dir->i_mtime = current_time(dir);
 		inode_inc_iversion(dir);
@@ -3176,6 +3185,13 @@ static int shmem_link(struct dentry *old
 			goto out;
 	}
 
+	ret = simple_offset_add(shmem_get_offset_ctx(dir), dentry);
+	if (ret) {
+		if (inode->i_nlink)
+			shmem_free_inode(inode->i_sb);
+		goto out;
+	}
+
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_time(inode);
 	inode_inc_iversion(dir);
@@ -3194,6 +3210,8 @@ static int shmem_unlink(struct inode *di
 	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode))
 		shmem_free_inode(inode->i_sb);
 
+	simple_offset_remove(shmem_get_offset_ctx(dir), dentry);
+
 	dir->i_size -= BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_time(inode);
 	inode_inc_iversion(dir);
@@ -3252,24 +3270,29 @@ static int shmem_rename2(struct mnt_idma
 {
 	struct inode *inode = d_inode(old_dentry);
 	int they_are_dirs = S_ISDIR(inode->i_mode);
+	int error;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
 	if (flags & RENAME_EXCHANGE)
-		return simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
+		return simple_offset_rename_exchange(old_dir, old_dentry,
+						     new_dir, new_dentry);
 
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
 	if (flags & RENAME_WHITEOUT) {
-		int error;
-
 		error = shmem_whiteout(idmap, old_dir, old_dentry);
 		if (error)
 			return error;
 	}
 
+	simple_offset_remove(shmem_get_offset_ctx(old_dir), old_dentry);
+	error = simple_offset_add(shmem_get_offset_ctx(new_dir), old_dentry);
+	if (error)
+		return error;
+
 	if (d_really_is_positive(new_dentry)) {
 		(void) shmem_unlink(new_dir, new_dentry);
 		if (they_are_dirs) {
@@ -3313,19 +3336,23 @@ static int shmem_symlink(struct mnt_idma
 	if (error && error != -EOPNOTSUPP)
 		goto out_iput;
 
+	error = simple_offset_add(shmem_get_offset_ctx(dir), dentry);
+	if (error)
+		goto out_iput;
+
 	inode->i_size = len-1;
 	if (len <= SHORT_SYMLINK_LEN) {
 		inode->i_link = kmemdup(symname, len, GFP_KERNEL);
 		if (!inode->i_link) {
 			error = -ENOMEM;
-			goto out_iput;
+			goto out_remove_offset;
 		}
 		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		inode_nohighmem(inode);
 		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE);
 		if (error)
-			goto out_iput;
+			goto out_remove_offset;
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
@@ -3340,6 +3367,9 @@ static int shmem_symlink(struct mnt_idma
 	d_instantiate(dentry, inode);
 	dget(dentry);
 	return 0;
+
+out_remove_offset:
+	simple_offset_remove(shmem_get_offset_ctx(dir), dentry);
 out_iput:
 	iput(inode);
 	return error;
@@ -4072,6 +4102,8 @@ static void shmem_destroy_inode(struct i
 {
 	if (S_ISREG(inode->i_mode))
 		mpol_free_shared_policy(&SHMEM_I(inode)->policy);
+	if (S_ISDIR(inode->i_mode))
+		simple_offset_destroy(shmem_get_offset_ctx(inode));
 }
 
 static void shmem_init_inode(void *foo)
@@ -4152,6 +4184,7 @@ static const struct inode_operations shm
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename2,
 	.tmpfile	= shmem_tmpfile,
+	.get_offset_ctx	= shmem_get_offset_ctx,
 #endif
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

libfs-add-directory-operations-for-stable-offsets.patch
shmem-refactor-shmem_symlink.patch
shmem-stable-directory-offsets.patch

