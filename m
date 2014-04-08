From: akpm@linux-foundation.org
Subject: [merged]
 fs-ufs-remove-unused-ufs_super_block_second-pointer.patch removed from -mm
 tree
Date: Tue, 08 Apr 2014 14:54:09 -0700
Message-ID: <53447001.GQm/isakD/tB64yJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbaDHVyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, cengelma@gmx.at

Subject: [merged] fs-ufs-remove-unused-ufs_super_block_second-pointer.patch removed from -mm tree
To: cengelma@gmx.at,dushistov@mail.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:54:09 -0700


The patch titled
     Subject: fs/ufs: remove unused ufs_super_block_second pointer
has been removed from the -mm tree.  Its filename was
     fs-ufs-remove-unused-ufs_super_block_second-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Engelmayer <cengelma@gmx.at>
Subject: fs/ufs: remove unused ufs_super_block_second pointer

Pointer 'usb2' to struct ufs_super_block_second acquired via
ubh_get_usb_second() is never used in function ufs_statfs().  Thus remove
it.

Detected by Coverity: CID 139940.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-remove-unused-ufs_super_block_second-pointer fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-remove-unused-ufs_super_block_second-pointer
+++ a/fs/ufs/super.c
@@ -1390,13 +1390,11 @@ static int ufs_statfs(struct dentry *den
 	struct super_block *sb = dentry->d_sb;
 	struct ufs_sb_private_info *uspi= UFS_SB(sb)->s_uspi;
 	unsigned  flags = UFS_SB(sb)->s_flags;
-	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
 	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	lock_ufs(sb);
 
-	usb2 = ubh_get_usb_second(uspi);
 	usb3 = ubh_get_usb_third(uspi);
 	
 	if ((flags & UFS_TYPE_MASK) == UFS_TYPE_UFS2) {
_

Patches currently in -mm which might be from cengelma@gmx.at are

origin.patch

