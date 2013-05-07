From: akpm@linux-foundation.org
Subject: + fat-fix-possible-overflow-for-fat_clusters.patch added to -mm tree
Date: Tue, 07 May 2013 13:29:39 -0700
Message-ID: <20130507202939.703665A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:53122 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab3EGU3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 16:29:40 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so106132qec.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 13:29:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, stable@vger.kernel.org, strasbur@chkw386.ch.pwr.wroc.pl


The patch titled
     Subject: fat: fix possible overflow for fat_clusters
has been added to the -mm tree.  Its filename is
     fat-fix-possible-overflow-for-fat_clusters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix possible overflow for fat_clusters

Intermediate value of fat_clusters can be overflowed on 32bits arch.

Reported-by: Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-fix-possible-overflow-for-fat_clusters fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-possible-overflow-for-fat_clusters
+++ a/fs/fat/inode.c
@@ -1229,6 +1229,19 @@ static int fat_read_root(struct inode *i
 	return 0;
 }
 
+static unsigned long calc_fat_clusters(struct super_block *sb)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	/* Divide first to avoid overflow */
+	if (sbi->fat_bits != 12) {
+		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
+		return ent_per_sec * sbi->fat_length;
+	}
+
+	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+}
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1434,7 +1447,7 @@ int fat_fill_super(struct super_block *s
 		sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
 
 	/* check that FAT table does not overflow */
-	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	fat_clusters = calc_fat_clusters(sb);
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fat-fix-possible-overflow-for-fat_clusters.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

