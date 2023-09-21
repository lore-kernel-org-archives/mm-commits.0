Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C0DE7D0A6
	for <mm-commits@archiver.kernel.org>; Thu, 21 Sep 2023 18:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjIUSLa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjIUSLB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 14:11:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EF58680A;
        Thu, 21 Sep 2023 10:38:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C06C4E773;
        Thu, 21 Sep 2023 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695311229;
        bh=7iEt8p/fCXV0wTfBBUWX6nsfQDWIOa8AnYKh1Dl2Wf8=;
        h=Date:To:From:Subject:From;
        b=KtjR+VIHTTNeJGyn415DUMzXaKjl/Rt45dx6abE2CwdbiPTTvzrQE16QaNT45TKUt
         5P1T3Co/PmllxPdX6G6X9vmw+VrCpvNPEgNWoT7yEalnSm+opO+ykxLmgn314jtHcT
         igtNJx0syUWlB3Rvnk9dkNf1gOocHA8PNR6MrxHE=
Date:   Thu, 21 Sep 2023 08:47:08 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mengferry@linux.alibaba.com, konishi.ryusuke@gmail.com,
        bianpan2016@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data.patch added to mm-hotfixes-unstable branch
Message-Id: <20230921154709.79C06C4E773@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix potential use after free in nilfs_gccache_submit_read_data()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data.patch

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

nilfs2-fix-potential-use-after-free-in-nilfs_gccache_submit_read_data.patch

