Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2190ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiIIVHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiIIVHO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D0314945A
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 857F6B82628
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D53C433D6;
        Fri,  9 Sep 2022 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662757600;
        bh=iOTqEyC2N81zSh9klZUCUdnzIzmBY0/jth5SjjOhF9M=;
        h=Date:To:From:Subject:From;
        b=Hk0lKS34EPvODbsPybBjY9yPNzqDBZvnKAZiuOS7GNbyfN19vqv29cz4bUo2ylJ85
         JJ9l0RRQ3v4tj8FyTQsyjOP4TBvsaQ1rbE32hti10Yf2G1VXoNCzwSgL0GoHymfrYk
         4zDdrneqHFewYLLncJOIClQ0hyBoLKGiIQynCh88=
Date:   Fri, 09 Sep 2022 14:06:39 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        hughd@google.com, chuck.lever@oracle.com, jlayton@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-add-support-for-an-i_version-counter.patch added to mm-unstable branch
Message-Id: <20220909210640.24D53C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: add support for an i_version counter
has been added to the -mm mm-unstable branch.  Its filename is
     tmpfs-add-support-for-an-i_version-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-add-support-for-an-i_version-counter.patch

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
From: Jeff Layton <jlayton@kernel.org>
Subject: tmpfs: add support for an i_version counter
Date: Fri, 9 Sep 2022 09:00:31 -0400

NFSv4 mandates a change attribute to avoid problems with timestamp
granularity, which Linux implements using the i_version counter. This is
particularly important when the underlying filesystem is fast.

Give tmpfs an i_version counter. Since it doesn't have to be persistent,
we can just turn on SB_I_VERSION and sprinkle some inode_inc_iversion
calls in the right places.

Also, while there is no formal spec for xattrs, most implementations
update the ctime on setxattr. Fix shmem_xattr_handler_set to update the
ctime and bump the i_version appropriately.

Link: https://lkml.kernel.org/r/20220909130031.15477-1-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/posix_acl.c |    3 +++
 mm/shmem.c     |   31 ++++++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

--- a/fs/posix_acl.c~tmpfs-add-support-for-an-i_version-counter
+++ a/fs/posix_acl.c
@@ -24,6 +24,7 @@
 #include <linux/user_namespace.h>
 #include <linux/namei.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/iversion.h>
 
 static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
@@ -1073,6 +1074,8 @@ int simple_set_acl(struct user_namespace
 	}
 
 	inode->i_ctime = current_time(inode);
+	if (IS_I_VERSION(inode))
+		inode_inc_iversion(inode);
 	set_cached_acl(inode, type, acl);
 	return 0;
 }
--- a/mm/shmem.c~tmpfs-add-support-for-an-i_version-counter
+++ a/mm/shmem.c
@@ -38,6 +38,7 @@
 #include <linux/hugetlb.h>
 #include <linux/fs_parser.h>
 #include <linux/swapfile.h>
+#include <linux/iversion.h>
 #include "swap.h"
 
 static struct vfsmount *shm_mnt;
@@ -1030,6 +1031,7 @@ void shmem_truncate_range(struct inode *
 {
 	shmem_undo_range(inode, lstart, lend, false);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
+	inode_inc_iversion(inode);
 }
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
@@ -1074,6 +1076,8 @@ static int shmem_setattr(struct user_nam
 	struct inode *inode = d_inode(dentry);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int error;
+	bool update_mtime = false;
+	bool update_ctime = true;
 
 	error = setattr_prepare(&init_user_ns, dentry, attr);
 	if (error)
@@ -1094,7 +1098,9 @@ static int shmem_setattr(struct user_nam
 			if (error)
 				return error;
 			i_size_write(inode, newsize);
-			inode->i_ctime = inode->i_mtime = current_time(inode);
+			update_mtime = true;
+		} else {
+			update_ctime = false;
 		}
 		if (newsize <= oldsize) {
 			loff_t holebegin = round_up(newsize, PAGE_SIZE);
@@ -1114,6 +1120,12 @@ static int shmem_setattr(struct user_nam
 	setattr_copy(&init_user_ns, inode, attr);
 	if (attr->ia_valid & ATTR_MODE)
 		error = posix_acl_chmod(&init_user_ns, inode, inode->i_mode);
+	if (!error && update_ctime) {
+		inode->i_ctime = current_time(inode);
+		if (update_mtime)
+			inode->i_mtime = inode->i_ctime;
+		inode_inc_iversion(inode);
+	}
 	return error;
 }
 
@@ -2889,6 +2901,7 @@ shmem_mknod(struct user_namespace *mnt_u
 		error = 0;
 		dir->i_size += BOGO_DIRENT_SIZE;
 		dir->i_ctime = dir->i_mtime = current_time(dir);
+		inode_inc_iversion(dir);
 		d_instantiate(dentry, inode);
 		dget(dentry); /* Extra count - pin the dentry in core */
 	}
@@ -2964,6 +2977,7 @@ static int shmem_link(struct dentry *old
 
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_time(inode);
+	inode_inc_iversion(dir);
 	inc_nlink(inode);
 	ihold(inode);	/* New dentry reference */
 	dget(dentry);		/* Extra pinning count for the created dentry */
@@ -2981,6 +2995,7 @@ static int shmem_unlink(struct inode *di
 
 	dir->i_size -= BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_time(inode);
+	inode_inc_iversion(dir);
 	drop_nlink(inode);
 	dput(dentry);	/* Undo the count from "create" - this does all the work */
 	return 0;
@@ -3070,6 +3085,8 @@ static int shmem_rename2(struct user_nam
 	old_dir->i_ctime = old_dir->i_mtime =
 	new_dir->i_ctime = new_dir->i_mtime =
 	inode->i_ctime = current_time(old_dir);
+	inode_inc_iversion(old_dir);
+	inode_inc_iversion(new_dir);
 	return 0;
 }
 
@@ -3122,6 +3139,7 @@ static int shmem_symlink(struct user_nam
 	}
 	dir->i_size += BOGO_DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = current_time(dir);
+	inode_inc_iversion(dir);
 	d_instantiate(dentry, inode);
 	dget(dentry);
 	return 0;
@@ -3193,6 +3211,7 @@ static int shmem_fileattr_set(struct use
 
 	shmem_set_inode_flags(inode, info->fsflags);
 	inode->i_ctime = current_time(inode);
+	inode_inc_iversion(inode);
 	return 0;
 }
 
@@ -3256,9 +3275,15 @@ static int shmem_xattr_handler_set(const
 				   size_t size, int flags)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int err;
 
 	name = xattr_full_name(handler, name);
-	return simple_xattr_set(&info->xattrs, name, value, size, flags, NULL);
+	err = simple_xattr_set(&info->xattrs, name, value, size, flags, NULL);
+	if (!err) {
+		inode->i_ctime = current_time(inode);
+		inode_inc_iversion(inode);
+	}
+	return err;
 }
 
 static const struct xattr_handler shmem_security_xattr_handler = {
@@ -3721,7 +3746,7 @@ static int shmem_fill_super(struct super
 		sb->s_flags |= SB_NOUSER;
 	}
 	sb->s_export_op = &shmem_export_ops;
-	sb->s_flags |= SB_NOSEC;
+	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
 #else
 	sb->s_flags |= SB_NOUSER;
 #endif
_

Patches currently in -mm which might be from jlayton@kernel.org are

tmpfs-add-support-for-an-i_version-counter.patch

