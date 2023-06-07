Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9CCC83003
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 17:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjFGRna (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjFGRn0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 13:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4283B1FE9;
        Wed,  7 Jun 2023 10:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631106416A;
        Wed,  7 Jun 2023 17:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D6EC433A0;
        Wed,  7 Jun 2023 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686159800;
        bh=TgHVW4jn0KsVFk60hOaUi1qID2b6aV14Wtr5flGFYJU=;
        h=Date:To:From:Subject:From;
        b=LmJ9TEKEMWejeHkG0ts64yM1wvzlD+n/LwH6kVWVuoqnmma0hNE6LkjBo7QOwIedB
         99EFW/E9zCd7wkWio891zjKdun4YlHojfrJKo3nE82wUch7ekRQq/b9Qxzn111N/iu
         x85wjD+xMO6o/rjyOLhh0T1aw+8BDlaASdnLmOYc=
Date:   Wed, 07 Jun 2023 10:43:19 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, hughd@google.com, dhowells@redhat.com,
        roberto.sassu@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch added to mm-unstable branch
Message-Id: <20230607174320.A6D6EC433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: use ramfs_kill_sb() for kill_sb method of ramfs-based tmpfs
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch

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
From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: shmem: use ramfs_kill_sb() for kill_sb method of ramfs-based tmpfs
Date: Wed, 7 Jun 2023 18:15:23 +0200

As the ramfs-based tmpfs uses ramfs_init_fs_context() for the
init_fs_context method, which allocates fc->s_fs_info, use ramfs_kill_sb()
to free it and avoid a memory leak.

Link: https://lkml.kernel.org/r/20230607161523.2876433-1-roberto.sassu@huaweicloud.com
Fixes: f32356261d44 ("vfs: Convert ramfs, shmem, tmpfs, devtmpfs, rootfs to use the new mount API")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c      |    2 +-
 include/linux/ramfs.h |    1 +
 mm/shmem.c            |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ramfs/inode.c~shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs
+++ a/fs/ramfs/inode.c
@@ -278,7 +278,7 @@ int ramfs_init_fs_context(struct fs_cont
 	return 0;
 }
 
-static void ramfs_kill_sb(struct super_block *sb)
+void ramfs_kill_sb(struct super_block *sb)
 {
 	kfree(sb->s_fs_info);
 	kill_litter_super(sb);
--- a/include/linux/ramfs.h~shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs
+++ a/include/linux/ramfs.h
@@ -7,6 +7,7 @@
 struct inode *ramfs_get_inode(struct super_block *sb, const struct inode *dir,
 	 umode_t mode, dev_t dev);
 extern int ramfs_init_fs_context(struct fs_context *fc);
+extern void ramfs_kill_sb(struct super_block *sb);
 
 #ifdef CONFIG_MMU
 static inline int
--- a/mm/shmem.c~shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs
+++ a/mm/shmem.c
@@ -4214,7 +4214,7 @@ static struct file_system_type shmem_fs_
 	.name		= "tmpfs",
 	.init_fs_context = ramfs_init_fs_context,
 	.parameters	= ramfs_fs_parameters,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= ramfs_kill_sb,
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
_

Patches currently in -mm which might be from roberto.sassu@huawei.com are

memfd-check-for-non-null-file_seals-in-memfd_create-syscall.patch
shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch

