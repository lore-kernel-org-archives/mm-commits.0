From: akpm@linux-foundation.org
Subject: - fat-add-printf-attribute-to-fat_fs_panic.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:41 -0800
Message-ID: <200811102033.mAAKXfSK024644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbYKJUhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:37:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Add printf attribute to fat_fs_panic()
has been removed from the -mm tree.  Its filename was
     fat-add-printf-attribute-to-fat_fs_panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Add printf attribute to fat_fs_panic()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fat/fat.h~fat-add-printf-attribute-to-fat_fs_panic fs/fat/fat.h
--- a/fs/fat/fat.h~fat-add-printf-attribute-to-fat_fs_panic
+++ a/fs/fat/fat.h
@@ -308,7 +308,8 @@ extern int fat_fill_super(struct super_b
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
+extern void fat_fs_panic(struct super_block *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3))) __cold;
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

