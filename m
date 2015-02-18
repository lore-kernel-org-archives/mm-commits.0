From: akpm@linux-foundation.org
Subject: [merged] fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:42:56 -0800
Message-ID: <54e4eb40.Qot6MOAa5L5FMIuL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbBRTm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fred.chou.nd@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fat: use MSDOS_SB macro to get msdos_sb_info
has been removed from the -mm tree.  Its filename was
     fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fred Chou <fred.chou.nd@gmail.com>
Subject: fs: fat: use MSDOS_SB macro to get msdos_sb_info

Use the MSDOS_SB macro to get msdos_sb_info, instead of coding it
directly.

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-use-msdos_sb-macro-to-get-msdos_sb_info
+++ a/fs/fat/inode.c
@@ -580,7 +580,7 @@ static void fat_set_state(struct super_b
 {
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
-	struct msdos_sb_info *sbi = sb->s_fs_info;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
 	/* do not change any thing if mounted read only */
 	if ((sb->s_flags & MS_RDONLY) && !force)
_

Patches currently in -mm which might be from fred.chou.nd@gmail.com are

origin.patch

