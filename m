From: akpm@linux-foundation.org
Subject: + kill-an-unused-ptr_err-in-bdev_cache_init.patch added to -mm tree
Date: Mon, 03 Dec 2007 13:19:41 -0800
Message-ID: <200712032119.lB3LJfQQ018193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbXLCVTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 16:19:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiyong@fc-cn.com


The patch titled
     kill an unused PTR_ERR in bdev_cache_init()
has been added to the -mm tree.  Its filename is
     kill-an-unused-ptr_err-in-bdev_cache_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kill-an-unused-ptr_err-in-bdev_cache_init.patch
