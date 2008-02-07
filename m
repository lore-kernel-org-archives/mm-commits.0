From: akpm@linux-foundation.org
Subject: - kill-an-unused-ptr_err-in-bdev_cache_init.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:35 -0800
Message-ID: <200802070023.m170NGBW006506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764473AbYBGAoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiyong@fc-cn.com, mm-commits@vger.kernel.org


The patch titled
     kill an unused PTR_ERR in bdev_cache_init()
has been removed from the -mm tree.  Its filename was
     kill-an-unused-ptr_err-in-bdev_cache_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill an unused PTR_ERR in bdev_cache_init()
From: Qi Yong <qiyong@fc-cn.com>

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/block_dev.c~kill-an-unused-ptr_err-in-bdev_cache_init fs/block_dev.c
--- a/fs/block_dev.c~kill-an-unused-ptr_err-in-bdev_cache_init
+++ a/fs/block_dev.c
@@ -534,7 +534,6 @@ void __init bdev_cache_init(void)
 	if (err)
 		panic("Cannot register bdev pseudo-fs");
 	bd_mnt = kern_mount(&bd_type);
-	err = PTR_ERR(bd_mnt);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */
_

Patches currently in -mm which might be from qiyong@fc-cn.com are

origin.patch
