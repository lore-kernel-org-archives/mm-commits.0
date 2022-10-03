Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CC8C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 19:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJCTtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 15:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJCTtN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 15:49:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91A839BBF;
        Mon,  3 Oct 2022 12:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF34DCE0E53;
        Mon,  3 Oct 2022 19:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A617C433D6;
        Mon,  3 Oct 2022 19:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664826547;
        bh=zIQeWN/nzrmF/KJip8K4yqN44Q6DymFqTzaKg74mdfA=;
        h=Date:To:From:Subject:From;
        b=uvBNOy6CoafWqVPlaQBXTM6aZ56IVVnh85FjH+vpbpnLhi20Uq9Yike+/dGQvMIKU
         Lqa7CA7OlSSYodfBygMxRptIZjCX98op2m/h1GchKNevzpLhGae8VAtxlvxYLVGqAJ
         cImCqMx6AOG68V59dpO0HYWIZLsh5u+BabQPc2HA=
Date:   Mon, 03 Oct 2022 12:49:06 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch added to mm-hotfixes-unstable branch
Message-Id: <20221003194907.8A617C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch

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
Subject: nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
Date: Sun, 2 Oct 2022 12:08:04 +0900

If the i_mode field in inode of metadata files is corrupted on disk, it
can cause the initialization of bmap structure, which should have been
called from nilfs_read_inode_common(), not to be called.  This causes a
lockdep warning followed by a NULL pointer dereference at
nilfs_bmap_lookup_at_level().

This patch fixes these issues by adding a missing sanitiy check for the
i_mode field of metadata file's inode.

Link: https://lkml.kernel.org/r/20221002030804.29978-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/inode.c~nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level
+++ a/fs/nilfs2/inode.c
@@ -455,6 +455,8 @@ int nilfs_read_inode_common(struct inode
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-use-after-free-bug-of-struct-nilfs_root.patch
nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch
nilfs2-replace-warn_ons-by-nilfs_error-for-checkpoint-acquisition-failure.patch

