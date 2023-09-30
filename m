Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81543E77350
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbjI3AVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjI3AVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B8C1B4;
        Fri, 29 Sep 2023 17:21:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7F4C433CB;
        Sat, 30 Sep 2023 00:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033276;
        bh=0u6nvM6N7YKlakyLnTe1DpAtiIlzRUOGJm8qIAfbOOA=;
        h=Date:To:From:Subject:From;
        b=lng713ohl9JE6mKmMTMpCrKnmBgy9nmL8HCLx1MsV2k8YAYkaongJSIZyTBtaFIIe
         mkMRS2D/rrd+TbJ036i+ZK5taXPbLcZzqNRlVG6vDA1sSkJT7+BzUzVB58cVWoOjQX
         jziMe+indvmypWvNBLezyQNqmTBxOHck0mEuzJu0=
Date:   Fri, 29 Sep 2023 17:21:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mengferry@linux.alibaba.com, konishi.ryusuke@gmail.com,
        bianpan2016@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data.patch removed from -mm tree
Message-Id: <20230930002115.ED7F4C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix potential use after free in nilfs_gccache_submit_read_data()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pan Bian <bianpan2016@163.com>
Subject: nilfs2: fix potential use after free in nilfs_gccache_submit_read_data()
Date: Thu, 21 Sep 2023 23:17:31 +0900

In nilfs_gccache_submit_read_data(), brelse(bh) is called to drop the
reference count of bh when the call to nilfs_dat_translate() fails.  If
the reference count hits 0 and its owner page gets unlocked, bh may be
freed.  However, bh->b_page is dereferenced to put the page after that,
which may result in a use-after-free bug.  This patch moves the release
operation after unlocking and putting the page.

NOTE: The function in question is only called in GC, and in combination
with current userland tools, address translation using DAT does not occur
in that function, so the code path that causes this issue will not be
executed.  However, it is possible to run that code path by intentionally
modifying the userland GC library or by calling the GC ioctl directly.

[konishi.ryusuke@gmail.com: NOTE added to the commit log]
Link: https://lkml.kernel.org/r/1543201709-53191-1-git-send-email-bianpan2016@163.com
Link: https://lkml.kernel.org/r/20230921141731.10073-1-konishi.ryusuke@gmail.com
Fixes: a3d93f709e89 ("nilfs2: block cache for garbage collection")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reported-by: Ferry Meng <mengferry@linux.alibaba.com>
Closes: https://lkml.kernel.org/r/20230818092022.111054-1-mengferry@linux.alibaba.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcinode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/gcinode.c~nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data
+++ a/fs/nilfs2/gcinode.c
@@ -73,10 +73,8 @@ int nilfs_gccache_submit_read_data(struc
 		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
 		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
-		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
-			brelse(bh);
+		if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
 			goto failed;
-		}
 	}
 
 	lock_buffer(bh);
@@ -102,6 +100,8 @@ int nilfs_gccache_submit_read_data(struc
  failed:
 	unlock_page(bh->b_page);
 	put_page(bh->b_page);
+	if (unlikely(err))
+		brelse(bh);
 	return err;
 }
 
_

Patches currently in -mm which might be from bianpan2016@163.com are


