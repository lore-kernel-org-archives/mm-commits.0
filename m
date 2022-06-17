Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1EBCCA47A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379702AbiFQC7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379895AbiFQC7M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346A165D10
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C264061D44
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2208FC34114;
        Fri, 17 Jun 2022 02:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434749;
        bh=PU89AMSAgiNLZN2uZ2/M/mA1aLPZphCm21ICiQ1hn5U=;
        h=Date:To:From:Subject:From;
        b=CPypkoSMAwO9WiODgXvyMTJlVCoxvem3iihrgbhKC2rwfqVLoEZ2MWKPdKQDqK95m
         TGF1JHNP19pF9xDRSzP+PpzYs3gGbZI6+dkEgSQN0ZIr6dqMbOwbaVp7d2NkgNUjSI
         7uMvr1X6WxcDm42QgC8sVylwMGDRFjk1G7Hf05u0=
Date:   Thu, 16 Jun 2022 19:59:08 -0700
To:     mm-commits@vger.kernel.org, walters@verbum.org,
        usama.anjum@collabora.com, pjones@redhat.com,
        lennart@poettering.net, hirofumi@mail.parknet.co.jp,
        ckellner@redhat.com, cccheng@synology.com, alexl@redhat.com,
        javierm@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper.patch removed from -mm tree
Message-Id: <20220617025909.2208FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: add a vfat_rename2() and make existing .rename callback a helper
has been removed from the -mm tree.  Its filename was
     fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Javier Martinez Canillas <javierm@redhat.com>
Subject: fat: add a vfat_rename2() and make existing .rename callback a helper
Date: Fri, 10 Jun 2022 09:57:18 +0200

Patch series "fat: add support for the renameat2 RENAME_EXCHANGE flag", v6.

The series adds support for the renameat2 system call RENAME_EXCHANGE flag
(which allows to atomically replace two paths) to the vfat filesystem
code.

There are many use cases for this, but we are particularly interested in
making possible for vfat filesystems to be part of OSTree [0] deployments.

Currently OSTree relies on symbolic links to make the deployment updates
an atomic transactional operation.  But RENAME_EXCHANGE could be used [1]
to achieve a similar level of robustness when using a vfat filesystem.

Patch #1 is just a preparatory patch to introduce the RENAME_EXCHANGE
support, patch #2 moves some code blocks in vfat_rename() to a set of
helper functions, that can be reused by tvfat_rename_exchange() that's
added by patch #3 and finally patch #4 adds some kselftests to test it.


This patch (of 4):

Currently vfat only supports the RENAME_NOREPLACE flag which is handled by
the virtual file system layer but doesn't support the RENAME_EXCHANGE
flag.

Add a vfat_rename2() function to be used as the .rename callback and move
the current vfat_rename() handler to a helper.  This is in preparation for
implementing the RENAME_NOREPLACE flag using a different helper function.

Link: https://lkml.kernel.org/r/20220610075721.1182745-1-javierm@redhat.com
Link: https://lkml.kernel.org/r/20220610075721.1182745-2-javierm@redhat.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Kellner <ckellner@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Chung-Chiang Cheng <cccheng@synology.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Alexander Larsson <alexl@redhat.com>
Cc: Colin Walters <walters@verbum.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/fs/fat/namei_vfat.c~fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper
+++ a/fs/fat/namei_vfat.c
@@ -889,9 +889,8 @@ out:
 	return err;
 }
 
-static int vfat_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
-		       struct dentry *old_dentry, struct inode *new_dir,
-		       struct dentry *new_dentry, unsigned int flags)
+static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
+		       struct inode *new_dir, struct dentry *new_dentry)
 {
 	struct buffer_head *dotdot_bh;
 	struct msdos_dir_entry *dotdot_de;
@@ -902,9 +901,6 @@ static int vfat_rename(struct user_names
 	int err, is_dir, update_dotdot, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
 
-	if (flags & ~RENAME_NOREPLACE)
-		return -EINVAL;
-
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = d_inode(old_dentry);
 	new_inode = d_inode(new_dentry);
@@ -1021,13 +1017,24 @@ error_inode:
 	goto out;
 }
 
+static int vfat_rename2(struct user_namespace *mnt_userns, struct inode *old_dir,
+			struct dentry *old_dentry, struct inode *new_dir,
+			struct dentry *new_dentry, unsigned int flags)
+{
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
+	/* VFS already handled RENAME_NOREPLACE, handle it as a normal rename */
+	return vfat_rename(old_dir, old_dentry, new_dir, new_dentry);
+}
+
 static const struct inode_operations vfat_dir_inode_operations = {
 	.create		= vfat_create,
 	.lookup		= vfat_lookup,
 	.unlink		= vfat_unlink,
 	.mkdir		= vfat_mkdir,
 	.rmdir		= vfat_rmdir,
-	.rename		= vfat_rename,
+	.rename		= vfat_rename2,
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
_

Patches currently in -mm which might be from javierm@redhat.com are


