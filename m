Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1100C43334
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 20:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiFXUft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 16:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiFXUfs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 16:35:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8711E3AA73
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 13:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E29F7B828C9
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 20:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9694EC34114;
        Fri, 24 Jun 2022 20:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656102944;
        bh=qwGmqdnhbDYoRiGN+nfmxN9NYAS0RSEfUU8NWMRNldw=;
        h=Date:To:From:Subject:From;
        b=cWBTtJi2Yl/NrUa7yOgYBb+MvMwz+j92QwZgFJ/2xOp9A040J5kmqqAHP9Hj9jdKH
         io1RZgRLtHa6sa1neiAod8C1cWKXgMR8t3Lt4jIWQBLmTat9HDSIZIfF5z8T92m9na
         SxEjCnQ21d8yBrG+SAjRC/F/3PIruoSqQ+iGbZmU=
Date:   Fri, 24 Jun 2022 13:35:43 -0700
To:     mm-commits@vger.kernel.org, ptp@lysator.liu.se,
        ciprian.craciun@gmail.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks.patch added to mm-hotfixes-unstable branch
Message-Id: <20220624203544.9694EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix incorrect masking of permission flags for symlinks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks.patch

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
Subject: nilfs2: fix incorrect masking of permission flags for symlinks
Date: Thu, 23 Jun 2022 17:54:01 +0900

The permission flags of newly created symlinks are wrongly dropped on
nilfs2 with the current umask value even though symlinks should have 777
(rwxrwxrwx) permissions:

 $ umask
 0022
 $ touch file && ln -s file symlink; ls -l file symlink
 -rw-r--r--. 1 root root 0 Jun 23 16:29 file
 lrwxr-xr-x. 1 root root 4 Jun 23 16:29 symlink -> file

This fixes the bug by inserting a missing check that excludes
symlinks.

Link: https://lkml.kernel.org/r/1655974441-5612-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Tommy Pettersson <ptp@lysator.liu.se>
Reported-by: Ciprian Craciun <ciprian.craciun@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/nilfs.h~nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks
+++ a/fs/nilfs2/nilfs.h
@@ -198,6 +198,9 @@ static inline int nilfs_acl_chmod(struct
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks.patch

