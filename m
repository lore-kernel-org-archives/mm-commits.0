Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAAEC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245454AbiESW2f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245512AbiESW2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F5677F0F
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BEE6171E
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF76C385AA;
        Thu, 19 May 2022 22:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999252;
        bh=oR5d/q69qm2C+oNRICB3yyiWqmA2CQqeu/RqvPVnQho=;
        h=Date:To:From:Subject:From;
        b=Yvpzz2e1D7sXKuzWhyUz2Gx2UVhUOfGfYjG1NBeozFWGTp0HAza7E8Wvha+nP2ukO
         DoIlLqkH0e3+OVgfb43eSZVHMOI2PVUt4wUJ7y4PLbs03bW8zmqoLQDMCBnuh3eLxN
         +dQMW6iGmREbf9RfpNpijJqG54Pjo6/Eo0ttsPQg=
Date:   Thu, 19 May 2022 15:27:32 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        cccheng@synology.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch removed from -mm tree
Message-Id: <20220519222732.CDF76C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: ignore ctime updates, and keep ctime identical to mtime in memory
has been removed from the -mm tree.  Its filename was
     fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chung-Chiang Cheng <cccheng@synology.com>
Subject: fat: ignore ctime updates, and keep ctime identical to mtime in memory
Date: Tue, 3 May 2022 23:25:34 +0800

FAT supports creation time but not change time, and there was no
corresponding timestamp for creation time in previous VFS.  The original
implementation took the compromise of saving the in-memory change time
into the on-disk creation time field, but this would lead to compatibility
issues with non-linux systems.

To address this issue, this patch changes the behavior of ctime.  It will
no longer be loaded and stored from the creation time on disk.  Instead of
that, it'll be consistent with the in-memory mtime and share the same
on-disk field.  All updates to mtime will also be applied to ctime in
memory, while all updates to ctime will be ignored.

Link: https://lkml.kernel.org/r/20220503152536.2503003-2-cccheng@synology.com
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   11 ++++-------
 fs/fat/misc.c  |    9 ++++++---
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/fs/fat/inode.c~fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory
+++ a/fs/fat/inode.c
@@ -567,12 +567,11 @@ int fat_fill_inode(struct inode *inode,
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 
 	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
-	if (sbi->options.isvfat) {
-		fat_time_fat2unix(sbi, &inode->i_ctime, de->ctime,
-				  de->cdate, de->ctime_cs);
+	inode->i_ctime = inode->i_mtime;
+	if (sbi->options.isvfat)
 		fat_time_fat2unix(sbi, &inode->i_atime, 0, de->adate, 0);
-	} else
-		fat_truncate_time(inode, &inode->i_mtime, S_ATIME|S_CTIME);
+	else
+		inode->i_atime = fat_truncate_atime(sbi, &inode->i_mtime);
 
 	return 0;
 }
@@ -888,8 +887,6 @@ retry:
 			  &raw_entry->date, NULL);
 	if (sbi->options.isvfat) {
 		__le16 atime;
-		fat_time_unix2fat(sbi, &inode->i_ctime, &raw_entry->ctime,
-				  &raw_entry->cdate, &raw_entry->ctime_cs);
 		fat_time_unix2fat(sbi, &inode->i_atime, &atime,
 				  &raw_entry->adate, NULL);
 	}
--- a/fs/fat/misc.c~fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory
+++ a/fs/fat/misc.c
@@ -347,10 +347,13 @@ int fat_truncate_time(struct inode *inod
 
 	if (flags & S_ATIME)
 		inode->i_atime = fat_truncate_atime(sbi, now);
-	if (flags & S_CTIME)
-		inode->i_ctime = fat_truncate_crtime(sbi, now);
+	/*
+	 * ctime and mtime share the same on-disk field, and should be
+	 * identical in memory. all mtime updates will be applied to ctime,
+	 * but ctime updates are ignored.
+	 */
 	if (flags & S_MTIME)
-		inode->i_mtime = fat_truncate_mtime(sbi, now);
+		inode->i_mtime = inode->i_ctime = fat_truncate_mtime(sbi, now);
 
 	return 0;
 }
_

Patches currently in -mm which might be from cccheng@synology.com are


