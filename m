From: akpm@linux-foundation.org
Subject: [merged] fat-fix-possible-overflow-for-fat_clusters.patch removed from -mm tree
Date: Tue, 28 May 2013 12:36:37 -0700
Message-ID: <51a50745.QCecdZb8T9kigff6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3E1Tgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, strasbur@chkw386.ch.pwr.wroc.pl, stable@vger.kernel.org, hirofumi@mail.parknet.co.jp

Subject: [merged] fat-fix-possible-overflow-for-fat_clusters.patch removed from -mm tree
To: hirofumi@mail.parknet.co.jp,stable@vger.kernel.org,strasbur@chkw386.ch.pwr.wroc.pl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:37 -0700


The patch titled
     Subject: fat: fix possible overflow for fat_clusters
has been removed from the -mm tree.  Its filename was
     fat-fix-possible-overflow-for-fat_clusters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fs-fat-use-fat_msg-to-replace-printk-in-__fat_fs_error.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

