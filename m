Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B4FC0015E
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 19:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjG1TZI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjG1TZG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 15:25:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B6A123;
        Fri, 28 Jul 2023 12:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B70B621D3;
        Fri, 28 Jul 2023 19:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1690C433C8;
        Fri, 28 Jul 2023 19:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690572303;
        bh=y8Tjh/8Iu5U5DtB3HoTZfH9lJV02DELlAWOY9YLNSig=;
        h=Date:To:From:Subject:From;
        b=G1H/FljaC2oKSoOTANZopeCZ83fuFDiuCcT0KLMyhkSaJfELNemD4keDxRGo1TU7C
         KrZpJA6FFki7KW3dttG6umtrMXTiJkC8WZVoBaXVvfilAbLlHQAo9f4TPTiiUE03ov
         Bhm8Khwb613ShbeglRMP9Z3BTcPpKlnsc37gY4SQ=
Date:   Fri, 28 Jul 2023 12:25:03 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput.patch added to mm-hotfixes-unstable branch
Message-Id: <20230728192503.A1690C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix use-after-free of nilfs_root in dirtying inodes via iput
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix use-after-free of nilfs_root in dirtying inodes via iput
Date: Sat, 29 Jul 2023 04:13:18 +0900

During unmount process of nilfs2, nothing holds nilfs_root structure after
nilfs2 detaches its writer in nilfs_detach_log_writer().  Previously,
nilfs_evict_inode() could cause use-after-free read for nilfs_root if
inodes are left in "garbage_list" and released by nilfs_dispose_list at
the end of nilfs_detach_log_writer(), and this bug was fixed by commit
9b5a04ac3ad9 ("nilfs2: fix use-after-free bug of nilfs_root in
nilfs_evict_inode()").

However, it turned out that there is another possibility of UAF in the
call path where mark_inode_dirty_sync() is called from iput():

nilfs_detach_log_writer()
  nilfs_dispose_list()
    iput()
      mark_inode_dirty_sync()
        __mark_inode_dirty()
          nilfs_dirty_inode()
            __nilfs_mark_inode_dirty()
              nilfs_load_inode_block() --> causes UAF of nilfs_root struct

This can happen after commit 0ae45f63d4ef ("vfs: add support for a
lazytime mount option"), which changed iput() to call
mark_inode_dirty_sync() on its final reference if i_state has I_DIRTY_TIME
flag and i_nlink is non-zero.

This issue appears after commit 28a65b49eb53 ("nilfs2: do not write dirty
data after degenerating to read-only") when using the syzbot reproducer,
but the issue has potentially existed before.

Fix this issue by adding a "purging flag" to the nilfs structure, setting
that flag while disposing the "garbage_list" and checking it in
__nilfs_mark_inode_dirty().

Unlike commit 9b5a04ac3ad9 ("nilfs2: fix use-after-free bug of nilfs_root
in nilfs_evict_inode()"), this patch does not rely on ns_writer to
determine whether to skip operations, so as not to break recovery on
mount.  The nilfs_salvage_orphan_logs routine dirties the buffer of
salvaged data before attaching the log writer, so changing
__nilfs_mark_inode_dirty() to skip the operation when ns_writer is NULL
will cause recovery write to fail.  The purpose of using the cleanup-only
flag is to allow for narrowing of such conditions.

Link: https://lkml.kernel.org/r/20230728191318.33047-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+74db8b3087f293d3a13a@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000b4e906060113fd63@google.com
Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org> # 4.0+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c     |    8 ++++++++
 fs/nilfs2/segment.c   |    2 ++
 fs/nilfs2/the_nilfs.h |    2 ++
 3 files changed, 12 insertions(+)

--- a/fs/nilfs2/inode.c~nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput
+++ a/fs/nilfs2/inode.c
@@ -1101,9 +1101,17 @@ int nilfs_set_file_dirty(struct inode *i
 
 int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
 {
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct buffer_head *ibh;
 	int err;
 
+	/*
+	 * Do not dirty inodes after the log writer has been detached
+	 * and its nilfs_root struct has been freed.
+	 */
+	if (unlikely(nilfs_purging(nilfs)))
+		return 0;
+
 	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
 		nilfs_warn(inode->i_sb,
--- a/fs/nilfs2/segment.c~nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput
+++ a/fs/nilfs2/segment.c
@@ -2845,6 +2845,7 @@ void nilfs_detach_log_writer(struct supe
 		nilfs_segctor_destroy(nilfs->ns_writer);
 		nilfs->ns_writer = NULL;
 	}
+	set_nilfs_purging(nilfs);
 
 	/* Force to free the list of dirty files */
 	spin_lock(&nilfs->ns_inode_lock);
@@ -2857,4 +2858,5 @@ void nilfs_detach_log_writer(struct supe
 	up_write(&nilfs->ns_segctor_sem);
 
 	nilfs_dispose_list(nilfs, &garbage_list, 1);
+	clear_nilfs_purging(nilfs);
 }
--- a/fs/nilfs2/the_nilfs.h~nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput
+++ a/fs/nilfs2/the_nilfs.h
@@ -29,6 +29,7 @@ enum {
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
 	THE_NILFS_GC_RUNNING,	/* gc process is running */
 	THE_NILFS_SB_DIRTY,	/* super block is dirty */
+	THE_NILFS_PURGING,	/* disposing dirty files for cleanup */
 };
 
 /**
@@ -208,6 +209,7 @@ THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
+THE_NILFS_FNS(PURGING, purging)
 
 /*
  * Mount option operations
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-use-after-free-of-nilfs_root-in-dirtying-inodes-via-iput.patch

