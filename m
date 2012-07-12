From: akpm@linux-foundation.org
Subject: [merged] fat-fix-non-atomic-nfs-i_pos-read.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:21 -0700
Message-ID: <20120712193722.1282E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47499 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233Ab2GLThY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:24 -0400
Received: by wgbdt11 with SMTP id dt11so144883wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix non-atomic NFS i_pos read
has been removed from the -mm tree.  Its filename was
     fat-fix-non-atomic-nfs-i_pos-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: fat: fix non-atomic NFS i_pos read

fat_encode_fh() can fetch an invalid i_pos value on systems where 64-bit
accesses are not atomic.  Make it use the same accessor as the rest of the
FAT code.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat-fix-non-atomic-nfs-i_pos-read fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-non-atomic-nfs-i_pos-read
+++ a/fs/fat/inode.c
@@ -738,22 +738,21 @@ static int
 fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
 {
 	int len = *lenp;
-	u32 ipos_h, ipos_m, ipos_l;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	loff_t i_pos;
 
 	if (len < 5) {
 		*lenp = 5;
 		return 255; /* no room */
 	}
 
-	ipos_h = MSDOS_I(inode)->i_pos >> 8;
-	ipos_m = (MSDOS_I(inode)->i_pos & 0xf0) << 24;
-	ipos_l = (MSDOS_I(inode)->i_pos & 0x0f) << 28;
+	i_pos = fat_i_pos_read(sbi, inode);
 	*lenp = 5;
 	fh[0] = inode->i_ino;
 	fh[1] = inode->i_generation;
-	fh[2] = ipos_h;
-	fh[3] = ipos_m | MSDOS_I(inode)->i_logstart;
-	fh[4] = ipos_l;
+	fh[2] = i_pos >> 8;
+	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
+	fh[4] = (i_pos & 0x0f) << 28;
 	if (parent)
 		fh[4] |= MSDOS_I(parent)->i_logstart;
 	return 3;
_

Patches currently in -mm which might be from steve@digidescorp.com are

origin.patch
fat-accessors-for-msdos_dir_entry-start-fields.patch
fat-refactor-shortname-parsing.patch
fat-exportfs-move-nfs-support-code.patch
fat-exportfs-fix-dentry-reconnection.patch

