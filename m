Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399BDCCA47F
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiGCWoF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiGCWny (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:43:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EEDE24
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 15:43:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 367386122F
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 22:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C6EC341C6;
        Sun,  3 Jul 2022 22:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888232;
        bh=QuwysOtJgA3YBvdJZ8CHlaosm5RiOvpBuD9rroTTpcE=;
        h=Date:To:From:Subject:From;
        b=k74zOKCmcAltb5WGvd12Ah3Hjdw0OZR4U/6gwMgIan5x55yCOGoj1OHnofV08tnCL
         D3yTAf46XoyX9oXOKYsG3tw8Zzu/GW2cjtuAe5XH1KZQJntIPkBscipzK5r2DwoMe7
         7PASKOsSX21FN2ul5IXPq1dsQO/zwz2YU/SnRcR0=
Date:   Sun, 03 Jul 2022 15:43:51 -0700
To:     mm-commits@vger.kernel.org, ptp@lysator.liu.se,
        ciprian.craciun@gmail.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks.patch removed from -mm tree
Message-Id: <20220703224352.87C6EC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix incorrect masking of permission flags for symlinks
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-incorrect-masking-of-permission-flags-for-symlinks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


