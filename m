Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBEAC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 21:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345363AbiEPVPC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 17:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348606AbiEPVOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 17:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04261F7F
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 14:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B83A614DA
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 21:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF3CC34100;
        Mon, 16 May 2022 21:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652735334;
        bh=BEjg4q6t3xBhrQh4lKUY5iGrltmo9+ktdD/luiYMFG0=;
        h=Date:To:From:Subject:From;
        b=Iek36sOYqIorTrSxl9VELdXIg7l9Yx2mC+i6PdDoz6f5U1CqFUDfFMeDLqEtlDEl8
         QH4Bl5YCzIqBV7JKheQkqNX5TuQsAMfk9KZUy+G+y4259xK2qIoEkqEh4VyIgAUyXG
         +0imHMZUkKsP1onYpEX0Xh7AgqfIkj+zbhztwJX4=
Date:   Mon, 16 May 2022 14:08:53 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        cccheng@synology.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-split-fat_truncate_time-into-separate-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20220516210853.DEF3CC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: split fat_truncate_time() into separate functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-split-fat_truncate_time-into-separate-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-split-fat_truncate_time-into-separate-functions.patch

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
Subject: fat: split fat_truncate_time() into separate functions
Date: Tue, 3 May 2022 23:25:33 +0800

Separate fat_truncate_time() to each timestamps for later creation time
work.

This patch does not introduce any functional changes, it's merely
refactoring change.

Link: https://lkml.kernel.org/r/20220503152536.2503003-1-cccheng@synology.com
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h  |    6 +++
 fs/fat/misc.c |   74 ++++++++++++++++++++++++++++++------------------
 2 files changed, 53 insertions(+), 27 deletions(-)

--- a/fs/fat/fat.h~fat-split-fat_truncate_time-into-separate-functions
+++ a/fs/fat/fat.h
@@ -453,6 +453,12 @@ extern void fat_time_fat2unix(struct msd
 			      __le16 __time, __le16 __date, u8 time_cs);
 extern void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec64 *ts,
 			      __le16 *time, __le16 *date, u8 *time_cs);
+extern struct timespec64 fat_truncate_atime(const struct msdos_sb_info *sbi,
+					    const struct timespec64 *ts);
+extern struct timespec64 fat_truncate_crtime(const struct msdos_sb_info *sbi,
+					     const struct timespec64 *ts);
+extern struct timespec64 fat_truncate_mtime(const struct msdos_sb_info *sbi,
+					    const struct timespec64 *ts);
 extern int fat_truncate_time(struct inode *inode, struct timespec64 *now,
 			     int flags);
 extern int fat_update_time(struct inode *inode, struct timespec64 *now,
--- a/fs/fat/misc.c~fat-split-fat_truncate_time-into-separate-functions
+++ a/fs/fat/misc.c
@@ -193,7 +193,7 @@ static long days_in_year[] = {
 	0,   0,  31,  59,  90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0,
 };
 
-static inline int fat_tz_offset(struct msdos_sb_info *sbi)
+static inline int fat_tz_offset(const struct msdos_sb_info *sbi)
 {
 	return (sbi->options.tz_set ?
 	       -sbi->options.time_offset :
@@ -289,15 +289,48 @@ static inline struct timespec64 fat_time
 }
 
 /*
+ * truncate atime to 24 hour granularity (00:00:00 in local timezone)
+ */
+struct timespec64 fat_truncate_atime(const struct msdos_sb_info *sbi,
+				     const struct timespec64 *ts)
+{
+	/* to localtime */
+	time64_t seconds = ts->tv_sec - fat_tz_offset(sbi);
+	s32 remainder;
+
+	div_s64_rem(seconds, SECS_PER_DAY, &remainder);
+	/* to day boundary, and back to unix time */
+	seconds = seconds + fat_tz_offset(sbi) - remainder;
+
+	return (struct timespec64){ seconds, 0 };
+}
+
+/*
+ * truncate creation time with appropriate granularity:
+ *   msdos - 2 seconds
+ *   vfat  - 10 milliseconds
+ */
+struct timespec64 fat_truncate_crtime(const struct msdos_sb_info *sbi,
+				      const struct timespec64 *ts)
+{
+	if (sbi->options.isvfat)
+		return fat_timespec64_trunc_10ms(*ts);
+	else
+		return fat_timespec64_trunc_2secs(*ts);
+}
+
+/*
+ * truncate mtime to 2 second granularity
+ */
+struct timespec64 fat_truncate_mtime(const struct msdos_sb_info *sbi,
+				     const struct timespec64 *ts)
+{
+	return fat_timespec64_trunc_2secs(*ts);
+}
+
+/*
  * truncate the various times with appropriate granularity:
- *   root inode:
- *     all times always 0
- *   all other inodes:
- *     mtime - 2 seconds
- *     ctime
- *       msdos - 2 seconds
- *       vfat  - 10 milliseconds
- *     atime - 24 hours (00:00:00 in local timezone)
+ *   all times in root node are always 0
  */
 int fat_truncate_time(struct inode *inode, struct timespec64 *now, int flags)
 {
@@ -312,25 +345,12 @@ int fat_truncate_time(struct inode *inod
 		ts = current_time(inode);
 	}
 
-	if (flags & S_ATIME) {
-		/* to localtime */
-		time64_t seconds = now->tv_sec - fat_tz_offset(sbi);
-		s32 remainder;
-
-		div_s64_rem(seconds, SECS_PER_DAY, &remainder);
-		/* to day boundary, and back to unix time */
-		seconds = seconds + fat_tz_offset(sbi) - remainder;
-
-		inode->i_atime = (struct timespec64){ seconds, 0 };
-	}
-	if (flags & S_CTIME) {
-		if (sbi->options.isvfat)
-			inode->i_ctime = fat_timespec64_trunc_10ms(*now);
-		else
-			inode->i_ctime = fat_timespec64_trunc_2secs(*now);
-	}
+	if (flags & S_ATIME)
+		inode->i_atime = fat_truncate_atime(sbi, now);
+	if (flags & S_CTIME)
+		inode->i_ctime = fat_truncate_crtime(sbi, now);
 	if (flags & S_MTIME)
-		inode->i_mtime = fat_timespec64_trunc_2secs(*now);
+		inode->i_mtime = fat_truncate_mtime(sbi, now);
 
 	return 0;
 }
_

Patches currently in -mm which might be from cccheng@synology.com are

fat-split-fat_truncate_time-into-separate-functions.patch
fat-ignore-ctime-updates-and-keep-ctime-identical-to-mtime-in-memory.patch
fat-report-creation-time-in-statx.patch
fat-remove-time-truncations-in-vfat_create-vfat_mkdir.patch

