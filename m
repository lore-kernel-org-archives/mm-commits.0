Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18720C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 21:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349066AbiEPVO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 17:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349137AbiEPVOo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 17:14:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A362189
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 14:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B88D461517
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 21:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D877C34119;
        Mon, 16 May 2022 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652735336;
        bh=dkLJuxVGAZGEiyBL9TVc0SCc7qS4G0B5+LxtKac4Zmg=;
        h=Date:To:From:Subject:From;
        b=RRo6IAzCbnWOiTy5jWPX8fQ4JLvxvoWGHYKrbmcL/wemYvhx6YD3lg17EptSZpr+B
         wWqSybCSKiBEwP+bcUX73aw+ViQYTcAzKeOlhyNThPT8s5hfhgPJ/oNxF+0AiKNT71
         PRuplJQvdH1bNU8mPEsku5YST9DMAojIWazcJZ/o=
Date:   Mon, 16 May 2022 14:08:55 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        cccheng@synology.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch added to mm-nonmm-unstable branch
Message-Id: <20220516210856.1D877C34119@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: ignore ctime updates, and keep ctime identical to mtime in memory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

fat-split-fat_truncate_time-into-separate-functions.patch
fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch
fat-report-creation-time-in-statx.patch
fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch

