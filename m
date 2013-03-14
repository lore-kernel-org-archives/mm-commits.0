From: akpm@linux-foundation.org
Subject: + fat-move-fat_i_pos_read-to-fath.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:36:36 -0700
Message-ID: <20130314213636.CF2555A4213@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42463 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3CNVgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:36:38 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so98688vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:36:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: move fat_i_pos_read to fat.h
has been added to the -mm tree.  Its filename is
     fat-move-fat_i_pos_read-to-fath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
