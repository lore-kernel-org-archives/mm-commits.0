Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD690C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiESW2m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245511AbiESW2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD380A5013
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6997F60DB5
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F7EC385AA;
        Thu, 19 May 2022 22:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999254;
        bh=BFzFkiT9XD88GEjlO7L7IRs5GCLFLdbKjE1489dcn4I=;
        h=Date:To:From:Subject:From;
        b=W+2RTFPDeG4mI23k72qIl1G/yKBCVsf8ffrM273JVjbCLsvvF8ZTmDQYbFs3qKkUd
         0KFkHkuibSH9zmXn8C9MNCiCBXN1itwNRGr8v0xT9E2htEIuqCOrKcYiyVkkrqCLt0
         wXT46ZI5VKcXBNK0VMWV+uxTOlfAmd+89GRtYf90=
Date:   Thu, 19 May 2022 15:27:34 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        cccheng@synology.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch removed from -mm tree
Message-Id: <20220519222734.C0F7EC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: remove time truncations in vfat_create/vfat_mkdir
has been removed from the -mm tree.  Its filename was
     fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


