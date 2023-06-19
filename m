Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D31EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjFSXVO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjFSXUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC0D10C6;
        Mon, 19 Jun 2023 16:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 255C960F57;
        Mon, 19 Jun 2023 23:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE84C433C0;
        Mon, 19 Jun 2023 23:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216842;
        bh=o3tAGB1OaBUq+iFFYKuAnjwnh6jmefzgvcRLwVdoKJ8=;
        h=Date:To:From:Subject:From;
        b=J5BT6EVFwDGf/jM0k4klTMAUHcoQTL047TiXmaFZHGZ4jL9PmIpx+/z6V9UKbmB28
         1vEd3Q3fw333MrYNhKKa/pg/ZkewdXKGTw3IOHbHUF5HWxo+F2iZbgGEg4hMvwQOSf
         DE2+bE6vKVQGAlz1rlblu+VGfkhWUT+r5VX3fL7U=
Date:   Mon, 19 Jun 2023 16:20:41 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, hughd@google.com, dhowells@redhat.com,
        roberto.sassu@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch removed from -mm tree
Message-Id: <20230619232042.7EE84C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: use ramfs_kill_sb() for kill_sb method of ramfs-based tmpfs
has been removed from the -mm tree.  Its filename was
     shmem-use-ramfs_kill_sb-for-kill_sb-method-of-ramfs-based-tmpfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: shmem: use ramfs_kill_sb() for kill_sb method of ramfs-based tmpfs
Date: Wed, 7 Jun 2023 18:15:23 +0200

As the ramfs-based tmpfs uses ramfs_init_fs_context() for the
init_fs_context method, which allocates fc->s_fs_info, use ramfs_kill_sb()
to free it and avoid a memory leak.

Link: https://lkml.kernel.org/r/20230607161523.2876433-1-roberto.sassu@huaweicloud.com
Fixes: c3b1b1cbf002 ("ramfs: add support for "mode=" mount option")
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
@@ -4199,7 +4199,7 @@ static struct file_system_type shmem_fs_
 	.name		= "tmpfs",
 	.init_fs_context = ramfs_init_fs_context,
 	.parameters	= ramfs_fs_parameters,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= ramfs_kill_sb,
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
_

Patches currently in -mm which might be from roberto.sassu@huawei.com are


