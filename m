Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEF1C77B7F
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjELXqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240705AbjELXqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:46:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C6112A;
        Fri, 12 May 2023 16:46:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 795076594E;
        Fri, 12 May 2023 23:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE64C433EF;
        Fri, 12 May 2023 23:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683935204;
        bh=exEphz6Zvx84nwShy2BNYCNnDDfoGaIQBTuyNDlkl24=;
        h=Date:To:From:Subject:From;
        b=F8DZ/D/dCzs7TQDnOSmwYdLsTdNIwvVu51p2h1rWwFJCsCMh8orroua6kpcatEg6N
         K74a7J900zSsvooTwKfOjgYF66SinB8OF4GjwBTvEykHloFYdAslWZpFWXbwJvClz8
         46N0U8RC72yKgSsou1I1KDqReN4auo+m3k6VnWFE=
Date:   Fri, 12 May 2023 16:46:44 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-use-after-free-bug-of-nilfs_root-in-nilfs_evict_inode.patch added to mm-hotfixes-unstable branch
Message-Id: <20230512234644.CBE64C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix use-after-free bug of nilfs_root in nilfs_evict_inode()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-use-after-free-bug-of-nilfs_root-in-nilfs_evict_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-use-after-free-bug-of-nilfs_root-in-nilfs_evict_inode.patch

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
Subject: nilfs2: fix use-after-free bug of nilfs_root in nilfs_evict_inode()
Date: Wed, 10 May 2023 00:29:56 +0900

During unmount process of nilfs2, nothing holds nilfs_root structure after
nilfs2 detaches its writer in nilfs_detach_log_writer().  However, since
nilfs_evict_inode() uses nilfs_root for some cleanup operations, it may
cause use-after-free read if inodes are left in "garbage_list" and
released by nilfs_dispose_list() at the end of nilfs_detach_log_writer().

Fix this issue by modifying nilfs_evict_inode() to only clear inode
without additional metadata changes that use nilfs_root if the file system
is degraded to read-only or the writer is detached.

Link: https://lkml.kernel.org/r/20230509152956.8313-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+78d4495558999f55d1da@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000099e5ac05fb1c3b85@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/nilfs2/inode.c~nilfs2-fix-use-after-free-bug-of-nilfs_root-in-nilfs_evict_inode
+++ a/fs/nilfs2/inode.c
@@ -917,6 +917,7 @@ void nilfs_evict_inode(struct inode *ino
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct the_nilfs *nilfs;
 	int ret;
 
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
@@ -929,6 +930,23 @@ void nilfs_evict_inode(struct inode *ino
 
 	truncate_inode_pages_final(&inode->i_data);
 
+	nilfs = sb->s_fs_info;
+	if (unlikely(sb_rdonly(sb) || !nilfs->ns_writer)) {
+		/*
+		 * If this inode is about to be disposed after the file system
+		 * has been degraded to read-only due to file system corruption
+		 * or after the writer has been detached, do not make any
+		 * changes that cause writes, just clear it.
+		 * Do this check after read-locking ns_segctor_sem by
+		 * nilfs_transaction_begin() in order to avoid a race with
+		 * the writer detach operation.
+		 */
+		clear_inode(inode);
+		nilfs_clear_inode(inode);
+		nilfs_transaction_abort(sb);
+		return;
+	}
+
 	/* TODO: some of the following operations may fail.  */
 	nilfs_truncate_bmap(ii, 0);
 	nilfs_mark_inode_dirty(inode);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-use-after-free-bug-of-nilfs_root-in-nilfs_evict_inode.patch

