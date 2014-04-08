From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-remove-unused-ufs_super_block_first-pointer.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:53:37 -0700
Message-ID: <53446fe1.9eKu6ww+RXVx1Fab%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaDHVxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, cengelma@gmx.at

Subject: [merged] fs-ufs-remove-unused-ufs_super_block_first-pointer.patch removed from -mm tree
To: cengelma@gmx.at,dushistov@mail.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:53:37 -0700


The patch titled
     Subject: fs/ufs: remove unused ufs_super_block_first pointer
has been removed from the -mm tree.  Its filename was
     fs-ufs-remove-unused-ufs_super_block_first-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Engelmayer <cengelma@gmx.at>
Subject: fs/ufs: remove unused ufs_super_block_first pointer

Remove occurences of unused pointers to struct ufs_super_block_first that
w= ere acquired via ubh_get_usb_first().

Detected by Coverity: CID 139929 - CID 139936, CID 139940.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   12 ------------
 fs/ufs/ialloc.c |    4 ----
 fs/ufs/super.c  |    2 --
 3 files changed, 18 deletions(-)

diff -puN fs/ufs/balloc.c~fs-ufs-remove-unused-ufs_super_block_first-pointer fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~fs-ufs-remove-unused-ufs_super_block_first-pointer
+++ a/fs/ufs/balloc.c
@@ -38,7 +38,6 @@ void ufs_free_fragments(struct inode *in
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned cgno, bit, end_bit, bbase, blkmap, i;
@@ -46,7 +45,6 @@ void ufs_free_fragments(struct inode *in
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
 	
 	UFSD("ENTER, fragment %llu, count %u\n",
 	     (unsigned long long)fragment, count);
@@ -135,7 +133,6 @@ void ufs_free_blocks(struct inode *inode
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned overflow, cgno, bit, end_bit, i;
@@ -143,7 +140,6 @@ void ufs_free_blocks(struct inode *inode
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
 
 	UFSD("ENTER, fragment %llu, count %u\n",
 	     (unsigned long long)fragment, count);
@@ -499,7 +495,6 @@ static u64 ufs_add_fragments(struct inod
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned cgno, fragno, fragoff, count, fragsize, i;
@@ -509,7 +504,6 @@ static u64 ufs_add_fragments(struct inod
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first (uspi);
 	count = newcount - oldcount;
 	
 	cgno = ufs_dtog(uspi, fragment);
@@ -577,7 +571,6 @@ static u64 ufs_alloc_fragments(struct in
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned oldcg, i, j, k, allocsize;
@@ -588,7 +581,6 @@ static u64 ufs_alloc_fragments(struct in
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
 	oldcg = cgno;
 	
 	/*
@@ -690,7 +682,6 @@ static u64 ufs_alloccg_block(struct inod
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cylinder_group * ucg;
 	u64 result, blkno;
 
@@ -698,7 +689,6 @@ static u64 ufs_alloccg_block(struct inod
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
 
 	if (goal == 0) {
@@ -794,7 +784,6 @@ static u64 ufs_bitmap_search(struct supe
 		0x0, 0x2, 0x6, 0xe, 0x1e, 0x3e, 0x7e, 0xfe, 0x1fe
 	};
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
-	struct ufs_super_block_first *usb1;
 	struct ufs_cylinder_group *ucg;
 	unsigned start, length, loc;
 	unsigned pos, want, blockmap, mask, end;
@@ -803,7 +792,6 @@ static u64 ufs_bitmap_search(struct supe
 	UFSD("ENTER, cg %u, goal %llu, count %u\n", ucpi->c_cgx,
 	     (unsigned long long)goal, count);
 
-	usb1 = ubh_get_usb_first (uspi);
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
 
 	if (goal)
diff -puN fs/ufs/ialloc.c~fs-ufs-remove-unused-ufs_super_block_first-pointer fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~fs-ufs-remove-unused-ufs_super_block_first-pointer
+++ a/fs/ufs/ialloc.c
@@ -57,7 +57,6 @@ void ufs_free_inode (struct inode * inod
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	int is_directory;
@@ -67,7 +66,6 @@ void ufs_free_inode (struct inode * inod
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
 	
 	ino = inode->i_ino;
 
@@ -175,7 +173,6 @@ struct inode *ufs_new_inode(struct inode
 	struct super_block * sb;
 	struct ufs_sb_info * sbi;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	struct inode * inode;
@@ -195,7 +192,6 @@ struct inode *ufs_new_inode(struct inode
 	ufsi = UFS_I(inode);
 	sbi = UFS_SB(sb);
 	uspi = sbi->s_uspi;
-	usb1 = ubh_get_usb_first(uspi);
 
 	mutex_lock(&sbi->s_lock);
 
diff -puN fs/ufs/super.c~fs-ufs-remove-unused-ufs_super_block_first-pointer fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-remove-unused-ufs_super_block_first-pointer
+++ a/fs/ufs/super.c
@@ -1390,14 +1390,12 @@ static int ufs_statfs(struct dentry *den
 	struct super_block *sb = dentry->d_sb;
 	struct ufs_sb_private_info *uspi= UFS_SB(sb)->s_uspi;
 	unsigned  flags = UFS_SB(sb)->s_flags;
-	struct ufs_super_block_first *usb1;
 	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
 	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	lock_ufs(sb);
 
-	usb1 = ubh_get_usb_first(uspi);
 	usb2 = ubh_get_usb_second(uspi);
 	usb3 = ubh_get_usb_third(uspi);
 	
_

Patches currently in -mm which might be from cengelma@gmx.at are

origin.patch

