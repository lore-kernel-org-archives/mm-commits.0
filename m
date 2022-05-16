Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C97C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 21:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349134AbiEPVPB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 17:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349218AbiEPVOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 17:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFBC11A1A
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 14:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6792261517
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 21:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA39AC385B8;
        Mon, 16 May 2022 21:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652735340;
        bh=LyKzmXn97TovSXqYdNxKQZOnUiIwOecccmY1wERnABc=;
        h=Date:To:From:Subject:From;
        b=hvp1xiPRO8d6Wf0vE8X2g9qX+lzNHJYtm9A73TcFTlO6eBrWwDIzRikBeP2S5Z8js
         aUzX1sKTLNhikrp5ka7SYu6eoyuBrIvRTrvwI0YuVbvOQfULInQzHuwr0fcc+QLf9V
         0OByEFElPqphQKIkkw3o6GvcddRLNiLo7hKqvNm0=
Date:   Mon, 16 May 2022 14:09:00 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        cccheng@synology.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch added to mm-nonmm-unstable branch
Message-Id: <20220516210900.BA39AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: remove time truncations in vfat_create/vfat_mkdir
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch

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
Subject: fat: remove time truncations in vfat_create/vfat_mkdir
Date: Tue, 3 May 2022 23:25:36 +0800

All the timestamps in vfat_create() and vfat_mkdir() come from
fat_time_fat2unix() which ensures time granularity.  We don't need to
truncate them to fit FAT's format.

Moreover, fat_truncate_crtime() and fat_timespec64_trunc_10ms() are also
removed because there is no caller anymore.

Link: https://lkml.kernel.org/r/20220503152536.2503003-4-cccheng@synology.com
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h        |    2 --
 fs/fat/misc.c       |   21 ---------------------
 fs/fat/namei_vfat.c |    4 ----
 3 files changed, 27 deletions(-)

--- a/fs/fat/fat.h~fat-remove-time-truncations-in-vfat_create-vfat_mkdir
+++ a/fs/fat/fat.h
@@ -456,8 +456,6 @@ extern void fat_time_unix2fat(struct msd
 			      __le16 *time, __le16 *date, u8 *time_cs);
 extern struct timespec64 fat_truncate_atime(const struct msdos_sb_info *sbi,
 					    const struct timespec64 *ts);
-extern struct timespec64 fat_truncate_crtime(const struct msdos_sb_info *sbi,
-					     const struct timespec64 *ts);
 extern struct timespec64 fat_truncate_mtime(const struct msdos_sb_info *sbi,
 					    const struct timespec64 *ts);
 extern int fat_truncate_time(struct inode *inode, struct timespec64 *now,
--- a/fs/fat/misc.c~fat-remove-time-truncations-in-vfat_create-vfat_mkdir
+++ a/fs/fat/misc.c
@@ -281,13 +281,6 @@ static inline struct timespec64 fat_time
 	return (struct timespec64){ ts.tv_sec & ~1ULL, 0 };
 }
 
-static inline struct timespec64 fat_timespec64_trunc_10ms(struct timespec64 ts)
-{
-	if (ts.tv_nsec)
-		ts.tv_nsec -= ts.tv_nsec % 10000000UL;
-	return ts;
-}
-
 /*
  * truncate atime to 24 hour granularity (00:00:00 in local timezone)
  */
@@ -306,20 +299,6 @@ struct timespec64 fat_truncate_atime(con
 }
 
 /*
- * truncate creation time with appropriate granularity:
- *   msdos - 2 seconds
- *   vfat  - 10 milliseconds
- */
-struct timespec64 fat_truncate_crtime(const struct msdos_sb_info *sbi,
-				      const struct timespec64 *ts)
-{
-	if (sbi->options.isvfat)
-		return fat_timespec64_trunc_10ms(*ts);
-	else
-		return fat_timespec64_trunc_2secs(*ts);
-}
-
-/*
  * truncate mtime to 2 second granularity
  */
 struct timespec64 fat_truncate_mtime(const struct msdos_sb_info *sbi,
--- a/fs/fat/namei_vfat.c~fat-remove-time-truncations-in-vfat_create-vfat_mkdir
+++ a/fs/fat/namei_vfat.c
@@ -780,8 +780,6 @@ static int vfat_create(struct user_names
 		goto out;
 	}
 	inode_inc_iversion(inode);
-	fat_truncate_time(inode, &ts, S_ATIME|S_CTIME|S_MTIME);
-	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
 	d_instantiate(dentry, inode);
 out:
@@ -878,8 +876,6 @@ static int vfat_mkdir(struct user_namesp
 	}
 	inode_inc_iversion(inode);
 	set_nlink(inode, 2);
-	fat_truncate_time(inode, &ts, S_ATIME|S_CTIME|S_MTIME);
-	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
 	d_instantiate(dentry, inode);
 
_

Patches currently in -mm which might be from cccheng@synology.com are

fat-split-fat_truncate_time-into-separate-functions.patch
fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch
fat-report-creation-time-in-statx.patch
fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch

