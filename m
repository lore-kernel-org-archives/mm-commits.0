Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DA6CCA47B
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 19:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345939AbiFMT4T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345840AbiFMT4H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 15:56:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324F5A33B6
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 11:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13491B81252
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 18:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A740C34114;
        Mon, 13 Jun 2022 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655144860;
        bh=EvMZodtOm/M0aCAwo2rx3pRD8nE9IWxnRqYbDkOa4cI=;
        h=Date:To:From:Subject:From;
        b=TYNJzwy78dZGo6myH0wOGKeSaaq42f1hF4rhEasTEEFvf55ZyqvpqjsFc+PgBjMmY
         T0/5vTdhMcpJeUoUuEJnOcspbxx7eoXJCLtdI05f29uzNnIuERTU2P+eX+a8F6Q/Si
         WNUxhY04QWftZGSuKtbz4rjf1qOivfNaVqF9nHts=
Date:   Mon, 13 Jun 2022 11:27:39 -0700
To:     mm-commits@vger.kernel.org, walters@verbum.org,
        usama.anjum@collabora.com, pjones@redhat.com,
        lennart@poettering.net, hirofumi@mail.parknet.co.jp,
        ckellner@redhat.com, cccheng@synology.com, alexl@redhat.com,
        javierm@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20220613182740.9A740C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add a vfat_rename2() and make existing .rename callback a helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper.patch

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

fat-add-a-vfat_rename2-and-make-existing-rename-callback-a-helper.patch
fat-add-renameat2-rename_exchange-flag-support.patch
selftests-filesystems-add-a-vfat-rename_exchange-test.patch

