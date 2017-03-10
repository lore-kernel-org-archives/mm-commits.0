From: akpm@linux-foundation.org
Subject: [merged]
 fat-fix-using-uninitialized-fields-of-fat_inode-fsinfo_inode.patch removed
 from -mm tree
Date: Fri, 10 Mar 2017 13:43:39 -0800
Message-ID: <58c31e0b.V2yEK09hu9DeHzEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932482AbdCJVnk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:43:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, moreno.bartalucci@tecnorama.it, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix using uninitialized fields of fat_inode/fsinfo_inode
has been removed from the -mm tree.  Its filename was
     fat-fix-using-uninitialized-fields-of-fat_inode-fsinfo_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix using uninitialized fields of fat_inode/fsinfo_inode

Recently fallocate patch was merged and it uses
MSDOS_I(inode)->mmu_private at fat_evict_inode().  However,
fat_inode/fsinfo_inode that was introduced in past didn't initialize
MSDOS_I(inode) properly.

With those combinations, it became the cause of accessing random entry
in FAT area.

Link: http://lkml.kernel.org/r/87pohrj4i8.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: Moreno Bartalucci <moreno.bartalucci@tecnorama.it>
Tested-by: Moreno Bartalucci <moreno.bartalucci@tecnorama.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-fix-using-uninitialized-fields-of-fat_inode-fsinfo_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-using-uninitialized-fields-of-fat_inode-fsinfo_inode
+++ a/fs/fat/inode.c
@@ -1359,6 +1359,16 @@ out:
 	return 0;
 }
 
+static void fat_dummy_inode_init(struct inode *inode)
+{
+	/* Initialize this dummy inode to work as no-op. */
+	MSDOS_I(inode)->mmu_private = 0;
+	MSDOS_I(inode)->i_start = 0;
+	MSDOS_I(inode)->i_logstart = 0;
+	MSDOS_I(inode)->i_attrs = 0;
+	MSDOS_I(inode)->i_pos = 0;
+}
+
 static int fat_read_root(struct inode *inode)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
@@ -1803,12 +1813,13 @@ int fat_fill_super(struct super_block *s
 	fat_inode = new_inode(sb);
 	if (!fat_inode)
 		goto out_fail;
-	MSDOS_I(fat_inode)->i_pos = 0;
+	fat_dummy_inode_init(fat_inode);
 	sbi->fat_inode = fat_inode;
 
 	fsinfo_inode = new_inode(sb);
 	if (!fsinfo_inode)
 		goto out_fail;
+	fat_dummy_inode_init(fsinfo_inode);
 	fsinfo_inode->i_ino = MSDOS_FSINFO_INO;
 	sbi->fsinfo_inode = fsinfo_inode;
 	insert_inode_hash(fsinfo_inode);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


