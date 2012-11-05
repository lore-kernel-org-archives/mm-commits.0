From: akpm@linux-foundation.org
Subject: [nacked] fat-move-fat_i_pos_read-to-fath.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:07:15 -0800
Message-ID: <20121105200716.277465C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:49682 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:07:18 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so400973lah.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:07:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: move fat_i_pos_read to fat.h
has been removed from the -mm tree.  Its filename was
     fat-move-fat_i_pos_read-to-fath.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: move fat_i_pos_read to fat.h

Originally, fat_i_pos_read() was a static inline function in inode.c.  The
static keyword was removed so that it could be accessed from other files. 
However it is better to make it a static inline function in fat.h as
suggested by Ogawa.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |   14 ++++++++++++++
 fs/fat/inode.c |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/fat/fat.h~fat-move-fat_i_pos_read-to-fath fs/fat/fat.h
--- a/fs/fat/fat.h~fat-move-fat_i_pos_read-to-fath
+++ a/fs/fat/fat.h
@@ -222,6 +222,20 @@ static inline void fat_get_blknr_offset(
 	*offset = i_pos & (sbi->dir_per_block - 1);
 }
 
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+					struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 static inline void fat16_towchar(wchar_t *dst, const __u8 *src, size_t len)
 {
 #ifdef __BIG_ENDIAN
diff -puN fs/fat/inode.c~fat-move-fat_i_pos_read-to-fath fs/fat/inode.c
--- a/fs/fat/inode.c~fat-move-fat_i_pos_read-to-fath
+++ a/fs/fat/inode.c
@@ -595,20 +595,6 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
-loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
-				    struct inode *inode)
-{
-	loff_t i_pos;
-#if BITS_PER_LONG == 32
-	spin_lock(&sbi->inode_hash_lock);
-#endif
-	i_pos = MSDOS_I(inode)->i_pos;
-#if BITS_PER_LONG == 32
-	spin_unlock(&sbi->inode_hash_lock);
-#endif
-	return i_pos;
-}
