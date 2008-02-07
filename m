From: akpm@linux-foundation.org
Subject: - fat-fix-printk-format-strings.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:34 -0800
Message-ID: <200802070021.m170LFZM006304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935060AbYBGAon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     FAT: Fix printk format strings
has been removed from the -mm tree.  Its filename was
     fat-fix-printk-format-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FAT: Fix printk format strings
From: Vegard Nossum <vegard.nossum@gmail.com>

This makes sure printk format strings contain no more than a single line.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
[the message was tweaked.]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    6 ++----
 fs/fat/misc.c  |    5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat-fix-printk-format-strings fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-printk-format-strings
+++ a/fs/fat/inode.c
@@ -1295,10 +1295,8 @@ int fat_fill_super(struct super_block *s
 
 		fsinfo = (struct fat_boot_fsinfo *)fsinfo_bh->b_data;
 		if (!IS_FSINFO(fsinfo)) {
-			printk(KERN_WARNING
-			       "FAT: Did not find valid FSINFO signature.\n"
-			       "     Found signature1 0x%08x signature2 0x%08x"
-			       " (sector = %lu)\n",
+			printk(KERN_WARNING "FAT: Invalid FSINFO signature: "
+			       "0x%08x, 0x%08x (sector = %lu)\n",
 			       le32_to_cpu(fsinfo->signature1),
 			       le32_to_cpu(fsinfo->signature2),
 			       sbi->fsinfo_sector);
diff -puN fs/fat/misc.c~fat-fix-printk-format-strings fs/fat/misc.c
--- a/fs/fat/misc.c~fat-fix-printk-format-strings
+++ a/fs/fat/misc.c
@@ -55,9 +55,8 @@ void fat_clusters_flush(struct super_blo
 	fsinfo = (struct fat_boot_fsinfo *)bh->b_data;
 	/* Sanity check */
 	if (!IS_FSINFO(fsinfo)) {
-		printk(KERN_ERR "FAT: Did not find valid FSINFO signature.\n"
-		       "     Found signature1 0x%08x signature2 0x%08x"
-		       " (sector = %lu)\n",
+		printk(KERN_ERR "FAT: Invalid FSINFO signature: "
+		       "0x%08x, 0x%08x (sector = %lu)\n",
 		       le32_to_cpu(fsinfo->signature1),
 		       le32_to_cpu(fsinfo->signature2),
 		       sbi->fsinfo_sector);
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
