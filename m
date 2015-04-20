From: akpm@linux-foundation.org
Subject: [merged] fs-fat-remove-unnecessary-defintion.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:19:22 -0700
Message-ID: <5535513a.rL4WZCKzd4gUQ433%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbbDTTNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: remove unnecessary defintion
has been removed from the -mm tree.  Its filename was
     fs-fat-remove-unnecessary-defintion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: fs/fat: remove unnecessary defintion

'*sb' never used, so let's remote it and pass inode->i_sb directly to the
MSDOS_SB.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fs-fat-remove-unnecessary-defintion fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-remove-unnecessary-defintion
+++ a/fs/fat/inode.c
@@ -1279,8 +1279,7 @@ out:
 
 static int fat_read_root(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int error;
 
 	MSDOS_I(inode)->i_pos = MSDOS_ROOT_INO;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

origin.patch
linux-next.patch

