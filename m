From: akpm@linux-foundation.org
Subject: [merged] fat-move-fat_i_pos_read-to-fath.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:43 -0700
Message-ID: <20130430190143.7FC5A5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40171 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3D3TBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:44 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87372ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: move fat_i_pos_read to fat.h
has been removed from the -mm tree.  Its filename was
     fat-move-fat_i_pos_read-to-fath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: move fat_i_pos_read to fat.h

Move fat_i_pos_read to fat.h so that it can be called from nfs.c in the
subsequent patches to encode the file handle.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |   14 ++++++++++++++
 fs/fat/inode.c |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/fat/fat.h~fat-move-fat_i_pos_read-to-fath fs/fat/fat.h
--- a/fs/fat/fat.h~fat-move-fat_i_pos_read-to-fath
+++ a/fs/fat/fat.h
@@ -218,6 +218,20 @@ static inline sector_t fat_clus_to_blknr
 		+ sbi->data_start;
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
@@ -655,20 +655,6 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
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
