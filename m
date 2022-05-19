Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB511C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245494AbiESW2j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245503AbiESW2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1D3986F9
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CAD261717
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DFFC385AA;
        Thu, 19 May 2022 22:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999253;
        bh=A4DTC6Neciegh06TL5yAzW0ZDKKBai2ZgkEhcDWjg8g=;
        h=Date:To:From:Subject:From;
        b=BOXvrljpI7uXBGMDZjcmX2S/w5ri4IxpRMi8RopESq04sN1N6+i25/H8Myj+KgLWt
         anh4JjnOt9XdfAwXlvfyQhMCY4ycx+TkbFjlFhg/TA07dEI6VkA6v/QV+GzryDnN71
         gY8YnmqXKPcSDxUTl+j4zOPFznb/2SDpe7uAklPw=
Date:   Thu, 19 May 2022 15:27:33 -0700
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        cccheng@synology.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-report-creation-time-in-statx.patch removed from -mm tree
Message-Id: <20220519222733.C4DFFC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: report creation time in statx
has been removed from the -mm tree.  Its filename was
     fat-report-creation-time-in-statx.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chung-Chiang Cheng <cccheng@synology.com>
Subject: fat: report creation time in statx
Date: Tue, 3 May 2022 23:25:35 +0800

creation time is no longer mixed with change time.  Add an in-memory field
for it, and report it in statx if supported.

Link: https://lkml.kernel.org/r/20220503152536.2503003-3-cccheng@synology.com
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 +
 fs/fat/file.c  |   14 +++++++++++---
 fs/fat/inode.c |   10 ++++++++--
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/fs/fat/fat.h~fat-report-creation-time-in-statx
+++ a/fs/fat/fat.h
@@ -126,6 +126,7 @@ struct msdos_inode_info {
 	struct hlist_node i_fat_hash;	/* hash by i_location */
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
+	struct timespec64 i_crtime;	/* File creation (birth) time */
 	struct inode vfs_inode;
 };
 
--- a/fs/fat/file.c~fat-report-creation-time-in-statx
+++ a/fs/fat/file.c
@@ -399,13 +399,21 @@ int fat_getattr(struct user_namespace *m
 		struct kstat *stat, u32 request_mask, unsigned int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+
 	generic_fillattr(mnt_userns, inode, stat);
-	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
+	stat->blksize = sbi->cluster_size;
 
-	if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+	if (sbi->options.nfs == FAT_NFS_NOSTALE_RO) {
 		/* Use i_pos for ino. This is used as fileid of nfs. */
-		stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb), inode);
+		stat->ino = fat_i_pos_read(sbi, inode);
+	}
+
+	if (sbi->options.isvfat && request_mask & STATX_BTIME) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime = MSDOS_I(inode)->i_crtime;
 	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
--- a/fs/fat/inode.c~fat-report-creation-time-in-statx
+++ a/fs/fat/inode.c
@@ -568,9 +568,11 @@ int fat_fill_inode(struct inode *inode,
 
 	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
 	inode->i_ctime = inode->i_mtime;
-	if (sbi->options.isvfat)
+	if (sbi->options.isvfat) {
 		fat_time_fat2unix(sbi, &inode->i_atime, 0, de->adate, 0);
-	else
+		fat_time_fat2unix(sbi, &MSDOS_I(inode)->i_crtime, de->ctime,
+				  de->cdate, de->ctime_cs);
+	} else
 		inode->i_atime = fat_truncate_atime(sbi, &inode->i_mtime);
 
 	return 0;
@@ -756,6 +758,8 @@ static struct inode *fat_alloc_inode(str
 	ei->i_logstart = 0;
 	ei->i_attrs = 0;
 	ei->i_pos = 0;
+	ei->i_crtime.tv_sec = 0;
+	ei->i_crtime.tv_nsec = 0;
 
 	return &ei->vfs_inode;
 }
@@ -889,6 +893,8 @@ retry:
 		__le16 atime;
 		fat_time_unix2fat(sbi, &inode->i_atime, &atime,
 				  &raw_entry->adate, NULL);
+		fat_time_unix2fat(sbi, &MSDOS_I(inode)->i_crtime, &raw_entry->ctime,
+				  &raw_entry->cdate, &raw_entry->ctime_cs);
 	}
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
_

Patches currently in -mm which might be from cccheng@synology.com are


