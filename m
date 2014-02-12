From: akpm@linux-foundation.org
Subject: + fs-ufs-remove-unused-ufs_super_block_second-pointer.patch added to -mm tree
Date: Wed, 12 Feb 2014 14:23:15 -0800
Message-ID: <52fbf453.WMLeqsVFx2e0gEcs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaBLWXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 17:23:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, cengelma@gmx.at

Subject: + fs-ufs-remove-unused-ufs_super_block_second-pointer.patch added to -mm tree
To: cengelma@gmx.at,dushistov@mail.ru
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 14:23:15 -0800


The patch titled
     Subject: fs/ufs: remove unused ufs_super_block_second pointer
has been added to the -mm tree.  Its filename is
     fs-ufs-remove-unused-ufs_super_block_second-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-remove-unused-ufs_super_block_second-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-remove-unused-ufs_super_block_second-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1389,13 +1389,11 @@ static int ufs_statfs(struct dentry *den
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
fs-ufs-remove-unused-ufs_super_block_first-pointer.patch
fs-ufs-remove-unused-ufs_super_block_second-pointer.patch
fs-ufs-remove-unused-ufs_super_block_third-pointer.patch
linux-next.patch

